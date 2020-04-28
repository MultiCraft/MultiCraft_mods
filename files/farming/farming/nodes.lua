minetest.override_item("default:dirt", {
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_grass", {
	soil = {
		base = "default:dirt_with_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_dry_grass", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:soil", {
	tiles = {"farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2,
		grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:soil_wet", {
	tiles = {"farming_soil_wet.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, wet = 1,
		grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:straw", {
	description = "Straw",
	tiles = {"farming_straw_top.png", "farming_straw_top.png", "farming_straw_side.png"},
	is_ground_content = false,
	groups = {snappy = 3, flammable = 4, fall_damage_add_percent = -30},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	label = "Farming soil",
	nodenames = {"group:field"},
	interval = 15,
	chance = 4,
	action = function(pos, node)
		pos.y = pos.y + 1
		local nn = minetest.get_node_or_nil(pos)
		if not nn then
			return
		end
		local nn_def = minetest.registered_nodes[nn.name]
		pos.y = pos.y - 1

		local soil = minetest.registered_nodes[node.name].soil
		local wet = soil.wet or nil
		local base = soil.base or nil
		local dry = soil.dry or nil
		if not soil or not wet or not base or not dry then
			return
		end

		if nn_def and nn_def.walkable and
				minetest.get_item_group(nn.name, "plant") == 0 then
			node.name = soil.base
			minetest.set_node(pos, node)
			return
		end

		local wet_lvl = minetest.get_item_group(node.name, "wet")
		-- Make the node wet if water is near it
		if minetest.find_node_near(pos, 3, {"group:water"}) then
			-- If it is dry soil and not base node, turn it into wet soil
			if wet_lvl == 0 then
				node.name = soil.wet
				minetest.set_node(pos, node)
			end
			return
		end

		-- Only dry out if there are no unloaded blocks (and therefore
		-- possible water sources) nearby
		if minetest.find_node_near(pos, 3, {"ignore"}) then
			return
		end

		-- Turn it back into base if it is already dry and no plant/seed
		-- is on top of it
		if wet_lvl == 0 then
			if minetest.get_item_group(nn.name, "plant") == 0 and
					minetest.get_item_group(nn.name, "seed") == 0 then
				node.name = soil.base
				minetest.set_node(pos, node)
			end

		-- If it is wet turn it back into dry soil
		elseif wet_lvl == 1 then
			node.name = soil.dry
			minetest.set_node(pos, node)
		end
	end
})
