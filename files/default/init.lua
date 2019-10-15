-- MultiCraft Game mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

-- Definitions made by this mod that other mods can use too
default = {
	colors = {
		grey = minetest.get_color_escape_sequence("#9d9d9d"),
		green = minetest.get_color_escape_sequence("#1eff00"),
		gold = minetest.get_color_escape_sequence("#ffdf00"),
		white = minetest.get_color_escape_sequence("#ffffff"),
		emerald = minetest.get_color_escape_sequence("#00e87e")
	}
}

default.gui_bg = "bgcolor[#08080880;true]"
default.listcolors = "listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]"
default.gui	= [[
	size[9,8.75]
	]] .. default.gui_bg ..
	default.listcolors .. [[
	background[-0.2,-0.26;9.41,9.49;formspec_inventory.png]
	image_button_exit[8.4,-0.1;0.75,0.75;close.png;exit;;true;false;close_pressed.png]
	list[current_player;main;0.01,4.51;9,3;9]
	list[current_player;main;0.01,7.75;9,1;]
]]


default.coloremerald = minetest.get_color_escape_sequence("#00D67C")

-- Load files
local default_path = minetest.get_modpath("default")

dofile(default_path .. "/functions.lua")
dofile(default_path .. "/trees.lua")
dofile(default_path .. "/nodes.lua")
dofile(default_path .. "/chests.lua")
dofile(default_path .. "/furnace.lua")
dofile(default_path .. "/torch.lua")
dofile(default_path .. "/tools.lua")
dofile(default_path .. "/craftitems.lua")
dofile(default_path .. "/crafting.lua")
dofile(default_path .. "/mapgen.lua")
dofile(default_path .. "/aliases.lua")
