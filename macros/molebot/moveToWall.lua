local rb = _G.libs.relativeBlocks
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function every(t, cb)
	local flag = true
	for k, v in pairs(t) do
		flag = cb(v, k) and flag
	end
	return flag
end

local function some(t, cb, count)
	local flag = 0
	for k, v in pairs(t) do
		flag = cb(v, k) and flag + 1 or flag
	end
	return count and flag or flag ~= 0
end

-- rb.toggleVisibility(true)
-- rb.sShow({ clear = true })
local function isBlockBedrock(direction, offsetX, offsetY)
	local block, bp = rb.getBlockByDirection(direction, nil, offsetX, offsetY)
	-- if block and block.name == "Bedrock" then
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
	return block and block.name == "Bedrock"
end

local blockXs = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
local blockYs = { -1, -2 }
local function hasBedrock(direction)
	return some(blockXs, function(x)
		return every(blockYs, function(y)
			return isBlockBedrock(direction, x, y)
		end)
	end)
end

local function alignPath(_, args)
	local time = args and args.time or 100
	if hasBedrock("back") then
		back(time)
	elseif hasBedrock("forward") then
		forward(time)
	elseif hasBedrock("right") then
		right(time)
	elseif hasBedrock("left") then
		left(time)
	end
	asyncSleepClock(time * 2)
end

return { cb = alignPath, options = { saveState = false } }
