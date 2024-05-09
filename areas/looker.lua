return {

	AreaMacro.new({ -31, 54, -115 }, { -28, 54, -115 }, {
		["raytraceable"] = true,
		["id"] = "placer",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "schematic",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = 90,
				["time"] = 250,
				["yaw"] = 90,
			},
			["schematic"] = {
				["blockName"] = "Dirt",
			},
		},
	}),

	AreaMacro.new({ -28, 54, -115 }, { -28, 54, -115 }, {
		["raytraceable"] = true,
		["id"] = "lefter",
		["defaultCallbacksNames"] = {
			[1] = "goLeft",
		},
		["callbackArgs"] = {},
	}),

	AreaMacro.new({ -31, 54, -114 }, { -28, 55, -114 }, {
		["raytraceable"] = true,
		["id"] = "aligner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = 22,
				["time"] = 250,
				["yaw"] = 90,
			},
		},
	}),

	AreaMacro.new({ -32, 55, -114 }, { -32, 55, -114 }, {
		["raytraceable"] = true,
		["id"] = "builder",
		["defaultCallbacksNames"] = {
			[1] = "areaBuilder",
		},
		["callbackArgs"] = {
			["areaBuilder"] = {
				["placer"] = {
					["direction"] = "LEFT",
					["blocks"] = 1,
				},
				["aligner"] = {
					["direction"] = "LEFT",
					["blocks"] = 1,
				},
				["starterplacer"] = {
					["direction"] = "LEFT",
					["blocks"] = 1,
				},
				["builder"] = {
					["direction"] = "LEFT",
					["blocks"] = 1,
				},
				["lefter"] = {
					["direction"] = "LEFT",
					["blocks"] = 1,
				},
			},
		},
	}),

	AreaMacro.new({ -32, 55, -115 }, { -31, 55, -115 }, {
		["raytraceable"] = true,
		["id"] = "starterplacer",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = 32,
				["time"] = 250,
				["yaw"] = 90,
			},
		},
	}),

	AreaMacro.new({ -28, 55, -115 }, { -28, 55, -115 }, {
		["type"] = "toggleable",
		["toggling"] = true,
		["id"] = "sneaker",
		["defaultCallbacksNames"] = {
			[1] = "sneak",
		},
		["callbackArgs"] = {},
	}),

	AreaMacro.new({ -28, 55, -116 }, { -25, 55, -116 }, {
		["id"] = "goBacker",
		["defaultCallbacksNames"] = {
			[1] = "goBack",
		},
		["callbackArgs"] = {},
	}),

	AreaMacro.new({ -28, 54, -116 }, { -25, 54, -116 }, {
		["raytraceable"] = true,
		["id"] = "backFiller",
		["defaultCallbacksNames"] = {
			[1] = "schematic",
		},
		["callbackArgs"] = {
			["schematic"] = {
				["blockName"] = "Dirt",
			},
		},
	}),

	AreaMacro.new({ -24, 55, -116 }, { -24, 55, -116 }, {
		["id"] = "switcher",
		type = "once",
		["defaultCallbacksNames"] = {
			[1] = "areaBuilder",
		},
		["callbackArgs"] = {
			["areaBuilder"] = {
				["placer"] = {},
				["aligner"] = {},
				["starterplacer"] = {},
				["builder"] = {},
				["lefter"] = {},
			},
		},
	}),

	AreaMacro.new({ -28, 55, -97 }, { -28, 55, -97 }, {
		["id"] = "13:06:16:4431",
		["type"] = "once",
		["callbackArgs"] = {
			queuePos = {
				points = {
					{ -27.5, 55, -96.5 },
					{ -27.5, 55, -115.5 },
				},
			},
		},
		["defaultCallbacksNames"] = {
			"queuePos",
		},
	}),
}

