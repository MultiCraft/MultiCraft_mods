-- Format of each item:
-- {item_name, minimum, maximum}

local items_ore = {
	{"default:diamond", 1, 1},
	{"default:emerald", 1, 1},
	{"default:gold_ingot", 1, 3},
	{"default:steel_ingot", 1, 3}
}

local items_food = {
	{"default:apple", 2, 6},
	{"mobs:pork", 1, 3},
	{"mobs:meat", 1, 3},
	{"mobs:chicken_cooked", 1, 3}
}

local items_material = {
	{"default:wood", 8, 64},
	{"default:cobble", 8, 64},
	{"default:obsidian", 2, 8},
	{"default:tree", 4, 16}
}

local random = math.random
local item_spawn = function(pos, node)
	local item1 = items_food[random(#items_food)]
	item1 = item1[1] .. " " .. random(item1[2], item1[3])
	local item2 = items_ore[random(#items_ore)]
	item2 = item2[1] .. " " .. random(item2[2], item2[3])
	local item3 = items_material[random(#items_material)]
	item3 = item3[1] .. " " .. random(item3[2], item3[3])
	minetest.spawn_item({x = pos.x - 0.4, y = pos.y + 0.58, z = pos.z - 0.2}, item1)
	minetest.spawn_item({x = pos.x, y = pos.y + 0.58, z = pos.z}, item2)
	minetest.spawn_item({x = pos.x + 0.4, y = pos.y + 0.58, z = pos.z - 0.2}, item3)

	minetest.set_node(pos, {name = "bonusbox:chest_open", param2 = node.param2})
	minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "bonusbox:chest_cap", param2 = node.param2})
end

minetest.register_node("bonusbox:chest", {
	tiles = {
		"chest_top.png",  "chest_top.png^[transformFY",
		"chest_side.png", "chest_side.png^[transformFX",
		"chest_back.png", "chest_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	drop = "",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4386, 0.1874},
			{-0.4837, -0.4415, -0.4837, 0.4837, 0.1104, 0.1729},
			{-0.5, 0.1104, -0.5, 0.5, 0.2498, 0.1874},
			{-0.4837, 0.2469, -0.4837, 0.4837, 0.5, 0.1699}
		}
	},
	groups = {choppy = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),

	on_rightclick = item_spawn
})

minetest.register_node("bonusbox:chest_open", {
	tiles = {
		"chest_open_top.png",  "chest_open_bottom.png",
		"chest_open_side.png", "chest_open_side.png^[transformFX",
		"chest_open_back.png", "chest_open_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	drop = "",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4386, 0.1874},
			{-0.4837, -0.4444, -0.4837, 0.4837, 0.1109, 0.1699},
			{-0.5, 0.1104, -0.5, 0.5, 0.1888, 0.1874},
			{-0.5, 0.1888, 0.1728, 0.5, 0.5, 0.2484},
			{-0.4845, 0.2062, 0.2426, 0.4845, 0.5, 0.5}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4386, 0.1874},
			{-0.4837, -0.4444, -0.4837, 0.4837, 0.1104, 0.1699},
			{-0.5, 0.1104, -0.5, 0.5, 0.1888, 0.1874}
		}
	},
	groups = {choppy = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("bonusbox:chest_cap", {
	tiles = {
		"chest_open_top.png",      "chest_open_bottom.png",
		"chest_open_side_two.png", "chest_open_side_two.png^[transformFX",
		"chest_open_back_two.png", "chest_open_front_two.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	drop = "",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.1722, 0.5, -0.1288, 0.25},
			{-0.4852, -0.5, 0.25, 0.4852, -0.1449, 0.5}
		}
	},
	selection_box = {
		type = "fixed"
	},
	groups = {attached_node = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:sand", "default:dirt_with_snow", "default:gravel",
 		"default:snowblock", "default:dirt_with_grass", "default:redsand",
		"default:redsandstone", "default:dirt_with_dry_grass"},
	sidelen = 80,
	fill_ratio = 0.0001,
	y_max = 31000,
	y_min = 1,
	decoration = {"bonusbox:chest"}
})
