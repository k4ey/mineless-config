local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function changePositionOfArea(areaId, position)
	local area = MacroCreator.api.getAreaManager():getAreaById(areaId)
	assert(area, "Area not found")
	MacroCreator.api.moveArea(area, position)
end

local function changeGoal(areaId, currentGoal, points)
	local areaEnv = _G["MacroCreatorAreaGlobals:" .. areaId]
	areaEnv.currentGoal = (currentGoal % #points) + 1
end

local function getGoal(areaId)
	local areaEnv = _G["MacroCreatorAreaGlobals:" .. areaId]
	if not areaEnv then
		areaEnv = {}
		_G["MacroCreatorAreaGlobals:" .. areaId] = areaEnv
	end
	if not areaEnv.currentGoal then
		areaEnv.currentGoal = 1
	end
	return areaEnv.currentGoal
end

local function onReset() end
local function gotoPos(Baritone, x, y, z)
	local blockPos = luajava.newInstance("net.minecraft.util.math.BlockPos", x, y, z)
	local ICustomGoalProcess = Baritone:getCustomGoalProcess()
	local goal = luajava.newInstance("baritone.api.pathing.goals.GoalNear", blockPos, 0.3)
	ICustomGoalProcess:setGoalAndPath(goal)
end

---goes to the next position from points, if wrapAround false, then stops at the last point, else it goes to the beginning
---@param self any
---@param args {["points"]: Point[], ["wrapAround"]: boolean}
local function queuePos(self, args)
	local points = assert(args.points, "no points to go to")
	local goal = assert(getGoal(self.areaId), "no goal found")
	local Baritone = luajava.bindClass("baritone.api.BaritoneAPI")
	assert(Baritone, "Baritone not found")
	Baritone = Baritone:getProvider():getPrimaryBaritone()

	local position = points[goal]
	for k, v in pairs(position) do
		position[k] = math.floor(v)
	end
	changePositionOfArea(self.areaId, position)
	if not args.wrapAround then
		changeGoal(self.areaId, goal, points)
		if goal == 1 and #points ~= 1 then
			return
		end
		gotoPos(Baritone, table.unpack(position))
	end
end

return { cb = queuePos, options = { onReset = onReset } }
