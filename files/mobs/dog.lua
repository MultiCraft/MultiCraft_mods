
if mobs.mod and mobs.mod == "redo" then

-- wolf
	mobs:register_mob("mobs:wolf", {
		type = "animal",
		visual = "mesh",
		mesh = "mobs_wolf.x",
		textures = {
			{"mobs_wolf.png"},
		},
		collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
		animation = {
			speed_normal = 20,	speed_run = 30,
			stand_start = 10,	stand_end = 20,
			walk_start = 75,	walk_end = 100,
			run_start = 100,	run_end = 130,
			punch_start = 135,	punch_end = 155
		},
		makes_footstep_sound = true,
		sounds = {
			war_cry = "mobs_wolf_attack"
		},
		reach = 2,
		hp_min = 6,
		hp_max = 10,
		armor = 100,
		lava_damage = 5,
		fall_damage = 4,
		fear_height = 2,
		damage = 4,
		attack_type = "dogfight",
		group_attack = true,
		view_range = 7,
		walk_velocity = 2,
		run_velocity = 3,
		stepheight = 1.1,
		follow = "mobs:meat_raw",
		on_rightclick = function(self, clicker)
			if mobs:feed_tame(self, clicker, 2, false) then
				if self.food == 0 then
					local mob = minetest.add_entity(self.object:getpos(), "mobs:dog")
					local ent = mob:get_luaentity()
					ent.owner = clicker:get_player_name()
					ent.following = clicker
					ent.order = "follow"
					self.object:remove()
				end
				return
			end
			mobs:capture_mob(self, clicker, 0, 0, 80, true, nil)
		end
	})

	local l_spawn_elevation_min = minetest.setting_get("water_level")
	if l_spawn_elevation_min then
		l_spawn_elevation_min = l_spawn_elevation_min - 5
	else
		l_spawn_elevation_min = -5
	end
	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs:wolf",
		{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
		{"air"},
		0, 20, 0, 6000, 1, 1, 31000
	)
	mobs:register_egg("mobs:wolf", "Wolf", "wool_grey.png", 1)

-- Dog
	mobs:register_mob("mobs:dog", {
		type = "npc",
		visual = "mesh",
		mesh = "mobs_wolf.x",
		textures = {
			{"mobs_dog.png"}
		},
		collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
		animation = {
			speed_normal = 20,	speed_run = 30,
			stand_start = 10,	stand_end = 20,
			walk_start = 75,	walk_end = 100,
			run_start = 100,	run_end = 130,
			punch_start = 135,	punch_end = 155
		},
		makes_footstep_sound = true,
		sounds = {
			war_cry = "mobs_wolf_attack"
		},
		hp_min = 15,
		hp_max = 25,
		armor = 100,
		lava_damage = 5,
		fall_damage = 5,
		damage = 4,
		reach = 2,
		attack_type = "dogfight",
		attacks_monsters = true,
		group_attack = true,
		view_range = 15,
		walk_velocity = 2,
		run_velocity = 4,
		stepheight = 1.1,
		follow = "mobs:raw_meat",
		on_rightclick = function(self, clicker)
			if mobs:feed_tame(self, clicker, 6, true) then
				return
			end
			if clicker:get_wielded_item():is_empty() and clicker:get_player_name() == self.owner then
				if clicker:get_player_control().sneak then
					self.order = ""
					self.state = "walk"
				else
					if self.order == "follow" then
						self.order = "stand"
						self.state = "stand"
					else
						self.order = "follow"
						self.state = "walk"
					end
				end
				return
			end
			mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
		end
	})

	mobs:register_egg("mobs:dog", "Dog", "wool_brown.png", 1)

end