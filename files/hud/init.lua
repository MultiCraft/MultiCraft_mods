hud = {}

if minetest.settings:get_bool("enable_damage") then

	local modpath = minetest.get_modpath("hud")
	dofile(modpath .. "/api.lua")
	dofile(modpath .. "/builtin.lua")
	dofile(modpath .. "/legacy.lua")

end
