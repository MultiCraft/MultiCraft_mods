farming.register_plant("farming_addons:corn", {
	description = "Corn Seed",
	inventory_image = "farming_addons_corn_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4, food = 1},
	place_param2 = 3
})

-- place corn
minetest.override_item("farming_addons:corn", {
	on_use = minetest.item_eat(2, nil, -1),
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		return farming.place_seed(itemstack, placer, pointed_thing, "farming_addons:seed_corn")
	end
})

minetest.override_item("farming_addons:corn_4", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_5", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_6", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_7", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_8", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

-- Baked Corn
minetest.register_craftitem("farming_addons:corn_baked", {
	description = "Baked Corn",
	inventory_image = "farming_addons_corn_baked.png",
	on_use = minetest.item_eat(8)
})


minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:corn_baked",
	recipe = "farming_addons:corn"
})


