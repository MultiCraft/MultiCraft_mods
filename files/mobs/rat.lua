
-- Rat by PilzAdam

mobs:register_mob("mobs:rat", {
	type = "animal",
	passive = true,
	reach = 1,
	hp_min = 1,
	hp_max = 4,
	armor = 100,
	collisionbox = {-0.2, -1, -0.2, 0.2, -0.8, 0.2},
	visual = "mesh",
	mesh = "mobs_rat.b3d",
	textures = {
		{"mobs_rat.png"},
		{"mobs_rat2.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_rat",
	},
	drops = {
	{name = "mobs:rat",
	chance = 1, min = 1, max = 1},
    },
	walk_velocity = 1,
	jump = true,
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
})

mobs:spawn_specific("mobs:rat",
		{"default:dirt", "default:sandstone", "default:sand", "default:stone", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass"},
		{"air"},
		0, 20, 0, 2000, 1, -31000, 31000
	)

mobs:register_egg("mobs:rat", "Rat", "mobs_rat_inventory.png", 0)
	
-- cooked rat, yummy!
minetest.register_craftitem("mobs:rat_cooked", {
	description = "Cooked Rat",
	inventory_image = "mobs_cooked_rat.png",
	on_use = minetest.item_eat(3),
})

minetest.register_craftitem("mobs:rat_meat", {
	description = "Meat Rat",
	inventory_image = "mobs_rat_inventory.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:rat_cooked",
	recipe = "mobs:rat",
	cooktime = 5,
})