dofile(minetest.get_modpath("player_api") .. "/api.lua")

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

function player_api.is_enabled_for(name)
	return creative_mode_cache
end

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png", "blank.png", "blank.png", "blank.png"},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 0}, -- y = 79
		lay       = {x = 162, y = 166},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160}
	},
	stepheight = 0.6,
	eye_height = 1.47,
})

if creative_mode_cache then
	minetest.register_item(":", {
		type = "none",
		wield_image = "blank.png",
		tool_capabilities = {
			full_punch_interval = 0.5,
			damage_groups = {fleshy = 5},
		}
	})

	local digtime = 128
	local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 192}
	minetest.register_node("player_api:hand", {
		tiles = {"character.png"},
		wield_scale = {x = 1, y = 1, z = 0.7},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "hand.b3d",
		inventory_image = "blank.png",
		drop = "",
		node_placement_prediction = "",
		range = 10,
		tool_capabilities = {
			full_punch_interval = 0.5,
			max_drop_level = 3,
			groupcaps = {
				crumbly = caps,
				cracky  = caps,
				snappy  = caps,
				choppy  = caps,
				oddly_breakable_by_hand = caps,
			},
			damage_groups = {fleshy = 5},
		}
})
else
	minetest.register_item(":", {
		type = "none",
		wield_image = "blank.png",
		tool_capabilities = {
			full_punch_interval = 0.5,
			damage_groups = {fleshy = 1},
		}
	})

	minetest.register_node("player_api:hand", {
		tiles = {"character.png"},
		wield_scale = {x = 1, y = 1, z = 0.7},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "hand.b3d",
		inventory_image = "blank.png",
		drop = "",
		node_placement_prediction = "",
		tool_capabilities = {
			full_punch_interval = 0.5,
			max_drop_level = 0,
			groupcaps = {
				crumbly = {times = {[1]=5.0, [2]=3.0, [3]=0.7}, uses = 0, maxlevel = 1},
				snappy  = {times = {[1]=0.5, [2]=0.5, [3]=0.5}, uses = 0, maxlevel = 1},
				choppy  = {times = {[1]=6.0, [2]=4.0, [3]=3.0}, uses = 0, maxlevel = 1},
				cracky  = {times = {[1]=7.0, [2]=5.0, [3]=4.0}, uses = 0, maxlevel = 1},
				oddly_breakable_by_hand = {times = {[1]=3.5, [2]=2.0, [3]=0.7}, uses = 0}
		},
		damage_groups = {fleshy = 1},
	}
})
end

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)

	-- Temporary solution to the problem of loading yaw 'nul' on iOS
	if (player:get_look_horizontal() == 0) then
		player:set_look_horizontal(0.01)
	end

	player_api.player_attached[player:get_player_name()] = false
	player_api.set_model(player, "character.b3d")
	player:set_local_animation(
		{x = 0,   y = 0}, -- y = 79
		{x = 168, y = 187},
		{x = 189, y = 198},
		{x = 200, y = 219},
		30)

	player:hud_set_hotbar_itemcount(9)
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")

	player:get_inventory():set_stack("hand", 1, "player_api:hand")

	-- Temporary solution to the problem of loading yaw 'nul' on iOS
	if PLATFORM == "iOS" then
		minetest.after(5, function()
			if (player:get_look_horizontal() == 0) then
				minetest.request_shutdown()
			end
		end)
	end
end)

-- Items for the new player
if not creative_mode_cache and minetest.is_singleplayer() then
	minetest.register_on_newplayer(function (player)
			player:get_inventory():add_item("main", "default:sword_steel")
			player:get_inventory():add_item("main", "default:torch 8")
			player:get_inventory():add_item("main", "default:wood 64")
	end)
end

-- Drop items at death
minetest.register_on_dieplayer(function(player)
	local pos = player:get_pos()
	local inv = player:get_inventory()

	-- Drop inventory items
	for i = 1, inv:get_size("main") do
		local stack = inv:get_stack("main", i)
		minetest.item_drop(stack, nil, pos)
		inv:set_stack("main", i, nil)
	end

	-- Display death coordinates
	minetest.chat_send_player(player:get_player_name(), "Your last coordinates: "
		.. minetest.pos_to_string(vector.round(pos)))
end)
