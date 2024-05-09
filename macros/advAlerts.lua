local playMCSound = _G.libs.playMCSound
local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

local function isSuffocating()
	local x, y, z = getPlayerBlockPos()
	local block = getBlock(x, y, z)
	return block and block.name ~= "Air"
end
local webhook =
	"https://discord.com/api/webhooks/1206951173735710740/hVNVREGW767dqlz3QsqIoV9MjCKiN-PAKNMNEOJNx01O13X4mDNUJhgQKoO_Hx1-gKoc"
function sendWebhook(text, flags, mentions)
	local json = _G.libs.json
	local httpQuick = _G["require"]("httpQuick")

	local embeds = {}
	local i = 0
	flags = flags or {}
	mentions = mentions or {}
	for k, v in pairs(flags) do
		table.insert(embeds, {
			name = k,
			value = v and "X" or "O",
			inline = i <= 1,
		})
		i = i + 1
		if i == 2 then
			i = 0
		end
	end
	local mentionEmbed = {}
	for k, v in pairs(mentions) do
		table.insert(mentionEmbed, {
			description = tostring(v),
			color = math.random(0, 0xFFFFFF),
		})
	end

	local jobj = {
		content = tostring(text),
		username = "mineless",
		embeds = { { fields = embeds }, table.unpack(mentionEmbed) },
	}

	local req = {
		out = json.encode(jobj),
		type = "application/json",
	}

	pcall(function()
		local res = httpQuick(webhook .. "?wait=true", req)
	end)
end

local function alert(severity)
	if severity == "panic" then
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
			log("&4The bot has been tped out of the mine, panicking out in case that was an &cadmin!!!")
		end)
		MacroCreator.api.toggleBot()
	elseif severity == "reset" then
		log("&c something is wrong, restting my position")
		jump()
		MOLEBOT_G.measurements.times.justStarted = 0
		MOLEBOT_G.measurements.timestamps.justStarted = os.clock()
		if MOLEBOT_G.resetCommand then
			say(MOLEBOT_G.resetCommand)
		else
			log("&4[MOLEBOT] &c| No reset command specified!")
		end
	end
end

local function checkConditions()
	local measurements = MOLEBOT_G.measurements
	local flags = {
		idle = measurements.times.idle > 10,
		lastBlockBreak = measurements.times.lastBlockBreak > 10,
		efficiency = measurements.times.efficiency > 10,
		longTermEfficiency = measurements.times.efficiency > 50,
		-- entityCountChanged = measurements.times.entityCountChanged < 20,
		positionDrasticChange = measurements.times.positionDrasticChange < 5,
		dimensionChanged = measurements.times.dimensionChanged > 1000000000, -- this is unused for now
		mentioned = measurements.times.mentioned < 120,
		justStarted = measurements.times.justStarted < 130,
		isSuffocating = isSuffocating(),
		isOutside = not MOLEBOT_G.isInsideAreas,
		inventoryChanged = measurements.times.inventoryChanged < 2,
		inventoryDrasticChange = measurements.times.inventoryDrasticChange < 20,
		outsideMine = measurements.times.isOutsideMine < 5,
		doesNotSeeCorners = measurements.times.seesCorners > 2,
	}
	MacroCreator.hud:updateFlags(flags)

	if flags.isSuffocating then -- something broke, should better reset
		sendWebhook("I am suffocating!")
		log("&c i am suffocating! unburrowing")
		alert("reset")
	end

	if flags.doesNotSeeCorners then
		log("&c there are mine corners! i had been tped out!")
		sendWebhook("no corners!", flags, { "position:", table.concat({ getPlayerBlockPos() }, ",") })
		alert("panic")
	end

	if flags.justStarted then -- to recent to care
		return
	end
	if flags.mentioned and (flags.idle or flags.lastBlockBreak or flags.positionDrasticChange or flags.isOutside) then -- has been mentioned and is idle
		sendWebhook("someone has mentioned you!", flags, MOLEBOT_G.lastMessages)
		log("&cmentioned me!!!")
		alert("panic")
	-- elseif flags.inventoryDrasticChange then
	-- 	log("&c my inventory changed drastically")
	-- 	sendWebhook("something strange happened to your inventory!", flags)
	-- 	alert("panic")
	elseif flags.outsideMine then
		log("&c outside of the mine")
		sendWebhook("you went outside the mine!", flags, { "position:", table.concat({ getPlayerBlockPos() }, ",") })
		alert("panic")
	elseif flags.positionDrasticChange and flags.isOutside then -- has been teleported out
		log("&csomeone tped me!!")
		sendWebhook("someone has tped you!", flags, { "position:", table.concat({ getPlayerBlockPos() }, ",") })
		alert("panic")
	elseif flags.idle and flags.efficiency then -- has been idle for too long
		log("&cI'm idle and not efficient")
		sendWebhook("I'm idle and not efficient", flags)
		alert("reset")
	elseif flags.longTermEfficiency then -- something broke, should better reset
		log("&cIm waaaay to inefficient")
		sendWebhook("waaaay to inefficient", flags)
		alert("reset")
	elseif flags.isOutside and flags.efficiency then
		log("&cwent outside of the area")
		sendWebhook("exited the area!", flags, { "position:", table.concat({ getPlayerBlockPos() }, ",") })
		alert("reset")
	end
end

local function advAlerts(_, args)
	local resetCommand = args and args.resetCommand ~= "/derive" and args.resetCommand or MOLEBOT_G.resetCommand
	if resetCommand == "/derive" then
		log("deriving the rest command from last tped to area")
	elseif not resetCommand or tostring(resetCommand):find("^/") then
		log("there is no command specified for reseting!!!!")
	end
	MOLEBOT_G.resetCommand = resetCommand
	webhook = args and args.webhook or webhook
	log(
		"&c&B [MINELESS] | &f&cAlerts are currently broken, gonna be resolved in the next version. (they probably do work but i cannot confirm ;d)"
	)
	while true do
		checkConditions()
		asyncSleepClock(1000)
	end
end
return { cb = advAlerts, options = { saveState = true } }
