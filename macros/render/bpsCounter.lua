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
MOLEBOT_G.blocksPer20Sec = 0
local function numOfBlocksMined()
  local currentMinedBlockCount = MOLEBOT_G.minedBlocks
  local diff = currentMinedBlockCount - lastMinedBlockCount
  if diff > 0 then
    lastMinedBlockCount = currentMinedBlockCount
  end
  return math.min(diff, 20), diff
end

local function bpsCounter()
  MOLEBOT_G.blocksPer20Sec = 0
  while true do
    MOLEBOT_G.blocksPer20Sec = 0
    for i = 1, 20 do
      asyncSleepClock(1000)
      local capped, uncapped = numOfBlocksMined()
      MOLEBOT_G.blocksPer20Sec = MOLEBOT_G.blocksPer20Sec + uncapped
      MacroCreator.hud:updateBps(capped, uncapped)
    end
    MacroCreator.network.blocks(MOLEBOT_G.blocksPer20Sec)
    -- log("&c sending blocks: ", MOLEBOT_G.blocksPer20Sec)
  end
end

return { cb = bpsCounter, options = { saveState = true } }
