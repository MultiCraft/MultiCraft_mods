local mesecons_rules = mesecon.rules.flat

function carts:turnoff_detector_rail(pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "detector_rail") == 1 then
		if node.name == "carts:detectorrail_on" then --has not been dug
			minetest.swap_node(pos, {name = "carts:detectorrail", param2 = node.param2})
		end
		mesecon.receptor_off(pos, mesecons_rules)
	end
end

function carts:signal_detector_rail(pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "detector_rail") ~= 1 then
		return
	end

	if node.name == "carts:detectorrail" then
		minetest.swap_node(pos, {name = "carts:detectorrail_on", param2 = node.param2})
	end
	mesecon.receptor_on(pos, mesecons_rules)
	minetest.after(0.5, carts.turnoff_detector_rail, carts, pos)
end

carts:register_rail("carts:detectorrail", {
	description = "Detector Rail",
	tiles = {
		"carts_rail_straight_dtc.png", "carts_rail_curved_dtc.png",
		"carts_rail_t_junction_dtc.png", "carts_rail_crossing_dtc.png"
	},
	groups = carts:get_rail_groups({detector_rail = 1}),

	mesecons = {receptor = {state = "off", rules = mesecons_rules}}
})

carts:register_rail("carts:detectorrail_on", {
	tiles = {
		"carts_rail_straight_dtc_on.png", "carts_rail_curved_dtc_on.png",
		"carts_rail_t_junction_dtc_on.png", "carts_rail_crossing_dtc_on.png"
	},
	groups = carts:get_rail_groups({
		detector_rail = 1, not_in_creative_inventory = 1
	}),
	drop = "carts:detectorrail",

	mesecons = {receptor = {state = "on", rules = mesecons_rules}}
})

minetest.register_craft({
	output = "carts:detectorrail 6",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "default:stick", "default:steel_ingot"},
		{"default:steel_ingot", "mesecons_pressureplates:pressure_plate_stone_off", "default:steel_ingot"}
	}
})
