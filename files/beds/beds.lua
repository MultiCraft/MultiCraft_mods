beds.register_bed("beds:bed", {
	description = "Bed",
	inventory_image = "beds_bed_inv.png",
	wield_image = "beds_bed_inv.png",
	tiles = {"beds_bed.png"},
	mesh = "beds_bed.obj",
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"}
	},
})

-- Fuel

minetest.register_craft({
	type = "fuel",
	recipe = "beds:fancy_bed_bottom",
	burntime = 13,
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:bed_bottom",
	burntime = 12,
})
