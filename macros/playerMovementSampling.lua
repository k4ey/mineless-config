local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end

local samples = {}
local function onReset()
    log("samples:")
    log(samples)
end

local function substract3d(vec1, vec2)
    return {vec1[1] - vec2[1], vec1[2] - vec2[2], vec1[3] - vec2[3]}
end

local function lookDirection(...)
    local lastVelocity = {0,0,0}
    local curVelocity = {0,0,0}
    samples = {}
    while true do
        asyncSleepClock(0)

        curVelocity = playerDetails.getVelocity()
        -- local movementDeviation =  substract3d(lastVelocity, curVelocity)
        local movementDeviation = curVelocity
        if movementDeviation[1] ~= 0 or movementDeviation[3] ~= 0 then
            samples[#samples+1] = movementDeviation
        end
        lastVelocity = curVelocity
    end
end
return {cb = lookDirection, options = {saveState = false, onReset = onReset}}
