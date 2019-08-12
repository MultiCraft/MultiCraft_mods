mobs:register_mob("mobs_animal:cow", {
	type = "animal",
	damage = 2,
	hp_min = 8,
	hp_max = 12,
	collisionbox = {-0.9, -0.01, -0.9, 0.9, 1.65, 0.9},
	visual = "mesh",
	mesh = "mobs_cow.b3d",
	textures = {
		{"mobs_cow.png"},
		{"mobs_cow2.png"},
		{"mobs_cow3.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_cow",
		attack = "mobs_cow",
	},
	run_velocity = 3,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(3, 5), pos)
		end
		return {
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:leather", chance = 2},
			{name = "mobs:leather", chance = 2}
		}
	end,
	animation = {
		speed_normal = 15,	speed_run = 15,
		stand_start = 0,	stand_end = 30,
		walk_start = 35,	walk_end = 65,
		run_start = 105,	run_end = 135,
		punch_start = 70,	punch_end = 100
	},
	follow = {"farming:wheat", "default:grass"},
	view_range = 10,
	replace_rate = 10,
	replace_what = {
		{"group:grass", "air", 0},
		{"default:dirt_with_grass", "default:dirt", -1}
	},
	fear_height = 2,

	on_rightclick = function(self, clicker)
		-- feed or tame
		if mobs:feed_tame(self, clicker, 8, true, true) then
			-- if fed 7x wheat or grass then cow can be milked again
			if self.food and self.food > 6 then
				self.gotten = false
			end
			return
		end

		if mobs:protect(self, clicker) then return end
	--	if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end

		local tool = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		-- milk cow with empty bucket
		if tool:get_name() == "bucket:bucket_empty" then
			if self.child == true then
				return
			end

			if self.gotten == true then
				minetest.chat_send_player(name,
						"Cow already milked!")
				return
			end

			local inv = clicker:get_inventory()
			tool:take_item()
			clicker:set_wielded_item(tool)

			if inv:room_for_item("main", {name = "mobs:bucket_milk"}) then
				clicker:get_inventory():add_item("main", "mobs:bucket_milk")
			else
				local pos = self.object:get_pos()
				pos.y = pos.y + 0.5
				minetest.add_item(pos, {name = "mobs:bucket_milk"})
			end
			self.gotten = true -- milked
			return
		end
	end,

	on_replace = function(self, pos, oldnode, newnode)
		self.food = (self.food or 0) + 1

		-- if cow replaces 8x grass then it can be milked again
		if self.food >= 8 then
			self.food = 0
			self.gotten = false
		end
	end,

	after_activate = function(self, staticdata, def, dtime)
		-- replace cow using the old directx model
		if self.mesh == "mobs_cow.x" then
			local pos = self.object:get_pos()
			if pos then
				minetest.add_entity(pos, self.name)
				self.object:remove()
			end
		end
	end
})

mobs:spawn({
	name = "mobs_animal:cow",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_dry_grass", "default:dirt_with_grass"},
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:cow", "Cow Egg", "mobs_cow_egg.png", 1)
