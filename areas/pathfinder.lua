return {
	AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
		id = "main",
		defaultCallbacksNames = {
			"perfcheck",
			"getToTop",
			"pathfinder",
		},
		callbackArgs = {},
		requirements = {
			pathfinder = function()
				return _G.MOLEBOT_G.pathfinderGoal
			end,
		},
		color = "black",
	}),
}
