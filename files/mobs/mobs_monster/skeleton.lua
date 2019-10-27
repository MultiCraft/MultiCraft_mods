mobs:register_mob("mobs_monster:skeleton", {
	type = "monster",
	visual = "mesh",
	mesh = "mobs_zombie.b3d",
	textures = {"mobs_skeleton.png"},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	animation = {
		speed_normal = 10,	speed_run = 15,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 188,
		run_start = 168,	run_end = 188
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_skeleton",
		war_cry = "mobs_zombie.3",
		attack = "mobs_zombie.2",
		damage = "mobs_zombie_hit",
		death = "mobs_zombie_death"
	},
	hp_min = 10,
	hp_max = 15,
	light_damage = 1,
	lava_damage = 5,
	damage = 1,
	group_attack = true,
	attack_npcs = true,
	view_range = 15,
	walk_chance = 75,
	walk_velocity = 0.5,
	run_velocity = 0.5,
	jump = false,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(2, 4), pos)
		end
		return {
			{name = "default:bone", chance = 2},
			{name = "default:bone", chance = 2}
		}
	end,

	after_activate = function(self)
		-- replace skeleton using the old directx model
		if self.mesh == "mobs_zombie.x" then
		local pos = self.object:get_pos()
		if pos then
			minetest.add_entity(pos, self.name)
			self.object:remove()
		end
		end
	end
})

mobs:spawn({
	name = "mobs_monster:skeleton",
	nodes = mobs_monster.spawn_nodes,
	max_light = 8,
	chance = 15000
})

mobs:register_egg("mobs_monster:skeleton", "Skeleton Egg", "mobs_monster_egg.png^default_bone.png")
