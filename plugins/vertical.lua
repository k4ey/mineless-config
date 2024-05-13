local silent = ...
MacroCreator.api.loadAreas("vertical.lua")
local editManager = MacroCreator.api.getEditManager()
local areaManager = MacroCreator.api.getAreaManager()
local areas = areaManager:getAllAreas()
local checkPosition = { getPlayerBlockPos() }
local _, _, sizes = editManager:getSizeOfMine("Bedrock", checkPosition)
local heights = editManager:getHeightOfMine("Bedrock", checkPosition)
local anchors = {
	downer = { w = false, d = false, h = true, x = true, z = true, y = false },
	jumper = { w = false, d = false, h = true, x = true, z = true },
	timeouter = { w = true, d = true, h = true },
	forwarder = { x = true, z = true, y = true },
	switcherDown = { x = true, z = true, h = true },
	switcherUp = { x = true, z = true, h = true, y = true },
	northWest = { x = true, z = true, w = true, d = true, y = true },
	northEast = { x = false, z = true, w = true, d = true, y = true },
	southWest = { x = true, z = false, w = true, d = true, y = true },
	southEast = { x = false, z = false, w = true, d = true, y = true },
}

for id, areaMacro in pairs(areas) do
	local transformed = editManager.transformArea(areaMacro.area, { 1000, 100, 1000 }, {
		width = sizes["x+"] + sizes["x-"],
		height = heights.h,
		depth = sizes["z+"] + sizes["z-"],
		oldWidth = 10,
		oldHeight = 10,
		oldDepth = 10,
	}, anchors[id] or {})
	local corners = editManager:deriveCorners()
	local corner = { corners[1][1], heights.y - heights["y-"], corners[1][2] }
	local area = editManager.denormalizeArea(transformed, corner)
	areas[id].area = area
end
areaManager.areas = areas
hud3D.clearAll()
MacroCreator.api.setLoadedArea("vertical")
