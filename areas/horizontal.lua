-- predefining default values
local enableCommands, commands, commandsInterval, commandsDelay, commandsEntropy, lookTime, timeEntropy, lookDelay, delayEntropy, safeMode, alignHeightDelay =
    false, {}, 10000, 10, 100, 400, 50, 50, 10, true, 10
--[[
 CONFIG EXAMPLE PLEASE COPY AND PASTE WHOLE LINES! IF YOU HAVE PROBLEMS, PLEASE INPUT THIS TEXT INTO CHATGPT AND TRY FIGURING OUT WHAT IS WRONG WITH __HIM FIRST__ (ITS GONNA BE FASTER THAN ASKING ME!!!!)
PROMPTS FOR CHATGPT:
I WANT TO SEND COMMANDS EVERY 200 SECONDS AND I WANT TO HAVE SAFE MODE ENABLED I WANT THE COMMANDS TO BE: "/mine reset" "/sell all"
below is a example configuration of a LUA script. PROVIDE TEXT MATCHING PROMPT, DO NOT PROVIDE COMMENTS, USE VARIABLES DEFINED BY THE EXAMPLE, DO NOT INTRODUCE ANY NEW FIELDS

local enableCommands = true -- true OR false TO ENABLE
local commands = { "/command one", "/command two" } -- HAS TO START WITH "/" to be a command, enableCommands must be true for this to take effect (ITS A TABLE OF STRINGS)
local commandsInterval = 200000 -- interval in ms (time between repeating commands)
local commandsDelay = 500 -- delay between each command in ms (wait time between consequitive commands)
local commandsEntropy = 100 -- random time to add  to interval (in ms)
local alignHeightDelay = 1000 -- delay between going down when a layer is cleared

local safeMode = true -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)
END OF PROMPT FOR CHATGPT

]]
-- >>>>PASTE YOUR CONFIG BELOW THIS LINE (WHEN PASTING MAKE SURE TO OVERWRITE LINES BELOW THIS COMMENT)<<<<
local enableCommands = true        -- true OR false TO ENABLE
local commands = { "/mine reset" } -- HAS TO START WITH "/" to be a command, enableCommands must be true for this to take effect (ITS A TABLE OF STRINGS)
local commandsInterval = 30000     -- interval in ms (time between repeating commands)
local commandsDelay = 500          -- delay between each command in ms (wait time between consequitive commands)
local commandsEntropy = 100        -- random time to add to interval (in ms)
local alignHeightDelay = 10        -- delay between going down when a layer is cleared

local safeMode = true              -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)

--BUT ABOVE THIS LINE!!!
return {
  referencePoint = { 0, 0, 0 },
  referenceDimensions = { 160, 160, 160 },
  areas = {
    AreaMacro.new({ 0, 0, 0 }, { 160, 170, 160 }, {
      id = "aligner",
      defaultCallbacksNames = {
        "alignHeight",
        "ensureFlying",
        "incrementer",
        "mine",
        safeMode and "afkbypass" or nil, -- if you have this enabled, you **cannot** use upgrader!!!! it will stop whenever any gui is opened
        -- "perfcheck",
        --"upgrader" -- upgrades! uncomment to apply, look inside upgrader.lua for more info
      },
      callbackArgs = {
        alignHeight = {
          radius = 30,
          delay = alignHeightDelay
        },
      },
    }),

    AreaMacro.new({ 0, 0, 0 }, { 160, 170, 160 }, {
      id = "forwarder",
      defaultCallbacksNames = {
        "goForward",
        "bpsCounter",
        enableCommands and "sayCommands" or nil
      },
      callbackArgs = {
        goForward = {
          sprint = true,
        },
        sayCommands = {
          -- input the commands you want here
          commands = commands,
          -- interval
          interval = commandsInterval,
          -- delay between each command
          delay = commandsDelay,

          entropy = commandsEntropy,

        },
      },
    }),

    AreaMacro.new({ 21, 0, 21 }, { 139, 170, 139 }, {
      id = "insider",
      color = "white",
      defaultCallbacksNames = {
        "alignPath",
        "noiser",
      },
      callbackArgs = {
        noiser = {
          time = 1000,
          timeout = 600,
          timeEntropy = 500,
          yawEntropy = 100,
        },
      },
    }),

    AreaMacro.new({ 79, 0, 151 }, { 81, 170, 161 }, {
      id = "lookdowner",
      defaultCallbacksNames = {
        "alignHeight",
        "goForward",
        "betterLook",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yaw = "north",
        },
      },
    }),

    AreaMacro.new({ 20, 0, 140 }, { 140, 170, 160 }, {
      color = "lime",
      id = "southTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "north",
        },
      },
    }),

    AreaMacro.new({ 140, 0, 20 }, { 160, 170, 140 }, {
      color = "pink",
      id = "eastTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "west",
        },
      },
    }),

    AreaMacro.new({ 20, 0, 0 }, { 140, 170, 20 }, {
      color = "green",
      id = "northTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "south",
        },
      },
    }),

    AreaMacro.new({ 0, 0, 20 }, { 20, 170, 140 }, {
      color = "red",
      id = "westTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "east",
        },
      },
    }),

    AreaMacro.new({ 140, 0, 20 }, { 160, 170, 0 }, {
      color = "cyan",
      id = "northEastTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "southWest",
        },
      },
    }),
    AreaMacro.new({ 140, 0, 140 }, { 160, 170, 160 }, {
      color = "magenta",
      id = "southEastTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "northWest",
        },
      },
    }),
    AreaMacro.new({ 20, 0, 140 }, { 0, 170, 160 }, {
      color = "blue",
      id = "southWestTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "northEast",
        },
      },
    }),
    AreaMacro.new({ 20, 0, 20 }, { 0, 170, 0 }, {
      color = "pink",
      id = "northWestTurner",
      defaultCallbacksNames = {
        "betterLook",
        "autoAlign",
      },
      callbackArgs = {
        betterLook = {
          pitch = "fdown",
          time = 700,
          yawEntropy = 10,
          timeEntropy = 100,
          yaw = "southEast",
        },
      },
    }),
  },
  anchors = {
    forwarder = { x = true, z = true, y = true },
    aligner = { x = true, z = true, y = true },
    insider = { x = true, z = true, y = true },

    lookdowner = { x = true, z = true, y = true, w = true, d = true },
    timeouter = { x = true, z = true, y = true, w = true, d = true },

    southTurner = { y = true, w = false, x = true, d = true },
    northTurner = { x = true, z = true, y = true, d = true },

    eastTurner = { y = true, z = true, w = true },
    westTurner = { y = true, z = true, x = true, w = true },

    northEastTurner = { y = true, z = true, w = true, d = true },
    northWestTurner = { y = true, z = true, x = true, w = true, d = true },

    southEastTurner = { y = true, z = false, w = true, d = true },
    southWestTurner = { y = true, x = true, z = false, w = true, d = true },
  }
}
