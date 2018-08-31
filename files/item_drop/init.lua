--Item collection
minetest.register_globalstep(function(dtime)
	--basic settings
	local age                   = 1 --how old an item has to be before collecting
	local radius_magnet         = 2.0 --radius of item magnet
	local radius_collect        = 0.3 --radius of collection
	local player_collect_height = 1.2 --added to their pos y value
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 then
			local pos = player:get_pos()
			local inv = player:get_inventory()
			--collection
			for _,object in ipairs(minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y + player_collect_height,z=pos.z}, radius_collect)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().age > age then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							
							if object:get_luaentity().itemstring ~= "" then
								inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
								minetest.sound_play("item_drop_pickup", {
									pos = pos,
									max_hear_distance = 50,
									gain = 0.1,
								})
								object:get_luaentity().itemstring = ""
								object:remove()
							end
							
							
						end
					end
				end
			end
			--magnet
			for _,object in ipairs(minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y + player_collect_height,z=pos.z}, radius_magnet)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().age > age then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							local pos1 = pos
							local pos2 = object:getpos()
							local vec = {x=pos1.x-pos2.x, y=(pos1.y+player_collect_height)-pos2.y, z=pos1.z-pos2.z}
							vec.x = pos2.x + (vec.x/2)
							vec.y = pos2.y + (vec.y/2)
							vec.z = pos2.z + (vec.z/2)
							object:moveto(vec)
							object:get_luaentity().physical_state = false
							object:get_luaentity().object:set_properties({
								physical = false
							})
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
		local inv
		if minetest.setting_getbool("creative_mode") and digger and digger:is_player() then
			inv = digger:get_inventory()
		end
		for _,item in ipairs(drops) do
			local count, name
			if type(item) == "string" then
				count = 1
				name = item
			else
				count = item:get_count()
				name = item:get_name()
			end
			if not inv or not inv:contains_item("main", ItemStack(name)) then
				for i=1,count do
					local obj = minetest.env:add_item(pos, name)
					if obj ~= nil then
						--obj:get_luaentity().timer = 
						obj:get_luaentity().collect = true
						local x = math.random(1, 5)
						if math.random(1,2) == 1 then
							x = -x
						end
						local z = math.random(1, 5)
						if math.random(1,2) == 1 then
							z = -z
						end
						obj:setvelocity({x=1/x, y=obj:get_velocity().y, z=1/z})
						obj:get_luaentity().age = 0.6
						-- FIXME this doesnt work for deactiveted objects
						if minetest.setting_get("remove_items") and tonumber(minetest.setting_get("remove_items")) then
							minetest.after(tonumber(minetest.setting_get("remove_items")), function(obj)
								obj:remove()
							end, obj)
						end
					end
				end
			end
		end
	end
end

--throw items using player's velocity
function minetest.item_drop(itemstack, dropper, pos)
	--do this to prevent dispensers and other things using this function from breaking
	
	--check if player
	local is_player = false
	if dropper then
		if minetest.get_player_information(dropper:get_player_name()) then
			is_player = true
		end
	end
	--if player then do modified item drop
	if dropper and is_player == true then
		local v = dropper:get_look_dir()
		local vel = dropper:get_player_velocity()
		local p = {x=pos.x, y=pos.y+1.3, z=pos.z}

		local item = itemstack:to_string()
		local obj = core.add_item(p, item)
		if obj then
			v.x = (v.x*5)+vel.x
			v.y = ((v.y*5)+2)+vel.y
			v.z = (v.z*5)+vel.z
			obj:setvelocity(v)
			obj:get_luaentity().dropped_by = dropper:get_player_name()
			--obj:get_luaentity().collect = true
			itemstack:clear()
			return itemstack
		end
	else --if machine then use default item drop to not break mods - also extend reach
		local v = dropper:get_look_dir()
		local p = {x=pos.x+v.x, y=pos.y+1.5+v.y, z=pos.z+v.z}
		local cs = itemstack:get_count()
		if dropper:get_player_control().sneak then
			cs = 1
		end
		local item = itemstack:take_item(cs)
		local obj = core.add_item(p, item)
		if obj then
			v.x = v.x*5
			v.y = v.y*5 + 2
			v.z = v.z*5
			obj:setvelocity(v)
			obj:get_luaentity().dropped_by = dropper:get_player_name()
			return itemstack
		end
	end
end
