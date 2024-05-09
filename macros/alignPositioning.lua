local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local getPlayerBlockPos = getPlayerBlockPos
local getBlock = getBlock
local sneak = sneak
local attack = attack

local function areBlocksInLineAir(direction, length, width)
	local function checkIfBlock(i, j)
		local x, y, z = getPlayerBlockPos()
		local block = getBlock(x + i, y - 2, z + j)
		return block and block.name == "Air"
	end
	local x, y, z = getPlayerBlockPos()
	local delta = { north = { 1, 1, -1 }, east = { 1, 1, 1 }, south = { 1, 1, 1 }, west = { -1, 1, 1 } }
	local block
	local theoreticalCount = length * width
	for i = 0, length, 1 do
		for j = 0, width, 1 do
			if direction == "west" or direction == "east" then
				if not checkIfBlock(i * delta[direction][1], j * delta[direction][3]) then
				end
			else
				if not checkIfBlock(j * delta[direction][1], i * delta[direction][3]) then
				end
			end
		end
	end
end

local function alignPositioning(self, args)
	local radius = args.radius or 3
	local directions = { "north", "east", "south", "west" }
	local direction = directions[math.floor(((playerDetails.getYaw() / 90 + 2.5) % 4 + 1))]
	areBlocksInLineAir(direction, 10, 5)
end

return { cb = alignPositioning, options = { saveState = false } }
