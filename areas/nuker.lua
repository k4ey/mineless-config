return {

	AreaMacro.new({ -6, 54, 151 }, { 14, 54, 169 }, {
		["id"] = "forwarder",
		["defaultCallbacksNames"] = {
			[1] = "goForward",
		},
		["callbackArgs"] = {},
	}),

	AreaMacro.new({ -6, 54, 170 }, { 14, 54, 172 }, {
		["id"] = "south",
		["defaultCallbacksNames"] = {
			[3] = "nukerMiner",
			[1] = "goRight",
			[2] = "betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["time"] = 1000,
				["yaw"] = "north",
			},
		},
	}),

	AreaMacro.new({ -6, 54, 148 }, { 14, 54, 150 }, {
		["id"] = "north",
		["defaultCallbacksNames"] = {
			[3] = "nukerMiner",
			[1] = "goLeft",
			[2] = "betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["time"] = 1000,
				["yaw"] = "south",
			},
		},
	}),
}

