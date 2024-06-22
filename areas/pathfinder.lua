return {
	AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
		id = "main",
		defaultCallbacksNames = {
			"perfcheck",
			"pathfinder",
		},
		callbackArgs = {},
		requirements = {
			pathfinder = function()
				return true
			end,
		},
		color = "black",
	}),
}
