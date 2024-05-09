local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local quat = _G.libs.quat
---@alias north -180
---@alias east -90
---@alias south 0
---@alias west 90
---@alias directions "north" | "east" | "south" | "west"
--
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

---@alias up -90
---@alias down 90
---@alias forward 0
---@alias fdown 81
---@alias pitches "up" | "down" | "forward" | "fdown"
local pitches = {
	---@type up
	up = -90,
	---@type down
	down = 90,
	---@type forward
	forward = 0,
	---@type fdown
	fdown = 81,
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
---@param timeout number?
local function disable(timeout)
	if not timeout then
		while true do
			coroutine.yield()
		end
	end
	asyncSleepClock(timeout)
end

---checks whether the script should adjust the yaw/pitch
---@param direction number
---@param desired number
---@return boolean
local function isGoodEnough(direction, desired)
	return math.abs(direction - desired) < 1
end

---@param self any
---@param args {yaw:(directions | number)?, pitch:number?, time:number?, timeout:number?} | {[1]:(directions | number)?, [2]:number?, [3]:number?, [4]:number?}
local function betterLook(self, args)
	local direction = args.yaw or args[1]
	local pitch = args.pitch or args[2]
	local time = args.time or args[3]
	local timeout = args.timeout or args[4]

	local curYaw = playerDetails.getYaw()
	local curPitch = playerDetails.getPitch()

	local newYaw = directions[direction] or type(direction) == "number" and direction or curYaw
	local newPitch = pitches[pitch] or type(pitch) == "number" and pitch or curPitch

	if isGoodEnough(curYaw, newYaw) and isGoodEnough(curPitch, newPitch) then
		disable(timeout)
	end
	if time then
		asyncLook(curYaw, newYaw, curPitch, newPitch, time)
	else
		look(newYaw, newPitch)
	end
	disable(timeout)
end
return { cb = betterLook, options = { saveState = false } }
