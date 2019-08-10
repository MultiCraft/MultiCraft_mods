mobs:register_mob("mobs_animal:parrot", {
	type = "animal",
	passive = true,
	hp_min = 8,
	hp_max = 10,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 0.75, 0.35},
	visual = "mesh",
	mesh = "mobs_parrot.b3d",
	textures = {
		{"mobs_parrot_green.png"},
		{"mobs_parrot_red.png"},
		{"mobs_parrot_yellow.png"}
	},
	makes_footstep_sound = true,
	--[[sounds = {
		random = "mobs_chicken",
	},]]
	run_velocity = 3,
	runaway = true,
	--[[drops = {
		{name = "mobs:chicken_raw"}
	},]]
	fall_damage = 0,
	fall_speed = -8,
	fear_height = 5,
	animation = {
		stand_start = 0,	stand_end = 79,
		walk_start = 80,	walk_end = 99,
		run_start = 120,	run_end = 131,
		fly_start = 120,	fly_end = 131
	},
--	fly = true,
	follow = {"farming:seed_wheat"},

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
	--	if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	end
})

mobs:spawn({
	name = "mobs_animal:parrot",
	nodes = {"default:leaves", "default:jungleleaves", "default:acacia_leaves", "default:birch_leaves", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:grass", "default:junglegrass"},
	min_light = 10,
	chance = 15000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:parrot", "Parror Egg", "mobs_parrot_egg.png", 0)
