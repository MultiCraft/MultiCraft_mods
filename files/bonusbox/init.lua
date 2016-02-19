local item_spawn = function(pos, node)
	minetest.spawn_item({x=pos.x-0.4,y=pos.y+0.58,z=pos.z-0.2}, "default:steel_ingot 2")
	minetest.spawn_item({x=pos.x,y=pos.y+0.58,z=pos.z}, "default:emerald")
	minetest.spawn_item({x=pos.x+0.4,y=pos.y+0.58,z=pos.z-0.2}, "default:diamond")
	
	minetest.set_node(pos, {name="bonusbox:chest_open", param2=node.param2})
	minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="bonusbox:chest_cap", param2=node.param2})
end

minetest.register_node("bonusbox:chest", {
	description = "Item Chest",
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
	groups = {choppy = 2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = item_spawn,
})

minetest.register_node("bonusbox:chest_open", {
	description = "Item Chest",
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
	groups = {oddly_breakable_by_hand=5, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("bonusbox:chest_cap", {
	description = "Chest Open",
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
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.172236, 0.5, -0.128775, 0.249501}, -- NodeBox1
			{-0.485183, -0.5, 0.249501, 0.485183, -0.144871, 0.5}, -- NodeBox2
		}
	},
	groups = {oddly_breakable_by_hand=5, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
})
