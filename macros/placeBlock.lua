local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function placeBlock()
	use(0)
	asyncSleepClock(200)
end

return { cb = placeBlock, options = { saveState = false } }
