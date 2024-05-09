local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local playerDetails = playerDetails
local function ensureFlying(self, args)
	if playerDetails.isOnGround() ~= false then
		key("SPACE", 50)
		asyncSleepClock(250)
		key("SPACE", 50)
		asyncSleepClock(50)
	end
	asyncSleepClock(100)
end

return { cb = ensureFlying, options = { saveState = false } }
