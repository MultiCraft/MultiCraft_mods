local S = minetest.get_translator_auto(true)

beds = {
	S = S,
	player = {},
	bed_position = {},
	pos = {},
	spawn = {}
}

beds.formspec = "size[8,10]" ..
	"no_prepend[]" ..
	default.gui_bg ..
	"button_exit[1.9,7;4.1,0.75;leave;" .. S("Leave Bed") .. "]"

local modpath = minetest.get_modpath("beds")

-- Load files

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/spawns.lua")
