local playMCSound = _G.libs.playMCSound
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

if not MOLEBOT_G then
	MOLEBOT_G = {}
end
---@class measurements
---@field timestamps {[string]: number} timestamps of last validity of the check
---@field times {[string]: number} times for how long the check has been NOT satisfied

if not MOLEBOT_G.measurements then
	---@type measurements
	MOLEBOT_G.measurements = {
		timestamps = {
			idle = 0,
			lastBlockBreak = 0,
			efficiency = 0,
			-- entityCountChanged = 0,
			positionDrasticChange = 0,
			dimensionChanged = 0,
			mentioned = 0,
			justStarted = 0,
			inventoryChanged = 0,
			inventoryDrasticChange = 0,
			isOutsideMine = 0,
			seesCorners = 0,
		},
		times = {
			idle = 0,
			lastBlockBreak = 0,
			efficiency = 0,
			-- entityCountChanged = 0,
			positionDrasticChange = 0,
			dimensionChanged = 0,
			justStarted = 0,
			mentioned = 0,
			inventoryChanged = 0,
			inventoryDrasticChange = 0,
			isOutsideMine = 0,
			seesCorners = 0,
		},
	}
end
local function hasJustStarted()
	return false
end
local function hasBeenMentioned()
	if not MOLEBOT_G.lastMessages then
		return false
	end
	local mentionedCount = #MOLEBOT_G.lastMessages
	MOLEBOT_G.lastMessages = {}
	return mentionedCount > 0
end

local function seesCorners()
	local editManager = MacroCreator.api.getEditManager()
	local corners = editManager:deriveCorners()
	local cornerCount = 0
	for _, cornerPos in pairs(corners) do
		local block = getBlock(cornerPos[1], editManager.mineHeight or 0, cornerPos[2])
		if block then
			if block.name ~= "Bedrock" then
				return false
			end
			cornerCount = cornerCount + 1
		end
	end
	return cornerCount ~= 0
end

local function isDimensionChanging()
	return getWorld() == false
end

local function isLoadingWorld()
	return luajava.getDeclaredFields(getMinecraft().field_71462_r)[1] == "customLoadingScreen"
end
local lastPosition = { 0, 0, 0 }
local function hasPositionChangedDrastically()
	local position = { getPlayerBlockPos() }
	local changed = false
	local dist = math.sqrt((position[1] - lastPosition[1]) ^ 2 + (position[3] - lastPosition[3]) ^ 2)
	changed = dist > 20
	lastPosition = position
	return changed
end

local lastEntityCount = 0
local function hasEntityCountChanged()
	local entities = getEntityList()
	local count = 0
	for _, entity in ipairs(entities) do
		count = count + 1
	end
	local changed = count ~= lastEntityCount
	if changed then
		lastEntityCount = count
	end
	return changed
end

local function isMoving()
	if isLoadingWorld() then
		return false
	end
	local player = playerDetails.getVelocity()
	local velocity = 0
	for i = 1, 3 do
		velocity = velocity + math.abs(player[i])
	end
	return velocity > 0.2
end

local lastInventory = {}
local function hasInventoryChanged(factor)
	local inventory = {}
	local inv = openInventory()
	local itemCount = 0
	for i = 1, inv.getTotalSlots() do
		local item = inv.getSlot(i)
		if item then
			inventory[i] = { id = item.id, amount = item.amount }
			itemCount = itemCount + 1
		else
			inventory[i] = false
		end
	end
	local changedItems = 0
	for slot, item in pairs(inventory) do
		local lastItem = lastInventory[slot]
		if item and lastItem then
			if item.id ~= lastItem.id or item.amount ~= lastItem.amount then
				changedItems = changedItems + 1
			end
		elseif item ~= lastItem then
			changedItems = changedItems + 1
		end
	end
	lastInventory = inventory
	if factor then
		return changedItems / itemCount > factor
	else
		return changedItems > 0
	end
end

local lastMinedBlockCount = 0
local function hasBrokenBlockRecently()
	local currentMinedBlockCount = MOLEBOT_G.minedBlocks
	if currentMinedBlockCount > lastMinedBlockCount then
		lastMinedBlockCount = currentMinedBlockCount
		return true
	end
	return false
end
local function isEfficientEnough()
	while true do
		local currentMinedBlockCount = MOLEBOT_G.minedBlocks
		asyncSleepClock(1000)
		local efficiency = MOLEBOT_G.minedBlocks - currentMinedBlockCount
		coroutine.yield(efficiency > 10)
	end
end

local function isInsideMine()
	local boundingBlock = "Bedrock"
	local function iterDepth(blockGetter)
		for i = 1, 999 do
			local block = blockGetter(i)
			if block and block.name == boundingBlock then
				return i - 1
			end
		end
		return 0
	end
	local x, y, z = getPlayerBlockPos()
	y = y - 20 -- we adjust the height to be inside the mine even tho we might be above it

	local sizeXP = iterDepth(function(i)
		return getBlock(x + i, y, z)
	end)

	local sizeXM = iterDepth(function(i)
		return getBlock(x - i, y, z)
	end)

	local sizeZP = iterDepth(function(i)
		return getBlock(x, y, z + i)
	end)

	local sizeZM = iterDepth(function(i)
		return getBlock(x, y, z - i)
	end)
	return (sizeXP > 0 or sizeXM > 0) and (sizeZP > 0 or sizeZM > 0)
end

---@param name string
---@param func fun():boolean|nil
local function measurer(name, func)
	local measurements = MOLEBOT_G.measurements

	local now = os.clock()
	local idleTime = now - measurements.timestamps[name]

	if func() == true then
		-- resets the time if the check is satisfied
		measurements.times[name] = 0
		measurements.timestamps[name] = now
	elseif func() == false then -- if nil then we ignore it
		-- sets the time if the check is not satisfied
		measurements.times[name] = idleTime
	else
		measurements.times[name] = idleTime
	end
end

local measurements = {
	{
		name = "idle",
		func = isMoving,
	},
	{
		name = "lastBlockBreak",
		func = hasBrokenBlockRecently,
	},
	{
		name = "efficiency",
		func = coroutine.wrap(isEfficientEnough),
	},
	-- {
	-- 	name = "entityCountChanged",
	-- 	func = hasEntityCountChanged,
	-- },
	{
		name = "positionDrasticChange",
		func = hasPositionChangedDrastically,
	},
	{
		name = "dimensionChanged",
		func = isDimensionChanging,
	},
	{
		name = "mentioned",
		func = hasBeenMentioned,
	},
	{
		name = "justStarted",
		func = hasJustStarted,
	},
	{
		name = "inventoryChanged",
		func = function()
			--- we save the old inventory so the inventory drastic can consume it one more time!
			local oldInventory = lastInventory
			local hasChanged = hasInventoryChanged()
			lastInventory = oldInventory
			return hasChanged
		end,
	},
	{
		name = "inventoryDrasticChange",
		func = function()
			return hasInventoryChanged(0.4)
		end,
	},
	{
		name = "isOutsideMine",
		func = function()
			return not isInsideMine
		end,
	},
	{
		name = "seesCorners",
		func = seesCorners,
	},
}

local function measure()
	for _, measurement in ipairs(measurements) do
		MOLEBOT_G.measurements.timestamps[measurement.name] = os.clock()
		MOLEBOT_G.measurements.times[measurement.name] = 0
	end
	while true do
		-- local now = os.clock()
		for _, measurement in pairs(measurements) do
			-- local subNow = os.clock()
			measurer(measurement.name, measurement.func)
			-- log(("Measurement %s took %s"):format(measurement.name, tostring(os.clock() - subNow)))
		end
		-- log("Measurements took " .. tostring(os.clock() - now))
		asyncSleepClock(350)
	end
end

return { cb = measure, options = { saveState = true } }
