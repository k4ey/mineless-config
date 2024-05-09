--- WE ASSUME ALL THE AREAS ARE ABSOLUTE!
---comment
---@param self any
---@param args {[1]:string}
local function areaSwitcher(self, args)
    local areaName = table.unpack(args)

    MacroCreator.api.loadAreas(areaName)
    coroutine.yield()
end

return {cb = areaSwitcher, options = {}}
