--
-- Temporary chest solution
--

local function get_chest_neighborpos(pos, param2, side)
	if side == "right" then
		if param2 == 0 then
			return {x=pos.x-1, y=pos.y, z=pos.z}
		elseif param2 == 1 then
			return {x=pos.x, y=pos.y, z=pos.z+1}
		elseif param2 == 2 then
			return {x=pos.x+1, y=pos.y, z=pos.z}
		elseif param2 == 3 then
			return {x=pos.x, y=pos.y, z=pos.z-1}
		end
	else
		if param2 == 0 then
			return {x=pos.x+1, y=pos.y, z=pos.z}
		elseif param2 == 1 then
			return {x=pos.x, y=pos.y, z=pos.z-1}
		elseif param2 == 2 then
			return {x=pos.x-1, y=pos.y, z=pos.z}
		elseif param2 == 3 then
			return {x=pos.x, y=pos.y, z=pos.z+1}
		end
	end
end

minetest.register_node("default:chest", {
	description = "Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local param2 = minetest.get_node(pos).param2
		local meta = minetest.get_meta(pos)
		if minetest.get_node(get_chest_neighborpos(pos, param2, "right")).name == "default:chest" then
			minetest.set_node(pos, {name="default:chest_right",param2=param2})
			local p = get_chest_neighborpos(pos, param2, "right")
			meta:set_string("formspec",
					"size[9,11.5]"..
					"background[-0.2,-0.35;9.42,12.46;formspec_chest_large.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.28;0.75,0.75;close.png;exit;;true;true;]"..
					"list[nodemeta:"..p.x..","..p.y..","..p.z..";main;0.01,0.4;9,3;]"..
					"list[current_name;main;0.01,3.39;9,3;]"..
					"list[current_player;main;0.01,7.4;9,3;9]"..
					"list[current_player;main;0,10.61;9,1;]")
			meta:set_string("infotext", "Large Chest")
			minetest.swap_node(p, {name="default:chest_left", param2=param2})
			local m = minetest.get_meta(p)
			m:set_string("formspec",
					"size[9,11.5]"..
					"background[-0.2,-0.35;9.42,12.46;formspec_chest_large.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.28;0.75,0.75;close.png;exit;;true;true;]"..
					"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0.01,3.39;9,3;]"..
					"list[current_name;main;0.01,0.4;9,3;]"..
					"list[current_player;main;0.01,7.4;9,3;9]"..
					"list[current_player;main;0,10.61;9,1;]")
			m:set_string("infotext", "Large Chest")
		elseif minetest.get_node(get_chest_neighborpos(pos, param2, "left")).name == "default:chest" then
			minetest.set_node(pos, {name="default:chest_left",param2=param2})
			local p = get_chest_neighborpos(pos, param2, "left")
			meta:set_string("formspec",
					"size[9,11.5]"..
					"background[-0.2,-0.35;9.42,12.46;formspec_chest_large.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.28;0.75,0.75;close.png;exit;;true;true;]"..
					"list[nodemeta:"..p.x..","..p.y..","..p.z..";main;0.01,3.39;9,3;]"..
					"list[current_name;main;0.01,0.4;9,3;]"..
					"list[current_player;main;0.01,7.4;9,3;9]"..
					"list[current_player;main;0,10.61;9,1;]")
			meta:set_string("infotext", "Large Chest")
			minetest.swap_node(p, {name="default:chest_right", param2=param2})
			local m = minetest.get_meta(p)
			m:set_string("formspec",
					"size[9,11.5]"..
					"background[-0.2,-0.35;9.42,12.46;formspec_chest_large.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.28;0.75,0.75;close.png;exit;;true;true;]"..
					"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0.01,0.4;9,3;]"..
					"list[current_name;main;0.01,3.39;9,3;]"..
					"list[current_player;main;0.01,7.4;9,3;9]"..
					"list[current_player;main;0,10.61;9,1;]")
			m:set_string("infotext", "Large Chest")
		else
			meta:set_string("formspec",
					"size[9,8.75]"..
					"background[-0.2,-0.26;9.41,9.49;formspec_chest.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.19;0.75,0.75;close.png;exit;;true;true;]"..
					"list[current_name;main;0,0.5;9,3;]"..
					"list[current_player;main;0,4.5;9,3;9]" ..
					"list[current_player;main;0,7.74;9,1;]")
			meta:set_string("infotext", "Chest")
		end
		local inv = meta:get_inventory()
		inv:set_size("main", 9*3)
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local meta = minetest.get_meta(pos)
		local meta2 = meta
		meta:from_table(oldmetadata)
		local inv = meta:get_inventory()
		for i=1,inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
				minetest.add_item(p, stack)
			end
		end
		meta:from_table(meta2:to_table())
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.exit then
		  fields.quit = true
	  --	minetest.show_formspec(sender:get_player_name(), 'quit', "")
		end
	end
})

minetest.register_node("default:chest_left", {
	tiles = {"default_chest_top_big.png", "default_chest_top_big.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side_big.png^[transformFX", "default_chest_front_big.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory=1},
	drop = "default:chest",
	sounds = default.node_sound_wood_defaults(),
	on_destruct = function(pos)
		local m = minetest.get_meta(pos)
		if m:get_string("infotext") == "Chest" then
			return
		end
		local param2 = minetest.get_node(pos).param2
		local p = get_chest_neighborpos(pos, param2, "left")
		if not p or minetest.get_node(p).name ~= "default:chest_right" then
			return
		end
		local meta = minetest.get_meta(p)
			meta:set_string("formspec",
					"size[9,8.75]"..
					"background[-0.2,-0.26;9.41,9.49;formspec_chest.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.19;0.75,0.75;close.png;exit;;true;true;]"..
					"list[current_name;main;0,0.5;9,3;]"..
					"list[current_player;main;0,4.5;9,3;9]" ..
					"list[current_player;main;0,7.74;9,1;]")
		meta:set_string("infotext", "Chest")
		minetest.swap_node(p, {name="default:chest", param2=param2})
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local meta = minetest.get_meta(pos)
		local meta2 = meta
		meta:from_table(oldmetadata)
		local inv = meta:get_inventory()
		for i=1,inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
				minetest.add_item(p, stack)
			end
		end
		meta:from_table(meta2:to_table())
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})

minetest.register_node("default:chest_right", {
	tiles = {"default_chest_top_big.png^[transformFX", "default_chest_top_big.png^[transformFX", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side_big.png", "default_chest_front_big.png^[transformFX"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory=1},
	drop = "default:chest",
	sounds = default.node_sound_wood_defaults(),
	on_destruct = function(pos)
		local m = minetest.get_meta(pos)
		if m:get_string("infotext") == "Chest" then
			return
		end
		local param2 = minetest.get_node(pos).param2
		local p = get_chest_neighborpos(pos, param2, "right")
		if not p or minetest.get_node(p).name ~= "default:chest_left" then
			return
		end
		local meta = minetest.get_meta(p)
			meta:set_string("formspec",
					"size[9,8.75]"..
					"background[-0.2,-0.26;9.41,9.49;formspec_chest.png]"..
					"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
					"image_button_exit[8.35,-0.19;0.75,0.75;close.png;exit;;true;true;]"..
					"list[current_name;main;0,0.5;9,3;]"..
					"list[current_player;main;0,4.5;9,3;9]" ..
					"list[current_player;main;0,7.74;9,1;]")
		meta:set_string("infotext", "Chest")
		minetest.swap_node(p, {name="default:chest", param2=param2})
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local meta = minetest.get_meta(pos)
		local meta2 = meta
		meta:from_table(oldmetadata)
		local inv = meta:get_inventory()
		for i=1,inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
				minetest.add_item(p, stack)
			end
		end
		meta:from_table(meta2:to_table())
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})
