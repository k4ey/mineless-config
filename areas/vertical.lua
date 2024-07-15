local lookTime = 350
local timeEntropy = 150
local delayEntropy = 50
local delay = 80

local expandMineArgs = {
  anchorArea = "forwarder",
  plugin = "vertical.lua"
}

local forwarderArgsDown = {
  alignHeightVerticalMine = {
    direction = "down",
  },
  expandMine = expandMineArgs
}

local forwarderArgsUp = {
  alignHeightVerticalMine = {
    direction = "up",
  },
  expandMine = expandMineArgs
}


local forwarderCallbacks = {
  "goLeft",
  "alignHeightVerticalMine",
  "mine",
  "ensureFlying",
  "moveToWall",
  "bpsCounter",
  -- "perfcheck",
  "afkbypass", -- if you have this enabled, you **cannot** use upgrader!!!! it will stop whenever any gui is opened
  "expandMine",
}
return {
  referencePoint = { 1000, 100, 1000 },
  referenceDimensions = { 10, 10, 10, },
  anchors = {
    downer = { w = false, d = false, h = true, x = true, z = true, y = false },
    jumper = { w = false, d = false, h = true, x = true, z = true },
    timeouter = { w = true, d = true, h = true },
    forwarder = { x = true, z = true, y = true },
    switcherDown = { x = true, z = true, h = true },
    switcherUp = { x = true, z = true, h = true, y = true },
    northWest = { x = true, z = true, w = true, d = true, y = true },
    northEast = { x = false, z = true, w = true, d = true, y = true },
    southWest = { x = true, z = false, w = true, d = true, y = true },
    southEast = { x = false, z = false, w = true, d = true, y = true },
  },
  areas = {
    AreaMacro.new({ 1000, 111, 1000 }, { 1010, 130, 1010 }, {
      id = "downer",
      color = "white",
      defaultCallbacksNames = {
        "ensureNotFlying",
      },
      callbackArgs = {},
    }),

    AreaMacro.new({ 999, 111, 999 }, { 1011, 111, 1011 }, {
      id = "jumper",
      color = "cyan",
      defaultCallbacksNames = {
        "getInHole",
      },
      callbackArgs = {},
    }),

    AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
      id = "forwarder",
      defaultCallbacksNames = forwarderCallbacks,
      callbackArgs = forwarderArgsDown,
    }),
    AreaMacro.new({ 1000, 109, 1000 }, { 1010, 109, 1010 }, {
      id = "switcherDown",
      defaultCallbacksNames = {
        "areaEditor",
      },
      callbackArgs = {
        areaEditor = {
          callbacks = {
            forwarder = forwarderCallbacks,
          },
          args = {
            forwarder = forwarderArgsDown,
          },
        },
      },
      color = "black",
      type = "once",
    }),
    AreaMacro.new({ 1000, 101, 1000 }, { 1010, 102, 1010 }, {
      id = "switcherUp",
      defaultCallbacksNames = {
        "areaEditor",
      },
      callbackArgs = {
        areaEditor = {
          callbacks = {
            forwarder = forwarderCallbacks,
          },
          args = {
            forwarder = forwarderArgsUp,
          },
        },
      },
      color = "black",
      type = "once",
    }),
    -- --
    AreaMacro.new({ 1009, 100, 1009 }, { 1009, 110, 1009 }, {
      id = "southEast",
      defaultCallbacksNames = {
        "betterLook",
      },
      callbackArgs = {
        betterLook = {
          time = lookTime,
          yaw = "north",
          timeEntropy = timeEntropy,
          pitch = "forward",
          delay = delay,
          delayEntropy = delayEntropy,
        },
      },
      color = "red",
    }),
    AreaMacro.new({ 1001, 100, 1009 }, { 1001, 110, 1009 }, {
      id = "southWest",
      defaultCallbacksNames = {
        "betterLook",
      },
      callbackArgs = {
        betterLook = {
          pitch = "forward",
          timeEntropy = timeEntropy,
          time = lookTime,
          yaw = "east",
          delay = delay,
          delayEntropy = delayEntropy,
        },
      },
      color = "pink",
    }),
    AreaMacro.new({ 1001, 100, 1001 }, { 1001, 110, 1001 }, {
      id = "northWest",
      defaultCallbacksNames = {
        "betterLook",
      },
      callbackArgs = {
        betterLook = {
          pitch = "forward",
          timeEntropy = timeEntropy,
          time = lookTime,
          yaw = "south",
          delay = delay,
          delayEntropy = delayEntropy,
        },
      },
      color = "blue",
    }),
    AreaMacro.new({ 1009, 100, 1001 }, { 1009, 110, 1001 }, {
      id = "northEast",
      defaultCallbacksNames = {
        "betterLook",
        "sayCommands", -- uncomment if you want to periodically say some commands
        -- "upgrader",
      },
      callbackArgs = {
        betterLook = {
          pitch = "forward",
          time = lookTime,
          timeEntropy = timeEntropy,
          yaw = "west",
          delay = delay,
          delayEntropy = delayEntropy,
        },
        sayCommands = {
          commands = { "/pmine reset" },
          interval = 60000,
        },
      },
      color = "cyan",
    }),
  }
}
