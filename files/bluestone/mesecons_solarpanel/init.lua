-- Solar Panel
minetest.register_node("mesecons_solarpanel:solar_panel_on", {
	drawtype = "nodebox",
	tiles = { "jeija_solar_panel.png" },
	inventory_image = "jeija_solar_panel.png",
	wield_image = "jeija_solar_panel.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = false,
	node_box = {
		type = "wallmounted",
		wall_bottom	= { -8/16, -8/16, -8/16,  8/16, -2/16, 8/16 },
		wall_top	= { -8/16,  2/16, -8/16,  8/16,  8/16, 8/16 },
		wall_side	= { -2/16, -8/16, -8/16, -8/16,  8/16, 8/16 }
	},
	drop = "mesecons_solarpanel:solar_panel_off",
	groups = {dig_immediate = 3, attached_node = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_glass_defaults(),
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = mesecon.rules.wallmounted_get,
	}},
	on_blast = mesecon.on_blastnode
})

-- Solar Panel
minetest.register_node("mesecons_solarpanel:solar_panel_off", {
	description = "Solar Panel",
	drawtype = "nodebox",
	tiles = { "jeija_solar_panel.png" },
	inventory_image = "jeija_solar_panel.png",
	wield_image = "jeija_solar_panel.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = false,
	node_box = {
		type = "wallmounted",
		wall_bottom	= { -8/16, -8/16, -8/16,  8/16, -2/16, 8/16 },
		wall_top	= { -8/16,  2/16, -8/16,  8/16,  8/16, 8/16 },
		wall_side	= { -2/16, -8/16, -8/16, -8/16,  8/16, 8/16 }
	},
	groups = {dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = mesecon.rules.wallmounted_get
	}},
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "mesecons_solarpanel:solar_panel_off",
	recipe = {
		{"default:glass", "default:glass", "default:glass"},
		{"mesecons:wire_00000000_off", "mesecons:wire_00000000_off", "mesecons:wire_00000000_off"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_abm(
	{nodenames = {"mesecons_solarpanel:solar_panel_off"},
	interval = 3,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local light = minetest.get_node_light(pos, nil)

		if light >= 10 then
			node.name = "mesecons_solarpanel:solar_panel_on"
			minetest.swap_node(pos, node)
			mesecon.receptor_on(pos, mesecon.rules.wallmounted_get(node))
		end
	end
})

minetest.register_abm(
	{nodenames = {"mesecons_solarpanel:solar_panel_on"},
	interval = 3,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local light = minetest.get_node_light(pos, nil)

		if light < 10 then
			node.name = "mesecons_solarpanel:solar_panel_off"
			minetest.swap_node(pos, node)
			mesecon.receptor_off(pos, mesecon.rules.wallmounted_get(node))
		end
	end
})

-- Solar panel
minetest.register_alias("mesecons_solarpanel:solar_panel_inverted_on", "mesecons_solarpanel:solar_panel_on")
minetest.register_alias("mesecons_solarpanel:solar_panel_inverted_off", "mesecons_solarpanel:solar_panel_off")
