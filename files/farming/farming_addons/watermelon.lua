local S = farming_addons.S

farming.register_plant("farming_addons:melon", {
	description = S"Watermelon Seed",
	harvest_description = S"Watermelon",
	inventory_image = "farming_addons_watermelon_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4, food = 1}
})

-- eat melons
minetest.override_item("farming_addons:melon", {
	description = S"Watermelon Slice",
	on_use = minetest.item_eat(2)
})

-- Watermelon Fruit
minetest.register_node("farming_addons:melon_fruit", {
	description = S"Watermelon",
	tiles = {
		"farming_addons_watermelon_fruit_top.png", "farming_addons_watermelon_fruit_top.png",
		"farming_addons_watermelon_fruit_side.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, flammable = 4, fall_damage_add_percent = -30, food = 1,
		not_cuttable = 1, falling_node = 1},
	sounds = default.node_sound_wood_defaults({
		dig = {name = "default_dig_oddly_breakable_by_hand"},
		dug = {name = "default_dig_choppy"}
	}),
	drop = {
		items = {
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}, rarity = 2},
			{items = {"farming_addons:melon"}, rarity = 2},
			{items = {"farming_addons:melon"}, rarity = 3},
			{items = {"farming_addons:melon"}, rarity = 4}
		}
	},

	mesecon = {
		on_mvps_move = function(_, _, _, nodemeta)
			farming_addons.dig_node(nodemeta,
				"farming_addons:melon_9", "farming_addons:melon_6")
		end
	},

	after_dig_node = function(_, _, oldmetadata)
		farming_addons.dig_node(oldmetadata,
			"farming_addons:melon_9", "farming_addons:melon_6")
	end
})

-- take over the growth from farming from here
minetest.override_item("farming_addons:melon_8", {
	next_stage = "farming_addons:melon_9",
	next_plant = "farming_addons:melon_fruit",
	on_timer = function(pos)
		farming_addons.grow_block(pos, true, true)
	end
})

minetest.register_node("farming_addons:melon_9", {
	visual = "mesh",
	mesh = "farming_addons_extra_face.b3d",
	tiles = {"farming_addons_melon_9.png", "farming_addons_watermelon_stem.png"},
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
			{items = {"farming_addons:seed_melon"}},
			{items = {"farming_addons:seed_melon"}, rarity = 2}
		}
	}
})

-- Golden Melon
minetest.register_craftitem("farming_addons:melon_golden", {
	description = S"Golden Watermelon Slice",
	inventory_image = "farming_addons_melon_golden.png",
	on_use = minetest.item_eat(10),
	groups = {food = 1}
})

-- Golden Watermelon
minetest.register_node("farming_addons:melon_fruit_golden", {
	description = S"Golden Watermelon",
	tiles = {
		"farming_addons_watermelon_golden_fruit_top.png", "farming_addons_watermelon_golden_fruit_top.png",
		"farming_addons_watermelon_golden_fruit_side.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 1, plant = 1, not_cuttable = 1, falling_node = 1},
	sounds = default.node_sound_stone_defaults()
})

--
-- Recipes
--

-- Seed
minetest.register_craft({
	output = "farming_addons:seed_melon 2",
	recipe = {{"farming_addons:melon"}}
})

-- Golden Melon
minetest.register_craft({
	output = "farming_addons:melon_golden",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "farming_addons:melon", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}
	}
})

-- Block
minetest.register_craft({
	output = "farming_addons:melon_fruit",
	recipe = {
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"}
	}
})

minetest.register_craft({
	output = "farming_addons:melon 9",
	recipe = {
		{"farming_addons:melon_fruit"}
	}
})

-- Golden Block
minetest.register_craft({
	output = "farming_addons:melon_fruit_golden",
	recipe = {
		{"farming_addons:melon_golden", "farming_addons:melon_golden", "farming_addons:melon_golden"},
		{"farming_addons:melon_golden", "farming_addons:melon_golden", "farming_addons:melon_golden"},
		{"farming_addons:melon_golden", "farming_addons:melon_golden", "farming_addons:melon_golden"}
	}
})

minetest.register_craft({
	output = "farming_addons:melon_golden 9",
	recipe = {
		{"farming_addons:melon_fruit_golden"}
	}
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
	biomes = {"rainforest"},
	y_max = 40,
	y_min = 1,
	decoration = "farming_addons:melon_fruit"
})

-- MVPS stopper
if mesecon and mesecon.register_mvps_stopper then
	mesecon.register_mvps_stopper("farming_addons:melon_9")
end
