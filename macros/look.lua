local function asyncSleepClock(ms)
    local now = os.clock()
    local future = now + ms/1000
    repeat
        coroutine.yield()
    until os.clock() >= future
end

-- local function getDirection()
--     local player = getPlayer()
--     local yaw_opt =  math.floor(player.yaw / 90 + 3.5)
--     local dir_mat = { [1]={"-z",-180}, [2]={ "+x",-90 }, [3]={ "+z",0 }, [4]={ "-x",90 }, [5]={ "-z",-180 } }
--     return dir_mat[yaw_opt]
-- end
local directions = {
    north=-180,
    east=-90,
    south=0,
    west=90,
}

local function lookDirection(...)
    local self, args = ...
    local direction, time = table.unpack(args)
    if time then
        --- implement this asynchronically using lerp someday...
        look(directions[direction], playerDetails.getPitch(), time)
        asyncSleepClock(time)
    else
        look(directions[direction], playerDetails.getPitch())
    end
end
return {cb = lookDirection, options = {}}
