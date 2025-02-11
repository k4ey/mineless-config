---@type fun(x: number, y: number, z: number): string?
---@diagnostic disable-next-line
getBlockName = getBlockName

local function loggingScript()
  local logging = MacroCreator:extensions("logging")
  ---@diagnostic disable
  ---@type logging
  if not logging then return end
  ---@diagnostic enable
  _G.LogsConfig = {
    range = 15,
    expandedRange = 45,
    wages = {
      ["Wood"] = 1,
    },
    rotationWage = 0.1,
    distanceWage = 0.9,
    inRangeDistance = 5,
    yRange = 0,
    rotationSpeed = 0.1,
    blackListRange = 256,
    blackListSize = 10,
    blackListAfter = 10
  }
  ---@type fun(blockVector: vec3, playerVector: vec3): number
  local getScore = logging.getScore

  runThread(function()
    local history = { vector = nil, time = nil }
    while true do
      if not MacroCreator.toggled then
        return
      end
      if LogsConfig.best then
        local dest = LogsConfig.best.pos + _G.libs.vec3(0.5, 0.5, 0.5)
        if not history.vector or (history.vector - dest):setY(0):length() > 0 then
          history.vector = dest
          history.time = os.clock()
        end
        local time = os.clock() - history.time
        local delta = 0.01 + 0.5 * time ^ 1.2
        libs.looker.lookTowards(dest, math.min(delta, 0.3), 0.1)
      end
      sleep(10)
    end
  end)
  while true do
    logging.getGoals(getScore)
    _G.libs.asyncSleepClock(200)
  end
end
return { cb = loggingScript, options = { saveState = false } }
