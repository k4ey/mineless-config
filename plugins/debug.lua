MacroCreator.api.loadAreas("pathfinder.lua")
local editManager = MacroCreator.api.getEditManager()
local areaManager = MacroCreator.api.getAreaManager()
local areas = areaManager:getAllAreas()
local checkPosition = { getPlayerBlockPos() }
local _, _, sizes = editManager:getSizeOfMine("Bedrock", checkPosition)
local y = editManager:getHeightOfMine("Bedrock", checkPosition)
local anchors = {
	main = { x = true, z = true, y = true },
}

for id, areaMacro in pairs(areas) do
	local transformed = editManager.transformArea(areaMacro.area, { 1000, 100, 1000 }, {
		width = sizes["x+"] + sizes["x-"],
		height = y.y + 10,
		depth = sizes["z+"] + sizes["z-"],
		oldWidth = 10,
		oldHeight = 10,
		oldDepth = 10,
	}, anchors[id] or {})
	local corners = editManager:deriveCorners()
	local _, py, _ = getPlayerBlockPos()
	local corner = { corners[1][1], py - y.y, corners[1][2] }
	local area = editManager.denormalizeArea(transformed, corner)
	areas[id].area = area
end
areaManager.areas = areas
MacroCreator.api.showAreas()
