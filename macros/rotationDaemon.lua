local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
local function daemon(_, args)
  local threshold = args.threshold or 3
  local quat = _G.libs.quat
  while true do
    local q = quat.Euler(0, playerDetails.getYaw(), playerDetails.getPitch())
    coroutine.yield()
    local q2 = quat.Euler(0, playerDetails.getYaw(), playerDetails.getPitch())
    local delta = quat.Angle(q, q2)
    -- log("Player moved: " .. tostring(delta) .. " degrees")
    if delta > threshold then
      logger.emerg(("WATCHDOG: Large snap! %s, stopping"):format(tostring(delta)))
      MacroCreator.toggled = false
      break
    end
  end
end

return { cb = daemon, options = { saveState = true } }
