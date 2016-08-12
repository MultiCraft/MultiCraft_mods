
local all_colours = {
	{"black",      "Black"     },
	{"blue",       "Blue"      },
	{"brown",      "Brown"     },
	{"cyan",       "Cyan"      },
	{"dark_green", "Dark Green"},
	{"dark_grey",  "Dark Grey" },
	{"green",      "Green"     },
	{"grey",       "Grey"      },
	{"magenta",    "Magenta"   },
	{"orange",     "Orange"    },
	{"pink",       "Pink"      },
	{"red",        "Red"       },
	{"violet",     "Violet"    },
	{"white",      "White"     },
	{"yellow",     "Yellow"    },
}

-- Sheep by PilzAdam

for _, col in pairs(all_colours) do

	mobs:register_mob("mobs_animal:sheep_"..col[1], {
		type = "animal",
		passive = true,
		hp_min = 6,
		hp_max = 10,
		armor = 100,
		collisionbox = {-0.4, -1, -0.4, 0.4, 0.3, 0.4},
		visual = "mesh",
		mesh = "mobs_sheep.b3d",
		textures = {
			{"mobs_sheep_" .. col[1] .. ".png"},
		},
		gotten_texture = {"mobs_sheep_shaved.png"},
		gotten_mesh = "mobs_sheep_shaved.b3d",
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_sheep",
			damage = "mobs_sheep_angry",
		},
		walk_velocity = 1,
		run_velocity = 2,
		runaway = true,
		jump = true,
		drops = {
			{name = "mobs:meat_raw", chance = 1, min = 1, max = 2},
			{name = "wool:"..col[1], chance = 1, min = 1, max = 1},
		},
		water_damage = 1,
		lava_damage = 5,
		light_damage = 0,
		animation = {
			speed_normal = 15,
			speed_run = 15,
			stand_start = 0,
			stand_end = 80,
			walk_start = 81,
			walk_end = 100,
		},
		follow = {"farming:wheat", "default:grass_5"},
		view_range = 8,
		replace_rate = 10,
		replace_what = {"default:grass_3", "default:grass_4", "default:grass_5", "farming:wheat_8"},
		replace_with = "air",
		replace_offset = -1,
		fear_height = 3,

		on_rightclick = function(self, clicker)

			--are we feeding?
			if mobs:feed_tame(self, clicker, 8, true, true) then

				--if full grow fuzz
				if self.gotten == false then

					self.object:set_properties({
						textures = {"mobs_sheep_"..col[1]..".png"},
						mesh = "mobs_sheep.b3d",
					})
				end

				return
			end

			local item = clicker:get_wielded_item()
			local itemname = item:get_name()

			--are we giving a haircut>
			if itemname == "mobs:shears" then

				if self.gotten ~= false
				or self.child ~= false
				or not minetest.get_modpath("wool") then
					return
				end

				self.gotten = true -- shaved

				local obj = minetest.add_item(
					self.object:getpos(),
					ItemStack( "wool:" .. col[1] .. " " .. math.random(1, 3) )
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

			local name = clicker:get_player_name()

			--are we coloring?
			if itemname:find("dye:") then

				if self.gotten == false
				and self.child == false
				and self.tamed == true
				and name == self.owner then

					local colr = string.split(itemname, ":")[2]

					for _,c in pairs(all_colours) do

						if c[1] == colr then

							local pos = self.object:getpos()

							self.object:remove()

							local mob = minetest.add_entity(pos, "mobs_animal:sheep_" .. colr)
							local ent = mob:get_luaentity()

							ent.owner = name
							ent.tamed = true

							-- take item
							if not minetest.setting_getbool("creative_mode") then
								item:take_item()
								clicker:set_wielded_item(item)
							end

							break
						end
					end
				end

				return
			end

			--are we capturing?
			mobs:capture_mob(self, clicker, 0, 5, 60, false, nil)
		end
	})

	mobs:register_egg("mobs_animal:sheep_"..col[1], col[2] .. " Sheep", "wool_"..col[1]..".png", 1)

	-- compatibility
	mobs:alias_mob("mobs:sheep_" .. col[1], "mobs_animal:sheep_" .. col[1])

end

mobs:register_spawn("mobs_animal:sheep_white",
	{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"}, 20, 5, 12000, 1, 31000, true)

mobs:register_spawn("mobs_animal:sheep_grey",
	{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"}, 20, 5, 12000, 1, 31000, true)

mobs:register_spawn("mobs_animal:sheep_dark_grey",
	{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"}, 20, 5, 12000, 1, 31000, true)

mobs:register_spawn("mobs_animal:sheep_black",
	{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"}, 20, 5, 12000, 1, 31000, true)

mobs:register_spawn("mobs_animal:sheep_brown",
	{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"}, 20, 5, 12000, 1, 31000, true)


-- compatibility
mobs:alias_mob("mobs:sheep", "mobs_animal:sheep_white")
