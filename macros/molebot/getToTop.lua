---@type RelativeBlocks
local rb = _G.libs.relativeBlocks
rb.toggleVisibility(true)
---@diagnostic disable-next-line
getBlockName = getBlockName

local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local getPlayerBlockPos = getPlayerBlockPos
local sneak = sneak

---@param x number
---@param y number
---@param z number
---@return boolean
local function inside(x, y, z, minX, minY, minZ, maxX, maxY, maxZ)
	return x >= minX and x <= maxX and y >= minY and y <= maxY and z >= minZ and z <= maxZ
end

---@param r1 number
---@param r2 number
---@param area Area
---@return boolean | { [1]: number, [2]: number, [3]: number }
local function getBlockInRadius(r1, r2, area, x, y, z)
	local minX = area.minX
	local maxX = area.maxX
	local minY = area.minY
	local maxY = area.maxY
	local minZ = area.minZ
	local maxZ = area.maxZ

	local name
	for i = r1, r2 do
		for j = r1, r2, 1 do
			for k = 0, 10, 1 do
				local bx, by, bz = x + i, y + k, z + j
				if inside(bx, by, bz, minX, minY, minZ, maxX, maxY, maxZ) then
					name = getBlockName(bx, by, bz)
					if name ~= "" and name ~= "Bedrock" and name ~= "Air" then
						rb.sShow({
							position = { bx, by, bz },
							name = name,
							xray = true,
							color = "red",
						})
						return { bx, by, bz }
					end
				end
			end
		end
	end
	return false
end

local function getPlayerStandingBlockPos()
	local x, y, z = getPlayerBlockPos()
	return x, y - 1, z
end

local function isAboveAndNotAir(px, py, pz, bx, by, bz)
	return py >= by and getBlockName(px, py, pz) ~= "Air"
end

local function isBelowAndAir(px, py, pz, bx, by, bz)
	return py < by and getBlockName(bx, by, bz) == "Air"
end

local function determineLastBlock(px, py, pz, bx, by, bz)
	if isAboveAndNotAir(px, py, pz, bx, by, bz) or isBelowAndAir(px, py, pz, bx, by, bz) then
		return px, py, pz
	end
	return bx, by, bz
end

local function hasFallenOfABlock(px, py, pz, bx, by, bz)
	return py < by
end

local function getDistanceToBlock(bx, bz)
	local px, _, pz = getPlayerPos()
	return math.sqrt((px - bx) ^ 2 + (pz - bz) ^ 2)
end

local function startFlying()
	asyncSleepClock(300)
	key("SPACE", 50)
	asyncSleepClock(150)
	key("SPACE", 50)
	asyncSleepClock(100)
	key("SPACE", 50)
end

local function returnToPosition(bx, by, bz)
	rb.sShow({ position = { bx, by, bz }, name = "Air", xray = true, color = "green" })
	local px, py, pz = getPlayerStandingBlockPos()
	lookAt(bx + 0.5, by + 0.5, bz + 0.5)

	startFlying()
	while py < by + 1 do
		key("SPACE", 20)
		asyncSleepClock(20)
		px, py, pz = getPlayerStandingBlockPos()
	end

	while getDistanceToBlock(bx + 0.5, bz + 0.5) > 0.5 do
		log(getDistanceToBlock(bx + 0.5, bz + 0.5))
		lookAt(bx + 0.5, by + 0.5, bz + 0.5)
		forward(10)
		asyncSleepClock(10)
	end

	asyncSleepClock(300)

	startFlying()
end

---comment
---@param self cbOptions
---@param args any
local function getToTop(self, args)
	local bx, by, bz = getPlayerStandingBlockPos()
	while true do
		local x, y, z = getPlayerStandingBlockPos()
		bx, by, bz = determineLastBlock(x, y, z, bx, by, bz)
		if hasFallenOfABlock(x, y, z, bx, by, bz) then
			returnToPosition(bx, by, bz)
			asyncSleepClock(250)
		end

		asyncSleepClock(0)
	end
end

return { cb = getToTop, options = { saveState = false } }
