local overridedSize = MacroCreator.api.getSettings("overrideSize", "horizontal")
if type(overridedSize) == "table" then
  logger.info("using overrided size! &ctoggle visibility to check if aligned correctly!")
  MacroCreator.api.loadConstantSizeArea("horizontal.lua", table.unpack(overridedSize))
  return
end

local minSize = 29
local ip = getWorld().ip
if ip == "oplegends.net" then
  local x, y, z = getPlayerBlockPos()
  MacroCreator.api.loadResizableArea("horizontal.lua", { x, y - 10, z }, nil)
else
  MacroCreator.api.loadResizableArea("horizontal.lua", nil, nil)
end
local size = MacroCreator.api.getEditManager().mineSize
if size <= minSize then
  toast("&c&B[MOLEBOT]", "Your mine is to small!")
  log("&cRequired size: &B" ..
    minSize .. " blocks for Horizontal.lua &cYou got &a&B" .. size .. ". &c Falling back to &Bvertical.lua &f")
  MacroCreator.api.runPlugin("vertical.lua")
end
