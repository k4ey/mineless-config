local function onReset()
	MOLEBOT_G.isInsideAreas = false
end

local function incrementer()
	MOLEBOT_G.isInsideAreas = true
	while true do
		coroutine.yield()
	end
end
return {
	cb = incrementer,
	options = { saveState = false, onReset = onReset },
}
