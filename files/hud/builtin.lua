HUD_SB_SIZE			= {x = 24,		y = 24}
HUD_HEALTH_OFFSET	= {x = -249,	y = -109}
HUD_AIR_OFFSET		= {x = 8,		y = -134}
HUD_HUNGER_OFFSET	= {x = 8,		y = -109}
HUD_ARMOR_OFFSET	= {x = -249,	y = -134}

hud.register("health", {
	hud_elem_type = "statbar",
	position = {x = 0.5, y = 1},
	size = HUD_SB_SIZE,
	text = "heart.png",
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
	position = {x = 0.5, y = 1},
	size = HUD_SB_SIZE,
	text = "bubble.png",
	number = 0,
	alignment = {x = -1, y = -1},
	offset = HUD_AIR_OFFSET,
	background = nil,
	events = {
		{
			type = "breath",
			func = function(player)
				if not player then return end
				local air = player:get_breath() or 11
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
	position = {x = 0.5, y = 1},
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
	position = {x = 0.5, y = 1},
	size = HUD_SB_SIZE,
	text = "hud_hunger_fg.png",
	number = 20,
	alignment = {x = -1, y = -1},
	offset = HUD_HUNGER_OFFSET,
	background = "hud_hunger_bg.png",
	max = 20,
})
