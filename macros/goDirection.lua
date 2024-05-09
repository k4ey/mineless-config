local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end
local directions = {
    left = true,
    right = true
}
if not MOLEBOT_G then
    MOLEBOT_G = {}
end
if MOLEBOT_G and not MOLEBOT_G.direction then
    MOLEBOT_G.direction = "left"
end

local function goDirection(self,once)
    assert(MOLEBOT_G and MOLEBOT_G.direction and directions[MOLEBOT_G.direction], "there is something wrong with the direction")

    local time = math.random(100,200)
    _G[MOLEBOT_G.direction](time)
    if not once then
        asyncSleepClock(time)
    end
end


--- add no reset to once types
return {cb = goDirection, options = {saveState = true}}
