-- Intllib
local S = intllib.make_gettext_pair()

toolranks = {}

local function create_description(name, uses, level)
	if not uses then return name end
	return default.colors.green .. name .. "\n"
		.. default.colors.gold .. S("Level") .. ": " .. (level or 1) .. "\n"
		.. default.colors.grey .. S("Uses") .. ": " .. (uses or 0)
end

function toolranks.get_level(uses)
	if uses >= 3200 then
		return 6
	elseif uses >= 1600 then
		return 5
	elseif uses >= 800 then
		return 4
	elseif uses >= 400 then
		return 3
	elseif uses >= 200 then
		return 2
	else
		return 1
	end
end

function toolranks.new_afteruse(itemstack, user, _, digparams)
	-- Get tool metadata and number of times used
	local itemmeta = itemstack:get_meta()
	local dugnodes = tonumber(itemmeta:get_string("dug")) or 1

	-- Only count nodes that spend the tool
	if digparams.wear > 0 then
		dugnodes = dugnodes + 1
		itemmeta:set_string("dug", dugnodes)
	else
		return
	end

	-- Get tool description and last level
	local itemdef   = itemstack:get_definition()
	local itemdesc  = itemdef.original_description or itemdef.description or "Tool"
	local lastlevel = tonumber(itemmeta:get_string("lastlevel")) or 1
	local name = user:get_player_name()

	-- Warn player when tool is almost broken
	if itemstack:get_wear() > 60100 then
		minetest.chat_send_player(name,
			default.colors.gold .. S("Your tool is almost broken!"))
		minetest.sound_play("default_tool_breaks", {
			to_player = name,
			gain = 2.0
		})
	end

	local level = toolranks.get_level(dugnodes)

	-- Alert player when tool got a new level
	if lastlevel < level then
		minetest.chat_send_player(name, S("Your") .. " "
			.. default.colors.green .. itemdesc
			.. default.colors.white .. " " .. S("got a new level!"))
		minetest.sound_play("toolranks_levelup", {
			to_player = name,
			gain = 1.0
		})
		itemmeta:set_string("lastlevel", level)
	end

	-- Set new meta
	local newdesc = create_description(itemdesc, dugnodes, level)
	itemmeta:set_string("description", newdesc)

	-- Set wear level
	local wear = digparams.wear
	if level > 1 then
		wear = digparams.wear * 4 / (4 + level)
	end

	itemstack:add_wear(wear)
	return itemstack
end

-- Helper function
minetest.after(0, function()
	for name, def in pairs(minetest.registered_tools) do
		minetest.override_item(name, {
			original_description = def.description,
			description = create_description(def.description),
			after_use = toolranks.new_afteruse
		})	
	end
end)
