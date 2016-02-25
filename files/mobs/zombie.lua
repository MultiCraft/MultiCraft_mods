mobs:register_mob("mobs:zombie", {
		type = "monster",
		visual = "mesh",
		mesh = "zombie.x",
		textures = {
			{"mobs_zombie.png"},
		},
		collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
		animation = {
			speed_normal = 10,		speed_run = 15,
			stand_start = 0,		stand_end = 79,
			walk_start = 168,		walk_end = 188,
			run_start = 168,		run_end = 188
		},
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_zombie.1",
			war_cry = "mobs_zombie.3",
			attack = "mobs_zombie.2",
			damage = "mobs_zombie_hit",
			death = "mobs_zombie_death",
		},
		hp_min = 15,
		hp_max = 25,
		armor = 100,
		knock_back = 1,
		light_damage = 1,
		lava_damage = 10,
		fear_height = 2,
		damage = 2,
		reach = 2,
		attack_type = "dogfight",
		group_attack = true,
		view_range = 15,
		walk_chance = 75,
		walk_velocity = 0.5,
		run_velocity = 0.5,
		jump = false,
		drops = {
			{name = "mobs:rotten_flesh", chance = 1, min = 1, max = 3,}
		},
	})

	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs:zombie",
		{"default:dirt", "default:sandstone", "default:sand", "default:stone", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass", "default:cobble", "default:mossycobble"},
		{"air"},
		0, 7, 0, 4000, 1, -31000, 31000
	)
	mobs:register_egg("mobs:zombie", "Zombie", "zombie_head.png", 0)

-- rotten flesh
	minetest.register_craftitem("mobs:rotten_flesh", {
		description = "Rotten Flesh",
		inventory_image = "mobs_rotten_flesh.png",
		on_use = minetest.item_eat(1),
	})

-- spawner block
		minetest.register_node("mobs:zombie_spawner", {
			description = "Zombie Spawner",
			tiles = {"zombie_head.png"},
			is_ground_content = false,
			groups = {cracky=3, stone=1, mob_spawner=1},
			sounds = default.node_sound_stone_defaults({
				dug = {name="mobs_zombie_death", gain=0.25}
			})
		})
		minetest.register_abm({
			nodenames = {"mobs:zombie_spawner"},
			interval = 60.0,
			chance = 1,
			action = function(pos, node, active_object_count, active_object_count_wider)
				minetest.add_entity(pos, "mobs:zombie")
			end
		})