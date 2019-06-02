boost_cart = {}
boost_cart.modpath = minetest.get_modpath("boost_cart")

local function getNum(setting)
	return tonumber(minetest.settings:get(setting))
end

-- Maximal speed of the cart in m/s
boost_cart.speed_max = getNum("boost_cart.speed_max") or 12
-- Set to -1 to disable punching the cart from inside
boost_cart.punch_speed_max = getNum("boost_cart.punch_speed_max") or 8
-- Maximal distance for the path correction (for dtime peaks)
boost_cart.path_distance_max = 3

-- Support for non-default games
if not default.player_attached then
	default.player_attached = {}
end

dofile(boost_cart.modpath.."/functions.lua")
dofile(boost_cart.modpath.."/rails.lua")

if minetest.global_exists("mesecon") then
	dofile(boost_cart.modpath.."/detector.lua")
--else
--	minetest.register_alias("carts:powerrail", "boost_cart:detectorrail")
--	minetest.register_alias("carts:powerrail", "boost_cart:detectorrail_on")
end

dofile(boost_cart.modpath.."/cart_entity.lua")

-- Aliases
minetest.register_alias("railcart:cart", "carts:cart")
minetest.register_alias("railcart:cart_entity", "carts:cart")
minetest.register_alias("default:rail", "boost_cart:rail")
minetest.register_alias("railtrack:powerrail", "carts:powerrail")
minetest.register_alias("railtrack:superrail", "carts:powerrail")
minetest.register_alias("railtrack:brakerail", "carts:brakerail")
minetest.register_alias("railtrack:switchrail", "boost_cart:startstoprail")
minetest.register_alias("railtrack:fixer", "default:stick")
minetest.register_alias("railtrack:inspector", "default:stick")