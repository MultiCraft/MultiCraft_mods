local path = minetest.get_modpath("mobs")

-- Mob API
dofile(path .. "/api.lua")

-- Mob Items
dofile(path .. "/crafts.lua")

minetest.after(0, function()
	for node, def in pairs(minetest.registered_items) do
		if def.groups.flora == 1
		or def.groups.seed == 1
		or def.groups.farming == 1
		or def.groups.food_meat_raw == 1
		or def.groups.food_fish_raw == 1 then
			minetest.add_group(node, {nohit = 1})
		end
	end
end)
