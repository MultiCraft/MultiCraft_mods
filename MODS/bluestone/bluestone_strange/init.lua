local S = mesecon.S

local vadd, vnew = vector.add, vector.new

local tfirst = "default_furnace_top.png"

-- Kamikaze Stone
minetest.register_node("bluestone_strange:removestone", {
	description = S("Disappearing Stone"),
	tiles = {
		tfirst,
		tfirst,
		tfirst .. "^bluestone_strange_ghost_front.png"
	},
	overlay_tiles = {"", "",
		{
			name = "bluestone_strange_disappear_face.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 2.0
			}
		}
	},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	mesecons = {effector = {
		action_on = function(pos, node)
			minetest.remove_node(pos)
			mesecon.on_dignode(pos, node)
			minetest.check_for_falling(vadd(pos, vnew(0, 1, 0)))
		end
	}},
	on_blast = mesecon.on_blastnode
})

minetest.register_craft({
	output = "bluestone_strange:removestone",
	recipe = {
		{"", "mesecons_delayer:delayer_off_1", ""},
		{"bluestone:dust", "default:cobble", "bluestone:dust"},
		{"", "mesecons_delayer:delayer_off_1", ""},
	}
})

-- Ghost Stone
mesecon.register_node("bluestone_strange:ghoststone", {
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
	on_blast = mesecon.on_blastnode
}, {
	description = S("Ghost Stone"),
	tiles = {
		tfirst,
		tfirst,
		tfirst .. "^bluestone_strange_ghost_front.png"
	},
	overlay_tiles = {"", "",
		{
			name = "bluestone_strange_ghost_face.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 2.0
			}
		}
	},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	mesecons = {conductor = {
		state = mesecon.state.off,
		rules = mesecon.rules.flat,
		onstate = "bluestone_strange:ghoststone_on"
	}}
}, {
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
--	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = false,
	floodable = false,
	groups = {cracky = 3},
	mesecons = {conductor = {
		state = mesecon.state.on,
		rules = mesecon.rules.flat,
		offstate = "bluestone_strange:ghoststone_off"
	}}
})

minetest.register_craft({
	output = "bluestone_strange:ghoststone_off",
	recipe = {
		{"", "default:glowstone_dust", ""},
		{"default:glowstone_dust", "bluestone_strange:removestone", "default:glowstone_dust"},
		{"", "default:glowstone_dust", ""}
	}
})
