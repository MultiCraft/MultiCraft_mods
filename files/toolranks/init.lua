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

local floor, log  = math.floor, math.log
local fmt = string.format
local max_level = 16

function toolranks.get_level(uses)
	uses = uses or 0
	local result = floor(log(uses) / log(2)) - 6

	return (result > 0 and result < max_level and result)
		or (result <= 0 and 1) or max_level
end

function toolranks.create_description(description, uses)
	local newdesc = fmt("%s%s\n%s%s %s\n%s%s %s",
		C.green, description,
		C.gold, S"Level:", toolranks.get_level(uses),
		C.grey, S"Uses:", uses or 0)

	return newdesc
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

	if lastlevel < level then
		minetest.chat_send_player(name,
			S("Your tool \"@1\" got a new @2 level!",
			C.green .. itemdesc .. C.white, level))

		minetest.sound_play("toolranks_levelup", {to_player = name})
		itemmeta:set_string("lastlevel", level)
	end

	-- Set new description
	itemmeta:set_string("description",
		toolranks.create_description(itemdesc, dugnodes))

	-- Set wear level
	if not minetest.is_creative_enabled(name) then
		local wear = digparams.wear
		if level > 1 then
			wear = wear * 4 / (4 + level - 1)
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
