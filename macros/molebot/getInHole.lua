local rb = _G.libs.relativeBlocks
local function isBlockAir(direction, offsetX, offsetY)
	local block, bp = rb.getBlockByDirection(direction, nil, offsetX, offsetY)
	-- if block and block.name == "Air" then
	-- 	rb.sShow({
	-- 		xray = true,
	-- 		position = bp or { 0, 0, 0 },
	-- 		color = "green",
	-- 	})
	-- else
	-- 	rb.sShow({
	-- 		xray = true,
	-- 		position = bp or { 0, 0, 0 },
	-- 		color = "red",
	-- 	})
	-- end
	return block and block.name == "Air"
end
local function every(t, cb)
	local flag = true
	for k, v in pairs(t) do
		flag = cb(v, k) and flag
	end
	return flag
end

local aboveAirBlocksXs = { 0 }
local aboveAirBlocksYs = { -1, -2, -3, -4 }
local function hasAirUnder()
	return every(aboveAirBlocksXs, function(x)
		return every(aboveAirBlocksYs, function(y)
			return isBlockAir("forward", x, y)
		end)
	end)
end

local behindBlocksXs = { 1 }
local behindBlocksYs = { -1, -2, -3 }
local function hasAirBehind()
	return every(behindBlocksXs, function(x)
		return every(behindBlocksYs, function(y)
			return isBlockAir("back", x, y)
		end)
	end)
end

local underBlocksXs = { 1 }
local underBlocksYs = { -1, -2, -3 }
local function hasAirInFront()
	return every(underBlocksXs, function(x)
		return every(underBlocksYs, function(y)
			return isBlockAir("forward", x, y)
		end)
	end)
end

local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function alignPath(_, args)
	local time = args and args.time or 50

	if hasAirInFront() then
		forward(time)
		asyncSleepClock(200)
	elseif hasAirUnder() then
		asyncSleepClock(500)
		forward(time)
	elseif hasAirBehind() then
		back(time)
	else
		forward(time)
	end
	asyncSleepClock(time)
end

return { cb = alignPath, options = { saveState = false } }
