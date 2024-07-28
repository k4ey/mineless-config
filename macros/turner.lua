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

local function count(t, offset)
  local _, py = getPlayerPos()
  py = py - 1
  local counter = 0
  local flag = false
  for k, v in pairs(t) do
    local x, z = math.floor(v[1] + offset.x), math.floor(v[2] + offset.z)
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

local function plotInMovement(v, offset, limit)
  local p = vec3(getPlayerPos())
  offset = offset or vec3(0, 0, 0)
  local np = blockInTicks(v, limit)
  local vectors = plotLine(p.x, p.z, np.x, np.z)
  return count(vectors, offset)
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

---asynchronously looks towards y1,p1 for <time> 'ms
---@param y0 number yaw source
---@param y1 number yaw dest
---@param p0 number pitch source
---@param p1 number pitch dest
---@param time number time how long it should take.
local function asyncLook(y0, y1, p0, p1, time)
  local start = os.clock()
  local future = start + time / 1000
  local yaw, pitch
  local i
  local angle1 = quat.Euler(0, p0, y0)
  local angle2 = quat.Euler(0, p1, y1)
  repeat
    ---@diagnostic disable-next-line
    i = math.clamp(1 - (future - os.clock()) / (future - start), 0, 1)
    local angle = quat.Lerp(angle1, angle2, i):ToEulerAngles()
    -- so basically this is some weird shit, does not work on negatives but does work on this...
    if angle.y > 90 then
      angle.y = angle.y - 360
    end
    --- this also, we do ZYX or smth like that
    yaw, pitch = angle.z, angle.y
    look(yaw, pitch)

    coroutine.yield()
  until os.clock() >= future
end




-- looker.asyncLook(yaw, (math.ceil(yaw / 45) % 8 + 1) * 45, pitch, 50, 400)

local function noiser(self, args)
  local step = args and args.step or 15
  local leftReach = args and args.leftReach or 30
  local forwardReach = args and args.forwardReach or 5
  local time = args and args.time or 100
  local segments = (360 / step)
  local pitch = args and args.pitch or 50

  local limit = args and args.limit or 20
  local toEdge = plotInMovement(getAccelerationVector(95), nil, leftReach)
  local toForwardEdgeEdge = plotInMovement(getAccelerationVector(0), nil, forwardReach)
  if toEdge < limit then
    local yaw, oldPitch = getRotation()
    local newYaw = ((math.ceil(yaw / step) + 1) % segments) * step
    asyncLook(yaw, newYaw, oldPitch, pitch, 100)
  elseif toForwardEdgeEdge < 2 then
    back(50)
  elseif toForwardEdgeEdge > 10 then
    forward(50)
  end


  coroutine.yield()
  hud3D.clearAll()
end
return { cb = noiser, options = { saveState = false } }
