-- Armor
function hud.set_armor()
end

if hud.show_armor then
    local shields = minetest.get_modpath("shields") ~= nil
    local armor_org_func = armor.update_armor

    local function get_armor_lvl(def)
	-- items/protection based display
	local lvl = def.level or 0
	local max = 63 -- full diamond armor
	if shields then
		max = 84.14 -- full diamond armor + diamond shield
	end
	-- TODO: is there a sane way to read out max values?
	local ret = lvl/max
	if ret > 1 then
		ret = 1
	end
	
	return tonumber(20 * ret)
    end

    function armor.update_armor(self, player)
	armor_org_func(self, player)
	local name = player:get_player_name()
	local def = self.def
	local armor_lvl = 0
	if def[name] and def[name].level then
		armor_lvl = get_armor_lvl(def[name])
	end
	hud.change_item(player, "armor", {number = armor_lvl})
    end
end

-- Hunger related functions
if not hud.show_hunger then
    function hud.set_hunger()
	hud.notify_hunger(1, true)
    end

    function hud.get_hunger()
	hud.notify_hunger(1, true)
    end

    function hud.item_eat(hp_change, replace_with_item)
    	return function(itemstack, user, pointed_thing)
		hud.notify_hunger(1, true)
		local func = minetest.item_eat(hp_change, replace_with_item)
		return func(itemstack, user, pointed_thing)
	end
    end

    function hud.save_hunger()
	hud.notify_hunger(1, true)
    end
    function hud.load_hunger(player)
	hud.notify_hunger(1, true)
    end
end
