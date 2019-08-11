function default.register_torch(name, def)
	local torch = {
		description = def.description,
		drawtype = "mesh",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = false,
		liquids_pointable = false,
		light_source = def.light_source,
		groups = def.groups,
		drop = name,
		sounds = def.sounds,
		floodable = true,

		mesecons = def.mesecons,

		on_blast = def.on_blast,

		on_flood = function(pos, oldnode, newnode)
			local torch = (oldnode.name:gsub("_wall", "") or oldnode.name:gsub("_celling", "")) or oldnode.name
			minetest.add_item(pos, ItemStack(torch))
			-- Play flame-extinguish sound if liquid is not an 'igniter'
			local nodedef = minetest.registered_items[newnode.name]
			if not (nodedef and nodedef.groups and
					nodedef.groups.igniter and nodedef.groups.igniter > 0) then
				minetest.sound_play(
					"default_cool_lava",
					{pos = pos, max_hear_distance = 16, gain = 0.1}
				)
			end
			-- Remove the torch node
			return false
		end,

		on_place = function(itemstack, placer, pointed_thing)
			local under = pointed_thing.under
			local above = pointed_thing.above
			local wdir = minetest.dir_to_wallmounted(vector.subtract(under, above))
			if wdir == 0 then
				itemstack:set_name(name .. "_ceiling")
			elseif wdir == 1 then
				itemstack:set_name(name)
			else
				itemstack:set_name(name .. "_wall")
			end
			itemstack = minetest.item_place(itemstack, placer, pointed_thing, wdir)
			itemstack:set_name(name)
			return itemstack
		end
	}

	local torch_floor = table.copy(torch)
	torch_floor.mesh = "torch_floor.obj"
	torch_floor.inventory_image = def.inventory_image
	torch_floor.wield_image = def.wield_image
	torch_floor.selection_box = {
		type = "wallmounted",
		wall_bottom = {-1/8, -1/2, -1/8, 1/8, 2/16, 1/8},
	}

	local torch_wall = table.copy(torch)
	torch_wall.mesh = "torch_wall.obj"
	torch_wall.selection_box = {
		type = "wallmounted",
		wall_side = {-1/2, -1/2, -1/8, -1/8, 1/8, 1/8},
	}
	torch_wall.groups.not_in_creative_inventory = 1

	local torch_ceiling = table.copy(torch)
	torch_ceiling.mesh = "torch_ceiling.obj"
	torch_ceiling.selection_box = {
		type = "wallmounted",
		wall_top = {-1/8, -1/16, -5/16, 1/8, 1/2, 1/8},
	}
	torch_ceiling.groups.not_in_creative_inventory = 1

	minetest.register_node(":" .. name, torch_floor)
	minetest.register_node(":" .. name .. "_wall", torch_wall)
	minetest.register_node(":" .. name .. "_ceiling", torch_ceiling)
end

default.register_torch("default:torch", {
	description = "Torch",
	tiles = {{
		name = "default_torch.png",
	--	name = "default_torch_animated.png",
	--	animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 3.3}
	}},
	inventory_image = "default_torch.png",
	wield_image = "default_torch.png",
	light_source = 12,
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1, torch = 1},
	sounds = default.node_sound_wood_defaults()
})
