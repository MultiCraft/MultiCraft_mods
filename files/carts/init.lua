carts = {}
carts.modpath = minetest.get_modpath("carts")

local translator = minetest.get_translator
carts.S = translator and translator("carts") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		carts.S = intllib.make_gettext_pair()
	end
end

-- Maximal speed of the cart in m/s
carts.speed_max = 12
-- Set to -1 to disable punching the cart from inside
carts.punch_speed_max = 8
-- Maximal distance for the path correction (for dtime peaks)
carts.path_distance_max = 3

dofile(carts.modpath.."/functions.lua")
dofile(carts.modpath.."/rails.lua")
dofile(carts.modpath.."/detector.lua")
dofile(carts.modpath.."/cart_entity.lua")
