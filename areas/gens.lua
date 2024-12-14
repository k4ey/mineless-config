-- predefining default values
local enableCommands, commands, commandsInterval, commandsDelay, commandsEntropy, pitch, safeMode, farmland, crops =
    false, {}, 0, 0, 0,
    18, false, "Farmland", {}
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
END OF PROMPT FOR CHATGPT
]]
-- >>>>PASTE YOUR CONFIG BELOW THIS LINE (WHEN PASTING MAKE SURE TO OVERWRITE LINES BELOW THIS COMMENT)<<<<


local safeMode = true -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)
local crops = {
  ["Wheat Crops"] = true,
}
local farmland = "Farmland"
local pitch = 18 -- pitch to look at when farming

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
        "mine",
        "bpsCounter",
        "perfcheck",
        "afkbypass"
      },
      callbackArgs = {
        goForward = { sprint = true, time = 230 },
        gens = { farmland = farmland, crops = crops, pitch = pitch },
      },
    }),
  }
}
