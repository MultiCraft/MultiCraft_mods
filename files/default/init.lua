-- MultiCraft Game mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

default = {}

default.S = minetest.get_translator("default")

-- Definitions made by this mod that other mods can use too
local Cesc = minetest.get_color_escape_sequence
default.colors = {
	grey = Cesc("#9d9d9d"),
	green = Cesc("#1eff00"),
	gold = Cesc("#ffdf00"),
	white = Cesc("#ffffff"),
	emerald = Cesc("#00e87e"),
	ruby = Cesc("#d80a1b")
}

minetest.register_craftitem("default:cell", {
	inventory_image = "formspec_cell.png"
})

default.gui_bg = "bgcolor[#08080880;true]"
default.listcolors = "listcolors[#0000;#fff7;#0000;#656276;#fff]"
default.gui_bg_img = "background[-0.2,-0.26;16.71,17.36;formspec_inventory_backround.png]"
function default.gui_close_btn(pos)
	pos = pos or "8.35,-0.1"
	return "image_button_exit[" .. pos .. ";0.75,0.75;close.png;exit;;true;false;close_pressed.png]"
end
default.gui = "size[9,8.75]" ..
	default.gui_bg ..
	default.listcolors ..
	default.gui_bg_img ..
	"background[0,0;0,0;formspec_inventory.png;true]" ..
	default.gui_close_btn() ..
	"list[current_player;main;0.01,4.51;9,3;9]" ..
	"list[current_player;main;0.01,7.75;9,1;]"

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
