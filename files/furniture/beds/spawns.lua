local world_path = minetest.get_worldpath()
local file = world_path .. "/beds_spawns"

function beds.read_spawns()
	local spawns = beds.spawn
	local input = io.open(file, "r")
	if input then
		repeat
			local x = input:read("*n")
			if x == nil then
				break
			end
			local y = input:read("*n")
			local z = input:read("*n")
			local name = input:read("*l")
			spawns[name:sub(2)] = {x = x, y = y, z = z}
		until input:read(0) == nil
		io.close(input)
	end
end

beds.read_spawns()

function beds.save_spawns()
	if not beds.spawn then
		return
	end
	local data = {}
	local output = io.open(file, "w")
	for k, v in pairs(beds.spawn) do
		table.insert(data, string.format("%.1f %.1f %.1f %s\n", v.x, v.y, v.z, k))
	end
	output:write(table.concat(data))
	io.close(output)
end

function beds.set_spawns()
	for name,_ in pairs(beds.player) do
		local player = minetest.get_player_by_name(name)
		local p = player:get_pos()
		-- but don't change spawn location if borrowing a bed
		if not minetest.is_protected(p, name) then
			beds.spawn[name] = p
		end
	end
	beds.save_spawns()
end

function beds.remove_spawns_at(pos)
	for name, p in pairs(beds.spawn) do
		if vector.equals(vector.round(p), pos) then
			beds.spawn[name] = nil
		end
	end
	beds.save_spawns()
end
