local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end

if not getSettings().luajava.allowPrivateAccess then
	log("&c&B [MINELESS] &f&3&B| Doing some tweaks to java settings, please restart your game...")
	getSettings().luajava = getSettings().luajava or {}
	getSettings().luajava.allowPrivateAccess = true
	getSettings().save()
end

-- local mc = getMinecraft()
-- local enumHand = luajava.bindClass("net.minecraft.util.EnumHand")
-- local allowAttacking = false

local function loop()
	-- local success, err = pcall(function(...)
	-- 	while true do
	-- 		runOnMC(function()
	-- 			local hit = playerDetails.getTarget()
	-- 			if allowAttacking then
	-- 				if hit and hit.block and mc.field_71476_x then -- currentScreen
	-- 					-- this.playerController.onPlayerDamageBlock(blockpos, this.objectMouseOver.sideHit)
	-- 					local blockPos = mc.field_71476_x:func_178782_a()
	-- 					mc.field_71442_b:func_180512_c(blockPos, mc.field_71476_x.field_178784_b)
	-- 					-- this.player.swingArm(EnumHand.MAIN_HAND);
	-- 					mc.field_71439_g:func_184609_a(enumHand.MAIN_HAND) -- player.
	-- 					-- this.sendClickBlockToController(this.currentScreen == null && this.gameSettings.keyBindAttack.isKeyDown() && this.inGameHasFocus);
	-- 					mc:func_147115_a(false) -- sendClickBlockToController
	-- 				end
	-- 			end
	-- 		end)
	-- 		waitTick()
	-- 	end
	-- end)
	-- if _G.DEV_ENV then
	-- 	log("&c err in thread:", success, err)
	-- end
end

MOLEBOT_G.canAttack = true

local function mine()
	-- log("&c NOT IMPLEMENTED")
	-- if _G.MiningThread then
	-- 	_G.MiningThread.stop()
	-- 	_G.MiningThread = nil
	-- end
	-- _G.MiningThread = runThread(loop)
	-- while true do
	-- 	-- currentScreen
	-- 	if MOLEBOT_G.canAttack and mc.field_71462_r == nil then
	-- 		allowAttacking = true
	-- 	else
	-- 		allowAttacking = false
	-- 	end
	-- 	asyncSleepClock(100)
	-- end
	if MOLEBOT_G.canAttack then
		attack(100)
		asyncSleepClock(100)
	else
		attack(0)
	end
end

local function onReset()
	-- allowAttacking = false
end
return {
	cb = mine,
	options = {
		onReset = onReset,
		saveState = true,
	},
}
