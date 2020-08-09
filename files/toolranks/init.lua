toolranks = {}

local translator = minetest.get_translator
local S = translator and translator("toolranks") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local C = default.colors

function toolranks.get_level(uses)
	if uses >= 16384 then
		return 8
	elseif uses >= 8192 then
		return 7
	elseif uses >= 4096 then
		return 6
	elseif uses >= 2048 then
		return 5
	elseif uses >= 1024 then
		return 4
	elseif uses >= 512 then
		return 3
	elseif uses >= 256 then
		return 2
	else
		return 1
	end
end

function toolranks.new_afteruse(itemstack, user, _, digparams)
	-- Get tool metadata and number of times used
	local itemmeta = itemstack:get_meta()
	local dugnodes = tonumber(itemmeta:get_string("dug")) or 0

	-- Only count nodes that spend the tool
	if digparams.wear > 0 then
		dugnodes = dugnodes + 1
		itemmeta:set_string("dug", dugnodes)
	else
		return itemstack
	end

	-- Get tool description and last level
	local itemdef   = itemstack:get_definition()
	local itemdesc  = itemdef.original_description or itemdef.description or "Tool"
	local lastlevel = tonumber(itemmeta:get_string("lastlevel")) or 1
	local name = user:get_player_name()

	-- Warn player when tool is almost broken
	if itemstack:get_wear() > 63500 then
		minetest.chat_send_player(name,
			C.gold .. S("Your tool \"@1\" is almost broken!",
			(C.ruby .. itemdesc .. C.gold)))

		minetest.sound_play("default_tool_breaks", {to_player = name})
	end

	local level = toolranks.get_level(dugnodes)

	-- Alert player when tool got a new level
	if lastlevel < level then
		minetest.chat_send_player(name,
			S("Your tool \"@1\" ot a new level!",
			(C.green .. itemdesc .. C.white)))

		minetest.sound_play("toolranks_levelup", {to_player = name})
		itemmeta:set_string("lastlevel", level)
	end

	-- Set new description
	itemmeta:set_string("description",
		C.green .. itemdesc .. "\n" ..
		C.gold .. S("Level: @1", level) .. "\n" ..
		C.grey .. S("Uses: @1", dugnodes))

	-- Set wear level
	if not (creative and creative.is_enabled_for
			and creative.is_enabled_for(name)) then
		local wear = digparams.wear
		if level > 1 then
			wear = digparams.wear * 4 / (4 + level)
		end
		itemstack:add_wear(wear)
	end

	return itemstack
end

-- Helper function
minetest.after(0, function()
	for name, def in pairs(minetest.registered_tools) do
		if not def.groups.armor_use then
			minetest.override_item(name, {
				original_description = def.description,
				after_use = toolranks.new_afteruse
			})
		end
	end
end)
