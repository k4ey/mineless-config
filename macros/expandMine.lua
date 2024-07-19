local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end

local function disable()
  while true do
    coroutine.yield()
  end
end

---@param args {anchorArea: string, fileName: string, executeCommands: string[], commadsDelay: number}
local function expandMine(self, args)
  local anchorArea = assert(MacroCreator.api.getAreaManager():getAreaById(args.anchorArea), "could not find the area")
  local areaManager = MacroCreator.api.getAreaManager()
  local editManager = MacroCreator.api.getEditManager()
  -- log(getBlockName(anchorArea.area.maxX, anchorArea.area.maxY, anchorArea.area.maxZ))
  if getBlockName(anchorArea.area.maxX, anchorArea.area.maxY, anchorArea.area.maxZ) ~= "Bedrock" then
    log("&cThe anchor area is not a solid block")
    MacroCreator.api.loadResizableArea(args.fileName or areaManager.areasFile, editManager.checkPosition, "Bedrock")
    for _, command in pairs(args.executeCommands or {}) do
      say(command)
      -- this has to be blockign!
      sleep(args.commadsDelay or 500)
    end
    sleep(1000)
  end
  asyncSleepClock(200)
  -- MacroCreator.api.getAreaManager():getAreaById("forwarder").area.maxX = MacroCreator.api.getAreaManager():getAreaById("forwarder").area.maxX + 1
end
return { cb = expandMine, options = { saveState = true } }
