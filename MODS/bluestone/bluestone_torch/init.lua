local S = mesecon.S

default.register_torch("bluestone_torch:torch", {
	description = S("Bluestone Torch"),
	tiles = {{
		name = "bluestone_torch_animated.png",
		animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 2}
	}},
	inventory_image = "bluestone_torch.png",
	wield_image = "bluestone_torch.png",
	wield_image2 = "[combine:32x32:7,0=bluestone_torch.png",
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

-- Fix `on_flood` behavior
local torch_on_flood = minetest.registered_nodes["bluestone_torch:torch"].on_flood
minetest.override_item("bluestone_torch:torch", {
	on_flood = function(...)
		torch_on_flood(...)
		mesecon.on_dignode(...)
		return false
	end
})

local torch_wall_on_flood = minetest.registered_nodes["bluestone_torch:torch_wall"].on_flood
minetest.override_item("bluestone_torch:torch_wall", {
	on_flood = function(...)
		torch_wall_on_flood(...)
		mesecon.on_dignode(...)
		return false
	end
})

local torch_ceiling_on_flood = minetest.registered_nodes["bluestone_torch:torch_ceiling"].on_flood
minetest.override_item("bluestone_torch:torch_ceiling", {
	on_flood = function(...)
		torch_ceiling_on_flood(...)
		mesecon.on_dignode(...)
		return false
	end
})

minetest.register_craft({
	output = "bluestone_torch:torch 4",
	recipe = {
		{"bluestone:dust"},
		{"default:stick"}
	}
})
