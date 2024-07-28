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
        "sayCommands",
        "expandMine",
      },
      ["callbackArgs"] = {
        sayCommands = { commands = { "/mine reset", }, interval = 60000, delay = 60000 },
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
