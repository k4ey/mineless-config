local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
local function pathfinder(self, args)
end
return { cb = pathfinder, options = { saveState = true } }
