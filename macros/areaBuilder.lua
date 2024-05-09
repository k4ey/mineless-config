local function byDirection(editManager, areaMacro, data)
	local direction = data.direction
	local blocks = data.blocks

	editManager.adjustment = "decrease"
	local expand = editManager:translateDirections(direction, blocks)
	areaMacro.area:translate(table.unpack(expand))
end

---@alias direction "UP" | "LEFT" | "RIGHT" | "DOWN" | "I" | "O"
---@alias areaid string
--- Changes the sizes of areas. We will see how this goes...
---@param self any
---@param args {areaid:{direction:direction, blocks:number}}
local function areaBuilder(self, args)
	local areaData = args
	for id, data in pairs(areaData) do
		local editManager = MacroCreator.api.getEditManager()
		local areaMacro = assert(MacroCreator.api.getAreaManager():getAreaById(id), "Area not found")
		if data.direction and data.blocks then
			byDirection(editManager, areaMacro, data)
		end
	end
	MacroCreator.api.showAreas()
end

return { cb = areaBuilder, options = {} }
