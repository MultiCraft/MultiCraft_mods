mobs:register_mob("mobs_monster:zombie", {
	type = "monster",
	visual = "mesh",
	mesh = "mobs_zombie.b3d",
	textures = {
		{"mobs_zombie.png"},
	},
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
		death = "mobs_zombie_death",
	},
	hp_min = 15,
	hp_max = 25,
	armor = 100,
	knock_back = 1,
	light_damage = 1,
	lava_damage = 10,
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
		{name = "mobs_monster:rotten_flesh", chance = 1, min = 1, max = 1},
		{name = "mobs_monster:rotten_flesh", chance = 2, min = 1, max = 1},
		{name = "mobs_monster:rotten_flesh", chance = 2, min = 1, max = 1}
	},
	after_activate = function(self, staticdata, def, dtime)
	-- replace zombies using the old directx model
		if self.mesh == "mobs_zombie.x" then
			local pos = self.object:get_pos()
			if pos then
				minetest.add_entity(pos, self.name)
				self.object:remove()
			end
		end
	end,	})

mobs:spawn({
	name = "mobs_monster:zombie",
	nodes = {"default:dirt", "default:sandstone", "default:sand", "default:redsand", "default:stone", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:cobble", "default:mossycobble"},
	min_light = 0,
	max_light = 10,
	chance = 7000,
	min_height = -50,
	max_height = 31000,
})	

mobs:register_egg("mobs_monster:zombie", "Zombie Head", "zombie_head.png", 0)

-- compatibility
mobs:alias_mob("mobs:zombie", "mobs_monster:zombie")
mobs:alias_mob("mobs:rotten_flesh", "mobs_monster:rotten_flesh")

-- rotten flesh
minetest.register_craftitem("mobs_monster:rotten_flesh", {
		description = "Rotten Flesh",
		inventory_image = "mobs_rotten_flesh.png",
		on_use = minetest.item_eat(1),
})
