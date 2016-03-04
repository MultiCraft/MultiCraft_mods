stairs = {}
stairs.mod = "redo"

function default.node_sound_wool_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "wool_coat_movement", gain = 1.0}
	table.dug = table.dug or
			{name = "wool_coat_movement", gain = 0.25}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	return table
end

stairs.wood = default.node_sound_wood_defaults()
stairs.dirt = default.node_sound_dirt_defaults()
stairs.stone = default.node_sound_stone_defaults()
stairs.glass = default.node_sound_glass_defaults()
stairs.leaves = default.node_sound_leaves_defaults()
stairs.wool = default.node_sound_wool_defaults() -- Xanadu only
--stairs.wool = stairs.leaves

-- Node will be called stairs:stair_<subname>
function stairs.register_stair(subname, recipeitem, groups, images, description, snds)
	minetest.register_node(":stairs:stair_" .. subname, {
		description = description.." Stair",
--		drawtype = "nodebox",
		drawtype = "mesh",
		mesh = "stairs_stair.obj",
		tiles = images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = snds,
--		node_box = {
--			type = "fixed",
--			fixed = {
--				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
--				{-0.5, 0, 0, 0.5, 0.5, 0.5},
--			},
--		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = minetest.rotate_node
	})

	minetest.register_craft({
		output = 'stairs:stair_' .. subname .. ' 6',
		recipe = {
			{recipeitem, recipeitem, recipeitem},
			{"", recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})
end

-- Node will be called stairs:slab_<subname>
function stairs.register_slab(subname, recipeitem, groups, images, description, snds)
	minetest.register_node(":stairs:slab_" .. subname, {
		description = description.." Slab",
		drawtype = "nodebox",
		tiles = images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = minetest.rotate_node
	})

	minetest.register_craft({
		output = 'stairs:slab_' .. subname .. ' 6',
		recipe = {
			{recipeitem, recipeitem, recipeitem},
		},
	})
end

-- Node will be called stairs:corner_<subname>
function stairs.register_corner(subname, recipeitem, groups, images, description, snds)
	minetest.register_node(":stairs:corner_" .. subname, {
		description = description.." Corner",
		drawtype = "nodebox",
		tiles = images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5},
			},
		},
		on_place = minetest.rotate_node
	})

	minetest.register_craft({
		output = 'stairs:corner_' .. subname .. ' 4',
		recipe = {
			{"", "", recipeitem},
			{"", recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem},
		},
	})
end

-- Node will be called stairs:invcorner_<subname>
function stairs.register_invcorner(subname, recipeitem, groups, images, description, snds)
	minetest.register_node(":stairs:invcorner_" .. subname, {
		description = description.." Inverted Corner",
		drawtype = "nodebox",
		tiles = images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0},
			},
		},
		on_place = minetest.rotate_node
	})

	minetest.register_craft({
		output = 'stairs:invcorner_' .. subname .. ' 8',
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})
end

-- Nodes will be called stairs:{stair,slab,corner,invcorner}_<subname>
function stairs.register_all(subname, recipeitem, groups, images, desc, snds)
	stairs.register_stair(subname, recipeitem, groups, images, desc, snds)
	stairs.register_slab(subname, recipeitem, groups, images, desc, snds)
	stairs.register_corner(subname, recipeitem, groups, images, desc, snds)
	stairs.register_invcorner(subname, recipeitem, groups, images, desc, snds)
end

-- Helper

local grp = {}

--= Default Minetest

stairs.register_all("wood", "default:wood",
	{choppy=2,oddly_breakable_by_hand=2,flammable=3},
	{"default_wood.png"},
	"Wooden",
	stairs.wood)

stairs.register_all("junglewood", "default:junglewood",
	{choppy=2,oddly_breakable_by_hand=2,flammable=3, not_in_craft_guide=1},
	{"default_junglewood.png"},
	"Jungle Wood",
	stairs.wood)

stairs.register_all("pine_wood", "default:pinewood",
	{choppy=2,oddly_breakable_by_hand=1,flammable=3, not_in_craft_guide=1},
	{"default_pine_wood.png"},
	"Pine Wood",
	stairs.wood)

stairs.register_all("cobble", "default:cobble",
	{cracky=3,stone=2},
	{"default_cobble.png"},
	"Cobble",
	stairs.stone)
		
stairs.register_all("mossy_cobble", "default:mossycobble",
	{cracky=3, stone=2, not_in_craft_guide=1},
	{"default_mossycobble.png"},
	"Mossy Cobble", 
	stairs.stone)

stairs.register_all("cloud", "default:cloud",
	{unbreakable=1, not_in_craft_guide=1},
	{"default_cloud.png"},
	"Cloud",
	stairs.wool)

stairs.register_all("coal", "default:coalblock",
	{cracky=3, not_in_craft_guide=1},
	{"default_coal_block.png"},
	"Coal",
	stairs.stone)

stairs.register_all("steel", "default:steelblock",
	{cracky=1,level=2, not_in_craft_guide=1},
	{"default_steel_block.png"},
	"Steel",
	stairs.stone)

stairs.register_all("gold", "default:goldblock",
	{cracky=1, not_in_craft_guide=1},
	{"default_gold_block.png"},
	"Gold",
	stairs.stone)

stairs.register_all("diamond", "default:diamondblock",
	{cracky=1,level=3, not_in_craft_guide=1},
	{"default_diamond_block.png"},
	"Diamond",
	stairs.stone)

stairs.register_all("stone", "default:stone",
	{cracky=3,stone=1, not_in_craft_guide=1},
	{"default_stone.png"},
	"Stone",
	stairs.stone)

stairs.register_all("mossycobble", "default:mossycobble",
	{cracky=3, not_in_craft_guide=1},
	{"default_mossycobble.png"},
	"Mossy Cobble",
	stairs.stone)

stairs.register_all("brick", "default:brick",
	{cracky=3, not_in_craft_guide=1},
	{"default_brick.png"},
	"Brick",
	stairs.stone)

stairs.register_all("sandstone", "default:sandstone",
	{crumbly=2,cracky=3, not_in_craft_guide=1},
	{"default_sandstone_bottom.png"},
	"Sandstone",
	stairs.stone)

stairs.register_all("glass", "default:glass",
	{cracky=3,oddly_breakable_by_hand=3, not_in_craft_guide=1},
	{"default_glass.png"},
	"Glass",
	stairs.glass)

stairs.register_all("obsidian", "default:obsidian",
	{cracky=1,level=2, unbreakable=1, not_in_craft_guide=1},
	{"default_obsidian.png"},
	"Obsidian",
	stairs.stone)

stairs.register_all("stonebrick", "default:stonebrick",
	{cracky=2,stone=1, not_in_craft_guide=1},
	{"default_stone_brick.png"},
	"Stone Brick",
	stairs.stone)

--= Farming Mod
if minetest.get_modpath("farming") then

stairs.register_all("straw", "farming:straw",
	{snappy = 3, flammable = 4, not_in_craft_guide = 1},
	{"farming_straw.png"},
	"Straw",
	stairs.leaves)

end

--= Mobs Mod

if mobs and mobs.mod and mobs.mod == "redo" then

grp = {crumbly = 3, flammable = 2, not_in_craft_guide = 1}

stairs.register_all("cheeseblock", "mobs:cheeseblock",
	grp,
	{"mobs_cheeseblock.png"},
	"Cheese Block",
	stairs.dirt)

stairs.register_all("honey_block", "mobs:honey_block",
	grp,
	{"mobs_honey_block.png"},
	"Honey Block",
	stairs.dirt)

end

--= Lapis Mod

if minetest.get_modpath("lapis") then

grp = {cracky = 3, not_in_craft_guide = 1}

stairs.register_all("lapis", "lapis:lapisblock",
	grp,
	{"lapis_block.png"},
	"Lapis",
	stairs.stone)

stairs.register_all("lapis_brick", "lapis:lapis_brick",
	grp,
	{"lapis_brick.png"},
	"Lapis Brick",
	stairs.stone)

stairs.register_all("lapis_cobble", "lapis:lapis_cobble",
	grp,
	{"lapis_cobble.png"},
	"Lapis Cobble",
	stairs.stone)

stairs.register_all("lazurite", "lapis:lazurite",
	grp,
	{"lapis_lazurite.png"},
	"Lazurite",
	stairs.stone)

stairs.register_all("lazurite_brick", "lapis:lazurite_brick",
	grp,
	{"lapis_lazurite_brick.png"},
	"Lazurite Brick",
	stairs.stone)

end

--= Homedecor Mod

if minetest.get_modpath("homedecor") then

local grp = {snappy = 3}

stairs.register_all("shingles_asphalt", "homedecor:shingles_asphalt",
	grp,
	{"homedecor_shingles_asphalt.png"},
	"Asphalt Shingle",
	stairs.leaves)

stairs.register_all("shingles_terracotta", "homedecor:roof_tile_terracotta",
	grp,
	{"homedecor_shingles_terracotta.png"},
	"Terracotta Shingle",
	stairs.leaves)

stairs.register_all("shingles_wood", "homedecor:shingles_wood",
	grp,
	{"homedecor_shingles_wood.png"},
	"Wooden Shingle",
	stairs.leaves)

end

--= Xanadu Mod

if minetest.get_modpath("xanadu") then

grp = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, not_in_craft_guide = 1}

minetest.register_alias("stairs:slab_stained_wood_brown", "stairs:slab_junglewood")
minetest.register_alias("stairs:stair_stained_wood_brown", "stairs:stair_junglewood")
minetest.register_alias("stairs:invcorner_stained_wood_brown", "stairs:invcorner_junglewood")
minetest.register_alias("stairs:corner_stained_wood_brown", "stairs:corner_junglewood")

stairs.register_all("stained_wood_white", "xanadu:stained_wood_white",
	grp,
	{"stained_wood_white.png"},
	"White Wooden",
	stairs.wood)

minetest.register_alias("stairs:slab_stained_wood_pink", "stairs:slab_acacia_wood")
minetest.register_alias("stairs:stair_stained_wood_pink", "stairs:stair_acacia_wood")
minetest.register_alias("stairs:invcorner_stained_wood_pink", "stairs:invcorner_acacia_wood")
minetest.register_alias("stairs:corner_stained_wood_pink", "stairs:corner_acacia_wood")

stairs.register_all("stained_wood_red", "xanadu:stained_wood_red",
	grp,
	{"stained_wood_red.png"},
	"Red Wooden",
	stairs.wood)

-- Decorative blocks

grp = {cracky = 3, not_in_craft_guide = 1}

stairs.register_all("stone1", "bakedclay:stone1",
	grp,
	{"stone1.png"},
	"Decorative Stone 1",
	stairs.stone)

stairs.register_all("stone2", "bakedclay:stone2",
	grp,
	{"stone2.png"},
	"Decorative Stone 2",
	stairs.stone)

stairs.register_all("stone3", "bakedclay:stone3",
	grp,
	{"stone3.png"},
	"Decorative Stone 3",
	stairs.stone)

stairs.register_all("stone4", "bakedclay:stone4",
	grp,
	{"stone4.png"},
	"Decorative Stone 4",
	stairs.stone)

stairs.register_all("stone5", "bakedclay:stone5",
	grp,
	{"stone5.png"},
	"Decorative Stone 5",
	stairs.stone)

stairs.register_all("stone6", "bakedclay:stone6",
	grp,
	{"stone6.png"},
	"Decorative Stone 6",
	stairs.stone)

stairs.register_all("sandstonebrick4", "bakedclay:sandstonebrick4",
	grp,
	{"sandstonebrick4.png"},
	"Decorative Sandstone 4",
	stairs.stone)

stairs.register_slab("desert_cobble1", "bakedclay:desert_cobble1",
	grp,
	{"desert_cobble1.png"},
	"Decorative desert cobble 1",
	stairs.stone)

stairs.register_slab("desert_cobble5", "bakedclay:desert_cobble5",
	grp,
	{"desert_cobble5.png"},
	"Decorative desert cobble 5",
	stairs.stone)

stairs.register_slab("desert_stone1", "bakedclay:desert_stone1",
	grp,
	{"desert_stone1.png"},
	"Decorative desert stone 1",
	stairs.stone)

stairs.register_slab("desert_stone3", "bakedclay:desert_stone3",
	grp,
	{"desert_stone3.png"},
	"Decorative desert stone 3",
	stairs.stone)

stairs.register_slab("desert_stone4", "bakedclay:desert_stone4",
	grp,
	{"desert_stone4.png"},
	"Decorative desert stone 4",
	stairs.stone)

stairs.register_slab("desert_stone5", "bakedclay:desert_stone5",
	grp,
	{"desert_stone5.png"},
	"Decorative desert stone 5",
	stairs.stone)

stairs.register_slab("red1", "bakedclay:red1",
	grp,
	{"baked_clay_red1.png"},
	"Decorative baked red clay 1",
	stairs.stone)

stairs.register_all("bred2", "bakedclay:red2",
	grp,
	{"baked_clay_red2.png"},
	"Decorative baked red clay 2",
	stairs.stone)

end

--= Baked Clay mod

if minetest.get_modpath("bakedclay") then

grp = {cracky = 3, not_in_craft_guide = 1}

stairs.register_all("bakedclay_white", "bakedclay:white",
	grp,
	{"baked_clay_white.png"},
	"Baked Clay White",
	stairs.stone)

stairs.register_all("bakedclay_grey", "bakedclay:grey",
	grp,
	{"baked_clay_grey.png"},
	"Baked Clay Grey",
	stairs.stone)

stairs.register_all("bakedclay_black", "bakedclay:black",
	grp,
	{"baked_clay_black.png"},
	"Baked Clay Black",
	stairs.stone)

stairs.register_all("bakedclay_red", "bakedclay:red",
	grp,
	{"baked_clay_red.png"},
	"Baked Clay Red",
	stairs.stone)

stairs.register_all("bakedclay_yellow", "bakedclay:yellow",
	grp,
	{"baked_clay_yellow.png"},
	"Baked Clay Yellow",
	stairs.stone)

stairs.register_all("bakedclay_green", "bakedclay:green",
	grp,
	{"baked_clay_green.png"},
	"Baked Clay Green",
	stairs.stone)

stairs.register_all("bakedclay_cyan", "bakedclay:cyan",
	grp,
	{"baked_clay_cyan.png"},
	"Baked Clay Cyan",
	stairs.stone)

stairs.register_all("bakedclay_blue", "bakedclay:blue",
	grp,
	{"baked_clay_blue.png"},
	"Baked Clay Blue",
	stairs.stone)

stairs.register_all("bakedclay_magenta", "bakedclay:magenta",
	grp,
	{"baked_clay_magenta.png"},
	"Baked Clay Magenta",
	stairs.stone)

stairs.register_all("bakedclay_orange", "bakedclay:orange",
	grp,
	{"baked_clay_orange.png"},
	"Baked Clay Orange",
	stairs.stone)

stairs.register_all("bakedclay_violet", "bakedclay:violet",
	grp,
	{"baked_clay_violet.png"},
	"Baked Clay Violet",
	stairs.stone)

stairs.register_all("bakedclay_brown", "bakedclay:brown",
	grp,
	{"baked_clay_brown.png"},
	"Baked Clay Brown",
	stairs.stone)

stairs.register_all("bakedclay_pink", "bakedclay:pink",
	grp,
	{"baked_clay_pink.png"},
	"Baked Clay Pink",
	stairs.stone)

stairs.register_all("bakedclay_dark_grey", "bakedclay:dark_grey",
	grp,
	{"baked_clay_dark_grey.png"},
	"Baked Clay Dark Grey",
	stairs.stone)

stairs.register_all("bakedclay_dark_green", "bakedclay:dark_green",
	grp,
	{"baked_clay_dark_green.png"},
	"Baked Clay Dark Green",
	stairs.stone)

end

--= Castle Mod

if minetest.get_modpath("castle") then

stairs.register_all("pavement", "castle:pavement",
	{cracky=2, not_in_craft_guide=1},
	{"castle_pavement_brick.png"},
	"Paving",
	stairs.stone)

stairs.register_all("dungeon_stone", "castle:dungeon_stone",
	{cracky=2, not_in_craft_guide=1},
	{"castle_dungeon_stone.png"},
	"Dungeon",
	stairs.stone)

stairs.register_all("stonewall", "castle:stonewall",
	{cracky=3, not_in_craft_guide=1},
	{"castle_stonewall.png"},
	"Castle Wall",
	stairs.stone)

end

--= Ethereal Mod

if minetest.get_modpath("ethereal") then

stairs.register_all("bamboo_floor", "ethereal:bamboo_floor",
	{snappy = 3, choppy = 3 , flammable=2, not_in_craft_guide=1},
	{"bamboo_floor.png"},
	"Bamboo",
	stairs.wood)

stairs.register_all("crystal_block", "ethereal:crystal_block",
	{cracky=1, level=2, not_in_craft_guide=1},
	{"crystal_block.png"},
	"Crystal Block",
	stairs.glass)

stairs.register_all("icebrick", "ethereal:icebrick",
	{crumbly=3, melts = 1, not_in_craft_guide=1},
	{"brick_ice.png"},
	"Ice Brick",
	stairs.glass)
		
stairs.register_all("snowbrick", "ethereal:snowbrick",
	{crumbly=3, melts = 1, not_in_craft_guide=1},
	{"brick_snow.png"},
	"Snow Brick",
	default.node_sound_dirt_defaults({
		footstep = {name="default_snow_footstep", gain=0.25},
		dug = {name="default_snow_footstep", gain=0.75},
	}))

stairs.register_all("dry_dirt", "ethereal:dry_dirt",
	{crumbly=3, not_in_craft_guide=1},
	{"ethereal_dry_dirt.png"},
	"Dry Dirt",
	stairs.dirt)

stairs.register_all("mushroom_trunk", "ethereal:mushroom_trunk",
	{choppy=2,oddly_breakable_by_hand=1,flammable=2, not_in_craft_guide=1},
	{"mushroom_trunk.png"},
	"Mushroom Trunk",
	stairs.wood)

stairs.register_all("mushroom", "ethereal:mushroom",
	{choppy=2,oddly_breakable_by_hand=1,flammable=2, not_in_craft_guide=1},
	{"mushroom_block.png"},
	"Mushroom Top",
	stairs.wood)

stairs.register_all("frost_wood", "ethereal:frost_wood",
	{choppy=2,oddly_breakable_by_hand=1,put_out_fire=1, not_in_craft_guide=1},
	{"frost_wood.png"},
	"Frost Wood",
	stairs.wood)

stairs.register_all("yellow_wood", "ethereal:yellow_wood",
	{choppy=2,oddly_breakable_by_hand=1,put_out_fire=1, not_in_craft_guide=1},
	{"yellow_wood.png"},
	"Healing Tree Wood",
	stairs.wood)

stairs.register_all("palm_wood", "ethereal:palm_wood",
	{choppy=2,oddly_breakable_by_hand=1,flammable=3, not_in_craft_guide=1},
	{"moretrees_palm_wood.png"},
	"Palm Wood",
	stairs.wood)

stairs.register_all("banana_wood", "ethereal:banana_wood",
	{choppy=2,oddly_breakable_by_hand=1,flammable=3, not_in_craft_guide=1},
	{"banana_wood.png"},
	"Banana Wood",
	stairs.wood)

stairs.register_all("willow_wood", "ethereal:willow_wood",
	{choppy=2,oddly_breakable_by_hand=1,flammable=3, not_in_craft_guide=1},
	{"willow_wood.png"},
	"Willow Wood",
	stairs.wood)

stairs.register_all("redwood_wood", "ethereal:redwood_wood",
	{choppy=2,oddly_breakable_by_hand=1,flammable=3, not_in_craft_guide=1},
	{"redwood_wood.png"},
	"Redwood Wood",
	stairs.wood)

stairs.register_all("acacia_wood", "ethereal:acacia_wood",
	{choppy=2,oddly_breakable_by_hand=1,flammable=3, not_in_craft_guide=1},
	{"moretrees_acacia_wood.png"},
	"Acacia Wood",
	stairs.wood)

end

--= Wool Mod

if minetest.get_modpath("wool") then

grp = {
	snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3,
	wool = 1, not_in_craft_guide = 1
}

stairs.register_all("wool_white", "wool:white",
	grp,
	{"wool_white.png"},
	"White Wool",
	stairs.wool)

stairs.register_all("wool_grey", "wool:grey",
	grp,
	{"wool_grey.png"},
	"Grey Wool",
	stairs.wool)

stairs.register_all("wool_black", "wool:black",
	grp,
	{"wool_black.png"},
	"Black Wool",
	stairs.wool)

stairs.register_all("wool_red", "wool:red",
	grp,
	{"wool_red.png"},
	"Red Wool",
	stairs.wool)

stairs.register_all("wool_yellow", "wool:yellow",
	grp,
	{"wool_yellow.png"},
	"Yellow Wool",
	stairs.wool)

stairs.register_all("wool_green", "wool:green",
	grp,
	{"wool_green.png"},
	"Green Wool", 
	stairs.wool)

stairs.register_all("wool_cyan", "wool:cyan",
	grp,
	{"wool_cyan.png"},
	"Cyan Wool", 
	stairs.wool)

stairs.register_all("wool_blue", "wool:blue",
	grp,
	{"wool_blue.png"},
	"Blue Wool", 
	stairs.wool)

stairs.register_all("wool_magenta", "wool:magenta",
	grp,
	{"wool_magenta.png"},
	"Magenta Wool", 
	stairs.wool)

stairs.register_all("wool_orange", "wool:orange",
	grp,
	{"wool_orange.png"},
	"Orange Wool",
	stairs.wool)

stairs.register_all("wool_violet", "wool:violet",
	grp,
	{"wool_violet.png"},
	"Violet Wool",
	stairs.wool)

stairs.register_all("wool_brown", "wool:brown",
	grp,
	{"wool_brown.png"},
	"Brown Wool",
	stairs.wool)

stairs.register_all("wool_pink", "wool:pink",
	grp,
	{"wool_pink.png"},
	"Pink Wool",
	stairs.wool)

stairs.register_all("wool_dark_grey", "wool:dark_grey",
	grp,
	{"wool_dark_grey.png"},
	"Dark Grey Wool", 
	stairs.wool)

stairs.register_all("wool_dark_green", "wool:dark_green",
	grp,
	{"wool_dark_green.png"},
	"Dark Green Wool", 
	stairs.wool)

end