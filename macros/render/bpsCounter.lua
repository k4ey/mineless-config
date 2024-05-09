local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local lastMinedBlockCount = 0
MOLEBOT_G = MOLEBOT_G or {}
MOLEBOT_G.minedBlocks = MOLEBOT_G.minedBlocks or 0
local function numOfBlocksMined()
	local currentMinedBlockCount = MOLEBOT_G.minedBlocks
	local diff = currentMinedBlockCount - lastMinedBlockCount
	if diff > 0 then
		lastMinedBlockCount = currentMinedBlockCount
	end
	return math.min(diff, 20), diff
end

local function bpsCounter()
	while true do
		asyncSleepClock(1000)
		MacroCreator.hud:updateBps(numOfBlocksMined())
	end
end

return { cb = bpsCounter, options = { saveState = true } }
