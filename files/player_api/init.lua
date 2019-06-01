dofile(minetest.get_modpath("player_api") .. "/api.lua")

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

function player_api.is_enabled_for(name)
	return creative_mode_cache
end

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png", "blank.png", "blank.png"},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 0}, -- y = 79
		lay       = {x = 162, y = 166},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160},
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
			full_punch_interval = 0.9,
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
			full_punch_interval = 0.9,
			max_drop_level = 0,
			groupcaps = {
				crumbly = {times = {[2]=3.00, [3]=0.70}, uses = 0, maxlevel = 1},
				snappy = {times ={[3]=0.40}, uses = 0, maxlevel = 1},
				choppy = {times = {[3]=3}, uses = 0, maxlevel = 1},
				cracky = {times = {[10]=10, [3]=7.5}, uses = 0, maxlevel = 1},
				oddly_breakable_by_hand = {times = {[0]=90.00, [1]=7.00, [2]=3.00, [3]=3*3.33, [4]=250, [5]=999999.0, [6]=0.5}, uses = 0, maxlevel = 5}
		},
		damage_groups = {fleshy = 1},
	}
})
end

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
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
end)
