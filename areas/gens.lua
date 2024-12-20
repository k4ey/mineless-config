-- predefining default values
local enableCommands, commands, commandsInterval, commandsDelay, commandsEntropy, pitch, safeMode, farmland, crops, range, stepSlow, stepQuick, forbidRange =
    false, {}, 0, 0, 0,
    18, false, "Farmland", {}, 50, 0.07, 0.15, 100
--[[
 CONFIG EXAMPLE PLEASE COPY AND PASTE WHOLE LINES! IF YOU HAVE PROBLEMS, PLEASE INPUT THIS TEXT INTO CHATGPT AND TRY FIGURING OUT WHAT IS WRONG WITH __HIM FIRST__ (ITS GONNA BE FASTER THAN ASKING ME!!!!)
PROMPTS FOR CHATGPT:
I WANT
below is a example configuration of a LUA script. PROVIDE TEXT MATCHING PROMPT, DO NOT PROVIDE COMMENTS, USE VARIABLES DEFINED BY THE EXAMPLE, DO NOT INTRODUCE ANY NEW FIELDS

local enableCommands = true -- true OR false TO ENABLE
local commands = { "/command one", "/command two" } -- HAS TO START WITH "/" to be a command, enableCommands must be true for this to take effect (ITS A TABLE OF STRINGS)
local commandsInterval = 200000 -- interval in ms (time between repeating commands)
local commandsDelay = 500 -- delay between each command in ms (wait time between consequitive commands)
local commandsEntropy = 100 -- random time to add  to interval (in ms)

local safeMode = true -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)
local pitch = 18 -- pitch to look at when mining
local crops = {
  ["Wheat Crops"] = true,
}
local farmland = "Farmland"
local range = 50 -- range at which it should look for possible goals
local stepQuick = 0.07 -- step used for interpolations on big angles (higher value more snappy)
local stepSlow = 0.15 -- step used for interpolations on small angles (higher value more snappy)
local forbidRange = 30 ^ 2 -- squared distance from obstackle that should be avoided at higher speeds use higher values
END OF PROMPT FOR CHATGPT
]]
-- >>>>PASTE YOUR CONFIG BELOW THIS LINE (WHEN PASTING MAKE SURE TO OVERWRITE LINES BELOW THIS COMMENT)<<<<


local safeMode = true -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)
local crops = {
  ["Wheat Crops"] = true,
  ["Carrots"] = true,
  ["Potatoes"] = true,
  ["Beetroots"] = true,
  ["Nether Wart"] = true
}
local farmland = "Farmland"
local pitch = 18           -- pitch to look at when farming
local range = 100          -- range at which it should look for possible goals
local stepQuick = 0.07     -- step used for interpolations on big angles (higher value more snappy)
local stepSlow = 0.21      -- step used for interpolations on small angles (higher value more snappy)
local forbidRange = 10 ^ 2 -- squared distance from obstackle that should be avoided at higher speeds use higher values

--BUT ABOVE THIS LINE!!!

crops.Air = true
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
        "gens",
        "goForward",
        "wobble",
        "mine",
        "bpsCounter",
        "perfcheck",
        "afkbypass",
        "positionDaemon",
        "rotationDaemon",
        "randomTurn"

      },
      callbackArgs = {
        goForward = { sprint = true, time = -1 },
        gens = {
          -- centerVector = { -171, 53, -5 },
          centerVector = { -171, 89, -5 },
        },
        rotationDaemon = { threshold = 10 },
        positionDaemon = { time = 1000, threshold = 2 },
        wobble = {
          time = 1000,
          delay = 200,
          entropyTime = 100,
          entropyDelay = 100
        }
      },

      requirements = {
      },
    }),
  }
}
