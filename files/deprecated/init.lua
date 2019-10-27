-- Media and code needed to upgrade to the new version.
-- Must be removed no earlier than 12 months after release.

local path = minetest.get_modpath("deprecated")

--== mesecons_pistons ==--
dofile(path .. "/mesecons_pistons.lua")

--== throwing ==--
minetest.register_entity(":throwing:arrow_entity", {
	is_visible = false,
	on_activate = function(self)
		self.object:remove()
	end
})

--== split ==--
minetest.register_on_joinplayer(function()
	local split_inv = minetest.create_detached_inventory("split", {
		allow_put = function(_, _, _, stack, _)
			return stack:get_count() / 2
		end
	})
	split_inv:set_size("main", 1)	
end)
