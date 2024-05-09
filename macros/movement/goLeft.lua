local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end
--- assumes player is looking at  0, -90
local function goLeft(self, once)
    left(200)
    if not once then
        asyncSleepClock(200)
    end
end


--- add no reset to once types
return {cb = goLeft, options = {saveState = true}}
