local rb = _G.libs.relativeBlocks
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

--leaving this for the future in case i need it anytime soon
local function isBlockAir(direction, offsetY)
	local block = rb.getBlockByDirection(direction, nil, 1, offsetY)
	return block and block.name == "Air"
end
--- this can be breaking if the player is sitting on a not  full block or when flying, BEWARE OF THAT CUZ I AINT IMPLEMENTING A CATCH FOR THIS.
local function getPossibleDirections()
	return {
		left = isBlockAir("left", 1) and isBlockAir("left", 2) and isBlockAir("left", 0),
		right = isBlockAir("right", 1) and isBlockAir("right", 2) and isBlockAir("right", 0),
		back = isBlockAir("back", 1) and isBlockAir("back", 2) and isBlockAir("back", 0),
		forward = isBlockAir("forward", 1) and isBlockAir("forward", 2) and isBlockAir("forward", 0),
	}
end
local directions = {
	left = right,
	right = left,
	forward = back,
	back = forward,
}

local function negateTable(t)
	local newT = {}
	local positiveValues = 0
	for k, v in pairs(t) do
		newT[k] = not v
		if newT[k] then
			positiveValues = positiveValues + 1
		end
	end
	return newT, positiveValues
end
local function stopMovement(possibleDirections)
	for k, v in pairs(possibleDirections) do
		if v == false then
			directions[k](0)
		end
	end
end

---@param self any
---@param args {time:number}
local function autoAlign(self, args)
	local time = args and args.time or 100

	local possibleDirections, count = negateTable(getPossibleDirections())
	if count > 0 then
		stopMovement(possibleDirections)
	end

	for k, v in pairs(possibleDirections) do
		if v == true then
			directions[k](time)
		end
	end
	asyncSleepClock(time)
end
return { cb = autoAlign, options = { saveState = false } }
