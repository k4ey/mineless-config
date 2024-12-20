local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
local function wobble(self, args)
  local time = args.time or 1000
  local delay = args.delay or 1000
  local entropyTime = args.entropyTime or 1000
  local entropyDelay = args.entropyDelay or 1000

  while true do
    local leftTime = time + math.random(-entropyTime, entropyTime)
    left(leftTime)
    asyncSleepClock(leftTime)
    local rightTime = time + math.random(-entropyTime, entropyTime)
    right(rightTime)
    asyncSleepClock(rightTime)
    if delay > 0 then
      local delayDelay = delay + math.random(-entropyDelay, entropyDelay)
      asyncSleepClock(delayDelay)
    end
  end
end


return { cb = wobble, options = { saveState = true } }
