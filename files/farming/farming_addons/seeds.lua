--
-- Seeds
--

-- Pumpkin
minetest.override_item("default:dry_grass", {drop = {
	max_items = 1,
	items = {
		{items = {"farming_addons:seed_pumpkin"}, rarity = 6},
		{items = {"default:dry_grass"}}
	}
}})

-- Carrot
-- Wheat
minetest.override_item("default:grass", {drop = {
	max_items = 1,
	items = {
		{items = {"farming:seed_wheat"}, rarity = 5},
		{items = {"farming_addons:seed_carrot"}, rarity = 12},
		{items = {"default:grass"}}
	}
}})

-- Potato
minetest.override_item("default:junglegrass", {drop = {
	max_items = 1,
	items = {
		{items = {"farming_addons:seed_potato"}, rarity = 6},
		{items = {"default:junglegrass"}}
	}
}})

-- Corn
-- Melon
minetest.override_item("default:dry_shrub", {drop = {
	max_items = 1,
	items = {
		{items = {"farming_addons:seed_corn"}, rarity = 6},
		{items = {"farming_addons:seed_melon"}, rarity = 6},
		{items = {"default:dry_shrub"}}
	}
}})
