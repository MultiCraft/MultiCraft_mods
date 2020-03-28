-- Required wrapper to allow customization of default.after_place_leaves
local function after_place_leaves(...)
	return default.after_place_leaves(...)
end

 -- Required wrapper to allow customization of default.grow_sapling
local function grow_sapling(...)
	return default.grow_sapling(...)
end

--
-- Stone
--

minetest.register_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:cobble",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:cobble", {
	description = "Cobblestone",
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrick", {
	description = "Stone Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:mossycobble", {
	description = "Mossy Cobblestone",
	tiles = {"default_mossycobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrickcarved", {
	description = "Stone Brick Carved",
	tiles = {"default_stonebrick_carved.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrickcracked", {
	description = "Stone Brick Cracked",
	tiles = {"default_stonebrick_cracked.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stonebrickmossy", {
	description = "Mossy Stone Brick",
	tiles = {"default_stonebrick_mossy.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png", "default_sandstone_normal.png"},
	groups = {crumbly = 1, cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:sandstonesmooth", {
	description = "Smooth Sandstone",
	tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png", "default_sandstone_smooth.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:redsandstone", {
	description = "Red Sandstone",
	tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png", "default_redsandstone_normal.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:redsandstonesmooth", {
	description = "Red Sandstone Smooth",
	tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png", "default_redsandstone_smooth.png"},
	groups = {crumbly = 2, cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky = 3, level = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:bedrock", {
	description = "Bedrock",
	tiles = {"default_bedrock.png"},
	groups = {oddly_breakable_by_hand = 5, speed = -30, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults()
})

--
-- Soft / Non-Stone
--

minetest.register_node("default:dirt", {
	description = "Dirt",
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
	description = "Dirt with Grass",
	tiles = {"default_grass.png", "default_dirt.png", "default_grass_side.png"},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25}
	})
})

minetest.register_node("default:dirt_with_dry_grass", {
	description = "Dirt with Dry Grass",
	tiles = {"default_dry_grass.png", "default_dirt.png",
		"default_dry_grass_side.png"},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.4}
	})
})

minetest.register_node("default:dirt_with_snow", {
	description = "Dirt with Snow",
	tiles = {"default_snow.png", "default_dirt.png",
		"default_snow_side.png"},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, snowy = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.4}
	})
})

minetest.register_node("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults()
})

minetest.register_node("default:gravel", {
	description = "Gravel",
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
	description = "Red Sand",
	tiles = {"default_red_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults()
})

minetest.register_node("default:clay", {
	description = "Clay",
	tiles = {"default_clay.png"},
	groups = {crumbly = 3},
	drop = "default:clay_lump 4",
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_node("default:hardened_clay", {
	description = "Hardened Clay",
	tiles = {"default_hardened_clay.png"},
	is_ground_content = false,
	groups = {cracky = 3, hardened_clay = 1},
	sounds = default.node_sound_defaults()
})

minetest.register_node("default:cement", {
	description = "Cement",
	tiles = {"default_cement.png"},
	is_ground_content = false,
	groups = {crumbly = 3, falling_node = 1},
	sounds = default.node_sound_defaults(),
	floodable = true,
	on_flood = function(pos)
		minetest.swap_node(pos, {name = "default:concrete"})
		return true
	end
})

minetest.register_node("default:concrete", {
	description = "Concrete",
	tiles = {"default_concrete.png"},
	groups = {cracky = 3},
	drop = "",
	sounds = default.node_sound_dirt_defaults()
})


minetest.register_node("default:snow", {
	description = "Snow",
	tiles = {"default_snow.png"},
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	walkable = false,
	drawtype = "nodebox",
	stack_max = 16,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+1/16, 0.5}
		}
	},
	groups = {crumbly = 3, falling_node = 1, snowy = 1, puts_out_fire = 1, misc = 1, speed = -30, not_in_creative_inventory = 1},
	sounds = default.node_sound_snow_defaults(),
	drop = "default:snowball",

	on_construct = function(pos)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name == "default:dirt_with_grass" or name == "default:dirt_with_dry_grass" then
			minetest.swap_node(pos, {name = "default:dirt_with_snow"})
		end
	end,

	on_timer = function(pos)
		minetest.remove_node(pos)
	end
})

minetest.register_node("default:snowblock", {
	description = "Snow Block",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, cools_lava = 1, melting = 1, speed = -30},
	sounds = default.node_sound_snow_defaults(),
	drop = "default:snowball 4",
	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end
})

minetest.register_node("default:ice", {
	description = "Ice",
	drawtype = "glasslike",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	use_texture_alpha = true,
	groups = {cracky = 3, cools_lava = 1, melting = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("default:packedice", {
	description = "Packed Ice",
	drawtype = "glasslike",
	tiles = {"default_ice_packed.png"},
	paramtype = "light",
	use_texture_alpha = true,
	groups = {cracky = 3, cools_lava = 1, melting = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults()
})

--
-- Trees
--

minetest.register_node("default:tree", {
	description = "Apple Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:wood", {
	description = "Apple Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:sapling", {
	description = "Apple Tree Sapling",
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
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
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
	description = "Apple Tree Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_leaves.png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 8},
			{items = {"default:leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:apple", {
	description = "Apple",
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
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_apple = 1, food = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos)
		minetest.set_node(pos, {name = "default:apple", param2 = 1})
	end
})

minetest.register_node("default:apple_gold", {
	description = "Golden Apple",
	drawtype = "plantlike",
	visual_scale = 0.75,
	tiles = {"default_apple_gold.png"},
	inventory_image = "default_apple_gold.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2, foodstuffs = 1, food = 1},
	on_use = minetest.item_eat(8),
	sounds = default.node_sound_defaults()
})


minetest.register_node("default:jungletree", {
	description = "Jungle Tree",
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png",
		"default_jungletree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:junglewood", {
	description = "Jungle Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:jungleleaves", {
	description = "Jungle Tree Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_jungleleaves.png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:junglesapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 8},
			{items = {"default:jungleleaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:junglesapling", {
	description = "Jungle Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_junglesapling.png"},
	inventory_image = "default_junglesapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
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
	description = "Pine Tree",
	tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
		"default_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:pine_wood", {
	description = "Pine Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:pine_needles",{
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	tiles = {"default_pine_needles.png"},
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
	description = "Pine Tree Sapling",
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
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
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
	description = "Acacia Tree",
	tiles = {"default_acacia_tree_top.png", "default_acacia_tree_top.png",
		"default_acacia_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:acacia_wood", {
	description = "Acacia Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_acacia_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:acacia_leaves", {
	description = "Acacia Tree Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_acacia_leaves.png"},
	waving = 1,
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, speed = -20},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:acacia_sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 8},
			{items = {"default:acacia_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves
})

minetest.register_node("default:acacia_sapling", {
	description = "Acacia Tree Sapling",
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
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
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
	description = "Birch Tree",
	tiles = {"default_birch_tree_top.png", "default_birch_tree_top.png",
		"default_birch_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("default:birch_wood", {
	description = "Birch Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_birch_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:birch_leaves", {
	description = "Birch Tree Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_birch_leaves.png"},
	waving = 1,
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:birch_sapling"}, rarity = 20},
			{items = {"default:vine"}, rarity = 8},
			{items = {"default:birch_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = after_place_leaves
})

minetest.register_node("default:birch_sapling", {
	description = "Birch Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_birch_sapling.png"},
	inventory_image = "default_birch_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
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

--
-- Ores
--

minetest.register_node("default:stone_with_coal", {
	description = "Coal Ore",
	tiles = {"default_stone.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:coalblock", {
	description = "Coal Block",
	tiles = {"default_coal_block.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_stone.png^default_mineral_iron.png"},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:steelblock", {
	description = "Steel Block",
	tiles = {"default_steel_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:lapisblock", {
	description = "Lapis Lazuli Block",
	tiles = {"default_lapis_block.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_bluestone", {
	description = "Bluestone Ore",
	tiles = {"default_stone.png^default_mineral_bluestone.png"},
	groups = {cracky = 2},
	drop = "mesecons:wire_00000000_off 8",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_lapis", {
	description = "Lapis Lazuli Ore",
	tiles = {"default_stone.png^default_mineral_lapis.png"},
	groups = {cracky = 2},
	drop = {
		max_items = 2,
		items = {
			{items = {"dye:blue 5"}, rarity = 16},
			{items = {"dye:blue 4"}, rarity = 12},
			{items = {"dye:blue 3"}, rarity = 8},
			{items = {"dye:blue 2"}, rarity = 6},
			{items = {"dye:blue 1"}, rarity = 1}
		}
	},
	sounds = default.node_sound_stone_defaults()
})


minetest.register_node("default:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"default_stone.png^default_mineral_gold.png"},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:goldblock", {
	description = "Gold Block",
	tiles = {"default_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_emerald", {
	description = default.colors.emerald .. Sl("Emerald Ore"),
	tiles = {"default_stone.png^default_mineral_emerald.png"},
	groups = {cracky = 2},
	drop = "default:emerald",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:emeraldblock", {
	description = default.colors.emerald .. Sl("Emerald Block"),
	tiles = {"default_emerald_block.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:rubyblock", {
	description = default.colors.ruby .. Sl("Ruby Block"),
	tiles = {"default_ruby_block.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:stone_with_diamond", {
	description = "Diamonds in Stone",
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:diamondblock", {
	description = "Diamond Block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults()
})

--
-- Plantlife (non-cubic)
--

minetest.register_node("default:cactus", {
	description = "Cactus",
	drawtype = "nodebox",
	tiles = {"default_cactus_top.png", "default_cactus_bottom.png", "default_cactus_side.png"},
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
		fixed = {
			{-7/16, -8/16, -7/16, 7/16, 8/16, 7/16}
		}
	}
})

minetest.register_node("default:sugarcane", {
	description = "Sugarcane",
	drawtype = "plantlike",
	tiles = {"default_sugarcane.png"},
	inventory_image = "default_sugarcane_inv.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {snappy = 3, flammable = 2, flora = 1},
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = function(pos, node, _, digger)
		default.dig_up(pos, node, digger)
	end
})

minetest.register_node("default:dry_shrub", {
	description = "Dry Shrub",
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
		fixed = {-1/3, -1/2, -1/3, 1/3, 1/6, 1/3}
	}
})

minetest.register_node("default:junglegrass", {
	description = "Jungle Grass",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_junglegrass.png"},
	inventory_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults()
})

minetest.register_node("default:grass", {
	description = "Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_tallgrass.png"},
	inventory_image = "default_tallgrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1,
		flammable = 1, dig_immediate = 3},
	sounds = default.node_sound_leaves_defaults()
})

minetest.register_node("default:dry_grass", {
	description = "Dry Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_tallgrass.png"},
	inventory_image = "default_dry_tallgrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1,
		dry_grass = 1, dig_immediate = 3},
	sounds = default.node_sound_leaves_defaults()
})

--
-- Liquids
--

minetest.register_node("default:water_source", {
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
	groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_water_defaults()
})

minetest.register_node("default:water_flowing", {
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
})


minetest.register_node("default:river_water_source", {
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
	groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_water_defaults()
})

minetest.register_node("default:river_water_flowing", {
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
})


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
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1}
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
	"label[0.9,0.1;" .. Sl("Bookshelf") .. "]" ..
	"list[context;books;0,1;9,2;]" ..
	"list[context;split;8,3.14;1,1;]" ..
	"listring[context;books]" ..
	"listring[current_player;main]"

local function update_bookshelf(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local invlist = inv:get_list("books")

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
		meta:set_string("infotext", Sl("Empty Bookshelf"))
	else
		meta:set_string("infotext", Sl("Bookshelf") .. "\n(" ..
			 Sl("Books:") .. " " .. n_written .. ", " .. Sl("Empty Books:") .. " " .. n_empty .. ")")
	end
end

minetest.register_node("default:bookshelf", {
	description = "Bookshelf",
	tiles = {"default_wood.png", "default_wood.png", "default_wood.png",
		"default_wood.png", "default_bookshelf.png", "default_bookshelf.png"},
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
	end,
	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("books")
	end,
	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		if not minetest.is_protected(pos, player:get_player_name()) and
				minetest.get_item_group(stack:get_name(), "book") ~= 0 then
			if listname == "split" then
				return 1
			else
				return stack:get_count()
			end
		end
		return 0
	end,
	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_move = function(pos, _, _, to_list, _, count, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		elseif to_list == "split" then
			return 1
		end
		return count
	end,
	on_metadata_inventory_move = update_bookshelf,
	on_metadata_inventory_put = update_bookshelf,
	on_metadata_inventory_take = update_bookshelf,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "books", drops)
		drops[#drops+1] = "default:bookshelf"
		minetest.remove_node(pos)
		return drops
	end
})


minetest.register_node("default:ladder_wood", {
	description = "Wooden Ladder",
	drawtype = "nodebox",
	tiles = {"default_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.5,  -0.25,  -0.375, 0.5},		-- Strut Left
			{ 0.25,  -0.5, -0.5,   0.375, -0.375, 0.5},		-- Strut Right
			{-0.438, -0.5,  0.312, 0.438, -0.35,  0.435},	-- Rung 1
			{-0.438, -0.5,  0.06,  0.438, -0.35,  0.185},	-- Rung 2
			{-0.438, -0.5, -0.185, 0.438, -0.35, -0.06},	-- Rung 3
			{-0.438, -0.5, -0.435, 0.438, -0.35, -0.31}		-- Rung 4
		}
	},
	selection_box = {
		type = "wallmounted",
		wall_top    = {-0.438,  0.35, -0.5,    0.438,  0.5,  0.5},
		wall_bottom = {-0.438, -0.5,  -0.5,    0.438, -0.35, 0.5},
		wall_side   = {-0.5,   -0.5,  -0.438, -0.35,   0.5,  0.438}
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 2, attached_node = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:grill_bar", {
	description = "Grill",
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
	wield_image = "default_grill_bar.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, 1/2, -6/16}
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_metal_defaults()
})

default.register_fence("default:fence_wood", {
	description = "Apple Wood Fence",
	texture = "default_wood.png",
	inventory_image = "default_fence_wood.png",
	material = "default:wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence_wood = 1},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_acacia_wood", {
	description = "Acacia Wood Fence",
	texture = "default_acacia_wood.png",
	inventory_image = "default_fence_acacia_wood.png",
	material = "default:acacia_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence_wood = 1},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_birch_wood", {
	description = "Birch Wood Fence",
	texture = "default_birch_wood.png",
	inventory_image = "default_fence_birch_wood.png",
	material = "default:birch_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence_wood = 1},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_jungle_wood", {
	description = "Jungle Wood Fence",
	texture = "default_junglewood.png",
	inventory_image = "default_fence_jungle_wood.png",
	material = "default:junglewood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence_wood = 1},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_pine_wood", {
	description = "Pine Wood Fence",
	texture = "default_pine_wood.png",
	inventory_image = "default_fence_pine_wood.png",
	material = "default:pine_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence_wood = 1},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_ice", {
	description = "Ice Fence",
	texture = "default_ice.png",
	inventory_image = "default_fence_ice.png",
	material = "default:ice",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_glass_defaults()
})


minetest.register_node("default:vine", {
	description = "Vines",
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
	groups = {snappy = 2, oddly_breakable_by_hand = 3, flammable = 2, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(30, 60))
	end,

	on_timer = function(pos)
		local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
		if (minetest.get_node_light(pos) or 0) < 13 then
			return true
		end
		if minetest.get_node(pos_under).name == "air" then
			minetest.set_node(pos_under, {
				name = "default:vine",
				param2 = minetest.get_node(pos).param2
			})
		end
	end,

	after_dig_node = function(pos, node, _, digger)
		default.dig_down(pos, node, digger)
		local pos_above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(pos_above).name == "default:vine" then
			minetest.get_node_timer(pos_above):start(math.random(30, 60))
		end
	end
})


minetest.register_node("default:glass", {
	description = "Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	drop = ""
})

minetest.register_node("default:brick", {
	description = "Brick Block",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_brick.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:glowstone", {
	description = "Glowstone",
	tiles = {"default_glowstone.png"},
	paramtype = "light",
	groups = {cracky = 3},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:glowstone_dust 8"}, rarity = 7},
			{items = {"default:glowstone_dust 6"}, rarity = 5},
			{items = {"default:glowstone_dust 4"}, rarity = 3},
			{items = {"default:glowstone_dust 3"}, rarity = 2},
			{items = {"default:glowstone_dust 2"}}
		}
	},
	light_source = minetest.LIGHT_MAX - 3
})

minetest.register_node("default:slimeblock", {
	description = "Slime Block",
	drawtype = "nodebox",
	tiles = {"default_slimeblock.png"},
	walkable = false,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
		}
	},
	use_texture_alpha = true,
	sunlight_propagates = true,
	groups = {oddly_breakable_by_hand = 3, disable_jump = 1, fall_damage_add_percent = -100, speed = -60}
})

--
-- Quartz
--

minetest.register_node("default:quartz_ore", {
	description = "Quartz Ore",
	tiles = {"default_quartz_ore.png"},
	groups = {cracky = 3, quartz = 1},
	drop = "default:quartz_crystal",
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:quartz_block", {
	description = "Quartz Block",
	tiles = {"default_quartz_block_top.png", "default_quartz_block_bottom.png", "default_quartz_block_side.png"},
	groups = {snappy = 1, quartz = 2, cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:quartz_chiseled", {
	description = "Chiseled Quartz",
	tiles = {"default_quartz_chiseled_top.png", "default_quartz_chiseled_top.png", "default_quartz_chiseled_side.png"},
	groups = {snappy = 1, quartz = 2, cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("default:quartz_pillar", {
	description = "Quartz Pillar",
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	tiles = {"default_quartz_pillar_top.png", "default_quartz_pillar_top.png", "default_quartz_pillar_side.png"},
	groups = {snappy = 1, quartz = 2, cracky = 1},
	sounds = default.node_sound_stone_defaults()
})

--
-- register trees for leafdecay
--

if minetest.get_mapgen_setting("mg_name") == "v6" then
	default.register_leafdecay({
		trunks = {"default:tree"},
		leaves = {"default:apple", "default:leaves"},
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
		leaves = {"default:apple", "default:leaves"},
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
