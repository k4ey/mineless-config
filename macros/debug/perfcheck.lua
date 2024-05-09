local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local last = 0
local function onReset() end

local function hw()
	local now = os.clock()
	local diff = now - last
	log(("&4[MOLEBOT] &c| %s"):format(tostring(diff)))
	last = now
end
return { cb = hw, options = { onReset = onReset } }
