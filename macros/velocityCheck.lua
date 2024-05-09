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

if not MOLEBOT_G.idleTime then
	MOLEBOT_G.idleTime = 0
end

local function isLoadingWorld()
	return luajava.getDeclaredFields(getMinecraft().field_71462_r)[1] == "customLoadingScreen"
end

local function isIdle()
	if isLoadingWorld() then
		return false
	end
	local player = getPlayer().velocity
	local velocity = 0
	for i = 1, 3 do
		velocity = velocity + math.abs(player[i])
	end
	return velocity < 0.5
end

local function alert(idleTime, panicAfter)
	if idleTime < panicAfter then
		return
	end
	playMCSound("ENTITY_WITHER_SPAWN")
	runThread(function()
		log("&cCROUCH &4TO TOGGLE")
		while not playerDetails.isSneaking() do
			pcall(playMCSound, "ENTITY_WITHER_SPAWN")
			pcall(function()
				getSound("~/macros/libs/sounds/ring.wav").play()
			end)
			sleep(500)
		end
		log("&4The bot has been stopped in case that was an &cadmin!!!")
	end)
	MacroCreator.api.toggleBot()
end

local function velocityCheck(self, args)
	local panicAfter = 5
	if args then
		panicAfter = args.panicAfter or 5
	end
	MOLEBOT_G.idleTime = os.clock()
	while true do
		local now = os.clock()
		local idleTime = now - MOLEBOT_G.idleTime
		-- log("idletime: ", idleTime)

		if isIdle() then
			alert(idleTime, panicAfter)
		else
			MOLEBOT_G.idleTime = now
		end
		asyncSleepClock(1000)
	end
end
return { cb = velocityCheck, options = { saveState = true } }
