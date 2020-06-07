dofile(minetest.get_modpath("sfinv") .. "/api.lua")

sfinv.register_page("sfinv:inventory", {
	get = function(_, player, context)
		return sfinv.make_formspec(player, context, [[
				listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]
				list[current_player;craft;2.75,1;2,1;1]
				list[current_player;craft;2.75,2;2,1;4]
				list[current_player;craftpreview;5.75,1.5;1,1;]
				image[4.75,1.5;1,1;default_arrow_bg.png^[transformR270]
			]], true)
	end
})
