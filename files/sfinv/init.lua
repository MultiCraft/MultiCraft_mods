dofile(minetest.get_modpath("sfinv") .. "/api.lua")

sfinv.register_page("sfinv:inventory", {
	get = function(_, player, context)
		return sfinv.make_formspec(player, context, [[ ]], true)
	end
})