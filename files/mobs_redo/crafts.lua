-- name tag
minetest.register_craftitem("mobs:nametag", {
	description = "Name Tag",
	inventory_image = "mobs_nametag.png",
	groups = {flammable = 2}
})

core.register_craft({
	type = "shapeless",
	output = "mobs:nametag",
	recipe = {"default:paper", "dye:black", "farming:string"}
})

-- leather
minetest.register_craftitem("mobs:leather", {
	description = "Leather",
	inventory_image = "mobs_leather.png",
	groups = {flammable = 2}
})

-- raw meat
minetest.register_craftitem("mobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(-3),
	groups = {food_meat_raw = 1, flammable = 2, food = 1}
})

-- cooked meat
minetest.register_craftitem("mobs:meat", {
	description = "Cooked Meat",
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
	description = "Raw Pork",
	inventory_image = "mobs_pork_raw.png",
	on_use = minetest.item_eat(-3),
	groups = {food_meat_raw = 1, flammable = 2, food = 1}
})

-- cooked pork
minetest.register_craftitem("mobs:pork", {
	description = "Cooked Pork",
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

-- raw rabbit
minetest.register_craftitem("mobs:rabbit_raw", {
	description = "Raw Rabbit",
	inventory_image = "mobs_rabbit_raw.png",
	on_use = minetest.item_eat(-3),
	groups = {food_meat_raw = 1, food_rabbit_raw = 1, flammable = 2, food = 1}
})

-- cooked rabbit
minetest.register_craftitem("mobs:rabbit_cooked", {
	description = "Cooked Rabbit",
	inventory_image = "mobs_rabbit_cooked.png",
	on_use = minetest.item_eat(5),
	groups = {food_meat = 1, food_rabbit = 1, flammable = 2, food = 1}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:rabbit_cooked",
	recipe = "mobs:rabbit_raw",
	cooktime = 5
})

-- rabbit hide
minetest.register_craftitem("mobs:rabbit_hide", {
	description = "Rabbit Hide",
	inventory_image = "mobs_rabbit_hide.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:leather",
	type = "shapeless",
	recipe = {
		"mobs:rabbit_hide", "mobs:rabbit_hide",
		"mobs:rabbit_hide", "mobs:rabbit_hide"
	}
})

-- chicken egg
local function mobs_shoot_egg(itemstack, thrower, pointed_thing)
	local playerpos = thrower:get_pos()
	if not minetest.is_valid_pos(playerpos) then
		return
	end
	local obj = minetest.item_throw("mobs:chicken_egg", thrower, 19, -3, egg_impact)
	if obj then
		obj:set_properties({
			visual = "sprite",
			visual_size = {x = 0.5, y = 0.5},
			textures = {"mobs_chicken_egg.png"},
		})
		minetest.sound_play("throwing_sound", {
			pos = playerpos,
			gain = 0.7,
			max_hear_distance = 10,
		})
		if not mobs.is_creative(thrower) or
		not minetest.is_singleplayer() then
			itemstack:take_item()
		end
	end
	return itemstack
end

minetest.register_craftitem(":mobs:chicken_egg", {
	description = "Chicken Egg",
	inventory_image = "mobs_chicken_egg.png",
	visual_scale = 0.7,
	on_use = mobs_shoot_egg,
	groups = {snappy = 2, dig_immediate = 3}
})

minetest.register_alias("mobs:egg", "air")

-- fried egg
minetest.register_craftitem("mobs:chicken_egg_fried", {
	description = "Fried Egg",
	inventory_image = "mobs_chicken_egg_fried.png",
	on_use = minetest.item_eat(2),
	groups = {flammable = 2, food = 1}
})

minetest.register_craft({
	type = "cooking",
	recipe = "mobs:chicken_egg",
	output = "mobs:chicken_egg_fried"
})

-- raw chicken
minetest.register_craftitem("mobs:chicken_raw", {
	description = "Raw Chicken",
	inventory_image = "mobs_chicken_raw.png",
	on_use = minetest.item_eat(-2),
	groups = {food_meat_raw = 1, food_chicken_raw = 1, flammable = 2, food = 1}
})

-- cooked chicken
minetest.register_craftitem("mobs:chicken_cooked", {
	description = "Cooked Chicken",
	inventory_image = "mobs_chicken_cooked.png",
	on_use = minetest.item_eat(6),
	groups = {food_meat = 1, food_chicken = 1, flammable = 2, food = 1}
})

minetest.register_craft({
	type = "cooking",
	recipe = "mobs:chicken_raw",
	output = "mobs:chicken_cooked"
})

-- cheese wedge
minetest.register_craftitem("mobs:cheese", {
	description = "Cheese",
	inventory_image = "mobs_cheese.png",
	on_use = minetest.item_eat(4),
	groups = {food_cheese = 1, flammable = 2, food = 1}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:cheese",
	recipe = "mobs:bucket_milk",
	cooktime = 5,
	replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- cheese block
minetest.register_node("mobs:cheeseblock", {
	description = "Cheese Block",
	tiles = {"mobs_cheeseblock.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_craft({
	output = "mobs:cheeseblock",
	recipe = {
		{"mobs:cheese", "mobs:cheese", "mobs:cheese"},
		{"mobs:cheese", "mobs:cheese", "mobs:cheese"},
		{"mobs:cheese", "mobs:cheese", "mobs:cheese"}
	}
})

minetest.register_craft({
	output = "mobs:cheese 9",
	recipe = {
		{"mobs:cheeseblock"}
	}
})

-- rotten flesh
minetest.register_craftitem("mobs:rotten_flesh", {
	description = "Rotten Flesh",
	inventory_image = "mobs_rotten_flesh.png",
	on_use = minetest.item_eat(-4),
	groups = {flammable = 2, food = 1}
})

minetest.register_alias("mobs_monster:rotten_flesh", "mobs:rotten_flesh")
minetest.register_alias("mobs:magic_lasso", "farming:string")
minetest.register_alias("mobs:lasso", "farming:string")

-- shears (right click to shear animal)
minetest.register_tool("mobs:shears", {
	description = "Steel Shears (right-click to shear)",
	inventory_image = "mobs_shears.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:shears",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"", "group:stick", "default:steel_ingot"}
	}
})

-- cobweb
minetest.register_node("mobs:cobweb", {
	description = "Cobweb",
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

-- protection item
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
		{"default:stone", "default:stone", "default:stone"}
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


minetest.register_craft({
	type = "fuel",
	recipe = "mobs:rabbit_hide",
	burntime = 2
})
