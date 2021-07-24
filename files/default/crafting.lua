-- mods/default/crafting.lua

minetest.register_craft({
	output = "default:wood 4",
	recipe = {
		{"default:tree"}
	}
})

minetest.register_craft({
	output = "default:junglewood 4",
	recipe = {
		{"default:jungletree"}
	}
})

minetest.register_craft({
	output = "default:pine_wood 4",
	recipe = {
		{"default:pine_tree"}
	}
})

minetest.register_craft({
	output = "default:acacia_wood 4",
	recipe = {
		{"default:acacia_tree"}
	}
})

minetest.register_craft({
	output = "default:birch_wood 4",
	recipe = {
		{"default:birch_tree"}
	}
})

minetest.register_craft({
	output = "default:wood",
	recipe = {
		{"default:bush_stem"}
	}
})

minetest.register_craft({
	output = "default:acacia_wood",
	recipe = {
		{"default:acacia_bush_stem"}
	}
})

minetest.register_craft({
	output = "default:pine_wood",
	recipe = {
		{"default:pine_bush_stem"}
	}
})

minetest.register_craft({
	output = "default:cherry_blossom_wood 4",
	recipe = {
		{"default:cherry_blossom_tree"}
	}
})

minetest.register_craft({
	output = "default:mossycobble",
	recipe = {
		{"default:cobble", "default:vine"}
	}
})

minetest.register_craft({
	output = "default:stonebrickmossy",
	recipe = {
		{"default:stonebrick", "default:vine"}
	}
})

minetest.register_craft({
	output = "default:stonebrickcarved",
	recipe = {
		{"default:stonebrick", "default:stonebrick"}
	}
})

minetest.register_craft({
	output = "default:pole",
	recipe = {
		{"", "", "default:stick"},
		{"", "default:stick", "farming:string"},
		{"default:stick", "", "farming:string"}
	}
})

minetest.register_craft({
	output = "default:coalblock",
	recipe = {
		{"default:coal_lump", "default:coal_lump", "default:coal_lump"},
		{"default:coal_lump", "default:coal_lump", "default:coal_lump"},
		{"default:coal_lump", "default:coal_lump", "default:coal_lump"}
	}
})

minetest.register_craft({
	output = "default:steelblock",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "default:goldblock",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "default:diamondblock",
	recipe = {
		{"default:diamond", "default:diamond", "default:diamond"},
		{"default:diamond", "default:diamond", "default:diamond"},
		{"default:diamond", "default:diamond", "default:diamond"}
	}
})

minetest.register_craft({
	output = "default:sandstone",
	recipe = {
		{"default:sand", "default:sand"},
		{"default:sand", "default:sand"}
	}
})

minetest.register_craft({
	output = "default:sand 4",
	recipe = {
		{"default:sandstone"}
	}
})

minetest.register_craft({
	output = "default:redsandstone",
	recipe = {
		{"default:redsand", "default:redsand"},
		{"default:redsand", "default:redsand"}
	}
})

minetest.register_craft({
	output = "default:redsand 4",
	recipe = {
		{"default:redsandstone"}
	}
})

minetest.register_craft({
	output = "default:clay",
	recipe = {
		{"default:clay_lump", "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump"}
	}
})

minetest.register_craft({
	output = "default:brick",
	recipe = {
		{"default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick"}
	}
})

minetest.register_craft({
	output = "default:bookshelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"default:book", "default:book", "default:book"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "default:stonebrick",
	recipe = {
		{"default:stone", "default:stone"}
	}
})

minetest.register_craft({
	output = "default:emeraldblock",
	recipe = {
		{"default:emerald", "default:emerald", "default:emerald"},
		{"default:emerald", "default:emerald", "default:emerald"},
		{"default:emerald", "default:emerald", "default:emerald"}
	}
})

minetest.register_craft({
	output = "default:rubyblock",
	recipe = {
		{"default:ruby", "default:ruby", "default:ruby"},
		{"default:ruby", "default:ruby", "default:ruby"},
		{"default:ruby", "default:ruby", "default:ruby"}
	}
})

minetest.register_craft({
	output = "default:packedice",
	recipe = {
		{"default:ice", "default:ice"},
		{"default:ice", "default:ice"}
	}
})

minetest.register_craft({
	output = "default:snowblock",
	recipe = {
		{"default:snowball", "default:snowball", "default:snowball"},
		{"default:snowball", "default:snowball", "default:snowball"},
		{"default:snowball", "default:snowball", "default:snowball"}
	}
})

minetest.register_craft({
	output = "default:glowstone",
	recipe = {
		{"default:glowstone_dust", "default:glowstone_dust"},
		{"default:glowstone_dust", "default:glowstone_dust"}
	}
})

minetest.register_craft({
	output = "default:grill_bar 4",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "default:cement 8",
	recipe = {
		{"default:gravel", "default:gravel", "default:sand"},
		{"default:gravel", "bucket:bucket_water", "default:sand"},
		{"default:gravel", "default:sand", "default:sand"}
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})

minetest.register_craft({
	output = "default:cement 8",
	recipe = {
		{"default:gravel", "default:gravel", "default:sand"},
		{"default:gravel", "bucket:bucket_river_water", "default:sand"},
		{"default:gravel", "default:sand", "default:sand"}
	},
	replacements = {{"bucket:bucket_river_water", "bucket:bucket_empty"}}
})

minetest.register_craft({
	output = "default:apple_gold",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:gold_ingot", "group:apple", "default:gold_ingot"},
		{"", "default:gold_ingot", ""}
	}
})

--
-- Cooking recipes
--

minetest.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "group:sand"
})

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:cobble"
})

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:mossycobble"
})

minetest.register_craft({
	type = "cooking",
	output = "default:sandstonesmooth",
	recipe = "default:sandstone"
})

minetest.register_craft({
	type = "cooking",
	output = "default:stonebrickcracked",
	recipe = "default:stonebrick"
})

minetest.register_craft({
	type = "cooking",
	output = "default:redsandstonesmooth",
	recipe = "default:redsandstone"
})

--
-- Fuels
--

minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 15
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 15
})


minetest.register_craft({
	type = "fuel",
	recipe = "default:vine",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:fence_wood",
	burntime = 15
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bush_stem",
	burntime = 7
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:acacia_bush_stem",
	burntime = 8
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:pine_bush_stem",
	burntime = 6
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglegrass",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 5
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:cactus",
	burntime = 15
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:sugarcane",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bookshelf",
	burntime = 30
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood_ladder",
	burntime = 8
})

minetest.register_craft({
	type = "fuel",
	recipe = "bucket:bucket_lava",
	burntime = 1000
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coalblock",
	burntime = 400
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:grass",
	burntime = 2
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:dry_grass",
	burntime = 2
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fern_1",
	burntime = 2
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:dry_shrub",
	burntime = 4
})
