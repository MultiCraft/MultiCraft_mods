local hud_id

-- Note: This function won't work with multiple different players
local function update_hud(player)
	local stack = player:get_wielded_item()
	if stack:get_name():sub(1, 17) == "nextgen_bows:bow_" then
		if not hud_id then
			hud_id = player:hud_add({
				hud_elem_type = "image",
				position = {x = 0.5, y = 0.5},
				text = "crosshair.png",
				scale = {x = 0.75, y = 0.75}
			})
		end
	elseif hud_id then
		player:hud_remove(hud_id)
		hud_id = nil
	end
end

if minetest.localplayer then
	sscsm.every(0.125, update_hud, minetest.localplayer)
else
	return update_hud
end
