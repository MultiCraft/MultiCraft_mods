-- how often node timers for plants will tick, +/- some random value
local function tick(pos)
	minetest.get_node_timer(pos):start(math.random(332, 572))
end

-- how often a growth failure tick is retried (e.g. too dark)
local function tick_again(pos)
	minetest.get_node_timer(pos):start(math.random(80, 160))
end

function farming_addons.grow_cocoa_plant(pos)
	local node = minetest.get_node(pos)
	local name = node.name
	local def = minetest.registered_nodes[name]

	-- disable timer for fully grown plant
	if not def.next_plant then
		return
	end

	-- check if on jungletree
	local direction = minetest.facedir_to_dir(node.param2)
	local below_pos = vector.add(pos, direction)
	local below = minetest.get_node(below_pos)
	if below.name ~= "default:jungletree" then
		tick_again(pos)
		return
	end

	-- check light
	local light = minetest.get_node_light(pos)
	if not light or light < def.minlight then
		tick_again(pos)
		return
	end

	-- grow
	minetest.swap_node(pos, {name = def.next_plant, param2 = node.param2})

	-- new timer needed?
	if minetest.registered_nodes[def.next_plant].next_plant then
		tick(pos)
	end

	return
end

function farming_addons.place_cocoa_bean(itemstack, placer, pointed_thing)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt or pt.type ~= "node" then
		return itemstack
	end

	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)

	local udef = minetest.registered_nodes[under.name]
	if udef and udef.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
		return udef.on_rightclick(pt.under, under, placer, itemstack,
			pointed_thing) or itemstack
	end

	local player_name = placer and placer:get_player_name()

	if player_name and
			(minetest.is_protected(pt.under, player_name) or
			minetest.is_protected(pt.above, player_name)) then
		minetest.record_protection_violation(pt.under, player_name)
		return itemstack
	end

	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return itemstack
	end
	if not minetest.registered_nodes[above.name] then
		return itemstack
	end

	-- check if NOT pointing at the top/below of the node
	if pt.above.y == pt.under.y - 1 or
		 pt.above.y == pt.under.y + 1 then
		return itemstack
	end
	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return itemstack
	end

	-- check if pointing at soil
	if under.name ~= "default:jungletree" then
		return itemstack
	end

	local direction = vector.direction(pt.above, pt.under)
	local new_param2 = minetest.dir_to_facedir(direction)

	-- add the node and remove 1 item from the itemstack
	minetest.set_node(pt.above, {name = "farming_addons:cocoa_1", param2 = new_param2})

	tick(pt.above)
	if player_name and not (creative and creative.is_enabled_for
			and creative.is_enabled_for(player_name)) then
		itemstack:take_item()
	end
	return itemstack
end

-- COCOA
minetest.register_craftitem("farming_addons:cocoa_bean", {
	description = "Cocoa Bean",
	tiles = {"farming_addons_cocoa_bean.png"},
	inventory_image = "farming_addons_cocoa_bean.png",
	wield_image = "farming_addons_cocoa_bean.png",
	on_place = farming_addons.place_cocoa_bean,
	groups = {farming = 1}
})

-- 1
minetest.register_node("farming_addons:cocoa_1", {
	description = "Cocoa 1",
	drawtype = "nodebox",
	tiles = {
		"farming_addons_cocoa_top_1.png",
		"farming_addons_cocoa_bottom_1.png",
		"farming_addons_cocoa_side_1.png",
		"farming_addons_cocoa_side_1.png^[transformFX",
		"farming_addons_cocoa_front_1.png",
		"farming_addons_cocoa_front_1.png"
	},
	paramtype = "light",
	sunlight_propagates = true,
	wield_scale = {x = 2, y = 2, z = 2},
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = {
		items = {
			{items = {"farming_addons:cocoa_bean"}, rarity = 3}
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.0625, 0.1875, 0.125, 0.25, 0.4375}, -- fruit
			{0, 0.25, 0.3125, 0, 0.375, 0.375}, -- stem_1
			{0, 0.375, 0.4375, 0, 0.4375, 0.5}, -- stem_2
			{0, 0.3125, 0.375, 0, 0.4375, 0.4375} -- stem_3
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.0625, 0.1875, 0.125, 0.5, 0.5}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.0625, 0.1875, 0.125, 0.5, 0.5}
		}
	},
	groups = {choppy = 3, flammable = 2, plant = 1, cocoa = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	next_plant = "farming_addons:cocoa_2",
	on_timer = farming_addons.grow_cocoa_plant,
	minlight = 10
})

-- 2
minetest.register_node("farming_addons:cocoa_2", {
	description = "Cocoa 2",
	drawtype = "nodebox",
	tiles = {
		"farming_addons_cocoa_top_2.png",
		"farming_addons_cocoa_bottom_2.png",
		"farming_addons_cocoa_side_2.png",
		"farming_addons_cocoa_side_2.png^[transformFX",
		"farming_addons_cocoa_front_2.png",
		"farming_addons_cocoa_front_2.png"
	},
	paramtype = "light",
	sunlight_propagates = true,
	wield_scale = {x = 1.5, y = 1.5, z = 1.5},
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = {
		items = {
			{items = {"farming_addons:cocoa_bean"}, rarity = 2}
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, 0.0625, 0.1875, 0.25, 0.4375}, -- fruit
			{0, 0.25, 0.25, 0, 0.375, 0.375}, -- stem_1
			{0, 0.375, 0.375, 0, 0.5, 0.5}, -- stem_2
			{0, 0.375, 0.3125, 0, 0.4375, 0.375} -- stem_3
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, 0.0625, 0.1875, 0.5, 0.5}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, 0.0625, 0.1875, 0.5, 0.5}
		}
	},
	groups = {choppy = 3, flammable = 2, plant = 1, cocoa = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	next_plant = "farming_addons:cocoa_3",
	on_timer = farming_addons.grow_cocoa_plant,
	minlight = 10
})

-- 3
minetest.register_node("farming_addons:cocoa_3", {
	description = "Cocoa 3",
	drawtype = "nodebox",
	tiles = {
		"farming_addons_cocoa_top_3.png",
		"farming_addons_cocoa_bottom_3.png",
		"farming_addons_cocoa_side_3.png",
		"farming_addons_cocoa_side_3.png^[transformFX",
		"farming_addons_cocoa_front_3.png",
		"farming_addons_cocoa_front_3.png"
	},
	paramtype = "light",
	sunlight_propagates = true,
	wield_scale = {x = 1.5, y = 1.5, z = 1.5},
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = {
		items = {
			{items = {"farming_addons:cocoa_bean"}, rarity = 1},
			{items = {"farming_addons:cocoa_bean"}, rarity = 2},
			{items = {"farming_addons:cocoa_bean"}, rarity = 2}
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.3125, -0.0625, 0.25, 0.25, 0.4375},
			{-0.0625, 0.25, 0.25, 0.0625, 0.375, 0.4375},
			{-0.0625, 0.375, 0.375, 0.0625, 0.5, 0.5},
			{-0.0625, 0.375, 0.3125, 0.0625, 0.4375, 0.375}
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.3125, -0.0625, 0.25, 0.5, 0.5}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.3125, -0.0625, 0.25, 0.5, 0.5}
		}
	},
	groups = {choppy = 3, flammable = 2, plant = 1, cocoa = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	on_timer = farming_addons.grow_cocoa_plant,
	minlight = 10
})

-- replacement LBM for pre-nodetimer plants
minetest.register_lbm({
	name = "farming_addons:start_nodetimer_cocoa",
	nodenames = {
		"farming_addons:cocoa_1",
		"farming_addons:cocoa_2"
	},
	action = tick_again
})

-- grow cocoa in jungletrees
local find_node_near = minetest.find_node_near
local get_node = minetest.get_node
local get_time = minetest.get_timeofday
minetest.register_abm({
	name = "farming_addons:grow_cocoa",
	nodenames = "default:jungletree",
	neighbors = {"default:jungletree"},
	interval = 5,
	chance = 50,
	catch_up = false,
	action = function(pos)
		if get_time() >= 0.25 and get_time() < 0.8 then
			if find_node_near(pos, 3, "group:cocoa")
			then return end

			local apos = {x = pos.x, y = pos.y, z = pos.z}
			if get_node({x = pos.x + 1, y = pos.y, z = pos.z}).name == "air" then
				apos.x = apos.x + 1
			elseif get_node({x = pos.x - 1, y = pos.y, z = pos.z}).name == "air" then
				apos.x = apos.x - 1
			elseif get_node({x = pos.x, y = pos.y, z = pos.z + 1}).name == "air" then
				apos.z = apos.z + 1
			elseif get_node({x = pos.x, y = pos.y, z = pos.z - 1}).name == "air" then
				apos.z = apos.z - 1
			else return end

			if get_node({x = apos.x, y = apos.y - 2, z = apos.z}).name ~= "air"
			then return end

			farming_addons.place_cocoa_bean(
				ItemStack("farming_addons:cocoa_1"), nil, {type = "node", under = pos, above = apos})
		end
	end
})

-- Cocoa
minetest.register_craft( {
	output = "dye:brown 2",
	recipe = {
		{"farming_addons:cocoa_bean"}
	}
})

minetest.register_craftitem("farming_addons:cookie", {
	description = "Cookie",
	inventory_image = "farming_addons_cookie.png",
	groups = {food = 1},
	on_use = minetest.item_eat(2)
})

minetest.register_craft( {
	output = "farming_addons:cookie 8",
	recipe = {
		{"farming:wheat", "farming_addons:cocoa_bean", "farming:wheat"}
	}
})

minetest.register_craftitem("farming_addons:chocolate", {
	description = "Chocolate",
	inventory_image = "farming_addons_chocolate.png",
	on_use = minetest.item_eat(3),
	groups = {food = 1}
})

minetest.register_craft( {
	output = "farming_addons:chocolate",
	recipe = {
		{"", "", "farming_addons:cocoa_bean"},
		{"", "farming_addons:cocoa_bean", ""},
		{"default:paper", "", ""}
	}
})
