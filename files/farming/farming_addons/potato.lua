farming.register_plant("farming_addons:potato", {
	description = "Potato Seed",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_potato_seed.png",
	steps = 4,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4, food = 1},
	place_param2 = 3
})

-- place and eat potatos
minetest.override_item("farming_addons:potato", {
	on_use = minetest.item_eat(2),
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

		return farming.place_seed(itemstack, placer, pointed_thing, "farming_addons:seed_potato")
	end,
})

-- add poisonous potato to drops
minetest.override_item("farming_addons:potato_4", {
	drop = {
		items = {
			{items = {"farming_addons:potato"}, rarity = 1},
			{items = {"farming_addons:potato"}, rarity = 2},
			{items = {"farming_addons:potato"}, rarity = 2},
			{items = {"farming_addons:potato_poisonous"}, rarity = 5},
			{items = {"farming_addons:seed_potato"}, rarity = 1},
			{items = {"farming_addons:seed_potato"}, rarity = 2}
		}
	}
})

-- Potato
minetest.register_craftitem("farming_addons:potato_baked", {
	description = "Baked Potato",
	inventory_image = "farming_addons_potato_baked.png",
	on_use = minetest.item_eat(6),
	groups = { food = 1},
})

minetest.register_craftitem("farming_addons:potato_poisonous", {
	description = "Poisonous Potato",
	inventory_image = "farming_addons_potato_poisonous.png",
	on_use = minetest.item_eat(2, nil, -4),
	groups = {food = 1},
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:potato_baked",
	recipe = "farming_addons:potato"
})
