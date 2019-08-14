local path = minetest.get_modpath("mobs")

-- Mob API
dofile(path .. "/api.lua")

-- Mob Items
dofile(path .. "/crafts.lua")

for node, def in pairs(minetest.registered_nodes) do
	if def.groups.flora == 1 then
		minetest.add_group(node, {nohit = 1})
	end
end

