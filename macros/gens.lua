local vec3 = _G.libs.vec3
local quat = _G.libs.quat
local rb = _G.libs.relativeBlocks
local looker = _G.libs.looker
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
    rb.sShow({ position = { v:unpack() }, color = color, opacity = 1, path = "default" })
  end
  return ...
end
---@type fun(x: number, y: number, z: number): string?
---@diagnostic disable-next-line
getBlockName = getBlockName


local vup = vec3(0, 1, 0)
local function isFarmLand(v)
  return true
  -- return getBlockName(v:unpack()) == GensConfig.farmland and GensConfig.crops[getBlockName((v + vup):unpack())]
end
local function degToRad(deg) return deg * math.pi / 180 end
---@param starting vec3
---@return vec3[]
local function generateCirclePositions(starting, deltaAngle, offset)
  ---@type table<string, vec3>
  local set = {}
  --- this can also generate angles from yaw to the block in one go, might be good for perf upgrade at some point
  for i = 0, 360, deltaAngle do
    local x = starting.x + math.cos(i) * offset
    local z = starting.z + math.sin(i) * offset
    local v = vec3(x, starting.y, z):ceil()

    set[v:__tostring()] = v
  end
  local positions = {}
  for _, v in pairs(set) do
    positions[#positions + 1] = v
  end
  ---@type vec3[]
  return positions
end

local function getDirectionVector(block)
  local yaw = looker.getRotationTo(block)
  local yawRad = degToRad(yaw)
  local v = vec3(-math.sin(yawRad), 0, math.cos(yawRad))
  return v
end
local function getPath(source, dest)
  local gens = MacroCreator:extensions("gens")
  local path = gens.getPositionsInDirection(source,
    getDirectionVector(dest), math.floor(source:distance(dest)))
  return path
end
local function getPathScore(path, allowedBlocks)
  local score = 0
  for _, v in pairs(path) do
    if not isFarmLand(v) or not allowedBlocks[v:__tostring()] then
      score = score - 3
    end
  end
  return score
end
---@param v vec3
---@return number
local function getAngleToBlock(v)
  local y1, p1 = looker.getRotationTo(v)
  local angle1 = quat.Euler(0, 0, playerDetails.getYaw())
  local angle2 = quat.Euler(0, 0, y1)
  local angle = angle1:Angle(angle2)
  return angle
end
local stepSlow = GensConfig.stepSlow
local function rotateTowards(v, slow, quick)
  local angle = getAngleToBlock(v)
  looker.lockYawTo(v.x, v.z,
    math.min(math.max(playerDetails.getPitch() + math.random(-angle, angle) / 100, 15), GensConfig.pitch), stepSlow,
    stepSlow)
end

---@param circle vec3[]
---@param allowedBlocks table<string, boolean>
local function generateCircleOfScores(circle, allowedBlocks)
  local ppos = getPlayerPosBlockVec()
  local scores = {}
  for _, v in pairs(circle) do
    local path = getPath(ppos, v)
    local score = getPathScore(path, allowedBlocks)
    scores[#scores + 1] = {
      score = score,
      angle = getAngleToBlock(v),
      v = v
    }
  end
  ---@type table<number, {score: number, angle: number, v: vec3}>
  return scores
end

local function floodFill(start, isEdge, action, visited)
  ---@type table<string, vec3>
  visited = visited or {}
  ---@type vec3[]
  local queue = {}
  ---@type vec3[]
  local edges = {}
  action = action or function() end

  ---@param v vec3
  local function visit(v)
    if visited[v:__tostring()] then return end
    if isEdge(v) then
      -- rb.sShow({ position = { v:unpack() }, color = "blue", opacity = 1 })
      table.insert(edges, v)
      return
    end
    visited[v:__tostring()] = v
    action(v)
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

---@return table<string, vec3> Set
local function recordPath()
  local lp = getPlayerPosBlockVec()
  local path = {}
  while true do
    coroutine.yield()
    local p = getPlayerPosBlockVec()
    local pid = p:__tostring()
    if pid ~= lp:__tostring() then
      lp = p
      path[pid] = p
    end
    if playerDetails.isSneaking() then break end
  end
  map(path, function(v)
    rb.sShow({ position = { v:unpack() }, color = "blue", opacity = 1 })
  end)
  return path
end



---@param path table<string, vec3>
local function expandPath(path)
  local blockMap = {}
  local initialPath = {}
  local removeTerrain = {}
  log("expanding possible goals")
  for _, edge in pairs(path) do
    initialPath[edge:__tostring()] = edge
    floodFill(edge, function(v)
        local notFarmland = not isFarmLand(v)
        if notFarmland then
          removeTerrain[v:__tostring()] = v
        end
        local outOfRange = v:distanceSquared(edge) > GensConfig.range
        return notFarmland or outOfRange
      end,
      ---@type vec3
      function(v)
        local id = v:__tostring()
        blockMap[id] = v
      end)
  end
  return blockMap, removeTerrain, initialPath
end
---#NOTICE: changes terrain IN PLACE
---@param terrain table<string, vec3>
---@return nil
local function removeDangerous(terrain, toRemoveTerrain)
  log("removing dangerous terrain")
  for _, edge in pairs(toRemoveTerrain) do
    floodFill(edge, function(v)
        local outOfRange = v:distanceSquared(edge) > GensConfig.range
        return outOfRange
      end,
      ---@type vec3
      function(v)
        local id = v:__tostring()
        terrain[id] = nil
      end)
  end
  return nil
end
_G.GensConfig = {}
local function mainRountine(terrain)
  local raytraceDistance = _G.GensConfig.raytraceDistance
  local raytraceStep = _G.GensConfig.raytraceStep or 1
  while true do
    local ppos = getPlayerPosBlockVec()
    local circle = generateCirclePositions(ppos, raytraceStep, raytraceDistance)
    local scores = generateCircleOfScores(circle, terrain)
    table.sort(scores, function(a, b) return a.score + -a.angle / 10 > b.score + -b.angle / 10 end)
    local bestScore = scores[1]
    local bestPath = getPath(ppos, bestScore.v)
    rb.sShow({ clear = true })
    show(bestPath)
    color = "green"
    rotateTowards(bestPath[#bestPath])
    coroutine.yield()
    if math.random(1, 1000) == 1 then return end
  end
end
---@param v vec3
---@param entropyX number
---@param entropyZ number
---in place!
local function applyEntropy(v, entropyX, entropyZ)
  v:setX(v.x + math.random(-entropyX, entropyX))
  v:setZ(v.z + math.random(-entropyZ, entropyZ))
end

local function createPathCreator(centerVector, entropyX, entropyZ, entropyDistanceMin, entropyDistanceMax)
  local center = centerVector or getPlayerPosBlockVec()
  ---@return vec3[]
  return function()
    local path = generateCirclePositions(
      center + vec3(math.random(-entropyX, entropyX), 0, math.random(-entropyZ, entropyZ)), 5,
      math.random(entropyDistanceMin, entropyDistanceMax))
    for _, v in pairs(path) do
      applyEntropy(v, entropyX, entropyZ)
    end
    return path
  end
end
local function createPath(centerVector, entropyX, entropyZ, entropyDistanceMin, entropyDistanceMax)
  return createPathCreator(centerVector, entropyX, entropyZ, entropyDistanceMin, entropyDistanceMax)
end
local function createTerrain(path)
  local blockMap, removeTerrain, initialPath = expandPath(path)
  removeDangerous(blockMap, removeTerrain) -- in place
  return blockMap, initialPath
end


local function gensScript(self, args)
  local gens = MacroCreator:extensions("gens")
  ---@diagnostic disable
  ---@type Gens
  if not gens then return end
  ---@diagnostic enable
  _G.GensConfig = _G.GensConfig or {}
  local gc = _G.GensConfig
  gc.entropyX = args.entropyX or 5
  gc.entropyZ = args.entropyZ or 5
  gc.entropyDistanceMin = args.entropyDistanceMin or 40
  gc.entropyDistanceMax = args.entropyDistanceMax or 60
  gc.centerVector = args.centerVector and vec3(table.unpack(args.centerVector)) or getPlayerPosBlockVec()

  gc.raytraceDistance = args.raytraceDistance or 20
  gc.raytraceStep = args.raytraceStep or 1
  gc.range = args.range or 125
  gc.pitch = args.pitch or 18
  gc.crops = args.crops or {
    ["Wheat Crops"] = true,
    ["Air"] = true
  }

  local generator = createPath(gc.centerVector, gc.entropyX, gc.entropyZ, gc.entropyDistanceMin,
    gc.entropyDistanceMax)

  while true do
    local derivedPath = generator()
    local terrain, goals = createTerrain(derivedPath)
    local i = 1
    rb.sShow({ clear = true, path = "area" })
    -- map(goals, function(v)
    --   i = i % 1 == 0 and
    --       (rb.sShow({ position = { (v + vec3(0, 5, 0)):unpack() }, color = "green", opacity = 1, path = "area" }) or i + 1) or
    --       i + 1
    -- end)
    mainRountine(terrain)
  end
end
return { cb = gensScript, options = { saveState = false } }
