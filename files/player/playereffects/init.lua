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

-- Variable for counting the effect_id
playereffects.last_effect_id = 0

--[[
	Settings for Player Effects
]]

-- Whether to use the HUD to expose the active effects to players (true or false)
playereffects.use_hud = true

-- Translations
local S = minetest.get_translator("playereffects")

local time = 0
minetest.register_globalstep(function(dtime)
	time = time + dtime
end)

-- Not same as math.round
local function round(number)
	return math.floor(number + 0.5)
end

function playereffects.next_effect_id()
	playereffects.last_effect_id = playereffects.last_effect_id + 1
	return playereffects.last_effect_id
end

--[=[ API functions ]=]
function playereffects.register_effect_type(effect_type_id, description, icon,
		groups, apply, cancel, hidden, cancel_on_death, repeat_interval)
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
	local playername = player and player:get_player_name()

	if not playername or not minetest.is_player(player) then
		minetest.log("error", "[playereffects] Attempted to apply effect type " .. effect_type_id .. " to a non-player!")
		return false
	end

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
	if repeat_interval then
		repeat_interval_time_left = repeat_interval_time_left and repeat_interval_time_left or repeat_interval
	end

	--[[ show no more than 10 effects on the screen, so that hud_update does not need to be called so often ]]
	local text_id, icon_id
	if duration > 0 and free_hudpos <= 10 then
		text_id, icon_id = playereffects.hud_effect(effect_type_id, player, free_hudpos, duration, repeat_interval_time_left)
		local hudinfo = {
			text_id = text_id,
			icon_id = icon_id,
			pos = free_hudpos
		}
		playereffects.hudinfos[playername][effect_id] = hudinfo
	end

	local effect = {
		playername = playername,
		effect_id = effect_id,
		effect_type_id = effect_type_id,
		start_time = time,
		repeat_interval_start_time = time,
		time_left = duration,
		repeat_interval_time_left = repeat_interval_time_left,
		metadata = metadata
	}

	playereffects.effects[effect_id] = effect

	if repeat_interval then
		minetest.after(repeat_interval_time_left, playereffects.repeater, effect_id,
			player, playereffects.effect_types[effect_type_id].apply)
	else
		minetest.after(duration, function(effect_id) playereffects.cancel_effect(effect_id) end, effect_id)
	end

	return effect_id
end

function playereffects.repeater(effect_id, player, apply)
	local effect = playereffects.effects[effect_id]
	if not effect then return end
	local repetitions = effect.time_left
	apply(player)
	repetitions = repetitions - 1
	effect.time_left = repetitions
	if repetitions <= 0 then
		playereffects.cancel_effect(effect_id)
	else
		local repeat_interval = playereffects.effect_types[effect.effect_type_id].repeat_interval
		effect.repeat_interval_time_left = repeat_interval
		effect.repeat_interval_start_time = time
		minetest.after(repeat_interval, playereffects.repeater, effect_id, player, apply)
	end
end

function playereffects.cancel_effect_type(effect_type_id, cancel_all, playername)
	local effects = playereffects.get_player_effects(playername)
	cancel_all = cancel_all and cancel_all or false
	for _, effect in ipairs(effects) do
		if effect.effect_type_id == effect_type_id then
			playereffects.cancel_effect(effect.effect_id)
			if not cancel_all then
				return
			end
		end
	end
end

function playereffects.cancel_effect_group(groupname, playername)
	local effects = playereffects.get_player_effects(playername)
	for _, effect in ipairs(effects) do
		local thesegroups = playereffects.effect_types[effect.effect_type_id].groups
		for _, group in ipairs(thesegroups) do
			if group == groupname then
				playereffects.cancel_effect(effect.effect_id)
				break
			end
		end
	end
end

function playereffects.get_remaining_effect_time(effect_id)
	local effect = playereffects.effects[effect_id]

	return effect and (effect.time_left - (time - effect.start_time)) or nil
end

function playereffects.cancel_effect(effect_id)
	local effect = playereffects.effects[effect_id]
	if not effect then return end
	local player = minetest.get_player_by_name(effect.playername)
	local hudinfo = playereffects.hudinfos[effect.playername]
	if player and hudinfo then
		local effect_hud = hudinfo[effect_id] or {}
		if effect_hud.text_id then
			player:hud_remove(effect_hud.text_id)
		end
		if effect_hud.icon_id then
			player:hud_remove(effect_hud.icon_id)
		end
		hudinfo[effect_id] = nil
		playereffects.effect_types[effect.effect_type_id].cancel(effect, player)
	end
	playereffects.effects[effect_id] = nil
end

function playereffects.get_player_effects(playername)
	local effects = {}
	if minetest.get_player_by_name(playername) then
		for _, v in pairs(playereffects.effects) do
			if v.playername == playername then
				effects[#effects + 1] = v
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

--[=[ Callbacks ]=]
--[[ Cancel all effects on player death ]]
minetest.register_on_dieplayer(function(player)
	local effects = playereffects.get_player_effects(player:get_player_name())
	for _, effect in ipairs(effects) do
		if playereffects.effect_types[effect.effect_type_id].cancel_on_death then
			playereffects.cancel_effect(effect.effect_id)
		end
	end
end)

local function save_meta(player)
	local player_name = player:get_player_name()
	local effects = playereffects.get_player_effects(player_name)

	local valid_effects = {}
	for _, effect in ipairs(effects) do
		-- I think time_left is actually the total duration and not the
		-- remaining time.
		local new_duration = effect.time_left - (time - effect.start_time)
		if new_duration > 0 then
			effect.time_left = new_duration
			valid_effects[#valid_effects + 1] = effect
		end
	end

	player:get_meta():set_string("playereffects", minetest.serialize(valid_effects))
end

minetest.register_on_leaveplayer(function(player)
	save_meta(player)
	playereffects.hudinfos[player:get_player_name()] = nil
end)

minetest.register_on_shutdown(function()
	for _, player in ipairs(minetest.get_connected_players()) do
		save_meta(player)
	end
end)

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	-- load all the effects again (if any)
	local meta = player:get_meta()
	playereffects.hudinfos[playername] = {}
	local inactive_effects = minetest.deserialize(meta:get_string("playereffects"))
	if inactive_effects ~= nil then
		minetest.after(1, function()
			-- Make sure the player hasn't left
			player = minetest.get_player_by_name(playername)
			if not player then return end

			for i = 1, #inactive_effects do
				local effect = inactive_effects[i]
				-- Don't apply unknown effects
				if playereffects.effect_types[effect.effect_type_id] then
					playereffects.apply_effect_type(effect.effect_type_id, effect.time_left, player, effect.repeat_interval_time_left)
				end
			end
		end)
	end
end)

minetest.register_playerstep(function(_, playernames)
	for _, name in ipairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			playereffects.hud_update(player)
		end
	end
end)

--[=[ HUD ]=]
function playereffects.hud_update(player)
	if not playereffects.use_hud then return end
	local playername = player:get_player_name()
	local hudinfos = playereffects.hudinfos[playername]
	if not hudinfos then return end
	for effect_id, hudinfo in pairs(hudinfos) do
		local effect = playereffects.effects[effect_id]
		if effect ~= nil and hudinfo.text_id then
			local description = playereffects.effect_types[effect.effect_type_id].description
			local repeat_interval = playereffects.effect_types[effect.effect_type_id].repeat_interval
			local timer, time_left
			if repeat_interval then
				local repeat_interval_time_left = round((effect.repeat_interval_start_time + effect.repeat_interval_time_left) - time)
				time_left = round(effect.time_left)
				timer = S("(@1 / @2 s)", time_left, repeat_interval_time_left)
			else
				time_left = round((effect.start_time + effect.time_left) - time)
				timer = S("(@1 s)", time_left)
			end
			if hudinfo.timer ~= timer then
				player:hud_change(hudinfo.text_id, "text", description .. " " .. timer)
				hudinfo.timer = timer
			end
		end
	end
end

function playereffects.hud_effect(effect_type_id, player, pos, duration, repeat_interval_time_left)
	local text_id, icon_id
	local effect_type = playereffects.effect_types[effect_type_id]
	if playereffects.use_hud and not effect_type.hidden then
		local color = effect_type.cancel_on_death and 0xFFFFFF or 0xF0BAFF
		local timer
		if effect_type.repeat_interval then
			timer = S("(@1 / @2 s)", duration, repeat_interval_time_left)
		else
			timer = S("(@1 s)", duration)
		end

		text_id = player:hud_add({
			hud_elem_type = "text",
			position = {x = 1, y = 0.3},
			name = "effect_" .. effect_type_id,
			scale = {x = 170, y = 20},
			alignment = {x = -1, y = 0},
			direction = 1,
			number = color,
			offset = {x = -40, y = (pos * 30) + 3},
			text = effect_type.description .. " " .. timer
		})

		local icon = effect_type.icon
		if icon then
			icon_id = player:hud_add({
				hud_elem_type = "image",
				position = {x = 1, y = 0.3},
				name = "effect_icon_" .. effect_type_id,
				scale = icon.scale or {x = 1, y = 1},
				text = icon.image or icon,
				alignment = {x = -1, y = 0},
				direction = 0,
				offset = {x = 0, y = pos * 30}
			})
		end
	end

	return text_id, icon_id
end
