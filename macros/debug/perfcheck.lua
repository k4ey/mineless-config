local stats = _G.libs.stats

local function hw()
  local measurements = {}
  local maxSamples = 1000
  local pointer = 0
  local last = 0
  local future = os.clock()
  local lastPointer = 0
  local lastMode = 0
  while true do
    local now = os.clock()
    local diff = now - last
    measurements[pointer] = diff
    pointer = (pointer + 1) % maxSamples
    last = now
    if now > future then
      local mode = stats.mode(measurements)
      local mean = stats.mean(measurements)
      lastMode = mode

      -- log(
      -- 	("&4[MINELESS] &f| Mode: &e%s&f , Mean: &e%s&f, Sample size: &e%s&f, YPS: &e%s&f"):format(
      -- 		tostring(mode),
      -- 		tostring(math.round(mean * 10000) / 10000),
      -- 		tostring(#measurements),
      -- 		tostring(math.max(pointer, lastPointer) - math.min(pointer, lastPointer))
      -- 	)
      -- )
      lastPointer = pointer
      future = now + 1
    end
    if diff > lastMode + (lastMode * 2) then
      log(
        ("&4[MINELESS] &f| &4&LSPIKE IN PERFORMANCE&f took: &e%s&f, should: &e%s"):format(
          tostring(diff),
          tostring(lastMode)
        )
      )
    end
    coroutine.yield()
  end
end
return { cb = hw, options = { saveState = true } }
