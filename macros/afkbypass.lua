local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

local function inTable(t, s)
  for _, v in pairs(t) do
    if v == s then
      return true
    end
  end
  return false
end

---@param self any
local function afk(self, args)
  local whiteListedLabels = args and args.whiteList
  if (not whiteListedLabels and openInventory().getTotalSlots() > 63) or (whiteListedLabels and not inTable(whiteListedLabels, openInventory().getUpperLabel())) then
    MacroCreator.api.toggleBot()
    jump(0)
    forward(0)
    left(0)
    right(0)
    back(0)
    attack(0)
    use(0)
  end
end
return { cb = afk, options = { saveState = false } }
