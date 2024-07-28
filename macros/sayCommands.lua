local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

---says given commands to chat with <time> delay
---@param self AreaMacro
---@param args { commands:string[], delay:number?, interval:number?, entropy: number? }
local function sayCommands(self, args)
  local commands = args.commands
  local time = args.delay
  local interval = args.interval
  local entropy = args.entropy or 0
  for _, command in pairs(commands) do
    say(command)
    if time then
      asyncSleepClock(time + math.random(-entropy, entropy))
    end
  end
  if interval then
    asyncSleepClock(interval + math.random(-entropy, entropy))
  end
end
return { cb = sayCommands, options = { saveState = true } }
