local S = mesecon.S

default.register_torch("bluestone_torch:torch", {
	description = S("Bluestone Torch"),
	tiles = {{
		name = "bluestone_torch_animated.png",
		animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 2}
	}},
	inventory_image = "bluestone_torch.png",
	wield_image = "bluestone_torch.png",
	use_texture_alpha = "clip",
	light_source = 10,
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1, torch = 1},
	sounds = default.node_sound_wood_defaults(),

	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = {
			{x =  1, y =  0,  z =  0},
			{x = -1, y =  0,  z =  0},
			{x =  0, y = -1,  z =  0},
			{x =  0, y =  0,  z =  1},
			{x =  0, y =  0,  z = -1}
		}
	}},

	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "bluestone_torch:torch 4",
	recipe = {
		{"mesecons:wire_00000000_off"},
		{"default:stick"}
	}
})
