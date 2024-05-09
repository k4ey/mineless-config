---- create an outline between -81 and 81  on x and z axis
function createOutline()
	local xp, yp, zp = 0, 152, 0
	local size = 90
	for x = -size, size do
		for z = -size, size do
			if x == -size or x == size or z == -size or z == size then
				say("/setblock " .. x + xp .. " " .. yp .. " " .. z + zp .. " bedrock")
				sleep(10)
			end
		end
	end
end

function scan()
	local xp, yp, zp = 0, 150, 0
	local air = {}
	for x = -80, 80 do
		for z = -80, 80 do
			local block = getBlock(x + xp, yp, z + zp)
			if block.name == "Air" then
				table.insert(air, { x = x + xp, y = yp, z = z + zp })
				say("/setblock " .. x + xp .. " " .. yp .. " " .. z + zp .. " stone")
				sleep(10)
			end
		end
	end
	return air
end
