local lookTime = 350
local timeEntropy = 50
local delayEntropy = 50
local delay = 100
local resetCommand = "/pmine reset"

local expandMineArgs = {
  anchorArea = "forwarder",
  plugin = "vertical.lua",
  executeCommands = { "/spawn", "/pmine go" },
  commandsDelay = 5000
}
local forwarderArgs = {
  expandMine = expandMineArgs,
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
  "moveToWall",
  "bpsCounter",
  -- "perfcheck",
  "afkbypass",
  -- "upgrader", -- if you want to use it, you have to specify whiteList for afkbypass!
  "expandMine",
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
    AreaMacro.new({ 1000, 111, 1000 }, { 1010, 130, 1010 }, {
      id = "downer",
      color = "white",
      defaultCallbacksNames = {
        "gotoPosition",
        "expandMine",
      },
      callbackArgs = {
        expandMine = expandMineArgs,
        gotoPosition = {
          positionCallback = function()
            local areas = { "southWest", "southEast", "northWest", "northEast" }
            local vec3 = _G.libs.vec3
            local minDist = math.huge
            local closestArea = nil
            local area
            local ppos = vec3(getPlayerBlockPos()):setY(0)
            for i, areaId in ipairs(areas) do
              area = assert(MacroCreator.api.getAreaManager():getAreaById(areaId), areaId .. " area not found")
              local dist = ppos:distance(vec3(table.unpack(area.area:getCenter())))
              if dist < minDist then
                minDist = dist
                closestArea = area
              end
            end
            assert(closestArea, "No closest area found")
            ---@cast area AreaMacro
            return closestArea.area.maxX, closestArea.area.maxY, closestArea.area.maxZ
          end
        }
      },
    }),

    AreaMacro.new({ 999, 111, 999 }, { 1011, 111, 1011 }, {
      id = "jumper",
      color = "cyan",
      defaultCallbacksNames = {
        -- "getInHole",
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
    AreaMacro.new({ 1009, 100, 1009 }, { 1002, 110, 1009 }, {
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
    AreaMacro.new({ 1001, 100, 1009 }, { 1001, 110, 1002 }, {
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
    AreaMacro.new({ 1001, 100, 1001 }, { 1008, 110, 1001 }, {
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
    AreaMacro.new({ 1009, 100, 1001 }, { 1009, 110, 1008 }, {
      id = "northEast",
      defaultCallbacksNames = {
        "betterLook",
        "sayCommands", -- uncomment if you want to periodically say some commands
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
          commands = { "/sellall" },
          interval = 5000,
          delay = 2000,
          entropy = 300
        },
      },
      color = "cyan",
    }),
  }
}
