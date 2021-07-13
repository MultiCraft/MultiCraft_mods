-- This SSCSM allows the creative SSCSM to get a player preview to display in
-- the inventory.

player_api = {}
local fmt = string.format

-- This doesn't have nearly as many features as the server-side preview_model
-- function.
local preview
function player_api.preview_model(_, x, y, w, h)
	return fmt("model[%f,%f;%f,%f;%s]", x, y, w, h, assert(preview))
end

sscsm.register_on_com_receive("player_api:preview", function(msg)
	preview = msg
end)
