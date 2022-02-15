dungeon_loot = {
	CHESTS_MIN = 1,
	CHESTS_MAX = 3,
	STACKS_PER_CHEST_MAX = 8
}

local modpath = minetest.get_modpath("dungeon_loot")
dofile(modpath .. "/loot.lua")
dofile(modpath .. "/mapgen.lua")
