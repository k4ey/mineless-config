return {
  referencePoint = { 1000, 100, 1000 },
  referenceDimensions = { 10, 10, 10, },
  anchors = {
    main = { x = true, z = true, y = true },
    inside = { x = true, z = true, y = true },
  },
  areas = {
    AreaMacro.new({ 1000, 50, 1000 }, { 1010, 141, 1010 }, {
      id = "main",
      type = "constant",
      color = "green",
      defaultCallbacksNames = {
        "logging",
        "goForwardNoCollision",
        "mine",
        "perfcheck",
        "afkbypass",
        "teleportDaemon",
      },
      callbackArgs = {
        goForward = { sprint = true, time = -1 },
        rotationDaemon = { threshold = 50 },
        positionDaemon = { time = 1000, threshold = 2 },
        teleportDaemon = { time = 100, threshold = 20, timeout = 2000 },
      },

      requirements = {
      },
    }),
  }
}
