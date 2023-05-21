-- This SSCSM allows the creative SSCSM to get a player preview to display in
-- the inventory.

player_api = {}
local esc = minetest.formspec_escape
local fmt = string.format
local tconcat = table.concat

local mesh, textures, rot_start, rot_cont, rot_mouse, anim_x, anim_y, anim_speed

-- Allow other mods to override the textures
function player_api.get_textures()
	return textures
end

-- This doesn't have nearly as many features as the server-side preview_model
-- function.
function player_api.preview_model(_, x, y, w, h)
	local t = {}
	for i, texture in ipairs(player_api.get_textures()) do
		t[i] = esc(texture)
	end

	return fmt("model[%.2f,%.2f;%.2f,%.2f;player_preview;%s;%s;0,%d;%s;%s;%u,%u;%u]",
		x, y, w, h, mesh, tconcat(t, ","), rot_start, rot_cont, rot_mouse, anim_x, anim_y, anim_speed)
end

sscsm.register_on_com_receive("player_api:preview", function(msg)
	mesh, textures, rot_start, rot_cont, rot_mouse, anim_x, anim_y, anim_speed = unpack(msg)
end)
