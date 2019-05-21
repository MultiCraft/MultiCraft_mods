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
stairs.metal = default.node_sound_metal_defaults()
stairs.wool = stairs.leaves


-- cache creative
local creative = minetest.settings:get_bool("creative_mode")
function is_creative_enabled_for(name)
	if creative or minetest.check_player_privs(name, {creative = true}) then
		return true
	end
	return false
end


-- process textures
local set_textures = function(images)
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
				align_style = "world",
			}
		elseif image.backface_culling == nil then -- override using any other value
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	return stair_images
end


-- placement helper
local stair_place = function(itemstack, placer, pointed_thing, stair_node)

	-- if sneak pressed then use param2 in node pointed at when placing
	if placer:is_player() and placer:get_player_control().sneak then

		local name  = placer:get_player_name()
		local pos_a = pointed_thing.above
		local node_a = minetest.get_node(pos_a)
		local def_a = minetest.registered_nodes[node_a.name]

		if not def_a.buildable_to
		or minetest.is_protected(pos_a, name) then
			return itemstack
		end

		local pos_u = pointed_thing.under
		local node_u = minetest.get_node(pos_u)

		if minetest.get_item_group(node_u.name, "stair") > 0
		or minetest.get_item_group(node_u.name, "slab") > 0 then

			minetest.set_node(pos_a, {name = stair_node, param2 = node_u.param2})

			if not is_creative_enabled_for(name) then
				itemstack:take_item()
			end

			return itemstack
		end
	end

	core.rotate_and_place(itemstack, placer, pointed_thing,
			is_creative_enabled_for(placer:get_player_name()),
			{invert_wall = placer:get_player_control().sneak})

	return itemstack
end


-- Node will be called stairs:stair_<subname>
function stairs.register_stair(subname, recipeitem, groups, images, description, snds, alpha)
	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:stair_" .. subname, {
		description = description.." Stair",
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:stair_" .. subname)
		end,
	})

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- stair recipes
	minetest.register_craft({
		output = "stairs:stair_" .. subname .. " 6",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname},
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname},
		},
	})
end


-- Node will be called stairs:slab_<subname>
function stairs.register_slab(subname, recipeitem, groups, images, description, snds, alpha)
	local slab_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.slab = 1

	minetest.register_node(":stairs:slab_" .. subname, {
		description = description.." Slab",
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:slab_" .. subname)
		end,
	})

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- slab recipe
	minetest.register_craft({
		output = "stairs:slab_" .. subname .. " 6",
		recipe = {
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- slab to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slab_" .. subname},
			{"stairs:slab_" .. subname},
		},
	})
end


-- Node will be called stairs:stair_outer_<subname>
function stairs.register_stair_outer(subname, recipeitem, groups, images, description, snds, alpha)
	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:stair_outer_" .. subname, {
		description = "Outer " .. description .. " Stair",
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:stair_outer_" .. subname)
		end,
	})

	-- add alias for old stairs redo name
	minetest.register_alias("stairs:corner_" .. subname, "stairs:stair_outer_" .. subname)

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- corner stair recipe
	minetest.register_craft({
		output = "stairs:stair_outer_" .. subname .. " 6",
		recipe = {
			{"", "", ""},
			{"", recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- corner stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 2",
		recipe = {
			{"stairs:stair_outer_" .. subname, "stairs:stair_outer_" .. subname},
			{"stairs:stair_outer_" .. subname, "stairs:stair_outer_" .. subname},
		},
	})
end

-- compatibility function for previous stairs:corner_<subname>
function stairs.register_corner(subname, recipeitem, groups, images, description, snds, alpha)
	stairs.register_stair_outer(subname, recipeitem, groups, images, description, snds, alpha)
end


-- Node will be called stairs:stair_inner_<subname>
function stairs.register_stair_inner(subname, recipeitem, groups, images, description, snds, alpha)

	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:stair_inner_" .. subname, {
		description = "Inner " .. description .. " Stair",
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:stair_inner_" .. subname)
		end,
	})

	-- add alias for old stairs redo name
	minetest.register_alias("stairs:invcorner_" .. subname, "stairs:stair_inner_" .. subname)

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- inside corner stair recipe
	minetest.register_craft({
		output = "stairs:stair_inner_" .. subname .. " 9",
		recipe = {
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- inside corner stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_inner_" .. subname, "stairs:stair_inner_" .. subname},
			{"stairs:stair_inner_" .. subname, "stairs:stair_inner_" .. subname},
		},
	})
end

-- compatibility function for previous stairs:invcorner_<subname>
function stairs.register_invcorner(subname, recipeitem, groups, images, description, snds, alpha)
	stairs.register_stair_inner(subname, recipeitem, groups, images, description, snds, alpha)
end


-- Node will be called stairs:slope_<subname>
function stairs.register_slope(subname, recipeitem, groups, images, description, snds, alpha)
	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:slope_" .. subname, {
		description = description .. " Slope",
		drawtype = "mesh",
		mesh = "stairs_slope.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
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
		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:slope_" .. subname)
		end,
	})

	-- slope recipe
	minetest.register_craft({
		output = "stairs:slope_" .. subname .. " 6",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
		},
	})

	-- slope to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_" .. subname, "stairs:slope_" .. subname},
		},
	})
end


-- Nodes will be called stairs:{stair,slab}_<subname>
function stairs.register_stair_and_slab(subname, recipeitem, groups, images,
		desc_stair, desc_slab, sounds, alpha)
	stairs.register_stair(subname, recipeitem, groups, images, desc_stair, sounds, alpha)
	stairs.register_slab(subname, recipeitem, groups, images, desc_slab, sounds, alpha)
end

-- Nodes will be called stairs:{stair,slab,corner,invcorner,slope}_<subname>
function stairs.register_all(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_stair(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_slab(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_corner(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_invcorner(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_slope(subname, recipeitem, groups, images, desc, snds, alpha)
end


local grp = {} -- Helper

--= Default

-- Wood types

stairs.register_all("wood", "default:wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_wood.png"},
	"Wooden",
	stairs.wood)

stairs.register_all("junglewood", "default:junglewood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_junglewood.png"},
	"Jungle Wood",
	stairs.wood)

stairs.register_all("pine_wood", "default:pinewood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"default_pine_wood.png"},
	"Pine Wood",
	stairs.wood)

stairs.register_all("acacia_wood", "default:acacia_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"default_acacia_wood.png"},
	"Acacia Wood",
	stairs.wood)
-- Stone types

stairs.register_all("stone", "default:stone",
	{cracky=3,stone=1, },
	{"default_stone.png"},
	"Stone",
	stairs.stone)

stairs.register_all("stonebrick", "default:stonebrick",
	{cracky = 2},
	{"default_stone_brick.png"},
	"Stone Brick",
	stairs.stone)

stairs.register_all("cobble", "default:cobble",
	{cracky = 3},
	{"default_cobble.png"},
	"Cobble",
	stairs.stone)

stairs.register_all("mossycobble", "default:mossycobble",
	{cracky = 3},
	{"default_mossycobble.png"},
	"Mossy Cobble",
	stairs.stone)

minetest.register_alias("stairs:mossy_cobble", "stairs:stair_mossycobble")

-- Sandstone types

stairs.register_all("sandstone", "default:sandstone",
	{crumbly = 1, cracky = 3},
	{"default_sandstone_normal.png"},
	"Sandstone",
	stairs.stone)

-- Obsidian

stairs.register_all("obsidian", "default:obsidian",
	{cracky = 1, level = 2},
	{"default_obsidian.png"},
	"Obsidian",
	stairs.stone)

-- Ores

stairs.register_all("coal", "default:coalblock",
	{cracky = 3},
	{"default_coal_block.png"},
	"Coal",
	stairs.stone)

stairs.register_all("steelblock", "default:steelblock",
	{cracky = 1, level = 2},
	{"default_steel_block.png"},
	"Steel",
	stairs.metal)

minetest.register_alias("stairs:stair_steel", "stairs:stair_steelblock")
minetest.register_alias("stairs:slab_steel", "stairs:slab_steelblock")
minetest.register_alias("stairs:corner_steel", "stairs:corner_steelblock")

stairs.register_all("goldblock", "default:goldblock",
	{cracky = 1},
	{"default_gold_block.png"},
	"Gold",
	stairs.metal)

minetest.register_alias("stairs:stair_gold", "stairs:stair_goldblock")
minetest.register_alias("stairs:slab_gold", "stairs:slab_goldblock")
minetest.register_alias("stairs:corner_gold", "stairs:corner_goldblock")

stairs.register_all("diamondblock", "default:diamondblock",
	{cracky = 1, level=3},
	{"default_diamond_block.png"},
	"Diamond",
	stairs.stone)

minetest.register_alias("stairs:stair_diamond", "stairs:stair_diamondblock")
minetest.register_alias("stairs:slab_diamond", "stairs:slab_diamondblock")
minetest.register_alias("stairs:corner_diamond", "stairs:corner_diamondblock")

-- Glass types

stairs.register_all("glass", "default:glass",
	{cracky = 3, oddly_breakable_by_hand = 3},
	{"default_glass.png"},
	"Glass",
	stairs.glass)


-- Brick, Snow and Ice

stairs.register_all("brick", "default:brick",
	{cracky = 3},
	{"default_brick.png"},
	"Brick",
	stairs.stone)

stairs.register_all("snowblock", "default:snowblock",
	{crumbly = 3, puts_out_fire = 1, cools_lava = 1, snowy = 1},
	{"default_snow.png"},
	"Snow Block",
	default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}))

stairs.register_all("ice", "default:ice",
	{cracky = 3, puts_out_fire = 1, cools_lava = 1},
	{"default_ice.png"},
	"Ice",
	default.node_sound_glass_defaults())


local colours = {
	{"black",      "Black",      "#000000b0"},
	{"blue",       "Blue",       "#015dbb70"},
	{"brown",      "Brown",      "#a78c4570"},
	{"cyan",       "Cyan",       "#01ffd870"},
	{"dark_green", "Dark Green", "#005b0770"},
	{"dark_grey",  "Dark Grey",  "#303030b0"},
	{"green",      "Green",      "#61ff0170"},
	{"grey",       "Grey",       "#5b5b5bb0"},
	{"magenta",    "Magenta",    "#ff05bb70"},
	{"orange",     "Orange",     "#ff840170"},
	{"pink",       "Pink",       "#ff65b570"},
	{"red",        "Red",        "#ff000070"},
	{"violet",     "Violet",     "#2000c970"},
	{"white",      "White",      "#abababc0"},
	{"yellow",     "Yellow",     "#e3ff0070"},
}

--= Farming
if minetest.get_modpath("farming") then

stairs.register_all("straw", "farming:straw",
	{snappy = 3, flammable = 4},
	{"farming_straw_side.png"},
	"Straw",
	stairs.leaves)

end

--= Mobs

if minetest.registered_nodes["mobs:cheeseblock"] then

grp = {crumbly = 3, flammable = 2}

stairs.register_all("cheeseblock", "mobs:cheeseblock",
	grp,
	{"mobs_cheeseblock.png"},
	"Cheese Block",
	stairs.dirt)

end

--= Lapis

stairs.register_all("lapis_block", "lapis:lapis_block",
	{cracky = 3},
	{"default_lapis_block.png"},
	"Lapis",
	stairs.stone)

minetest.register_alias("stairs:lapis", "stairs:lapis_block")
minetest.register_alias("stairs:lapisblock", "stairs:lapis_block")

--= Wool

if minetest.get_modpath("wool") then

for i = 1, #colours, 1 do

stairs.register_all("wool_" .. colours[i][1], "wool:" .. colours[i][1],
	{snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
	{"wool_" .. colours[i][1] .. ".png"},
	colours[i][2] .. " Wool",
	stairs.wool)

end

end
