local vec3 = _G.libs.vec3
local rb = _G.libs.relativeBlocks
local looker = _G.libs.looker
-- rb.toggleVisibility(true)
---@return vec3
local function getPlayerPosBlockVec() return vec3(getPlayerBlockPos()) end
local function map(t, f)
  local r = {}
  for k, v in pairs(t) do r[k] = f(v) end
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
_G.GensConfig = _G.GensConfig or {}
_G.GensConfig.farmland = "Farmland"
_G.GensConfig.crops = _G.GensConfig.crops or {
  ["Wheat Crops"] = true,
  ["Air"] = true
}

local crops = GensConfig.crops

---@param v vec3
local function isCrop(v)
  local farmLand = getBlockName(v:unpack())
  local crop = getBlockName((v + vec3(0, 1, 0)):unpack())
  if farmLand ~= GensConfig.farmland then return -999 end
  if not crops[crop] then return -999 end
  return crop ~= "Air" and 1 or 0
end


local directions = {
  0, 2, 5, 10, 15, 20, 45, 90, -5, -10, -15, -20, -45, -90, -180
}

local function asyncLook(y, p, time)
  local yaw, pitch = playerDetails.getYaw(), playerDetails.getPitch()
  looker.asyncLook(yaw, y, pitch, p, time)
end


local function lockYawFor(yaw, ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
    asyncLook(yaw, 17, ms)
  until os.clock() >= future
end


local function gensScript(self, args)
  local lastDirection = 0
  ---@diagnostic disable
  ---@type Gens
  local gens = assert(MacroCreator:extensions("gens"), "gens are currently locked!")
  local countCropsInDirection = gens.countCropsInDirection
  local addWeights = gens.addWeights
  local getPositionsInDirection = gens.getPositionsInDirection
  local getDirectionVector = gens.getDirectionVector
  ---@diagnostic enable

  while true do
    local directionWithAmount = map(directions,
      function(direction)
        return { countCropsInDirection(direction, 50, isCrop) * addWeights(direction, lastDirection),
          direction }
      end)

    table.sort(directionWithAmount, function(a, b) return a[1] > b[1] end)
    local bestDirection = directionWithAmount[1][2]
    local goalBlocks = getPositionsInDirection(getPlayerPosBlockVec(), getDirectionVector(bestDirection), 50)
    local goal = goalBlocks[#goalBlocks]
    local yaw, _ = looker.getRotationTo(goal + vec3(1, 0, 1))
    lastDirection = bestDirection
    lockYawFor(yaw, 300)
    coroutine.yield()

    rb.sShow({ clear = true })
  end
end
return { cb = gensScript, options = { saveState = false } }
