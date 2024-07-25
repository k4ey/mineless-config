local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

local playerDetails = playerDetails
local function ensureFlying(self, args)
  local _, vel = playerDetails.getVelocity()
  if playerDetails.isOnGround() == false and playerDetails.getFallDist() == 0 and vel == 0 then
    runThread(function()
      key("SPACE", -1)
      waitTick()
      key("SPACE", 0)
      waitTick()
      waitTick()
      key("SPACE", -1)
      waitTick()
      key("SPACE", 0)
    end)
    asyncSleepClock(500)
  end
  asyncSleepClock(100)
end

return { cb = ensureFlying, options = { saveState = false } }
