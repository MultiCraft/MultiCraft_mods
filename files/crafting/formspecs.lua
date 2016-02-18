default.chest_formspec = 
	"size[9,9.75]"..
    "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
	"background[-0.19,-0.25;9.41,10.48;crafting_inventory_chest.png]"..
	"bgcolor[#080808BB;true]"..
	"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]"..
	"list[current_name;main;0,0.5;9,4;]"..
	"list[current_player;main;0,5.5;9,3;9]"..
	"list[current_player;main;0,8.74;9,1;]"

local chest_inv_size = 4*9
local chest_inv_vers = 2

function default.get_locked_chest_formspec(pos)
		local meta = minetest.get_meta(pos)
		local inv_v = meta:get_int("chest_inv_ver")
		if inv_v and inv_v < chest_inv_vers then
			local inv = meta:get_inventory()
			inv:set_size("main",chest_inv_size)
			meta:set_int("chest_inv_ver",chest_inv_vers)
		end
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = 
		"size[9,9.75]"..
        "image_button_exit[9,0;1,1;;exit;X;true;true;]"..
		"background[-0.19,-0.25;9.41,10.48;crafting_inventory_chest.png]"..
		"bgcolor[#080808BB;true]"..
		"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]"..
		"list[nodemeta:".. spos .. ";main;0,0.5;9,4;]"..
		"list[current_player;main;0,5.5;9,3;9]"..
		"list[current_player;main;0,8.74;9,1;]"
	return formspec
end

minetest.register_abm({
        nodenames = {"default:chest"},
        interval = 1,
        chance = 1,
        action = function(pos, node)
		local meta = minetest.get_meta(pos)
		local inv_v = meta:get_int("chest_inv_ver")
		if inv_v and inv_v < chest_inv_vers then
			local inv = meta:get_inventory()
			inv:set_size("main",chest_inv_size)
			meta:set_int("chest_inv_ver",chest_inv_vers)
		end
	end
})