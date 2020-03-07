--[[

  Copyright (C) 2015-2017 Auke Kok <sofar@foo-projects.org>
  Copyright (C) 2019-2020 MultiCraft Development Team

  "flowerpot" is free software; you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation; either version 3.0 of
  the license, or (at your option) any later version.

--]]

flowerpot = {}

-- Handle plant removal from flowerpot
local function flowerpot_on_punch(pos, node, puncher)
	if puncher and not minetest.check_player_privs(puncher, "protection_bypass") then
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
local function flowerpot_on_rightclick(pos, _, clicker, itemstack)
	if clicker and not minetest.check_player_privs(clicker, "protection_bypass") then
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
	local tile = def.tiles[1]
	if type (tile) == "table" then
		return tile.name
	end
	return tile
end

function flowerpot.register_node(nodename)
	local nodedef = minetest.registered_nodes[nodename]
	local name = nodedef.name:gsub(":", "_")
	local plantlike = nodedef.drawtype == "plantlike" and true or false

	minetest.register_node("flowerpot:" .. name, {
		drawtype = "mesh",
		mesh = "flowerpot.obj",
		tiles = {
			{name = "flowerpot.png"},
			{name = plantlike and get_tile(nodedef) or "blank.png"},
			{name = not plantlike and get_tile(nodedef) or "blank.png"}
		},
		paramtype = "light",
		sunlight_propagates = true,
		collision_box = {
			type = "fixed",
			fixed = {-1/4, -1/2, -1/4, 1/4, -1/8, 1/4}
		},
		selection_box = {
			type = "fixed",
			fixed = {-1/4, -1/2, -1/4, 1/4, 7/16, 1/4}
		},
		sounds = default.node_sound_defaults(),
		groups = {attached_node = 1, oddly_breakable_by_hand = 1, snappy = 3, not_in_creative_inventory = 1},
		drop = {
			items = {
				{items = {"flowerpot:empty", nodename}}
			}
		},

		flowerpot_plantname = nodename,

		on_punch = flowerpot_on_punch
	})
end

-- Empty Flowerpot
minetest.register_node("flowerpot:empty", {
	description = "Flowerpot",
	drawtype = "mesh",
	mesh = "flowerpot.obj",
	inventory_image = "flowerpot_item.png",
	wield_image = "flowerpot_item.png",
	tiles = {
		{name = "flowerpot.png"},
		{name = "blank.png"},
		{name = "blank.png"}
	},
	paramtype = "light",
	sunlight_propagates = true,
	collision_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, -1/8, 1/4}
	},
	selection_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, -1/16, 1/4}
	},
	sounds = default.node_sound_defaults(),
	groups = {attached_node = 1, oddly_breakable_by_hand = 3, cracky = 1},
	
	on_rightclick = flowerpot_on_rightclick
})

-- Craft
minetest.register_craft({
	output = "flowerpot:empty",
	recipe = {
		{"default:clay_brick", "", "default:clay_brick"},
		{"", "default:clay_brick", ""}
	}
})

local register_pot = flowerpot.register_node
for node, def in pairs(minetest.registered_nodes) do
	if def.groups.flora or def.groups.sapling then
		flowerpot.register_node(node)
	end
end
