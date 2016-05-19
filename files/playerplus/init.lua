--[[
	walking on ice makes player walk faster,
	stepping through snow or water slows player down,
	touching a cactus hurts player,
	stuck inside node suffocates player.

	PlayerPlus by TenPlus1
]]

-- get node but use fallback for nil or unknown
local function node_ok(pos, fallback)

	fallback = fallback or "air"

	local node = minetest.get_node_or_nil(pos)

	if not node then
		return fallback
	end

	if minetest.registered_nodes[node.name] then
		return node.name
	end

	return fallback
end

local pp = {}
local def = {}
local time = 0

minetest.register_globalstep(function(dtime)

	time = time + dtime

	-- every 1 second
	if time < 1 then
		return
	end

	-- reset time for next check
	time = 0

	-- check players
	for _,player in pairs(minetest.get_connected_players()) do

		-- where am I?
		local pos = player:getpos()

		-- what is around me?
		pos.y = pos.y - 0.1 -- standing on
		local nod_stand = node_ok(pos)

		pos.y = pos.y + 1.5 -- head level
		local nod_head = node_ok(pos)
	
		pos.y = pos.y - 1.2 -- feet level
		local nod_feet = node_ok(pos)

		pos.y = pos.y - 0.2 -- reset pos

		-- is 3d_armor mod active? if so make armor physics default
		if minetest.get_modpath("3d_armor") then
			def = armor.def[player:get_player_name()] or {}
		end

		-- set to armor physics or defaults
		pp.speed = def.speed or 1
		pp.jump = def.jump or 1
		pp.gravity = def.gravity or 1

		-- standing on ice? if so walk faster
		if nod_stand == "default:ice" then
			pp.speed = pp.speed + 0.6
		end

		-- standing on snow? if so walk slower
		if nod_stand == "default:snow"
		or nod_stand == "default:snowblock"
		-- wading in water? if so walk slower
		or minetest.registered_nodes[nod_feet].groups.water then
			pp.speed = pp.speed - 0.1
		end

		-- set player physics
		player:set_physics_override(pp.speed, pp.jump, pp.gravity)
		--print ("Speed:", pp.speed, "Jump:", pp.jump, "Gravity:", pp.gravity)

		-- is player suffocating inside node? (only solid "normal" type nodes)
		if minetest.registered_nodes[nod_head].walkable
		and minetest.registered_nodes[nod_head].drawtype == "normal"
		and not minetest.check_player_privs(player:get_player_name(), {noclip = true}) then

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
