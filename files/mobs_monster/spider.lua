-- Spider by AspireMint (fishyWET (CC-BY-SA 3.0 license for texture)
mobs:register_mob("mobs_monster:spider", {
	docile_by_day = true,
	group_attack = true,
	type = "monster",
	passive = false,
	damage = 2,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.8, -0.5, -0.8, 0.8, 0, 0.8},
	visual = "mesh",
	mesh = "mobs_spider.b3d",
	textures = {
		{"mobs_spider.png"},
		{"mobs_spider_grey.png"},
		{"mobs_spider_orange.png"},
	},
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider",
	},
	run_velocity = 3,
	view_range = 15,
	floats = 0,
	drops = {
		{name = "farming:string"},
		{name = "farming:string", chance = 2}
	},
	water_damage = 5,
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
	nodes = {"default:dirt", "default:sandstone", "default:sand", "default:redsand", "default:redsand", "default:stone", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:cobble", "default:mossycobble"},
	max_light = 12,
	chance = 20000,
	min_height = -64,
})

mobs:register_egg("mobs_monster:spider", "Spider egg", "mobs_chicken_egg.png^mobs_cobweb.png", 1)
mobs:register_egg("mobs_monster:small_spider", "Small Spider egg", "mobs_chicken_egg.png^mobs_cobweb.png", 1)

-- Small spider

mobs:register_mob("mobs_monster:small_spider", {
	--docile_by_day = true,
	group_attack = true,
	type = "animal",
	passive = false,
	damage = 1,
	hp_min = 5,
	hp_max = 10,
	collisionbox = {-0.3, -0.15, -0.3, 0.3, 0.05, 0.3},
	visual = "mesh",
	mesh = "mobs_spider.b3d",
	textures = {
		{"mobs_spider.png"},
		{"mobs_spider_grey.png"},
		{"mobs_spider_orange.png"},
	},
	visual_size = {x = 0.3, y = 0.3},
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider",
	},
	run_velocity = 3,
	view_range = 10,
	floats = 0,
	drops = {
		{name = "farming:string"}
	},
	water_damage = 5,
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
	nodes = {"default:dirt", "default:sandstone", "default:sand", "default:redsand", "default:redsand", "default:stone", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:cobble", "default:mossycobble"},
	chance = 20000,
	min_height = -64,
})

minetest.register_craft({
	output = "mobs:cobweb",
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
	}
})
