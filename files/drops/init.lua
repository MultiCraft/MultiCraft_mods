local age                   = 0.5 -- How old an item has to be before collecting
local radius_magnet         = 2   -- Radius of item magnet
local player_collect_height = 1.3 -- Added to their pos y value
local players_per_step      = 20  -- How many players to process in one server step

local function collect_items(player)
	local pos = player:get_pos()
	if not minetest.is_valid_pos(pos) then
		return
	end
	-- Detect
	local col_pos = vector.add(pos, {x = 0, y = player_collect_height, z = 0})
	local objects = minetest.get_objects_inside_radius(col_pos, radius_magnet)
	for _,object in ipairs(objects) do
		local entity = object:get_luaentity()
		if entity and not object:is_player() and
				entity.name == "__builtin:item" and entity.age > age then
			local item = ItemStack(entity.itemstring)
			local inv = player:get_inventory()
			if item:get_name() ~= "" and inv and
				inv:room_for_item("main", item) then
				-- Magnet
				object:move_to(col_pos)
				entity.collectioner = true
				-- Collect
				if entity.collectioner == true then
					minetest.after(0.01, function()
						minetest.sound_play("item_drop_pickup", {
							pos = pos,
							max_hear_distance = 10,
							gain = 0.25,
						})
						inv:add_item("main", item)
						entity.itemstring = ""
						object:remove()
					end)
				end
			end
		end
	end
end

local function table_iter(t)
	local i = 0
	local n = table.getn(t)
	return function ()
		i = i + 1
		if i <= n then
			return t[i]
		end
	end
end

local player_iter = nil
local function get_next_player()
	if player_iter == nil then
		local names = {}
		for player in table_iter(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if name then
				table.insert(names, name)
			end
		end
		player_iter = table_iter(names)
		if players_per_step > #names then
			players_per_step = #names + 1
		end
		return
	end
	local name = player_iter()
	player_iter = name and player_iter
	return name or get_next_player()
end

-- Item collection
minetest.register_globalstep(function()
	-- only deal with * player count on each server step
	for i = 1, players_per_step do
		local name = get_next_player()
		if name then
			local player = minetest.get_player_by_name(name)
			if player and player:is_player() and player:get_hp() > 0 then
				collect_items(player)
			end
		end
	end
end)
