local age                   = 1 --How old an item has to be before collecting
local radius_magnet         = 2 --Radius of item magnet
local player_collect_height = 1.3 --Added to their pos y value

--Item collection
minetest.register_globalstep(function(dtime)
	--collection
	for _,player in ipairs(minetest.get_connected_players()) do
		--don't magnetize to dead players
		if player:get_hp() > 0 then
			local pos = player:get_pos()
			local inv = player:get_inventory()
			--radial detection
			for _,object in ipairs(minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y + player_collect_height,z=pos.z}, radius_magnet)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().age > age then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							--collect
							if object:get_luaentity().collectioner == true and object:get_luaentity().age > age and object:get_luaentity().age > object:get_luaentity().age_stamp then							
							if object:get_luaentity().itemstring ~= "" then
								inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
								minetest.sound_play("item_drop_pickup", {
									pos = pos,
									max_hear_distance = 15,
									gain = 0.1,
								})
								object:get_luaentity().itemstring = ""
								object:remove()
							end
							
							--magnet
							else
								--moveto for extreme speed boost
								local pos1 = pos
								pos1.y = pos1.y + player_collect_height
								object:moveto(pos1)
								object:get_luaentity().collectioner = true
								object:get_luaentity().age_stamp = object:get_luaentity().age
							
						end
					end
				end
			end
			end
		end
	end
end)

--Drop items on dig
--This only works in survival
if minetest.setting_getbool("creative_mode") == false then
	function minetest.handle_node_drops(pos, drops, digger)
		for _,item in ipairs(drops) do
			local count, name
			if type(item) == "string" then
				count = 1
				name = item
			else
				count = item:get_count()
				name = item:get_name()
			end
			--if not inv or not inv:contains_item("main", ItemStack(name)) then
				for i=1,count do
					local obj = minetest.add_item(pos, name)
					if obj ~= nil then
						obj:get_luaentity().collect = true
						obj:get_luaentity().age = age
					obj:setvelocity({x=math.random(-3,3), y=math.random(2,5), z=math.random(-3,3)})
			end
		end
		end
	end
end


--Throw items using player's velocity
function minetest.item_drop(itemstack, dropper, pos)

	--if player then do modified item drop
	if dropper and minetest.get_player_information(dropper:get_player_name()) then
		local v = dropper:get_look_dir()
		local vel = dropper:get_player_velocity()
		local p = {x=pos.x, y=pos.y+player_collect_height, z=pos.z}
		local item = itemstack:to_string()
		local obj = core.add_item(p, item)
		if obj then
			v.x = (v.x*5)+vel.x
			v.y = ((v.y*5)+2)+vel.y
			v.z = (v.z*5)+vel.z
			obj:setvelocity(v)
			obj:get_luaentity().dropped_by = dropper:get_player_name()
			itemstack:clear()
			return itemstack
		end
	--machine
	else
		local v = dropper:get_look_dir()
		local item = itemstack:to_string()
		local obj = minetest.add_item({x=pos.x,y=pos.y+1.5,z=pos.z}, item) --{x=pos.x+v.x,y=pos.y+v.y+1.5,z=pos.z+v.z}
			if obj then
			v.x = (v.x*5)
			v.y = (v.y*5)
			v.z = (v.z*5)
			obj:setvelocity(v)
			obj:get_luaentity().dropped_by = nil
			itemstack:clear()
			return itemstack
		end
	end
end
