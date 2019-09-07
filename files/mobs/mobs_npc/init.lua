local path = minetest.get_modpath("mobs_npc")
local npc = {"npc", "trader"}

for _, name in pairs(npc) do
	dofile(path .. "/" .. name .. ".lua")
end
