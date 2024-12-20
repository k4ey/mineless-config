local quat = _G.libs.quat
local function turn(sign)
  local yaw = playerDetails.getYaw()
  local pitch = playerDetails.getPitch()
  local angle1 = quat.Euler(0, pitch, yaw)
  local angle2 = quat.Euler(0, pitch, yaw + math.random(1, 30) * sign)

  local angle = quat.Lerp(angle1, angle2, 0.07):ToEulerAngles()
  if angle.y > 90 then
    angle.y = angle.y - 360
  end
  yaw, pitch = angle.z, angle.y
  look(yaw, playerDetails.getPitch())
end
local function asyncSleepClock(ms)
  local now = os.clock()
  local future = now + ms / 1000
  repeat
    coroutine.yield()
  until os.clock() >= future
end
--- should be paired with something that prevents other rotations from happening (as it might look snappy when you rotate left and some other thing rotates right!)
local function rotator(_, args)
  while true do
    for i = 1, 10 do
      local yaw = playerDetails.getYaw()
      local pitch = playerDetails.getPitch()
      local angle = quat.Euler(0, pitch, yaw)
      coroutine.yield()
      local newYaw = playerDetails.getYaw()
      local newPitch = playerDetails.getPitch()
      local angle2 = quat.Euler(0, newPitch, newYaw)
      local dy = newYaw - yaw
      local signDy = math.sign(dy)
      local delta = angle:Angle(angle2)
      if delta < 1 then return end
      if math.random(1, 10) ~= 1 then return end
      log("turned:", signDy < 0 and "left" or "rigth")
      for i = 1, math.random(1, 20) do
        turn(signDy)
        coroutine.yield()
        coroutine.yield()
      end
    end
  end
end

return { cb = rotator, options = { saveState = true } }
