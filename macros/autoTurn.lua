local quat = _G.libs.quat
---@alias north 180
---@alias east 270
---@alias south 0
---@alias west 90
---@alias directions "north" | "east" | "south" | "west"
local directions = {
	---@type north
	north = -180 + 360,
	---@type east
	east = -90 + 360,
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
-- local function getDirection()
--     local player = getPlayer()
--     local yaw_opt =  math.floor(player.yaw / 90 + 3.5)
--     local dir_mat = { [1]={"-z",-180}, [2]={ "+x",-90 }, [3]={ "+z",0 }, [4]={ "-x",90 }, [5]={ "-z",-180 } }
--     return dir_mat[yaw_opt]
-- end

---checks whether the script should adjust the yaw/pitch
---@param direction number
---@param desired number
---@return boolean
local function isGoodEnough(direction, desired)
	return math.abs(direction - desired) < 1
end
--- decides from which direction the player is coming
local function getDirection()
	local velocity = playerDetails.getVelocity()
	local dx, dz = velocity[1], velocity[3]
	log("deltas")
	log(dx)
	log(dz)
	if math.abs(dx) > math.abs(dz) then
		log("X")
		if dx > 0.00 then
			return "+x"
		elseif dx < 0.00 then
			return "-x"
		end
	else
		log("Z")
		if dz < 0.00 then
			return "-z"
		elseif dz > 0.00 then
			return "+z"
		end
	end
	-- if dx >= 0.08 then
	--     return "+x"
	-- elseif dx <= -0.08 then
	--     return "-x"
	-- elseif dz <= -0.08 then
	--     return "-z"
	-- elseif dz >= 0.08 then
	--     return "+z"
	-- end
end
--[[ leaving this for the future in case i need it anytime soon
local function isBlockAir(x,y,z)
    return getBlock(x,y,z).name == "Air"
end
--- this can be breaking if the player is sitting on a not  full block or when flying, BEWARE OF THAT CUZ I AINT IMPLEMENTING A CATCH FOR THIS.
local function getPossibleDirections()
    local x,y,z = getPlayerBlockPos()
    return {
        ["+x"] = isBlockAir(x+1,y,z) and isBlockAir(x+1,y+1,z),
        ["-x"] = isBlockAir(x-1,y,z) and isBlockAir(x-1,y+1,z),
        ["+z"] = isBlockAir(x,y,z+1) and isBlockAir(x,y+1,z+1),
        ["-z"] = isBlockAir(x,y,z-1) and isBlockAir(x,y+1,z-1),
    }
end
]]
--
local directions = {
	["-z"] = -180 + 360,
	["+x"] = -90,
	["+z"] = 0,
	["-x"] = 90,
}
-- fucking euler angles KUUUUURWA

---@param self any
---@param args {[1]:number}
local function lookDirection(self, args)
	local time = args and table.unpack(args) or 250
	local direction = getDirection()
	if not direction then
		return
	end
	local directionFrom = string.gsub(direction, "[+-]", function(sign)
		return sign == "+" and "-" or "+"
	end)
	--- this might be used for the future pathfinders or something, leaving this for now...
	-- local possibleDirections = getPossibleDirections()
	-- possibleDirections[] = false

	local curYaw = playerDetails.getYaw()
	if isGoodEnough(curYaw, directions[directionFrom]) then
		disable()
	end
	asyncLook(curYaw, directions[directionFrom], playerDetails.getPitch(), playerDetails.getPitch(), 250)
	disable()
end
return { cb = lookDirection, options = { saveState = false } }
