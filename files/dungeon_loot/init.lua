-- "Dungeon Loot" [dungeon_loot]
-- Copyright (c) 2015 BlockMen <blockmen2015@gmail.com>
--
-- init.lua
--
-- This software is provided 'as-is', without any express or implied warranty. In no
-- event will the authors be held liable for any damages arising from the use of
-- this software.
--
-- Permission is granted to anyone to use this software for any purpose, including
-- commercial applications, and to alter it and redistribute it freely, subject to the
-- following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
-- claim that you wrote the original software. If you use this software in a
-- product, an acknowledgment in the product documentation is required.
-- 2. Altered source versions must be plainly marked as such, and must not
-- be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
--


-- Following Code (everything before fill_chest) by Amoeba <amoeba@iki.fi>
dungeon_loot = {}
dungeon_loot.version = 1.2

-- Load other file(s)
local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/config.lua") 		-- All the constants for simple tuning


local function get_max_loot(loot_list, depth)
	local loot_type = loot_list[1].name
	local loot_min_depth = loot_list[1].min_depth
	for i,v in ipairs(loot_list) do
		if v.min_depth < depth then
			loot_type = v.name
			loot_min_depth = v.min_depth
		else
			break
		end
	end
	return loot_type, loot_min_depth
end

local function get_basic_loot(loot_list, depth)
	local loot_type = ""
	local loot_amount = 0
	local total_chance = 0
	for i,v in ipairs(loot_list) do
		if v.chance_and_amount then
			total_chance = total_chance + v.chance_and_amount
		elseif v.chance then
			total_chance = total_chance + v.chance
		else
			error("No chance_and_amount or chance found in basic_list table.")
			return nil, 0
		end
	end
	local leftover = math.random(1,total_chance)
	local type_amount = 0
	for i,v in ipairs(loot_list) do
		if v.chance_and_amount then
			leftover = leftover - v.chance_and_amount
		elseif v.chance then
			leftover = leftover - v.chance
		end
		if leftover < 1 then
			loot_type = v.name
			if v.chance_and_amount then
				type_amount = v.chance_and_amount
			else
				type_amount = v.amount
			end
			break
		end
	end
	if loot_type == "" then 	-- Paranoia
		error("Unable to choose a loot_type from basic_list table.")
		return nil, 0
	end
	loot_amount = math.random(1,math.ceil(type_amount/2))
	if depth > dungeon_loot.depth_first_basic_increase then
		loot_amount = math.random(1,type_amount)
	end
	if depth > dungeon_loot.depth_second_basic_increase then
		loot_amount = math.random(1,type_amount*2)
	end
	return loot_type, loot_amount
end

local function get_item_and_amount(list_item, actual_depth)
	if list_item.chance < math.random() then
		return nil, 0
	end
	-- Suspicious trickery
	list_name = nil
	list_name_string = "dungeon_loot." .. list_item.name .. "_list"
-- 	list_name = _G[list_name_string]
	lsf = loadstring("list_name = " .. list_name_string)
	lsf()
	if list_name == nil then
		error("Unable to connect " .. list_name_string .. " to actual table")
		return nil, 0
	end
	local amount = 0
	local loot_type = ""
	local loot_depth = 0
	local max_depth = 1
	if actual_depth < 0 then
		max_depth = math.ceil(math.abs(actual_depth))
	end
	if list_item.type == "depth_cutoff" then
		local rnd_depth = math.random(1,max_depth)
 		loot_type, loot_depth = get_max_loot(list_name, rnd_depth)
		if list_item.max_amount == 1 then 	-- For tools & weapons
			amount = 1
		else
			-- Stop large amounts of the first item
			if loot_depth < 1 then
				loot_depth = 5
			end
			local leftover = rnd_depth
			while leftover > 0 do
				amount = amount + 1
				leftover = leftover - math.random(1,loot_depth)
				leftover = leftover - math.ceil(loot_depth/2)
			end
		end
	elseif list_item.type == "basic_list" then
		loot_type, amount = get_basic_loot(list_name, max_depth)
	else
		error("Got unknown loot table type " .. list_item.type)
		loot_type = nil
	end
	-- Hey, if you leave out the max_amount, you deserve what you get
	if list_item.max_amount and amount > list_item.max_amount then
		amount = list_item.max_amount
	end
	return loot_type, amount
end

local function fill_chest(pos)
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		if n and n.name and n.name == "default:chest" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
			for i,v in ipairs(dungeon_loot.loot_types) do
				local item, num = get_item_and_amount(v,pos.y)
				if item then
					local stack = ItemStack({name = item, count = num, wear = 0, metadata = ""})
					inv:set_stack("main",i,stack)
				end
			end
		end
	end)
end

-- Place chest in dungeons

local function place_spawner(tab)
	if tab == nil or #tab < 1 then
		return
	end
	local pos = tab[math.random(1, #tab)]
	pos.y = pos.y - 1
	local below = core.get_node_or_nil(pos)
	if below and below.name ~= "air" then
		pos.y = pos.y + 1
		core.set_node(pos, {name = "default:chest"})
		fill_chest(pos)
	end
end

core.set_gen_notify("dungeon")
core.register_on_generated(function(minp, maxp, blockseed)
	local ntf = core.get_mapgen_object("gennotify")
	if ntf and ntf.dungeon and #ntf.dungeon >= dungeon_loot.min_num_of_rooms then
		core.after(3, place_spawner, table.copy(ntf.dungeon))
	end
end)
