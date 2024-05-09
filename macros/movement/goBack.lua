local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end
--- assumes player is looking at  0, -90
local function goBack(options)
    back(200)
    asyncSleepClock(200)
end


--- add no reset to once types
return {cb = goBack, options = {saveState = true}}
