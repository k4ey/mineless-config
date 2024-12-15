local vec3 = _G.libs.vec3
local quat = _G.libs.quat
local rb = _G.libs.relativeBlocks
local looker = _G.libs.looker
local function init()
  local gens = MacroCreator:extensions("gens")
  ---@return vec3
  local function getPlayerPosBlockVec() return vec3(getPlayerBlockPos()) end
  local function map(t, f)
    local r = {}
    local rval, rkey = nil, nil
    for k, v in pairs(t) do
      rval, rkey = f(v)
      rkey = rkey or k
      r[rkey] = rval
    end
    return r
  end

  local color = "red"
  local function show(...)
    local vs = { ... }
    if #vs == 1 then vs = vs[1] end
    for i, v in pairs(vs) do
      v = v + vec3(0, 1, 0)
      rb.sShow({ position = { v:unpack() }, color = color, opacity = 1 })
    end
    return ...
  end
  ---@type fun(x: number, y: number, z: number): string?
  ---@diagnostic disable-next-line
  getBlockName = getBlockName

  ---@param v vec3
  local function getCropScore(v)
    local farmLand = getBlockName(v:unpack())
    local crop = getBlockName((v + vec3(0, 1, 0)):unpack())
    -- local headBlock = getBlockName((v + vec3(0, 2, 0)):unpack())
    if farmLand ~= GensConfig.farmland then return -999 end
    if not GensConfig.crops[crop] then return 0 end
    return crop ~= "Air" and 1 or 0
  end

  local function isCrop(v)
    local score = getCropScore(v)
    return score > 0
  end

  local vup = vec3(0, 1, 0)
  local function isFarmLand(v)
    return getBlockName(v:unpack()) == GensConfig.farmland and GensConfig.crops[getBlockName((v + vup):unpack())]
  end

  ---@class Probed: vec3
  ---@field angle number


  local function getAngleToBlock(v)
    local y1, p1 = looker.getRotationTo(v)
    local angle1 = quat.Euler(0, 0, playerDetails.getYaw())
    local angle2 = quat.Euler(0, 0, y1)
    local angle = angle1:Angle(angle2)
    return angle
  end



  local stepSlow = GensConfig.stepSlow
  local stepQuick = GensConfig.stepQuick
  local function rotateTowards(v, slow, quick)
    local angle = getAngleToBlock(v)
    looker.lockYawTo(v.x, v.z,
      math.min(math.max(playerDetails.getPitch() + math.random(-angle, angle) / 100, 15), GensConfig.pitch),
      slow or stepSlow, quick or stepQuick)
  end


  -- FLOOD FILL FROM PLAYER TO OBTAIN BLOCKS IN RANGE, STORE EDGES IN SET
  local function floodFill(start, isEdge, actionCondition, action, visited)
    ---@type table<string, vec3>
    visited = visited or {}
    ---@type vec3[]
    local queue = {}
    ---@type vec3[]
    local edges = {}
    actionCondition = actionCondition or function() return false end
    action = action or function() end

    ---@param v vec3
    local function visit(v)
      if visited[v:__tostring()] then return end
      if isEdge(v) then
        rb.sShow({ position = { v:unpack() }, color = "blue", opacity = 1 })
        table.insert(edges, v)
        return
      end
      visited[v:__tostring()] = v
      if actionCondition(v) then action(v) end
      -- rb.sShow({ position = { v:unpack() }, color = "red", opacity = 1 })
      table.insert(queue, v)
    end
    visit(start)
    while #queue > 0 do
      ---@type vec3
      local v = table.remove(queue, 1)
      for _, d in ipairs({ vec3(0, 0, 1), vec3(0, 0, -1), vec3(1, 0, 0), vec3(-1, 0, 0) }) do
        local n = v + d
        if not visited[n:__tostring()] then visit(n) end
      end
    end
    return edges, visited
  end

  local forbiddenRange = GensConfig.forbidRange
  local function getRestrictedArea(edges)
    ---restrict blocks closer than 5 to edge
    ---@type table<string, vec3>
    local visited = {}
    -- rb.sShow({ clear = true })
    for _, e in pairs(edges) do
      floodFill(e, function(v)
        local dist = v:distanceSquared(e)
        return (not dist == 0 and not isCrop(v)) or dist > forbiddenRange
      end, function(v)
        return true
      end, function(v)
      end, visited)
    end

    ---@type { string:  boolean }
    local restricted = {}
    for k, v in pairs(visited) do
      restricted[k] = true
      -- rb.sShow({ position = { v:unpack() }, color = "yellow", opacity = 1 })
    end
    return restricted
  end

  local function degToRad(deg) return deg * math.pi / 180 end

  local function getDirectionVector(block)
    local yaw = looker.getRotationTo(block)
    local yawRad = degToRad(yaw)
    local v = vec3(-math.sin(yawRad), 0, math.cos(yawRad))
    return v
  end
  local function getYawDirectionVector(offset)
    local yaw = playerDetails.getYaw()
    local yawRad = degToRad(yaw + offset)
    local v = vec3(-math.sin(yawRad), 0, math.cos(yawRad))
    return v
  end

  local function isSafePath(path, restricted)
    restricted = restricted or {}
    for _, v in pairs(path) do
      if not isFarmLand(v) or restricted[v:__tostring()] then return false end
    end
    return true
  end

  local range = GensConfig.range or 50
  local pPos = getPlayerPosBlockVec()
  local edges, inside = floodFill(pPos, function(v) return not isCrop(v) or v:distance(pPos) > range end)
  local i = 0
  inside = map(inside, function(v)
    i = i + 1
    return v, i
  end)
  local function getGoals(pool, amount, mapper, sorting)
    local len = #pool
    if len == 0 then
      log(
        "&4 NO FARMING AREA DETECTED!!!, GET INTO FARMING ZONE AND TRY LOADING IT AGAIN, IF THIS DOES NOT WORK, GO TO MINELESS-CONFIG-MAIN AND EDIT areas/gens.lua (more instructions there)")
      error("", 0)
    end

    local goals = {}
    for i = 1, amount do
      local goal = pool[math.random(1, len)]
      goals[#goals + 1] = goal
    end
    local mapped = map(goals, function(goal) return mapper(goal) end)

    -- sort based on rotation (smaller better)
    sorting(mapped)
    return mapped
  end
  ---@param pool vec3[]
  ---@param probes number
  local function randomGoalRotations(pool, probes)
    local goals = getGoals(pool, probes, function(goal)
        local rotation = getAngleToBlock(goal)
        return { goal = goal, rotation = rotation }
      end,
      function(goals)
        return table.sort(goals, function(a, b) return math.abs(a.rotation) < math.abs(b.rotation) end)
      end)
    return goals[1].goal
  end
  ---@param pool vec3[]
  ---@param probes number
  local function randomGoalDistance(pool, probes)
    local ppos = getPlayerPosBlockVec()
    local goals = getGoals(pool, probes, function(goal)
        local distance = goal:distanceSquared(ppos)
        return { goal = goal, distance = distance }
      end,
      function(goals)
        table.sort(goals, function(a, b) return math.abs(a.distance) < math.abs(b.distance) end)
      end)
    return goals[math.random(1, 20)].goal
  end

  local restricted = getRestrictedArea(edges)
  local function normalRoutine(goalBlock)
    local ppos = getPlayerPosBlockVec()
    local initialDistance = goalBlock:distance(ppos)
    if initialDistance < 20 then
      log("initial distance")
      return
    end
    while true do
      ppos = getPlayerPosBlockVec()
      local distance = goalBlock:distance(ppos)
      if initialDistance - distance > initialDistance / 2 then
        log("distance matched")
        break
      end
      local path = gens.getPositionsInDirection(ppos,
        getDirectionVector(goalBlock), math.floor(distance))
      if not isSafePath(path, restricted) then
        log("unsafe, normal")
        break
      end
      color = "green"
      rotateTowards(goalBlock)
      show(path)
      coroutine.yield()
      -- rb.sShow({ clear = true })
    end
  end




  local function forbiddenRoutine()
    log("inside forbidden")
    while true do
      local goalBlock = randomGoalDistance(inside, 50)
      log("goal block:", goalBlock)
      local ppos = getPlayerPosBlockVec()
      local path = gens.getPositionsInDirection(ppos,
        getDirectionVector(goalBlock), math.floor(goalBlock:distance(ppos)))

      local initialDistance = goalBlock:distance(ppos)
      while isSafePath(path, {}) do
        log("is safe, in forbidden")
        ppos = getPlayerPosBlockVec()
        path = gens.getPositionsInDirection(ppos,
          getDirectionVector(goalBlock), math.floor(goalBlock:distance(ppos)))
        color = "green"
        show(path)
        local distance = goalBlock:distance(ppos)
        if initialDistance - distance > initialDistance / 2 then
          log("distance matched")
          return
        end
        rotateTowards(goalBlock, 0.15, 0.21)
        rb.sShow({ clear = true })
        if not restricted[ppos:__tostring()] then
          log("exited restricted")
          return
        end
        coroutine.yield()
      end
      coroutine.yield()
    end
  end

  while true do
    rb.sShow({ clear = true })
    local ppos = getPlayerPosBlockVec()
    local goalBlock = randomGoalRotations(inside, 50)
    log("goal:", { goalBlock:unpack() })
    if restricted[ppos:__tostring()] then
      forbiddenRoutine()
    else
      normalRoutine(goalBlock)
    end

    coroutine.yield()
  end
end




local function gensScript(self, args)
  local gens = MacroCreator:extensions("gens")
  ---@diagnostic disable
  ---@type Gens
  if not gens then return end
  ---@diagnostic enable
  _G.GensConfig = _G.GensConfig or {}
  _G.GensConfig.farmland = args.farmland or "Farmland"
  _G.GensConfig.crops = args.crops or {
    ["Wheat Crops"] = true,
    ["Air"] = true
  }
  _G.GensConfig.pitch = args.pitch or 18
  _G.GensConfig.range = args.range or 50
  _G.GensConfig.stepQuick = args.stepQuick or 0.21
  _G.GensConfig.stepSlow = args.stepSlow or 0.1
  _G.GensConfig.forbidRange = args.forbidRange or (30 ^ 2)

  init()
end
return { cb = gensScript, options = { saveState = false } }
