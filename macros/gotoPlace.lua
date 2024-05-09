local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function onReset() end

local function gotoPos(Baritone, x, y, z)
	local blockPos = luajava.newInstance("net.minecraft.util.math.BlockPos", x, y, z)
	local ICustomGoalProcess = Baritone:getCustomGoalProcess()
	local goal = luajava.newInstance("baritone.api.pathing.goals.GoalNear", blockPos, 0.1)
	ICustomGoalProcess:setGoalAndPath(goal)
end
local goals = {
	loadPosition = function()
		return MacroCreator.api.getEditManager().loadPosition
	end,
}

---goes to the next position from points, if wrapAround false, then stops at the last point, else it goes to the beginning
---@param self any
---@param args {["place"]:string, ["offset"]:Point}
local function gotoPlace(self, args)
	local goal = assert(goals[args.place], "No such place: " .. args.place)()
	local offset = args.offset or { 0, 0, 0 }
	for i = 1, 3 do
		goal[i] = goal[i] + offset[i]
	end
	local Baritone = luajava.bindClass("baritone.api.BaritoneAPI")
	assert(Baritone, "Baritone not found")
	Baritone = Baritone:getProvider():getPrimaryBaritone()

	gotoPos(Baritone, table.unpack(goal))
end

return { cb = gotoPlace, options = { onReset = onReset } }
