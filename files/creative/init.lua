creative = {}

minetest.register_privilege("creative", {
	description = "Enable creative mode",
	give_to_singleplayer = false
})

-- Override the engine's creative mode function
local old_is_creative_enabled = minetest.is_creative_enabled

function minetest.is_creative_enabled(name)
	if name == "" then
		return old_is_creative_enabled(name)
	end
	return minetest.check_player_privs(name, {creative = true}) or
		old_is_creative_enabled(name)
end

-- For backwards compatibility:
function creative.is_enabled_for(name)
	return minetest.is_creative_enabled(name)
end

-- Unlimited node placement
minetest.register_on_placenode(function(_, _, placer)
	if placer and placer:is_player() then
		return minetest.is_creative_enabled(placer:get_player_name())
	end
end)

-- Don't pick up if the item is already in the inventory
local old_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
	if not digger or not digger:is_player() or
		not minetest.is_creative_enabled(digger:get_player_name()) then
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
