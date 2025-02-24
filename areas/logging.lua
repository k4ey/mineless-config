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
        "actions"
      },
      callbackArgs = {
        goForward = { sprint = true, time = -1 },
        rotationDaemon = { threshold = 50 },
        positionDaemon = { time = 1000, threshold = 2 },
        teleportDaemon = { time = 100, threshold = 20, timeout = 2000 },
        actions = {
          config = {
            {
              action = function()
                sleep(400)
                setHotbar(1)
                sleep(100)
                use()
                sleep(100)
                setHotbar(2)

                return false
              end,
              requirement = function()
                local item = openInventory().getSlot(37)
                if not item or not item.nbt.tag then return false end
                local data = item.nbt.tag['custom-item-data']
                if not data then return false end
                local power = data["pet-power-key"]
                local status = data["pet-status-key"]
                if status == "INACTIVE" and power > 0 then
                  return true
                end
              end
            },
            {
              action = function()
                sleep(1000)
                local inv = openInventory()
                setHotbar(3)
                for i = 10, 10 + 36 do
                  local item = inv.getSlot(i)
                  if item and item.name and item.name == "Logging Armor Fragment" then
                    if i ~= 39 then
                      inv.click(i)
                      sleep(100)
                      inv.click(39)
                    end
                    use()
                    sleep(100)
                  end
                end
                setHotbar(2)
                return false
              end,
              requirement = function()
                for i = 10, 10 + 36 do
                  local item = openInventory().getSlot(i)
                  if item and item.name and item.name == "Logging Armor Fragment" and item.amount > 5 then
                    return true
                  end
                end
                return false
              end
            },
            {
              action = function()
                local inv = openInventory()
                sleep(1000)
                say("/armor")

                local time = os.clock()
                while inv.getUpperLabel() ~= "Armor Type" do
                  log(os.clock() - time)
                  if os.clock() - time > 5 then
                    return false
                  end
                  sleep(100)
                end

                inv.click(15)

                time = os.clock()
                while inv.getUpperLabel() ~= "Logging Armor" do
                  log(os.clock() - time)
                  if os.clock() - time > 5 then
                    return false
                  end
                  sleep(100)
                end
                sleep(100)
                local possible = { 11, 13, 15, 17 }
                for _, slot in ipairs(possible) do
                  inv.click(slot)
                  sleep(100)
                end
                sleep(100)
                openInventory().close()

                say("/spawn")
                sleep(math.random(1, 5) * 1000)

                time = os.clock()
                say("/logging")
                while inv.getUpperLabel() ~= "Logging World Selector" do
                  log(os.clock() - time)
                  if os.clock() - time > 5 then
                    return false
                  end
                  sleep(100)
                end
                inv.quick(15)
              end,
              requirement = function()
                for i = 6, 9 do
                  local item = openInventory().getSlot(i)
                  if not item or not item.nbt.tag then return false end
                  local data = item.nbt.tag['custom-item-data']
                  local power = data["skill-armor-performedactions"]
                  local target = data["skill-armor-actions-target"]
                  if power >= target then return true end
                end
                return false
              end
            },
            {
              action = function()
              end,
              requirement = function()
                return true
              end
            }
          }

        }
      },

      requirements = {
      },
    }),
  }
}
