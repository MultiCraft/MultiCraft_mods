local S = beds.S
local pi = math.pi
local is_sp = minetest.is_singleplayer()
local enable_respawn = minetest.settings:get_bool("enable_bed_respawn")
if enable_respawn == nil then
	enable_respawn = true
end
local enable_night_skip = minetest.settings:get_bool("enable_bed_night_skip")
if enable_night_skip == nil then
	enable_night_skip = true
end
local hunger_exists = minetest.global_exists("hunger")
local na_exists = minetest.global_exists("node_attacher")

-- Helper functions

local function get_look_yaw(pos)
	local rotation = minetest.get_node(pos).param2
	if rotation > 3 then
		rotation = rotation % 4 -- Mask colorfacedir values
	end
	if rotation == 1 then
		return pi / 2, rotation
	elseif rotation == 3 then
		return -pi / 2, rotation
	elseif rotation == 0 then
		return pi, rotation
	else
		return 0, rotation
	end
end

local function check_in_beds(players)
	local in_bed = beds.player
	if not players then
		players = minetest.get_connected_players()
	end

	for _, player in ipairs(players) do
		local name = player:get_player_name()
		if not in_bed[name] then
			return false
		end
	end

	return #players > 0
end

local function lay_down(player, pos, bed_pos, state, skip)
	local name = player:get_player_name()
	local hud_flags = player:hud_get_flags()

	if not player or not name then
		return
	end

	-- stand up
	if state ~= nil and not state then
		if not beds.player[name] then
			-- player not in bed, do nothing
			return false
		end
		beds.bed_position[name] = nil
		-- skip here to prevent sending player specific changes (used for leaving players)
		if skip then
			return
		end
		local p = beds.pos[name] or nil
		if p then
			player:set_pos(p)
		end

		-- physics, eye_offset, etc
	--	local physics_override = beds.player[name].physics_override
		beds.player[name] = nil
	--[[player:set_physics_override({
			speed = physics_override.speed,
			jump = physics_override.jump,
			gravity = physics_override.gravity
		})]]
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		player:set_look_horizontal(math.random(1, 180) / 100)
		player_api.player_attached[name] = false
		hud_flags.wielditem = true
		player_api.set_animation(player, "stand", 30)
	else -- lay down
		-- Check if bed is occupied
		for other_name, other_pos in pairs(beds.bed_position) do
			if name ~= other_name and
					vector.distance(bed_pos, other_pos) < 0.1 then
				minetest.chat_send_player(name, S("This bed is already occupied!"))
				return false
			end
		end

		-- Check if player is attached to an object
		if player:get_attach() then
			return false
		end

		-- Check if player is moving
		if vector.length(player:get_player_velocity()) > 0 then
			minetest.chat_send_player(name, S("You have to stop moving before going to bed!"))
			return false
		end

		if beds.player[name] then
			-- player already in bed, do nothing
			return false
		end

		beds.pos[name] = pos
		beds.bed_position[name] = bed_pos
	--	beds.player[name] = {physics_override = player:get_physics_override()}
		beds.player[name] = true

		-- physics, eye_offset, etc
		player:set_eye_offset({x = 0, y = -13, z = 0}, {x = 0, y = 0, z = 0})
		local yaw, param2 = get_look_yaw(bed_pos)
		player:set_look_horizontal(yaw)
		local dir = minetest.facedir_to_dir(param2)
	--	player:set_physics_override({speed = 0, jump = 0, gravity = 0})
		player:set_pos({x = bed_pos.x + dir.x / 2, y = bed_pos.y, z = bed_pos.z + dir.z / 2})
		player_api.player_attached[name] = true
		hud_flags.wielditem = false
		minetest.after(0.2, function()
			if player then
				player_api.set_animation(player, "lay", 0)
			end
		end)
	end

	player:hud_set_flags(hud_flags)
end

local function get_player_in_bed_count()
	local c = 0
	for _, _ in pairs(beds.player) do
		c = c + 1
	end
	return c
end

local function update_formspecs(finished)
	local ges = #minetest.get_connected_players()
	local player_in_bed = get_player_in_bed_count()
	local is_majority = (ges / 2) < player_in_bed

	local form_n = beds.formspec
	if finished then
		form_n = form_n ..
			"image_button[1.3,6;5.4,0.8;blank.png;;" ..
				S("Good morning.") .. ";false;false;]"
	else
		local text = S("Good night.")
		if not is_sp then
			text = S("@1 of @2 players are in bed", player_in_bed, ges)
		end
		form_n = form_n ..
			"image_button[1.3,6;5.4,0.8;blank.png;;" .. text .. ";false;false;]"
		if is_majority and enable_night_skip then
			form_n = form_n ..
				"button[1.9,4;4.2,0.75;force;" .. S("Force night skip") .. "]"
		end
	end

	for name,_ in pairs(beds.player) do
		minetest.show_formspec(name, "beds_form", form_n)
	end
end


-- Public functions

function beds.skip_night()
	minetest.set_timeofday(0.23)
	minetest.chat_send_all(S("Good morning."))

	-- sleep restores health and makes hungry
	if hunger_exists then
		for name, _ in pairs(beds.player) do
			local player = minetest.get_player_by_name(name)

			if player then
				local saturation = hunger.get_saturation(player)
				local new = math.max(2, saturation - 4)
				if new < saturation then
					player:set_hp(20)
					hunger.set_saturation(player, new)
				end
			end
		end
	end
end

function beds.on_rightclick(pos, player)
	local name = player:get_player_name()
	local ppos = player:get_pos()
	local tod = minetest.get_timeofday()

	if na_exists and node_attacher.stand(player) then
		return false
	end

	if tod > 0.2 and tod < 0.805 then
		if beds.player[name] then
			lay_down(player, nil, nil, false)
		elseif na_exists then
			node_attacher.sit(pos, minetest.get_node(pos), player)
		end
		return
	end

	-- move to bed
	if not beds.player[name] or beds.player[name] == 2 then
		lay_down(player, ppos, pos)
		beds.set_spawns() -- save respawn positions when entering bed
	else
		lay_down(player, nil, nil, false)
	end

	update_formspecs(false)
end

function beds.can_dig(bed_pos, player)
	-- Check all players in bed which one is at the expected position
	for _, player_bed_pos in pairs(beds.bed_position) do
		if vector.equals(bed_pos, player_bed_pos) then
			return false
		end
	end

	if na_exists then
		return node_attacher.can_dig(bed_pos, player)
	end

	return true
end

-- Callbacks
-- Only register respawn callback if respawn enabled
if enable_respawn then
	-- respawn player at bed if enabled and valid position is found
	minetest.register_on_respawnplayer(function(player)
		local name = player:get_player_name()
		local pos = beds.spawn[name]
		if pos then
			player:set_pos(pos)
			return true
		end
	end)
end

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	lay_down(player, nil, nil, false, true)
	beds.player[name] = nil
	if check_in_beds() then
		minetest.after(2, function()
			update_formspecs(false)
		end)
	end
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	local in_bed = beds.player
	local pos = player:get_pos()
	local yaw = get_look_yaw(pos)

	if in_bed[name] then
		lay_down(player, nil, pos, false)
		player:set_look_horizontal(yaw)
		player:set_pos(pos)
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "beds_form" then
		return
	end

	-- Because "Force night skip" button is a button_exit, it will set fields.quit
	-- and lay_down call will change value of player_in_bed, so it must be taken
	-- earlier.
	local last_player_in_bed = get_player_in_bed_count()

	if fields.quit or fields.leave then
		lay_down(player, nil, nil, false)
		update_formspecs(false)
	end

	if fields.force then
		local is_majority = (#minetest.get_connected_players() / 2) < last_player_in_bed
		if is_majority and enable_night_skip then
			update_formspecs(true)
			beds.skip_night()
		else
			update_formspecs(false)
		end
	end
end)
