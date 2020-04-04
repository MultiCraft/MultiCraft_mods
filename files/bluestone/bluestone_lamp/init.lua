mesecon.register_node("bluestone_lamp:lightstone", {
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
	on_blast = mesecon.on_blastnode
},{
	description = "Lamp",
	tiles = {"bluestone_lamp_off.png"},
	groups = {cracky = 2, mesecon = 2},

	mesecons = {effector = {
		action_on = mesecon.flipstate
	}}
},{
	tiles = {"bluestone_lamp_on.png"},
	groups = {cracky = 2, mesecon = 2, not_in_creative_inventory = 1},
	light_source = minetest.LIGHT_MAX,

	mesecons = {effector = {
		action_off = mesecon.flipstate
	}}
})

minetest.register_craft({
	output = "bluestone_lamp:lightstone_off",
	recipe = {
		{"", "mesecons:wire_00000000_off", ""},
		{"mesecons:wire_00000000_off", "default:glowstone","mesecons:wire_00000000_off"},
		{"", "mesecons:wire_00000000_off", ""},
	}
})

minetest.register_alias("mesecons_lightstone:lightstone_off", "bluestone_lamp:lightstone_off")
minetest.register_alias("mesecons_lightstone:lightstone_on", "bluestone_lamp:lightstone_on")
