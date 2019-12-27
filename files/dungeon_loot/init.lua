dungeon_loot = {}

dungeon_loot.CHESTS_MIN = 1
dungeon_loot.CHESTS_MAX = 3
dungeon_loot.STACKS_PER_CHEST_MAX = 8

local modpath = minetest.get_modpath("dungeon_loot")
dofile(modpath .. "/loot.lua")
dofile(modpath .. "/mapgen.lua")
