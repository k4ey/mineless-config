return {

	AreaMacro.new({ -29, 54, -112 }, { 10, 54, -75 }, {
		["raytraceable"] = true,
		["id"] = "12:15:12:1334",
		["defaultCallbacksNames"] = {
			[1] = "schematic",
		},
		["callbackArgs"] = {},
	}),
	AreaMacro.new({ -29, 55, -112 }, { -29, 55, -75 }, {
		["id"] = "12:15:12:11",
		["defaultCallbacksNames"] = {
			[1] = "areaSwitcher",
		},
		["callbackArgs"] = {
			areaSwitcher = { areaName = "perimeterFiller1" },
		},
	}),
	AreaMacro.new({ 10, 55, -112 }, { 10, 55, -75 }, {
		["id"] = "12:15:12:113",
		["defaultCallbacksNames"] = {
			[1] = "goLeft",
		},
	}),
}

