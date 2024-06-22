return {

	AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
		["id"] = "perfmanager",
		["defaultCallbacksNames"] = {
			-- "reqCheck",
			"perfcheck",
			-- "bpsCounter",
			-- "mine",
		},
		["callbackArgs"] = {
			alignHeight = {},
		},
		requirements = {
			reqCheck = function()
				return math.random(1, 1000)
			end,
		},
		color = "black",
	}),
}
