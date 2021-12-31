local S = farming_addons.S

-- spawn snow golem
--[[local function pumpkin_on_construct(pos)
	if not minetest.get_modpath("mobs_npc") then return end

	for i = 1, 2 do
		if minetest.get_node({x = pos.x, y = pos.y - i, z=pos.z}).name ~= "default:snowblock" then
			return
		end
	end

	-- if 3 snow block are placed, this will make snow golem
	for i = 0, 2 do
		minetest.remove_node({x=pos.x,y=pos.y-i,z=pos.z})
	end

	minetest.add_entity({x = pos.x, y = pos.y - 1, z = pos.z}, "mobs_npc:snow_golem")
end]]

local drop = {}
for i = 1, 8 do
	local base_rarity = 9 - i
	drop[i] = {
		items = {
			{items = {"farming_addons:pumpkin_fruit"}, rarity = base_rarity * 2},
			{items = {"farming_addons:seed_pumpkin"}, rarity = base_rarity},
			{items = {"farming_addons:seed_pumpkin"}, rarity = base_rarity * 2}
		}
	}
end

farming.register_plant("farming_addons:pumpkin", {
	description = S"Pumpkin Seed",
	harvest_description = S"Pumpkin",
	inventory_image = "farming_addons_pumpkin_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland", "desert"},
	groups = {flammable = 4, food = 1},
	drop = drop
})

-- Pumpkin Fruit
local pumpkin_def = {
	description = S"Pumpkin",
	tiles = {
		"farming_addons_pumpkin_top.png^farming_addons_pumpkin_top_normal.png",
		"farming_addons_pumpkin_top.png", "farming_addons_pumpkin_side.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, flammable = 4, fall_damage_add_percent = -30, food = 1,
		falling_node = 1, not_cuttable = 1},
	sounds = default.node_sound_wood_defaults({
		dig = {name = "default_dig_oddly_breakable_by_hand"},
		dug = {name = "default_dig_choppy"}
	}),
	drop = "farming_addons:pumpkin_fruit",

	mesecon = {
		on_mvps_move = function(_, _, _, nodemeta)
			farming_addons.dig_node(nodemeta,
				"farming_addons:pumpkin_9", "farming_addons:pumpkin_6")
		end
	},

	after_dig_node = function(_, _, oldmetadata)
		farming_addons.dig_node(oldmetadata,
			"farming_addons:pumpkin_9", "farming_addons:pumpkin_6")
	end,

--	on_construct = pumpkin_on_construct
}

minetest.register_node("farming_addons:pumpkin_fruit", pumpkin_def)

local pumpkin_def_att = table.copy(pumpkin_def)
pumpkin_def_att.tiles = {
	"farming_addons_pumpkin_top.png^farming_addons_pumpkin_top_attached.png",
	"farming_addons_pumpkin_top.png", "farming_addons_pumpkin_side.png"
}
pumpkin_def_att.groups.not_in_creative_inventory = 1
minetest.register_node("farming_addons:pumpkin_fruit_attached", pumpkin_def_att)

minetest.override_item("farming_addons:pumpkin", {
	description = S"Pumpkin Slice"
})

-- take over the growth from farming from here
minetest.override_item("farming_addons:pumpkin_8", {
	next_stage = "farming_addons:pumpkin_9",
	next_plant = "farming_addons:pumpkin_fruit_attached",
	on_timer = function(pos)
		farming_addons.grow_block(pos, true, true)
	end
})

minetest.register_node("farming_addons:pumpkin_9", {
	visual = "mesh",
	mesh = "farming_addons_extra_face.b3d",
	tiles = {"farming_addons_pumpkin_9.png", "farming_addons_pumpkin_stem.png"},
	drawtype = "mesh",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = "blend",
	walkable = false,
	paramtype = "light",
	groups = {snappy = 3, flammable = 4, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1},
	drop = {
		items = {
			{items = {"farming_addons:seed_pumpkin"}},
			{items = {"farming_addons:seed_pumpkin"}, rarity = 2}
		}
	}
})

-- Backed Pumpkin Slice
minetest.register_craftitem("farming_addons:pumpkin_backed", {
	description = S"Pumpkin Backed Slice",
	inventory_image = "farming_addons_pumpkin_backed.png",
	on_use = minetest.item_eat(5),
	groups = {food = 1}
})

--
-- Recipes
--

-- Seed
minetest.register_craft({
	output = "farming_addons:seed_pumpkin 2",
	recipe = {{"farming_addons:pumpkin"}}
})

-- Block
minetest.register_craft({
	output = "farming_addons:pumpkin_fruit",
	recipe = {
		{"farming_addons:pumpkin", "farming_addons:pumpkin", "farming_addons:pumpkin"},
		{"farming_addons:pumpkin", "farming_addons:pumpkin", "farming_addons:pumpkin"},
		{"farming_addons:pumpkin", "farming_addons:pumpkin", "farming_addons:pumpkin"}
	}
})

minetest.register_craft({
	output = "farming_addons:pumpkin 9",
	recipe = {
		{"farming_addons:pumpkin_fruit"}
	}
})

-- Backed Pumpkin Slice
minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:pumpkin_backed",
	recipe = "farming_addons:pumpkin"
})

-- Fuel
minetest.register_craft({
	type = "fuel",
	recipe = "farming_addons:pumpkin_fruit",
	burntime = 20
})

--
-- Generation
--

minetest.register_decoration({
	name = "default:grass",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 80,
	fill_ratio = 0.0001,
	y_max = 40,
	y_min = 1,
	decoration = "farming_addons:pumpkin_fruit"
})

-- MVPS stopper
if mesecon and mesecon.register_mvps_stopper then
	mesecon.register_mvps_stopper("farming_addons:pumpkin_9")
end
