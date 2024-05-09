local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function onReset()
	log("goodbye")
end

local function hw(...)
	log("helloworld!")
end
return { cb = hw, options = { onReset = onReset } }
