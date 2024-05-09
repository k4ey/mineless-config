local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
---@param self any
---@param args {pluginPath:string}
local function areaBuilder(self, args)
	MacroCreator.api.runPlugin(args.pluginPath)
end

return { cb = areaBuilder, options = {} }
