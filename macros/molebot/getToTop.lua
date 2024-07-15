---@type relativeBlocks
local rb = _G.libs.relativeBlocks
rb.toggleVisibility(true)
---@diagnostic disable-next-line
getBlockName = getBlockName

local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
local getPlayerBlockPos = getPlayerBlockPos
local sneak = sneak

---@param x number
---@param y number
---@param z number
---@return boolean
local function inside(x, y, z, minX, minY, minZ, maxX, maxY, maxZ)
  return x >= minX and x <= maxX and y >= minY and y <= maxY and z >= minZ and z <= maxZ
end

---@param r1 number
---@param r2 number
---@param area Area
---@return boolean | { [1]: number, [2]: number, [3]: number }
local function getBlockInRadius(r1, r2, area, x, y, z)
  local minX = area.minX
  local maxX = area.maxX
  local minY = area.minY
  local maxY = area.maxY
  local minZ = area.minZ
  local maxZ = area.maxZ

  local name
  for i = r1, r2 do
    for j = r1, r2, 1 do
      for k = 0, 10, 1 do
        local bx, by, bz = x + i, y + k, z + j
        if inside(bx, by, bz, minX, minY, minZ, maxX, maxY, maxZ) then
          name = getBlockName(bx, by, bz)
          if name ~= "" and name ~= "Bedrock" and name ~= "Air" then
            rb.sShow({
              position = { bx, by, bz },
              name = name,
              xray = true,
              color = "red",
            })
            return { bx, by, bz }
          end
        end
      end
    end
  end
  return false
end

local function getPlayerStandingBlockPos()
  local x, y, z = getPlayerBlockPos()
  return x, y - 1, z
end

local function isAboveAndNotAir(px, py, pz, bx, by, bz)
  return py >= by and getBlockName(px, py, pz) ~= "Air"
end

local function isBelowAndAir(px, py, pz, bx, by, bz)
  return py < by and getBlockName(bx, by, bz) == "Air"
end

local function determineLastBlock(px, py, pz, bx, by, bz)
  if isAboveAndNotAir(px, py, pz, bx, by, bz) or isBelowAndAir(px, py, pz, bx, by, bz) then
    return px, py, pz
  end
  return bx, by, bz
end

local function hasFallenOfABlock(px, py, pz, bx, by, bz)
  return py < by
end

local function stopFlying()
  if playerDetails.isOnGround() then return end
  key("SPACE", -1)
  waitTick()
  key("SPACE", 0)
  waitTick()
  key("SPACE", -1)
  waitTick()
  key("SPACE", 0)
end


---comment
---@param self cbOptions
---@param args any
local function getToTop(self, args)
  local bx, by, bz = getPlayerStandingBlockPos()
  while true do
    local x, y, z = getPlayerStandingBlockPos()

    bx, by, bz = determineLastBlock(x, y, z, bx, by, bz)
    if hasFallenOfABlock(x, y, z, bx, by, bz) then
      while not playerDetails.isOnGround() do
        coroutine.yield()
      end
      -- _G.MOLEBOT_G.pathfinderGoal = { bx, by, bz }
      asyncSleepClock(100)
      libs.pathfinder(libs.movements, { bx, by + 2, bz })
      while _G.MOLEBOT_G.pathfinderGoal do
        coroutine.yield()
      end
      asyncSleepClock(100)
      stopFlying()
    end

    asyncSleepClock(0)
  end
end

return { cb = getToTop, options = { saveState = false } }
