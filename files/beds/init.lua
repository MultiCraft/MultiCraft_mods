beds = {}
beds.player = {}
beds.bed_position = {}
beds.pos = {}
beds.spawn = {}

-- Intllib
local S = intllib.make_gettext_pair()

beds.formspec = "size[8,11;true]" ..
	"no_prepend[]" ..
	default.gui_bg ..
	"button_exit[2,10;4,0.75;leave;" .. S("Leave Bed") .. "]"

local modpath = minetest.get_modpath("beds")

-- Load files

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/spawns.lua")

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
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:bed_bottom",
	burntime = 12
})
