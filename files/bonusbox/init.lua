-- Format of each item:
-- {item_name, minimum, maximum}

local items_ore = {
	{"default:diamond", 1, 2},
	{"default:emerald", 1, 2},
	{"default:gold_ingot", 2, 4},
	{"default:steel_ingot", 2, 8},
}

local items_food = {
	{"default:apple", 2, 8},
	{"mobs:pork", 1, 4},
	{"mobs:meat", 1, 4},
	{"mobs:chicken_cooked", 1, 4},
}

local items_material = {
	{"default:wood", 8, 64},
	{"default:cobble", 8, 64},
	{"default:obsidian", 2, 8},
	{"default:tree", 4, 16},
}

local item_spawn = function (pos, node)
	local item1 = items_food[math.random(#items_food)]
	item1 = item1[1] .. " " .. math.random(item1[2], item1[3])
	local item2 = items_ore[math.random(#items_ore)]
	item2 = item2[1] .. " " .. math.random(item2[2], item2[3])
	local item3 = items_material[math.random(#items_material)]
	item3 = item3[1] .. " " .. math.random(item3[2], item3[3])
	minetest.spawn_item({x = pos.x - 0.4, y = pos.y + 0.58, z = pos.z - 0.2}, item1)
	minetest.spawn_item({x = pos.x, y = pos.y + 0.58, z = pos.z}, item2)
	minetest.spawn_item({x = pos.x + 0.4, y = pos.y + 0.58, z = pos.z - 0.2}, item3)

	minetest.set_node(pos, {name = "bonusbox:chest_open", param2 = node.param2})
	minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "bonusbox:chest_cap", param2 = node.param2})
end

minetest.register_node("bonusbox:chest", {
		tiles = {
			"chest_top.png",
			"chest_bottom.png",
			"chest_right.png",
			"chest_left.png",
			"chest_back.png",
			"chest_front.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.438627, 0.187361}, -- NodeBox1
				{-0.483652, -0.441532, -0.483652, 0.483652, 0.110383, 0.172837}, -- NodeBox2
				{-0.5, 0.110383, -0.5, 0.5, 0.249814, 0.187361}, -- NodeBox3
				{-0.483652, 0.246909, -0.483652, 0.483652, 0.5, 0.169932}, -- NodeBox4
			}
		},
		groups = {choppy = 2, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults(),
		on_rightclick = item_spawn,
	})

minetest.register_node("bonusbox:chest_open", {
		tiles = {
			"chest_open_top.png",
			"chest_open_bottom.png",
			"chest_open_riqht.png",
			"chest_open_left.png",
			"chest_open_back.png",
			"chest_open_front.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		drop = "",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.438627, 0.187361}, -- NodeBox1
				{-0.483652, -0.444437, -0.483652, 0.483652, 0.110383, 0.169932}, -- NodeBox2
				{-0.5, 0.110383, -0.5, 0.5, 0.188813, 0.187361}, -- NodeBox3
				{-0.5, 0.188813, 0.172837, 0.5, 0.5, 0.248362}, -- NodeBox4
				{-0.484478, 0.206242, 0.242552, 0.484478, 0.5, 0.5}, -- NodeBox5
			}
		},
		groups = {choppy = 2, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults(),
	})

minetest.register_node("bonusbox:chest_cap", {
		tiles = {
			"chest_open_top.png",
			"chest_open_bottom.png",
			"chest_open_right_two.png",
			"chest_open_left_two.png",
			"chest_open_back_two.png",
			"chest_open_front_two.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		drop = "",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0.172236, 0.5, -0.128775, 0.249501}, -- NodeBox1
				{-0.485183, -0.5, 0.249501, 0.485183, -0.144871, 0.5}, -- NodeBox2
			}
		},
		groups = {attached_node = 1, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults(),
	})