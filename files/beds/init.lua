local S = minetest.get_translator("beds")

beds = {
	S = S,
	player = {},
	bed_position = {},
	pos = {},
	spawn = {}
}

beds.formspec = "size[8,10]" ..
	"no_prepend[]" ..
	"bgcolor[#08080880;true]" ..
	"button_exit[1.9,7;4.1,0.75;leave;" .. S("Leave Bed") .. "]"

local modpath = minetest.get_modpath("beds")

-- Load files

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/spawns.lua")
