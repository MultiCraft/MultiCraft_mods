-- mods/default/aliases.lua

-- Aliases to support loading worlds using nodes following the old naming convention
-- These can also be helpful when using chat commands, for example /giveme
minetest.register_alias("stone", "default:stone")
minetest.register_alias("stone_with_coal", "default:stone_with_coal")
minetest.register_alias("stone_with_iron", "default:stone_with_iron")
minetest.register_alias("dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("dirt_with_grass_footsteps", "default:dirt_with_grass_footsteps")
minetest.register_alias("dirt", "default:dirt")
minetest.register_alias("sand", "default:sand")
minetest.register_alias("gravel", "default:gravel")
minetest.register_alias("sandstone", "default:sandstone")
minetest.register_alias("clay", "default:clay")
minetest.register_alias("brick", "default:brick")
minetest.register_alias("tree", "default:tree")
minetest.register_alias("jungletree", "default:jungletree")
minetest.register_alias("junglegrass", "default:junglegrass")
minetest.register_alias("leaves", "default:leaves")
minetest.register_alias("cactus", "default:cactus")
minetest.register_alias("papyrus", "default:sugarcane")
minetest.register_alias("bookshelf", "default:bookshelf")
minetest.register_alias("glass", "default:glass")
minetest.register_alias("wooden_fence", "default:fence_wood")
minetest.register_alias("ladder", "default:ladder")
minetest.register_alias("wood", "default:wood")
minetest.register_alias("water_flowing", "default:water_flowing")
minetest.register_alias("water_source", "default:water_source")
minetest.register_alias("lava_flowing", "default:lava_flowing")
minetest.register_alias("lava_source", "default:lava_source")
minetest.register_alias("torch", "default:torch")
minetest.register_alias("sign_wall", "default:sign_wall")
minetest.register_alias("signs:sign_wall", "signs:sign")
minetest.register_alias("furnace", "default:furnace")
minetest.register_alias("chest", "default:chest")
minetest.register_alias("locked_chest", "default:chest_locked")
minetest.register_alias("cobble", "default:cobble")
minetest.register_alias("mossycobble", "default:mossycobble")
minetest.register_alias("steelblock", "default:steelblock")
minetest.register_alias("sapling", "default:sapling")
minetest.register_alias("apple", "default:apple")

minetest.register_alias("WPick", "default:pick_wood")
minetest.register_alias("STPick", "default:pick_stone")
minetest.register_alias("SteelPick", "default:pick_steel")
minetest.register_alias("WShovel", "default:shovel_wood")
minetest.register_alias("STShovel", "default:shovel_stone")
minetest.register_alias("SteelShovel", "default:shovel_steel")
minetest.register_alias("WAxe", "default:axe_wood")
minetest.register_alias("STAxe", "default:axe_stone")
minetest.register_alias("SteelAxe", "default:axe_steel")
minetest.register_alias("WSword", "default:sword_wood")
minetest.register_alias("STSword", "default:sword_stone")
minetest.register_alias("SteelSword", "default:sword_steel")

minetest.register_alias("Stick", "default:stick")
minetest.register_alias("paper", "default:paper")
minetest.register_alias("book", "default:book")
minetest.register_alias("lump_of_coal", "default:coal_lump")
minetest.register_alias("lump_of_iron", "default:iron_lump")
minetest.register_alias("lump_of_clay", "default:clay_lump")
minetest.register_alias("steel_ingot", "default:steel_ingot")
minetest.register_alias("clay_brick", "default:clay_brick")
minetest.register_alias("snow", "default:snow")

-- Aliases for corrected pine node names
minetest.register_alias("default:pinetree", "default:pine_tree")
minetest.register_alias("default:pinewood", "default:pine_wood")

-- Gold nugget
minetest.register_alias("default:gold_nugget", "default:gold_ingot")

-- Sandstone Carved
minetest.register_alias("default:sandstonecarved", "default:sandstonesmooth")

-- Workbench
minetest.register_alias("crafting:workbench", "workbench:workbench")
minetest.register_alias("default:workbench", "workbench:workbench")

-- String
minetest.register_alias("default:string", "farming:string")

-- Hay Bale
minetest.register_alias("default:haybale", "farming:straw")

-- Ladder
minetest.register_alias("default:ladder", "default:ladder_wood")

-- Ladder
minetest.register_alias("default:reeds", "default:sugarcane")
minetest.register_alias("default:papyrus", "default:sugarcane")

-- Fences
minetest.register_alias("fences:fence_wood", "default:fence_wood")
minetest.register_alias("fences:fence_wood_1", "default:fence_wood")
minetest.register_alias("fences:fence_wood_2", "default:fence_wood")
minetest.register_alias("fences:fence_wood_3", "default:fence_wood")
minetest.register_alias("fences:fence_wood_11", "default:fence_wood")
minetest.register_alias("fences:fence_wood_12", "default:fence_wood")
minetest.register_alias("fences:fence_wood_13", "default:fence_wood")
minetest.register_alias("fences:fence_wood_14", "default:fence_wood")
minetest.register_alias("fences:fence_wood_21", "default:fence_wood")
minetest.register_alias("fences:fence_wood_22", "default:fence_wood")
minetest.register_alias("fences:fence_wood_23", "default:fence_wood")
minetest.register_alias("fences:fence_wood_24", "default:fence_wood")
minetest.register_alias("fences:fence_wood_32", "default:fence_wood")
minetest.register_alias("fences:fence_wood_33", "default:fence_wood")
minetest.register_alias("fences:fence_wood_34", "default:fence_wood")
minetest.register_alias("fences:fence_wood_35", "default:fence_wood")

-- Hardened Clay
minetest.register_alias("hardened_clay:hardened_clay", "default:hardened_clay")
