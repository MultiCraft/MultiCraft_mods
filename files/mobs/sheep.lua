local all_colours = {
	"grey", "black", "red", "yellow", "green", "cyan", "blue", "magenta",
	"white", "orange", "violet", "brown", "pink", "dark_grey", "dark_green"
}

-- Sheep by PilzAdam

for _, col in ipairs(all_colours) do

	mobs:register_mob("mobs:sheep_"..col, {
		type = "animal",
		passive = true,
		hp_min = 6,
		hp_max = 10,
		armor = 100,
		collisionbox = {-0.4, -1, -0.4, 0.4, 0.3, 0.4},
		visual = "mesh",
		mesh = "mobs_sheep.b3d",
		textures = {
			{"mobs_sheep_"..col..".png"},
		},
		gotten_texture = {"mobs_sheep_shaved.png"},
		gotten_mesh = "mobs_sheep_shaved.b3d",
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_sheep",
			damage = "mobs_sheep_angry",
			death  = "mobs_sheep_angry",
		},
		walk_velocity = 1,
		jump = true,
		drops = {
			{name = "mobs:meat_raw",
			chance = 1, min = 1, max = 2},
			{name = "wool:"..col,
			chance = 1, min = 1, max = 1},
		},
		water_damage = 1,
		lava_damage = 5,
		light_damage = 0,
		fear_height = 2,
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
		on_rightclick = function(self, clicker)
			local shpcolor = string.split(self.name,"_")[2]
			if shpcolor =="dark" then
				shpcolor = shpcolor.."_"..string.split(self.name,"_")[3]
			end

			--are we feeding?
			if mobs:feed_tame(self, clicker, 8, true, true) then
				--if full grow fuzz
				if self.gotten == false then
					self.object:set_properties({
						textures = {"mobs_sheep_"..shpcolor..".png"},
						mesh = "mobs_sheep.b3d",
					})
				end
				return
			end

			local item = clicker:get_wielded_item()
			local itemname = item:get_name()

			--are we giving a haircut>
			if itemname == "mobs:shears" then
				if self.gotten == false and self.child == false then
					self.gotten = true -- shaved
					if minetest.get_modpath("wool") then
						local pos = self.object:getpos()
						pos.y = pos.y + 0.5
						local obj = minetest.add_item(pos, ItemStack("wool:"..shpcolor.." "..math.random(1,3)))
						if obj then
							obj:setvelocity({
								x = math.random(-1,1),
								y = 5,
								z = math.random(-1,1)
							})
						end
						item:add_wear(650) -- 100 uses
						clicker:set_wielded_item(item)
					end
					self.object:set_properties({
						textures = {"mobs_sheep_shaved.png"},
						mesh = "mobs_sheep_shaved.b3d",
					})
				end
				return
			end

			local name = clicker:get_player_name()

			--are we coloring?
			if itemname:find("dye:") then
				if self.gotten == false and self.child == false and self.tamed == true and name == self.owner then
					local col = string.split(itemname,":")[2]
					for _,c in pairs(all_colours) do
						if c == col then
							local pos = self.object:getpos()
							self.object:remove()
							local mob = minetest.add_entity(pos, "mobs:sheep_"..col)
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

	mobs:register_egg("mobs:sheep_"..col, "Sheep ("..col..")", "wool_"..col..".png", 1)

end

mobs:spawn_specific("mobs:sheep_white",
		{"default:dirt", "default:sand", "default:snowblock", "default:dirt_with_snow",  "default:dirt_with_grass"},
		{"air"},
		0, 20, 0, 5000, 1, -31000, 31000
	)