-- Copyright (c) 2013-18 rubenwardy. MIT.

-- The global award namespace
awards = {
	show_mode = "hud",
	registered_awards = {},
	registered_triggers = {},
	on_unlock = {},
}

-- Internationalization support.
awards.translator = minetest.get_translator("awards")

-- Load files
local path = minetest.get_modpath("awards")

dofile(path .. "/src/data.lua")
dofile(path .. "/src/api_awards.lua")
dofile(path .. "/src/api_triggers.lua")
dofile(path .. "/src/chat_commands.lua")
dofile(path .. "/src/triggers.lua")

minetest.register_on_shutdown(awards.save)
