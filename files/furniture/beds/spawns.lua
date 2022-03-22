local world_path = minetest.get_worldpath()
local file = world_path .. "/beds_spawns"

local vequals, vround = vector.equals, vector.round

function beds.read_spawns()
	local input = io.open(file, "r")
	local spawns = {}
	beds.spawn = spawns
	if not input then
		return
	end

	local first_char = input:read(1)
	-- Go back to the start of the file
	input:seek("set")

	if first_char == "{" then
		-- JSON
		beds.spawn = minetest.parse_json(input:read("*a")) or spawns
	else
		-- Plain text format
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
	end

	input:close()
end

beds.read_spawns()

function beds.save_spawns()
	if not beds.spawn then
		return
	end
	minetest.safe_file_write(file, minetest.write_json(beds.spawn, true))
end

function beds.set_spawns()
	for name in pairs(beds.player) do
		local player = minetest.get_player_by_name(name)
		local p = vround(player:get_pos())
		-- but don't change spawn location if borrowing a bed
		if not minetest.is_protected(p, name) then
			beds.spawn[name] = p
		end
	end
	beds.save_spawns()
end

function beds.remove_spawns_at(pos)
	for name, p in pairs(beds.spawn) do
		if vequals(p, pos) then
			beds.spawn[name] = nil
		end
	end
	beds.save_spawns()
end
