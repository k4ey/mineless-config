local function waitTicks(ticks)
  for i = 1, ticks do
    waitTick()
  end
end
HeldKeys = {}
local keyMutex = newMutex("HeldKeys" .. tostring(os.time()))
function tickKey(kname, ticks)
  while not keyMutex.tryLock() do
    sleep(1)
  end
  key(kname, -1)
  if HeldKeys[kname] then
    HeldKeys[kname].ticks = ticks
    HeldKeys[kname].changed = true
  else
    HeldKeys[kname] = { ticks = ticks, changed = true }
  end
  keyMutex.unlock()

  runThread(function()
    local counterLock = newMutex("counterLock" .. kname)
    if not counterLock.tryLock() then
      -- log("&c [ERROR] Failed to lock counterLock for key " .. kname)
      return
    end

    local count = 0
    repeat
      if HeldKeys[kname].changed then
        keyMutex.lock()
        count = 0
        HeldKeys[kname].changed = false
        keyMutex.unlock()
      end
      waitTick()
      count = count + 1
      -- log("&e [INFO] Key " .. kname .. " held for " .. count .. " ticks")
    until count >= HeldKeys[kname].ticks
    key(kname, 0)
    -- log("&e [INFO] Key " .. kname .. " released after " .. count .. " ticks")
    counterLock.unlock()
  end)
end

function fly()
  local counterLock = newMutex("counterLockSPACE")
  counterLock.lock()
  waitTicks(20)
  key("SPACE", -1)
  waitTick()
  key("SPACE", 0)
  waitTicks(1)
  key("SPACE", -1)
  waitTick()
  key("SPACE", 0)
  counterLock.unlock()
end

local function override(...)
  while true do
    coroutine.yield()
  end
end
return { cb = override, options = {} }
