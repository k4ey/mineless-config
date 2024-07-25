local vec3 = _G.libs.vec3
local rb = _G.libs.relativeBlocks
local quat = _G.libs.quat
local looker = _G.libs.looker

rb.toggleVisibility(true)


local function plot(x, y)
  -- local _, yp, _ = getPlayerPos()
  -- local v = vec3(math.floor(x), yp - 1, math.floor(y))
  -- rb.sShow({
  --   position = { v:unpack() },
  --   color = "blue",
  --   opacity = 1
  --
  -- })
  -- if getBlockName(v:unpack()) == "Air" or getBlockName(v:unpack()) == "Bedrock" then
  --   rb.sShow({
  --     position = { v:unpack() },
  --     color = "red",
  --     opacity = 1,
  --     xray = true
  --   })
  -- end
end

local function plotTable(t)
  for i = 1, #t do
    plot(t[i][1], t[i][2])
  end
end

local function plotLineLow(x0, y0, x1, y1, inverted)
  local dx = x1 - x0
  local dy = y1 - y0
  local yi = inverted and -1 or 1
  if dy < 0 then
    yi = inverted and 1 or -1
    dy = -dy
  end
  local d = (2 * dy) - dx
  local y = inverted and y1 or y0

  local plotted = {}
  if inverted then
    local temp = x0
    x0 = x1
    x1 = temp
  end

  for x = x0, x1, inverted and -1 or 1 do
    plotted[#plotted + 1] = { x, y }
    if d > 0 then
      y = y + yi
      d = d + (2 * (dy - dx))
    else
      d = d + 2 * dy
    end
  end
  return plotted
end



local function plotLineHigh(x0, y0, x1, y1, inverted)
  local dx = x1 - x0
  local dy = y1 - y0
  local xi = inverted and -1 or 1
  if dx < 0 then
    xi = inverted and 1 or -1
    dx = -dx
  end
  local d = (2 * dx) - dy
  local x = inverted and x1 or x0
  if inverted then
    local temp = y0
    y0 = y1
    y1 = temp
  end

  local plotted = {}
  for y = y0, y1, inverted and -1 or 1 do
    plotted[#plotted + 1] = { x, y }
    if d > 0 then
      x = x + xi
      d = d + (2 * (dx - dy))
    else
      d = d + 2 * dx
    end
  end
  return plotted
end

local abs = math.abs

local function plotLine(x0, y0, x1, y1)
  if abs(y1 - y0) < abs(x1 - x0) then
    if x0 > x1 then
      return plotLineLow(x1, y1, x0, y0, true)
    else
      return plotLineLow(x0, y0, x1, y1)
    end
  else
    if y0 > y1 then
      return plotLineHigh(x1, y1, x0, y0, true)
    else
      return plotLineHigh(x0, y0, x1, y1)
    end
  end
end



local function blockInTicks(v, ticks)
  -- local v = vec3(playerDetails.getVelocity())
  local dv = v * ticks
  local p = vec3(getPlayerPos())
  return p + dv
end

local function count(t)
  local _, py = getPlayerPos()
  py = py - 1
  local counter = 0
  local flag = false
  for k, v in pairs(t) do
    local x, z = math.floor(v[1]), math.floor(v[2])
    plot(x, z)
    if getBlockName(x, py, z) == "Air" or getBlockName(x, py, z) == "Bedrock" then
      if not flag then
        flag = true
      else
        return counter - 1
      end
    else
      flag = false
    end
    counter = counter + 1
  end
  return counter
end

local function plotInMovement(v)
  local p = vec3(getPlayerPos())
  local np = blockInTicks(v, 30)
  local vectors = plotLine(p.x, p.z, np.x, np.z)
  return count(vectors)
end



local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

local function getRotation()
  return playerDetails.getYaw(), playerDetails.getPitch()
end
local degToRad = function(deg)
  return deg * math.pi / 180
end

local function getAccelerationVector(offset)
  local yaw, pitch = getRotation()
  local yawRad = degToRad(yaw + offset)
  local v = vec3(-math.sin(yawRad), 0, math.cos(yawRad))
  return v
end

local function getBlockUnderPlayer()
  local x, y, z = getPlayerBlockPos()
  y = y - 1
  return getBlockName(x, y, z)
end



local function noiser(self, args)
  local vright = getAccelerationVector(90)
  local vforward = getAccelerationVector(0)
  hud3D.clearAll()
  local limit = 10
  local rblocks = plotInMovement(vright)
  local fblocks = plotInMovement(vforward)
  if getBlockUnderPlayer() == "Air" then return end
  if rblocks < limit then
    local yaw = getRotation()
    local pitch = 50
    local toEdge = 10 - rblocks
    local time = rblocks * 10
    if getBlockUnderPlayer() == "Air" then return end
    looker.asyncLook(yaw, yaw + toEdge * 2, pitch, pitch, time)
    back(50)
    asyncSleepClock(rblocks)
  end
  if fblocks > 5 then
    back(0)
    forward(50)
  elseif fblocks < 2 then
    forward(0)
    back(50)
  end

  -- right(-1)
  asyncSleepClock(10)
end
return { cb = noiser, options = { saveState = false } }
