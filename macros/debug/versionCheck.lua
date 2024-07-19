local function splitByDot(str)
  str = str or ""
  local t, count = {}, 0
  str:gsub("([^%.]+)", function(c)
    count = count + 1
    t[count] = c
  end)
  return t
end

local MacrosVersion = { semantic = "1.1.0", release = "alpha" }
local Macrosv = splitByDot(MacrosVersion.semantic)
local Minelessv = splitByDot(MacroCreator.version.semantic)

for num = 1, #Minelessv do
  if Minelessv[num] > Macrosv[num] then
    log("&c&B [MINELESS] &f&3| A &cnew version&3 of macros is avaiable! Ask &aahwz &3 for a new zip file!")
    log(
      "&c&B [MINELESS] &f&3| Current: ",
      "&c" .. MacroCreator.version.semantic,
      "&3. You have ",
      "&c" .. MacrosVersion.semantic
    )
  end
end

local function versionCheck(...)
  while true do
    coroutine.yield()
  end
end
return { cb = versionCheck, options = {} }
