local vec3 = _G.libs.vec3
local rb = _G.libs.relativeBlocks
local quat = _G.libs.quat
rb.toggleVisibility(true)
local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

local degToRad = function(deg)
  return deg * math.pi / 180
end

local function getAccelerationVector()
  local yaw = playerDetails.getYaw()
  local yawRad = degToRad(yaw + 90)
  local v = vec3(-math.sin(yawRad), 0, math.cos(yawRad))
  return v
end



local function noiser(self, args)
  local v = getAccelerationVector()
  local ppos = vec3(getPlayerPos())
  local nextBlock = ppos + vec3(v.x, 0, v.z)
  local nextBlockName = getBlockName(nextBlock:unpack())
  local nextNextBlockName = getBlockName((nextBlock + vec3(0, 1, 0)):unpack())
  if nextBlockName ~= "Air" then
    if nextNextBlockName == "Air" then
      jump()
    end
    -- rb.sShow({
    --   position = { nextBlock:unpack() },
    --   color = "red",
    --   opacity = 1
    -- })
  else
    -- rb.sShow({
    --   position = { nextBlock:unpack() },
    --   color = "green",
    --   opacity = 1
    -- })
  end
  asyncSleepClock(10)
end
return { cb = noiser, options = { saveState = false } }
