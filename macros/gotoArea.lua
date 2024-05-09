local function gotoPos(Baritone, x, y, z)
	local blockPos = luajava.newInstance("net.minecraft.util.math.BlockPos", x, y, z)
	local ICustomGoalProcess = Baritone:getCustomGoalProcess()
	local goal = luajava.newInstance("baritone.api.pathing.goals.GoalNear", blockPos, 0.3)
	ICustomGoalProcess:setGoalAndPath(goal)
end

---goes to the areaId center by default
---@param self any
---@param args {areaId: string, positionWithin: "minCorner"|"center"|"maxCorner"}
local function gotoArea(self, args)
	local areaId = assert(args.areaId, "no area to go to")
	local area = MacroCreator.api.getAreaManager():getAreaById(areaId)
	local positionWithin = args.positionWithin or "center"
	local Baritone = luajava.bindClass("baritone.api.BaritoneAPI")
	assert(area, "no area with such id")
	assert(Baritone, "Baritone not found")
	Baritone = Baritone:getProvider():getPrimaryBaritone()

	local position
	if positionWithin == "center" then
		position = area.area:getCenter()
	elseif positionWithin == "minCorner" then
		position = { area.area.minX, area.area.minY, area.area.minZ }
	elseif positionWithin == "maxCorner" then
		position = { area.area.maxX, area.area.maxY, area.area.maxZ }
	end
	gotoPos(Baritone, table.unpack(position))
end

return { cb = gotoArea, options = {} }
