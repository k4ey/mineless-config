local playMCSound = _G.libs.playMCSound
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

if not MOLEBOT_G then
	MOLEBOT_G = {}
end

if not MOLEBOT_G.insideTimestamp then
	MOLEBOT_G.insideTimestamp = 0
end

local function goBackToMine(returnCommand)
	say(returnCommand)
	MOLEBOT_G.insideTimestamp = os.clock()
end
local function outsideArea(outsideTime, returnAfter, returnCommand)
	pcall(playMCSound, "ENTITY_HORSE_DEATH")
	pcall(function()
		getSound("~/macros/libs/sounds/ring2.wav").play()
	end)
	if returnCommand and outsideTime > returnAfter then
		goBackToMine(returnCommand)
	end
end

local function overseer(self, args)
	local returnCommand, returnAfter, outsideAfter = nil, nil, nil
	if args then
		returnCommand = args.returnCommand
		returnAfter = args.returnAfter or 10
		outsideAfter = args.outsideAfter or 5
	end
	while true do
		local now = os.clock()
		local outsideTime = now - MOLEBOT_G.insideTimestamp
		-- log("outside time:", outsideTime)
		if outsideTime > outsideAfter then
			outsideArea(outsideTime, returnAfter, returnCommand)
		end
		asyncSleepClock(1000)
	end
end
return { cb = overseer, options = { saveState = true } }
