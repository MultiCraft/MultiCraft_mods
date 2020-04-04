-- Solar Panel
mesecon.register_node("mesecons_solarpanel:solar_panel", {
	drawtype = "nodebox",
	tiles = {"mesecons_solarpanel.png"},
	inventory_image = "mesecons_solarpanel.png",
	wield_image = "mesecons_solarpanel.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = false,
	node_box = {
		type = "wallmounted",
		wall_bottom	= {-0.5, -0.5, -0.5,  0.5, -1/7, 0.5},
		wall_top	= {-0.5,  1/7, -0.5,  0.5,  0.5, 0.5},
		wall_side	= {-1/7, -0.5, -0.5, -0.5,  0.5, 0.5}
	},
	sounds = default.node_sound_glass_defaults(),

	on_blast = mesecon.on_blastnode,

	on_timer = function(pos)
		local light = minetest.get_node_light(pos)
		local node = minetest.get_node(pos)

		if light >= 10 and node.name == "mesecons_solarpanel:solar_panel_off" then
			node.name = "mesecons_solarpanel:solar_panel_on"
			minetest.swap_node(pos, node)
			mesecon.receptor_on(pos, mesecon.rules.wallmounted_get(node))
		elseif light < 10 and node.name == "mesecons_solarpanel:solar_panel_on" then
			node.name = "mesecons_solarpanel:solar_panel_off"
			minetest.swap_node(pos, node)
			mesecon.receptor_off(pos, mesecon.rules.wallmounted_get(node))
		end

		return true
	end,
	
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(mesecon.setting("spanel_interval", 1))
	end
},{
	description = "Solar Panel",
	groups = {dig_immediate = 3, attached_node = 1},
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = mesecon.rules.wallmounted_get
	}}
},{
	groups = {dig_immediate = 3, attached_node = 1, not_in_creative_inventory = 1},
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = mesecon.rules.wallmounted_get
	}}
})

minetest.register_craft({
	output = "mesecons_solarpanel:solar_panel_off",
	recipe = {
		{"default:glass", "default:glass", "default:glass"},
		{"mesecons:wire_00000000_off", "mesecons:wire_00000000_off", "mesecons:wire_00000000_off"},
		{"group:wood", "group:wood", "group:wood"}
	}
})
