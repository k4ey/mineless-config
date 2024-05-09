local delayEntropy = 150
local delay = 100
return {
	AreaMacro.new({ 1000, 111, 1000 }, { 1010, 130, 1010 }, {
		["id"] = "downer",
		color = "white",
		["defaultCallbacksNames"] = {
			"ensureNotFlying",
		},
		["callbackArgs"] = {},
	}),

	AreaMacro.new({ 999, 111, 999 }, { 1011, 111, 1011 }, {
		["id"] = "jumper",
		color = "cyan",
		["defaultCallbacksNames"] = {
			[1] = "getInHole",
		},
		["callbackArgs"] = {},
	}),

	AreaMacro.new({ 1000, 114, 1000 }, { 1000, 114, 1000 }, {
		["type"] = "toggleable",
		["toggling"] = true,
		["id"] = "timeouter",
		["defaultCallbacksNames"] = {
			[1] = "measurer",
			[2] = "advAlerts",
			[3] = "bpsCounter",
		},
		["callbackArgs"] = {
			["advAlerts"] = {
				["resetCommand"] = "/derive",
				["webhook"] = "https://discord.com/api/webhooks/1206951173735710740/hVNVREGW767dqlz3QsqIoV9MjCKiN-PAKNMNEOJNx01O13X4mDNUJhgQKoO_Hx1-gKoc",
			},
		},
	}),

	AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
		["id"] = "forwarder",
		["defaultCallbacksNames"] = {
			"goLeft",
			-- "sneak",
			"ensureFlying",
			"mine",
			"moveToWall",
			"bpsCounter",
			"alignHeightVerticalMine",
		},
		["callbackArgs"] = {
			alignHeightVerticalMine = {
				direction = "down",
			},
		},
	}),
	AreaMacro.new({ 1000, 109, 1000 }, { 1010, 109, 1010 }, {
		["id"] = "switcherDown",
		["defaultCallbacksNames"] = {
			-- "resetMine",
			"areaEditor",
		},
		["callbackArgs"] = {
			-- resetMine = {
			-- 	resetMineCommand = "/derive",
			-- },
			areaEditor = {
				callbacks = {
					["forwarder"] = {
						"goLeft",
						"alignHeightVerticalMine",
						-- "sneak",
						"ensureFlying",
						"mine",
						"moveToWall",
						"bpsCounter",
					},
				},
				args = {
					forwarder = {
						alignHeightVerticalMine = {
							direction = "down",
						},
					},
				},
			},
		},
		color = "black",
		type = "once",
	}),
	AreaMacro.new({ 1000, 101, 1000 }, { 1010, 102, 1010 }, {
		["id"] = "switcherUp",
		["defaultCallbacksNames"] = {
			-- "resetMine",
			"areaEditor",
		},
		["callbackArgs"] = {
			-- resetMine = {
			-- 	resetMineCommand = "/derive",
			-- },
			areaEditor = {
				callbacks = {
					["forwarder"] = {
						"goLeft",
						-- "goUp",
						"alignHeightVerticalMine",
						"mine",
						"ensureFlying",
						"moveToWall",

						"bpsCounter",
					},
				},
				args = {
					forwarder = {
						alignHeightVerticalMine = {
							direction = "up",
						},
					},
				},
			},
		},
		color = "black",
		type = "once",
	}),
	-- --
	AreaMacro.new({ 1009, 100, 1009 }, { 1009, 110, 1009 }, {
		["id"] = "southEast",
		["defaultCallbacksNames"] = {
			"betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["time"] = 350,
				["yaw"] = "north",
				timeEntropy = 100,
				pitch = "forward",
				delay = delay,
				delayEntropy = delayEntropy,
			},
		},
		color = "red",
	}),
	AreaMacro.new({ 1001, 100, 1009 }, { 1001, 110, 1009 }, {
		["id"] = "southWest",
		["defaultCallbacksNames"] = {
			"betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				pitch = "forward",
				timeEntropy = 200,
				["time"] = 350,
				["yaw"] = "east",
				delay = delay,
				delayEntropy = delayEntropy,
			},
		},
		color = "pink",
	}),
	AreaMacro.new({ 1001, 100, 1001 }, { 1001, 110, 1001 }, {
		["id"] = "northWest",
		["defaultCallbacksNames"] = {
			"betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				pitch = "forward",
				timeEntropy = 100,
				["time"] = 350,
				["yaw"] = "south",
				delay = delay,
				delayEntropy = delayEntropy,
			},
		},
		color = "blue",
	}),
	AreaMacro.new({ 1009, 100, 1001 }, { 1009, 110, 1001 }, {
		["id"] = "northEast",
		["defaultCallbacksNames"] = {
			"betterLook",
			"sayCommands", -- uncomment if you want to periodically say some commands
			-- "upgrader",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				pitch = "forward",
				["time"] = 350,
				timeEntropy = 100,
				["yaw"] = "west",
				delay = delay,
				delayEntropy = delayEntropy,
			},
			sayCommands = {
				commands = { "/pmine reset" },
				interval = 60000,
			},
		},
		color = "cyan",
	}),
}
