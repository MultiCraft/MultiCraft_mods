-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local animation_blend = 0

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
local player_sneak_nametag = {}

local player_skin = {}
local player_armor = {}
local player_wielditem = {}
local player_cube = {}

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

function player_api.set_textures(player, skin, armor, wielditem, cube)
	local name = player:get_player_name()

	local oldskin      = player_skin[name]      or "character.png"
	local oldarmor     = player_armor[name]     or "blank.png"
	local oldwielditem = player_wielditem[name] or "blank.png"
	local oldcube      = player_cube[name]      or "blank.png"

	skin      = skin      or oldskin
	armor     = armor     or oldarmor
	wielditem = wielditem or oldwielditem
	cube      = cube      or oldcube

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

	local texture = {skin, armor, wielditem, cube}
	player_textures[name] = texture
	player:set_properties({textures = texture})
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
	local anim = model.animations[anim_name]
	player_anim[name] = anim_name
	player:set_animation(anim, speed or model.animation_speed, animation_blend)
end

function player_api.preview(player, skin)
	local c = "blank.png"
	if player then
		local name = player:get_player_name()
		local model = models[player_model[name]]
		skin = player_textures[name] or model.textures
		c = "(" .. skin[1] .. "^" .. skin[2] .. ")"
	elseif skin then
		c = skin
	end

	local texture = "((" ..
		"([combine:32x64:0,0=" .. c .. "^[mask:player_api_leg.png)^" ..					-- Left Leg
		"([combine:32x64:0,0=" .. c .. "^[mask:player_api_leg.png^[transformFX)^" ..	-- Right Leg

		"([combine:32x64:-8,-16=" .. c .. "^[mask:player_api_head.png)^" ..				-- Head

		"([combine:32x64:-32,-24=" .. c .. "^[mask:player_api_chest.png)^" ..			-- Chest

		"([combine:32x64:-72,-16=" .. c .. "^[mask:player_api_head.png)^" ..			-- Helmet

		"([combine:32x64:-88,-24=" .. c .. "^[mask:player_api_arm.png)^" ..				-- Left Arm
		"([combine:32x64:-88,-24=" .. c .. "^[mask:player_api_arm.png^[transformFX)" ..	-- Right Arm

		")^[resize:128x256)^[mask:player_api_transform.png"								-- Full texture

	return texture
end

-- Localize for better performance
local player_set_animation = player_api.set_animation
local player_attached = player_api.player_attached

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_model[name] = nil
	player_anim[name] = nil
	player_textures[name] = nil

	player_skin[name] = nil
	player_armor[name] = nil
	player_wielditem[name] = nil
	player_cube[name] = nil
	player_api.wielded_item[name] = nil

	player_attached[name] = nil
	player_sneak[name] = nil
	player_sneak_nametag[name] = nil
end)

-- Check each player and apply animations
minetest.register_playerstep(function(_, playernames)
	for _, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			local model_name = player_model[name]
			local model = model_name and models[model_name]
			if model and not player_attached[name] then
				local controls = player:get_player_control()
				local animation_speed_mod = model.animation_speed or 30

				-- Determine if the player is sneaking, and reduce animation speed if so
				if controls.sneak then
					animation_speed_mod = animation_speed_mod / 2

					if not player_sneak_nametag[name] then
						local nametag = player:get_nametag_attributes()
						nametag.color.a = 0
						player:set_nametag_attributes(nametag)
						player_sneak_nametag[name] = true
					end
				else
					if player_sneak_nametag[name] then
						local nametag = player:get_nametag_attributes()
						nametag.color.a = 255
						player:set_nametag_attributes(nametag)
						player_sneak_nametag[name] = false
					end
				end

				-- Apply animations based on what the player is doing
				if player:get_hp() == 0 then
					player_set_animation(player, "lay")
				-- Determine if the player is walking
				elseif controls.up or controls.down or controls.left or controls.right then
					if player_sneak[name] ~= controls.sneak then
						player_anim[name] = nil
						player_sneak[name] = controls.sneak
					end
					if controls.LMB or controls.RMB then
						player_set_animation(player, "walk_mine", animation_speed_mod)
					else
						player_set_animation(player, "walk", animation_speed_mod)
					end
				elseif controls.LMB or controls.RMB then
					player_set_animation(player, "mine", animation_speed_mod)
				else
					player_set_animation(player, "stand", animation_speed_mod)
				end
			end

			-- Update wielditem
			player_api.update_wielded_item(player, name)
		end
	end
end, true) -- Force this callback to run every step for smoother animations
