carts = {}
carts.modpath = minetest.get_modpath("carts")
carts.S = minetest.get_translator_auto(true)

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
