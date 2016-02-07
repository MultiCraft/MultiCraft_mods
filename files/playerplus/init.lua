--[[
	walking on ice makes player walk faster,
	stepping through snow or water slows player down,
	touching a cactus hurts player,
	stuck inside node suffocates player.

	PlayerPlus by TenPlus1
]]

pp = {}

local time = 0
minetest.register_globalstep(function(dtime)

	time = time + dtime
	local def = {}

	-- every 1 second
	if time > 1 then

		-- reset time for next check
		time = 0

		-- check players
		for _,player in ipairs(minetest.get_connected_players()) do
			
			-- where am I?
			local pos = player:getpos()
				
			-- what is around me?
			pos.y = pos.y - 0.1 -- standing on
			local nod_stand = minetest.get_node(pos).name

			pos.y = pos.y + 1.5 -- head level
			local nod_head = minetest.get_node(pos).name
	
			pos.y = pos.y - 1.2 -- feet level
			local nod_feet = minetest.get_node(pos).name
	
			pos.y = pos.y - 0.2 -- reset pos

			-- is 3d_armor mod active? if so make armor physics default
			if minetest.get_modpath("3d_armor") then
				def = armor.def[player:get_player_name()] or nil
			end

			-- set to armor physics or defaults
			pp.speed = def.speed or 1
			pp.jump = def.jump or 1
			pp.gravity = def.gravity or 1

			-- standing on ice? if so walk faster
			if nod_stand == "default:ice" then
				pp.speed = pp.speed + 0.4
			end

			-- standing on snow? if so walk slower
			if nod_stand == "default:snow"
			or nod_stand == "default:snowblock"
			-- wading in water? if so walk slower
			or nod_feet == "default:water_flowing"
			or nod_feet ==  "default:water_source" then
				pp.speed = pp.speed - 0.4
			end
				
			-- set player physics
			player:set_physics_override(pp.speed, pp.jump, pp.gravity)
			--print ("Speed:", pp.speed, "Jump:", pp.jump, "Gravity:", pp.gravity)

			-- is player suffocating inside node? (only nodes found in default game)
			if minetest.registered_nodes[nod_head]
			and minetest.registered_nodes[nod_head].walkable
			and nod_head:find("default:")
			and not minetest.check_player_privs(player:get_player_name(), {noclip=true}) then
				if player:get_hp() > 0 then
					player:set_hp(player:get_hp()-1)
				end
			end

			-- am I near a cactus?
			local near = minetest.find_node_near(pos, 1, "default:cactus")
			if near then
					
				-- am I touching the cactus? if so it hurts
				for _,object in ipairs(minetest.get_objects_inside_radius(near, 1.0)) do
					if object:get_hp() > 0 then
						object:set_hp(object:get_hp()-1)
					end
				end

			end

		end
		
	end
end)
