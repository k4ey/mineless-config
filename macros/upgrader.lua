-- local mc = getMinecraft()
-- local keyBinding = luajava.bindClass("net.minecraft.client.settings.KeyBinding")
-- local setGameFocused = function(focus)
-- 	pcall(function(...)
-- 		keyBinding:func_186704_a() -- updateKeyBindState
-- 		mc.field_71415_g = true -- inGameHasFocus
-- 		mc.field_71417_B:func_74372_a() -- mouseHelper.grabMouseCursor
-- 		mc:func_147108_a() -- displayGuiScreen
-- 		mc.field_71429_W = 10000 -- leftClickCounter
-- 	end)
-- end
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

---disables the area until it gets reset
local function disable(timeout)
	if not timeout then
		while true do
			coroutine.yield()
		end
	end
	asyncSleepClock(timeout)
end

---@alias UpgraderStep_IdName { id: string, name: string, slot: number, nowait:boolean? }
---@alias UpgraderStep_Action { action: function}
---@alias UpgraderStep UpgraderStep_IdName | UpgraderStep_Action

---@type UpgraderStep[]
local usteps = {
	{
		action = function()
			local previousSlots = openInventory().getTotalSlots()
			repeat
				use()
				asyncSleepClock(100)
			until openInventory().getTotalSlots() ~= previousSlots
		end,
	},
	{ name = "Token Enchants" },
	{ name = "Jackhammer" },
	{ slot = 16 },
	{
		action = function()
			openInventory().close()
		end,
	},
}
local inv = openInventory()

---@param i number
---@return {name: string, id: string}?
local function getSlot(i)
	if inv.getTotalSlots() <= i then
		return nil
	end
	local item = inv.getSlot(i)
	return item and { name = item.name:gsub("§.", ""), id = item.id } or nil
end

---@param itemName string?
---@param itemId string?
---@return number?
local function getSlotWith(itemName, itemId)
	assert(itemName or itemId, "provide something to look for!")
	for i = 1, inv.getTotalSlots() - 1 do
		local item = getSlot(i)
		if item then
			if itemName and itemId then
				if item.name == itemName and item.id == itemId then
					return i
				end
			elseif itemName then
				if item.name == itemName then
					return i
				end
			elseif item.id == itemId then
				return i
			end
		end
	end
end

---@param slot number
local function clickAsync(slot)
	inv.click(slot)
	log("clicking slot " .. slot)
end

---parses the upgrades
---@param steps UpgraderStep[]
---@param delay number MILISECONDS
---@param timeout number SECONDS
local function parseUpgrades(steps, delay, timeout)
	for _, step in pairs(steps) do
		local beginTime = os.clock()
		log(step)
		if step.name or step.id then
			repeat
				local slot = getSlotWith(step.name, step.id)
				if slot then
					log("found slot " .. slot .. "for ", step)
					clickAsync(slot)
				end
				asyncSleepClock(delay)
				if os.clock() - beginTime > timeout / 1000 then
					break
				end
			until slot or step.nowait
		elseif step.action then
			assert(type(step.action) == "function", "action is invalid!")
			step.action()
		elseif step.slot then
			assert(type(step.slot) == "number" and step.slot < openInventory().getTotalSlots(), "slot is invalid!")
			openInventory().click(step.slot)
		end
		asyncSleepClock(delay)
	end
end

---@param self any
---@param args { delay: number?, timeout: number?, steps: UpgraderStep[] }
local function upgrader(self, args)
	local delay = args and args.delay or 500
	local timeout = args and args.timeout or 60000
	local steps = args and args.steps or usteps
	parseUpgrades(steps, delay, 2000)
	-- runOnMC(setGameFocused)
	asyncSleepClock(timeout)
end
return { cb = upgrader, options = { saveState = true } }
