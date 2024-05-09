local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function findInInventory(itemName)
	local inv = openInventory()
	for i = 1, inv.getTotalSlots() do
		local slot = inv.getSlot(i)
		if slot and slot.name == itemName then
			return i
		end
	end
end

local function putInHotbar(itemName)
	local inv = openInventory()
	if inv.getSlot(36 + getHotbar()).name == itemName then
		return true
	end
	local slot = findInInventory(itemName)
	if slot then
		inv.swap(slot, 36 + getHotbar())
		asyncSleepClock(10)
		return true
	else
		return false
	end
end
---@param side string
---@return {[1]:number, [2]:number, [3]:number}
local function translateSide(side)
	local map = {
		["down"] = { 0, -1, 0 },
		["up"] = { 0, 1, 0 },
		["north"] = { 0, 0, -1 },
		["south"] = { 0, 0, 1 },
		["west"] = { -1, 0, 0 },
		["east"] = { 1, 0, 0 },
	}
	assert(map[side], "Invalid side")
	return map[side]
end

---@alias blockName string name of the block
---@alias itemName string name of the item used to place the block (optional)
---places choosen block at location of this area
---@param self any
---@param args {[1]:blockName, [2]: itemName} | {blockName: blockName, itemName: itemName}
local function fillSchematic(self, args)
	local blockName = args[1] or args.blockName or "Dirt"
	local itemName = args[2] or args.itemName or args[1] or args.blockName or "Dirt"

	local area = assert(MacroCreator.api.getAreaManager():getAreaById(self.areaId))
	while true do
		local target = playerDetails.getTarget()
		if target then
			local pos = target.pos
			local vect = translateSide(target.side)
			local blockPos = { pos[1] + vect[1], pos[2] + vect[2], pos[3] + vect[3] }
			if area.area:inside(blockPos) then
				local block = getBlock(table.unpack(blockPos))
				if block and block.name ~= blockName then
					putInHotbar(itemName)
					use(0)
				end
			end
		end
		asyncSleepClock(10)
	end
end
return { cb = fillSchematic, options = {} }
