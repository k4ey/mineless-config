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

if not MOLEBOT_G.specialBlockTimestamp then
	MOLEBOT_G.specialBlockTimestamp = 0
end

local function parseCoords(coords)
	local x, y, z = getPlayerBlockPos()
	if type(coords[1]) == "string" then
		x = x + (tonumber(string.sub(coords[1], 2)) or 0)
	else
		x = coords[1]
	end
	if type(coords[2]) == "string" then
		y = y + (tonumber(string.sub(coords[2], 2)) or 0)
	else
		y = coords[2]
	end
	if type(coords[3]) == "string" then
		z = z + (tonumber(string.sub(coords[3], 2)) or 0)
	else
		z = coords[3]
	end
	return x, y, z
end
local function canSeeSpecialBlock(specialBlock)
	local x, y, z = parseCoords(specialBlock.coords)
	-- log(x,y,z)
	local block = getBlock(x, y, z)
	return block and block.name == specialBlock.name
end
local function isLoadingWorld()
	return luajava.getDeclaredFields(getMinecraft().field_71462_r)[1] == "customLoadingScreen"
end

local function overseer(self, args)
	local specialBlock, panicAfter = nil, nil
	if args then
		specialBlock = args.specialBlock
		panicAfter = args.panicAfter or 5
	end
	MOLEBOT_G.specialBlockTimestamp = os.clock()
	while true do
		local now = os.clock()
		local noSpecialBlockTime = now - MOLEBOT_G.specialBlockTimestamp
		-- log("no block time:", noSpecialBlockTime)
		if not isLoadingWorld() and not canSeeSpecialBlock(specialBlock) then
			playMCSound("ENTITY_WITHER_SPAWN")
			if noSpecialBlockTime > panicAfter then
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
			end
		else
			MOLEBOT_G.specialBlockTimestamp = now
		end
		asyncSleepClock(1000)
	end
end
return { cb = overseer, options = { saveState = true } }
