mobs:register_mob("mobs_animal:cow", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 2,
	hp_min = 8,
	hp_max = 12,
	armor = 100,
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
	},
	walk_velocity = 1,
	run_velocity = 2,
	jump = true,
	jump_height = 6,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
		{name = "mobs:meat_raw", chance = 2, min = 1, max = 1},
		{name = "mobs:meat_raw", chance = 2, min = 1, max = 1},
		{name = "mobs:leather", chance = 2, min = 1, max = 1},
		{name = "mobs:leather", chance = 2, min = 1, max = 1}
	},
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 35,
		walk_end = 65,
		run_start = 105,
		run_end = 135,
		punch_start = 70,
		punch_end = 100,
	},
	follow = "farming:wheat",
	view_range = 8,
	replace_rate = 10,
	replace_what = {
		{"group:grass", "air", 0},
		{"default:dirt_with_grass", "default:dirt", -1}
	},
	replace_with = "air",
	fear_height = 2,
	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end

		local tool = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		-- milk cow with empty bucket
		if tool:get_name() == "bucket:bucket_empty" then

			--if self.gotten == true
			if self.child == true then
				return
			end

			if self.gotten == true then
				minetest.chat_send_player(name,
						"Cow already milked!")
				return
			end

			local inv = clicker:get_inventory()

			inv:remove_item("main", "bucket:bucket_empty")

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
		after_activate = function(self, staticdata, def, dtime)
			-- replace cow using the old directx model
			if self.mesh == "mobs_cow.x" then
				local pos = self.object:get_pos()
				if pos then
					minetest.add_entity(pos, self.name)
					self.object:remove()
				end
			end
		end,
	})

mobs:spawn({
	name = "mobs_animal:cow",
	nodes = {"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
	min_light = 5,
	interval = 30,
	chance = 8000,
	min_height = 0,
	max_height = 31000,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:cow", "Cow", "default_grass.png", 1)

mobs:alias_mob("mobs:cow", "mobs_animal:cow") -- compatibility


-- bucket of milk
minetest.register_craftitem(":mobs:bucket_milk", {
	description = "Bucket of Milk",
	inventory_image = "mobs_bucket_milk.png",
	stack_max = 1,
	on_use = minetest.item_eat(8, 'bucket:bucket_empty'),
	groups = {food_milk = 1, flammable = 3},
})

-- cheese wedge
minetest.register_craftitem(":mobs:cheese", {
	description = "Cheese",
	inventory_image = "mobs_cheese.png",
	on_use = minetest.item_eat(4),
	groups = {food_cheese = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:cheese",
	recipe = "mobs:bucket_milk",
	cooktime = 5,
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- cheese block
minetest.register_node(":mobs:cheeseblock", {
	description = "Cheese Block",
	tiles = {"mobs_cheeseblock.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_craft({
	output = "mobs:cheeseblock",
	recipe = {
		{'mobs:cheese', 'mobs:cheese', 'mobs:cheese'},
		{'mobs:cheese', 'mobs:cheese', 'mobs:cheese'},
		{'mobs:cheese', 'mobs:cheese', 'mobs:cheese'},
	}
})

minetest.register_craft({
	output = "mobs:cheese 9",
	recipe = {
		{'mobs:cheeseblock'},
	}
})
