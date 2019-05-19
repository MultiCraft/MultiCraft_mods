local age = 0.5 --How old an item has to be before collecting
local radius_magnet = 2 --Radius of item magnet
local player_collect_height = 1.3 --Added to their pos y value

local function collect_items(player)
	local pos = player:get_pos()
	if not pos then
		return
	end
	local col_pos = vector.add(pos, {x=0, y=player_collect_height, z=0})
	local objects = minetest.get_objects_inside_radius(col_pos, radius_magnet)
	for _,object in ipairs(objects) do
		local entity = object:get_luaentity()
		if entity and not object:is_player() and
				entity.name == "__builtin:item" and entity.age > age then
			if entity.collectioner == true and entity.age > entity.age_stamp then
				local inv = player:get_inventory()
				local item = ItemStack(entity.itemstring)
				--collect
				if item:get_name() ~= "" and inv and
						inv:room_for_item("main", item) then
					inv:add_item("main", item)
					minetest.sound_play("item_drop_pickup", {
						pos = pos,
						max_hear_distance = 15,
						gain = 0.1,
					})
					entity.itemstring = ""
					object:remove()
				end
			else
				--magnet, moveto for extreme speed boost
				object:moveto(col_pos)
				entity.collectioner = true
				entity.age_stamp = entity.age
			end
		end
	end
end

local function table_iter(t)
	local i = 0
	local n = table.getn(t)
	return function ()
		i = i + 1
		if i <= n then
			return t[i]
		end
	end
end

local player_iter = nil

--Item collection
minetest.register_globalstep(function()
	if player_iter == nil then
		local names = {}
		for player in table_iter(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if name then
				table.insert(names, name)
			end
		end
		player_iter = table_iter(names)
	end
	 -- only deal with one player per server step
	local name = player_iter()
	if name then
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() and player:get_hp() > 0 then
			--radial detection
			collect_items(player)
			return
		end
	end
	player_iter = nil
end)

--Drop items on dig
--This only works in survival
if minetest.setting_getbool("creative_mode") == false then
	function minetest.handle_node_drops(pos, drops)
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
			for _ = 1, count do
				local obj = minetest.add_item(pos, name)
				if obj ~= nil then
					obj:get_luaentity().collect = true
					obj:get_luaentity().age = 0
					obj:setvelocity({
						x = math.random(-3, 3),
						y = math.random(2, 5),
						z = math.random(-3, 3)
					})
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
