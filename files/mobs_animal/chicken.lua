mobs:register_mob("mobs_animal:chicken", {
	type = "animal",
	passive = true,
	hp_min = 3,
	hp_max = 6,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 0.75, 0.35},
	visual = "mesh",
	mesh = "mobs_chicken.b3d",
	textures = {"mobs_chicken.png"},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_chicken",
	},
	run_velocity = 3,
	runaway = true,
	drops = {
		{name = "mobs:chicken_raw"}
	},
	fall_damage = 0,
	fall_speed = -8,
	fear_height = 5,
	animation = {
		stand_start = 0,
		stand_end = 20,
		walk_start = 20,
		walk_end = 40,
		run_start = 60,
		run_end = 80,
	},
	follow = {"farming:seed_wheat"},

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		--if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	end,

	do_custom = function(self, dtime)
		self.egg_timer = (self.egg_timer or 0) + dtime
		if self.egg_timer < 10 then
			return
		end
		self.egg_timer = 0

		if self.child
		or math.random(1, 100) ~= 1 then
			return
		end

		local pos = self.object:get_pos()
		minetest.add_item(pos, "mobs:chicken_egg")
		minetest.sound_play("default_place_node_hard", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 5,
		})
	end,
	after_activate = function(self, staticdata, def, dtime)
		-- replace chicken using the old directx model
		if self.mesh == "mobs_chicken.x" then
			local pos = self.object:get_pos()
			if pos then
				minetest.add_entity(pos, self.name)
				self.object:remove()
			end
		end
	end,
	})

mobs:spawn({
	name = "mobs_animal:chicken",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true,
})

mobs:register_egg("mobs_animal:chicken", "Chicken egg", "mobs_chicken_egg_inv.png", 1)

-- egg throwing

function egg_impact(thrower, pos, dir, hit_object)
	if hit_object then
		local punch_damage = {
			full_punch_interval = 1.0,
			damage_groups = {fleshy=1},
		}
		hit_object:punch(thrower, 1.0, punch_damage, dir)
	end

	if math.random(1, 8) == 8 then
		pos.y = pos.y + 1
		local nod = minetest.get_node_or_nil(pos)

		if not nod or
		not minetest.registered_nodes[nod.name] or
		minetest.registered_nodes[nod.name].walkable == true then
			return
		end

		local mob = minetest.add_entity(pos, "mobs_animal:chicken")
		local ent2 = mob:get_luaentity()
		mob:set_properties({
			visual_size = {
				x = ent2.base_size.x / 2,
				y = ent2.base_size.y / 2
			},
			collisionbox = {
				ent2.base_colbox[1] / 2,
				ent2.base_colbox[2] / 2,
				ent2.base_colbox[3] / 2,
				ent2.base_colbox[4] / 2,
				ent2.base_colbox[5] / 2,
				ent2.base_colbox[6] / 2
			},
		})
		ent2.child = true
		ent2.tamed = true
		ent2.owner = thrower
	end
end
