-- Glue
minetest.register_craftitem("mesecons_materials:glue", {
	image = "mesecons_glue.png",
	on_place_on_ground = minetest.craftitem_place_item,
	description="Glue",
})

minetest.register_craft({
	output = "mesecons_materials:glue 2",
	type = "cooking",
	recipe = "group:sapling",
	cooktime = 2
})

