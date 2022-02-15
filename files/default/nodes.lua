local S = default.S
local C = default.colors

-- Required wrapper to allow customization of default.after_place_leaves
local function after_place_leaves(...)
	return default.after_place_leaves(...)
end

 -- Required wrapper to allow customization of default.grow_sapling
local function grow_sapling(...)
	return default.grow_sapling(...)
end

local random = math.random

--
-- Stone
--

minetest.register_node("default:stone", {
	description = S("Stone"),
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:cobble",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:cobble", {
	description = S("Cobblestone"),
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrick", {
	description = S("Stone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:mossycobble", {
	description = S("Mossy Cobblestone"),
	tiles = {"default_mossycobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrickcarved", {
	description = S("Stone Brick Carved"),
	tiles = {"default_stonebrick_carved.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrickcracked", {
	description = S("Stone Brick Cracked"),
	tiles = {"default_stonebrick_cracked.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrickmossy", {
	description = S("Mossy Stone Brick"),
	tiles = {"default_stonebrick_mossy.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:sandstone", {
	description = S("Sandstone"),
	tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png",
		"default_sandstone_normal.png"},
	groups = {crumbly = 1, cracky = 3},
	sounds = default.node_sound_dirt_defaults({
		dig = {name = "default_dig_cracky", gain = 0.24}
	})
})

minetest.register_node("default:sandstonesmooth", {
	description = S("Smooth Sandstone"),
	tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png",
		"default_sandstone_smooth.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_dirt_defaults({
		dig = {name = "default_dig_cracky", gain = 0.24}
	})
})

minetest.register_node("default:sandstonecarved", {
	description = S("Carved Sandstone"),
	tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png",
		"default_sandstone_carved.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_dirt_defaults({
		dig = {name = "default_dig_cracky", gain = 0.24}
	})
})

minetest.register_node("default:redsandstone", {
	description = S("Red Sandstone"),
	tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png",
		"default_redsandstone_normal.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_dirt_defaults({
		dig = {name = "default_dig_cracky", gain = 0.24}
	})
})

minetest.register_node("default:redsandstonesmooth", {
	description = S("Red Sandstone Smooth"),
	tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png",
		"default_redsandstone_smooth.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_dirt_defaults({
		dig = {name = "default_dig_cracky", gain = 0.24}
	})
})

minetest.register_node("default:redsandstonecarved", {
	description = S("Red Carved Sandstone"),
	tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png",
		"default_redsandstone_carved.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_dirt_defaults({
		dig = {name = "default_dig_cracky", gain = 0.24}
	})
})

minetest.register_node("default:obsidian", {
	description = S("Obsidian"),
	tiles = {"default_obsidian.png"},
	groups = {cracky = 1, level = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:bedrock", {
	description = S("Bedrock"),
	tiles = {"default_bedrock.png"},
	groups = {oddly_breakable_by_hand = 5, speed = -30,
		not_in_creative_inventory = 1},
	drop = "",
	sounds = default.node_sound_stone_defaults()
})

--
-- Soft / Non-Stone
--

minetest.register_node("default:dirt", {
	description = S("Dirt"),
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:bone"}, rarity = 30},
			{items = {"default:dirt"}}
		}
	},
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_node("default:dirt_with_grass", {
	description = S("Dirt with Grass"),
	tiles = {"default_grass.png", "default_dirt.png", "default_grass_side.png"},
	wield_cube = "default_dirt.png",
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25}
	})
})

minetest.register_node("default:dirt_with_dry_grass", {
	description = S("Dirt with Dry Grass"),
	tiles = {"default_dry_grass.png", "default_dirt.png",
		"default_dry_grass_side.png"},
	wield_cube = "default_dirt.png",
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.4}
	})
})

minetest.register_node("default:dirt_with_snow", {
	description = S("Dirt with Snow"),
	tiles = {"default_snow.png", "default_dirt.png",
		"default_snow_side.png"},
	wield_cube = "default_dirt.png",
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, snowy = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.4}
	})
})

minetest.register_node("default:sand", {
	description = S("Sand"),
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults()
})

minetest.register_node("default:gravel", {
	description = S("Gravel"),
	tiles = {"default_gravel.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {"default:flint"}, rarity = 8},
			{items = {"default:gravel"}}
		}
	}
})

minetest.register_node("default:redsand", {
	description = S("Red Sand"),
	tiles = {"default_red_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults()
})

minetest.register_node("default:clay", {
	description = S("Clay"),
	tiles = {"default_clay.png"},
	groups = {crumbly = 3},
	drop = "default:clay_lump 4",
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_node("default:hardened_clay", {
	description = S("Hardened Clay"),
	tiles = {"default_hardened_clay.png"},
	is_ground_content = false,
	groups = {cracky = 3, hardened_clay = 1},
	sounds = default.node_sound_stone_defaults()
})


minetest.register_node("default:snow", {
	description = S("Snow"),
	tiles = {"default_snow.png"},
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	walkable = false,
	drawtype = "nodebox",
	stack_max = 16,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5}
	},
	groups = {crumbly = 3, falling_node = 1, snowy = 1, speed = -30,
		not_in_creative_inventory = 1},
	sounds = default.node_sound_snow_defaults(),
	drop = "default:snowball",

	on_construct = function(pos)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name == "default:dirt"
		or name == "default:dirt_with_grass"
		or name == "default:dirt_with_dry_grass" then
			minetest.swap_node(pos, {name = "default:dirt_with_snow"})
		end
	end
})

minetest.register_node("default:snowblock", {
	description = S("Snow Block"),
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, cools_lava = 1, snowy = 1, speed = -30},
	sounds = default.node_sound_snow_defaults(),
	drop = "default:snowball 4",

	on_construct = function(pos)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name == "default:dirt"
		or name == "default:dirt_with_grass"
		or name == "default:dirt_with_dry_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end
})

minetest.register_node("default:ice", {
	description = S("Ice"),
	drawtype = "glasslike",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	use_texture_alpha = "blend",
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("default:packedice", {
	description = S("Packed Ice"),
	drawtype = "glasslike",
	tiles = {"default_ice_packed.png"},
	paramtype = "light",
	use_texture_alpha = "blend",
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults()
})

--
-- Trees
--

minetest.register_node("default:tree", {
	description = S("Apple Tree"),
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:wood", {
	description = S("Apple Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:sapling", {
	description = S("Apple Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end
})

minetest.register_node("default:leaves", {
	description = S("Apple Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 12},
			{items = {"default:leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:apple", {
	description = S("Red Apple"),
	drawtype = "plantlike",
	visual_scale = 0.75,
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3/16, -0.5, -3/16, 3/16, 1/4, 3/16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, apple = 1, food = 1},
	on_use = minetest.item_eat(3),
	sounds = default.node_sound_leaves_defaults()
})

minetest.register_node("default:apple_green", {
	description = S("Green Apple"),
	drawtype = "plantlike",
	visual_scale = 0.75,
	tiles = {"default_apple_green.png"},
	inventory_image = "default_apple_green.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3/16, -0.5, -3/16, 3/16, 1/4, 3/16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, apple = 1, food = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults()
})

minetest.register_node("default:apple_gold", {
	description = S("Golden Apple"),
	drawtype = "plantlike",
	visual_scale = 0.75,
	tiles = {"default_apple_gold.png"},
	inventory_image = "default_apple_gold.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3/16, -0.5, -3/16, 3/16, 1/4, 3/16}
	},
	groups = {fleshy = 3, dig_immediate = 1, flammable = 2, cracky = 2,
		food = 1},
	on_use = minetest.item_eat(10),
	sounds = default.node_sound_stone_defaults()
})


minetest.register_node("default:jungletree", {
	description = S("Jungle Tree"),
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png",
		"default_jungletree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:junglewood", {
	description = S("Jungle Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:jungleleaves", {
	description = S("Jungle Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_jungleleaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:junglesapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 12},
			{items = {"default:jungleleaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:junglesapling", {
	description = S("Jungle Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_junglesapling.png"},
	inventory_image = "default_junglesapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.4, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:junglesapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 15, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end
})


minetest.register_node("default:pine_tree", {
	description = S("Pine Tree"),
	tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
		"default_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:pine_wood", {
	description = S("Pine Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:pine_needles",{
	description = S("Pine Needles"),
	drawtype = "allfaces_optional",
	tiles = {"default_pine_needles.png"},
	use_texture_alpha = "clip",
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:pine_sapling", {
	description = S("Pine Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_pine_sapling.png"},
	inventory_image = "default_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:pine_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 14, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end
})


minetest.register_node("default:acacia_tree", {
	description = S("Acacia Tree"),
	tiles = {"default_acacia_tree_top.png", "default_acacia_tree_top.png",
		"default_acacia_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:acacia_wood", {
	description = S("Acacia Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_acacia_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:acacia_leaves", {
	description = S("Acacia Tree Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"default_acacia_leaves.png"},
	use_texture_alpha = "clip",
	waving = 1,
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:acacia_sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 12},
			{items = {"default:acacia_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:acacia_sapling", {
	description = S("Acacia Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_acacia_sapling.png"},
	inventory_image = "default_acacia_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:acacia_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -4, y = 1, z = -4},
			{x = 4, y = 7, z = 4},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end
})

minetest.register_node("default:birch_tree", {
	description = S("Birch Tree"),
	tiles = {"default_birch_tree_top.png", "default_birch_tree_top.png",
		"default_birch_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:birch_wood", {
	description = S("Birch Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_birch_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:birch_leaves", {
	description = S("Birch Tree Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"default_birch_leaves.png"},
	use_texture_alpha = "clip",
	waving = 1,
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:birch_sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 12},
			{items = {"default:birch_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:birch_sapling", {
	description = S("Birch Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_birch_sapling.png"},
	inventory_image = "default_birch_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 5 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:birch_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 12, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end
})

minetest.register_node("default:cherry_blossom_tree", {
	description = S("Cherry Blossom Tree"),
	tiles = {"default_cherry_blossom_tree_top.png",
		"default_cherry_blossom_tree_top.png", "default_cherry_blossom_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:cherry_blossom_wood", {
	description = S("Cherry Blossom Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_cherry_blossom_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:cherry_blossom_sapling", {
	description = S("Cherry Blossom Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_cherry_blossom_sapling.png"},
	inventory_image = "default_cherry_blossom_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:cherry_blossom_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end
})

minetest.register_node("default:cherry_blossom_leaves", {
	description = S("Cherry Blossom Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_cherry_blossom_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:cherry_blossom_sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 12},
			{items = {"default:cherry_blossom_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

--
-- Ores
--

minetest.register_node("default:stone_with_coal", {
	description = S("Coal Ore"),
	tiles = {"default_stone.png^default_mineral_coal.png"},
	groups = {cracky = 3, not_cuttable = 1},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:coalblock", {
	description = S("Coal Block"),
	tiles = {"default_coal_block.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_iron", {
	description = S("Iron Ore"),
	tiles = {"default_stone.png^default_mineral_iron.png"},
	groups = {cracky = 2, not_cuttable = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:steelblock", {
	description = S("Steel Block"),
	tiles = {"default_steel_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_bluestone", {
	description = S("Bluestone Ore"),
	tiles = {"default_stone.png^default_mineral_bluestone.png"},
	groups = {cracky = 2, not_cuttable = 1},
	drop = "mesecons:wire_00000000_off 8",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_gold", {
	description = S("Gold Ore"),
	tiles = {"default_stone.png^default_mineral_gold.png"},
	groups = {cracky = 2, not_cuttable = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:goldblock", {
	description = S("Gold Block"),
	tiles = {"default_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_emerald", {
	description = C.emerald .. S("Emerald Ore"),
	tiles = {"default_stone.png^default_mineral_emerald.png"},
	groups = {cracky = 2, not_cuttable = 1},
	drop = "default:emerald",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:emeraldblock", {
	description = C.emerald .. S("Emerald Block"),
	tiles = {"default_emerald_block.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:rubyblock", {
	description = C.ruby .. S("Ruby Block"),
	tiles = {"default_ruby_block.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_diamond", {
	description = S("Diamonds in Stone"),
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	groups = {cracky = 1, not_cuttable = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:diamondblock", {
	description = S("Diamond Block"),
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults()
})

--
-- Plantlife (non-cubic)
--

minetest.register_node("default:cactus", {
	description = S("Cactus"),
	drawtype = "nodebox",
	tiles = {"default_cactus_top.png", "default_cactus_bottom.png",
		"default_cactus_side.png"},
	wield_cube = "[combine:56x56:-4,-4=default_cactus_top.png",
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 3, flammable = 2, attached_node = 1, flora = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	node_box = {
		type = "fixed",
		fixed = {
			{-7/16, -8/16, -7/16,  7/16, 8/16,  7/16}, -- Main Body
			{-8/17, -8/16, -7/16,  8/16, 8/16, -7/16}, -- Spikes
			{-8/17, -8/16,  7/16,  8/16, 8/16,  7/16}, -- Spikes
			{-7/16, -8/16, -8/17, -7/16, 8/16,  8/16}, -- Spikes
			{ 7/16, -8/16,  8/16,  7/16, 8/16, -8/17}  -- Spikes
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -8/16, -7/16, 7/16, 8/16, 7/16}
	},

	mesecon = {
		on_mvps_move = function(pos, _, oldpos)
			local check_pos = {x = oldpos.x, y = oldpos.y + 1, z = oldpos.z}
			local oldnode = minetest.get_node(check_pos)
			local height = 1
			local drop = false
			while oldnode.name == "default:cactus" do
				local new_pos = {x = pos.x, y = pos.y + height, z = pos.z}
				minetest.remove_node(check_pos)
				if drop or minetest.get_node(new_pos).name ~= "air" then
					minetest.add_item(check_pos, "default:cactus")
					drop = true
				else
					minetest.add_node(new_pos, {name = "default:cactus"})
				end
				height = height + 1
				check_pos.y = check_pos.y + 1
				oldnode = minetest.get_node(check_pos)
			end
		end
	}
})

minetest.register_node("default:sugarcane", {
	description = S("Sugarcane"),
	drawtype = "plantlike",
	tiles = {"default_sugarcane.png"},
	inventory_image = "default_sugarcane_inv.png",
	wield_image = "default_sugarcane_inv.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.5, -0.31, 0.31, 0.5, 0.31}
	},
	groups = {snappy = 3, flammable = 2, wieldview = 2},
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = function(pos, node, _, digger)
		default.dig_up(pos, node, digger)
	end
})

minetest.register_node("default:dry_shrub", {
	description = S("Dry Shrub"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_shrub.png"},
	inventory_image = "default_dry_shrub.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 4,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/3, -0.5, -1/3, 1/3, 1/3, 1/3}
	}
})

minetest.register_node("default:junglegrass", {
	description = S("Jungle Grass"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.25,
	tiles = {"default_junglegrass.png"},
	inventory_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1,
		junglegrass = 1, flammable = 1, dig_immediate = 2},
	sounds = default.node_sound_leaves_defaults({
		dig = {name = "default_dig_snappy", gain = 0.5}
	}),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 12 / 16, 0.5}
	}
})

-- Grass

local function grass_place(itemstack, placer, pointed_thing)
	-- place a random grass node
	local stack = ItemStack("default:grass_" .. random(1, 5))
	local ret = minetest.item_place(stack, placer, pointed_thing)
	return ItemStack("default:grass_1 " ..
		itemstack:get_count() - (1 - ret:get_count()))
end

minetest.register_node("default:grass_1", {
	description = S("Grass"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_grass_1.png"},
	-- Use texture of a taller grass stage in inventory
	inventory_image = "default_grass_4.png",
	wield_image = "default_grass_4.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1,
		normal_grass = 1, flammable = 1, dig_immediate = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16}
	},

	on_place = grass_place
})

for i = 2, 5 do
	minetest.register_node("default:grass_" .. i, {
		description = S("Grass"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_grass_" .. i .. ".png"},
		inventory_image = "default_grass_" .. i .. ".png",
		wield_image = "default_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drop = "default:grass_1",
		groups = {snappy = 3, flora = 1, attached_node = 1,
			not_in_creative_inventory = 1, grass = 1,
			normal_grass = 1, flammable = 1, dig_immediate = 3},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, (-1 / 16 + i / 12), 6 / 16}
		}
	})
end

-- Compatiability Grass node
minetest.register_node("default:grass", {
	description = S("Grass"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_grass_4.png"},
	inventory_image = "default_grass_4.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "default:grass_1",
	groups = {snappy = 3, flora = 1, attached_node = 1,
		not_in_creative_inventory = 1, grass = 1,
		normal_grass = 1, flammable = 1, dig_immediate = 3},
	sounds = default.node_sound_leaves_defaults(),

	on_place = grass_place
})

-- Dry Grass

local function dry_grass_place(itemstack, placer, pointed_thing)
	-- place a random dry grass node
	local stack = ItemStack("default:dry_grass_" .. random(1, 5))
	local ret = minetest.item_place(stack, placer, pointed_thing)
	return ItemStack("default:dry_grass_1 " ..
		itemstack:get_count() - (1 - ret:get_count()))
end

minetest.register_node("default:dry_grass_1", {
	description = S("Dry Grass"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_grass_1.png"},
	inventory_image = "default_dry_grass_4.png",
	wield_image = "default_dry_grass_4.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, flora = 1,
		attached_node = 1, grass = 1, dry_grass = 1, dig_immediate = 2},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -3 / 16, 6 / 16}
	},

	on_place = dry_grass_place
})

for i = 2, 5 do
	minetest.register_node("default:dry_grass_" .. i, {
		description = S("Dry Grass"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_dry_grass_" .. i .. ".png"},
		inventory_image = "default_dry_grass_" .. i .. ".png",
		wield_image = "default_dry_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1,
			not_in_creative_inventory = 1, grass = 1, dry_grass = 1, dig_immediate = 2},
		drop = "default:dry_grass_1",
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, (-1 / 16 + i / 12), 6 / 16}
		}
	})
end

-- Compatiability Dry Grass node
minetest.register_node("default:dry_grass", {
	description = S("Dry Grass"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_grass_4.png"},
	inventory_image = "default_dry_grass_4.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1,
		not_in_creative_inventory = 1, grass = 1, dry_grass = 1, dig_immediate = 2},
	sounds = default.node_sound_leaves_defaults(),

	on_place = dry_grass_place
})

minetest.register_node("default:fern_1", {
	description = S("Fern"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_fern_1.png"},
	inventory_image = "default_fern_3.png",
	wield_image = "default_fern_3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, flora = 1, grass = 1,
		fern = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -0.15, 4 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		-- place a random fern node
		local stack = ItemStack("default:fern_" .. random(1, 3))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("default:fern_1 " ..
			itemstack:get_count() - (1 - ret:get_count()))
	end
})

for i = 2, 3 do
	minetest.register_node("default:fern_" .. i, {
		description = S("Fern"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_fern_" .. i .. ".png"},
		inventory_image = "default_fern_" .. i .. ".png",
		wield_image = "default_fern_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1,
			grass = 1, fern = 1, not_in_creative_inventory = 1},
		drop = "default:fern_1",
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {(-4 / 16 - i / 32), -0.5, (-4 / 16 - i / 32),
				(4 / 16 + i / 32), (-3 / 16 + i / 6), (4 / 16 + i / 32)}
		}
	})
end

minetest.register_node("default:bush_stem", {
	description = S("Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"default_bush_stem.png"},
	inventory_image = "default_bush_stem.png",
	wield_image = "default_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, bush_stem = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16}
	}
})

minetest.register_node("default:bush_leaves", {
	description = S("Bush Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_bush_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:bush_sapling"}, rarity = 5},
			{items = {"default:bush_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:bush_sapling", {
	description = S("Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"default_bush_sapling.png"},
	inventory_image = "default_bush_sapling.png",
	wield_image = "default_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:bush_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end
})

minetest.register_node("default:blueberry_bush_stem", {
	description = S("Blueberry Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"default_blueberry_bush_stem.png"},
	inventory_image = "default_blueberry_bush_stem.png",
	wield_image = "default_blueberry_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, bush_stem = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16}
	}
})

minetest.register_node("default:blueberry_bush_leaves_with_berries", {
	description = S("Blueberry Bush Leaves with Berries"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_blueberry_bush_leaves.png^default_blueberry_overlay.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3, flammable = 2, leaves = 1, dig_immediate = 2, speed = -20},
	drop = "default:blueberries",
	sounds = default.node_sound_leaves_defaults({
		dig = {name = "default_dig_snappy", gain = 0.5}
	}),
	node_dig_prediction = "default:blueberry_bush_leaves",

	on_punch = function(pos)
		minetest.after(0.1, function()
			minetest.set_node(pos, {name = "default:blueberry_bush_leaves"})
			minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z},
				"default:blueberries")
			minetest.get_node_timer(pos):start(random(300, 1500))
		end)
	end
})

minetest.register_node("default:blueberry_bush_leaves", {
	description = S("Blueberry Bush Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_blueberry_bush_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:blueberry_bush_sapling"}, rarity = 5},
			{items = {"default:blueberry_bush_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	on_timer = function(pos)
		if minetest.get_node_light(pos) < 12 then
			minetest.get_node_timer(pos):start(200)
		else
			minetest.set_node(pos, {name = "default:blueberry_bush_leaves_with_berries"})
		end
	end,

	after_place_node = after_place_leaves
})

minetest.register_node("default:blueberry_bush_sapling", {
	description = S("Blueberry Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"default_blueberry_bush_sapling.png"},
	inventory_image = "default_blueberry_bush_sapling.png",
	wield_image = "default_blueberry_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:blueberry_bush_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end
})

minetest.register_node("default:acacia_bush_stem", {
	description = S("Acacia Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"default_acacia_bush_stem.png"},
	inventory_image = "default_acacia_bush_stem.png",
	wield_image = "default_acacia_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, bush_stem = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16}
	}
})

minetest.register_node("default:acacia_bush_leaves", {
	description = S("Acacia Bush Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_acacia_bush_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:acacia_bush_sapling"}, rarity = 5},
			{items = {"default:acacia_bush_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:acacia_bush_sapling", {
	description = S("Acacia Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"default_acacia_bush_sapling.png"},
	inventory_image = "default_acacia_bush_sapling.png",
	wield_image = "default_acacia_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:acacia_bush_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end
})

minetest.register_node("default:pine_bush_stem", {
	description = S("Pine Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"default_pine_bush_stem.png"},
	inventory_image = "default_pine_bush_stem.png",
	wield_image = "default_pine_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, bush_stem = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16}
	}
})

minetest.register_node("default:pine_bush_needles", {
	description = S("Pine Bush Needles"),
	drawtype = "allfaces_optional",
	tiles = {"default_pine_needles.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_bush_sapling"}, rarity = 5},
			{items = {"default:pine_bush_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:pine_bush_sapling", {
	description = S("Pine Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"default_pine_bush_sapling.png"},
	inventory_image = "default_pine_bush_sapling.png",
	wield_image = "default_pine_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 2 / 16, 3 / 16}
	},
	groups = {snappy = 2, dig_immediate = 2, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:pine_bush_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end
})

--
-- Liquids
--

local is_sp = minetest.is_singleplayer()
local function liquid_place(itemstack, placer, pointed_thing)
	if pointed_thing.type == "node" then
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local node_def = minetest.registered_nodes[node.name]
		if node_def and node_def.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return node_def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local player_name = placer and placer:get_player_name() or ""
		if is_sp or
				minetest.check_player_privs(player_name, {server = true}) then
			local result
			itemstack, result = minetest.item_place(itemstack,
					placer, pointed_thing)

			if result then
				minetest.sound_play({name = "default_place_node_hard"},
						{pos = pointed_thing.above})
			end
		end
	end

	return itemstack
end

-- Water
local water_source = {
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 2.0
			}
		},
		{
			name = "default_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 2.0
			}
		}
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 90, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1,
		not_in_creative_inventory = 1},
	sounds = default.node_sound_water_defaults(),
	node_placement_prediction = "",
	on_place = liquid_place
}

minetest.register_node("default:water_source", water_source)

-- Poured water source
local water_source_poured = table.copy(water_source)
water_source_poured.liquid_alternative_flowing = "default:water_flowing_poured"
water_source_poured.liquid_alternative_source = "default:water_source_poured"
water_source_poured.liquid_renewable = false
water_source_poured.liquid_range = 3
water_source_poured.groups.falling_node = 1
minetest.register_node("default:water_source_poured", water_source_poured)

local water_flowing = {
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 0.8
			}
		},
		{
			name = "default_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 0.8
			}
		}
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 90, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults()
}

minetest.register_node("default:water_flowing", water_flowing)

-- Poured water flowing
local water_flowing_poured = table.copy(water_flowing)
water_flowing_poured.liquid_alternative_flowing = "default:water_flowing_poured"
water_flowing_poured.liquid_alternative_source = "default:water_source_poured"
water_flowing_poured.liquid_renewable = false
water_flowing_poured.liquid_range = 3
minetest.register_node("default:water_flowing_poured", water_flowing_poured)

-- River Water
local river_water_source = {
	drawtype = "liquid",
	tiles = {
		{
			name = "default_river_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 2.0
			}
		},
		{
			name = "default_river_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 2.0
			}
		}
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:river_water_flowing",
	liquid_alternative_source = "default:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 90, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1,
		not_in_creative_inventory = 1},
	sounds = default.node_sound_water_defaults(),
	node_placement_prediction = "",
	on_place = liquid_place
}

minetest.register_node("default:river_water_source", river_water_source)

-- Poured river water source
local river_water_source_poured = table.copy(river_water_source)
river_water_source_poured.liquid_alternative_flowing = "default:river_water_flowing_poured"
river_water_source_poured.liquid_alternative_source = "default:river_water_source_poured"
minetest.register_node("default:river_water_source_poured", river_water_source_poured)

local river_water_flowing = {
	drawtype = "flowingliquid",
	tiles = {"default_river_water.png"},
	special_tiles = {
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 0.8
			}
		},
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 0.8
			}
		}
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:river_water_flowing",
	liquid_alternative_source = "default:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 90, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults()
}
minetest.register_node("default:river_water_flowing", river_water_flowing)

-- Poured river water flowing
local river_water_flowing_poured = table.copy(river_water_flowing)
river_water_flowing_poured.liquid_alternative_flowing = "default:river_water_flowing_poured"
river_water_flowing_poured.liquid_alternative_source = "default:river_water_source_poured"
minetest.register_node("default:river_water_flowing_poured", river_water_flowing_poured)

-- Lava
minetest.register_node("default:lava_source", {
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 3.0
			}
		},
		{
			name = "default_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 3.0
			}
		}
	},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4,
	post_effect_color = {a = 180, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1},
	node_placement_prediction = "",
	on_place = liquid_place
})

minetest.register_node("default:lava_flowing", {
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 3.3
			}
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 3.3
			}
		}
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = minetest.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4,
	post_effect_color = {a = 180, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1}
})

--
-- Tools / "Advanced" crafting / Non-"natural"
--

local bookshelf_formspec =
	default.gui ..
	"item_image[0,-0.1;1,1;default:bookshelf]" ..
	"label[0.9,0.1;" .. S("Bookshelf") .. "]" ..
	"list[context;books;0,1;9,2;]" ..
	"list[context;split;8,3.14;1,1;]" ..
	"listring[context;books]" ..
	"listring[current_player;main]"

local function update_bookshelf(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local invlist = inv:get_list("books")
	if not invlist then
		inv:set_size("books", 9 * 2)
		invlist = inv:get_list("books")
	end

	local formspec = bookshelf_formspec
	-- Inventory slots overlay
	local bx, by = 0, 1
	local n_written, n_empty = 0, 0
	for i = 1, 18 do
		if i == 10 then
			bx = 0
			by = by + 1
		end
		formspec = formspec ..
			"image[" .. bx .. "," .. by .. ";1,1;formspec_cell.png]"
		local stack = invlist[i]
		if stack:is_empty() then
			formspec = formspec ..
				"image[" .. bx .. "," .. by .. ";1,1;default_bookshelf_slot.png]"
		else
			local metatable = stack:get_meta():to_table() or {}
			if metatable.fields and metatable.fields.text then
				n_written = n_written + stack:get_count()
			else
				n_empty = n_empty + stack:get_count()
			end
		end
		bx = bx + 1
	end
	meta:set_string("formspec", formspec)
	if n_written + n_empty == 0 then
		meta:set_string("infotext", S("Empty Bookshelf"))
	else
		meta:set_string("infotext", S("Bookshelf") .. "\n(" ..
			S("Books:") .. " " .. n_written .. ", " ..
			S("Empty Books:") .. " " .. n_empty .. ")")
	end
end

-- LBM for updating Bookshelf
minetest.register_lbm({
	label = "Bookshelf updater",
	name = "default:bookshelf_updater",
	nodenames = "default:bookshelf",
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_string("version") ~= "2" then
			update_bookshelf(pos)
			meta:set_string("version", "2")
		end
	end
})

minetest.register_node("default:bookshelf", {
	description = S("Bookshelf"),
	tiles = {
		"default_wood.png", "default_wood.png",
		"default_wood.png", "default_wood.png",
		"default_wood.png^default_bookshelf.png", "default_wood.png^default_bookshelf.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("books", 9 * 2)
		inv:set_size("split", 1)
		update_bookshelf(pos)
		meta:set_string("version", "2")
	end,
	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("books")
	end,
	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		if not minetest.is_protected(pos, player and player:get_player_name() or "")
				and minetest.get_item_group(stack:get_name(), "book") ~= 0 then
			return listname == "split" and 1 or stack:get_count()
		end
		return 0
	end,
	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		if minetest.is_protected(pos, player and player:get_player_name() or "") then
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_move = function(pos, _, _, to_list, _, count, player)
		if not minetest.is_protected(pos, player and player:get_player_name() or "") then
			return to_list == "split" and 1 or count
		end
		return 0
	end,
	on_metadata_inventory_move = update_bookshelf,
	on_metadata_inventory_put = update_bookshelf,
	on_metadata_inventory_take = update_bookshelf,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "books", drops)
		drops[#drops + 1] = "default:bookshelf"
		minetest.remove_node(pos)
		return drops
	end
})

local ladder_wood_groups = {
	choppy = 2, oddly_breakable_by_hand = 3, flammable = 2, attached_node = 1,
	wood_ladder = 1
}

default.register_ladder("default:ladder_wood", {
	description = S("Apple Wood Ladder"),
	tiles = {"default_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	groups = ladder_wood_groups,
	sounds = default.node_sound_wood_defaults(),
	material = "default:wood"
})

default.register_ladder("default:ladder_acacia_wood", {
	description = S("Acacia Wood Ladder"),
	tiles = {"default_acacia_wood.png"},
	inventory_image = "default_ladder_acacia_wood.png",
	wield_image = "default_ladder_acacia_wood.png",
	groups = ladder_wood_groups,
	sounds = default.node_sound_wood_defaults(),
	material = "default:acacia_wood"
})

default.register_ladder("default:ladder_birch_wood", {
	description = S("Birch Wood Ladder"),
	tiles = {"default_birch_wood.png"},
	inventory_image = "default_ladder_birch_wood.png",
	wield_image = "default_ladder_birch_wood.png",
	groups = ladder_wood_groups,
	sounds = default.node_sound_wood_defaults(),
	material = "default:birch_wood"
})

default.register_ladder("default:ladder_jungle_wood", {
	description = S("Jungle Wood Ladder"),
	tiles = {"default_junglewood.png"},
	inventory_image = "default_ladder_jungle_wood.png",
	wield_image = "default_ladder_jungle_wood.png",
	groups = ladder_wood_groups,
	sounds = default.node_sound_wood_defaults(),
	material = "default:junglewood"
})

default.register_ladder("default:ladder_pine_wood", {
	description = S("Pine Wood Ladder"),
	tiles = {"default_pine_wood.png"},
	inventory_image = "default_ladder_pine_wood.png",
	wield_image = "default_ladder_pine_wood.png",
	groups = ladder_wood_groups,
	sounds = default.node_sound_wood_defaults(),
	material = "default:pine_wood"
})

default.register_ladder("default:ladder_cherry_blossom_wood", {
	description = S("Cherry Blossom Wood Ladder"),
	tiles = {"default_cherry_blossom_wood.png"},
	inventory_image = "default_ladder_cherry_blossom_wood.png",
	wield_image = "default_ladder_cherry_blossom_wood.png",
	groups = ladder_wood_groups,
	sounds = default.node_sound_wood_defaults(),
	material = "default:cherry_blossom_wood"
})

default.register_ladder("default:ladder_steel", {
	description = S("Steel Ladder"),
	tiles = {"default_ladder_steel_tile.png"},
	inventory_image = "default_ladder_steel.png",
	wield_image = "default_ladder_steel.png",
	groups = {cracky = 1, level = 2, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),
	material = "default:steel_ingot"
})

default.register_ladder("default:ladder_ice", {
	description = S("Ice Ladder"),
	tiles = {"default_ice.png"},
	inventory_image = "default_ladder_ice.png",
	wield_image = "default_ladder_ice.png",
	use_texture_alpha = "blend",
	groups = {cracky = 3, cools_lava = 1, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),
	material = "default:ice"
})


minetest.register_node("default:grill_bar", {
	description = S("Grill"),
	drawtype = "nodebox",
	tiles = {
		"default_grill_side.png",
		"default_grill_side.png^[transform2",
		"default_grill_side.png^[transform3",
		"default_grill_side.png^[transform1",
		"default_grill_bar.png^[transform46",
		"default_grill_bar.png^[transform6"
	},
	inventory_image = "default_grill_bar.png",
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, -3/8}
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_metal_defaults()
})

local fence_wood_groups = {
	choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence_wood = 1
}

default.register_fence("default:fence_wood", {
	description = S("Apple Wood Fence"),
	texture = "default_wood.png",
	inventory_image = "default_fence_wood.png",
	material = "default:wood",
	groups = fence_wood_groups,
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_acacia_wood", {
	description = S("Acacia Wood Fence"),
	texture = "default_acacia_wood.png",
	inventory_image = "default_fence_acacia_wood.png",
	material = "default:acacia_wood",
	groups = fence_wood_groups,
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_birch_wood", {
	description = S("Birch Wood Fence"),
	texture = "default_birch_wood.png",
	inventory_image = "default_fence_birch_wood.png",
	material = "default:birch_wood",
	groups = fence_wood_groups,
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_jungle_wood", {
	description = S("Jungle Wood Fence"),
	texture = "default_junglewood.png",
	inventory_image = "default_fence_jungle_wood.png",
	material = "default:junglewood",
	groups = fence_wood_groups,
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_pine_wood", {
	description = S("Pine Wood Fence"),
	texture = "default_pine_wood.png",
	inventory_image = "default_fence_pine_wood.png",
	material = "default:pine_wood",
	groups = fence_wood_groups,
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_cherry_blossom_wood", {
	description = S("Cherry Blossom Wood Fence"),
	texture = "default_cherry_blossom_wood.png",
	inventory_image = "default_fence_cherry_blossom_wood.png",
	material = "default:cherry_blossom_wood",
	groups = fence_wood_groups,
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_ice", {
	description = S("Ice Fence"),
	texture = "default_ice.png",
	inventory_image = "default_fence_ice.png",
	use_texture_alpha = "blend",
	material = "default:ice",
	groups = {cracky = 3, cools_lava = 1, flammable = 2},
	sounds = default.node_sound_glass_defaults()
})


minetest.register_node("default:vine", {
	description = S("Vines"),
	drawtype = "signlike",
	tiles = {"default_vine.png"},
	inventory_image = "default_vine.png",
	wield_image = "default_vine.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	selection_box = {
		type = "wallmounted"
	},
	groups = {snappy = 2, oddly_breakable_by_hand = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults()
})


minetest.register_node("default:glass", {
	description = S("Glass"),
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	drop = ""
})

minetest.register_node("default:brick", {
	description = S("Brick Block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_brick.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:glowstone", {
	description = S("Glowstone"),
	tiles = {"default_glowstone.png"},
	paramtype = "light",
	groups = {cracky = 3},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:glowstone_dust 6"}, rarity = 5},
			{items = {"default:glowstone_dust 4"}, rarity = 3},
			{items = {"default:glowstone_dust 3"}, rarity = 2},
			{items = {"default:glowstone_dust 2"}}
		}
	},
	light_source = minetest.LIGHT_MAX - 3
})

--
-- register trees for leafdecay
--

if minetest.get_mapgen_setting("mg_name") == "v6" then
	default.register_leafdecay({
		trunks = {"default:tree"},
		leaves = {"default:apple", "default:apple_green", "default:leaves"},
		radius = 2
	})

	default.register_leafdecay({
		trunks = {"default:jungletree"},
		leaves = {"default:jungleleaves"},
		radius = 3
	})
else
	default.register_leafdecay({
		trunks = {"default:tree"},
		leaves = {"default:apple", "default:apple_green", "default:leaves"},
		radius = 3
	})

	default.register_leafdecay({
		trunks = {"default:jungletree"},
		leaves = {"default:jungleleaves"},
		radius = 2
	})
end

default.register_leafdecay({
	trunks = {"default:pine_tree"},
	leaves = {"default:pine_needles"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"default:acacia_tree"},
	leaves = {"default:acacia_leaves"},
	radius = 2
})

default.register_leafdecay({
	trunks = {"default:birch_tree"},
	leaves = {"default:birch_leaves"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"default:cherry_blossom_tree"},
	leaves = {"default:cherry_blossom_leaves"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"default:bush_stem"},
	leaves = {"default:bush_leaves"},
	radius = 1
})

default.register_leafdecay({
	trunks = {"default:acacia_bush_stem"},
	leaves = {"default:acacia_bush_leaves"},
	radius = 1
})

default.register_leafdecay({
	trunks = {"default:pine_bush_stem"},
	leaves = {"default:pine_bush_needles"},
	radius = 1
})

default.register_leafdecay({
	trunks = {"default:blueberry_bush_stem"},
	leaves = {"default:blueberry_bush_leaves"},
	radius = 1
})
