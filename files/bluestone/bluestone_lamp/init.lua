minetest.register_node(":mesecons_lightstone:lightstone_off", {
	description = "Lamp",
	tiles = {"bluestone_lamp_off.png"},
	is_ground_content = false,
	groups = {cracky = 2, mesecon_effector_off = 1, mesecon = 2},
	sounds = default.node_sound_glass_defaults(),
	mesecons = {effector = {
		action_on = function(pos, node)
			minetest.swap_node(pos, {name = "mesecons_lightstone:lightstone_on", param2 = node.param2})
		end,
	}},
	on_blast = mesecon.on_blastnode,
})

minetest.register_node(":mesecons_lightstone:lightstone_on", {
	tiles = {"bluestone_lamp_on.png"},
	is_ground_content = false,
	groups = {cracky = 2, not_in_creative_inventory = 1, mesecon = 2},
	drop = "mesecons_lightstone:lightstone_off",
	light_source = minetest.LIGHT_MAX - 2,
	sounds = default.node_sound_glass_defaults(),
	mesecons = {effector = {
		action_off = function(pos, node)
			minetest.swap_node(pos, {name = "mesecons_lightstone:lightstone_off", param2 = node.param2})
		end,
	}},
	on_blast = mesecon.on_blastnode,
})

minetest.register_craft({
	output = "mesecons_lightstone:lightstone_off",
	recipe = {
		{"", "mesecons:wire_00000000_off", ""},
		{"mesecons:wire_00000000_off", "default:glowstone","mesecons:wire_00000000_off"},
		{"", "mesecons:wire_00000000_off", ""},
	}
})
