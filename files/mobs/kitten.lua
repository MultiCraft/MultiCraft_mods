
-- Kitten by Jordach / BFD

mobs:register_mob("mobs:kitten", {
	type = "animal",
	passive = true,
	reach = 2,
	hp_min = 5,
	hp_max = 10,
	armor = 100,
	collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.1, 0.3},
	visual = "mesh",
	visual_size = {x = 0.5, y = 0.5},
	mesh = "mobs_kitten.b3d",
	textures = {
		{"mobs_kitten_striped.png"},
		{"mobs_kitten_splotchy.png"},
		{"mobs_kitten_ginger.png"},
		{"mobs_kitten_sandy.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_kitten",
	},
	walk_velocity = 0.6,
	run_velocity = 2,
	runaway = true,
	jump = false,
	drops = {
		{name = "farming:string",
		chance = 1, min = 1, max = 1},
	},
	water_damage = 1,
	lava_damage = 5,
	fear_height = 3,
	animation = {
		speed_normal = 42,
		stand_start = 97,
		stand_end = 192,
		walk_start = 0,
		walk_end = 96,
	},
	follow = {"mobs:rat"},
	view_range = 8,
	on_rightclick = function(self, clicker)
	
		if mobs:feed_tame(self, clicker, 4, true, true) then
			return
		end
		
		mobs:capture_mob(self, clicker, 50, 50, 90, false, nil)
	end
})

	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs:kitten",
		{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
		{"air"},
		5, 20, 0, 5000, 1, 1, 31000
	)
mobs:register_egg("mobs:kitten", "Kitten", "mobs_kitten_inv.png", 0)