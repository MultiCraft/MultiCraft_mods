-- mods/default/nodes.lua

--
-- Node definitions
--

minetest.register_node("default:dirt_with_snow", {
	description = "Dirt with Snow",
	stack_max = 64,
	tiles = {"default_snow.png", "default_dirt.png",
		{name = "default_snow_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.25},
	}),
})

minetest.register_node("default:snow", {
	description = "Snow",
	stack_max = 64,
	tiles = {"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	paramtype = "light",
	buildable_to = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	},
	groups = {crumbly = 3, falling_node = 1, puts_out_fire = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.25},
		dug = {name = "default_snow_footstep", gain = 0.75},
	}),

	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})

minetest.register_node("default:snowblock", {
	description = "Snow Block",
	stack_max = 64,
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, puts_out_fire = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.25},
		dug = {name = "default_snow_footstep", gain = 0.75},
	}),
})


minetest.register_node("default:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, puts_out_fire = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:pine_tree", {
	description = "Pine Tree",
	stack_max = 64,
	tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
		"default_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("default:pine_wood", {
	description = "Pine Wood Planks",
	stack_max = 64,
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:pine_needles",{
	description = "Pine Needles",
	stack_max = 64,
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
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

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:pine_sapling", {
	description = "Pine Sapling",
	stack_max = 64,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_pine_sapling.png"},
	inventory_image = "default_pine_sapling.png",
	wield_image = "default_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:stone", {
    description = "Stone",
    tiles = {"default_stone.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=3, stone=1, building = 1, decorative = 1},
    drop = 'default:cobble',
    legacy_mineral = true,
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_coal", {
    description = "Coal Ore",
    tiles = {"default_stone.png^default_mineral_coal.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=3, building = 1},
    drop = 'default:coal_lump',
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_iron", {
    description = "Iron Ore",
    tiles = {"default_stone.png^default_mineral_iron.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=2, building = 1},
    drop = 'default:stone_with_iron',
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:stone_with_gold", {
    description = "Gold Ore",
    tiles = {"default_stone.png^default_mineral_gold.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=2, building = 1},
    drop = "default:stone_with_gold",
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:stone_with_bluestone", {
    description = "Bluestone Ore",
    tiles = {"default_stone.png^default_mineral_bluestone.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=2, building = 1},
    drop = "mesecons:wire_00000000_off 5",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_lapis", {
    description = "Lapis Lazuli Ore",
    tiles = {"default_stone.png^default_mineral_lapis.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=2, building = 1},
    drop = {
        max_items = 2,
        items = {
            {items = {'dye:blue 5'},rarity = 16},
            {items = {'dye:blue 4'},rarity = 12},
            {items = {'dye:blue 3'},rarity = 8},
            {items = {'dye:blue 2'},rarity = 6},
            {items = {'dye:blue 1'},rarity = 1},
        }
    },
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_emerald", {
    description = "Emerald Ore",
    tiles = {"default_stone.png^default_mineral_emerald.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=2, building = 1},
    drop = "default:emerald",
--  drop = {
--      max_items = 2,
--      items = {
--          {items="default:emerald",rarity = 5},
--          {items="default:emerald"},
--      },
--  },
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_diamond", {
    description = "Diamonds in Stone",
    tiles = {"default_stone.png^default_mineral_diamond.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=1, building = 1},
    drop = "default:diamond",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stonebrick", {
    description = "Stone Brick",
    tiles = {"default_stone_brick.png"},
    stack_max = 64,
    groups = {cracky=3, stone=1, building = 1, decorative = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stonebrickcarved", {
    description = "Stone Brick Carved",
    tiles = {"default_stonebrick_carved.png"},
    stack_max = 64,
    groups = {cracky=3, stone=1, building = 1, decorative = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stonebrickcracked", {
    description = "Stone Brick Cracked",
    tiles = {"default_stonebrick_cracked.png"},
    stack_max = 64,
    groups = {cracky=3, stone=1, building = 1, decorative = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stonebrickmossy", {
    description = "Mossy Stone Brick",
    tiles = {"default_stonebrick_mossy.png"},
    stack_max = 64,
    groups = {cracky=3, stone=1, building = 1, decorative = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:dirt_with_grass", {
    description = "Dirt with Grass",
    tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, soil=1, building = 1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})

minetest.register_node("default:dirt_with_grass_footsteps", {
    description = "Dirt with Grass and Footsteps",
    tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, not_in_creative_inventory=1, soil=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})

minetest.register_node("default:dirt_with_snow", {
    description = "Dirt with Snow",
    tiles = {"default_snow.png", "default_dirt.png", "default_dirt.png^default_snow_side.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, building = 1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})

minetest.register_node("default:dirt", {
    description = "Dirt",
    tiles = {"default_dirt.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, soil=1, building = 1},
    sounds = default.node_sound_dirt_defaults(),
})


minetest.register_node("default:gravel", {
    description = "Gravel",
    tiles = {"default_gravel.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2, falling_node=1, building = 1},
    drop = {
        max_items = 1,
        items = {
            {items = {'default:flint'},rarity = 7},
            {items = {'default:gravel'}}
        }
    },
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_gravel_footstep", gain=0.45},
    }),
})

-- sandstone --
minetest.register_node("default:sand", {
    description = "Sand",
    tiles = {"default_sand.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, falling_node=1, sand=1, building = 1},
    sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:sandstone", {
    description = "Sandstone",
    tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png", "default_sandstone_normal.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2,cracky=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstonesmooth", {
    description = "Sandstone Smooth",
    tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png", "default_sandstone_smooth.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2,cracky=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstonecarved", {
    description = "Sandstone Carved",
    tiles = {"default_sandstone_top.png", "default_sandstone_bottom.png", "default_sandstone_carved.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2,cracky=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

-- red sandstone --

minetest.register_node("default:redsand", {
    description = "Red Sand",
    tiles = {"default_red_sand.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, falling_node=1, redsand=1, building = 1},
    sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:redsandstone", {
    description = "Red SandStone",
    tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png", "default_redsandstone_normal.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2,cracky=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:redsandstonesmooth", {
    description = "Red SandStone Smooth",
    tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png", "default_redsandstone_smooth.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2,cracky=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:redsandstonecarved", {
    description = "Red SandStone Carved",
    tiles = {"default_redsandstone_top.png", "default_redsandstone_bottom.png", "default_redsandstone_carved.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=2,cracky=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

---

minetest.register_node("default:clay", {
    description = "Clay",
    tiles = {"default_clay.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, building = 1},
    drop = 'default:clay_lump 4',
    sounds = default.node_sound_dirt_defaults({
        footstep = "",
    }),
})

minetest.register_node("default:brick", {
    description = "Brick Block",
    tiles = {"default_brick.png"},
    stack_max = 64,
    groups = {cracky=3, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:haybale", {
    description = "Hay Bale",
    tiles = {"default_hayblock_top.png", "default_hayblock_top.png", "default_hayblock_side.png"},
    stack_max = 64,
    paramtype2 = "facedir",
    is_ground_content = false,
    on_place = minetest.rotate_node,
    groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2, building = 1},
    sounds = default.node_sound_wood_defaults(),
})



--
-- Trees
--

minetest.register_node("default:tree", {
	description = "Tree",
	stack_max = 64,
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:wood", {
	description = "Wooden Planks",
	stack_max = 64,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:sapling", {
	description = "Sapling",
	stack_max = 64,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:leaves", {
	description = "Leaves",
	stack_max = 64,
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'default:leaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:apple", {
	description = "Apple",
	stack_max = 64,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "default:apple", param2 = 1})
		end
	end,
})


minetest.register_node("default:jungletree", {
	description = "Jungle Tree",
	stack_max = 64,
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png",
		"default_jungletree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:junglewood", {
	description = "Junglewood Planks",
	stack_max = 64,
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:jungleleaves", {
	description = "Jungle Leaves",
	stack_max = 64,
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_jungleleaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:junglesapling'}, rarity = 20},
			{items = {'default:jungleleaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:junglesapling", {
	description = "Jungle Sapling",
	stack_max = 64,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_junglesapling.png"},
	inventory_image = "default_junglesapling.png",
	wield_image = "default_junglesapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("default:pine_tree", {
	description = "Pine Tree",
	stack_max = 64,
	tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
		"default_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:pine_wood", {
	description = "Pine Wood Planks",
	stack_max = 64,
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:pine_needles",{
	description = "Pine Needles",
	stack_max = 64,
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
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

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:pine_sapling", {
	description = "Pine Sapling",
	stack_max = 64,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_pine_sapling.png"},
	inventory_image = "default_pine_sapling.png",
	wield_image = "default_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("default:acacia_tree", {
	description = "Acacia Tree",
	stack_max = 64,
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
	stack_max = 64,
	tiles = {"default_acacia_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:acacia_leaves", {
	description = "Acacia Leaves",
	stack_max = 64,
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_acacia_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:acacia_sapling"}, rarity = 20},
			{items = {"default:acacia_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:acacia_sapling", {
	description = "Acacia Tree Sapling",
	stack_max = 64,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_acacia_sapling.png"},
	inventory_image = "default_acacia_sapling.png",
	wield_image = "default_acacia_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})



minetest.register_node("default:junglegrass", {
	description = "Jungle Grass",
	stack_max = 64,
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_junglegrass.png"},
	inventory_image = "default_junglegrass.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

minetest.register_node("default:cactus", {
    description = "Cactus",
    drawtype = "nodebox",
    tiles = {"default_cactus_top.png", "default_cactus_bottom.png", "default_cactus_side.png","default_cactus_side.png","default_cactus_side.png","default_cactus_side.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {snappy=1,choppy=3,flammable=2, decorative = 1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-7/16, -8/16, -7/16,  7/16, 8/16,  7/16}, -- Main Body
            {-8/16, -8/16, -7/16,  8/16, 8/16, -7/16}, -- Spikes
            {-8/16, -8/16,  7/16,  8/16, 8/16,  7/16}, -- Spikes
            {-7/16, -8/16, -8/16, -7/16, 8/16,  8/16}, -- Spikes
            {7/16,  -8/16,  8/16,  7/16, 8/16, -8/16}, -- Spikes
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-7/16, -8/16, -7/16, 7/16, 8/16, 7/16},
        },
    },


})

minetest.register_node("default:papyrus", {
	description = "Papyrus",
	drawtype = "plantlike",
	tiles = {"default_papyrus.png"},
	inventory_image = "default_papyrus.png",
	wield_image = "default_papyrus.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
})

minetest.register_node("default:reeds", {
    description = "Sugarcane",
    drawtype = "plantlike",
    tiles = {"default_papyrus.png"},
    inventory_image = "default_sugar_cane.png",
    wield_image = "default_sugar_cane.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
    node_box = {
        type = "fixed",
        fixed = {
            {-7/16, -8/16, -7/16,  7/16, 8/16,  7/16}, -- Main Body
            {-8/16, -8/16, -7/16,  8/16, 8/16, -7/16}, -- Spikes
            {-8/16, -8/16,  7/16,  8/16, 8/16,  7/16}, -- Spikes
            {-7/16, -8/16, -8/16, -7/16, 8/16,  8/16}, -- Spikes
            {7/16,  -8/16,  8/16,  7/16, 8/16, -8/16}, -- Spikes
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-7/16, -8/16, -7/16, 7/16, 8/16, 7/16},
        },
    },
    stack_max = 64,
    groups = {snappy=3,flammable=2, materials=1},
    sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("default:quartz_ore", {
    description = "Quartz Ore",
    stack_max = 64,
    tiles = {"default_quartz_ore.png"},
    groups = {cracky=3, stone=1, building = 1},
    drop = 'default:quartz_crystal',
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartz_block", {
    description = "Quartz Block",
    stack_max = 64,
    tiles = {"default_quartz_block_top.png", "default_quartz_block_bottom.png", "default_quartz_block_side.png"},
    groups = {snappy=1,bendy=2,cracky=1,level=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartz_chiseled", {
    description = "Chiseled Quartz",
    stack_max = 64,
    tiles = {"default_quartz_chiseled_top.png", "default_quartz_chiseled_top.png", "default_quartz_chiseled_side.png"},
    groups = {snappy=1,bendy=2,cracky=1,level=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartz_pillar", {
    description = "Quartz Pillar",
    stack_max = 64,
    paramtype2 = "facedir",
    on_place = minetest.rotate_node,
    tiles = {"default_quartz_pillar_top.png", "default_quartz_pillar_top.png", "default_quartz_pillar_side.png"},
    groups = {snappy=1,bendy=2,cracky=1,level=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:bedrock", {
    description = "Bedrock",
    tiles = {"default_bedrock.png"},
    stack_max = 64,
    groups = {oddly_breakable_by_hand=5, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:bookshelf", {
    description = "Bookshelf",
    tiles = {"default_wood.png", "default_wood.png", "default_bookshelf.png"},
    stack_max = 64,
    groups = {choppy=3,oddly_breakable_by_hand=2,flammable=3, building = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:slimeblock", {
    description = "Slime Block",
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        }
    },
    tiles = {"default_slimeblock.png"},
    paramtype = "light",
    use_texture_alpha = true,
    sunlight_propagates = true,
    stack_max = 64,
    groups = {oddly_breakable_by_hand=3,dig_immediate=2,bouncy=70,disable_jump=1, fall_damage_add_percent=-100, building = 1},
})

minetest.register_node("default:glass", {
    description = "Glass",
    drawtype = "glasslike",
    tiles = {"default_glass.png"},
    paramtype = "light",
    sunlight_propagates = true,
    stack_max = 64,
    groups = {cracky=3,oddly_breakable_by_hand=3, building = 1},
    sounds = default.node_sound_glass_defaults(),
    drop = "",
})

---- colored glass
AddGlass( "Glass Red",  "basecolor_red", "_red")
AddGlass( "Glass Green",  "unicolor_dark_green", "_green")
AddGlass( "Glass Blue",  "basecolor_blue", "_blue")
AddGlass( "Glass Light Blue",  "basecolor_cyan", "_light_blue")
AddGlass( "Glass Black",  "basecolor_black", "_black")
AddGlass( "Glass White",  "basecolor_white", "_white")
AddGlass( "Glass Yellow",  "basecolor_yellow", "_yellow")
AddGlass( "Glass Brown",  "unicolor_dark_orange", "_brown")
AddGlass( "Glass Orange",  "excolor_orange", "_orange")
AddGlass( "Glass Pink",  "unicolor_light_red", "_pink")
AddGlass( "Glass Gray",  "unicolor_darkgrey", "_gray")
AddGlass( "Glass Lime",  "basecolor_green", "_lime")
AddGlass( "Glass Silver",  "basecolor_grey", "_silver")
AddGlass( "Glass Magenta",  "basecolor_magenta", "_magenta")
AddGlass( "Glass Purple",  "excolor_violet", "_purple")

minetest.register_node("default:ladder", {
    description = "Ladder",
    drawtype = "signlike",
    tiles = {"default_ladder.png"},
    inventory_image = "default_ladder.png",
    wield_image = "default_ladder.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    walkable = false,
    climbable = true,
    selection_box = {
        type = "wallmounted",
        --wall_top = = <default>
        --wall_bottom = = <default>
        --wall_side = = <default>
    },
    stack_max = 64,
    groups = {choppy=2,oddly_breakable_by_hand=3,flammable=2, decorative = 1},
    legacy_wallmounted = true,
    sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("default:vine", {
    description = "Vine",
    drawtype = "signlike",
    tiles = {"default_vine.png"},
    inventory_image = "default_vine.png",
    wield_image = "default_vine.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    walkable = false,
    climbable = true,
    selection_box = {
        type = "wallmounted",
    },
    stack_max = 64,
    groups = {choppy=2,oddly_breakable_by_hand=3,flammable=2, decorative = 1},
    legacy_wallmounted = true,
    sounds = default.node_sound_leaves_defaults(),
    drop = "",
    after_dig_node = function(pos, oldnode, oldmetadata, user)
    local item = user:get_wielded_item()
        if item:get_name() == "default:shears" then
            user:get_inventory():add_item("main", ItemStack(oldnode.name))
        end
        local next_find = true
        local ptr = 1
        while next_find == true do
            local pos2 = {x=pos.x, y=pos.y-ptr, z=pos.z}
            local node = minetest.env:get_node(pos2)
            if node.name == "default:vine" and check_attached_node(pos2, node) == false then
                drop_attached_node(pos2)
                nodeupdate(pos2)
                ptr = ptr + 1
            else
                next_find = false
            end
        end
    end
})



minetest.register_node("default:wood", {
    description = "Wooden Planks",
    tiles = {"default_wood.png"},
    stack_max = 64,
    groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1, building = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:cloud", {
    description = "Cloud",
    tiles = {"default_cloud.png"},
    stack_max = 64,
    sounds = default.node_sound_defaults(),
    groups = {not_in_creative_inventory=1},
})

--
-- Liquids
--

minetest.register_node("default:water_source", {
	description = "Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name = "default_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
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
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
})

minetest.register_node("default:water_flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
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
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1,
		not_in_creative_inventory = 1},
})


minetest.register_node("default:river_water_source", {
	description = "River Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_river_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		{
			name = "default_river_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
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
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
})

minetest.register_node("default:river_water_flowing", {
	description = "Flowing River Water",
	drawtype = "flowingliquid",
	tiles = {"default_river_water.png"},
	special_tiles = {
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
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
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1,
		not_in_creative_inventory = 1},
})


minetest.register_node("default:lava_source", {
	description = "Lava Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{
			name = "default_lava_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
			backface_culling = false,
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX - 1,
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
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, hot = 3, igniter = 1},
})

minetest.register_node("default:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 1,
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
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, hot = 3, igniter = 1,
		not_in_creative_inventory = 1},
})



minetest.register_node("default:torch", {
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	tiles = {
		"default_torch_on_floor_top.png",
		"default_torch_on_floor_bottom.png",
		"default_torch_on_floor.png",
		"default_torch_on_floor.png",
		"default_torch_on_floor.png",
		"default_torch_on_floor.png"
	},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = default.LIGHT_MAX - 1,
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	liquids_pointable = false,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.125, 0.0625}, -- NodeBox1
		}
	},
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5 - 0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5 + 0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5 + 0.3, 0.3, 0.1},
	},
})


local function get_chest_neighborpos(pos, param2, side)
    if side == "right" then
        if param2 == 0 then
            return {x=pos.x-1, y=pos.y, z=pos.z}
        elseif param2 == 1 then
            return {x=pos.x, y=pos.y, z=pos.z+1}
        elseif param2 == 2 then
            return {x=pos.x+1, y=pos.y, z=pos.z}
        elseif param2 == 3 then
            return {x=pos.x, y=pos.y, z=pos.z-1}
        end
    else
        if param2 == 0 then
            return {x=pos.x+1, y=pos.y, z=pos.z}
        elseif param2 == 1 then
            return {x=pos.x, y=pos.y, z=pos.z-1}
        elseif param2 == 2 then
            return {x=pos.x-1, y=pos.y, z=pos.z}
        elseif param2 == 3 then
            return {x=pos.x, y=pos.y, z=pos.z+1}
        end
    end
end

local function hacky_swap_node(pos,name, param2)
    local node = minetest.env:get_node(pos)
    local meta = minetest.env:get_meta(pos)
    if node.name == name then
        return
    end
    node.name = name
    node.param2 = param2 or node.param2
    local meta0 = meta:to_table()
    minetest.env:set_node(pos,node)
    meta = minetest.env:get_meta(pos)
    meta:from_table(meta0)
end

minetest.register_node("default:chest", {
    description = "Chest",
    tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
    paramtype2 = "facedir",
    stack_max = 64,
    groups = {choppy=2,oddly_breakable_by_hand=2, decorative = 1},
    legacy_facedir_simple = true,
    sounds = default.node_sound_wood_defaults(),
    on_construct = function(pos)
        local param2 = minetest.env:get_node(pos).param2
        local meta = minetest.env:get_meta(pos)
        if minetest.env:get_node(get_chest_neighborpos(pos, param2, "right")).name == "default:chest" then
            minetest.env:set_node(pos, {name="default:chest_right",param2=param2})
            local p = get_chest_neighborpos(pos, param2, "right")
            meta:set_string("formspec",
                    "size[9,11.5]"..
                    "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                    "list[nodemeta:"..p.x..","..p.y..","..p.z..";main;0,0;9,3;]"..
                    "list[current_name;main;0,3;9,3;]"..
                    "list[current_player;main;0,7;9,3;9]"..
                    "list[current_player;main;0,10.5;9,1;]")
            meta:set_string("infotext", "Large Chest")
            hacky_swap_node(p, "default:chest_left", param2)
            local m = minetest.env:get_meta(p)
            m:set_string("formspec",
                    "size[9,11.5]"..
                    "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                    "list[current_name;main;0,0;9,3;]"..
                    "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,3;9,3;]"..
                    "list[current_player;main;0,7;9,3;9]"..
                    "list[current_player;main;0,10.5;9,1;]")
            m:set_string("infotext", "Large Chest")
        elseif minetest.env:get_node(get_chest_neighborpos(pos, param2, "left")).name == "default:chest" then
            minetest.env:set_node(pos, {name="default:chest_left",param2=param2})
            local p = get_chest_neighborpos(pos, param2, "left")
            meta:set_string("formspec",
                    "size[9,11.5]"..
                    "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                    "list[current_name;main;0,0;9,3;]"..
                    "list[nodemeta:"..p.x..","..p.y..","..p.z..";main;0,3;9,3;]"..
                    "list[current_player;main;0,7;9,3;9]"..
                    "list[current_player;main;0,10.5;9,1;]")
            meta:set_string("infotext", "Large Chest")
            hacky_swap_node(p, "default:chest_right", param2)
            local m = minetest.env:get_meta(p)
            m:set_string("formspec",
                    "size[9,11.5]"..
                    "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                    "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0;9,3;]"..
                    "list[current_name;main;0,3;9,3;]"..
                    "list[current_player;main;0,7;9,3;9]"..
                    "list[current_player;main;0,10.5;9,1;]")
            m:set_string("infotext", "Large Chest")
        else
            meta:set_string("formspec",
                    "size[9,8.5]"..
                    "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                    "list[current_name;main;0,0;9,3;]"..
                    "list[current_player;main;0,4;9,3;9]"..
                    "list[current_player;main;0,7.5.5;9,1;]")
            meta:set_string("infotext", "Coffre")
        end
        local inv = meta:get_inventory()
        inv:set_size("main", 9*3)
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.env:get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for i=1,inv:get_size("main") do
            local stack = inv:get_stack("main", i)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.env:add_item(p, stack)
            end
        end
        meta:from_table(meta2:to_table())
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " takes stuff from chest at "..minetest.pos_to_string(pos))
    end,
    on_receive_fields = function(pos, formname, fields, sender)      
       if fields.exit then
          print('test')
          fields.quit = true
      --    minetest.show_formspec(sender:get_player_name(), 'quit', "")
       end
    end
})

minetest.register_node("default:chest_left", {
    tiles = {"default_chest_top_big.png", "default_chest_top_big.png", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side_big.png^[transformFX", "default_chest_front_big.png"},
    paramtype2 = "facedir",
    groups = {choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
    drop = "default:chest",
    sounds = default.node_sound_wood_defaults(),
    on_destruct = function(pos)
        local m = minetest.env:get_meta(pos)
        if m:get_string("infotext") == "Chest" then
            return
        end
        local param2 = minetest.env:get_node(pos).param2
        local p = get_chest_neighborpos(pos, param2, "left")
        if not p or minetest.env:get_node(p).name ~= "default:chest_right" then
            return
        end
        local meta = minetest.env:get_meta(p)
        meta:set_string("formspec",
                "size[9,8.5]"..
                "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                "list[current_name;main;0,0;9,3;]"..
                "list[current_player;main;0,4;9,3;9]"..
                "list[current_player;main;0,7.5.5;9,1;]")
        meta:set_string("infotext", "Coffre")
        hacky_swap_node(p, "default:chest")
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.env:get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for i=1,inv:get_size("main") do
            local stack = inv:get_stack("main", i)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.env:add_item(p, stack)
            end
        end
        meta:from_table(meta2:to_table())
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " takes stuff from chest at "..minetest.pos_to_string(pos))
    end,
})

minetest.register_node("default:chest_right", {
    tiles = {"default_chest_top_big.png^[transformFX", "default_chest_top_big.png^[transformFX", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side_big.png", "default_chest_front_big.png^[transformFX"},
    paramtype2 = "facedir",
    groups = {choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
    drop = "default:chest",
    sounds = default.node_sound_wood_defaults(),
    on_destruct = function(pos)
        local m = minetest.env:get_meta(pos)
        if m:get_string("infotext") == "Chest" then
            return
        end
        local param2 = minetest.env:get_node(pos).param2
        local p = get_chest_neighborpos(pos, param2, "right")
        if not p or minetest.env:get_node(p).name ~= "default:chest_left" then
            return
        end
        local meta = minetest.env:get_meta(p)
        meta:set_string("formspec",
                "size[9,8.5]"..
                "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
                "list[current_name;main;0,0;9,3;]"..
                "list[current_player;main;0,4;9,3;9]"..
                "list[current_player;main;0,7.5.5;9,1;]")
        meta:set_string("infotext", "Chest")
        hacky_swap_node(p, "default:chest")
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.env:get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for i=1,inv:get_size("main") do
            local stack = inv:get_stack("main", i)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.env:add_item(p, stack)
            end
        end
        meta:from_table(meta2:to_table())
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " takes stuff from chest at "..minetest.pos_to_string(pos))
    end,
})


minetest.register_node("default:cobble", {
    description = "Cobblestone",
    tiles = {"default_cobble.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=3, stone=2, building = 1, decorative = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mossycobble", {
    description = "Mossy Cobblestone",
    tiles = {"default_mossycobble.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=3, building = 1, decorative = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:steelblock", {
    description = "Steel Block",
    tiles = {"default_steel_block.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=1,level=2, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:goldblock", {
    description = "Gold Block",
    tiles = {"default_gold_block.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=1, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:diamondblock", {
    description = "Diamond Block",
    tiles = {"default_diamond_block.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=1,level=3, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:lapisblock", {
    description = "Lapis Lazul Block",
    tiles = {"default_lapis_block.png"},
    stack_max = 64,
    groups = {cracky=1, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:emeraldblock", {
    description = "Emerald Block",
    tiles = {"default_emerald_block.png"},
    stack_max = 64,
    groups = {cracky=1, building = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:obsidian", {
    description = "Obsidian",
    tiles = {"default_obsidian.png"},
    is_ground_content = true,
    sounds = default.node_sound_stone_defaults(),
    stack_max = 64,
    groups = {cracky=4,level=2,oddly_breakable_by_hand=4, building = 1},
})

minetest.register_node("default:apple", {
    description = "Apple",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_apple.png"},
    inventory_image = "default_apple.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    stack_max = 64,
    groups = {fleshy=3,dig_immediate=3,flammable=2, foodstuffs = 1},
    on_use = minetest.item_eat(4),
    sounds = default.node_sound_defaults(),
})

minetest.register_node("default:apple_gold", {
    description = "Golden Apple",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_apple_gold.png"},
    inventory_image = "default_apple_gold.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    stack_max = 64,
    groups = {fleshy=3,dig_immediate=3,flammable=2, foodstuffs = 1},
    on_use = minetest.item_eat(8),
    sounds = default.node_sound_defaults(),
})

minetest.register_node("default:dry_shrub", {
    description = "Dry Shrub",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_dry_shrub.png"},
    inventory_image = "default_dry_shrub.png",
    wield_image = "default_dry_shrub.png",
    paramtype = "light",
    walkable = false,
    stack_max = 64,
    groups = {snappy=3,flammable=3,attached_node=1, decorative = 1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-1/3, -1/2, -1/3, 1/3, 1/6, 1/3},
    },
})

minetest.register_node("default:grass", {
    description = "Grass",
    drawtype = "plantlike",
    tiles = {"default_tallgrass.png"},
    inventory_image = "default_tallgrass.png",
    wield_image = "default_tallgrass.png",
    walkable = false,
    buildable_to = true,
        --drop = {
        --max_items = 1,
        --items = {
        --    {
       --         -- player will get sapling with 1/20 chance
       --         items = {'farming:wheat_seed'},
       --         rarity = 5,
       --     },
       --     {
       --         -- player will get leaves only if he get no saplings,
       --         -- this is because max_items is 1
      --          items = {''},
      --      }
       -- }
    --},
    paramtype = "light",
    is_ground_content = true,
    groups = {snappy=3,flammable=3,attached_node=1,dig_immediate=3, decorative=1, grass=1},
    sounds = default.node_sound_leaves_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, user)
    local item = user:get_wielded_item()
        if item:get_name() == "default:shears" then
            user:get_inventory():add_item("main", ItemStack(oldnode.name))
        end
    end
})

minetest.register_node("default:glowstone", {
    description = "Glowstone",
    tiles = {"default_glowstone.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {cracky=3, building = 1},
    drop = {
    max_items = 1,
    items = {
            {items = {'default:glowdust 9'},rarity = 7},
            {items = {'default:glowdust 6'},rarity = 5},
            {items = {'default:glowdust 4'},rarity = 3},
            {items = {'default:glowdust 3'},rarity = 2},
            {items = {'default:glowdust 2'}},
        }
    },
    light_source = 12,
})

minetest.register_node("default:sponge", {
    description = "Sponge",
    drawtype = "normal",
    tiles = {"default_sponge.png"},
    paramtype = 'light',
    walkable = true,
    pointable = true,
    diggable = true,
    buildable_to = false,
    stack_max = 64,
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3, building = 1},
        on_place = function(itemstack, placer, pointed_thing)
        local pn = placer:get_player_name()
        if pointed_thing.type ~= "node" then
            return itemstack
        end
        if minetest.is_protected(pointed_thing.above, pn) then
            return itemstack
        end
            local change = false
            local on_water = false
            local pos = pointed_thing.above
        -- verifier si il est dans l'eau ou a cotée
        if string.find(minetest.env:get_node(pointed_thing.above).name, "water_source")
        or  string.find(minetest.env:get_node(pointed_thing.above).name, "water_flowing") then
            on_water = true
        end
        for i=-1,1 do
            p = {x=pos.x+i, y=pos.y, z=pos.z}
            n = minetest.env:get_node(p)
            -- On verifie si il y a de l'eau
            if (n.name=="default:water_flowing") or (n.name == "default:water_source") then
                on_water = true
            end
        end
        for i=-1,1 do
            p = {x=pos.x, y=pos.y+i, z=pos.z}
            n = minetest.env:get_node(p)
            -- On verifie si il y a de l'eau
            if (n.name=="default:water_flowing") or (n.name == "default:water_source") then
                on_water = true
            end
        end
        for i=-1,1 do
            p = {x=pos.x, y=pos.y, z=pos.z+i}
            n = minetest.env:get_node(p)
            -- On verifie si il y a de l'eau
            if (n.name=="default:water_flowing") or (n.name == "default:water_source") then
                on_water = true
            end
        end

            if on_water == true then
                for i=-3,3 do
                    for j=-3,3 do
                        for k=-3,3 do
                            p = {x=pos.x+i, y=pos.y+j, z=pos.z+k}
                            n = minetest.env:get_node(p)
                            -- On Supprime l'eau
                            if (n.name=="default:water_flowing") or (n.name == "default:water_source")then
                                minetest.env:add_node(p, {name="air"})
                                change = true
                            end
                        end
                    end
                end
            end
            p = {x=pos.x, y=pos.y, z=pos.z}
            n = minetest.env:get_node(p)
            if change == true then
                minetest.env:add_node(pointed_thing.above, {name = "default:sponge_wet"})
            else
                minetest.env:add_node(pointed_thing.above, {name = "default:sponge"})
            end
        return itemstack

    end
})

minetest.register_node("default:sponge_wet", {
    description = "Wet Sponge",
    drawtype = "normal",
    tiles = {"default_sponge_wet.png"},
    paramtype = 'light',
    walkable = true,
    pointable = true,
    diggable = true,
    buildable_to = false,
    stack_max = 64,
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3, not_in_creative_inventory = 1},
})


minetest.register_node("default:ice", {
    description = "Ice",
    drawtype = "glasslike",
    tiles = {"default_ice.png"},
    is_ground_content = true,
    paramtype = "light",
    use_texture_alpha = true,
    stack_max = 64,
    groups = {cracky=3,oddly_breakable_by_hand=2, building = 1},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:packedice", {
    description = "Packed Ice",
    drawtype = "glasslike",
    tiles = {"default_ice_packed.png"},
    is_ground_content = true,
    paramtype = "light",
    use_texture_alpha = true,
    stack_max = 64,
    groups = {cracky=2, building = 1},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:snow", {
    description = "Snow",
    tiles = {"default_snow.png"},
    inventory_image = "default_snowball.png",
    wield_image = "default_snowball.png",
    is_ground_content = true,
    paramtype = "light",
    buildable_to = true,
    drawtype = "nodebox",
    stack_max = 16,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5,  0.5, -0.5+2/16, 0.5},
        },
    },
    groups = {crumbly=3,falling_node=1, misc = 1},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
    on_use = snow_shoot_snowball,
    on_construct = function(pos)
    pos.y = pos.y - 1
        if minetest.env:get_node(pos).name == "default:dirt_with_grass" then
            minetest.env:set_node(pos, {name="default:dirt_with_snow"})
        end
    end,
})

minetest.register_node("default:snowblock", {
    description = "Snow Block",
    tiles = {"default_snow.png"},
    is_ground_content = true,
    stack_max = 64,
    groups = {crumbly=3, building = 1},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
    drop = "default:snow 4",
})