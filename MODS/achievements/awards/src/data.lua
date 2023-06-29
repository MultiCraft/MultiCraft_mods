local storage = minetest.get_mod_storage()

local cached_data = {}

local legacy_data
do
	-- Load legacy data
	local json = storage:get_string("player_data")
	legacy_data = (json and json ~= "") and minetest.parse_json(json) or {}
end

-- Clear the cache and save the awards list when a player leaves
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if cached_data[name] then
		player:get_meta():set_string("awards", minetest.write_json(cached_data[name]))
		cached_data[name] = nil
	end
end)

-- Save awards data for all players
function awards.save()
	for name in pairs(cached_data) do
		awards.save_for_player(name)
	end
	storage:set_string("player_data", minetest.write_json(legacy_data))
end

-- Save awards data for one player
function awards.save_for_player(name)
	local player = minetest.get_player_by_name(name)
	if player and cached_data[name] then
		player:get_meta():set_string("awards", minetest.write_json(cached_data[name]))
	end
end

-- Gets the list of awards for an online player
-- TODO: Maybe make this function accept a player object?
function awards.player(name)
	local player = minetest.get_player_by_name(name)
	if not player then return end

	local data = cached_data[name]
	if not data then
		local meta = player:get_meta()
		local json = meta:get_string("awards")
		if json and json ~= "" then
			-- Load data from player meta
			data = minetest.parse_json(json)
			if not data then
				minetest.log("warning", "[awards] Invalid saved data for " .. name)
			end
		elseif legacy_data[name] then
			-- Migrate legacy data to player meta
			data = legacy_data[name]
			meta:set_string("awards", minetest.write_json(data))
		end

		-- Remove legacy data
		-- This is done when loading data from player meta as well since
		-- legacy_data isn't saved if the server crashes
		legacy_data[name] = nil

		-- Create a new entry if required and save to cache
		data = data or {}
		cached_data[name] = data
	end

	-- Make sure the default values exist
	-- minetest.write_json({}) returns "null" so the "unlocked" table may not
	-- exist in existing entries if it's empty
	data.name = data.name or name
	data.unlocked = data.unlocked or {}

	return data
end

awards.player_or_nil = awards.player

function awards.enable(name)
	awards.player(name).disabled = nil
end

function awards.disable(name)
	awards.player(name).disabled = true
end

function awards.clear_player(name)
	local player = minetest.get_player_by_name(name)
	if player then
		cached_data[name] = nil
		player:get_meta():set_string("awards", "")
	end
end
