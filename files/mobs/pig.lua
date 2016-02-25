-- Warthog(Boar) by KrupnoPavel (MIT)
-- Changed to Boar and tweaked by Kaadmy (WTFPL) and MoNTE48 (LGPLv3)
mobs:register_mob("mobs:pig", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	group_attack = true,
	reach = 2,
	damage = 2,
	hp_min = 5,
	hp_max = 15,
	armor = 100,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.1, 0.4},
	visual = "mesh",
	mesh = "mobs_pig.x",
	textures = {
		{"mobs_pig.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_pig",
		attack = "mobs_pig_angry",
		death  = "mobs_pig_angry",
	},
	walk_velocity = 2,
	run_velocity = 3,
	jump = true,
	follow = {"default:apple", "farming:potato"},
	view_range = 10,
	drops = {
		{name = "mobs:pork_raw",
		chance = 1, min = 1, max = 1},
		{name = "mobs:pork_raw",
		chance = 2, min = 1, max = 1},
		{name = "mobs:pork_raw",
		chance = 2, min = 1, max = 1},
	},
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	fear_height = 2,
	animation = {
	 speed_normal = 20,
	 stand_start = 0,
	 stand_end = 60,
	 walk_start = 61,
	 walk_end = 80,
	 punch_start = 90,
	 punch_end = 110,
    },
	on_rightclick = function(self, clicker)
		mobs:feed_tame(self, clicker, 8, true, true)
		mobs:capture_mob(self, clicker, 0, 5, 50, false, nil)
	end,
})

mobs:spawn_specific("mobs:pig",
		{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
		{"air"},
		0, 20, 0, 5000, 1, -31000, 31000
	)

mobs:register_egg("mobs:pig", "Pig", "wool_pink.png", 1)
