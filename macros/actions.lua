local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

---@param fun function
---@param req function
local function createAction(fun, req)
  return coroutine.create(function()
    while true do
      if req() then
        while fun() do coroutine.yield() end
      end
      asyncSleepClock(100)
    end
  end)
end


local actions = {}

---@class ActionConfig
---@field action function
---@field requirement function


---@param self any
---@param args { config: ActionConfig[] }
local function actionsQueue(self, args)
  for _, action in pairs(args.config) do
    actions[#actions + 1] = createAction(action.action, action.requirement)
  end
  while true do
    for _, action in ipairs(actions) do
      coroutine.resume(action)
    end
    asyncSleepClock(100)
  end
end
return { cb = actionsQueue, options = { saveState = true } }
