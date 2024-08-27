return {

  AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
    ["id"] = "main",
    ["defaultCallbacksNames"] = {
      -- "reqCheck",
      -- "perfcheck",
      "bpsCounter",
      "orbitter"
      -- "betterRunner",
      -- "ensureNotFlying",
      -- "mine",
      -- "turner",
      -- "autojump",
      -- "goRight",
      -- "sayCommands",
      -- "expandMine"
      -- "mine",
    },
    ["callbackArgs"] = {
      -- sayCommands = { commands = { "/mine reset", "/mine go" }, interval = 60000, delay = 60000 },
      -- expandMine = { anchorArea = "main", fileName = "perftesting.lua", executeCommands = { "/mine go" }, commandsDelay = 1000 }
    },
    requirements = {
      -- ensureNotFlying = function()
      --   local x, y, z = getPlayerPos()
      --   return y >= MacroCreator.editManager.wallCoords["-x"][2]
      -- end
    },
    color = "black",
  }),
}
