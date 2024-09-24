local overridedSize = MacroCreator.api.getSettings("overrideSize", "running")
if type(overridedSize) == "table" then
  MacroCreator.api.loadConstantSizeArea("running.lua", table.unpack(overridedSize))
  return
end

local ip = getWorld().ip
if ip == "oplegends.net" then
  local x, y, z = getPlayerBlockPos()
  MacroCreator.api.loadResizableArea("running.lua", { x, y - 10, z }, nil)
  return
end
MacroCreator.api.loadResizableArea("running.lua", nil, nil)
