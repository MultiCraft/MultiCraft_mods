local modpath = minetest.get_modpath("3d_armor")

dofile(modpath .. "/api.lua")
dofile(modpath .. "/armor.lua")

-- Register Callbacks

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	for field, _ in pairs(fields) do
		if string.find(field, "skins_set_") then
			minetest.after(0, function(player)
				local skin = armor:get_player_skin(name)
				armor.textures[name].skin = skin..".png"
				armor:set_player_armor(player)
			end, player)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local armor_inv = minetest.create_detached_inventory(name.."_armor",{
		allow_put = function(inv, listname, index, stack, player)
			local item = stack:get_name()
			if not minetest.registered_items[item] and not minetest.registered_items[item].groups then return 0 end
			if  minetest.registered_items[item].groups['armor_head']
			and index == 1 then
				return 1
			end
			if  minetest.registered_items[item].groups['armor_torso']
			and index == 2 then
				return 1
			end
			if  minetest.registered_items[item].groups['armor_legs']
			and index == 3 then
				return 1
			end
			if  minetest.registered_items[item].groups['armor_feet']
			and index == 4 then
				return 1
			end
			return 0
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		on_put = function(inv, listname, index, stack, player)
			armor:save_armor_inventory(player)
			armor:set_player_armor(player)
			--armor:update_inventory(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			armor:save_armor_inventory(player)
			armor:set_player_armor(player)
			--armor:update_inventory(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			armor:save_armor_inventory(player)
			armor:set_player_armor(player)
			--armor:update_inventory(player)
		end,
	}, name)

	armor_inv:set_size("armor", 4)
	if not armor:load_armor_inventory(player) then
		local player_inv = player:get_inventory()
		if player_inv then
			player_inv:set_size("armor", 4)
			for i=1, 4 do
				local stack = player_inv:get_stack("armor", i)
				armor_inv:set_stack("armor", i, stack)
			end
			player_inv:set_size("armor", 0)
		end
		armor:save_armor_inventory(player)
	end

	armor.player_hp[name] = 0
	armor.def[name] = {
		state = 0,
		count = 0,
		level = 0,
		heal = 0,
		jump = 1,
		speed = 1,
		gravity = 1
	}
	armor.textures[name] = {
		skin = armor.default_skin..".png",
		armor = "blank.png",
		wielditem = "blank.png",
		cube = "blank.png",
		preview = armor.default_skin.."_preview.png",
	}
	if minetest.get_modpath("skins") then
		local skin = skins.skins[name]
		if skin and skins.get_type(skin) == skins.type.MODEL then
			armor.textures[name].skin = skin..".png"
		end
	elseif minetest.get_modpath("simple_skins") then
		local skin = skins.skins[name]
		if skin then
			armor.textures[name].skin = skin..".png"
		end
	end
	if minetest.get_modpath("player_textures") then
		local filename = minetest.get_modpath("player_textures").."/textures/player_"..name
		local f = io.open(filename..".png")
		if f then
			f:close()
			armor.textures[name].skin = "player_"..name..".png"
		end
	end
	for i=1, 1 do
		minetest.after(1 * i, function(player)
			armor:set_player_armor(player)
		end, player)
	end
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	local pos = player:get_pos()
	if name and pos then
		local drop = {}
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
			if armor.def[name].heal > math.random(100) then
				hp_change = 0
			end
		end
		armor:update_armor(player)
	end
	return hp_change
end)
