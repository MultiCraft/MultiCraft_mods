local S = minetest.get_translator("nextgen_bows")

nextgen_bows.register_bow("bow_wood", {
	description = S("Bow"),
	uses = 385,
	-- `crit_chance` 10% chance, 5 is 20% chance
	-- (1 / crit_chance) * 100 = % chance
	crit_chance = 10,
	recipe = {
		{"", "group:wood", "farming:string"},
		{"group:wood", "", "farming:string"},
		{"", "group:wood", "farming:string"},
	}
})

nextgen_bows.register_arrow("arrow", {
	description = S("Arrow"),
	inventory_image = "nextgen_bows_arrow.png",
	craft = {
		{"default:flint"},
		{"default:stick"},
		{"default:paper"}
	},
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level = 0,
		damage_groups = {fleshy=2}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "nextgen_bows:bow_wood",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "nextgen_bows:arrow",
	burntime = 1,
})

minetest.register_craftitem("nextgen_bows:arrow_node", {
	inventory_image = "nextgen_bows_arrow_entity.png",
	groups = {not_in_creative_inventory = 1}
})

minetest.register_alias("throwing:bow", "nextgen_bows:bow_wood")
minetest.register_alias("throwing:bow_arrow", "nextgen_bows:bow_wood_charged")
minetest.register_alias("throwing:arrow", "nextgen_bows:arrow")
minetest.register_alias("throwing:arrow_item", "nextgen_bows:arrow_node")
