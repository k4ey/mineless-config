local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function deactivate()
	while true do
		coroutine.yield()
	end
end

local function goBlockDown(self, args)
	local _, y, _ = getPlayerPos()
	local y2
	while true do
		_, y2, _ = getPlayerPos()
		sneak(50)
		if math.floor(y + 1.62) ~= math.floor(y2 + 1.62) then
			deactivate()
		end
		asyncSleepClock(50)
	end
end

--- add no reset to once types
return { cb = goBlockDown, options = { saveState = false } }
