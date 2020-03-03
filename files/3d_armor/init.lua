local modpath = minetest.get_modpath("3d_armor")

dofile(modpath .. "/api.lua")
dofile(modpath .. "/armor.lua")

-- Register Callbacks

local function handle_inventory(player)
	if player and player:is_player() then
		armor:save_armor_inventory(player)
		armor:set_player_armor(player)
		if creative and creative.is_enabled_for and
				creative.is_enabled_for(player) then
			local set = set_creative_inventory and set_creative_inventory(player)
		else
			local set = set_survival_inventory and set_survival_inventory(player)
		end
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local armor_inv = minetest.create_detached_inventory(name .. "_armor", {
		allow_put = function(_, _, index, stack)
			local item = minetest.registered_tools[stack:get_name()]
			if not item or not item.groups then
				return 0
			end
			if item.groups.armor_head  and index == 1 then
				return 1
			end
			if item.groups.armor_torso and index == 2 then
				return 1
			end
			if item.groups.armor_legs  and index == 3 then
				return 1
			end
			if item.groups.armor_feet  and index == 4 then
				return 1
			end
			return 0
		end,
		allow_move = function()
			return 0
		end,
		on_put = function(_, _, _, _, player)
			handle_inventory(player)
		end,
		on_take = function(_, _, _, _, player)
			handle_inventory(player)
		end
	}, name)

	armor_inv:set_size("armor", 4)
	if not armor:load_armor_inventory(player) then
		local player_inv = player:get_inventory()
		player_inv:set_size("armor", 4)
		for i = 1, 4 do
			local stack = player_inv:get_stack("armor", i)
			armor_inv:set_stack("armor", i, stack)
		end
		armor:save_armor_inventory(player)
		player_inv:set_size("armor", 0)
	end
	armor.def[name] = {
		level = 0,
		state = 0,
		count = 0,
		heal = 0
	}
	armor.textures[name] = {armor = "blank.png"}
	minetest.after(1, function()
		handle_inventory(player)
	end)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		armor.def[name] = nil
		armor.textures[name] = nil
	end
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	local pos = player:get_pos()
	if name and pos then
		local armor_inv = armor:get_armor_inventory(player)
		if armor_inv then
			for i = 1, armor_inv:get_size("armor") do
				local stack = armor_inv:get_stack("armor", i)
				if stack:get_count() > 0 then
					minetest.item_drop(stack, player, pos)
					armor_inv:set_stack("armor", i, nil)
				end
			end
		end
		armor:save_armor_inventory(player)
		armor:set_player_armor(player)
	end
end)

minetest.register_on_player_hpchange(function(player, hp_change)
	if player and hp_change < 0 then
		local name = player:get_player_name()
		if name then
			local heal = armor.def[name].heal
			if heal >= math.random(100) then
				hp_change = 0
			end
		end
		armor:update_armor(player)
	end
	return hp_change
end)
