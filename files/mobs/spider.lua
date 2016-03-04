
-- Spider by AspireMint (fishyWET (CC-BY-SA 3.0 license for texture)

mobs:register_mob("mobs:spider", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 2,
	hp_min = 15,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.9, -0.01, -0.7, 0.7, 0.6, 0.7},
	visual = "mesh",
	mesh = "mobs_spider.x",
	textures = {
		{"mobs_spider.png"},
	},
	visual_size = {x = 7, y = 7},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	view_range = 15,
	floats = 0,
	drops = {
		{name = "farming:string",
		chance = 1, min = 1, max = 2},
	},
	water_damage = 5,
	lava_damage = 5,
	light_damage = 1,
	fear_height = 2,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 1,
		stand_end = 1,
		walk_start = 20,
		walk_end = 40,
		run_start = 20,
		run_end = 40,
		punch_start = 50,
		punch_end = 90,
	},
})
	
	mobs:spawn_specific("mobs:spider",
		{"default:dirt", "default:sandstone", "default:sand", "default:stone", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass", "default:cobble", "default:mossycobble"},
		{"air"},
		0, 7, 0, 5000, 1, -31000, 31000
	)

mobs:register_egg("mobs:spider", "Spider", "mobs_cobweb.png", 1)

-- cobweb
minetest.register_node("mobs:cobweb", {
	description = "Cobweb",
	drawtype = "plantlike",
	visual_scale = 1.1,
	stack_max = 64,
	tiles = {"mobs_cobweb.png"},
	inventory_image = "mobs_cobweb.png",
	paramtype = "light",
	sunlight_propagates = true,
	liquid_viscosity = 11,
	liquidtype = "source",
	liquid_alternative_flowing = "mobs:cobweb",
	liquid_alternative_source = "mobs:cobweb",
	liquid_renewable = false,
	liquid_range = 0,
	walkable = false,
	groups = {snappy = 1, liquid = 3},
	--drop = "farming:cotton",
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "mobs:cobweb",
	recipe = {
		{"farming:string", "", "farming:string"},
		{"", "farming:string", ""},
		{"farming:string", "", "farming:string"},
	}
})