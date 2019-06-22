mobs:register_mob("mobs_animal:bear", {
	type = "animal",
	visual = "mesh",
	mesh = "mobs_bear.b3d",
	collisionbox = {-0.5, -0.01, -0.5, 0.5, 1.49, 0.5},
	animation = {
		speed_normal = 15,	speed_run = 30,
		stand_start = 0,	stand_end = 30,
		walk_start = 35,	walk_end = 65,
		run_start = 105,	run_end = 135,
		punch_start = 70,	punch_end = 100,
	},
	textures = {"mobs_bear.png"},
	sounds = {
		random = "mobs_bear",
		attack = "mobs_bear_angry",
	},
	runaway = false,
	jump = false,
	jump_height = 4,
	fly = false,
	walk_chance = 75,
	walk_velocity = 3,
	run_velocity = 3,
	view_range = 10,
	follow = {
		"farming:blueberries", "farming:raspberries"
	},
	passive = false,
	attack_type = "dogfight",
	damage = 4,
	reach = 3,
	attacks_monsters = true,
	pathfinding = true,
	group_attack = true,
	hp_min = 10,
	hp_max = 15,
	armor = 100,
	knock_back = 2,
	water_damage = 0,
	lava_damage = 5,
	fall_damage = 3,
	fear_height = 4,
	drops = {
		{name = "mobs:meat_raw"},
		{name = "mobs:meat_raw"},
		{name = "mobs:meat_raw", chance = 2},
		{name = "mobs:meat_raw", chance = 2},
		{name = "mobs:leather"},
		{name = "mobs:leather", chance = 2}
	},
	replace_what = {
		"farming:blueberry_4", "farming:raspberry_4"
	},
	replace_with = "air",
	replace_rate = 20,
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 10, true, true) then
			return
		end
		if clicker:get_wielded_item():is_empty() and clicker:get_player_name() == self.owner then
			if clicker:get_player_control().sneak then
			self.order = ""
			self.state = "walk"
			self.walk_velocity = 1
			else
			if self.order == "follow" then
				self.order = "stand"
				self.state = "stand"
				self.walk_velocity = 1
			else
				self.order = "follow"
				self.state = "walk"
				self.walk_velocity = 3
			end
			end
			return
		end
		--mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
	end,
	after_activate = function(self, staticdata, def, dtime)
		-- replace bear using the old directx model
		if self.mesh == "mobs_bear.x" then
		local pos = self.object:get_pos()
		if pos then
			minetest.add_entity(pos, self.name)
			self.object:remove()
		end
		end
	end,
})

mobs:spawn({
	name = "mobs_animal:bear",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"},
	min_light = 0,
	interval = 30,
	chance = 15000,
	min_height = 0,
	max_height = 31000,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:bear", "Bear egg", "mobs_bear_egg.png", 1)
