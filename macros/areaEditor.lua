--- changes callbacks of given area
---@param self any
---@param args {string:string[]}
local function areaEditor(self, args)
	local callbackManager = MacroCreator.api.getCallbackManager()
	local areaCallbacks = args.callbacks
	local areaArgs = args.args
	local area
	for id, callbacks in pairs(areaCallbacks) do
		area = MacroCreator.api.getAreaManager():getAreaById(id)
		area.defaultCallbacksNames = callbacks
		area.callbackArgs = areaArgs[id]
		area.callbacks = {}
		callbackManager:loadDefaultCallbacks(area)
	end
end

return { cb = areaEditor, options = {} }
