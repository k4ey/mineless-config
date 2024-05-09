return {
	AreaMacro.new({ 0, 0, 0 }, { 10, 10, 10 }, {
		["id"] = "tester",
		["defaultCallbacksNames"] = {
			[1] = "sayCommands",
		},
		["callbackArgs"] = {
			sayCommands = {
				commands = { "kurwa", "/kurwa mac ", "jAPIEROLDE" },
				interval = 1000,
				delay = 10,
			},
		},
		color = "gray",
	}),
	-- AreaMacro.new({ 0, 0, 0 }, { 10, 10, 10 }, {
	-- 	["id"] = "tester",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "gray",
	-- }),
	-- AreaMacro.new({ 2, 0, 0 }, { 8, 10, 2 }, {
	-- 	["id"] = "depther",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "pink",
	-- }),
	-- AreaMacro.new({ 8, 0, 2 }, { 10, 10, 8 }, {
	-- 	["id"] = "widtherx",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "green",
	-- }),
	-- AreaMacro.new({ 2, 0, 8 }, { 8, 10, 10 }, {
	-- 	["id"] = "deptherz",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "red",
	-- }),
	-- AreaMacro.new({ 0, 0, 2 }, { 2, 10, 8 }, {
	-- 	["id"] = "widther",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "lime",
	-- }),
	-- AreaMacro.new({ 0, 0, 0 }, { 2, 10, 2 }, {
	-- 	["id"] = "corner1",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "blue",
	-- }),
	-- AreaMacro.new({ 8, 0, 8 }, { 10, 10, 10 }, {
	-- 	["id"] = "corner2",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "white",
	-- }),
	-- AreaMacro.new({ 8, 0, 0 }, { 10, 10, 2 }, {
	-- 	["id"] = "corner3",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "orange",
	-- }),
	-- AreaMacro.new({ 0, 0, 8 }, { 2, 10, 10 }, {
	-- 	["id"] = "corner4",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "black",
	-- }),
	-- AreaMacro.new({ 5, 5, 5 }, { 5, 5, 5 }, {
	-- 	["id"] = "center",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "cyan",
	-- }),
	-- AreaMacro.new({ 4, 5, 4 }, { 4, 5, 4 }, {
	-- 	["id"] = "center2",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "blue",
	-- }),
	-- AreaMacro.new({ 3, 5, 3 }, { 7, 5, 7 }, {
	-- 	["id"] = "center3",
	-- 	["defaultCallbacksNames"] = {
	-- 		[1] = "perfcheck",
	-- 	},
	-- 	["callbackArgs"] = {},
	-- 	color = "purple",
	-- }),
}
