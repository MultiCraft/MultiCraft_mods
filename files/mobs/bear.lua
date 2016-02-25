-- bear
	mobs:register_mob("mobs:bear", {
		type = "npc",
		visual = "mesh",
		mesh = "mobs_bear.x",
		textures = {
			{"mobs_bear.png"},
		},
		collisionbox = {-0.5, -0.01, -0.5, 0.5, 1.49, 0.5},
		animation = { 
			speed_normal = 15,	speed_run = 24,
			stand_start = 0,	stand_end = 30,
			walk_start = 35,	walk_end = 65,
			run_start = 105,	run_end = 135,
			punch_start = 70,	punch_end = 100
		},
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_bear",
			attack = "mobs_bear_angry",
		},
		reach = 2,
		hp_min= 10,
		hp_max = 15,
		armor = 100,
		knock_back = 1,
		lava_damage = 10,
		fall_damage = 5,
		fear_height = 2,
		damage = 6,
		reach = 3,
		attack_type = "dogfight",
		attacks_monsters = true,
		view_range = 14,
		stepheight = 1.1,
		jump = false,
		drops = {
			{name = "mobs:meat_raw", chance = 1, min = 3, max = 6},
			{name = "mobs:leather", chance = 1, min = 1, max = 2}	
		},
		follow = {"mobs:honey", "farming:raspberries", "farming:blueberries", "farming_plus:strawberry_item",
			"bushes:strawberry", "bushes:blackberry", "bushes:blueberry", "bushes:raspberry",
			"bushes:gooseberry", "bushes:mixed_berry"},
		replace_rate = 50,
		replace_what = {"mobs:beehive", "farming:blueberry_4", "farming:raspberry_4", "farming_plus:strawberry",
			"bushes:strawberry_bush", "bushes:blackberry_bush", "bushes:blueberry_bush", "bushes:raspberry_bush",
			"bushes:gooseberry_bush", "bushes:mixed_berry_bush"},
		replace_with = "air",
		on_rightclick = function(self, clicker)
			if mobs:feed_tame(self, clicker, 10, true) then
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

	local l_spawn_elevation_min = minetest.setting_get("water_level")
	if l_spawn_elevation_min then
		l_spawn_elevation_min = l_spawn_elevation_min - 10
	else
		l_spawn_elevation_min = -10
	end
	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs:bear",
		{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
		{"air"},
		5, 20, 0, 6000, 1, 1, 31000
	)
	mobs:register_egg("mobs:bear", "Bear", "wool_brown.png", 1)