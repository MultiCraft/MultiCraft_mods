
--
-- Workbench
--

local function set_workbench(player)

	local split_form = ""
	local workbench = "size[9,8.75]" ..
	"image_button_exit[8.4,-0.1;0.75,0.75;close.png;exit;;true;true;]"..
	"background[-0.2,-0.26;9.41,9.49;formspec_workbench.png]" ..
	"bgcolor[#08080880;true]" ..
	"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
	"list[detached:split;main;8,3.14;1,1;]"..
	"list[current_player;main;0,4.5;9,3;9]" ..
	"list[current_player;main;0,7.74;9,1;]" ..
	"list[current_player;craft;2,0.5;3,3;]" ..
	"list[current_player;craftpreview;6.05,1.5;1,1;]" ..
	split_form

	minetest.show_formspec(player:get_player_name(), "main", workbench)
end

minetest.register_node("default:workbench", {
		description = "Workbench",
		tiles = {"workbench_top.png", "workbench_top.png", "workbench_side.png",
			"workbench_side.png", "workbench_front.png", "workbench_front.png"},
		paramtype2 = "facedir",
		paramtype = "light",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		on_rightclick = function (pos, node, clicker, itemstack)
			set_workbench(clicker)
		end
	})

minetest.register_craft({
		output = 'default:workbench',
		recipe = {
			{'group:wood', 'group:wood'},
			{'group:wood', 'group:wood'}
		}
	})

local split_inv = minetest.create_detached_inventory("split", {
    allow_move = function(_, _, _, _, _, count, _)
        return count
    end,
    allow_put = function(_, _, _, stack, _)
        return stack:get_count() / 2
    end,
    allow_take = function(_, _, _, stack, _)
        return stack:get_count()
    end,
})
split_inv:set_size("main", 1)
