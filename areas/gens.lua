return {
  referencePoint = { 1000, 100, 1000 },
  referenceDimensions = { 10, 10, 10, },
  anchors = {
    main = { x = true, z = true, y = true },
    inside = { x = true, z = true, y = true },
  },
  areas = {
    AreaMacro.new({ 1000, 100, 1000 }, { 1010, 110, 1010 }, {
      id = "main",
      type = "toggleable",
      toggling = true,
      color = "green",
      defaultCallbacksNames = {
        "rayTraceTurning",
        "goForward",
        "mine",
        "bpsCounter",
        "perfcheck"

      },
      callbackArgs = {
        goForward = { sprint = true, time = 230 },
      },
    }),
  }
}
