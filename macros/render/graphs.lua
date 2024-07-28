local stats = _G.libs.stats
local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end


local function measuremenets(t)
  return {
    mode = stats.mode(t),
    mean = stats.mean(t),
    std = stats.sd(t),
    min = stats.min(t),
    max = stats.max(t)
  }
end

local function drawGraph()
end

local history = {}
local function graph()
  local pointer = 0
  local maxSamples = 1000
  while true do
    local blocksPerSecond = _G.MOLEBOT_G.blocksPerSec
    pointer = (pointer + 1) % maxSamples
    history[pointer] = blocksPerSecond
    asyncSleepClock(1000)
  end
end

return { cb = graph, options = { saveState = true } }
