local S = mesecon.S

local interval = mesecon.setting("observer_interval", 1)
local deg = math.deg
local vsubtract = vector.subtract

local neighbor = {
	[0] = {x =  0, y =  0, z =  1},
	[1] = {x =  1, y =  0, z =  0},
	[2] = {x =  0, y =  0, z = -1},
	[3] = {x = -1, y =  0, z =  0},
	[4] = {x =  0, y = -1, z =  0},
	[8] = {x =  0, y =  1, z =  0}
}

local function get_rules_flat(node)
	return {neighbor[node.param2]}
end

local function observer_orientate(pos, placer)
	-- Not placed by player
	if not placer then return end

	-- Pitch in degrees
	local pitch = deg(placer:get_look_vertical())
	local node = minetest.get_node(pos)

	if pitch > 55 then
		node.param2 = 4
	elseif pitch < -55 then
		node.param2 = 8
	else
		return
	end
	minetest.swap_node(pos, node)
end

-- Scan the node in front of the observer
-- and update the observer state if needed.
local function observer_scan(pos, initialize)
	local node = minetest.get_node(pos)
	local nodeparam2 = node.param2
	local dir = minetest.facedir_to_dir(nodeparam2)
	local front = minetest.get_node(vsubtract(pos, dir))
	local frontname = front.name
	local frontparam2 = front.param2
	local meta = minetest.get_meta(pos)
	local oldnode = meta:get_string("node_name")
	local oldparam2 = meta:get_string("node_param2")

	local meta_needs_updating = false
	if not initialize and oldnode ~= "" then
		if not (frontname == oldnode and tostring(frontparam2) == oldparam2) then
			minetest.set_node(pos, {name = "bluestone_observer:observer_on", param2 = nodeparam2})
			mesecon.receptor_on(pos, get_rules_flat(node))
			meta_needs_updating = true
		end
	else
		meta_needs_updating = true
	end

	if meta_needs_updating then
		meta:set_string("node_name", frontname)
		meta:set_string("node_param2", tostring(frontparam2))
	end
end

local ttop = "default_furnace_top.png"
local tside = "default_furnace_side.png"

mesecon.register_node("bluestone_observer:observer", {
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	paramtype2 = "facedir",
}, {
	description = S("Observer"),
	groups = {cracky = 3},
	tiles = {
		ttop, ttop,
		tside, tside,
		tside .. "^bluestone_observer_back.png^bluestone_observer_back_inactive.png",
		tside .. "^mesecons_dropper_front.png^bluestone_observer_front.png"
	},
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = get_rules_flat
	}},

	after_place_node = observer_orientate,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(interval)
		observer_scan(pos, true)
	end,

	on_timer = function(pos)
		observer_scan(pos)
		return true
	end
}, {
	groups = {cracky = 3, not_in_creative_inventory = 1},
	on_rotate = false,
	tiles = {
		ttop, ttop,
		tside, tside,
		tside .. "^bluestone_observer_back.png^bluestone_observer_back_active.png",
		tside .. "^mesecons_dropper_front.png^bluestone_observer_front.png"
	},
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = get_rules_flat
	}},

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(interval)
	end,

	on_timer = function(pos)
		local node = minetest.get_node(pos)
		node.name = "bluestone_observer:observer_off"
		minetest.set_node(pos, node)
		mesecon.receptor_off(pos, get_rules_flat(node))
	end
})

minetest.register_craft({
	output = "bluestone_observer:observer_off",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"},
		{"mesecons:wire_00000000_off", "default:quartz_crystal", "mesecons:wire_00000000_off"},
		{"default:cobble", "default:cobble", "default:cobble"}
	}
})
