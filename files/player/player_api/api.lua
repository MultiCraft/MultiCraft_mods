-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local animation_blend = 0
local enable_sscsm = minetest.global_exists("sscsm")

player_api.registered_models = {}

-- Local for speed
local models = player_api.registered_models

function player_api.register_model(name, def)
	models[name] = def
end

-- Player stats and animations
local player_model = {}
local player_textures = {}
local player_anim = {}
local player_sneak = {}

player_api.player_skin = {}
player_api.player_armor = {}
player_api.player_cape = {}
local player_wielditem = {}
local player_cube = {}

local b = "blank.png"

local player_skin, player_armor, player_cape =
		player_api.player_skin, player_api.player_armor, player_api.player_cape

player_api.wielded_item = {}
player_api.player_attached = {}

function player_api.get_animation(player)
	local name = player:get_player_name()
	return {
		model = player_model[name],
		textures = player_textures[name],
		animation = player_anim[name]
	}
end

-- Called when a player's appearance needs to be updated
function player_api.set_model(player, model_name)
	local name = player:get_player_name()
	local model = models[model_name]
	if player_model[name] == model_name then
		return
	end
	player:set_properties({
		mesh = model_name,
		textures = player_textures[name] or model.textures,
		visual = "mesh",
		visual_size = model.visual_size or {x = 1, y = 1},
		collisionbox = model.collisionbox or {-0.3, 0.0, -0.3, 0.3, 1.75, 0.3},
		stepheight = model.stepheight or 0.6,
		eye_height = model.eye_height or 1.47
	})
	player_api.set_animation(player, "stand")
	player_model[name] = model_name
end

function player_api.set_textures(player, skin, armor, wielditem, cube, cape)
	local name = player:get_player_name()

	local oldskin      = player_skin[name]      or "character.png"
	local oldarmor     = player_armor[name]     or b
	local oldwielditem = player_wielditem[name] or b
	local oldcube      = player_cube[name]      or b
	local oldcape      = player_cape[name]      or b

	skin      = skin      or oldskin
	armor     = armor     or oldarmor
	wielditem = wielditem or oldwielditem
	cube      = cube      or oldcube
	cape      = cape      or oldcape

	if oldskin ~= skin then
		player_skin[name] = skin
	end
	if oldarmor ~= armor then
		player_armor[name] = armor
	end
	if oldwielditem ~= wielditem then
		player_wielditem[name] = wielditem
	end
	if oldcube ~= cube then
		player_cube[name] = cube
	end
	if oldcape ~= cape then
		player_cape[name] = cape
	end

	local texture = {skin, armor, wielditem, cube, cape}

	local skip = false
	if player_textures[name] then
		skip = true
		for i = 1, #texture do
			if texture[i] ~= player_textures[name][i] then
				skip = false
				break
			end
		end
	end

	if not skip then
		player_textures[name] = texture
		player:set_properties({textures = texture})

		if enable_sscsm and sscsm.has_sscsms_enabled(name) then
			sscsm.com_send(name, "player_api:preview", player_api.preview(player))
		end
	end
end

function player_api.set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	if player_anim[name] == anim_name then
		return
	end
	local model = player_model[name] and models[player_model[name]]
	if not (model and model.animations[anim_name]) then
		return
	end
	player_anim[name] = anim_name
	local anim_speed = speed or model.animation_speed
	player:set_animation(model.animations[anim_name], anim_speed, animation_blend, true)
end

function player_api.set_sneak(player, sneak, speed)
	local name = player:get_player_name()
	local model = player_model[name] and models[player_model[name]]
	local anim = model.animations
	local anim_speed = speed or model.animation_speed

	if sneak then
		-- Set snaaking local animation
		player:set_local_animation(
			anim["sneak_stand"],
			anim["sneak_walk"],
			anim["sneak_mine"],
			anim["sneak_walk_mine"],
			anim_speed)

		-- Hide nametag
		local nametag = player:get_nametag_attributes()
		nametag.color.a = 0
		player:set_nametag_attributes(nametag)
	else
		-- Back normal local animation
		player:set_local_animation(
			anim["stand"],
			anim["walk"],
			anim["mine"],
			anim["walk_mine"],
			anim_speed)

		-- Show nametag
		local nametag = player:get_nametag_attributes()
		nametag.color.a = 255
		player:set_nametag_attributes(nametag)
	end
end

function player_api.preview(player, skin, head)
	local c = b
	if player then
		local name = player:get_player_name()
		local model = models[player_model[name]] or models["character.b3d"]
		local texture = player_textures[name] or model.textures
		c = "(" .. texture[1] .. "^" .. texture[2] .. ")"
	elseif skin then
		c = skin
	end

	local texture
	if head then
		texture = "[combine:16x16:-16,-16=" .. c											-- Head
	else
		texture = "((" ..
			"([combine:32x64:0,0=" .. c .. "^[mask:player_api_leg.png)^" ..					-- Left Leg
			"([combine:32x64:0,0=" .. c .. "^[mask:player_api_leg.png^[transformFX)^" ..	-- Right Leg

			"([combine:32x64:-8,-16=" .. c .. "^[mask:player_api_head.png)^" ..				-- Head

			"([combine:32x64:-32,-24=" .. c .. "^[mask:player_api_chest.png)^" ..			-- Chest

			"([combine:32x64:-72,-16=" .. c .. "^[mask:player_api_head.png)^" ..			-- Helmet

			"([combine:32x64:-88,-24=" .. c .. "^[mask:player_api_arm.png)^" ..				-- Left Arm
			"([combine:32x64:-88,-24=" .. c .. "^[mask:player_api_arm.png^[transformFX)" ..	-- Right Arm

			")^[resize:128x256)^[mask:player_api_transform.png"								-- Full texture
	end

	return texture
end

-- Localize for better performance
local player_set_animation = player_api.set_animation
local player_set_sneak = player_api.set_sneak
local player_attached = player_api.player_attached

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_model[name] = nil
	player_anim[name] = nil
	player_textures[name] = nil

	player_skin[name] = nil
	player_armor[name] = nil
	player_cape[name] = nil
	player_wielditem[name] = nil
	player_cube[name] = nil
	player_api.wielded_item[name] = nil

	player_attached[name] = nil
	player_sneak[name] = nil
end)

-- Check each player and apply animations
minetest.register_playerstep(function(_, playernames)
	for _, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			local model_name = player_model[name]
			local model = model_name and models[model_name]
			if model and not player_attached[name] then
				local animation_speed_mod = model.animation_speed or 30

				-- Apply animations based on what the player is doing
				if player:get_hp() == 0 then
					player_set_animation(player, "lay")
					return
				end

				local controls = player:get_player_control()
				local c_sneak = controls.sneak
				local c_mouse = controls.LMB or controls.RMB

				-- Determine if the player is sneaking, and reduce animation speed if so
				if c_sneak then
					animation_speed_mod = animation_speed_mod / 2
				end

				-- Determine if the player is sneaking
				if player_sneak[name] ~= c_sneak then
					player_anim[name] = nil
					player_sneak[name] = c_sneak
					player_set_sneak(player, c_sneak, animation_speed_mod)
				end

				-- Determine if the player is walking
				if controls.up or controls.down or controls.left or controls.right then
					if not c_sneak then
						if c_mouse then
							player_set_animation(player, "walk_mine", animation_speed_mod)
						else
							player_set_animation(player, "walk", animation_speed_mod)
						end
					else
						if c_mouse then
							player_set_animation(player, "sneak_walk_mine", animation_speed_mod)
						else
							player_set_animation(player, "sneak_walk", animation_speed_mod)
						end
					end
				elseif c_mouse then
					if not c_sneak then
						player_set_animation(player, "mine", animation_speed_mod)
					else
						player_set_animation(player, "sneak_mine", animation_speed_mod)
					end
				elseif c_sneak then
					player_set_animation(player, "sneak_stand", animation_speed_mod)
				else
					player_set_animation(player, "stand", animation_speed_mod)
				end
			end

			-- Update wielditem
			player_api.update_wielded_item(player, name)
		end
	end
end, true) -- Force this callback to run every step for smoother animations

if enable_sscsm then
	sscsm.register({
		name = "player_api",
		file = minetest.get_modpath("player_api") .. "/sscsm.lua"
	})

	sscsm.register_on_sscsms_loaded(function(name)
		local player = minetest.get_player_by_name(name)
		sscsm.com_send(name, "player_api:preview", player_api.preview(player))
	end)
end
