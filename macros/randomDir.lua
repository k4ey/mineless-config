local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end
local function disable()
    while true do
        coroutine.yield()
    end
end
--- assumes player is looking at  0, -90
local function goLeft(self, once)
    local time = math.random(1000,5000)
    if math.random() > 0.5 then
        left(time)
    else
        right(time)
    end
    if not once then
        asyncSleepClock(time)
    else
        disable()
    end
end


--- add no reset to once types
return {cb = goLeft, options = {saveState = true}}
