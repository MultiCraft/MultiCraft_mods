local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	mobs:register_mob("mobs_animal:sheep_" .. name, {
		stay_near = {"farming:straw", 10},
		type = "animal",
		passive = true,
		hp_min = 6,
		hp_max = 10,
		collisionbox = {-0.4, -1, -0.4, 0.4, 0.3, 0.4},
		visual = "mesh",
		mesh = "mobs_sheep.b3d",
		textures = {"mobs_sheep_" .. name .. ".png"},
		gotten_texture = {"mobs_sheep_shaved.png"},
		gotten_mesh = "mobs_sheep_shaved.b3d",
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_sheep",
			damage = "mobs_sheep_angry",
		},
		runaway = true,
		jump_height = 3,
		drops = function(pos)
			if rawget(_G, "experience") then
				experience.add_orb(math.random(2, 4), pos)
			end
			return {
				{name = "mobs:meat_raw"},
				{name = "mobs:meat_raw", chance = 2},
				{name = "wool:" .. name}
			}
		end,
		animation = {
			speed_normal = 15,
			speed_run = 15,
			stand_start = 0,
			stand_end = 80,
			walk_start = 81,
			walk_end = 100,
		},
		follow = {"farming:wheat", "default:grass"},
		replace_rate = 10,
		replace_what = {
			{"group:grass", "air", -1},
			{"default:dirt_with_grass", "default:dirt", -2}
		},
		fear_height = 3,
		on_replace = function(self, pos, oldnode, newnode)

			self.food = (self.food or 0) + 1

			-- if sheep replaces 8x grass then it regrows wool
			if self.food >= 8 then

				self.food = 0
				self.gotten = false

					self.object:set_properties({
						textures = {"mobs_sheep_" .. name .. ".png"},
						mesh = "mobs_sheep.b3d",
					})
			end
		end,
		on_rightclick = function(self, clicker)
			--are we feeding?
			if mobs:feed_tame(self, clicker, 8, true, true) then
				--if fed 7x grass or wheat then sheep regrows wool
				if self.food and self.food > 6 then
					self.gotten = false
					self.object:set_properties({
						textures = {"mobs_sheep_" .. name .. ".png"},
						mesh = "mobs_sheep.b3d",
					})
				end
				return
			end

			local item = clicker:get_wielded_item()
			local itemname = item:get_name()
			local player = clicker:get_player_name()

			--are we giving a haircut>
			if itemname == "mobs:shears" then
				if self.gotten or self.child
				or player ~= self.owner
				or not minetest.get_modpath("wool") then
					return
				end
				self.gotten = true -- shaved
				local obj = minetest.add_item(
					self.object:get_pos(),
					ItemStack( "wool:" .. name .. " " .. math.random(1, 3) )
				)
				if obj then
					obj:setvelocity({
						x = math.random(-1, 1),
						y = 5,
						z = math.random(-1, 1)
					})
				end
				item:add_wear(650) -- 100 uses
				clicker:set_wielded_item(item)
				self.object:set_properties({
					textures = {"mobs_sheep_shaved.png"},
					mesh = "mobs_sheep_shaved.b3d",
				})
				return
			end

			--are we coloring?
			if itemname:find("dye:") then
				if self.gotten == false
				and self.child == false
				and self.tamed == true
				and player == self.owner then
					local colr = string.split(itemname, ":")[2]
					for i = 1, #dyes do
						local name = unpack(dyes[i])

						if name == colr then
							local pos = self.object:get_pos()
							self.object:remove()
							local mob = minetest.add_entity(pos, "mobs_animal:sheep_" .. colr)
							local ent = mob:get_luaentity()
							ent.owner = player
							ent.tamed = true

							-- take item
							if not mobs.is_creative(player) or
							not minetest.is_singleplayer() then
								item:take_item()
								clicker:set_wielded_item(item)
							end
							break
						end
					end
				end
				return
			end

			if mobs:protect(self, clicker) then return end
			--if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end
		end
	})

	minetest.register_alias("mobs_animal:sheep_" .. name, "mobs_animal:sheep_white")
end

mobs:register_egg("mobs_animal:sheep_white", "White Sheep egg", "wool_white.png", 1)

mobs:spawn({
	name = "mobs_animal:sheep_white",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
	min_light = 7,
	chance = 100000,
	min_height = 0,
	day_toggle = true,
})

mobs:spawn({
	name = "mobs_animal:sheep_grey",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
	min_light = 7,
	chance = 100000,
	min_height = 0,
	day_toggle = true,
})

mobs:spawn({
	name = "mobs_animal:sheep_dark_grey",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:snow", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
	min_light = 7,
	chance = 100000,
	min_height = 0,
	day_toggle = true,
})

mobs:spawn({
	name = "mobs_animal:sheep_black",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:dirt_with_dry_grass",  "default:dirt_with_grass"},
	min_light = 7,
	chance = 100000,
	min_height = 0,
	day_toggle = true,
})

mobs:spawn({
	name = "mobs_animal:sheep_brown",
	nodes = {"default:dirt", "default:sand", "default:redsand", "default:dirt_with_dry_grass",  "default:dirt_with_grass"},
	min_light = 7,
	chance = 100000,
	min_height = 0,
	day_toggle = true,
})
