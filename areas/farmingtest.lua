return {

	AreaMacro.new({ 35, 53, 70 }, { 35, 53, 100 }, {
		["id"] = "alignerLeft",
		["defaultCallbacksNames"] = {
			"alignPathNotBlock",
			"mine",
			"goForward",
		},
		["callbackArgs"] = {

			alignPathNotBlock = {
				direction = "right",
			},
		},
		color = "black",
	}),
	AreaMacro.new({ 34, 53, 70 }, { 34, 53, 100 }, {

		["id"] = "alignerRight",
		["defaultCallbacksNames"] = {
			"alignPathNotBlock",
			"goForward",
			"mine",
		},
		["callbackArgs"] = {
			alignPathNotBlock = {
				direction = "left",
			},
		},
		color = "gray",
	}),
	AreaMacro.new({ 34, 53, 100 }, { 35, 53, 100 }, {

		["id"] = "comebacker",
		["defaultCallbacksNames"] = {
			"gotoArea",
		},
		["callbackArgs"] = {
			gotoArea = {
				areaId = "pluginRunner",
			},
		},
		color = "green",
	}),
	AreaMacro.new({ 40, 53, 70 }, { 40, 53, 70 }, {

		type = "once",
		["id"] = "pluginRunner",
		["defaultCallbacksNames"] = {
			"runPlugin",
		},
		["callbackArgs"] = {
			runPlugin = {
				pluginPath = "farming.lua",
			},
		},
		color = "green",
	}),
}
