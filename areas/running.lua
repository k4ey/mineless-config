-- predefining default values
local enableCommands, commands, commandsInterval, commandsDelay, commandsEntropy, lookTime, timeEntropy, lookDelay, delayEntropy, safeMode =
    false, {}, 10000, 10, 100, 400, 50, 50, 10, true

--[[
 CONFIG EXAMPLE PLEASE COPY AND PASTE WHOLE LINES! IF YOU HAVE PROBLEMS, PLEASE INPUT THIS TEXT INTO CHATGPT AND TRY FIGURING OUT WHAT IS WRONG WITH __HIM FIRST__ (ITS GONNA BE FASTER THAN ASKING ME!!!!)
PROMPTS FOR CHATGPT:
(change this line as needed) I WANT TO SEND COMMANDS EVERY 200 SECONDS AND I WANT TO HAVE SAFE MODE ENABLED I WANT THE COMMANDS TO BE: "/mine reset" "/sell all"
below is a example configuration of a LUA script. PROVIDE TEXT MATCHING PROMPT, DO NOT PROVIDE COMMENTS, USE VARIABLES DEFINED BY THE EXAMPLE, DO NOT INTRODUCE ANY NEW FIELDS

local enableCommands = true -- true OR false TO ENABLE
local commands = { "/command one", "/command two" } -- HAS TO START WITH "/" to be a command, enableCommands must be true for this to take effect (ITS A TABLE OF STRINGS)
local commandsInterval = 200000 -- interval in ms (time between repeating commands)
local commandsDelay = 500 -- delay between each command in ms (wait time between consequitive commands)
local commandsEntropy = 100 -- random time to add  to interval (in ms)

local lookTime = 400 -- ms how long it takes to change the direction
local timeEntropy = 50 -- random ms range added to lookTime
local lookDelay = 50  -- ms after which it starts turning after hitting a wall
local delayEntropy = 10 -- random ms added to lookDelay

local safeMode = true -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)
END OF PROMPT FOR CHATGPT

]]
-- >>>>PASTE YOUR CONFIG BELOW THIS LINE (WHEN PASTING MAKE SURE TO OVERWRITE LINES BELOW THIS COMMENT)<<<<
local enableCommands = true        -- true OR false TO ENABLE
local commands = { "/mine reset" } -- HAS TO START WITH "/" to be a command, enableCommands must be true for this to take effect (ITS A TABLE OF STRINGS)
local commandsInterval = 200000    -- interval in ms (time between repeating commands)
local commandsDelay = 500          -- delay between each command in ms (wait time between consequitive commands)
local commandsEntropy = 100        -- random time to add to interval (in ms)


--BUT ABOVE THIS LINE!!!

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
        -- "expandMine",
        "afkbypass", -- if you have this enabled, you **cannot** use upgrader!!!! it will stop whenever any gui is opened
        enableCommands and "sayCommands" or nil,
      },
      ["callbackArgs"] = {
        sayCommands = {
          -- input the commands you want here
          commands = commands,
          -- interval
          interval = commandsInterval,
          -- delay between each command
          delay = commandsDelay,
          -- random time to add  to interval (in ms)
          entropy = commandsEntropy,
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
