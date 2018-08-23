	mobs:register_mob("mobs_animal:bear", {
		type = "npc",
		visual = "mesh",
		mesh = "mobs_bear.b3d",
		rotate = 0,
		collisionbox = {-0.5, -0.01, -0.5, 0.5, 1.49, 0.5},
		animation = {
			speed_normal = 15,	speed_run = 30,
			stand_start = 0,	stand_end = 30,
			walk_start = 35,	walk_end = 65,
			run_start = 105,	run_end = 135,
			punch_start = 70,	punch_end = 100,
		},
		textures = {
			{"mobs_bear.png"},
		},
		sounds = {
			random = "mobs_bear",
			attack = "mobs_bear_angry",
		},
		fear_height = 4,
		runaway = false,
		jump = false,
		jump_height = 4,
		fly = false,
		walk_chance = 75,
		run_velocity = 3,
		view_range = 14,
		follow = {
			"farming:blueberries", "farming:raspberries"
		},
		attack_type = "dogfight",
		damage = 4,
		reach = 3,
		attacks_monsters = true,
		pathfinding = true,
		hp_min = 10,
		hp_max = 15,
		armor = 100,
		knock_back = 1,
		lava_damage = 10,
		fall_damage = 5,
		makes_footstep_sound = true,
		drops = {
			{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
			{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
			{name = "mobs:meat_raw", chance = 2, min = 1, max = 1},
			{name = "mobs:meat_raw", chance = 2, min = 1, max = 1},
			{name = "mobs:leather", chance = 1, min = 1, max = 1},
			{name = "mobs:leather", chance = 2, min = 1, max = 1}
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
				mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
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
	nodes = {"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass"},
	min_light = 0,
	chance = 15000,
	min_height = 0,
	max_height = 31000,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:bear", "Bear", "wool_brown.png", 1)

-- compatibility
mobs:alias_mob("mobs:bear", "mobs_animal:bear")