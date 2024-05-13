local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
--- runs given plugin
---@param self any
---@param args {pluginPath: string, delay: number, shouldRun: function, args: table}
local function pluginRunner(self, args)
	if
		args.shouldRun({
			getPlayerBlockPos = getPlayerBlockPos,
			api = MacroCreator.api,
			getBlockName = getBlockName,
			table = table,
		})
	then
		log("&c&L[MINELESS]", "running plugin : " .. args.pluginPath)
		MacroCreator.api.runPlugin(args.pluginPath, table.unpack(args))
	end
	asyncSleepClock(args.delay or 5000)
end

return { cb = pluginRunner, options = {} }
