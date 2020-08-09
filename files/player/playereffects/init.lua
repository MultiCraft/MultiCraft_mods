--[=[ Main tables ]=]

playereffects = {}

--[[ table containing the groups (experimental) ]]
playereffects.groups = {}

--[[ table containing all the HUD info tables, indexed by player names.
A single HUD info table is formatted like this: {text_id = 1, icon_id=2, pos = 0}
Where:	text_id: HUD ID of the textual effect description
		icon_id: HUD ID of the effect icon (optional)
		pos: Y offset factor (starts with 0)
Example of full table:
{["player1"] = {{text_id = 1, icon_id = 4, pos = 0}}, ["player2] = {{text_id = 5, icon_id=6, pos = 0}, {text_id = 7, icon_id=8, pos = 1}}}
]]
playereffects.hudinfos = {}

--[[ table containing all the effect types ]]
playereffects.effect_types = {}

--[[ table containing all the active effects ]]
playereffects.effects = {}

--[[ table containing all the inactive effects.
Effects become inactive if a player leaves an become active again if they join again. ]]
playereffects.inactive_effects = {}

-- Variable for counting the effect_id
playereffects.last_effect_id = 0

--[[
	Settings for Player Effects
]]

-- Whether to use the HUD to expose the active effects to players (true or false)
playereffects.use_hud = true

-- Whether to use autosave (true or false)
local use_autosave = false

-- The time interval between autosaves, in seconds (only used when use_autosave is true)
local autosave_time = 10

-- Translations
local translator = minetest.get_translator
local S = translator and translator("playereffects") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

--[=[ Load inactive_effects and last_effect_id from playereffects, if this file exists ]=]
do
	local filepath = minetest.get_worldpath() .. "/playereffects"
	local file = io.open(filepath, "r")
	if file then
		minetest.log("action", "[playereffects] playereffects loading...")
		local string = file:read()
		io.close(file)
		if string ~= nil then
			local savetable = minetest.deserialize(string)
			playereffects.inactive_effects = savetable.inactive_effects
		--	minetest.debug("[playereffects] playereffects successfully read.")
		--	minetest.debug("[playereffects] inactive_effects = " .. dump(playereffects.inactive_effects))
		--	playereffects.last_effect_id = savetable.last_effect_id
		--	minetest.debug("[playereffects] last_effect_id = " .. dump(playereffects.last_effect_id))
		end
	end
end

function playereffects.next_effect_id()
	playereffects.last_effect_id = playereffects.last_effect_id + 1
	return playereffects.last_effect_id
end

--[=[ API functions ]=]
function playereffects.register_effect_type(effect_type_id, description, icon, groups, apply, cancel, hidden, cancel_on_death, repeat_interval)
	local effect_type = {}
	effect_type.description = description
	effect_type.apply = apply
	effect_type.groups = groups
	effect_type.icon = icon
	effect_type.cancel = cancel and cancel or function() end
	effect_type.hidden = hidden and hidden or false
	effect_type.cancel_on_death = cancel_on_death and cancel_on_death or true
	effect_type.repeat_interval = repeat_interval

	playereffects.effect_types[effect_type_id] = effect_type
--	minetest.log("action", "[playereffects] Effect type " .. effect_type_id .. " registered!")
end

function playereffects.apply_effect_type(effect_type_id, duration, player, repeat_interval_time_left)
	local start_time = os.time()
	if type(player) == "userdata" and not player:is_player() then
		minetest.log("error", "[playereffects] Attempted to apply effect type " .. effect_type_id .. " to a non-player!")
		return false
	end

	local playername = player:get_player_name()
	if not playername then return false end
	local groups = playereffects.effect_types[effect_type_id].groups
	for _, v in pairs(groups) do
		playereffects.cancel_effect_group(v, playername)
	end

	local metadata
	if not playereffects.effect_types[effect_type_id].repeat_interval then
		local status = playereffects.effect_types[effect_type_id].apply(player)
		if status == false then
			minetest.log("action", "[playereffects] Attempt to apply effect type " .. effect_type_id .. " to player " .. playername .. " failed!")
			return false
		else
			metadata = status
		end
	end

	local effect_id = playereffects.next_effect_id()
	local smallest_hudpos
	local biggest_hudpos = -1
	local free_hudpos

	local hudinfos = playereffects.hudinfos[playername] or {}
	for _, hudinfo in pairs(hudinfos) do
		local hudpos = hudinfo.pos
		if hudpos > biggest_hudpos then
			biggest_hudpos = hudpos
		end
		if not smallest_hudpos then
			smallest_hudpos = hudpos
		elseif hudpos < smallest_hudpos then
			smallest_hudpos = hudpos
		end
	end
	if not smallest_hudpos then
		free_hudpos = 0
	elseif smallest_hudpos >= 0 then
		free_hudpos = smallest_hudpos - 1
	else
		free_hudpos = biggest_hudpos + 1
	end

	local repeat_interval = playereffects.effect_types[effect_type_id].repeat_interval
	if repeat_interval ~= nil then
		repeat_interval_time_left = repeat_interval_time_left and repeat_interval_time_left or repeat_interval
	end

	--[[ show no more than 10 effects on the screen, so that hud_update does not need to be called so often ]]
	local text_id, icon_id
	if free_hudpos <= 10 then
		text_id, icon_id = playereffects.hud_effect(effect_type_id, player, free_hudpos, duration, repeat_interval_time_left)
		local hudinfo = {
			text_id = text_id,
			icon_id = icon_id,
			pos = free_hudpos
		}
		playereffects.hudinfos[playername][effect_id] = hudinfo
		playereffects.hud_update(player)
	end

	local effect = {
		playername = playername,
		effect_id = effect_id,
		effect_type_id = effect_type_id,
		start_time = start_time,
		repeat_interval_start_time = start_time,
		time_left = duration,
		repeat_interval_time_left = repeat_interval_time_left,
		metadata = metadata
	}

	playereffects.effects[effect_id] = effect

	if repeat_interval ~= nil then
		minetest.after(repeat_interval_time_left, playereffects.repeater, effect_id,
			duration, player, playereffects.effect_types[effect_type_id].apply)
	else
		minetest.after(duration, function(effect_id) playereffects.cancel_effect(effect_id) end, effect_id)
	end

	return effect_id
end

function playereffects.repeater(effect_id, repetitions, player, apply)
	local effect = playereffects.effects[effect_id]
	if effect ~= nil then
		repetitions = effect.time_left
		apply(player)
		repetitions = repetitions - 1
		effect.time_left = repetitions
		if repetitions <= 0 then
			playereffects.cancel_effect(effect_id)
		else
			local repeat_interval = playereffects.effect_types[effect.effect_type_id].repeat_interval
			effect.repeat_interval_time_left = repeat_interval
			effect.repeat_interval_start_time = os.time()
			minetest.after(repeat_interval, playereffects.repeater, effect_id,
				repetitions, player, apply)
		end
	end
end

function playereffects.cancel_effect_type(effect_type_id, cancel_all, playername)
	local effects = playereffects.get_player_effects(playername)
	cancel_all = cancel_all and cancel_all or false
	for e = 1, #effects do
		if effects[e].effect_type_id == effect_type_id then
			playereffects.cancel_effect(effects[e].effect_id)
			if not cancel_all then
				return
			end
		end
	end
end

function playereffects.cancel_effect_group(groupname, playername)
	local effects = playereffects.get_player_effects(playername)
	for e = 1, #effects do
		local effect = effects[e]
		local thesegroups = playereffects.effect_types[effect.effect_type_id].groups
		for g = 1, #thesegroups do
			if thesegroups[g] == groupname then
				playereffects.cancel_effect(effect.effect_id)
				break
			end
		end
	end
end

function playereffects.get_remaining_effect_time(effect_id)
	local now = os.time()
	local effect = playereffects.effects[effect_id]

	return effect and (effect.time_left - os.difftime(now, effect.start_time)) or nil
end

function playereffects.cancel_effect(effect_id)
	local effect = playereffects.effects[effect_id]
	if effect ~= nil then
		local player = minetest.get_player_by_name(effect.playername)
		local hudinfo = playereffects.hudinfos[effect.playername][effect_id]
		if player and hudinfo then
			if hudinfo.text_id ~= nil then
				player:hud_remove(hudinfo.text_id)
			end
			if hudinfo.icon_id ~= nil then
				player:hud_remove(hudinfo.icon_id)
			end
			playereffects.hudinfos[effect.playername][effect_id] = nil
			playereffects.effect_types[effect.effect_type_id].cancel(effect, player)
		end
		playereffects.effects[effect_id] = nil
	end
end

function playereffects.get_player_effects(playername)
	local effects = {}
	if minetest.get_player_by_name(playername) ~= nil then
		for _, v in pairs(playereffects.effects) do
			if v.playername == playername then
				effects[#effects+1] = v
			end
		end
	end

	return effects
end

function playereffects.has_effect_type(playername, effect_type_id)
	local pe = playereffects.get_player_effects(playername)
	for i = 1, #pe do
		if pe[i].effect_type_id == effect_type_id then
			return true
		end
	end

	return false
end

--[=[ Saving all data to file ]=]
function playereffects.save_to_file()
	local save_time = os.time()
	local savetable = {}
	local inactive_effects = {}
	for playername, effecttable in pairs(playereffects.inactive_effects) do
		if inactive_effects[playername] == nil then
			inactive_effects[playername] = {}
		end
		local pinacteff = inactive_effects[playername]

		for i = 1, #effecttable do
			pinacteff[#pinacteff+1] = effecttable[i]
		end
	end

	for _, effect in pairs(playereffects.effects) do
		local new_duration, new_repeat_duration
		if playereffects.effect_types[effect.effect_type_id].repeat_interval ~= nil then
			new_duration = effect.time_left
			new_repeat_duration = effect.repeat_interval_time_left - os.difftime(save_time, effect.repeat_interval_start_time)
		else
			new_duration = effect.time_left - os.difftime(save_time, effect.start_time)
		end
		local new_effect = {
			effect_id = effect.effect_id,
			effect_type_id = effect.effect_type_id,
			time_left = new_duration,
			repeat_interval_time_left = new_repeat_duration,
			start_time = effect.start_time,
			repeat_interval_start_time = effect.repeat_interval_start_time,
			playername = effect.playername,
			metadata = effect.metadata
		}
		local player_inactive_effects_effect = inactive_effects[effect.playername]
		player_inactive_effects_effect[#player_inactive_effects_effect+1] = new_effect
	end

	for playername, _ in pairs(inactive_effects) do
		if #inactive_effects[playername] < 1 then
			inactive_effects[playername] = nil
		end
	end

	savetable.inactive_effects = inactive_effects
--	savetable.last_effect_id = playereffects.last_effect_id

	local savestring = minetest.serialize(savetable)

	local filepath = minetest.get_worldpath() .. "/playereffects"
	local file = io.open(filepath, "w")
	if file then
		file:write(savestring)
		io.close(file)
		minetest.log("action", "[playereffects] Wrote playereffects data into " .. filepath .. ".")
	else
		minetest.log("error", "[playereffects] Failed to write playereffects data into " .. filepath .. ".")
	end
end

--[=[ Callbacks ]=]
--[[ Cancel all effects on player death ]]
minetest.register_on_dieplayer(function(player)
	local effects = playereffects.get_player_effects(player:get_player_name())
	for e = 1, #effects do
		if playereffects.effect_types[effects[e].effect_type_id].cancel_on_death then
			playereffects.cancel_effect(effects[e].effect_id)
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	local leave_time = os.time()
	local playername = player:get_player_name()
	local effects = playereffects.get_player_effects(playername)

	playereffects.hud_clear(player)

	local inactive_effects = playereffects.inactive_effects[playername]
	for e = 1, #effects do
		local new_duration = effects[e].time_left - os.difftime(leave_time, effects[e].start_time)
		local new_effect = effects[e]
		new_effect.time_left = new_duration
		inactive_effects[#inactive_effects+1] = new_effect
		playereffects.cancel_effect(effects[e].effect_id)
	end
end)

minetest.register_on_shutdown(function()
	minetest.log("action", "[playereffects] Server shuts down. Rescuing data into playereffects")
	playereffects.save_to_file()
end)

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	-- load all the effects again (if any)
	playereffects.hudinfos[playername] = {}
	local inactive_effects = playereffects.inactive_effects[playername]
	if inactive_effects ~= nil then
		minetest.after(2, function()
			for i = 1, #inactive_effects do
				local effect = inactive_effects[i]
				playereffects.apply_effect_type(effect.effect_type_id, effect.time_left, player, effect.repeat_interval_time_left)
			end
		end)
	end
	playereffects.inactive_effects[playername] = {}
end)

-- Autosave into file
if use_autosave then
	minetest.register_globalstep(function(dtime)
		playereffects.autosave_timer = playereffects.autosave_timer or 0
		playereffects.autosave_timer = playereffects.autosave_timer + dtime

		if playereffects.autosave_timer >= autosave_time then
			playereffects.autosave_timer = 0
			minetest.log("action", "[playereffects] Autosaving mod data to playereffects...")
			playereffects.save_to_file()
		end
	end)
end

minetest.register_playerstep(function(_, playernames)
	for _, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			playereffects.hud_update(player)
		end
	end
end)

--[=[ HUD ]=]
function playereffects.hud_update(player)
	if playereffects.use_hud then
		local now = os.time()
		local playername = player:get_player_name()
		local hudinfos = playereffects.hudinfos[playername]
		if hudinfos ~= nil then
			for effect_id, hudinfo in pairs(hudinfos) do
				local effect = playereffects.effects[effect_id]
				if effect ~= nil and hudinfo.text_id ~= nil then
					local description = playereffects.effect_types[effect.effect_type_id].description
					local repeat_interval = playereffects.effect_types[effect.effect_type_id].repeat_interval
					if repeat_interval ~= nil then
						local repeat_interval_time_left = os.difftime(effect.repeat_interval_start_time + effect.repeat_interval_time_left, now)
						player:hud_change(hudinfo.text_id, "text",
							description .. " (" .. effect.time_left .. " / " .. repeat_interval_time_left .. " " .. S("s") .. ")")
					else
						local time_left = os.difftime(effect.start_time + effect.time_left, now)
						player:hud_change(hudinfo.text_id, "text",
							description .. " (" .. time_left .. " " .. S("s") .. ")")
					end
				end
			end
		end
	end
end

function playereffects.hud_clear(player)
	if playereffects.use_hud then
		local playername = player:get_player_name()
		local hudinfos = playereffects.hudinfos[playername]
		if hudinfos then
			for effect_id, hudinfo in pairs(hudinfos) do
				if hudinfo.text_id then
					player:hud_remove(hudinfo.text_id)
				end
				if hudinfo.icon_id then
					player:hud_remove(hudinfo.icon_id)
				end
				playereffects.hudinfos[playername][effect_id] = nil
			end
		end
	end
end

function playereffects.hud_effect(effect_type_id, player, pos)
	local text_id, icon_id
	local effect_type = playereffects.effect_types[effect_type_id]
	if playereffects.use_hud and not effect_type.hidden then
		local color
		if effect_type.cancel_on_death then
			color = 0xFFFFFF
		else
			color = 0xF0BAFF
		end
		text_id = player:hud_add({
			hud_elem_type = "text",
			position = {x = 1, y = 0.3},
			name = "effect_" .. effect_type_id,
			scale = {x = 170, y = 20},
			alignment = {x = -1, y = 0},
			direction = 1,
			number = color,
			offset = {x = -5, y = pos * 30}
		})

		local icon = effect_type.icon
		if icon then
			icon_id = player:hud_add({
				hud_elem_type = "image",
				scale = {x = 1, y = 1},
				position = {x = 1, y = 0.3},
				name = "effect_icon_" .. effect_type_id,
				text = icon,
				alignment = {x = -1, y = 0},
				direction = 0,
				offset = {x = -230, y = pos * 30}
			})
		end
	end

	return text_id, icon_id
end
