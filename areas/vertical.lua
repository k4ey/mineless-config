local delayEntropy = 150
local delay = 100

--- determines whether plugin should be ran based on condition
-- currently does not work so ignore this
local pluginRunnerArgs = {
	pluginPath = "vertical.lua",
	delay = 5000,
	shouldRun = function(env)
		---@type EditManager
		local editManager = env.api.getEditManager()
		local wall = editManager.wallCoords["+x"]
		return editManager.wallCoords["+x"] and env.getBlockName(env.table.unpack(wall)) ~= "Bedrock"
	end,
}

local forwarderArgsDown = {
	alignHeightVerticalMine = {
		direction = "down",
	},
	-- pluginRunner = pluginRunnerArgs,
}
local forwarderArgsUp = {
	alignHeightVerticalMine = {
		direction = "up",
	},
	-- pluginRunner = pluginRunnerArgs,
}

local forwarderCallbacks = {
	"goLeft",
	"alignHeightVerticalMine",
	"mine",
	"ensureFlying",
	"moveToWall",
	"bpsCounter",
	-- "pluginRunner",
}
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

	AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
		["id"] = "forwarder",
		["defaultCallbacksNames"] = forwarderCallbacks,
		["callbackArgs"] = forwarderArgsDown,
	}),
	AreaMacro.new({ 1000, 109, 1000 }, { 1010, 109, 1010 }, {
		["id"] = "switcherDown",
		["defaultCallbacksNames"] = {
			"areaEditor",
		},
		["callbackArgs"] = {
			areaEditor = {
				callbacks = {
					forwarder = forwarderCallbacks,
				},
				args = {
					forwarder = forwarderArgsDown,
				},
			},
		},
		color = "black",
		type = "once",
	}),
	AreaMacro.new({ 1000, 101, 1000 }, { 1010, 102, 1010 }, {
		["id"] = "switcherUp",
		["defaultCallbacksNames"] = {
			"areaEditor",
		},
		["callbackArgs"] = {
			areaEditor = {
				callbacks = {
					forwarder = forwarderCallbacks,
				},
				args = {
					forwarder = forwarderArgsUp,
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
