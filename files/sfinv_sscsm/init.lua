if not minetest.global_exists("sscsm") then
	return
end

-- SSCSM helpers for sfinv
sscsm.register({
	name = "sfinv_sscsm",
	file = minetest.get_modpath("sfinv_sscsm") .. DIR_DELIM .. "api.lua",
})

-- If an SSCSM handler returns false, it will get sent to the server here.
sscsm.register_on_com_receive("sfinv_sscsm:fields", function(name, fields)
	local player = minetest.get_player_by_name(name)

	-- Ensure fields is a table containing only strings.
	if type(fields) ~= "table" or not player then return end
	for k, v in pairs(fields) do
		if type(k) ~= "string" or type(v) ~= "string" then
			return
		end
	end

	-- Run callbacks.
	local funcs = minetest.registered_on_player_receive_fields
	for i = #funcs, 1, -1 do
		if funcs[i](player, "", fields) then
			return
		end
	end
end)

-- Add sfinv.open_formspec().
function sfinv.open_formspec(player, context)
	local name = player:get_player_name()
	if sscsm.has_sscsms_enabled(name) then
		sscsm.com_send(name, "sfinv_sscsm:open_formspec")
		return
	end
	local fs = sfinv.get_formspec(player,
			context or sfinv.get_or_create_context(player))
	minetest.show_formspec(name, "", fs)
end

local old_set_page = sfinv.set_page
function sfinv.set_page(player, pagename, temp)
	local name = player:get_player_name()
	if sscsm.has_sscsms_enabled(name) then
		sscsm.com_send(name, "sfinv_sscsm:set_page", {pagename, temp})
		if temp then return end
	end

	return old_set_page(player, pagename, temp)
end

-- Send default.gui_bg and default.listcolors.
sscsm.register_on_sscsms_loaded(function(name)
	sscsm.com_send(name, "sfinv_sscsm:formspec_prepend",
		default.gui_bg .. default.listcolors)
end)
