walls = {}

local S = minetest.get_translator_auto(true)
walls.S = S

walls.register = function(wall_name, wall_desc, wall_texture_table, wall_mat, wall_sounds, not_in_cinv)
	-- inventory node, and pole-type wall start item
	minetest.register_node(wall_name, {
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed         = {-1/4,  -1/2, -1/4,   1/4,  1/2,  1/4},
			connect_front = {-3/16, -1/2, -1/2,   3/16, 3/8, -1/4},
			connect_left  = {-1/2,  -1/2, -3/16, -1/4,  3/8,  3/16},
			connect_back  = {-3/16, -1/2,  1/4,   3/16, 3/8,  1/2},
			connect_right = { 1/4,  -1/2, -3/16,  1/2,  3/8,  3/16}
		},
		collision_box = {
			type = "connected",
			fixed         = {-1/4, -1/2, -1/4,  1/4, 1/2 + 3/8,  1/4},
			connect_front = {-1/4, -1/2, -1/2,  1/4, 1/2 + 3/8, -1/4},
			connect_left  = {-1/2, -1/2, -1/4, -1/4, 1/2 + 3/8,  1/4},
			connect_back  = {-1/4, -1/2,  1/4,  1/4, 1/2 + 3/8,  1/2},
			connect_right = {1/4,  -1/2, -1/4,  1/2, 1/2 + 3/8,  1/4}
		},
		connects_to = {"group:wall", "group:stone", "group:fence"},
		paramtype = "light",
		is_ground_content = false,
		tiles = wall_texture_table,
		walkable = true,
		groups = {cracky = 3, wall = 1, stone = 2, not_in_creative_inventory = 1},
		sounds = wall_sounds,
		drop = wall_name .. "_inv",
		after_dig_node = function(pos, _, _, digger)
			local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
			local node_under = (minetest.get_node(pos_under).name):gsub("_full$", "")
			if minetest.get_item_group(node_under, "wall") == 1 and
					digger and digger:is_player() then
				minetest.set_node(pos_under, {name = node_under})
			end
		end
	})

	minetest.register_node(wall_name .. "_full", {
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed         = {-1/4,  -1/2, -1/4,   1/4,  1/2,  1/4},
			connect_front = {-3/16, -1/2, -1/2,   3/16, 1/2, -1/4},
			connect_left  = {-1/2,  -1/2, -3/16, -1/4,  1/2,  3/16},
			connect_back  = {-3/16, -1/2,  1/4,   3/16, 1/2,  1/2},
			connect_right = { 1/4,  -1/2, -3/16,  1/2,  1/2,  3/16},
		},
		connects_to = {"group:wall", "group:stone", "group:fence"},
		paramtype = "light",
		is_ground_content = false,
		tiles = wall_texture_table,
		groups = {cracky = 3, wall = 1, stone = 2, not_in_creative_inventory = 1},
		sounds = wall_sounds,
		drop = wall_name .. "_inv",
		after_dig_node = function(pos, _, _, digger)
			local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
			local node_under = (minetest.get_node(pos_under).name):gsub("_full$", "")
			if minetest.get_item_group(node_under, "wall") == 1 and
					digger and digger:is_player() then
				minetest.set_node(pos_under, {name = node_under})
			end
		end
	})

	minetest.register_node(wall_name .. "_inv", {
		description = wall_desc,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-1/4, -1/2, -1/4,   1/4, 1/2, 1/4},
				{-1/2, -1/2, -3/16, -1/4, 3/8, 3/16},
				{ 1/4, -1/2, -3/16,  1/2, 3/8, 3/16}
			}
		},
		paramtype = "light",
		tiles = wall_texture_table,
		groups = {cracky = 3, wall = 1, stone = 2, not_in_creative_inventory = not_in_cinv and 1 or 0},

		on_construct = function(pos)
			minetest.set_node(pos, {name = wall_name})
		end,
		after_place_node = function(pos)
			local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
			local pos_above = {x = pos.x, y = pos.y + 1, z = pos.z}
			local node_under = minetest.get_node(pos_under).name
			local node_above = minetest.get_node(pos_above).name
			if minetest.get_item_group(node_under, "wall") == 1 and
					minetest.get_item_group(node_under, "wall_not_full") ~= 1 then
				local node_under_can = node_under:gsub("_full$", "")
				minetest.set_node(pos_under, {name = node_under_can .. "_full"})
			end

			if minetest.get_item_group(node_above, "wall") == 1 and
					minetest.get_item_group(node_above, "wall_not_full") ~= 1 then
				minetest.set_node(pos, {name = wall_name .. "_full"})
			end
		end
	})

	if not not_in_cinv then
		-- crafting recipe
		minetest.register_craft({
			output = wall_name .. "_inv 6",
			recipe = {
				{"", "", ""},
				{wall_mat, wall_mat, wall_mat},
				{wall_mat, wall_mat, wall_mat}
			}
		})
	end
end

walls.register("walls:cobble", S("Cobblestone Wall"), {"default_cobble.png"},
		"default:cobble", default.node_sound_stone_defaults(), true)

walls.register("walls:mossycobble", S("Mossy Cobblestone Wall"), {"default_mossycobble.png"},
		"default:mossycobble", default.node_sound_stone_defaults(), true)

walls.register("walls:sandstone", S("Sandstone Wall"), {"default_sandstone_normal.png"},
		"default:sandstone", default.node_sound_stone_defaults())

walls.register("walls:redsandstone", S("Red Sandstone Wall"), {"default_redsandstone_normal.png"},
		"default:redsandstone", default.node_sound_stone_defaults())

-- Ice Wall
walls.register("walls:ice", S("Ice Wall"), {"default_ice.png"},
		"default:ice", default.node_sound_glass_defaults())

minetest.override_item("walls:ice", {
	use_texture_alpha = "blend",
	connects_to = {"group:wall", "group:fence", "default:ice", "default:packedice"},
	groups = {cracky = 3, wall = 1, not_in_creative_inventory = 1},
})

minetest.override_item("walls:ice_full", {
	use_texture_alpha = "blend",
	connects_to = {"group:wall", "group:fence", "default:ice", "default:packedice"},
	groups = {cracky = 3, wall = 1, not_in_creative_inventory = 1},
})

minetest.override_item("walls:ice_inv", {
	use_texture_alpha = "blend",
	groups = {cracky = 3, wall = 1},
})

-- Legacy, but more beautiful walls
dofile(minetest.get_modpath("walls") .. "/legacy.lua")
