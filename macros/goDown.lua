local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end

local function goDown(options)
    sneak(200)
    asyncSleepClock(200)
end


--- add no reset to once types
return {cb = goDown, options = {saveState = true}}
