
-- Rat by PilzAdam

mobs:register_mob("mobs:rat", {
	type = "animal",
	passive = true,
	hp_min = 1,
	hp_max = 4,
	armor = 100,
	collisionbox = {-0.25, -1, -0.25, 0.25, -0.8, 0.25},
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
	{name = "mobs:rat_meat",
	chance = 1, min = 1, max = 1},
    },
	walk_velocity = 1,
	run_velocity = 2,
	runaway = true,
	jump = true,
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 2,
})

mobs:spawn_specific("mobs:rat",
		{"default:dirt", "default:sandstone", "default:sand", "default:stone", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass"},
		{"air"},
		0, 20, 0, 4000, 1, -31000, 31000
	)

mobs:register_egg("mobs:rat", "Rat", "mobs_rat_inventory.png", 0)
	
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