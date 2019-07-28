beds = {}
beds.player = {}
beds.bed_position = {}
beds.pos = {}
beds.spawn = {}

-- Intllib
local S = intllib.make_gettext_pair()

beds.formspec = "size[8,11;true]" ..
	"no_prepend[]" ..
	default.gui_bg..
	"button_exit[2,10;4,0.75;leave;" .. S("Leave Bed") .. "]"

local modpath = minetest.get_modpath("beds")

-- Load files

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/spawns.lua")
