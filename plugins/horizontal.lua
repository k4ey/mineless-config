MacroCreator.api.loadAreas("horizontal.lua")
local minSize = 29
local editManager = MacroCreator.api.getEditManager()
local areaManager = MacroCreator.api.getAreaManager()
local areas = areaManager:getAllAreas()
local checkPosition = { getPlayerBlockPos() }
local _, _, sizes = editManager:getSizeOfMine("Bedrock", checkPosition)
local width = sizes["x+"] + sizes["x-"]
local depth = sizes["z+"] + sizes["z-"]

if width <= minSize or depth <= minSize then
  toast("&c&B[MOLEBOT]", "Your mine is to small!")
end
assert(width >= minSize,
  "&cRequired size: &B" .. minSize .. " blocks &cYou got &a&B" .. width .. ". &c Use &Bvertical.lua &f")
assert(depth >= minSize,
  "&cRequired size: &B" .. minSize .. " blocks &cYou got &a&B" .. depth .. ". &c Use &Bvertical.lua &f")

local heights = editManager:getHeightOfMine("Bedrock", checkPosition)
local anchors = {
  forwarder = { x = true, z = true, y = true },
  aligner = { x = true, z = true, y = true },
  insider = { x = true, z = true, y = true },

  lookdowner = { x = true, z = true, y = true, w = true, h = true, d = true },
  timeouter = { x = true, z = true, y = true, w = true, h = true, d = true },

  southTurner = { y = true, h = true, w = false, x = true, d = true },
  northTurner = { x = true, z = true, y = true, h = true, d = true },

  eastTurner = { y = true, h = true, z = true, w = true },
  westTurner = { y = true, h = true, z = true, x = true, w = true },

  northEastTurner = { y = true, h = true, z = true, w = true, d = true },
  northWestTurner = { y = true, h = true, z = true, x = true, w = true, d = true },

  southEastTurner = { y = true, h = true, z = false, w = true, d = true },
  southWestTurner = { y = true, h = true, x = true, z = false, w = true, d = true },
}

for id, areaMacro in pairs(areas) do
  local transformed = editManager.transformArea(areaMacro.area, { 0, 0, 0 }, {
    width = sizes["x+"] + sizes["x-"],
    height = heights.y,
    depth = sizes["z+"] + sizes["z-"],
    oldWidth = 160,
    oldHeight = 160,
    oldDepth = 160,
  }, anchors[id] or {})
  local corners = editManager:deriveCorners()
  local corner = { corners[1][1], heights.y - heights["y-"], corners[1][2] }
  local area = editManager.denormalizeArea(transformed, corner)
  areas[id].area = area
end
areaManager.areas = areas
hud3D.clearAll()
MacroCreator.api.setLoadedArea("horizontal")
