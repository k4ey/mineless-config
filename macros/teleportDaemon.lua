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
    if delta > threshold then
      asyncSleepClock(args.timeout or 100)
      logger.emerg("WATCHDOG: Player got tped out! stopping")
      MacroCreator.toggled = false
      break
    end
  end
end

return { cb = daemon, options = { saveState = true } }
