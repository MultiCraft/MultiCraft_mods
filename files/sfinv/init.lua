dofile(minetest.get_modpath("sfinv") .. "/api.lua")

sfinv.register_page("sfinv:crafting", {
	title = "Crafting",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]
				list[current_player;craft;4,1;2,1;1]
				list[current_player;craft;4,2;2,1;4]
				list[current_player;craftpreview;7.05,1.54;1,1;]
				list[detached:split;main;7.99,3.15;1,1;]
				image[1.5,0;2,4;default_player2d.png;]
				image_button_exit[8.4,-0.1;0.75,0.75;close.png;exit;;true;true]
			]], true)
	end
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
