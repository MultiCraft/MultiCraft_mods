mobs:register_mob("mobs_animal:pig", {
	type = "animal",
	group_attack = true,
	damage = 2,
	hp_min = 5,
	hp_max = 15,
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
	},
	walk_velocity = 2,
	run_velocity = 3,
	follow = {"default:apple", "farming:potato"},
	drops = function(pos)
		if rawget(_G, "experience") then
			--experience.add_orb(math.random(1,3), pos) -- random amount between 1 and 3
			experience.add_orb(3, pos)
		end

		return {
			{name = "mobs:pork_raw"},
			{name = "mobs:pork_raw", chance = 2},
			{name = "mobs:pork_raw", chance = 2}
		}
	end,
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
	on_rightclick = function (self, clicker)
	mobs:feed_tame(self, clicker, 8, true, true)
	--mobs:capture_mob(self, clicker, 0, 5, 50, false, nil)
	end,
})

mobs:spawn({
	name = "mobs_animal:pig",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"},
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:pig", "Pig egg", "mobs_pig_egg.png", 1)
