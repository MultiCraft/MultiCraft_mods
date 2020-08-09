beds = {
	player = {},
	bed_position = {},
	pos = {},
	spawn = {}
}

local translator = minetest.get_translator
beds.S = translator and translator("beds") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		beds.S = intllib.make_gettext_pair()
	end
end

beds.formspec = "size[8,11;true]" ..
	"no_prepend[]" ..
	default.gui_bg ..
	"button_exit[2,10;4,0.75;leave;" .. beds.S("Leave Bed") .. "]"

local modpath = minetest.get_modpath("beds")

-- Load files

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/spawns.lua")
