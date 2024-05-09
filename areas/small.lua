return {
	AreaMacro.new({ 0, 0, 0 }, { 160, 170, 160 }, {
		["id"] = "aligner",
		["defaultCallbacksNames"] = {
			[3] = "alignHeight",
			[1] = "ensureFlying",
			[2] = "incrementer",
			[4] = "mine",
			--[5] = "upgrader" -- upgrades! uncomment to apply, look inside upgrader.lua for more info
		},
		["callbackArgs"] = {
			["alignHeight"] = {
				["radius"] = 30,
			},
		},
	}),

	AreaMacro.new({ 0, 0, 0 }, { 160, 170, 160 }, {
		["id"] = "forwarder",
		["defaultCallbacksNames"] = {
			[2] = "betterLook",
			[1] = "goForward",
			[4] = "bpsCounter",
			--[3] = "sayCommands", -- uncomment if you want to periodically say some commands
		},
		["callbackArgs"] = {
			["goForward"] = {
				["sprint"] = true,
			},
			["sayCommands"] = {
				-- input the commands you want here
				commands = { "/firstCommadn", "/secondCommand" },
				-- interval
				interval = 10000,
				-- delay between each command
				delay = 10,
			},
		},
	}),

	AreaMacro.new({ 21, 0, 21 }, { 139, 170, 139 }, {
		["id"] = "insider",
		color = "white",
		["defaultCallbacksNames"] = {
			[1] = "alignPath",
			[2] = "noiser",
		},
		["callbackArgs"] = {
			noiser = {
				time = 1000,
				timeout = 600,
				timeEntropy = 500,
				yawEntropy = 100,
			},
		},
	}),

	AreaMacro.new({ 79, 0, 151 }, { 81, 170, 161 }, {
		["id"] = "lookdowner",
		["defaultCallbacksNames"] = {
			[1] = "alignHeight",
			[2] = "goForward",
			[3] = "betterLook",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				["yaw"] = "north",
			},
		},
	}),

	AreaMacro.new({ 79, 0, 165 }, { 81, 170, 168 }, {
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

	AreaMacro.new({ 20, 0, 140 }, { 140, 170, 160 }, {
		color = "lime",
		["id"] = "southTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "north",
			},
		},
	}),

	AreaMacro.new({ 140, 0, 20 }, { 160, 170, 140 }, {
		color = "pink",
		["id"] = "eastTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "west",
			},
		},
	}),

	AreaMacro.new({ 20, 0, 0 }, { 140, 170, 20 }, {
		color = "green",
		["id"] = "northTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "south",
			},
		},
	}),

	AreaMacro.new({ 0, 0, 20 }, { 20, 170, 140 }, {
		color = "red",
		["id"] = "westTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "east",
			},
		},
	}),

	AreaMacro.new({ 140, 0, 20 }, { 160, 170, 0 }, {
		color = "cyan",
		["id"] = "northEastTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "southWest",
			},
		},
	}),
	AreaMacro.new({ 140, 0, 140 }, { 160, 170, 160 }, {
		color = "magenta",
		["id"] = "southEastTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "northWest",
			},
		},
	}),
	AreaMacro.new({ 20, 0, 140 }, { 0, 170, 160 }, {
		color = "blue",
		["id"] = "southWestTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "northEast",
			},
		},
	}),
	AreaMacro.new({ 20, 0, 20 }, { 0, 170, 0 }, {
		color = "pink",
		["id"] = "northWestTurner",
		["defaultCallbacksNames"] = {
			[1] = "betterLook",
			[2] = "autoAlign",
		},
		["callbackArgs"] = {
			["betterLook"] = {
				["pitch"] = "fdown",
				["time"] = 700,
				yawEntropy = 10,
				timeEntropy = 100,
				["yaw"] = "southEast",
			},
		},
	}),
}
