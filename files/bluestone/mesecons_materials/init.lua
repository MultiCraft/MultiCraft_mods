-- Glue
minetest.register_craftitem("mesecons_materials:glue", {
	image = "mesecons_glue.png",
	on_place_on_ground = minetest.craftitem_place_item,
	description = "Glue",
})

minetest.register_craft({
	output = "mesecons_materials:glue 2",
	type = "cooking",
	recipe = "group:sapling",
	cooktime = 2
})

-- Bluestone Block

minetest.register_node("mesecons_materials:bluestoneblock", {
	description = "Bluestone Block",
	tiles = {"bluestone_block.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 1},
	light_source = minetest.LIGHT_MAX - 4,
	sounds = default.node_sound_stone_defaults(),
	mesecons = {receptor = {
		state = mesecon.state.on
	}},
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "mesecons_materials:bluestoneblock",
	recipe = {
		{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"},
	}
})

minetest.register_craft({
	output = "mesecons:wire_00000000_off 9",
	recipe = {
		{"mesecons_materials:bluestoneblock"},
	}
})

minetest.register_alias("mesecons_torch:bluestoneblock", "mesecons_materials:bluestoneblock")
