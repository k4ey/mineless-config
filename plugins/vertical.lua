local ip = getWorld().ip
if ip == "oplegends.net" then
  local x, y, z = getPlayerBlockPos()
  MacroCreator.api.loadResizableArea("vertical.lua", { x, y - 10, z }, nil)
  return
end
MacroCreator.api.loadResizableArea("vertical.lua", nil, nil)
