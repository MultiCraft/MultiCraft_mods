farming.register_plant("farming_addons:melon", {
	description = "Melon Seed",
	inventory_image = "farming_addons_melon_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4},
	place_param2 = 3
})

-- eat melons
minetest.override_item("farming_addons:melon", {
	on_use = minetest.item_eat(2)
})

-- MELON FRUIT - HARVEST
minetest.register_node("farming_addons:melon_fruit", {
	description = "Melon Fruit",
	tiles = {"farming_addons_melon_fruit_top.png", "farming_addons_melon_fruit_top.png", "farming_addons_melon_fruit_side.png", "farming_addons_melon_fruit_side.png", "farming_addons_melon_fruit_side.png", "farming_addons_melon_fruit_side.png"},
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	groups = {snappy = 3, flammable = 4, fall_damage_add_percent = -30},
	drop = {
		max_items = 7,
		items = {
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}, rarity = 2},
			{items = {"farming_addons:melon"}, rarity = 2},
			{items = {"farming_addons:melon"}, rarity = 3},
			{items = {"farming_addons:melon"}, rarity = 3}
		}
	},
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local parent = oldmetadata.fields.parent
		local parent_pos_from_child = minetest.string_to_pos(parent)
		local parent_node = nil

		-- make sure we have position
		if parent_pos_from_child
			and parent_pos_from_child ~= nil then
			parent_node = minetest.get_node(parent_pos_from_child)
		end

		-- tick parent if parent stem still exists
		if parent_node ~= nil
			and parent_node.name == "farming_addons:melon_8" then
			farming_addons.tick(parent_pos_from_child)
		end
	end
})

-- take over the growth from minetest_game farming from here
minetest.override_item("farming_addons:melon_8", {
	next_plant = "farming_addons:melon_fruit",
	on_timer = farming_addons.grow_block
})

-- replacement LBM for pre-nodetimer plants
minetest.register_lbm({
	name = "farming_addons:start_nodetimer_melon",
	nodenames = {"farming_addons:melon_8"},
	action = function(pos, node)
		farming_addons.tick_short(pos)
	end
})

-- Melon
minetest.register_craftitem("farming_addons:golden_melon", {
	description = "Golden Melon",
	inventory_image = "farming_addons_golden_melon.png",
	on_use = minetest.item_eat(10)
})

minetest.register_craft({
	output = "farming_addons:golden_melon",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "farming_addons:melon", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "farming_addons:melon_fruit",
	recipe = {
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"}
	}
})
