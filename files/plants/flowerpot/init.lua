--[[

  Copyright (C) 2015-2017 Auke Kok <sofar@foo-projects.org>
  Copyright (C) 2019-2021 MultiCraft Development Team

  "flowerpot" is free software; you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation; either version 3.0 of
  the license, or (at your option) any later version.

--]]

flowerpot = {}

local S = minetest.get_translator("flowerpot")

local tcopy = table.copy
local b = "blank.png"

-- Handle plant removal from flowerpot
function flowerpot.on_punch(pos, node, puncher)
	if puncher and not
			minetest.check_player_privs(puncher, "protection_bypass") then
		local name = puncher:get_player_name()
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return false
		end
	end

	local nodedef = minetest.registered_nodes[node.name]
	local plant = nodedef.flowerpot_plantname

	minetest.sound_play(nodedef.sounds.dug, {pos = pos})
	minetest.handle_node_drops(pos, {plant}, puncher)
	node.name = "flowerpot:empty"
	minetest.swap_node(pos, node)
end
local on_punch = flowerpot.on_punch

-- Handle plant insertion into flowerpot
local function on_rightclick(pos, node, clicker, itemstack)
	local player_name = clicker and clicker:get_player_name() or ""

	if not minetest.check_player_privs(player_name, "protection_bypass") and
			minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return false
	end

	local nodename = itemstack:get_name()
	if not nodename then
		return false
	end

	local name = "flowerpot:" .. nodename:gsub(":", "_")
	local def = minetest.registered_nodes[name]
	if not def then
		return itemstack
	end
	minetest.sound_play(def.sounds.place, {pos = pos})
	node.name = name
	minetest.swap_node(pos, node)

	if not minetest.is_creative_enabled(player_name) then
		itemstack:take_item()
	end

	return itemstack
end

local function get_tile(def)
	local tiles = {"flowerpot.png"}
	local inventory_image = def.inventory_image

	if inventory_image ~= "" then
		tiles[2] = inventory_image
		tiles[3] = b
	else
		local tile = def.tiles[1]
		if type(tile) == "table" then
			tile = tile.name
		end

		tiles[2] = b
		tiles[3] = tile
	end

	return tiles
end

local function get_height(def)
	local height = 7/16
	local sel_box = def.selection_box

	if sel_box and sel_box.fixed then
		local new_height = sel_box.fixed[5] + 1/12
		if new_height >= 1/6 then
			height = new_height
		end
	end

	return height
end

flowerpot.pot_def = {
	drawtype = "mesh",
	mesh = "flowerpot.b3d",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_defaults(),
	use_texture_alpha = "clip",
	groups = {falling_node = 1, oddly_breakable_by_hand = 3, cracky = 1},
	collision_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, -1/8, 1/4}
	}
}
local pot_def = flowerpot.pot_def

function flowerpot.register_node(nodename)
	local pot_node = "flowerpot:" .. nodename:gsub(":", "_")
	-- prevent duplicates
	if minetest.registered_nodes[pot_node] ~= nil then
		return false
	end

	local def = minetest.registered_nodes[nodename]

	local node = tcopy(pot_def)
	node.tiles = get_tile(def)
	node.selection_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, get_height(def), 1/4}
	}
	node.groups.not_in_creative_inventory = 1
	node.drop = {items = {{items = {"flowerpot:pot", nodename}}}}
	node.flowerpot_plantname = nodename
	node.on_punch = on_punch

	minetest.register_node(":" .. pot_node, node)
end

-- Empty Flowerpot
local empty = tcopy(pot_def)
empty.description = S"Flowerpot"
empty.mesh = "flowerpot.b3d"
empty.tiles = {"flowerpot.png", b, b}
empty.selection_box = {
	type = "fixed",
	fixed = {-1/4, -1/2, -1/4, 1/4, -0.0625, 1/4}
}
empty.groups.not_in_creative_inventory = 1
empty.drop = "flowerpot:pot"
empty.on_rightclick = on_rightclick

minetest.register_node("flowerpot:empty", empty)

-- Inventory Flowerpot
local inv = tcopy(pot_def)
inv.description = S"Flowerpot"
inv.mesh = "flowerpot_inv.b3d"
inv.wield_image2 = "flowerpot_item.png"
inv.tiles = {"flowerpot.png"}
inv.node_placement_prediction = ""
inv.on_place = function(itemstack, placer, pointed_thing)
	if pointed_thing.type == "node" then
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local node_def = minetest.registered_nodes[node.name]
		if node_def and node_def.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return node_def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local _, result = minetest.item_place(ItemStack("flowerpot:empty"),
				placer, pointed_thing)

		if result then
			minetest.sound_play({name = "default_place_node_hard"},
					{pos = pointed_thing.above})
			if not minetest.is_creative_enabled(placer:get_player_name()) then
				itemstack:take_item()
			end
		end
	end

	return itemstack
end

minetest.register_node("flowerpot:pot", inv)

-- Craft
minetest.register_craft({
	output = "flowerpot:pot 2",
	recipe = {
		{"default:clay_brick", "", "default:clay_brick"},
		{"", "default:clay_brick", ""}
	}
})

-- Register pots nodes
local function register_pots()
	local register_pot = flowerpot.register_node
	for name, def in pairs(minetest.registered_nodes) do
		local mod_name = name:split(":")[1]
		local group = def.groups
		if mod_name ~= "flowers" and
				(group.flora or group.sapling) and
				not group.not_in_creative_inventory then
			register_pot(name)
		end
	end
end

do
	register_pots()

	minetest.register_alias("flowerpot:default_grass", "flowerpot:default_grass_1")
	minetest.register_alias("flowerpot:default_dry_grass", "flowerpot:default_dry_grass_1")

	for i = 2, 5 do
		minetest.register_alias("flowerpot:default_grass_" .. i, "flowerpot:default_grass_1")
		minetest.register_alias("flowerpot:default_dry_grass_" .. i, "flowerpot:default_dry_grass_1")
	end
end
