--[[
	walking on ice makes player walk faster,
	stepping through snow or water slows player down,
	touching a cactus hurts player,
	and	suffocation when head is inside solid node,.

	PlayerPlus by TenPlus1
]]

playerplus = {}

-- get node but use fallback for nil or unknown
local node_ok = function(pos, fallback)

	fallback = fallback or "air"

	local node = minetest.get_node_or_nil(pos)

	if node and minetest.registered_nodes[node.name] then
		return node.name
	end

	return fallback
end


local armor_mod = minetest.get_modpath("3d_armor")
--local def = {}
local time = 0


minetest.register_globalstep(function(dtime)

	time = time + dtime

	-- every 1 second
	if time < 1 then
		return
	end

	-- reset time for next check
	time = 0

	-- define locals outside loop
	local name, pos, ndef, def, nslow, nfast

	-- loop through players
	for _,player in ipairs(minetest.get_connected_players()) do

		-- who am I?
		name = player:get_player_name()

		-- where am I?
		pos = player:get_pos()

		-- what is around me?
		pos.y = pos.y - 0.1 -- standing on
		playerplus[name].nod_stand = node_ok(pos)

		-- Does the node below me have an on_walk_over function set?
		ndef = minetest.registered_nodes[playerplus[name].nod_stand]
		if ndef and ndef.on_walk_over then
			ndef.on_walk_over(pos, ndef, player)
		end

		pos.y = pos.y + 1.5 -- head level
		playerplus[name].nod_head = node_ok(pos)
	
		pos.y = pos.y - 1.2 -- feet level
		playerplus[name].nod_feet = node_ok(pos)

		pos.y = pos.y - 0.2 -- reset pos

		-- get player physics
		def = player:get_physics_override()

		if armor_mod and armor and armor.def then
			-- get player physics from armor
			def.speed = armor.def[name].speed or def.speed
			def.jump = armor.def[name].jump or def.jump
			def.gravity = armor.def[name].gravity or def.gravity
		end

		-- are we standing on any nodes that speed player up?
		nfast = nil
		if playerplus[name].nod_stand == "default:ice" then
			nfast = true
		end

		-- are we standing on any nodes that slow player down?
		nslow = nil
		if playerplus[name].nod_stand == "default:snow"
		or playerplus[name].nod_stand == "default:snowblock"
		-- The probable cause of the bug when swimming under water on the server!
		or minetest.registered_nodes[ playerplus[name].nod_feet ].groups.water then
			nslow = true
		end

		-- apply speed changes
		if nfast and not playerplus[name].nfast then
			def.speed = def.speed + 0.4
		
			playerplus[name].nfast = true
		
		elseif not nfast and playerplus[name].nfast then
			def.speed = def.speed - 0.4

			playerplus[name].nfast = nil
		end

		-- apply slowdown changes
		if nslow and not playerplus[name].nslow then
			def.speed = def.speed - 0.3

			playerplus[name].nslow = true

		elseif not nslow and playerplus[name].nslow then
			def.speed = def.speed + 0.3

			playerplus[name].nslow = nil
		end
		
	-- set player physics
		player:set_physics_override(def.speed, def.jump, def.gravity)
--[[
		print ("Speed: " .. def.speed
			.. " / Jump: " .. def.jump
			.. " / Gravity: " .. def.gravity)
]]
		-- Is player suffocating inside a normal node without no_clip privs?
		local ndef = minetest.registered_nodes[playerplus[name].nod_head]

		if ndef.walkable == true
		and ndef.drowning == 0
		and ndef.damage_per_second <= 0
		and ndef.groups.disable_suffocation ~= 1
		and ndef.drawtype == "normal"
		and not minetest.check_player_privs(name, {noclip = true}) then

			if player:get_hp() > 0 then
				player:set_hp(player:get_hp() - 2)
			end
		end

		-- am I near a cactus?
		local near = minetest.find_node_near(pos, 1, "default:cactus")

		if near then

			-- am I touching the cactus? if so it hurts
			for _,object in pairs(minetest.get_objects_inside_radius(near, 1.1)) do

				if object:get_hp() > 0 then
					object:set_hp(object:get_hp() - 2)
				end
			end

		end

	end

end)


-- set to blank on join (for 3rd party mods)
minetest.register_on_joinplayer(function(player)

	local name = player:get_player_name()

	playerplus[name] = {}
	playerplus[name].nod_head = ""
	playerplus[name].nod_feet = ""
	playerplus[name].nod_stand = ""
end)


-- clear when player leaves
minetest.register_on_leaveplayer(function(player)

	playerplus[ player:get_player_name() ] = nil
end)
