local rb = _G.libs.relativeBlocks
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function isBlock(x, y, z)
	local name = getBlockName(x, y, z)
	-- rb.sShow({
	-- 	position = { x, y, z },
	-- 	color = name == "Air" and "red" or "green",
	-- 	xray = true,
	-- })
	return name == "Air"
end

rb.toggleVisibility(true)
local function areaBlocksNearPlayer(radius)
	local playerHead = 1.62
	local x, y, z = getPlayerPos()
	local directions = { "left" }
	for i = 1, radius do
		for j = 1, radius do
			for _, direction in ipairs(directions) do
				local rx1, ry1, rz1 = rb.direction(direction, j)
				local rx2, ry2, rz2 = rb.direction("forward", i)
				local rx, ry, rz = rx1 + rx2, ry1 + ry2, rz1 + rz2

				if not isBlock(math.floor(x + rx), math.floor(y + playerHead), math.floor(z + rz)) then
					return false
				end
			end
		end
	end
	return true
end

-- local function restoreFocus()
--     mc.field_71415_G = true -- mc.inGameHasFocus = true
-- end

local function goBlockVertically(self, args)
	rb.toggleVisibility(true)
	local radius = args.radius or 2
	local direction = args.direction or "down"
	if playerDetails.isOnGround() then
		asyncSleepClock(5250)
	end
	if areaBlocksNearPlayer(radius) then
		if direction == "down" then
			sneak(50)
		else
			key("SPACE", 50)
		end
	end
	asyncSleepClock(50)
end

return { cb = goBlockVertically, options = { saveState = false } }
