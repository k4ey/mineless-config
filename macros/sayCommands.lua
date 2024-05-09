local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

---says given commands to chat with <time> delay
---@param self AreaMacro
---@param args { commands:string[], delay:number?, interval:number? }
local function sayCommands(self, args)
	local commands = args.commands
	local time = args.delay
	local interval = args.interval
	for _, command in pairs(commands) do
		say(command)
		if time then
			asyncSleepClock(time)
		end
	end
	if interval then
		asyncSleepClock(interval)
	end
end
return { cb = sayCommands, options = { saveState = true } }
