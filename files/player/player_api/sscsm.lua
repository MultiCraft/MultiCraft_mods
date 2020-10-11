-- This SSCSM allows the creative SSCSM to get a player preview to display in
-- the inventory.

player_api = {}

local preview
function player_api.preview()
	assert(preview)
	return preview
end

sscsm.register_on_com_receive("player_api:preview", function(msg)
	preview = msg
end)
