return {
  referencePoint = { 1000, 100, 1000 },
  referenceDimensions = { 10, 10, 10, },
  anchors = {
    main = { x = true, z = true, y = true },
    inside = { x = true, z = true, y = true },
  },
  areas = {
    AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
      id = "inside",
      defaultCallbacksNames = {},
      callbackArgs = {},
      color = "green"
    }),
    AreaMacro.new({ 1000, 100, 1000 }, { 1010, 120, 1010 }, {
      id = "main",
      defaultCallbacksNames = {
        "bpsCounter",
        "ensureNotFlying",
        "turner",
        "autojump",
        "mine",
        "goRight",
        "betterLook",
        "expandMine",
        "afkbypass", -- if you have this enabled, you **cannot** use upgrader!!!! it will stop whenever any gui is opened
        MacroCreator.api.getSettings("commandsEnabled") and "sayCommands" or nil
      },
      ["callbackArgs"] = {
        sayCommands = {
          commands = MacroCreator.api.getSettings("commands") or {},
          interval = MacroCreator.api.getSettings("commandsInterval") or 60000,
          delay = MacroCreator.api.getSettings("commandsDelay") or 60000,
          entropy = 300,
        },
        expandMine = { anchorArea = "inside", fileName = "running.lua", executeCommands = { "/mine go" }, commandsDelay = 1000 },
        betterLook = {
          pitch = 50,
          time = 1000,
          timeout = 100
        },
        turner = {
          -- step = 90,
          -- time = 200,
          -- forwardReach = 4,
          -- limit = 7

        }
      },
      requirements = {
        ensureNotFlying = function()
          local x, y, z = getPlayerPos()
          return y >= MacroCreator.editManager.wallCoords["-x"][2]
        end,
        turner = function()
          return playerDetails.isOnGround() and playerDetails.getPitch() == 50
        end,
        betterLook = function()
          return playerDetails.getPitch() ~= 50
        end,

      },
      color = "black",
    }),
  }
}
