player_api = {}

dofile(minetest.get_modpath("player_api") .. "/api.lua")
dofile(minetest.get_modpath("player_api") .. "/wieldview.lua")

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

-- Default player appearance
local b = "blank.png"
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png", b, b, b, b},
	animations = {
		-- Standard animations.
		stand           = {x = 0,   y =   0}, -- y = 79
		sit             = {x = 81,  y = 160},
		lay             = {x = 162, y = 166},
		walk            = {x = 168, y = 187},
		mine            = {x = 189, y = 198},
		walk_mine       = {x = 200, y = 219},
		sneak_stand     = {x = 221, y = 261},
		sneak_walk      = {x = 262, y = 282},
		sneak_mine      = {x = 283, y = 293},
		sneak_walk_mine = {x = 294, y = 314}
	},
	stepheight = 0.6,
	eye_height = 1.47
})

-- Hand definition
player_api.hand = {
	wield_scale = {x = 1, y = 1, z = 0.7},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "hand.b3d",
	tiles = {"character.png"},
	inventory_image = b,
	drop = "",
	node_placement_prediction = ""
}

local hand = player_api.hand
if creative_mode_cache then
	local digtime = 128
	local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 192}

	hand.range = 10
	hand.tool_capabilities = {
		full_punch_interval = 0.5,
		max_drop_level = 3,
		groupcaps = {
			crumbly = caps,
			cracky  = caps,
			snappy  = caps,
			choppy  = caps,
			oddly_breakable_by_hand = caps
		},
		damage_groups = {fleshy = 5}
	}
else
	hand.tool_capabilities = {
		full_punch_interval = 0.5,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1]=5.0, [2]=3.0, [3]=2.0}, uses = 0, maxlevel = 1},
			snappy  = {times = {[1]=0.5, [2]=0.5, [3]=0.5}, uses = 0, maxlevel = 1},
			choppy  = {times = {[1]=6.0, [2]=4.0, [3]=3.0}, uses = 0, maxlevel = 1},
			cracky  = {times = {[1]=7.0, [2]=5.0, [3]=4.0}, uses = 0, maxlevel = 1},
			oddly_breakable_by_hand = {times = {[1]=3.5, [2]=2.0, [3]=0.7}, uses = 0}
		},
		damage_groups = {fleshy = 1}
	}
end

minetest.register_node("player_api:hand", hand)

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local inv = player:get_inventory()

	player_api.player_attached[name] = false
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
	inv:set_size("main", 36)

	local gender = player:get_attribute("gender")
	local color  = player:get_attribute("color")
	local skin   = player:get_attribute("skin")

	gender = (gender and gender == "female" and "_female")   or ""
	color  = (color  and color  == "yes"    and "_dark")     or ""
	skin   = (skin   and skin   ~= "1"      and "_" .. skin) or ""

	local texture = "character" .. gender .. color .. skin .. ".png"
	player_api.set_textures(player, texture)
	inv:set_size("hand", 1)
	inv:set_stack("hand", 1, "player_api:hand" .. gender .. color)
end)

-- Items for the new player
if not creative_mode_cache and minetest.is_singleplayer() then
	minetest.register_on_newplayer(function(player)
		player:get_inventory():add_item("main", "default:sword_steel")
		player:get_inventory():add_item("main", "default:torch 8")
		player:get_inventory():add_item("main", "default:wood 32")
	end)
end

-- Drop items at death
minetest.register_on_dieplayer(function(player)
	local pos = player:get_pos()
	local inv = player:get_inventory()

	-- Drop inventory items
	local stack
	for i = 1, inv:get_size("main") do
		stack = inv:get_stack("main", i)
		if stack:get_count() > 0 then
			minetest.item_drop(stack, nil, pos)
		end
	end
	inv:set_list("main", {})

	-- Display death coordinates
	local name = player:get_player_name()
	local pos_string = minetest.pos_to_string(pos, 1)

	minetest.chat_send_player(name, Sl("Your last coordinates:") .. " "
		.. pos_string)

	minetest.log("action", name .. " died at " .. pos_string)
end)
