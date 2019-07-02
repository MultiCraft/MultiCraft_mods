local age                   = 0.5 -- How old an item has to be before collecting
local radius_magnet         = 2   -- Radius of item magnet

local function collect_items(player)
	local pos = player:get_pos()
	if not minetest.is_valid_pos(pos) then
		return
	end
	-- Detect
	local col_pos = vector.add(pos, {x = 0, y = 1.3, z = 0})
	local objects = minetest.get_objects_inside_radius(col_pos, radius_magnet)
	for _, object in ipairs(objects) do
		local entity = object:get_luaentity()
		if entity and not object:is_player() and
				not entity.collectioner and
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
					minetest.after(0.05, function()
						minetest.sound_play("item_drop_pickup", {
							pos = col_pos,
							max_hear_distance = 10,
							gain = 0.2,
						})
						entity.itemstring = ""
						object:remove()
						inv:add_item("main", item)
					end)
				end
			end
		end
	end
end

-- Item collection

minetest.register_playerstep(function(dtime, playernames)
	for _, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() and player:get_hp() > 0 then
			collect_items(player)
		end
	end
end, minetest.is_singleplayer()) -- Force step in singlplayer mode only
