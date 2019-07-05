default.register_torch("bluestone_torch:torch", {
	description = "Bluestone Torch",
	tiles = {{
		name = "bluestone_torch.png",
	--	name = "bluestone_torch_animated.png",
	--	animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 3.3}
	}},
	inventory_image = "bluestone_torch.png",
	wield_image = "bluestone_torch.png",
	light_source = 10,
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1, torch = 1},
	sounds = default.node_sound_wood_defaults(),
	mesecons = {receptor = {
		state = mesecon.state.on
	}},
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "bluestone_torch:torch 4",
	recipe = {
	{"mesecons:wire_00000000_off"},
	{"default:stick"},}
})

minetest.register_alias("mesecons_torch:mesecon_torch_off", "bluestone_torch:torch")
minetest.register_alias("mesecons_torch:mesecon_torch_on", "bluestone_torch:torch")
