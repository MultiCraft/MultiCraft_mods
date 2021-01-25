local S = mobs_animal.S

mobs:register_mob("mobs_animal:bunny", {
	description = S"Bunny",
	stepheight = 0.6,
	type = "animal",
	damage = 5,
	passive = true,
	reach = 1,
	hp_min = 1,
	hp_max = 4,
	collisionbox = {-0.268, -0.5, -0.268, 0.268, 0.167, 0.268},
	visual = "mesh",
	mesh = "mobs_bunny.b3d",
	drawtype = "front",
	textures = {
		{"mobs_bunny_grey.png"},
		{"mobs_bunny_brown.png"},
		{"mobs_bunny_white.png"}
	},
	runaway = true,
	runaway_from = {"mobs_animal:pumba", "player"},
	jump_height = 5,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(2), pos)
		end
		return {
			{name = "mobs:rabbit_raw"},
			{name = "mobs:rabbit_hide", min = 0, max = 1}
		}
	end,
	fear_height = 2,
	animation = {
		speed_normal = 15,
		stand_start = 1,	stand_end = 15,
		walk_start = 16,	walk_end = 24,
		punch_start = 16,	punch_end = 24
	},
	follow = {"flora", "farming_addons:carrot"},
	replace_rate = 10,
	replace_what = {"farming:carrot_7", "farming:carrot_8", "farming_plus:carrot"},
	replace_with = "air",

	on_rightclick = function(self, clicker)
		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, true, true) then return end
	--	if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end

		-- Monty Python tribute
		local item = clicker:get_wielded_item()

		if item:get_name() == "mobs:rotten_flesh" then
			if not mobs.is_creative(clicker:get_player_name()) then
				item:take_item()
				clicker:set_wielded_item(item)
			end

			self.object:set_properties({
				textures = {"mobs_bunny_evil.png"}
			})
			self.type = "monster"
			self.health = 20
			self.passive = false
			return
		end
	end,

	on_spawn = function(self)
		local pos = self.object:get_pos()
		pos.y = pos.y - 1
		-- white snowy bunny
		if minetest.find_node_near(pos, 1,
				{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then
			self.base_texture = {"mobs_bunny_white.png"}
			self.object:set_properties({textures = self.base_texture})
		-- brown desert bunny
		elseif minetest.find_node_near(pos, 1,
				{"group:sand", "default:desert_stone"}) then
			self.base_texture = {"mobs_bunny_brown.png"}
			self.object:set_properties({textures = self.base_texture})
		-- grey stone bunny
		elseif minetest.find_node_near(pos, 1,
				{"default:stone", "default:gravel"}) then
			self.base_texture = {"mobs_bunny_grey.png"}
			self.object:set_properties({textures = self.base_texture})
		end
		return true -- run only once, false/nil runs every activation
	end
})

mobs:spawn({
	name = "mobs_animal:bunny",
	nodes = {"default:snow", "default:snowblock", "default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"},
	min_light = 10,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:bunny", S"Bunny Egg", "mobs_bunny_evil.png", true)
