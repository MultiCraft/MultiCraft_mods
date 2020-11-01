mobs:register_mob("mobs_monster:zombie", {
	type = "monster",
	visual = "mesh",
	mesh = "mobs_zombie.b3d",
	textures = {"mobs_zombie.png"},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	animation = {
		speed_normal = 10,	speed_run = 15,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 188,
		run_start = 168,	run_end = 188
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie.1",
		war_cry = "mobs_zombie.3",
		attack = "mobs_zombie.2",
		damage = "mobs_zombie_hit",
		death = "mobs_zombie_death"
	},
	hp_min = 15,
	hp_max = 25,
	water_damage = 2,
	light_damage = 2,
	damage = 2,
	group_attack = true,
	attack_npcs = true,
	view_range = 15,
	walk_chance = 75,
	walk_velocity = 0.5,
	run_velocity = 0.5,
	jump = false,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(3, 5), pos)
		end
		return {
			{name = "mobs_monster:rotten_flesh"},
			{name = "mobs_monster:rotten_flesh", chance = 2}
		}
	end
})

mobs:spawn({
	name = "mobs_monster:zombie",
	nodes = mobs_monster.spawn_nodes,
	max_light = 6,
	chance = 15000
})

mobs:register_egg("mobs_monster:zombie", mobs_monster.S"Zombie Head", "zombie_head.png")

-- Giant Zombie, spawning disabled
mobs:register_mob("mobs_monster:zombie_giant", {
	type = "monster",
	visual = "mesh",
	mesh = "mobs_zombie.b3d",
	textures = {"mobs_zombie.png"},
	collisionbox = {-0.75, -2.5, -0.75, 0.75, 2, 0.75},
	visual_size = {x = 2.5, y = 2.5},
	animation = {
		speed_normal = 10,	speed_run = 15,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 188,
		run_start = 168,	run_end = 188
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie.1",
		war_cry = "mobs_zombie.3",
		attack = "mobs_zombie.2",
		damage = "mobs_zombie_hit",
		death = "mobs_zombie_death"
	},
	hp_min = 30,
	hp_max = 50,
	water_damage = 2,
	light_damage = 2,
	damage = 5,
	group_attack = false,
	attack_npcs = true,
	view_range = 25,
	walk_chance = 50,
	walk_velocity = 1.5,
	run_velocity = 3,
	jump = true,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(6, 10), pos)
		end
		return {
			{name = "mobs_monster:rotten_flesh"},
			{name = "mobs_monster:rotten_flesh"},
			{name = "mobs_monster:rotten_flesh"},
			{name = "mobs_monster:rotten_flesh", chance = 2},
			{name = "mobs_monster:rotten_flesh", chance = 2},
			{name = "mobs_monster:rotten_flesh", chance = 2},
			{name = "mobs_monster:rotten_flesh", chance = 3},
			{name = "mobs_monster:rotten_flesh", chance = 3},
			{name = "mobs_monster:rotten_flesh", chance = 3}
		}
	end
})

--[[mobs:spawn({
	name = "mobs_monster:zombie_giant",
	nodes = mobs_monster.spawn_nodes,
	max_light = 4,
	chance = 35000
})]]

mobs:register_egg("mobs_monster:zombie_giant", mobs_monster.S"Giant Zombie Head", "zombie_head.png")
minetest.add_group("mobs_monster:zombie_giant", {not_in_creative_inventory = 1})
