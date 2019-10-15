-- mods/default/aliases.lua

-- Aliases to support loading worlds using nodes following the old naming convention

-- Pinetree
minetest.register_alias("default:pinetree", "default:pine_tree")
minetest.register_alias("default:pinewood", "default:pine_wood")

-- Gold Nugget
minetest.register_alias("default:gold_nugget", "default:gold_ingot")

-- Sandstone Carved
minetest.register_alias("default:sandstonecarved", "default:sandstonesmooth")

-- Ladder
minetest.register_alias("default:ladder", "default:ladder_wood")

-- Sugarcane
minetest.register_alias("default:reeds", "default:sugarcane")
minetest.register_alias("default:papyrus", "default:sugarcane")

-- Fences
minetest.register_alias("fences:fence_wood", "default:fence_wood")
for _, n in pairs({"1", "2", "3", "11", "12", "13", "14",
		"21", "22", "23", "24", "32", "33", "34", "35"}) do
	minetest.register_alias("fences:fence_wood_" .. n, "default:fence_wood")
end

-- Hardened Clay
minetest.register_alias("hardened_clay:hardened_clay", "default:hardened_clay")
