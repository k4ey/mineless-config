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
        "goForward",
        "mine",
        "perfcheck",
        "afkbypass",
      },
      callbackArgs = {
        goForward = { sprint = true, time = -1 },
      },

      requirements = {
      },
    }),
  }
}
