-- global values
hud.registered_items = {}
hud.damage_events = {}
hud.breath_events = {}

-- keep id handling internal
local hud_id = {}	-- hud item ids
local sb_bg = {}	-- statbar background ids

-- localize often used table
local items = hud.registered_items

local function throw_error(msg)
	minetest.log("error", "Better HUD[error]: " .. msg)
end


--
-- API
--

function hud.register(name, def)
	if not name or not def then
		throw_error("not enough parameters given")
		return false
	end

	--TODO: allow other elements
	if def.hud_elem_type ~= "statbar" then
		throw_error("The given HUD element is no statbar")
		return false
	end
	if items[name] ~= nil then
		throw_error("A statbar with that name already exists")
		return false
	end

	-- actually register
	-- add background first since draworder is based on id :\
	if def.hud_elem_type == "statbar" and def.background ~= nil then
		sb_bg[name] = table.copy(def)
		sb_bg[name].text = def.background
		if not def.autohide_bg and def.max then
			sb_bg[name].number = def.max
		end
	end
	-- add item itself
	items[name] = def

	-- register events
	if def.events then
		for _,v in pairs(def.events) do
			if v and v.type and v.func then
				if v.type == "damage" then
					table.insert(hud.damage_events, v)
				end

				if v.type == "breath" then
					table.insert(hud.breath_events, v)
				end
			end
		end
	end
	
	-- no error so far, return sucess
	return true
end

-- swaps stabar positions
function hud.swap_statbar(player, item1, item2)
	if not player or not item1 or not item2 then
		throw_error("Not enough parameters given to swap statbars")
		return false
	end

	local def1 = items[item1] or nil
	local def2 = items[item2] or nil

	if not def1 or not def2 then
		throw_error("Can't swap statbars. Given statbars are not correct")
		return false
	end

	local pos_swap = false
	local p_name = player:get_player_name()
	local elem1 = hud_id[p_name.."_"..item1]
	local elem2 = hud_id[p_name.."_"..item2]

	if not elem1 or not elem2 or not elem1.id or not elem2.id then
		return false
	end

	player:hud_change(elem2.id, "offset", def1.offset)
	player:hud_change(elem1.id, "offset", def2.offset)

	if def1.position.x ~= def2.position.x or def1.position.y ~= def2.position.y then
		player:hud_change(elem2.id, "position", def1.position)
		player:hud_change(elem1.id, "position", def2.position)
		pos_swap = true
	end

	-- do the items have backgrounds? if so, swap them aswell
	local bg1 = hud_id[p_name.."_"..item1.."_bg"] or nil
	local bg2 = hud_id[p_name.."_"..item2.."_bg"] or nil
	if bg1 ~= nil and bg1.id then
		player:hud_change(bg1.id, "offset", def2.offset)
		if pos_swap == true then
			player:hud_change(bg1.id, "position", def2.position)
		end	
	end
	if bg2 ~= nil and bg2.id then
		player:hud_change(bg2.id, "offset", def1.offset)
		if pos_swap == true then
			player:hud_change(bg2.id, "position", def1.position)
		end	
	end

	return true

end

function hud.change_item(player, name, def)
	if not player or not player:is_player() or not name or not def then
		throw_error("Not enough parameters given to change HUD item")
		return false
	end
	local i_name = player:get_player_name().."_"..name
	local elem = hud_id[i_name]
	if not elem then
		throw_error("Given HUD element " .. dump(name) .. " does not exist".." hהההה")
		return false
	end

	-- Only update if values supported and value actually changed
	-- update supported values (currently number and text only)
	if def.number and elem.number then
		if def.number ~= elem.number then
			if elem.max and def.number > elem.max and not def.max then
				def.number = elem.max
			end
			if def.max then
				elem.max = def.max
			end
			player:hud_change(elem.id, "number", def.number)
			elem.number = def.number
			-- hide background when set
			local bg = hud_id[i_name.."_bg"]
			if elem.autohide_bg then
				if def.number < 1 then
					player:hud_change(bg.id, "number", 0)
				else
					local num = bg.number
					if bg.max then
						num = bg.max
					end
					player:hud_change(bg.id, "number", num)
				end
			else
				if bg and bg.max and bg.max < 1 and def.max and def.max > bg.max then
					player:hud_change(bg.id, "number", def.max)
					bg.max = def.max
					bg.number = def.max
				end	
			end
		end
	end
	if def.text and elem.text then
		if def.text ~= elem.text then
			player:hud_change(elem.id, "text", def.text)
			elem.text = def.text
		end
	end

	if def.offset and elem.offset then
		if def.item_name and def.offset == "item" then
			-- for legacy reasons
			if def.item_name then
				hud.swap_statbar(player, name, def.item_name)
			end
		else
			player:hud_change(elem.id, "offset", def.offset)
			elem.offset = def.offset
		end
	end

	return true
end

function hud.remove_item(player, name)
	if not player or not name then
		throw_error("Not enough parameters given")
		return false
	end
	local i_name = player:get_player_name().."_"..name
	if hud_id[i_name] == nil then
		throw_error("Given HUD element " .. dump(name) .. " does not exist")
		return false
	end
	player:hud_remove(hud_id[i_name].id)
	hud_id[i_name] = nil

	return true
end


--
-- Add registered HUD items to joining players
--

-- Following code is placed here to keep HUD ids internal
local function add_hud_item(player, name, def)
	if not player or not name or not def then
		throw_error("not enough parameters given")
		return false
	end
	local i_name = player:get_player_name().."_"..name
	hud_id[i_name] = def
	hud_id[i_name].id = player:hud_add(def)
end

minetest.register_on_joinplayer(function(player)

	-- first: hide the default statbars
	local hud_flags = player:hud_get_flags()
	hud_flags.healthbar = false
	hud_flags.breathbar = false
	player:hud_set_flags(hud_flags)

	-- now add the backgrounds for statbars
	for _,item in pairs(sb_bg) do
		add_hud_item(player, _.."_bg", item)
	end
	-- and finally the actual HUD items
	for _,item in pairs(items) do
		add_hud_item(player, _, item)
	end

end)
