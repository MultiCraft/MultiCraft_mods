mobs:register_mob("mobs_animal:wolf", {
	type = "animal",
	visual = "mesh",
	mesh = "mobs_wolf.x",
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	animation = {
		speed_normal = 20,	speed_run = 30,
		stand_start = 10,	stand_end = 20,
		walk_start = 75,	walk_end = 100,
		run_start = 100,	run_end = 130,
		punch_start = 135,	punch_end = 155,
	},
	textures = {
		{"mobs_wolf.png"},
	},
	jump = false,
	walk_chance = 75,
	walk_velocity = 2,
	run_velocity = 3,
	view_range = 7,
	follow = "mobs:meat_raw",
	damage = 2,
	pathfinding = true,
	group_attack = true,
	hp_min = 8,
	hp_max = 10,
	fall_damage = 3,
	fear_height = 4,
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_wolf_attack",
		death = "mobs_wolf_attack"
	},
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 2, false, true) then
			if self.food == 0 then
			local mob = minetest.add_entity(self.object:getpos(), "mobs_animal:dog")
			local ent = mob:get_luaentity()
			ent.owner = clicker:get_player_name()
			ent.following = clicker
			ent.order = "follow"
			self.object:remove()
			end
			return
		end
		--mobs:capture_mob(self, clicker, 0, 0, 80, true, nil)
	end
})

mobs:spawn({
	name = "mobs_animal:wolf",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"},
	min_light = 0,
	chance = 20000,
	min_height = 0,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:wolf", "Wolf's egg", "wool_grey.png", 1)

-- Dog
mobs:register_mob("mobs_animal:dog", {
	type = "npc",
	visual = "mesh",
	mesh = "mobs_wolf.x",
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	animation = {
		speed_normal = 20,	speed_run = 30,
		stand_start = 10,	stand_end = 20,
		walk_start = 75,	walk_end = 100,
		run_start = 100,	run_end = 130,
		punch_start = 135,	punch_end = 155,
	},
	textures = {
		{"mobs_dog.png"}
	},
	fear_height = 4,
	jump = false,
	walk_chance = 75,
	walk_velocity = 2,
	run_velocity = 4,
	view_range = 15,
	follow = "mobs:meat_raw",
	damage = 4,
	attacks_monsters = true,
	pathfinding = true,
	group_attack = true,
	hp_min = 15,
	hp_max = 25,
	fall_damage = 5,
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_wolf_attack",
		death = "mobs_wolf_attack"
	},
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 6, true, true) then
			return
		end
		if clicker:get_wielded_item():is_empty() and clicker:get_player_name() == self.owner then
			if clicker:get_player_control().sneak then
			self.order = ""
			self.state = "walk"
			self.walk_velocity = 2
			self.stepheight = 0.6
			else
			if self.order == "follow" then
				self.order = "stand"
				self.state = "stand"
				self.walk_velocity = 2
				self.stepheight = 0.6
			else
				self.order = "follow"
				self.state = "walk"
				self.walk_velocity = 3
				self.stepheight = 1.1
			end
		end
			return
		end
		--mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
		end
})

mobs:register_egg("mobs_animal:dog", "Dog Egg", "wool_brown.png", 1)
