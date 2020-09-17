mobs:register_mob("mobs_animal:wolf", {
	type = "animal",
	damage = 2,
	hp_min = 8,
	hp_max = 10,
	collisionbox = {-0.6, -0.01, -0.6, 0.6, 1.1, 0.6},
	visual = "mesh",
	mesh = "mobs_wolf.x",
	textures = {
		{"mobs_wolf.png"}
	},
	animation = {
		speed_normal = 20,	speed_run = 30,
		stand_start = 10,	stand_end = 20,
		walk_start = 75,	walk_end = 100,
		run_start = 100,	run_end = 130,
		punch_start = 135,	punch_end = 155
	},
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_wolf_attack",
		death = "mobs_wolf_attack"
	},
	walk_chance = 75,
	walk_velocity = 2,
	run_velocity = 3,
	view_range = 7,
	follow = {"food_meat_raw", "default:bone"},
	pathfinding = true,
	group_attack = true,
	fear_height = 4,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 2, false, true) then
			if self.food == 0 then
				local mob = minetest.add_entity(self.object:get_pos(), "mobs_animal:dog")
				local ent = mob:get_luaentity()
				ent.owner = clicker:get_player_name()
				ent.following = clicker
				ent.order = "follow"
				self.object:remove()
			end
			return
		end
	--	mobs:capture_mob(self, clicker, 0, 0, 80, true, nil)
	end
})

-- Dog
mobs:register_mob("mobs_animal:dog", {
	type = "npc",
	damage = 4,
	hp_min = 15,
	hp_max = 25,
	collisionbox = {-0.6, -0.01, -0.6, 0.6, 1.1, 0.6},
	visual = "mesh",
	mesh = "mobs_wolf.x",
	textures = {
		{"mobs_dog.png"}
	},
	animation = {
		speed_normal = 20,	speed_run = 30,
		stand_start = 10,	stand_end = 20,
		walk_start = 75,	walk_end = 100,
		run_start = 100,	run_end = 130,
		punch_start = 135,	punch_end = 155
	},
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_wolf_attack",
		death = "mobs_wolf_attack"
	},
	water_damage = 0,
	fear_height = 4,
	walk_chance = 75,
	walk_velocity = 2,
	run_velocity = 4,
	view_range = 15,
	follow = {"food_meat_raw", "default:bone"},
	attacks_monsters = true,
	pathfinding = true,
	group_attack = true,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 6, true, true) then return end
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
	--	mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
	end
})

mobs:spawn({
	name = "mobs_animal:wolf",
	mobs_animal.spawn_nodes,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:wolf", mobs_animal.S"Wolf's Egg", "wool_grey.png", true)
mobs:register_egg("mobs_animal:dog", mobs_animal.S"Dog Egg", "wool_brown.png", true)
