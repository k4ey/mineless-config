local rb = _G.libs.relativeBlocks

local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local getPlayerBlockPos = getPlayerBlockPos
local sneak = sneak
local attack = attack

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
---@return boolean
local function areBlocksInRadiusAir(r1, r2, area)
	local x, y, z = getPlayerBlockPos()

	local minX = area.minX
	local maxX = area.maxX
	local minY = area.minY
	local maxY = area.maxY
	local minZ = area.minZ
	local maxZ = area.maxZ

	local name
	for i = r1, r2 do
		for j = r1, r2, 1 do
			for k = -2, 0, 1 do
				local bx, by, bz = x + i, y + k, z + j
				if inside(bx, by, bz, minX, minY, minZ, maxX, maxY, maxZ) then
					name = getBlockName(bx, by, bz)
					if name ~= "" and name ~= "Bedrock" and name ~= "Air" then
						return false
					end
				end
			end
		end
	end
	return true
end

---comment
---@param self cbOptions
---@param args any
local function goBlockVertically(self, args)
	local areaManager = MacroCreator.api.getAreaManager()
	local radius = args.radius or 3
	local areaId = tostring(self.areaId)
	local area = areaManager:getAreaById(areaId)
	assert(area, "area is not specified????")
	while true do
		if areBlocksInRadiusAir(-radius, radius, area.area) then
			-- we are using mine daemon to allow mining offscreen, look mine.lua in MACROS/macros
			_G.MOLEBOT_G.canAttack = false
			sneak(25)
			asyncSleepClock(100)
		else
			_G.MOLEBOT_G.canAttack = true
			asyncSleepClock(250)
		end
	end
end

return { cb = goBlockVertically, options = { saveState = false } }
