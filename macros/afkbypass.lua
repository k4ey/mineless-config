local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

---@param self any
local function afk(self)
	if openInventory().getTotalSlots() > 63 then
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
