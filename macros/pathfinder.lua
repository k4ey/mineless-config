local function asyncSleepClock(ms)
	local now = os.clock()
	local future = now + ms / 1000
	repeat
		coroutine.yield()
	until os.clock() >= future
end
local function startFlying()
	log("Flying")
	asyncSleepClock(500)
	key("SPACE", 100)
	asyncSleepClock(250)
	key("SPACE", 50)
	asyncSleepClock(500)
end
local aStar = (function()
	local PQ = {}

	PQ.new = function()
		local queue = {
			n = 0,
			pop = PQ.pop,
			insert = PQ.insert,
		}
		return queue
	end

	PQ.insert = function(self, priority, elem)
		local n = self.n + 1
		self.n = n
		self[n] = { p = priority, v = elem }
		local i = n
		while i >= 2 do
			local j = math.floor(i / 2)
			if self[i].p < self[j].p then
				self[i], self[j] = self[j], self[i]
			end
			i = j
		end
	end

	PQ.pop = function(self)
		if self.n == 0 then
			return nil
		end
		local ret = self[1]
		local n = self.n
		self[1], self[n] = self[n], nil
		self.n = n - 1
		local i = 1
		while i < self.n do
			local left = 2 * i
			local right = 2 * i + 1
			local current = i
			if left <= self.n then
				if self[left].p < self[i].p then
					i = left
				end
			end
			if right <= self.n then
				if self[right].p < self[i].p then
					i = right
				end
			end
			if current == i then
				break
			else
				self[current], self[i] = self[i], self[current]
			end
		end
		return ret.v
	end

	local function fromMaybe(default)
		return function(maybeNil)
			if maybeNil == nil then
				return default
			else
				return maybeNil
			end
		end
	end

	local function maybe(default)
		return function(f)
			return function(x)
				if x == nil then
					return default
				else
					return f(x)
				end
			end
		end
	end

	local function inferior(x)
		return function(y)
			return x < y
		end
	end
	local function nodeToString(node)
		return node.x .. "," .. node.y .. "," .. node.z
	end

	local function backtrack(last, cameFrom)
		local current = last
		local path = {}
		while current ~= nil do
			table.insert(path, 1, current)
			current = cameFrom[nodeToString(current)]
		end
		return path
	end

	-- aStar:
	--      - expand:   function that takes a node and return its neighbors as array/table
	--                  neighbors must be values, not keys, as they are discarded
	--      - cost:     function that take two nodes, `from` and `to`, and return the cost
	--                  to go from `from` to `to`
	--                  must be curried
	--      - heuristic:function that takes a node and return the estimated cost to reach
	--                  the goal
	--      - goal:     function that takes a node and return whether the goal has been
	--                  reached or not
	--      - start:    the starting node
	--
	-- return nil in case of failure
	--        the ordered path in case of success, as an array

	local function createNodeStorage()
		local storage = {}
		local t = {
			__newindex = function(self, key, value)
				rawset(self, tostring(key.x) .. "," .. tostring(key.y) .. "," .. tostring(key.z), value)
			end,
			__index = function(self, key)
				return rawget(self, tostring(key.x) .. "," .. tostring(key.y) .. "," .. tostring(key.z))
			end,
		}
		setmetatable(storage, t)
		return storage
	end

	local function aStar(expand)
		return function(cost)
			return function(heuristic)
				return function(goal)
					return function(start)
						local open = PQ.new()
						local closed = createNodeStorage()

						local cameFrom = createNodeStorage()

						local tCost = createNodeStorage()

						open:insert(0, start)
						cameFrom[start] = nil
						tCost[start] = 0
						for current in PQ.pop, open do
							coroutine.yield()
							if goal(current) then
								return backtrack(current, cameFrom)
							else
								closed[current] = true
								local costFromCurrentTo = cost(current)
								for _, neighbor in pairs(expand(current)) do
									if not closed[neighbor] then
										local tmpCost = tCost[current] + costFromCurrentTo(neighbor)
										if maybe(true)(inferior(tmpCost))(tCost[neighbor]) then
											cameFrom[neighbor] = current
											tCost[neighbor] = tmpCost
											open:insert(tmpCost + heuristic(neighbor), neighbor)
										end
									end
								end
							end
						end
						return nil
					end
				end
			end
		end
	end

	return aStar
end)()

local rb = _G.libs.relativeBlocks

rb.toggleVisibility(true)

---disables the area until it gets reset
---@param timeout number?
local function disable(timeout)
	if not timeout then
		while true do
			coroutine.yield()
		end
	end
	asyncSleepClock(timeout)
end

local function canFitIn(x)
	return math.abs(x % 1) <= 0.7 or math.abs(x % 1) >= 0.3
end
local function canFitInY(y)
	log(math.abs(y % 1))
	return
end
local lastJump = os.clock()

--- goes to given node, assumes it is possible to get to it
---@param node { x: number, y: number, z: number }
local function gotoNode(node)
	look(0, 0)
	rb.sShow({
		xray = true,
		position = { node.x, node.y, node.z },
		color = "pink",
		opacity = 1,
	})
	local epsilon = 0.5
	local dist = 1 / 0
	local fallDist = playerDetails.getFallDist()
	while dist > epsilon + epsilon * 0.5 do
		local x, y, z = getPlayerPos()
		local nx, ny, nz = node.x + 0.5, node.y + 0.5, node.z + 0.5
		local dx, dy, dz = nx - x, ny - y, nz - z
		if (playerDetails.isOnGround() or fallDist > 0) and dy > 0.2 then
			startFlying()
			asyncSleepClock(1000)
		end
		dist = math.sqrt(dx * dx + dy * dy + dz * dz)
		-- log(dist)
		log({ dx, dy, dz })
		if dy >= epsilon then
			local now = os.clock()
			log(now - lastJump)
			if now - lastJump > 0.2 or now - lastJump < 0.7 then
				lastJump = os.clock()
				log("jumping")
				key("SPACE", 50)
				asyncSleepClock(50)
			end
		elseif dy <= -epsilon or math.abs(y % 1) >= 0.2 then
			sneak(10)
			asyncSleepClock(10)
		end

		if dz > epsilon or not canFitIn(z) then
			forward(10)
			asyncSleepClock(50)
		elseif dz < -epsilon or not canFitIn(z) then
			back(10)
			asyncSleepClock(50)
		elseif dx > epsilon or not canFitIn(x) then
			left(10)
			asyncSleepClock(50)
		elseif dx < -epsilon or not canFitIn(x) then
			right(10)
			asyncSleepClock(50)
		end
		coroutine.yield()
	end
end
local colortable = { "blue", "cyan" }
local function expand(n, from)
	local deltas = { { 1, 0, 0 }, { -1, 0, 0 }, { 0, 1, 0 }, { 0, -1, 0 }, { 0, 0, 1 }, { 0, 0, -1 } }
	local accessible = {}
	for i, delta in ipairs(deltas) do
		local x, y, z = n.x + delta[1], n.y + delta[2], n.z + delta[3]

		-- rb.sShow({
		-- 	xray = true,
		-- 	position = { x, y, z },
		-- 	color = colortable[math.random(1, #colortable)],
		-- 	opacity = 1,
		-- })
		if getBlockName(x, y, z) == "Air" and getBlockName(x, y + 1, z) == "Air" then
			accessible[#accessible + 1] = { x = x, y = y, z = z }
		end
	end
	return accessible
end
local function cost(from)
	return function(to)
		return 1
	end
end
local function heuristicGoal(goal)
	return function(node)
		local dx = node.x - goal.x
		local dy = node.y - goal.y
		local dz = node.z - goal.z
		return dx * dx + dy * dy * 2 + dz * dz
	end
end
local function createGoal(goal)
	return function(n)
		return n.x == goal.x and n.y == goal.y and n.z == goal.z
	end
end

local function pathfind(gx, gy, gz)
	local goal = { x = gx, y = gy, z = gz }

	rb.sShow({
		xray = true,
		position = { gx, gy, gz },
		color = "red",

		opacity = 1,
	})
	local x, y, z = getPlayerBlockPos()
	local start = { x = x, y = y, z = z }
	local simpleAStar = aStar(expand)(cost)(heuristicGoal(goal))
	local path = simpleAStar(createGoal(goal))(start) or {}
	startFlying()
	for i, node in ipairs(path) do
		gotoNode(node)
		-- rb.sShow({
		-- 	xray = true,
		-- 	position = { node.x, node.y, node.z },
		-- 	color = "green",
		-- 	opacity = 1,
		-- })
	end
	_G.MOLEBOT_G.pathfinderGoal = nil
end
-- run("~/macros/bundled-main.lua")

local lx, ly, lz = 0, 0, 0
---@param self any
---@param args table
local function pathfinder(self, args)
	local gx, gy, gz = table.unpack(_G.MOLEBOT_G.pathfinderGoal)
	gy = gy + 1
	if getBlockName(gx, gy, gz) ~= "Air" or getBlockName(gx, gy + 1, gz) ~= "Air" then
		rb.sShow({
			clear = true,
		})
		return
	end
	local now = os.clock()
	pathfind(gx, gy, gz)
	log("Time taken: ", os.clock() - now)
	disable(1000)
end
return { cb = pathfinder, options = { saveState = true } }
