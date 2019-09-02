local spider_replace = {"air", "mobs:cobweb"}
if not minetest.is_singleplayer() then
	spider_replace = {}
end

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
		{"mobs_spider_orange.png"}
	},
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider"
	},
	run_velocity = 3,
	view_range = 15,
	replace_rate = 64,
	replace_what = {
		spider_replace
	},
	floats = 0,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(2, 4), pos)
		end
		return {
			{name = "farming:string"},
			{name = "farming:string", chance = 2}
		}
	end,
	water_damage = 5,
	animation = {
		speed_normal = 15,	speed_run = 20,
		stand_start = 0,	stand_end = 0,
		walk_start = 1,		walk_end = 21,
		run_start = 1,		run_end = 21,
		punch_start = 25,	punch_end = 45,
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
	end
})

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
		{"mobs_spider_orange.png"}
	},
	visual_size = {x = 0.3, y = 0.3},
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider"
	},
	run_velocity = 3,
	view_range = 10,
	floats = 0,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(1, 2), pos)
		end
		return {
			{name = "farming:string"}
		}
	end,
	water_damage = 5,
	animation = {
		speed_normal = 15,	speed_run = 20,
		stand_start = 0,	stand_end = 0,
		walk_start = 1,		walk_end = 21,
		run_start = 1,		run_end = 21,
		punch_start = 25,	punch_end = 45
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
	end
})

mobs:register_egg("mobs_monster:spider", "Spider Egg", "mobs_monster_egg.png^mobs_spider_egg.png", 2)
mobs:register_egg("mobs_monster:small_spider", "Small Spider Egg", "mobs_monster_egg.png^mobs_spider_small_egg.png", 2)

local spawn_nodes = {"default:dirt", "default:sandstone", "default:sand", "default:redsand", "default:redsand", "default:stone", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass", "default:cobble", "default:mossycobble"}

mobs:spawn({
	name = "mobs_monster:spider",
	nodes = spawn_nodes,
	max_light = 12,
	chance = 20000
})

mobs:spawn({
	name = "mobs_monster:small_spider",
	nodes = spawn_nodes,
	chance = 20000
})
