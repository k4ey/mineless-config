local overridedSize = MacroCreator.api.getSettings("overrideSize", "vertical")
if type(overridedSize) == "table" then
  MacroCreator.api.loadConstantSizeArea("vertical.lua", table.unpack(overridedSize))
  return
end

local ip = getWorld().ip
if ip == "oplegends.net" then
  local x, y, z = getPlayerBlockPos()
  MacroCreator.api.loadResizableArea("vertical.lua", { x, y - 10, z }, nil)
  return
end
MacroCreator.api.loadResizableArea("vertical.lua", nil, nil)
