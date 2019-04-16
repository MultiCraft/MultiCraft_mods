
-- name tag
minetest.register_craftitem("mobs:nametag", {
	description = "Name Tag",
	inventory_image = "mobs_nametag.png",
	groups = {flammable = 2},
})

core.register_craft({
	type = "shapeless",
	output = "mobs:nametag",
	recipe = {"default:paper", "dye:black", "farming:string"},
})

-- leather
minetest.register_craftitem("mobs:leather", {
	description = "Leather",
	inventory_image = "mobs_leather.png",
	groups = {flammable = 2},
})

-- raw meat
minetest.register_craftitem("mobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2},
})

-- cooked meat
minetest.register_craftitem("mobs:meat", {
	description = "Cooked Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 5,
})

-- raw pork
minetest.register_craftitem("mobs:pork_raw", {
	description = "Raw Pork",
	inventory_image = "mobs_pork_raw.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2},
})

-- cooked pork
minetest.register_craftitem("mobs:pork", {
	description = "Cooked Pork",
	inventory_image = "mobs_pork_cooked.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:pork",
	recipe = "mobs:pork_raw",
	cooktime = 5,
})

-- lasso
minetest.register_tool("mobs:lasso", {
	description = "Lasso (right-click animal to put in inventory)",
	inventory_image = "mobs_magic_lasso.png",
	groups = {flammable = 2},
})

	minetest.register_craft({
		output = "mobs:lasso",
		recipe = {
			{"farming:string", "", "farming:string"},
			{"", "default:diamond", ""},
			{"farming:string", "", "farming:string"},
		}
	})

minetest.register_alias("mobs:magic_lasso", "mobs:lasso")
-- shears (right click to shear animal)
minetest.register_tool("mobs:shears", {
	description = "Steel Shears (right-click to shear)",
	inventory_image = "mobs_shears.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	output = 'mobs:shears',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'', 'group:stick', 'default:steel_ingot'},
	}
})

-- protection rune
minetest.register_craftitem("mobs:protector", {
	description = "Mob Protection Rune",
	inventory_image = "mobs_protector.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	output = "mobs:protector",
	recipe = {
		{"default:stone", "default:stone", "default:stone"},
		{"default:stone", "default:goldblock", "default:stone"},
		{"default:stone", "default:stone", "default:stone"},
	}
})

-- items that can be used as fuel
minetest.register_craft({
	type = "fuel",
	recipe = "mobs:nametag",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:lasso",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:leather",
	burntime = 4,
})
