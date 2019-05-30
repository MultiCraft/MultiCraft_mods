--
-- Mgv6
--

local function register_mgv6_flower(flower_name)
	minetest.register_decoration({
		name = "flowers:"..flower_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 100, y = 100, z = 100},
			seed = 436,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "flowers:"..flower_name,
	})
end

local function register_mgv6_mushroom(mushroom_name)
	minetest.register_decoration({
		name = "flowers:"..mushroom_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.04,
			spread = {x = 100, y = 100, z = 100},
			seed = 7133,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "flowers:"..mushroom_name,
		spawn_by = "default:tree",
		num_spawn_by = 1,
	})
end

local function register_mgv6_waterlily()
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.1,
			spread = {x = 100, y = 100, z = 100},
			seed = 48,
			octaves = 3,
			persist = 0.7
		},
		y_min = 0,
		y_max = 0,
		schematic = minetest.get_modpath("flowers") .. "/schematics/waterlily.mts",
		rotation = "random",
	})
end

function flowers.register_mgv6_decorations()
	register_mgv6_flower("rose")
	register_mgv6_flower("tulip")
	register_mgv6_flower("dandelion_yellow")
	register_mgv6_flower("orchid")
	register_mgv6_flower("allium")
	register_mgv6_flower("dandelion_white")

	register_mgv6_mushroom("mushroom_brown")
	register_mgv6_mushroom("mushroom_red")

	register_mgv6_waterlily()
end


--
-- All other biome API mapgens
--

local function register_flower(seed, flower_name)
	minetest.register_decoration({
		name = "flowers:"..flower_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.04,
			spread = {x = 100, y = 100, z = 100},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"stone_grassland", "sandstone_grassland",
			"deciduous_forest", "coniferous_forest", "floatland_grassland", "floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 1,
		decoration = "flowers:"..flower_name,
	})
end

local function register_mushroom(mushroom_name)
	minetest.register_decoration({
		name = "flowers:"..mushroom_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest", "coniferous_forest",
			"floatland_coniferous_forest"},
		y_max = 31000,
		y_min = 1,
		decoration = "flowers:"..mushroom_name,
	})
end

local function register_waterlily()
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.1,
			spread = {x = 100, y = 100, z = 100},
			seed = 48,
			octaves = 3,
			persist = 0.7
		},
		y_min = 0,
		y_max = 0,
		schematic = minetest.get_modpath("flowers") .. "/schematics/waterlily.mts",
		rotation = "random",
	})
end

function flowers.register_decorations()
	register_flower(436,	 "rose")
	register_flower(19822,	 "tulip")
	register_flower(1220999, "dandelion_yellow")
	register_flower(36662,	 "orchid")
	register_flower(1133,	 "allium")
	register_flower(73133,	 "dandelion_white")

	register_mushroom("mushroom_brown")
	register_mushroom("mushroom_red")

	register_waterlily()
end


--
-- Detect mapgen to select functions
--

local mg_name = minetest.get_mapgen_setting("mg_name")
if mg_name == "v6" then
	flowers.register_mgv6_decorations()
else
	flowers.register_decorations()
end
