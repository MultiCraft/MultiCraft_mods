mobs:register_mob("mobs_animal:kitten", {
	stepheight = 0.6,
	type = "animal",
	passive = true,
	hp_min = 8,
	hp_max = 10,
	collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.1, 0.3},
	visual = "mesh",
	visual_size = {x = 0.5, y = 0.5},
	mesh = "mobs_kitten.b3d",
	textures = {
		{"mobs_kitten_striped.png"},
		{"mobs_kitten_splotchy.png"},
		{"mobs_kitten_ginger.png"},
		{"mobs_kitten_sandy.png"}
	},
	sounds = {
		random = "mobs_kitten"
	},
	walk_velocity = 0.6,
	walk_chance = 15,
	run_velocity = 2,
	runaway = true,
	jump_height = 5,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(2), pos)
		end
		return {
			{name = "farming:string"}
		}
	end,
	fall_damage = 2,
	fear_height = 3,
	animation = {
		speed_normal = 42,
		stand_start = 97,	stand_end = 192,
		walk_start = 0,		walk_end = 96,
		stoodup_start = 0,	stoodup_end = 0
	},
	follow = {"default:fish_raw"},
	view_range = 8,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 4, true, true) then return end
	--	if mobs:capture_mob(self, clicker, 50, 50, 90, false, nil) then return end
	end
})

mobs:spawn({
	name = "mobs_animal:kitten",
	nodes = mobs_animal.spawn_nodes,
	min_light = 10,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:kitten", "Cat's Egg", "mobs_kitten_egg.png", true)
