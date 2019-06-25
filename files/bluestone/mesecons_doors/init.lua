-- Modified, from minetest_game/mods/doors/init.lua
local function on_rightclick(pos, dir, check_name, replace, replace_dir, params)
	pos.y = pos.y + dir
	if not minetest.get_node(pos).name == check_name then
		return
	end
	local p2 = minetest.get_node(pos).param2
	p2 = params[p2 + 1]

	minetest.swap_node(pos, {name = replace_dir, param2 = p2})

	pos.y = pos.y - dir
	minetest.swap_node(pos, {name = replace, param2 = p2})

	if (minetest.get_meta(pos):get_int("right") ~= 0) == (params[1] ~= 3) then
		minetest.sound_play("doors_door_close", {pos = pos, gain = 0.3, max_hear_distance = 10})
	else
		minetest.sound_play("doors_door_open", {pos = pos, gain = 0.3, max_hear_distance = 10})
	end
end

local function meseconify_door(name)
	if minetest.registered_items[name .. "_a"] then
		-- new style mesh node based doors
		local override = {
			mesecons = {effector = {
				action_on = function(pos, node)
					local door = doors.get(pos)
					if door then
						door:open()
					end
				end,
				action_off = function(pos, node)
					local door = doors.get(pos)
					if door then
						door:close()
					end
				end,
				rules = mesecon.rules.pplate
			}}
		}
		minetest.override_item(name .. "_a", override)
		minetest.override_item(name .. "_b", override)
	end
end

meseconify_door("doors:door_wood")
meseconify_door("doors:door_steel")
meseconify_door("doors:door_glass")
meseconify_door("doors:door_obsidian_glass")

-- Trapdoor
local function trapdoor_switch(pos, node)
	local state = minetest.get_meta(pos):get_int("state")

	if state == 1 then
		minetest.sound_play("doors_door_close", {pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.set_node(pos, {name="doors:trapdoor", param2 = node.param2})
	else
		minetest.sound_play("doors_door_open", {pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.set_node(pos, {name="doors:trapdoor_open", param2 = node.param2})
	end

	minetest.get_meta(pos):set_int("state", state == 1 and 0 or 1)
end

if doors and doors.get then
	local override = {
		mesecons = {effector = {
			action_on = function(pos, node)
				local door = doors.get(pos)
				if door then
					door:open()
				end
			end,
			action_off = function(pos, node)
				local door = doors.get(pos)
				if door then
					door:close()
				end
			end,
		}},
	}
	minetest.override_item("doors:trapdoor", override)
	minetest.override_item("doors:trapdoor_open", override)
	minetest.override_item("doors:trapdoor_steel", override)
	minetest.override_item("doors:trapdoor_steel_open", override)
else
	if minetest.registered_nodes["doors:trapdoor"] then
		minetest.override_item("doors:trapdoor", {
			mesecons = {effector = {
				action_on = trapdoor_switch,
				action_off = trapdoor_switch
			}},
		})

		minetest.override_item("doors:trapdoor_open", {
			mesecons = {effector = {
				action_on = trapdoor_switch,
				action_off = trapdoor_switch
			}},
		})
	end
end
