local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
--- assumes player is looking at  0, -90
local function goForward(self, args)
	local time = args and args.customTime or 200
	if args and args.sprint then
		if not playerDetails.isSneaking() and not playerDetails.isSprinting() then
			sprint(true)
		end
	end
	forward(time)
	asyncSleepClock(200)
end

--- add no reset to once types
return { cb = goForward, options = { saveState = true } }
