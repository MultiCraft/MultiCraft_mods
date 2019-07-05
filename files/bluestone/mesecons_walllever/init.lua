-- WALL LEVER
-- Basically a switch that can be attached to a wall
-- Powers the block 2 nodes behind (using a receiver)
mesecon.register_node("mesecons_walllever:wall_lever", {
	description = "Lever",
	drawtype = "nodebox",
	inventory_image = "jeija_wall_lever.png",
	wield_image = "jeija_wall_lever.png",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,
	sounds = default.node_sound_wood_defaults(),
	on_punch = function(pos, node)
		if (mesecon.flipstate(pos, node) == "on") then
			mesecon.receptor_on(pos, mesecon.rules.buttonlike_get(node))
		else
			mesecon.receptor_off(pos, mesecon.rules.buttonlike_get(node))
		end
		minetest.sound_play("mesecons_lever", {pos=pos})
	end,
	on_rightclick = function(pos, node)
		if (mesecon.flipstate(pos, node) == "on") then
			mesecon.receptor_on(pos, mesecon.rules.buttonlike_get(node))
		else
			mesecon.receptor_off(pos, mesecon.rules.buttonlike_get(node))
		end
		minetest.sound_play("mesecons_lever", {pos=pos})
	end
},{
	tiles = {
		"jeija_wall_lever_tb.png",
		"jeija_wall_lever_bottom.png",
		"jeija_wall_lever_sides.png",
		"jeija_wall_lever_sides.png",
		"jeija_wall_lever_back.png",
		"jeija_wall_lever_off.png",
	},
	node_box = {
		type = "fixed",
		fixed = {{ -2/16, -3/16,  8/16, 2/16, 3/16,  4/16 }, -- the base
				 { -1/16, -8/16,  7/16, 1/16, 0/16,  5/16 }} -- the lever itself.
	},
	mesecons = {receptor = {
		rules = mesecon.rules.buttonlike_get,
		state = mesecon.state.off
	}},
	groups = {dig_immediate = 2},
},{
	tiles = {
		"jeija_wall_lever_top.png",
		"jeija_wall_lever_tb.png",
		"jeija_wall_lever_sides.png",
		"jeija_wall_lever_sides.png",
		"jeija_wall_lever_back.png",
		"jeija_wall_lever_on.png",
	},
	node_box = {
		type = "fixed",
		fixed = {{ -2/16, -3/16,  8/16, 2/16, 3/16,  4/16 }, -- the base
				 { -1/16,  0/16,  7/16, 1/16, 8/16,  5/16 }} -- the lever itself.
	},
	on_rotate = false,
	mesecons = {receptor = {
		rules = mesecon.rules.buttonlike_get,
		state = mesecon.state.on
	}},
	groups = {dig_immediate = 2, not_in_creative_inventory = 1}
})

minetest.register_craft({
	output = "mesecons_walllever:wall_lever_off 2",
	recipe = {
		{"default:cobble"},
		{"default:stick"},
	}
})
