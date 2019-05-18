-- Common rail registrations

boost_cart:register_rail("boost_cart:rail", {
	description = "Rail",
	tiles = {
		"carts_rail_straight.png", "carts_rail_curved.png",
		"carts_rail_t_junction.png", "carts_rail_crossing.png"
	},
	groups = boost_cart:get_rail_groups(),
}, {})

minetest.register_craft({
	output = "boost_cart:rail 16",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
})

--[[
-- Moreores' copper rail
if minetest.get_modpath("moreores") then
	minetest.register_alias("carts:copperrail", "moreores:copper_rail")

	if minetest.raillike_group then
		-- Ensure that this rail uses the same connect_to_raillike
		local new_groups = minetest.registered_nodes["moreores:copper_rail"].groups
		new_groups.connect_to_raillike = minetest.raillike_group("rail")
		minetest.override_item("moreores:copper_rail", {
			groups = new_groups
		})
	end
else
	boost_cart:register_rail(":carts:copperrail", {
		description = "Copper rail",
		tiles = {
			"carts_rail_straight_cp.png", "carts_rail_curved_cp.png",
			"carts_rail_t_junction_cp.png", "carts_rail_crossing_cp.png"
		},
		groups = boost_cart:get_rail_groups()
	})

	minetest.register_craft({
		output = "carts:copperrail 12",
		recipe = {
			{"default:copper_ingot", "", "default:copper_ingot"},
			{"default:copper_ingot", "group:stick", "default:copper_ingot"},
			{"default:copper_ingot", "", "default:copper_ingot"},
		}
	})
end
]]
-- Power rail
boost_cart:register_rail(":carts:powerrail", {
	description = "Powered rail",
	tiles = {
		"carts_rail_straight_pwr.png", "carts_rail_curved_pwr.png",
		"carts_rail_t_junction_pwr.png", "carts_rail_crossing_pwr.png"
	},
	groups = boost_cart:get_rail_groups(),
	after_place_node = function(pos, placer, itemstack)
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "0.5")
		end
	end,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				boost_cart:boost_rail(pos, 0.5)
			end,
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "0")
			end,
		},
	},
})

minetest.register_craft({
	output = "carts:powerrail 6",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"default:gold_ingot", "group:stick", "default:gold_ingot"},
		{"default:gold_ingot", "mesecons:wire_00000000_off", "default:gold_ingot"},
	}
})

-- Brake rail
boost_cart:register_rail(":carts:brakerail", {
	description = "Brake rail",
	tiles = {
		"carts_rail_straight_brk.png", "carts_rail_curved_brk.png",
		"carts_rail_t_junction_brk.png", "carts_rail_crossing_brk.png"
	},
	groups = boost_cart:get_rail_groups(),
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
			end,
		},
	},
})

minetest.register_craft({
	output = "carts:brakerail 6",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	}
})

boost_cart:register_rail("boost_cart:startstoprail", {
	description = "Start-stop rail",
	tiles = {
		"carts_rail_straight_ss.png", "carts_rail_curved_ss.png",
		"carts_rail_t_junction_ss.png", "carts_rail_crossing_ss.png"
	},
	groups = boost_cart:get_rail_groups(),
	after_place_node = function(pos, placer, itemstack)
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "halt")
		end
	end,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				boost_cart:boost_rail(pos, 0.5)
			end,
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "halt")
			end,
		},
	},
})

minetest.register_craft({
	output = "boost_cart:startstoprail 2",
	recipe = {
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "mesecons_torch:mesecon_torch_on", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
	}
})
