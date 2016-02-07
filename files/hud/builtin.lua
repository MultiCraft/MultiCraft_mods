HUD_IW_MAX = 8
HUD_IW_TICK = 0.4
if minetest.is_singleplayer() == true then
	HUD_IW_TICK = 0.2
end
HUD_ENABLE_HUNGER = true
HUD_SB_SIZE = {x = 24, y = 24}

HUD_HEALTH_POS = {x = 0.5,y = 1}
HUD_HEALTH_OFFSET = {x = -248, y = -93}
HUD_AIR_POS = {x = 0.5, y = 1}
HUD_AIR_OFFSET = {x = 6, y = -93}
HUD_HUNGER_POS = {x = 0.5, y = 1}
HUD_HUNGER_OFFSET = {x = 6, y = -124}
HUD_ARMOR_POS = {x = 0.5, y = 1}
HUD_ARMOR_OFFSET = {x = -248, y = -124}

-- Reorder everything when using ItemWeel
hud.item_wheel = minetest.setting_getbool("hud_item_wheel")
if hud.item_wheel then
	HUD_HEALTH_POS = {x = 0.5,y = 1}
	HUD_HEALTH_OFFSET = {x = -385, y = -77}
	HUD_AIR_POS = {x = 0.5, y = 1}
	HUD_AIR_OFFSET = {x = 150, y = -77}
	HUD_HUNGER_POS = {x = 0.5, y = 1}
	HUD_HUNGER_OFFSET = {x = 180, y = -44}
	HUD_ARMOR_POS = {x = 0.5, y = 1}
	HUD_ARMOR_OFFSET = {x = -415, y = -44}
end

-- read hud.conf settings
hud.read_conf()

local damage_enabled = minetest.setting_getbool("enable_damage")

hud.show_hunger = minetest.get_modpath("hunger") ~= nil
hud.show_armor = minetest.get_modpath("3d_armor") ~= nil

-- check if some settings are invalid
local enable_hunger = minetest.setting_getbool("hud_hunger_enable")
if (enable_hunger == true or HUD_ENABLE_HUNGER == true) and not hud.show_hunger then
	hud.notify_hunger(5)
end

if damage_enabled then
    hud.register("health", {
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		size = HUD_SB_SIZE,
		text = "hud_heart_fg.png",
		number = 20,
		alignment = {x = -1, y = -1},
		offset = HUD_HEALTH_OFFSET,
		background = "hud_heart_bg.png",
		events = {
			{
				type = "damage",
				func = function(player)
					hud.change_item(player, "health", {number = player:get_hp()})
				end
		 	}
		},
    })

    hud.register("air", {
		hud_elem_type = "statbar",
		position = HUD_AIR_POS,
		size = HUD_SB_SIZE,
		text = "hud_air_fg.png",
		number = 0,
		alignment = {x = -1, y = -1},
		offset = HUD_AIR_OFFSET,
		background = nil,
		events = {
			{
				type = "breath",
				func = function(player)
					local air = player:get_breath()
					if air > 10 then
						air = 0
					end
					hud.change_item(player, "air", {number = air * 2})
				end
		 	}
		},
    })

    hud.register("armor", {
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		size = HUD_SB_SIZE,
		text = "hud_armor_fg.png",
		number = 0,
		alignment = {x = -1, y = -1},
		offset = HUD_ARMOR_OFFSET,
		background = "hud_armor_bg.png",
		autohide_bg = true,
		max = 20,
    })

    hud.register("hunger", {
		hud_elem_type = "statbar",
		position = HUD_HUNGER_POS,
		size = HUD_SB_SIZE,
		text = "hud_hunger_fg.png",
		number = 0,
		alignment = {x = -1, y = -1},
		offset = HUD_HUNGER_OFFSET,
		background = "hud_hunger_bg.png",
		max = 0,
    })
else
	hud.show_armor = false
end
