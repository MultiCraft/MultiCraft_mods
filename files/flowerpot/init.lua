--[[

  Copyright (C) 2015-2017 Auke Kok <sofar@foo-projects.org>
  Copyright (C) 2019-2020 MultiCraft Development Team

  "flowerpot" is free software; you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation; either version 3.0 of
  the license, or (at your option) any later version.

--]]

flowerpot = {}

local translator = minetest.get_translator
local S = translator and translator("flowerpot") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local b = "blank.png"

-- Handle plant removal from flowerpot
local function on_punch(pos, node, puncher)
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
	minetest.swap_node(pos, {name = "flowerpot:empty"})
end

-- Handle plant insertion into flowerpot
local function on_rightclick(pos, _, clicker, itemstack)
	if clicker and not
			minetest.check_player_privs(clicker, "protection_bypass") then
		local name = clicker:get_player_name()
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return false
		end
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
	minetest.swap_node(pos, {name = name})
	if not minetest.settings:get_bool("creative_mode") then
		itemstack:take_item()
	end
	return itemstack
end

local function get_tile(def)
	local tiles = {"flowerpot.png"}
	local drawtype = def.drawtype

	if drawtype == "mesh" then
		tiles[2] = "[combine:64x64:0,10=" .. def.inventory_image
		tiles[3] = b
	else
		local tile = def.tiles[1]
		if type(tile) == "table" then
			tile = tile.name
		end

		if drawtype == "plantlike" then
			tiles[2] = tile
			tiles[3] = b
		else
			tiles[2] = b
			tiles[3] = tile
		end
	end


	return tiles
end

local pot = {
	drawtype = "mesh",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_defaults(),
	groups = {falling_node = 1, oddly_breakable_by_hand = 3, cracky = 1},
	collision_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}
	}
}

function flowerpot.register_node(nodename)
	local def = minetest.registered_nodes[nodename]

	local node = table.copy(pot)
	node.mesh = "flowerpot.b3d"
	node.tiles = get_tile(def)
	node.selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
	}
	node.groups.not_in_creative_inventory = 1
	node.drop = {items = {{items = {"flowerpot:pot", nodename}}}}
	node.flowerpot_plantname = nodename
	node.on_punch = on_punch

	minetest.register_node(":flowerpot:" .. def.name:gsub(":", "_"), node)
end

-- Empty Flowerpot
local empty = table.copy(pot)
empty.description = S"Flowerpot"
empty.mesh = "flowerpot.b3d"
empty.tiles = {"flowerpot.png", b, b}
empty.selection_box = {
	type = "fixed",
	fixed = {-0.25, -0.5, -0.25, 0.25, -0.0625, 0.25}
}
empty.groups.not_in_creative_inventory = 1
empty.drop = "flowerpot:pot"
empty.on_rightclick = on_rightclick

minetest.register_node("flowerpot:empty", empty)

-- Inventory Flowerpot
local inv = table.copy(pot)
inv.description = S"Flowerpot"
inv.mesh = "flowerpot_inv.b3d"
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
	for node, def in pairs(minetest.registered_nodes) do
		if def.groups.flora or def.groups.sapling then
			register_pot(node)
		end
	end
end

if minetest.register_on_mods_loaded then
	minetest.register_on_mods_loaded(function()
		register_pots()
	end)
else -- legacy MultiCraft Engine
	minetest.after(0, function()
		register_pots()
	end)
end
