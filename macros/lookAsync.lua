local quat = libs.quat
---@alias north -180
---@alias east -90
---@alias south 0
---@alias west 90
---@alias directions "north" | "east" | "south" | "west"
local directions = {
	---@type north
	north = -180,
	---@type east
	east = -90,
	---@type south
	south = 0,
	---@type west
	west = 90,
}

---asynchronously looks towards y1,p1 for <time> 'ms
---@param y0 number yaw source
---@param y1 number yaw dest
---@param p0 number pitch source
---@param p1 number pitch dest
---@param time number time how long it should take.
local function asyncLook(y0, y1, p0, p1, time)
	local start = os.clock()
	local future = start + time / 1000
	local yaw, pitch
	local i
	local angle1 = quat.Euler(0, p0, y0)
	local angle2 = quat.Euler(0, p1, y1)
	repeat
		---@diagnostic disable-next-line
		i = math.clamp(1 - (future - os.clock()) / (future - start), 0, 1)
		local angle = quat.Lerp(angle1, angle2, i):ToEulerAngles()
		-- so basically this is some weird shit, does not work on negatives but does work on this...
		if angle.y > 90 then
			angle.y = angle.y - 360
		end
		--- this also, we do ZYX or smth like that
		yaw, pitch = angle.z, angle.y
		look(yaw, pitch)

		coroutine.yield()
	until os.clock() >= future
	local angle = quat.Slerp(angle1, angle2, 1):ToEulerAngles()
	if angle.y > 90 then
		angle.y = angle.y - 360
	end
	look(angle.z, angle.y)
end
---disables the area until it gets reset
local function disable()
	while true do
		coroutine.yield()
	end
end

---checks whether the script should adjust the yaw/pitch
---@param direction number
---@param desired number
---@return boolean
local function isGoodEnough(direction, desired)
	return math.abs(direction - desired) < 1
end

---@param self any
---@param args {[1]:directions, [2]:number}
local function lookDirection(self, args)
	local direction, time = table.unpack(args)
	local newYaw, newPitch = 0, 0

	local curYaw = playerDetails.getYaw()
	local curPitch = playerDetails.getPitch()
	if type(direction) == "string" then
		newYaw = directions[direction]
		newPitch = playerDetails.getPitch()
	elseif type(direction) == "table" and #direction == 2 then
		newYaw = direction[1]
		newPitch = direction[2]
	end

	if isGoodEnough(curYaw, newYaw) then
		disable()
	end
	if time then
		asyncLook(curYaw, newYaw, curPitch, newPitch, time)
	else
		look(newYaw, newPitch)
	end
	disable()
end
return { cb = lookDirection, options = { saveState = false } }
