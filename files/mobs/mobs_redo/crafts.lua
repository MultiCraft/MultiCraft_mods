local S = mobs.S

-- name tag
minetest.register_craftitem("mobs:nametag", {
	description = S"Name Tag",
	inventory_image = "mobs_nametag.png",
	groups = {flammable = 2, nohit = 1}
})

minetest.register_craft({
	type = "shapeless",
	output = "mobs:nametag",
	recipe = {"default:paper", "dye:black", "farming:string"}
})

-- leather
minetest.register_craftitem("mobs:leather", {
	description = S"Leather",
	inventory_image = "mobs_leather.png",
	groups = {flammable = 2}
})

-- raw meat
minetest.register_craftitem("mobs:meat_raw", {
	description = S"Raw Meat",
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(3, nil, -4),
	groups = {food_meat_raw = 1, flammable = 2, food = 1}
})

-- cooked meat
minetest.register_craftitem("mobs:meat", {
	description = S"Cooked Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2, food = 1}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 5
})

-- raw pork
minetest.register_craftitem("mobs:pork_raw", {
	description = S"Raw Pork",
	inventory_image = "mobs_pork_raw.png",
	on_use = minetest.item_eat(3, nil, -4),
	groups = {food_meat_raw = 1, flammable = 2, food = 1}
})

-- cooked pork
minetest.register_craftitem("mobs:pork", {
	description = S"Cooked Pork",
	inventory_image = "mobs_pork_cooked.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2, food = 1}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:pork",
	recipe = "mobs:pork_raw",
	cooktime = 5
})

-- rotten flesh
minetest.register_craftitem("mobs:rotten_flesh", {
	description = S"Rotten Flesh",
	inventory_image = "mobs_rotten_flesh.png",
	on_use = minetest.item_eat(4, nil, -4),
	groups = {flammable = 2, food = 1}
})

-- fish
minetest.register_craftitem(":default:fish_raw", {
	description = S"Raw Fish",
	inventory_image = "mobs_fish.png",
	groups = {food_fish_raw = 1, food = 1},
	on_use = minetest.item_eat(2, nil, -3)
})

minetest.register_craftitem(":default:fish", {
	description = S"Cooked Fish",
	inventory_image = "mobs_fish_cooked.png",
	groups = {food = 1},
	on_use = minetest.item_eat(6)
})

minetest.register_craft({
	type = "cooking",
	output = "default:fish",
	recipe = "default:fish_raw"
})


minetest.register_alias("mobs_monster:rotten_flesh", "mobs:rotten_flesh")
minetest.register_alias("mobs:magic_lasso", "default:diamond")
minetest.register_alias("mobs:lasso", "default:diamond")
minetest.register_alias("mobs:protector", "default:goldblock")

-- shears
minetest.register_tool("mobs:shears", {
	description = S"Steel Shears",
	inventory_image = "mobs_shears.png",
	groups = {flammable = 2, nohit = 1}
})

minetest.register_craft({
	output = "mobs:shears",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"", "default:stick", "default:steel_ingot"}
	}
})

-- cobweb
minetest.register_node("mobs:cobweb", {
	description = S"Cobweb",
	drawtype = "plantlike",
	visual_scale = 1.2,
	tiles = {"mobs_cobweb.png"},
	inventory_image = "mobs_cobweb.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 1, disable_jump = 1, speed = -30},
	sounds = default.node_sound_leaves_defaults()
})

minetest.register_craft({
	output = "mobs:cobweb",
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"}
	}
})

-- items that can be used as fuel
minetest.register_craft({
	type = "fuel",
	recipe = "mobs:nametag",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:leather",
	burntime = 4
})
