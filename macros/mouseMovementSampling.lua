local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end

local pitchSamples = {}
local yawSamples = {}
local function onReset()
    log("PITCH:")
    log(pitchSamples)
    log("\n\n\nYAW:")
    log(yawSamples)
end

local function lookDirection(...)
    local lastPitch = 0
    local curPitch = 0
    local lastYaw = 0
    local curYaw= 0
    pitchSamples = {}
    while true do
        asyncSleepClock(0)

        curPitch = playerDetails.getPitch()
        local pitchDeviation =  curPitch - lastPitch
        if pitchDeviation ~= 0 then
            pitchSamples[#pitchSamples+1] = pitchDeviation
        end
        lastPitch = curPitch

        curYaw = playerDetails.getYaw()
        local yawDeviation =  curYaw - lastYaw
        if yawDeviation ~= 0 then
            yawSamples[#yawSamples+1] = yawDeviation
        end
        lastYaw = curYaw
    end
end
return {cb = lookDirection, options = {saveState = false, onReset = onReset}}
