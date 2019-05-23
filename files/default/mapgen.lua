--
-- Aliases for map generators
--

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_river_water_source", "default:river_water_source")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_desert_stone", "default:redsandstone")
minetest.register_alias("mapgen_desert_sand", "default:redsand")
minetest.register_alias("default:desert_sand", "default:redsand")
minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
minetest.register_alias("mapgen_snowblock", "default:snowblock")
minetest.register_alias("mapgen_snow", "default:snow")
minetest.register_alias("mapgen_ice", "default:ice")
minetest.register_alias("mapgen_sandstone", "default:sandstone")
minetest.register_alias("mapgen_bedrock", "default:bedrock")

-- Flora

minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_pine_tree", "default:pine_tree")
minetest.register_alias("mapgen_pine_needles", "default:pine_needles")

-- Dungeons

minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_sandstonebrick", "default:sandstone")
minetest.register_alias("mapgen_stair_sandstonebrick", "stairs:stair_sandstone")

--
-- Register bedrock for Mgv6
--

function default.register_bedrock()
	-- Bedrock
	-- This first to avoid other ores cutting through bedrock

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:bedrock",
		wherein        = {"default:stone", "default:sand",
			"default:water_source", "default:lava_source", "air"},
		clust_scarcity = 1 * 1 * 1,
		clust_num_ores = 5,
		clust_size     = 2,
		y_min          = -66,
		y_max          = -64,
	})
end

--
-- Register ores
--

-- All mapgens except singlenode


function default.register_ores()

	-- Blob ore
	-- These first to avoid other ores in blobs

	-- Clay
	-- This first to avoid clay in sand blobs

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:clay",
		wherein         = {"default:sand"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -15,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Sand

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:sand",
		wherein         = {"default:stone", "default:sandstone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 4,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 2316,
			octaves = 1,
			persist = 0.0
		},
	})
	
	-- Red Sand

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:redsand",
		wherein         = {"default:stone", "default:redsandstone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 6,
		y_min           = -24,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 2316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Dirt

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:dirt",
		wherein         = {"default:stone", "default:sandstone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Gravel

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gravel",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -60,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Scatter ores

	-- Coal

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 9,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 0,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 8,
		clust_size     = 3,
		y_min          = 8,
		y_max          = -24,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 27,
		clust_size     = 6,
		y_max          = 0,
		y_min          = -64,
	})

	-- Iron

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 830,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -59,
		y_max          = -10,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 1660,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -9,
		y_max          = 0,
	})

	-- Gold

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -18,
		y_min          = -24,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -24,
		y_min          = -48,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -48,
		y_min          = -64,
	})

	-- Diamond

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 4,
		clust_size     = 3,
		y_max          = -48,
		y_min          = -59,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:stone",
		clust_scarcity = 5000,
		clust_num_ores = 2,
		clust_size     = 2,
		y_max          = -48,
		y_min          = -59,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = -52,
		y_min          = -55,
	})

	-- Bluestone

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_bluestone",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -59,
		y_max          = -48,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_bluestone",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 10,
		clust_size     = 4,
		y_min          = -59,
		y_max          = -48,
	})

	-- Emerald

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_emerald",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 1,
		clust_size     = 2,
		y_min     = -59,
		y_max     = -35,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_emerald",
		wherein        = "default:stone",
		clust_scarcity = 50000,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -59,
		y_max          = -35,
	})

	-- Lapis Lazuli

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_lapis",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 7,
		clust_size     = 4,
		y_min          = -50,
		y_max          = -46,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_lapis",
		wherein        = "default:stone",
		clust_scarcity = 10000,
		clust_num_ores = 5,
		clust_size     = 4,
		y_min          = -59,
		y_max          = -50,
	})

	-- Glowstone

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:glowstone",
		wherein        = "default:stone",
		clust_scarcity = 50000,
		clust_num_ores = 10,
		clust_size     = 5,
		y_min          = -59,
		y_max          = -0,
	})
end


--
-- Register biomes
--

-- All mapgens except mgv6

function default.register_biomes()

	-- Icesheet

	minetest.register_biome({
		name = "icesheet",
		node_dust = "default:snowblock",
		node_top = "default:snowblock",
		depth_top = 1,
		node_filler = "default:snowblock",
		depth_filler = 3,
		node_stone = "default:ice",
		node_water_top = "default:ice",
		depth_water_top = 10,
		node_river_water = "default:ice",
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = -8,
		heat_point = 0,
		humidity_point = 73,
	})
	
	minetest.register_biome({
		name = "icesheet_ocean",
		node_dust = "default:snowblock",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_water_top = "default:ice",
		depth_water_top = 10,
		y_max = -9,
		y_min = -64,
		heat_point = 0,
		humidity_point = 73,
	})

	-- Tundra

	minetest.register_biome({
		name = "tundra_highland",
		node_dust = "default:snow",
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 47,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_max = 46,
		y_min = 2,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_beach",
		node_top = "default:gravel",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 2,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_max = 1,
		y_min = -3,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_max = -4,
		y_min = -64,
		heat_point = 0,
		humidity_point = 40,
	})

	-- Taiga

	minetest.register_biome({
		name = "taiga",
		node_dust = "default:snow",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 4,
		heat_point = 25,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "taiga_ocean",
		node_dust = "default:snow",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 3,
		y_min = -60,
		heat_point = 25,
		humidity_point = 70,
	})

	-- Snowy grassland

	minetest.register_biome({
		name = "snowy_grassland",
		node_dust = "default:snow",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 4,
		heat_point = 20,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "snowy_grassland_ocean",
		node_dust = "default:snow",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 3,
		y_min = -64,
		heat_point = 20,
		humidity_point = 35,
	})

	-- Grassland

	minetest.register_biome({
		name = "grassland",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 6,
		heat_point = 50,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "grassland_dunes",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 2,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 5,
		y_min = 4,
		heat_point = 50,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "grassland_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 3,
		y_min = -64,
		heat_point = 50,
		humidity_point = 35,
	})
	-- Coniferous forest

	minetest.register_biome({
		name = "coniferous_forest",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 6,
		heat_point = 45,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "coniferous_forest_dunes",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 5,
		y_min = 4,
		heat_point = 45,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "coniferous_forest_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 3,
		y_min = -64,
		heat_point = 45,
		humidity_point = 70,
	})

	-- Deciduous forest

	minetest.register_biome({
		name = "deciduous_forest",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 1,
		heat_point = 60,
		humidity_point = 68,
	})

	minetest.register_biome({
		name = "deciduous_forest_shore",
		node_top = "default:dirt",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 0,
		y_min = -1,
		heat_point = 60,
		humidity_point = 68,
	})

	minetest.register_biome({
		name = "deciduous_forest_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = -2,
		y_min = -64,
		heat_point = 60,
		humidity_point = 68,
	})

	-- Desert

	minetest.register_biome({
		name = "desert",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 1,
		node_stone = "default:sandstone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 4,
		heat_point = 92,
		humidity_point = 16,
	})

	minetest.register_biome({
		name = "desert_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "default:redsandstone",
		node_riverbed = "default:redsand",
		depth_riverbed = 2,
		y_max = 3,
		y_min = -64,
		heat_point = 92,
		humidity_point = 16,
	})
	
	-- Sandstone desert

	minetest.register_biome({
		name = "sandstone_desert",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 1,
		node_stone = "default:sandstone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 4,
		heat_point = 60,
		humidity_point = 0,
	})

	minetest.register_biome({
		name = "sandstone_desert_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "default:sandstone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 3,
		y_min = -64,
		heat_point = 60,
		humidity_point = 0,
	})

	-- Savanna

	minetest.register_biome({
		name = "savanna",
		node_top = "default:dirt_with_dry_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 1,
		heat_point = 89,
		humidity_point = 42,
	})

	minetest.register_biome({
		name = "savanna_shore",
		node_top = "default:dirt",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 0,
		y_min = -1,
		heat_point = 89,
		humidity_point = 42,
	})

	minetest.register_biome({
		name = "savanna_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,

		y_max = -2,
		y_min = -255,
		heat_point = 89,
		humidity_point = 42,
	})


	-- Rainforest

	minetest.register_biome({
		name = "rainforest",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 1,
		heat_point = 86,
		humidity_point = 65,
	})

	minetest.register_biome({
		name = "rainforest_swamp",
		node_top = "default:dirt",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = 0,
		y_min = -1,
		heat_point = 86,
		humidity_point = 65,
	})

	minetest.register_biome({
		name = "rainforest_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		y_max = -2,
		y_min = -255,
		heat_point = 86,
		humidity_point = 65,
	})

	-- Underground

	minetest.register_biome({
		name = "underground",
		--node_dust = "",
		--node_top = "",
		--depth_top = ,
		--node_filler = "",
		--depth_filler = ,
		--node_stone = "",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "",
		y_min = -31000,
		y_max = -113,
		heat_point = 50,
		humidity_point = 50,
	})
end


--
-- Register decorations
--

-- Mgv6

function default.register_mgv6_decorations()

	-- Bonusbox chest

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:sand", "default:dirt_with_snow", "default:gravel",
 			"default:snowblock", "default:dirt_with_grass", "default:redsand",
			"default:redsandstone"},
		sidelen = 80,
		fill_ratio = 0.0002,
		y_min = 1,
		y_max = 31000,
		decoration = {"bonusbox:chest"},
	})

	-- Sugar Cane

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 100, y = 100, z = 100},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		y_max = 1,
		y_min = 1,
		decoration = "default:sugarcane",
		height = 2,
		height_max = 4,
		spawn_by = "default:water_source",
		num_spawn_by = 1,
	})

	-- Cacti

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:redsand"},
		sidelen = 16,
		noise_params = {
			offset = -0.012,
			scale = 0.024,
			spread = {x = 100, y = 100, z = 100},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "default:cactus",
		height = 3,
		height_max = 4,
	})

	-- Long grasses

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		fill_ratio = 0.05,
		y_max = 30,
		y_min = 1,
		decoration = "default:grass",
	})

	-- Dry shrubs

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:redsand", "default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.035,
			spread = {x = 100, y = 100, z = 100},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "default:dry_shrub",
		param2 = 4,
	})
end



function default.register_decorations()

	-- Apple tree and log

	minetest.register_decoration({
		name = "default:apple_tree",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/apple_tree.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	minetest.register_decoration({
		name = "default:apple_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.0012,
			scale = 0.0007,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/apple_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dirt_with_grass",
		num_spawn_by = 8,
	})

	-- Emergent jungle tree
	-- Due to 32 node height, altitude is limited and prescence depends on chunksize

--[[	local chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))
	if chunksize >= 5 then
		minetest.register_decoration({
			name = "default:emergent_jungle_tree",
			deco_type = "schematic",
--			place_on = {"default:dirt_with_rainforest_litter"},
			place_on = {"default:dirt_with_grass", "default:dirt"},
			sidelen = 80,
			noise_params = {
				offset = 0.0,
				scale = 0.0025,
				spread = {x = 250, y = 250, z = 250},
				seed = 2685,
				octaves = 3,
				persist = 0.7
			},
			biomes = {"rainforest"},
			y_max = 32,
			y_min = 1,
			schematic = minetest.get_modpath("default") ..
					"/schematics/emergent_jungle_tree.mts",
			flags = "place_center_x, place_center_z",
			rotation = "random",
			place_offset_y = -4,
		})
	end]]

	-- Jungle tree and log

	minetest.register_decoration({
		name = "default:jungle_tree",
		deco_type = "schematic",
--		place_on = {"default:dirt_with_rainforest_litter", "default:dirt"},
		place_on = {"default:dirt_with_grass", "default:dirt"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"rainforest", "rainforest_swamp"},
		y_max = 31000,
		y_min = -1,
		schematic = minetest.get_modpath("default") .. "/schematics/jungle_tree.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	minetest.register_decoration({
		name = "default:jungle_log",
		deco_type = "schematic",
--		place_on = {"default:dirt_with_rainforest_litter"},
		place_on = {"default:dirt_with_grass", "default:dirt"},
		sidelen = 80,
		fill_ratio = 0.005,
		biomes = {"rainforest", "rainforest_swamp"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/jungle_log.mts",
		flags = "place_center_x",
		rotation = "random",
--		spawn_by = "default:dirt_with_rainforest_litter",
--		num_spawn_by = 8,
	})

	-- Taiga and temperate coniferous forest pine tree, small pine tree and log

	minetest.register_decoration({
		name = "default:pine_tree",
		deco_type = "schematic",
--		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		place_on = {"default:dirt_with_snow", "default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_tree.mts",
		flags = "place_center_x, place_center_z",
	})

	minetest.register_decoration({
		name = "default:small_pine_tree",
		deco_type = "schematic",
--		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		place_on = {"default:dirt_with_snow", "default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = -0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/small_pine_tree.mts",
		flags = "place_center_x, place_center_z",
	})

	minetest.register_decoration({
		name = "default:pine_log",
		deco_type = "schematic",
--		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		place_on = {"default:dirt_with_snow", "default:dirt_with_grass"},
		sidelen = 80,
		fill_ratio = 0.0018,
		biomes = {"taiga", "coniferous_forest", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_log.mts",
		flags = "place_center_x",
		rotation = "random",
--		spawn_by = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		spawn_by = {"default:dirt_with_snow", "default:dirt_with_grass"},
		num_spawn_by = 8,
	})

	-- Acacia tree and log

	minetest.register_decoration({
		name = "default:acacia_tree",
		deco_type = "schematic",
		place_on = {"default:dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.002,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/acacia_tree.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	minetest.register_decoration({
		name = "default:acacia_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.001,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/acacia_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dirt_with_dry_grass",
--		num_spawn_by = 8,
	})

	-- Large cactus

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:redsand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default").."/schematics/large_cactus.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	-- Cactus

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:redsand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert"},
		y_max = 31000,
		y_min = 4,
		decoration = "default:cactus",
		height = 2,
		height_max = 5,
	})

	-- Papyrus

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		biomes = {"savanna_swamp"},
		y_min = 0,
		y_max = 0,
		schematic = minetest.get_modpath("default").."/schematics/papyrus.mts",
--		spawn_by = "default:dirt_with_rainforest_litter",
--		num_spawn_by = 8,
	})

	-- Bonusbox chest

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:sand", "default:dirt_with_snow", "default:gravel",
 			"default:snowblock", "default:dirt_with_grass", "default:redsand",
			"default:redsandstone", "default:dirt_with_dry_grass"},
		sidelen = 80,
		fill_ratio = 0.0002,
		y_min = 1,
		y_max = 31000,
		decoration = {"bonusbox:chest"},
	})

	-- Grasses

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "default:sand"},
		sidelen = 16,
		noise_params = {
			offset = 0.15,
			scale = 0.15,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"grassland", "deciduous_forest", "floatland_grassland", "stone_grassland", "sandstone_grassland",
			"deciduous_forest", "coniferous_forest",
			"stone_grassland_dunes", "sandstone_grassland_dunes",
			"coniferous_forest_dunes"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:grass",
	})

	-- Dry grasses

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.15,
			scale = 0.15,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:dry_grass",
	})

	-- Junglegrass

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"rainforest"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:junglegrass",
	})

	-- Dry shrub

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:redsand", "default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.02,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert", "tundra"},
		y_max = 31000,
		y_min = 2,
		decoration = "default:dry_shrub",
	})
end


--
-- Detect mapgen, flags and parameters to select functions
--

-- Get setting or default
local mgv7_spflags = minetest.get_mapgen_setting("mgv7_spflags") or
	"mountains, ridges, nofloatlands, caverns"
local captures_float = string.match(mgv7_spflags, "floatlands")
local captures_nofloat = string.match(mgv7_spflags, "nofloatlands")

-- Get setting or default
-- Make global for mods to use to register floatland biomes
default.mgv7_floatland_level =
	minetest.get_mapgen_setting("mgv7_floatland_level") or 1280
default.mgv7_shadow_limit =
	minetest.get_mapgen_setting("mgv7_shadow_limit") or 1024

minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()

local mg_name = minetest.get_mapgen_setting("mg_name")

if mg_name == "v6" then
	default.register_bedrock()
	default.register_ores()
	default.register_mgv6_decorations()
-- Need to check for 'nofloatlands' because that contains
-- 'floatlands' which makes the second condition true.
elseif mg_name == "v7" and
	captures_float == "floatlands" and
	captures_nofloat ~= "nofloatlands" then
	-- Mgv7 with floatlands and floatland biomes
	default.register_biomes(default.mgv7_shadow_limit - 1)
	default.register_floatland_biomes(
		default.mgv7_floatland_level, default.mgv7_shadow_limit)
	default.register_ores()
	default.register_decorations()
else
	default.register_biomes()
	default.register_ores()
	default.register_decorations()
end
