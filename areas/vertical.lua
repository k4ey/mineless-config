-- predefining default values
local enableCommands, commands, commandsInterval, commandsDelay, commandsEntropy, lookTime, timeEntropy, lookDelay, delayEntropy, safeMode, borderHeight =
    false, {}, 10000, 10, 100, 400, 50, 50, 10, true, 1

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

local borderHeight = 1 -- how many blocks to leave between the bottom and the top of the mine (set to allow for the player to move between specific Y levels)

local safeMode = true -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)
END OF PROMPT FOR CHATGPT

]]
-- >>>>PASTE YOUR CONFIG BELOW THIS LINE (WHEN PASTING MAKE SURE TO OVERWRITE LINES BELOW THIS COMMENT)<<<<
local enableCommands = true        -- true OR false TO ENABLE
local commands = { "/mine reset" } -- HAS TO START WITH "/" to be a command, enableCommands must be true for this to take effect (ITS A TABLE OF STRINGS)
local commandsInterval = 200000    -- interval in ms (time between repeating commands)
local commandsDelay = 500          -- delay between each command in ms (wait time between consequitive commands)
local commandsEntropy = 100        -- random time to add to interval (in ms)

local lookTime = 400               -- ms how long it takes to change the direction
local timeEntropy = 50             -- random ms range added to lookTime
local lookDelay = 50               -- ms after which it starts turning after hitting a wall
local delayEntropy = 10            -- random ms added to lookDelay
local safeMode = true              -- true OR false TO ENABLE SAFE MODE (stops when any GUI is opened)

--BUT ABOVE THIS LINE!!!







local function lookArgs(yaw)
  local yawTable = {
    north = -180,
    east = -90,
    south = 0,
    west = 90
  }
  local yawEntropies = {
    [-180] = { min = 155, max = 180, override = true },
    [-90] = { min = -115, max = -90, override = true },
    [0] = { min = -25, max = 0, override = true },
    [90] = { min = 70, max = 90, override = true }
  }
  local yawEnt = yawEntropies[yawTable[yaw]]
  return {
    time = lookTime,
    yaw = yaw,
    timeEntropy = timeEntropy,
    pitch = "forward",
    pitchEntropy = 2,
    delay = lookDelay,
    delayEntropy = delayEntropy,
    yawEntropy = yawEnt,
  }
end
local forwarderArgs = {
  afkbypass = {
    -- whiteList = { -- this is used by afkbypass ( the script that stops you when afk check happens!) you can add labels that are ignored so you can use upgrader for example
    --   "Crafting", "Speed Upgrade", "Pickaxe Enchantments", "Token Greed Upgrade", "Gem Greed Upgrade"
    -- }
  },
  -- upgrader = { -- if you want to have automatic upgrades uncommment this
  --   steps = {
  --     {
  --       action = function()
  --         local previousSlots = openInventory().getTotalSlots()
  --         repeat
  --           use()
  --           _G.libs.asyncSleepClock(100)
  --         until openInventory().getTotalSlots() ~= previousSlots
  --       end,
  --     },
  --     { name = "Token Greed Enchant" },
  --     { name = "Max Upgrade" },
  --     {
  --       action = function()
  --         openInventory().close()
  --       end,
  --     },
  --   }
  -- }
}
local forwarderCallbacks = {
  "goLeft",
  "alignHeightVerticalMine",
  "mine",
  "ensureFlying",
  -- "moveToWall",
  "bpsCounter",
  -- "perfcheck",
  safeMode and "afkbypass" or nil, -- if you have this enabled, you **cannot** use upgrader!!!! it will stop whenever any gui is opened
  -- "upgrader", -- if you want to use it, you have to specify whiteList for afkbypass!
}

local forwarderArgsDown = _G.libs.table_extend('keep', false, forwarderArgs, {
  alignHeightVerticalMine = {
    direction = "down",
  },
})
local forwarderArgsUp = _G.libs.table_extend('keep', false, forwarderArgs, {
  alignHeightVerticalMine = {
    direction = "up",
  },
})

local yawEntropies = {
  [180] = { min = 135, max = 180 },
  [-90] = { min = -135, max = -90 },
  [0] = { min = -45, max = 0 },
  [90] = { min = 45, max = 90 }
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
    northWest = { x = true, z = true, w = false, d = true, y = true },
    northEast = { x = false, z = true, w = true, d = false, y = true },
    southWest = { x = true, z = true, w = true, d = false, y = true },
    southEast = { x = true, z = false, w = false, d = true, y = true },
  },
  areas = {
    AreaMacro.new({ 1000, 112, 1000 }, { 1010, 130, 1010 }, {
      id = "downer",
      color = "white",
      defaultCallbacksNames = {
        "goDown"
      },
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
    AreaMacro.new({ 1000, 109, 1000 }, { 1010, 109 - borderHeight, 1010 }, {
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
    AreaMacro.new({ 1000, 101, 1000 }, { 1010, 102 + borderHeight, 1010 }, {
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
    AreaMacro.new({ 1009, 100, 1009 }, { 1002, 110, 1009 }, {
      id = "southEast",
      defaultCallbacksNames = {
        "betterLook",
      },
      callbackArgs = {
        betterLook = lookArgs("north"),
      },
      color = "red",
    }),
    AreaMacro.new({ 1001, 100, 1009 }, { 1001, 110, 1002 }, {
      id = "southWest",
      defaultCallbacksNames = {
        "betterLook",
      },
      callbackArgs = {
        betterLook = lookArgs("east")
      },
      color = "pink",
    }),
    AreaMacro.new({ 1001, 100, 1001 }, { 1008, 110, 1001 }, {
      id = "northWest",
      defaultCallbacksNames = {
        "betterLook",
      },
      callbackArgs = {
        betterLook = lookArgs("south"),
      },
      color = "blue",
    }),
    AreaMacro.new({ 1009, 100, 1001 }, { 1009, 110, 1008 }, {
      id = "northEast",
      defaultCallbacksNames = {
        "betterLook",
        enableCommands and "sayCommands" or nil
      },
      callbackArgs = {
        betterLook = lookArgs("west"),
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
      },
      color = "cyan",
    }),
  }
}
