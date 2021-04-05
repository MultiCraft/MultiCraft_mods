-- Namespace for functions

flowers = {}

local translator = minetest.get_translator
local S = translator and translator("flowers") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

-- Map Generation

dofile(minetest.get_modpath("flowers") .. "/mapgen.lua")

local min, random = math.min, math.random
local vadd, vsubtract = vector.add, vector.subtract

--
-- Flowers
--

-- Flower registration

local function add_simple_flower(name, desc, box, f_groups, inv)
	-- Common flowers' groups
	f_groups.snappy = 3
	f_groups.flower = 1
	f_groups.flora = 1
	f_groups.attached_node = 1
	f_groups.flammable = 1

	local image = "flowers_" .. name .. ".png"
	local inventory_image = inv and "flowers_" .. name .. "_inv.png" or image

	minetest.register_node("flowers:" .. name, {
		description = S(desc),
		drawtype = "plantlike",
		waving = 1,
		tiles = {image},
		inventory_image = inventory_image,
		wield_image = inventory_image,
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		groups = f_groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = box
		}
	})
end

local rose_size			= {-0.18, -0.5, -0.18, 0.18, 0.27, 0.18}
local tulip_size		= {-0.16, -0.5, -0.16, 0.16, 0.18, 0.16}
local houstonia_size	= {-0.23, -0.5, -0.23, 0.23, 0.06, 0.23}
local orchid_size		= {-0.31, -0.5, -0.31, 0.31, 0.37, 0.31}
local allium_size		= {-0.19, -0.5, -0.19, 0.19, 0.38, 0.19}
local oxeye_daisy_size	= {-0.19, -0.5, -0.19, 0.19, 0.33, 0.19}

flowers.datas = {
	-- Rose
	{
		"rose",
		"Red Rose",
		rose_size,
		{color_red = 1}
	},
	{
		"rose_burgundy",
		"Burgundy Rose",
		rose_size,
		{color_red = 1}
	},
	{
		"rose_pink",
		"Pink Rose",
		rose_size,
		{color_pink = 1}
	},
	{
		"rose_white",
		"White Rose",
		rose_size,
		{color_white = 1}
	},
	{
		"rose_yellow",
		"Yellow Rose",
		rose_size,
		{color_yellow = 1}
	},

	-- Tulip
	{
		"tulip",
		"Orange Tulip",
		tulip_size,
		{color_orange = 1}
	},
	{
		"tulip_burgundy",
		"Burgundy Tulip",
		tulip_size,
		{color_red = 1}
	},
	{
		"tulip_pink",
		"Pink Tulip",
		tulip_size,
		{color_pink = 1}
	},
	{
		"tulip_red",
		"Red Tulip",
		tulip_size,
		{color_red = 1}
	},
	{
		"tulip_violet",
		"Violet Tulip",
		tulip_size,
		{color_violet = 1}
	},
	{
		"tulip_white",
		"White Tulip",
		tulip_size,
		{color_white = 1}
	},
	{
		"tulip_yellow",
		"Yellow Tulip",
		tulip_size,
		{color_yellow = 1}
	},

	-- Dandelion
	{
		"dandelion_yellow",
		"Yellow Dandelion",
		{-0.25, -0.5, -0.25, 0.25, 0, 0.25},
		{color_yellow = 1}, true
	},

	-- Houstonia
	{
		"houstonia",
		"White Houstonia",
		houstonia_size,
		{color_white = 1}
	},
	{
		"houstonia_blue",
		"Blue Houstonia",
		houstonia_size,
		{color_blue = 1}
	},
	{
		"houstonia_pink",
		"Pink Houstonia",
		houstonia_size,
		{color_pink = 1}
	},


	-- Orchid
	{
		"orchid",
		"Blue Orchid",
		orchid_size,
		{color_blue = 1}
	},
	{
		"orchid_pink",
		"Pink Orchid",
		orchid_size,
		{color_pink = 1}
	},
	{
		"orchid_white",
		"White Orchid",
		orchid_size,
		{color_white = 1}
	},

	-- Allium
	{
		"allium",
		"Violet Allium",
		allium_size,
		{color_violet = 1}
	},
	{
		"allium_blue",
		"Blue Allium",
		allium_size,
		{color_blue = 1}
	},
	{
		"allium_white",
		"White Allium",
		allium_size,
		{color_white = 1}
	},
	{
		"allium_magenta",
		"Magenta Allium",
		allium_size,
		{color_magenta = 1}
	},

	-- Oxeye
	{
		"oxeye_daisy",
		"White Oxeye",
		oxeye_daisy_size,
		{color_white = 1}
	},
	{
		"oxeye_daisy_pink",
		"Pink Oxeye",
		oxeye_daisy_size,
		{color_pink = 1}
	},

	-- Sunflower
	{
		"sunflower",
		"Sunflower",
		{-0.33, -0.5, -0.33, 0.33, 0.95, 0.33},
		{color_yellow = 1}
	}
}

for _, item in pairs(flowers.datas) do
	add_simple_flower(unpack(item))
end

-- Set sunflower scale and drop
local sunflower_drops = {
	{items = {"flowers:sunflower"}}
}
if minetest.get_modpath("farming_plants") then
	sunflower_drops = {
		{items = {"flowers:sunflower"}, rarity = 2},
		{items = {"farming_plants:seed_sunflower"}}
	}
end

minetest.override_item("flowers:sunflower", {
	visual_scale = 1.5,
	drop = {
		max_items = 1,
		items = sunflower_drops
	}
})

-- Flower spread
-- Public function to enable override by mods

function flowers.flower_spread(pos, node)
	local under = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	-- Replace flora with dry shrub in desert sand and silver sand,
	-- as this is the only way to generate them.
	-- However, preserve grasses in sand dune biomes.
	if minetest.get_item_group(under.name, "sand") == 1 and
			under.name ~= "default:sand" then
		minetest.set_node(pos, {name = "default:dry_shrub"})
		return
	end

	if minetest.get_item_group(under.name, "soil") == 0 then
		return
	end

	local light = minetest.get_node_light(pos)
	if not light or light < 12 then
		return
	end

	local pos0 = vsubtract(pos, 4)
	local pos1 = vadd(pos, 4)
	-- Maximum flower density created by mapgen is 13 per 9x9 area.
	-- The limit of 7 below was tuned by in-game testing to result in a maximum
	-- flower density by ABM spread of 13 per 9x9 area.
	-- Warning: Setting this limit theoretically without in-game testing
	-- results in a maximum flower density by ABM spread that is far too high.
	if #minetest.find_nodes_in_area(pos0, pos1, "group:flora") > 7 then
		return
	end

	local soils = minetest.find_nodes_in_area_under_air(
		pos0, pos1, "group:soil")
	local num_soils = #soils
	if num_soils >= 1 then
		for _ = 1, min(3, num_soils) do
			local soil = soils[random(num_soils)]
			local soil_name = minetest.get_node(soil).name
			local soil_above = {x = soil.x, y = soil.y + 1, z = soil.z}
			light = minetest.get_node_light(soil_above)
			if light and light >= 12 and
					-- Only spread to same surface node
					soil_name == under.name and
					-- Desert sand is in the soil group
					soil_name ~= "default:redsand" then
					-- Spread also other flowers.
				local flower = node.name
				if random(3) == 1 then
					local fdata = flowers.datas
					flower = "flowers:" .. fdata[random(#fdata)][1]
				end

				minetest.set_node(soil_above, {name = flower})
			end
		end
	end
end

minetest.register_abm({
	label = "Flower spread",
	nodenames = {"group:flora"},
	interval = 20,
	chance = 200,
	action = function(...)
		flowers.flower_spread(...)
	end
})


--
-- Mushrooms
--

minetest.register_node("flowers:mushroom_red", {
	description = S"Red Mushroom",
	tiles = {"flowers_mushroom_red.png"},
	inventory_image = "flowers_mushroom_red.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1, food = 1, flora = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(2, nil, -5),
	selection_box = {
		type = "fixed",
		fixed = {-0.22, -0.5, -0.22, 0.22, 0.13, 0.22}
	}
})

minetest.register_node("flowers:mushroom_brown", {
	description = S"Brown Mushroom",
	tiles = {"flowers_mushroom_brown.png"},
	inventory_image = "flowers_mushroom_brown.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {food_mushroom = 1, snappy = 3, attached_node = 1, flammable = 1, food = 1, flora = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(3),
	selection_box = {
		type = "fixed",
		fixed = {-0.23, -0.5, -0.23, 0.23, 0.13, 0.23}
	}
})


-- Mushroom spread and death

function flowers.mushroom_spread(pos, node)
	if minetest.get_node_light(pos, 0.5) > 3 then
		if minetest.get_node_light(pos, nil) == 15 then
			minetest.remove_node(pos)
		end
		return
	end
	local positions = minetest.find_nodes_in_area_under_air(
		{x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
		{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
		{"group:soil", "group:tree"})
	if #positions == 0 then
		return
	end
	local pos2 = positions[random(#positions)]
	pos2.y = pos2.y + 1
	if minetest.get_node_light(pos2, 0.5) <= 3 then
		minetest.set_node(pos2, {name = node.name})
	end
end

minetest.register_abm({
	label = "Mushroom spread",
	nodenames = {"flowers:mushroom_brown", "flowers:mushroom_red"},
	interval = 15,
	chance = 150,
	action = function(...)
		flowers.mushroom_spread(...)
	end
})


--
-- Waterlily
--

minetest.register_node("flowers:waterlily", {
	description = S"Waterlily",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"flowers_waterlily.png"},
	inventory_image = "flowers_waterlily.png",
	wield_image = "flowers_waterlily.png",
	liquids_pointable = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -15/32, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -0.5, -7/16, 7/16, -15/32, 7/16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under)
		local def = minetest.registered_nodes[node.name]

		if def and def.on_rightclick then
			return def.on_rightclick(pointed_thing.under, node, placer,
					itemstack, pointed_thing) or itemstack
		end

		if def and def.liquidtype == "source" and
				minetest.get_item_group(node.name, "water") > 0 then
			local player_name = placer and placer:get_player_name() or ""
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "flowers:waterlily",
					param2 = random(0, 3)})
				if not minetest.is_creative_enabled(player_name) then
					itemstack:take_item()
				end
			end
		end

		return itemstack
	end
})

minetest.register_node("flowers:waterlily_flower", {
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"flowers_waterlily.png^flowers_waterlily_flower.png", "flowers_waterlily.png"},
	walkable = false,
	floodable = true,
	groups = {snappy = 3, flammable = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_leaves_defaults(),
	drop = "flowers:waterlily",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -31 / 64, -0.5, 0.5, -15 / 32, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -0.5, -7/16, 7/16, -15/32, 7/16}
	}
})


minetest.register_abm({
	label = "Waterlily Flower",
	nodenames = {
		"flowers:waterlily",
		"flowers:waterlily_flower"
	},
	interval = 20,
	chance = 3,
	catch_up = false,
	action = function(pos, node)
		local light = minetest.get_node_light(pos)
		if light >= 10 and node.name == "flowers:waterlily" then
			node.name = "flowers:waterlily_flower"
			minetest.swap_node(pos, node)
		elseif light < 10 and node.name == "flowers:waterlily_flower" then
			node.name = "flowers:waterlily"
			minetest.swap_node(pos, node)
		end
	end
})
