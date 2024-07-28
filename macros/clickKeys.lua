local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

local function pressAndHold(key, hold)
  key(key, hold)
  asyncSleepClock(hold)
end


---@alias Key string | { key: string, hold: number }
---holds given keys for <hold> amount of time
---@param self AreaMacro
---@param args { keys:Key[], delay:number?, interval:number?, hold:number}
local function clickKeys(self, args)
  local keys = args.keys
  local time = args.delay
  local interval = args.interval
  local hold = args.hold or 100
  for _, k in pairs(keys) do
    if type(k) == "table" then
      pressAndHold(k.key, k.hold)
    else
      pressAndHold(k, hold)
    end

    if time then
      asyncSleepClock(time)
    end
  end
  if interval then
    asyncSleepClock(interval)
  end
end
return { cb = clickKeys, options = { saveState = true } }
