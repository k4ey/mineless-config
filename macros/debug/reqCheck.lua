local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function onReset() end

local function reqCheck(...)
	log({ ... })
end
return { cb = reqCheck, options = { onReset = onReset } }
