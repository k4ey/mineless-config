return {

	AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
		["id"] = "perfmanager",
		["defaultCallbacksNames"] = {
			"perfcheck",
			"bpsCounter",
			"mine",
		},
		["callbackArgs"] = {
			-- {time:number?, timeout:number?, timeEntropy: number?, yawEntropy: number?, pitchEntropy:number?}
		},
		color = "black",
	}),
}
