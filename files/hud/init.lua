hud = {}

hud.show_armor = minetest.get_modpath("3d_armor") ~= nil

if minetest.settings:get_bool("enable_damage") then

	local modpath = minetest.get_modpath("hud")
	dofile(modpath .. "/api.lua")
	dofile(modpath .. "/builtin.lua")

end
