carts = {}
carts.modpath = minetest.get_modpath("carts")

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

-- Aliases
minetest.register_alias("railcart:cart", "carts:cart")
minetest.register_alias("railcart:cart_entity", "carts:cart")
minetest.register_alias("default:rail", "carts:rail")
minetest.register_alias("boost_cart:rail", "carts:rail")
minetest.register_alias("railtrack:powerrail", "carts:powerrail")
minetest.register_alias("railtrack:superrail", "carts:powerrail")
minetest.register_alias("railtrack:brakerail", "carts:brakerail")
minetest.register_alias("railtrack:switchrail", "carts:startstoprail")
minetest.register_alias("boost_cart:detectorrail", "carts:detectorrail")
minetest.register_alias("boost_cart:startstoprail", "carts:startstoprail")
minetest.register_alias("railtrack:fixer", "default:stick")
minetest.register_alias("railtrack:inspector", "default:stick")
