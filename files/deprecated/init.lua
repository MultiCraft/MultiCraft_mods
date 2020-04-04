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
local split_inv = minetest.create_detached_inventory("split", {
	allow_put = function(_, _, _, stack, _)
		return stack:get_count() / 2
	end
})
split_inv:set_size("main", 1)	

-- Fences alias
minetest.register_alias("fences:fence_wood", "default:fence_wood")
for _, n in pairs({"1", "2", "3", "11", "12", "13", "14",
		"21", "22", "23", "24", "32", "33", "34", "35"}) do
	minetest.register_alias("fences:fence_wood_" .. n, "default:fence_wood")
end

--== mesecons_solarpanel ==--
minetest.register_lbm({
	label = "Enable timer on ABM Solar Panels",
	name = ":mesecons_solarpanel:timer_start",
	nodenames = {"mesecons_solarpanel:solar_panel_off", "mesecons_solarpanel:solar_panel_on"},
	run_at_every_load = false,
	action = function(pos)
		minetest.get_node_timer(pos):start(mesecon.setting("spanel_interval", 1))
	end
})

minetest.register_alias("mesecons_solarpanel:solar_panel_inverted_off", "mesecons_solarpanel:solar_panel_off")
minetest.register_alias("mesecons_solarpanel:solar_panel_inverted_on", "mesecons_solarpanel:solar_panel_on")

--== Potions ==--
minetest.register_alias("potionspack:antigravity", "pep:grav0")
minetest.register_alias("potionspack:antigravityii", "pep:gravreset")
minetest.register_alias("potionspack:speed", "pep:speedminus")
minetest.register_alias("potionspack:speedii", "pep:speedplus")
minetest.register_alias("potionspack:inversion", "pep:invisible")
minetest.register_alias("potionspack:confusion", "pep:breath")
minetest.register_alias("potionspack:whatwillthisdo", "pep:mole")
minetest.register_alias("potionspack:instanthealth", "pep:regen")
minetest.register_alias("potionspack:instanthealthii", "pep:regen2")
minetest.register_alias("potionspack:regen", "pep:regen")
minetest.register_alias("potionspack:regenii", "pep:regen2")
minetest.register_alias("potionspack:harming", "pep:gravreset")
minetest.register_alias("potionspack:harmingii", "pep:gravreset")
minetest.register_alias("pep:jumpreset", "pep:nightvision")
minetest.register_alias("pep:speedreset", "pep:invisible")
