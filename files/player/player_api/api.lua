local fmt = string.format
local tconcat, tcopy = table.concat, table.copy
local floor = math.floor
local vequals, vnew = vector.equals, vector.new
local esc = minetest.formspec_escape

player_api.registered_models = {}

-- Local for speed
local models = player_api.registered_models

local function collisionbox_equals(collisionbox, other_collisionbox)
	if collisionbox == other_collisionbox then
		return true
	end
	for index = 1, 6 do
		if collisionbox[index] ~= other_collisionbox[index] then
			return false
		end
	end
	return true
end

function player_api.register_model(name, def)
	models[name] = def
	def.visual_size = def.visual_size or {x = 1, y = 1}
	def.collisionbox = def.collisionbox or {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
	def.stepheight = def.stepheight or 0.6
	def.eye_height = def.eye_height or 1.47

	-- Sort animations into property classes:
	-- Animations with same properties have the same _equals value
	for animation_name, animation in pairs(def.animations) do
		animation.eye_height = animation.eye_height or def.eye_height
		animation.collisionbox = animation.collisionbox or def.collisionbox
		animation.override_local = animation.override_local or false

		for _, other_animation in pairs(def.animations) do
			if other_animation._equals then
				if collisionbox_equals(animation.collisionbox, other_animation.collisionbox)
						and animation.eye_height == other_animation.eye_height then
					animation._equals = other_animation._equals
					break
				end
			end
		end
		animation._equals = animation._equals or animation_name
	end
end

player_api.default_skin = "character_1.png"
player_api.default_hair = "player_haircut_1.png"
player_api.default_model = "character.b3d"

local default_model = player_api.default_model

-- Player stats and animations
-- model, textures, animation
local players = {}
player_api.player_attached = {}

local function get_player_data(player)
	return players[player:get_player_name()] or {}
end

function player_api.get_animation(player)
	return get_player_data(player)
end

-- Called when a player's appearance needs to be updated
function player_api.set_model(player, model_name)
	local player_data = get_player_data(player)
	if player_data.model == model_name then
		return
	end

	local model = models[model_name]
	local textures = player_data.textures or model.textures
	player_data.model = model_name
	player_data.textures = textures

	player:set_properties({
		mesh = model_name,
		textures = textures,
		visual = "mesh",
		visual_size = model.visual_size,
		stepheight = model.stepheight
	})

	-- sets local_animation, collisionbox & eye_height
	player_api.set_animation(player, "stand")
end

function player_api.get_textures(player)
	local player_data = get_player_data(player)
	local model = models[player_data.model] or models[default_model]
	return player_data.textures or model.textures
end

function player_api.set_textures(player, ...)
	local player_data = get_player_data(player)
	local textures = tcopy(player_api.get_textures(player))
	local new_textures = {...}

	local skip = true
	for i = 1, #textures do
		if not new_textures[i] then
			new_textures[i] = textures[i]
		elseif new_textures[i] ~= textures[i] then
			skip = false
		end
	end

	if not skip then
		player_data.textures = new_textures
		player:set_properties({textures = new_textures})

		local name = player:get_player_name()
		if sscsm.has_sscsms_enabled(name) then
			player_api.update_sscsm_preview(player, name)
		end
	end
end

function player_api.set_texture(player, index, texture)
	local player_data = get_player_data(player)
	local textures = tcopy(player_api.get_textures(player))

	if textures[index] ~= texture then
		textures[index] = texture
		player_data.textures = textures
		player:set_properties({textures = textures})

		local name = player:get_player_name()
		if sscsm.has_sscsms_enabled(name) then
			player_api.update_sscsm_preview(player, name)
		end
	end
end

function player_api.set_animation(player, anim_name, speed, mode)
	local player_data = get_player_data(player)
	local model = models[player_data.model]
	if not (model and model.animations[anim_name]) then
		return
	end
	speed = speed or model.animation_speed
	if player_data.animation == anim_name and player_data.animation_speed == speed then
		return
	end
	local previous_anim = model.animations[player_data.animation] or {}
	local anim = model.animations[anim_name]
	player_data.animation = anim_name
	player_data.animation_speed = speed
	-- If necessary change the local animation (only seen by the client of *that* player)
	-- `override_local` <=> suspend local animations while this one is active
	if anim.override_local then
		if mode then
			local a = model.animations -- (not specific to the animation being set)
			player:set_local_animation(
				a[mode .. "_stand"], a[mode .. "_walk"], a[mode .. "_mine"], a[mode .. "_walk_mine"],
				speed
			)
		else
			player:set_local_animation(anim, anim, anim, anim, speed)
		end
	else
		local a = model.animations -- (not specific to the animation being set)
		player:set_local_animation(
			a.stand, a.walk, a.mine, a.walk_mine,
			speed
		)
	end

	-- Set the animation seen by everyone else
	player:set_animation(anim, speed, 0)
	-- Update related properties if they changed
	if anim._equals ~= previous_anim._equals then
		player:set_properties({
			collisionbox = anim.collisionbox,
			eye_height = anim.eye_height
		})
	end

	local invis_exists = minetest.global_exists("invisibility")
	local name = player:get_player_name()
	if mode and mode == "sneak" then
		-- Hide nametag
		if not (invis_exists and invisibility[name]) then
			local nametag = player:get_nametag_attributes()
			nametag.color.a = 0
			player:set_nametag_attributes(nametag)
		end
	else
		-- Show nametag
		if not (invis_exists and invisibility[name]) then
			local nametag = player:get_nametag_attributes()
			nametag.color.a = 255
			player:set_nametag_attributes(nametag)
		end
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	players[name] = {}
	player_api.player_attached[name] = false
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	player_api.player_attached[name] = nil
end)

-- Force reset the attached table
minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	player_api.player_attached[name] = nil
end)

player_api.wield_tile = {}
player_api.wield_cube = {}

local b = "blank.png"
function player_api.parse_preview_params(player, rot, textures, animation, speed, gender, hide_wielditem)
	local mesh
	if player then
		local player_data = get_player_data(player)
		mesh = player_data.model or default_model

		-- model texture from player or variable
		if not textures then
			local t = {}
			for i, v in ipairs(player_api.get_textures(player)) do
				if hide_wielditem and (i == 4 or i == 5) then
					t[i] = b
				elseif i == 4 then
					t[i] = esc(player_api.wield_tile[player:get_player_name()] or b)
				elseif i == 5 then
					t[i] = esc(player_api.wield_cube[player:get_player_name()] or b)
				else
					t[i] = esc(v)
				end
			end

			textures = tconcat(t, ",")
		end
	end

	-- nil checks
	mesh = mesh or default_model
	textures = textures or tconcat(models[default_model].textures, ",")

	-- swap gender for preview
	if gender == "male" then
		textures = textures:gsub("character_female_", "character_")
		textures = textures:gsub("_female", "")
	elseif gender == "female" then
		textures = textures:gsub("_accessory.png", "_accessory_female.png")

		if not textures:find("character_female_") then
			textures = textures:gsub("character_", "character_female_")
		end
		if not textures:find("haircut_female_") then
			textures = textures:gsub("haircut_", "haircut_female_")
		end
	end

	-- model rotation
	if type(rot) ~= "table" then
		rot = {}
	end
	rot.start = rot.start or -180
	rot.cont = rot.cont or "false"
	rot.mouse = rot.mouse or "false"

	-- model animation
	local anim
	if player then
		local player_data = get_player_data(player)
		local model = models[player_data.model] or models[default_model]
		anim = model.animations[animation or "relax"]
		anim.speed = speed or model.animation_speed
	else
		local model = models[default_model]
		anim = model.animations[animation or "relax"]
		anim.speed = model.animation_speed
	end

	return "player_preview", mesh, textures, rot.start, rot.cont, rot.mouse,
		anim.x, anim.y, anim.speed
end

-- Localize for better performance
local player_set_animation = player_api.set_animation
local player_attached = player_api.player_attached
local parse_preview_params = player_api.parse_preview_params

function player_api.preview_model(player, x, y, w, h, rot, textures, animation,
		speed, gender, hide_wielditem)
	local model = "model[%.2f,%.2f;%.2f,%.2f;%s;%s;%s;0,%d;%s;%s;%u,%u;%u" .. "]"

	local model_fs = -- "style[player_preview;bgcolor=black]" ..
		fmt(model, x, y, w, h, parse_preview_params(
			player, rot, textures, animation, speed, gender, hide_wielditem))

	return model_fs
end

local function check_node(ppos, num, liquid)
	local pos = {x = ppos.x, y = ppos.y, z = ppos.z}
	if liquid then
		pos.y = floor(pos.y)
	end
	local nodes, result = {}, {}

	for i = 0, num - 1 do
		local node = minetest.get_node_or_nil({x = pos.x, y = pos.y - i, z = pos.z})
		if node then
			nodes[i + 1] = node.name
		end
	end

	for _, nname in ipairs(nodes) do
		local def = minetest.registered_nodes[nname]
		if not def then return false end

		if liquid then
			if def.liquidtype ~= "none" then
				result[#result + 1] = true
			end
		else
			if def.drawtype == "airlike" then
				result[#result + 1] = true
			end
		end
	end

	return #result == num
end

local function animate_player(player, name)
	local player_data = get_player_data(player)
	local model = models[player_data.model] or models[default_model]
	if model and not player_attached[name] and not player:get_attach() then
		if player:get_hp() == 0 then
			player_set_animation(player, "lay")
			return
		end

		local controls = player:get_player_control()
		local animation_speed_mod = model.animation_speed or 30
		local pos = player:get_pos()

		local move = controls.up or controls.down or controls.left or controls.right
		local c_moving = move and "walk" or "stand"
		local c_sneaking = controls.sneak and "sneak"
		local c_mouseclick = (controls.LMB or controls.RMB) and "mine" or nil
		local c_flying = player_data.flying
		local c_swimming = player_data.swimming

		local old_pos = player_data.old_pos or vnew()
		if not vequals(old_pos, pos) then
			if minetest.get_player_privs(name).fly == true then
				c_flying = check_node(pos, 3) and "fly"
			end

			if not c_flying then
				c_swimming = check_node(pos, 2, true) and "swim"
			end

			player_data.old_pos = pos
			player_data.flying = c_flying
			player_data.swimming = c_swimming
		end

		local c_special
		-- Override sneaking animation while flying and swimming
		if c_flying then
			if minetest.get_player_privs(name).fly == true then
				c_special = c_flying
			end
		elseif c_swimming then
			c_special = c_swimming
		elseif c_sneaking then
			if not c_flying and not c_swimming then
				c_special = c_sneaking
				-- Determine if the player is sneaking, and reduce animation speed if so
				animation_speed_mod = animation_speed_mod / 2
			end
		end

		local item = player:get_wielded_item():get_name()
		if not item or item == "" then
			c_special = not c_special and "hand" or c_special
		end

		-- Apply animation
		local anim = {}
		anim[#anim + 1] = c_special
		anim[#anim + 1] = c_moving
		anim[#anim + 1] = c_mouseclick

		local mode = c_special or c_sneaking
		player_set_animation(player, tconcat(anim, "_"), animation_speed_mod, mode)
	end
end

-- Check each player and apply animations
minetest.register_playerstep(function(_, playernames)
	for _, name in ipairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			animate_player(player, name)
		end
	end
end, true) -- Force this callback to run every step for smoother animations

sscsm.register({
	name = "player_api",
	file = minetest.get_modpath("player_api") .. "/sscsm.lua"
})

function player_api.update_sscsm_preview(player, name)
	local _, mesh, _, rot_start, rot_cont, rot_mouse,
		anim_x, anim_y, anim_speed = parse_preview_params(player, nil, "", nil, nil, nil, true)
	sscsm.com_send(name, "player_api:preview", {
		mesh, player_api.get_textures(player),
		rot_start, rot_cont, rot_mouse, anim_x, anim_y, anim_speed
	})
end

sscsm.register_on_sscsms_loaded(function(name)
	player_api.update_sscsm_preview(minetest.get_player_by_name(name), name)
end)
