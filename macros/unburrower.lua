local getPlayerBlockPos = getPlayerBlockPos
local getBlock = getBlock

-- local function restoreFocus()
--     mc.field_71415_G = true -- mc.inGameHasFocus = true
-- end

local function unburrow(self, args)
	local command = args.command or "/pmine tp Rattletrapped"
	local x, y, z = getPlayerBlockPos()
	local block = getBlock(x, y, z)
	if block and block.name ~= "Air" then
		say(command)
	end
end

return { cb = unburrow, options = { saveState = false } }
