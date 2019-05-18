local mesecons_rules = mesecon.rules.flat

function boost_cart:turnoff_detector_rail(pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "detector_rail") == 1 then
		if node.name == "boost_cart:detectorrail_on" then --has not been dug
			minetest.swap_node(pos, {name = "boost_cart:detectorrail", param2=node.param2})
		end
		mesecon.receptor_off(pos, mesecons_rules)
	end
end

function boost_cart:signal_detector_rail(pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "detector_rail") ~= 1 then
		return
	end

	if node.name == "boost_cart:detectorrail" then
		minetest.swap_node(pos, {name = "boost_cart:detectorrail_on", param2=node.param2})
	end
	mesecon.receptor_on(pos, mesecons_rules)
	minetest.after(0.5, boost_cart.turnoff_detector_rail, boost_cart, pos)
end

boost_cart:register_rail("boost_cart:detectorrail", {
	description = "Detector rail",
	tiles = {
		"carts_rail_straight_dtc.png", "carts_rail_curved_dtc.png",
		"carts_rail_t_junction_dtc.png", "carts_rail_crossing_dtc.png"
	},
	groups = boost_cart:get_rail_groups({detector_rail = 1}),

	mesecons = {receptor = {state = "off", rules = mesecons_rules}},
})

boost_cart:register_rail("boost_cart:detectorrail_on", {
	description = "Detector rail ON (you hacker you)",
	tiles = {
		"carts_rail_straight_dtc_on.png", "carts_rail_curved_dtc_on.png",
		"carts_rail_t_junction_dtc_on.png", "carts_rail_crossing_dtc_on.png"
	},
	groups = boost_cart:get_rail_groups({
		detector_rail = 1, not_in_creative_inventory = 1
	}),
	drop = "boost_cart:detectorrail",

	mesecons = {receptor = {state = "on", rules = mesecons_rules}},
})

minetest.register_craft({
	output = "boost_cart:detectorrail 6",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "mesecons_pressureplates:pressure_plate_stone_off", "default:steel_ingot"},
		{"default:steel_ingot", "mesecons:wire_00000000_off", "default:steel_ingot"},
	},
})
