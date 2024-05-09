local rb = _G.libs.relativeBlocks

rb.toggleVisibility(true)
rb.sShow({ clear = true })
local function isBlockSolid(direction, offsetX, offsetY)
	local block, bp = rb.getBlockByDirection(direction, nil, offsetX, offsetY)
	if block and block.name ~= "Air" then
		rb.sShow({
			xray = true,
			position = bp or { 0, 0, 0 },
			color = "green",
		})
	else
		rb.sShow({
			xray = true,
			position = bp or { 0, 0, 0 },
			color = "red",
		})
	end
	return block and block.name ~= "Air" and block.name ~= "Bedrock"
end
local function some(t, cb, count)
	local flag = 0
	for k, v in pairs(t) do
		flag = cb(v, k) and flag + 1 or flag
	end
	return count and flag or flag ~= 0
end

local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function getMax(t)
	local max = -99999
	local maxkey = nil
	for k, v in pairs(t) do
		if v > max then
			max = v
			maxkey = k
		end
	end
	return max, maxkey
end

local underBlocksXs = { 1, 2, 3, 4 }
local underBlocksYs = { 0 }
local function hasUnderBlock()
	return some(underBlocksXs, function(x)
		return some(underBlocksYs, function(y)
			return isBlockSolid("forward", x, y)
		end)
	end)
end

local function alignPathDirection(self, args)
	local time = args and args.time or 50
	local dir = args.direction
	assert(dir)
	rb.sShow({ clear = true })
	if not hasUnderBlock() then
		_G[dir](time)
		asyncSleepClock(time)
	end
	asyncSleepClock(time)
end

return { cb = alignPathDirection, options = { saveState = false } }
