local function get_chest_neighborpos(pos, param2, side)
	if side == "right" then
		if param2 == 0 then
			return {x = pos.x - 1, y = pos.y, z = pos.z}
		elseif param2 == 1 then
			return {x = pos.x, y = pos.y, z = pos.z + 1}
		elseif param2 == 2 then
			return {x = pos.x + 1, y = pos.y, z = pos.z}
		elseif param2 == 3 then
			return {x = pos.x, y = pos.y, z = pos.z - 1}
		end
	else
		if param2 == 0 then
			return {x = pos.x + 1, y = pos.y, z = pos.z}
		elseif param2 == 1 then
			return {x = pos.x, y = pos.y, z = pos.z - 1}
		elseif param2 == 2 then
			return {x = pos.x - 1, y = pos.y, z = pos.z}
		elseif param2 == 3 then
			return {x = pos.x, y = pos.y, z = pos.z + 1}
		end
	end
end

local function can_dig(pos, oldmetadata)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

local function allow_metadata_inventory_take(pos, _, _, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function allow_metadata_inventory_put(pos, _, _, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local chest_formspec = [[
	size[9,8.75]
	background[-0.2,-0.26;9.41,9.49;formspec_chest.png]
	]] .. default.gui_bg ..
	default.listcolors .. [[
	image_button_exit[8.35,-0.19;0.75,0.75;close.png;exit;;true;false;close_pressed.png]
	list[current_name;main;0,0.5;9,3;]
	list[current_player;main;0,4.5;9,3;9]
	list[current_player;main;0,7.74;9,1;]
]]

local large_chest_formspec = [[
	size[9,11.5]
	background[-0.2,-0.35;9.42,12.46;formspec_chest_large.png]
	]] .. default.gui_bg ..
	default.listcolors .. [[
	image_button_exit[8.35,-0.28;0.75,0.75;close.png;exit;;true;false;close_pressed.png]
	list[current_player;main;0.01,7.4;9,3;9]
	list[current_player;main;0,10.61;9,1;]
]]

minetest.register_node("default:chest", {
	description = "Chest",
	tiles = {
		"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local param2 = minetest.get_node(pos).param2
		local meta = minetest.get_meta(pos)
		if minetest.get_node(get_chest_neighborpos(pos, param2, "right")).name == "default:chest" then
			minetest.set_node(pos, {name="default:chest_right", param2 = param2})
			local pos2 = get_chest_neighborpos(pos, param2, "right")
			meta:set_string("formspec",
				large_chest_formspec ..
				"list[nodemeta:" .. pos2.x .. "," .. pos2.y .. "," .. pos2.z .. ";main;0.01,0.4;9,3;]" ..
				"list[current_name;main;0.01,3.39;9,3;]")
			meta:set_string("infotext", Sl("Large Chest"))
			minetest.swap_node(pos2, {name = "default:chest_left", param2 = param2})
			local meta2 = minetest.get_meta(pos2)
			meta2:set_string("formspec",
				large_chest_formspec ..
				"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;0.01,3.39;9,3;]" ..
				"list[current_name;main;0.01,0.4;9,3;]")
			meta2:set_string("infotext", Sl("Large Chest"))
		elseif minetest.get_node(get_chest_neighborpos(pos, param2, "left")).name == "default:chest" then
			minetest.set_node(pos, {name = "default:chest_left", param2 = param2})
			local pos2 = get_chest_neighborpos(pos, param2, "left")
			meta:set_string("formspec",
				large_chest_formspec ..
				"list[nodemeta:" .. pos2.x .. "," .. pos2.y .. "," .. pos2.z .. ";main;0.01,3.39;9,3;]" ..
				"list[current_name;main;0.01,0.4;9,3;]")
			meta:set_string("infotext", Sl("Large Chest"))
			minetest.swap_node(pos2, {name = "default:chest_right", param2 = param2})
			local meta2 = minetest.get_meta(pos2)
			meta2:set_string("formspec",
				large_chest_formspec ..
				"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;0.01,0.4;9,3;]" ..
				"list[current_name;main;0.01,3.39;9,3;]")
			meta2:set_string("infotext", Sl("Large Chest"))
		else
			meta:set_string("formspec", chest_formspec)
			meta:set_string("infotext", Sl("Chest"))
		end
		local inv = meta:get_inventory()
		inv:set_size("main", 9*3)
	end,

	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_take = allow_metadata_inventory_take
})

minetest.register_node("default:chest_left", {
	tiles = {
		"default_chest_top_big.png", "default_chest_top_big.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side_big.png^[transformFX", "default_chest_front_big.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	drop = "default:chest",
	sounds = default.node_sound_wood_defaults(),

	on_destruct = function(pos)
		local param2 = minetest.get_node(pos).param2
		local pos2 = get_chest_neighborpos(pos, param2, "left")
		if not pos2 or minetest.get_node(pos2).name ~= "default:chest_right" then
			return
		end
		local meta = minetest.get_meta(pos2)
		meta:set_string("formspec", chest_formspec)
		meta:set_string("infotext", Sl("Chest"))
		minetest.swap_node(pos2, {name = "default:chest", param2 = param2})
	end,

	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_take = allow_metadata_inventory_take
})

minetest.register_node("default:chest_right", {
	tiles = {
		"default_chest_top_big.png^[transformFX", "default_chest_top_big.png^[transformFX", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side_big.png", "default_chest_front_big.png^[transformFX"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	drop = "default:chest",
	sounds = default.node_sound_wood_defaults(),

	on_destruct = function(pos)
		local param2 = minetest.get_node(pos).param2
		local pos2 = get_chest_neighborpos(pos, param2, "right")
		if not pos2 or minetest.get_node(pos2).name ~= "default:chest_left" then
			return
		end
		local meta = minetest.get_meta(pos2)
		meta:set_string("formspec", chest_formspec)
		meta:set_string("infotext", Sl("Chest"))
		minetest.swap_node(pos2, {name = "default:chest", param2 = param2})
	end,

	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_take = allow_metadata_inventory_take
})
