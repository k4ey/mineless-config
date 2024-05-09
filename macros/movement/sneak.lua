local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function mine()
	while true do
		sneak(250)
		asyncSleepClock(250)
	end
end
return { cb = mine, options = {} }
