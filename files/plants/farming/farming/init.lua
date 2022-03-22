-- Global farming namespace
farming = {}

local S = minetest.get_translator_auto({"ru"})
farming.S = S

-- Load files
local path = minetest.get_modpath("farming")
dofile(path .. "/api.lua")
dofile(path .. "/nodes.lua")
dofile(path .. "/hoes.lua")

-- Register farming items as dungeon loot
if minetest.global_exists("dungeon_loot") then
	dungeon_loot.register({
		{name = "farming:hoe_steel", chance = 0.25},
		{name = "farming:hoe_gold", chance = 0.2},
		{name = "farming:hoe_diamond", chance = 0.05}
	})
end
