local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
local function gotoPosition(_, options)
  local pathfinder = _G.libs.pathfinder
  local movements = _G.libs.movements
  local x, y, z = options.positionCallback()
  -- pathfinder(movements, { x, y + 5, z })
  pathfinder(movements, { x, y - 10, z })
end

local function onReset()
  log("&c RESETTING GOAL")
  _G.MOLEBOT_G.pathfinderGoal = nil
end


return { cb = gotoPosition, options = { saveState = false, onReset = onReset }, }
