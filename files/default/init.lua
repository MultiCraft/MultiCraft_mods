-- MultiCraft mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

-- Definitions made by this mod that other mods can use too
default = {}

default.LIGHT_MAX = 14

-- Load files
dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafting.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/player.lua")
dofile(minetest.get_modpath("default").."/trees.lua")
dofile(minetest.get_modpath("default").."/aliases.lua")
dofile(minetest.get_modpath("default").."/furnace.lua")
dofile(minetest.get_modpath("default").."/workbench.lua")
dofile(minetest.get_modpath("default").."/chest.lua")

if not minetest.setting_getbool("creative_mode") then
	minetest.register_on_newplayer(function (player)
			player:get_inventory():add_item('main', 'default:sword_steel')
			player:get_inventory():add_item('main', 'default:torch 8')
			player:get_inventory():add_item('main', 'default:wood 64')
	end)
end
