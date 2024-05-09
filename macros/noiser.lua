local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local quat = _G.libs.quat

---asynchronously looks towards y1,p1 for <time> 'ms
---@param y0 number yaw source
---@param y1 number yaw dest
---@param p0 number pitch source
---@param p1 number pitch dest
---@param time number time how long it should take.
local function asyncLook(y0, y1, p0, p1, time)
	local start = os.clock()
	local future = start + time / 1000
	local yaw, pitch, curYaw, curPitch
	local i
	local angle1 = quat.Euler(0, p0, y0)
	local angle2 = quat.Euler(0, p1, y1)

	--- for the future, snapping wont happen if you do not allow for a situation when there are two areas that change directions at once.
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
---@param timeout number
local function disable(timeout)
	if not timeout then
		while true do
			coroutine.yield()
		end
	end
	asyncSleepClock(timeout)
end

local mc = getMinecraft()

---@param self any
---@param args {time:number?, timeout:number?, timeEntropy: number?, yawEntropy: number?, pitchEntropy:number?}
local function noiser(self, args)
	local time = args.time or 250
	local timeout = args.timeout or 1000
	local timeEntropy = args.timeEntropy or 0
	local yawEntropy = args.yawEntropy or 0
	local pitchEntropy = args.pitchEntropy or 0

	local curYaw = playerDetails.getYaw()
	local curPitch = playerDetails.getPitch()

	local newYaw = curYaw + math.random(-yawEntropy, yawEntropy)
	local newPitch = curPitch + math.random(-pitchEntropy, pitchEntropy)

	if time then
		time = time + math.random(-timeEntropy, timeEntropy)
	end
	if mc.field_71476_x == nil then
		asyncLook(curYaw, newYaw, curPitch, newPitch, time)
		disable(timeout)
	end
end
return { cb = noiser, options = { saveState = false } }
