local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function resetMine(_, args)
	local resetMineCommand = args and args.resetMineCommand ~= "/derive" and args.resetMineCommand
		or MOLEBOT_G.resetMineCommand
	if resetMineCommand == "/derive" then
		log("deriving the rest command from last tped to area")
	elseif not resetMineCommand or not tostring(resetMineCommand):find("^/") then
		log("there is no command specified for mine reseting!!!!")
	else
		say(resetMineCommand)
	end
end
return { cb = resetMine, options = { saveState = true } }
