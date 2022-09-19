local S = mesecon.S

mesecon.register_node("bluestone_lamp:lightstone", {
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
	on_blast = mesecon.on_blastnode
}, {
	description = S("Lamp"),
	tiles = {"bluestone_lamp_off.png"},
	groups = {cracky = 2, mesecon = 2},

	mesecons = {effector = {
		action_on = mesecon.flipstate,
		rules = mesecon.rules.all
	}}
}, {
	tiles = {"bluestone_lamp_on.png"},
	groups = {cracky = 2, mesecon = 2, not_in_creative_inventory = 1},
	light_source = minetest.LIGHT_MAX,

	mesecons = {effector = {
		action_off = mesecon.flipstate,
		rules = mesecon.rules.all
	}}
})

minetest.register_craft({
	output = "bluestone_lamp:lightstone_off",
	recipe = {
		{"", "bluestone:dust", ""},
		{"bluestone:dust", "default:glowstone","bluestone:dust"},
		{"", "bluestone:dust", ""},
	}
})
