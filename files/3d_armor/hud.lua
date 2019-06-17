-- (c) Copyright BlockMen (2013-2016), LGPLv3.0+

if minetest.settings:get_bool("enable_damage") then
	local armor_org_func = armor.set_player_armor
	local function get_armor_lvl(def)
		-- items/protection based display
		local lvl = def.level or 0
		local max = 63 -- full diamond armor
		local ret = lvl/max
		if ret > 1 then
			ret = 1
		end
		return tonumber(20 * ret)
	end

	function armor.set_player_armor(self, player)
		armor_org_func(self, player)
		local name = player:get_player_name()
		local def = self.def
		local armor_lvl = 0
		if def[name] and def[name].level then
			armor_lvl = get_armor_lvl(def[name])
		end
		hud.change_item(player, "armor", {number = armor_lvl})
	end

	hud.register("armor", {
		hud_elem_type = "statbar",
		position      = {x = 0.5,  y = 1},
		alignment     = {x = -1,   y = -1},
		offset        = {x = -247, y = -134},
		size          = {x = 24,   y = 24},
		text          = "3d_armor_statbar_fg.png",
		background    = "3d_armor_statbar_bg.png",
		number        = 0,
		max           = 20,
		autohide_bg   = true,
	})
end