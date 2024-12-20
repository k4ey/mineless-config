local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
local function daemon(_, args)
  local delay = args.time or 1000
  local threshold = args.threshold or 2
  while true do
    local x, y, z = getPlayerPos()
    asyncSleepClock(delay)
    local nx, ny, nz = getPlayerPos()
    local delta = math.abs(nx - x) + math.abs(nz - z) + math.abs(ny - y)
    -- log("Player moved: " .. tostring(delta) .. " blocks")
    if delta < threshold then
      logger.emerg("WATCHDOG: Player did not move far enough, stopping")
      MacroCreator.toggled = false
      break
    end
  end
end

return { cb = daemon, options = { saveState = true } }
