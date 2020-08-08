creative = {}

minetest.register_privilege("creative", {
	description = "Enable creative mode",
	give_to_singleplayer = false
})

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

function creative.is_enabled_for(name)
	return creative_mode_cache or
		minetest.check_player_privs(name, {creative = true})
end

-- Unlimited node placement
minetest.register_on_placenode(function(_, _, placer)
	if placer and placer:is_player() then
		return creative.is_enabled_for(placer:get_player_name())
	end
end)

-- Don't pick up if the item is already in the inventory
local old_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
	if not digger or not digger:is_player() or
		not creative.is_enabled_for(digger:get_player_name()) then
		return old_handle_node_drops(pos, drops, digger)
	end
	local inv = digger:get_inventory()
	if inv then
		for _, item in pairs(drops) do
			if not inv:contains_item("main", item, true) then
				inv:add_item("main", item)
			end
		end
	end
end
