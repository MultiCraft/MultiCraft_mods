local S = default.S

function default.register_torch(name, def)
	def.drawtype = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "wallmounted"
	def.sunlight_propagates = true
	def.walkable = false
	def.liquids_pointable = false
	def.drop = name
	def.floodable = true

	def.on_flood = function(pos, oldnode, newnode)
		oldnode.name = name or name .. "_wall" or name .. "_celling"
		minetest.add_item(pos, ItemStack(oldnode))
		-- Play flame-extinguish sound if liquid is not an 'igniter'
		if minetest.get_item_group(newnode.name, "igniter") == 0 then
			minetest.sound_play("default_cool_lava",
				{pos = pos, max_hear_distance = 16, gain = 0.1})
		end
		-- Remove the torch node
		return false
	end

	def.on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local node_def = minetest.registered_nodes[node.name]
		if node_def and node_def.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
			return node_def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end
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

	def.mesh = "torch_floor.obj"
	def.selection_box = {
		type = "wallmounted",
		wall_bottom = {-1/8, -1/2, -1/8, 1/8, 2/16, 1/8}
	}
	minetest.register_node(":" .. name, def)

	local torch_wall = table.copy(def)
	torch_wall.mesh = "torch_wall.obj"
	torch_wall.selection_box = {
		type = "wallmounted",
		wall_side = {-1/2, -1/2, -1/8, -1/8, 1/8, 1/8}
	}
	torch_wall.groups.not_in_creative_inventory = 1
	minetest.register_node(":" .. name .. "_wall", torch_wall)

	local torch_ceiling = table.copy(def)
	torch_ceiling.mesh = "torch_ceiling.obj"
	torch_ceiling.selection_box = {
		type = "wallmounted",
		wall_top = {-1/8, -1/16, -5/16, 1/8, 1/2, 1/8}
	}
	torch_ceiling.groups.not_in_creative_inventory = 1
	minetest.register_node(":" .. name .. "_ceiling", torch_ceiling)
end

default.register_torch("default:torch", {
	description = S("Torch"),
	tiles = {{
		name = "default_torch_animated.png",
		animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 2}
	}},
	inventory_image = "default_torch.png",
	wield_image = "default_torch.png",
	use_texture_alpha = "clip",
	light_source = 12,
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1, torch = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	output = "default:torch 4",
	recipe = {
		{"group:coal"},
		{"default:stick"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:torch",
	burntime = 7
})
