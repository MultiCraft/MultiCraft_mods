-- Common rail registrations

carts:register_rail("carts:rail", {
	description = "Rail",
	tiles = {
		"carts_rail_straight.png", "carts_rail_curved.png",
		"carts_rail_t_junction.png", "carts_rail_crossing.png"
	},
	groups = carts:get_rail_groups()
})

minetest.register_craft({
	output = "carts:rail 16",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"}
	}
})

-- Power rail
carts:register_rail("carts:powerrail", {
	description = "Powered Rail",
	tiles = {
		"carts_rail_straight_pwr.png", "carts_rail_curved_pwr.png",
		"carts_rail_t_junction_pwr.png", "carts_rail_crossing_pwr.png"
	},
	groups = carts:get_rail_groups(),
	after_place_node = function(pos, placer, itemstack)
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "0.5")
		end
	end,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				carts:boost_rail(pos, 0.5)
			end,
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "0")
			end
		}
	}
})

minetest.register_craft({
	output = "carts:powerrail 6",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"default:gold_ingot", "group:stick", "default:gold_ingot"},
		{"default:gold_ingot", "mesecons:wire_00000000_off", "default:gold_ingot"}
	}
})

-- Brake rail
carts:register_rail("carts:brakerail", {
	description = "Brake Rail",
	tiles = {
		"carts_rail_straight_brk.png", "carts_rail_curved_brk.png",
		"carts_rail_t_junction_brk.png", "carts_rail_crossing_brk.png"
	},
	groups = carts:get_rail_groups(),
	after_place_node = function(pos, placer, itemstack)
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "-0.3")
		end
	end,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "-0.3")
			end,
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "0")
			end
		}
	}
})

minetest.register_craft({
	output = "carts:brakerail 6",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

carts:register_rail("carts:startstoprail", {
	description = "Start-stop Rail",
	tiles = {
		"carts_rail_straight_ss.png", "carts_rail_curved_ss.png",
		"carts_rail_t_junction_ss.png", "carts_rail_crossing_ss.png"
	},
	groups = carts:get_rail_groups(),
	after_place_node = function(pos, placer, itemstack)
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "halt")
		end
	end,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				carts:boost_rail(pos, 0.5)
			end,
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "halt")
			end
		}
	}
})

minetest.register_craft({
	output = "carts:startstoprail 2",
	recipe = {
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "mesecons_torch:mesecon_torch_on", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"}
	}
})
