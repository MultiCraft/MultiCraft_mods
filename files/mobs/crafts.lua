
-- nametag
minetest.register_craftitem("mobs:nametag", {
	description = "Nametag",
	inventory_image = "mobs_nametag.png",
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
})

-- raw meat
minetest.register_craftitem("mobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(3),
})

-- cooked meat
minetest.register_craftitem("mobs:meat", {
	description = "Cooked Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
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
})

-- cooked pork
minetest.register_craftitem("mobs:pork", {
	description = "Cooked Pork",
	inventory_image = "mobs_pork_cooked.png",
	on_use = minetest.item_eat(8),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:pork",
	recipe = "mobs:pork_raw",
	cooktime = 5,
})

-- golden lasso
minetest.register_tool("mobs:magic_lasso", {
	description = "Magic Lasso (right-click animal to put in inventory)",
	inventory_image = "mobs_magic_lasso.png",
})

minetest.register_craft({
	output = "mobs:magic_lasso",
	recipe = {
		{"farming:string", "default:gold_lump", "farming:string"},
		{"default:gold_lump", "default:diamondblock", "default:gold_lump"},
		{"farming:string", "default:gold_lump", "farming:string"},
	}
})

-- shears (right click to shear animal)
minetest.register_tool("mobs:shears", {
	description = "Steel Shears (right-click to shear)",
	inventory_image = "mobs_shears.png",
})

minetest.register_craft({
	output = 'mobs:shears',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'', 'group:stick', 'default:steel_ingot'},
	}
})