
-- Spider by AspireMint (fishyWET (CC-BY-SA 3.0 license for texture)

mobs:register_mob("mobs_monster:spider", {
	docile_by_day = true,
	group_attack = true,
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 2,
	hp_min = 15,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 0.6, 0.7},
	visual = "mesh",
	mesh = "mobs_spider.b3d",
	textures = {
		{"mobs_spider.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	view_range = 15,
	floats = 0,
--	drops = {
--		{name = "farming:string",
--		chance = 1, min = 1, max = 2},	},
	water_damage = 5,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 20,
		stand_start = 0,
		stand_end = 0,
		walk_start = 1,
		walk_end = 21,
		run_start = 1,
		run_end = 21,
		punch_start = 25,
		punch_end = 45,
	},
		after_activate = function(self, staticdata, def, dtime)
			-- replace spider using the old directx model
			if self.mesh == "mobs_spider.x" then
				local pos = self.object:get_pos()
				if pos then
					minetest.add_entity(pos, self.name)
					self.object:remove()
				end
			end
		end,
})

mobs:spawn({
	name = "mobs_monster:spider",
	nodes = {"default:dirt", "default:sandstone", "default:sand", "default:stone", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:cobble", "default:mossycobble"},
	min_light = 0,
	max_light = 12,
	chance = 7000,
	min_height = -50,
	max_height = 31000,
})

mobs:register_egg("mobs_monster:spider", "Spider", "mobs_cobweb.png", 1)

mobs:alias_mob("mobs:spider", "mobs_monster:spider") -- compatibility

-- Small spider

mobs:register_mob("mobs_monster:small_spider", {
	docile_by_day = true,
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 1,
	hp_min = 5,
	hp_max = 10,
	armor = 100,
	collisionbox = {-0.23, -0.01, -0.23, 0.23, 0.2, 0.23},
	visual = "mesh",
	mesh = "mobs_spider.b3d",
	textures = {
		{"mobs_spider.png"},
	},
	visual_size = {x = 0.3, y = 0.3},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	view_range = 10,
	floats = 0,
--	drops = {
--		{name = "farming:string",
--		chance = 1, min = 1, max = 1},	},
	water_damage = 5,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 20,
		stand_start = 0,
		stand_end = 0,
		walk_start = 1,
		walk_end = 21,
		run_start = 1,
		run_end = 21,
		punch_start = 25,
		punch_end = 45,
	},
		after_activate = function(self, staticdata, def, dtime)
			-- replace spider using the old directx model
			if self.mesh == "mobs_spider.x" then
				local pos = self.object:get_pos()
				if pos then
					minetest.add_entity(pos, self.name)
					self.object:remove()
				end
			end
		end,
})

mobs:spawn({
	name = "mobs_monster:small_spider",
	nodes = {"default:dirt", "default:sandstone", "default:sand", "default:stone", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:cobble", "default:mossycobble"},
	min_light = 0,
	max_light = 15,
	interval = 30,
	chance = 8000,
	min_height = -50,
	max_height = 31000,
})

-- cobweb
minetest.register_node(":mobs:cobweb", {
	description = "Cobweb",
	drawtype = "plantlike",
	visual_scale = 1.2,
	tiles = {"mobs_cobweb.png"},
	inventory_image = "mobs_cobweb.png",
	paramtype = "light",
	sunlight_propagates = true,
	liquid_viscosity = 11,
	liquidtype = "source",
	liquid_alternative_flowing = "mobs:cobweb",
	liquid_alternative_source = "mobs:cobweb",
	liquid_renewable = false,
	liquid_range = 0,
	walkable = false,
	groups = {snappy = 1, disable_jump = 1},
	--drop = "farming:cotton",
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "mobs:cobweb",
	recipe = {
		{"farming:string", "", "farming:string"},
		{"", "farming:string", ""},
		{"farming:string", "", "farming:string"},
	}
})
