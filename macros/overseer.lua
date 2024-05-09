local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end

local routines = {
    "vertical",
    "vertical",
    "vertical",
    "horizontal",
}
local directions = {
    "right",
    "right",
    "right",
    "left"
}

if not MOLEBOT_G then
    MOLEBOT_G = {}
    MOLEBOT_G.direction = "right"
end

local function overseer(self, args)
    while true do
        log("randomizing actions...")
        local routine = routines[math.random(1,#routines)]
        local direction = directions[math.random(1,#directions)]
        log(MOLEBOT_G)
        if direction == MOLEBOT_G.direction then
            MacroCreator.api.loadAreas(routine)
        end
        MOLEBOT_G.direction = direction
        asyncSleepClock(60000)
    end
end
return {cb = overseer, options = {saveState = true}, }

