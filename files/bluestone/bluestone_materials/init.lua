local S = mesecon.S

-- Glue
minetest.register_craftitem("bluestone_materials:glue", {
	description = S("Glue"),
	inventory_image = "mesecons_glue.png"
})

minetest.register_craft({
	output = "bluestone_materials:glue 2",
	type = "cooking",
	recipe = "group:sapling"
})

-- Bluestone Block
minetest.register_node("bluestone_materials:bluestoneblock", {
	description = S("Bluestone Block"),
	tiles = {"bluestone_block.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 1},
	light_source = minetest.LIGHT_MAX - 4,
	sounds = default.node_sound_stone_defaults(),
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = mesecon.rules.alldirs
	}},
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "bluestone_materials:bluestoneblock",
	recipe = {
		{"mesecons:wire_00000000_off", "mesecons:wire_00000000_off", "mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off", "mesecons:wire_00000000_off", "mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off", "mesecons:wire_00000000_off", "mesecons:wire_00000000_off"}
	}
})

minetest.register_craft({
	output = "mesecons:wire_00000000_off 9",
	recipe = {
		{"bluestone_materials:bluestoneblock"}
	}
})
