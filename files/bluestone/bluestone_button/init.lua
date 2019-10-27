-- WALL BUTTON
-- A button that when pressed emits power for 1 second
-- and then turns off again

local function button_turnoff(pos, material)
	local node = minetest.get_node(pos)
	minetest.swap_node(pos, {name = "mesecons_button:button_" .. material .. "_off", param2 = node.param2})
	minetest.sound_play("mesecons_button_pop", {pos = pos})
	local rules = mesecon.rules.buttonlike_get(node)
	mesecon.receptor_off(pos, rules)
end

local boxes_off = { -4/16, -2/16, 8/16, 4/16, 2/16, 6/16 } 
local boxes_on  = { -4/16, -2/16, 8/16, 4/16, 2/16, 7/16 }

local function on_place(itemstack, placer, pointed_thing)
	if pointed_thing.type == "node" then
		local nodepos = minetest.get_pointed_thing_position(pointed_thing)
		local node = minetest.get_node(nodepos)
		local def = minetest.registered_nodes[node.name]
		if not def.walkable then
			return itemstack -- Place on walkable node, not allowed
		end
		local undery = pointed_thing.under.y
		local posy = pointed_thing.above.y
		if undery > posy then -- Place on celling, not allowed
			return itemstack
		elseif undery < posy then -- Place on bottom, not allowed
			return itemstack
		else
			return minetest.item_place(itemstack, placer, pointed_thing)
		end
	end
end

local function press(pos, node, material)
	minetest.swap_node(pos, {name = "mesecons_button:button_" .. material .. "_on", param2 = node.param2})
	mesecon.receptor_on(pos, mesecon.rules.buttonlike_get(node))
	minetest.sound_play("mesecons_button_push", {pos=pos})
	minetest.get_node_timer(pos):start(1)
end

local mesecons_off = [[
	receptor = {
		state = mesecon.state.off,
		rules = mesecon.rules.buttonlike_get
	}
]]

local mesecons_on = [[
	receptor = {
		state = mesecon.state.on,
		rules = mesecon.rules.buttonlike_get
	}
]]

minetest.register_node(":mesecons_button:button_stone_off", {
	description = "Stone Button",
	drawtype = "nodebox",
	tiles = {"default_stone.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	walkable = false,
	on_rotate = mesecon.buttonlike_onrotate,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = boxes_off
	},
	groups = {dig_immediate = 2, attached_node2 = 1},
	sounds = default.node_sound_stone_defaults(),
	
	on_place = on_place,
	on_punch = function(pos, node)
		press(pos, node, "stone")
	end,
	on_rightclick = function(pos, node)
		press(pos, node, "stone")
	end,
	mesecons = mesecons_off,
	on_blast = mesecon.on_blastnode,
})

minetest.register_node(":mesecons_button:button_stone_on", {
	drawtype = "nodebox",
	tiles = {"default_stone.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	walkable = false,
	on_rotate = false,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = boxes_on
	},
	groups = {dig_immediate = 2, attached_node2 = 1, not_in_creative_inventory = 1},
	drop = "mesecons_button:button_stone_off",
	sounds = default.node_sound_stone_defaults(),

	mesecons = mesecons_on,
	on_timer = function(pos, node)
		button_turnoff(pos, "stone")
	end,
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "mesecons_button:button_stone_off 2",
	recipe = {{"default:cobble"}}
})

minetest.register_node(":mesecons_button:button_wood_off", {
	description = "Wood Button",
	drawtype = "nodebox",
	tiles = {"default_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	walkable = false,
	on_rotate = mesecon.buttonlike_onrotate,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = boxes_off
	},
	groups = {dig_immediate = 2, attached_node2 = 1},
	sounds = default.node_sound_stone_defaults(),

	on_place = on_place,
	on_punch = function(pos, node)
		press(pos, node, "wood")
	end,
	on_rightclick = function(pos, node)
		press(pos, node, "wood")
	end,
	mesecons = mesecons_off,
	on_blast = mesecon.on_blastnode
})

minetest.register_node(":mesecons_button:button_wood_on", {
	drawtype = "nodebox",
	tiles = {"default_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	walkable = false,
	on_rotate = false,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = boxes_on
	},
	groups = {dig_immediate = 2, attached_node2 = 1, not_in_creative_inventory = 1},
	drop = "mesecons_button:button_wood_off",
	sounds = default.node_sound_stone_defaults(),

	mesecons = mesecons_on,
	on_timer = function(pos, node)
		button_turnoff(pos, "wood")
	end,
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "mesecons_button:button_wood_off 2",
	recipe = {{"group:wood"}}
})
