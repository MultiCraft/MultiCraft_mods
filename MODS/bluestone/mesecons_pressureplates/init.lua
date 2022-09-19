local S = mesecon.S

local pp_box_off = {
	type = "fixed",
	fixed = {-7/16, -8/16, -7/16, 7/16, -7/16, 7/16}
}

local pp_box_on = {
	type = "fixed",
	fixed = {-7/16, -8/16, -7/16, 7/16, -7.5/16, 7/16}
}

local function pp_on_timer(pos)
	local node = minetest.get_node(pos)

	local objs = minetest.get_objects_inside_radius(pos, 0.8)
	local is_on = mesecon.is_receptor_on(node.name)

	if objs[1] == nil and is_on then
		mesecon.flipstate(pos, node)
		mesecon.receptor_off(pos, mesecon.rules.pplate)
	elseif not is_on then
		for _, obj in pairs(objs) do
			local objpos = obj:get_pos()
			if objpos.y > pos.y-1 and objpos.y < pos.y then
				mesecon.flipstate(pos, node)
				mesecon.receptor_on(pos, mesecon.rules.pplate )
			end
		end
	end
	return true
end

-- Register a Pressure Plate
-- offstate:	name of the pressure plate when inactive
-- onstate: name of the pressure plate when active
-- description: description displayed in the player's inventory
-- tiles_off:   textures of the pressure plate when inactive
-- tiles_on:	textures of the pressure plate when active
-- image:   inventory and wield image of the pressure plate
-- recipe:  crafting recipe of the pressure plate
-- groups:	groups
-- sounds:	sound table

function mesecon.register_pressure_plate(basename, description, tile, recipe, groups, sounds)
	if not groups then
		groups = {}
	end
	local groups_off = table.copy(groups)
	local groups_on = table.copy(groups)
	groups_on.not_in_creative_inventory = 1

	mesecon.register_node(basename, {
		drawtype = "nodebox",
		tiles = tile,
		paramtype = "light",
		is_ground_content = false,
		description = description,
		pressureplate_basename = basename,
		sounds = sounds,
		on_timer = pp_on_timer,

		on_construct = function(pos)
			minetest.get_node_timer(pos):start(mesecon.setting("pplate_interval", 0.1))
		end
	}, {
		mesecons = {receptor = {
			state = mesecon.state.off, rules = mesecon.rules.pplate
		}},
		node_box = pp_box_off,
		selection_box = pp_box_off,
		groups = groups_off
	}, {
		mesecons = {receptor = {
			state = mesecon.state.on, rules = mesecon.rules.pplate
		}},
		node_box = pp_box_on,
		selection_box = pp_box_on,
		groups = groups_on
	})

	minetest.register_craft({
		output = basename .. "_off 2",
		recipe = recipe
	})
end

mesecon.register_pressure_plate(
	"mesecons_pressureplates:pressure_plate_wood",
	S("Wooden Pressure Plate"),
	{"default_wood.png"},
	{{"default:wood", "bluestone:dust", "default:wood"}},
	{choppy = 3, oddly_breakable_by_hand = 3, attached_node = 1},
	default.node_sound_wood_defaults())

mesecon.register_pressure_plate(
	"mesecons_pressureplates:pressure_plate_stone",
	S("Stone Pressure Plate"),
	{"default_stone.png"},
	{{"default:cobble", "bluestone:dust", "default:cobble"}},
	{cracky = 3, oddly_breakable_by_hand = 3, attached_node = 1},
	default.node_sound_stone_defaults())
