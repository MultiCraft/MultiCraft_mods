local storage = minetest.get_mod_storage()
local __player_data

-- Table Save Load Functions
function awards.save()
	storage:set_string("player_data", minetest.write_json(__player_data))
end

function awards.load()
	local json = storage:get_string("player_data")
	__player_data = (json and json ~= "") and minetest.parse_json(json) or {}
end

function awards.player(name)
	assert(type(name) == "string")
	local data = __player_data[name] or {}
	__player_data[name] = data

	data.name     = data.name or name
	data.unlocked = data.unlocked or {}
	return data
end

function awards.player_or_nil(name)
	return __player_data[name]
end

function awards.enable(name)
	awards.player(name).disabled = nil
end

function awards.disable(name)
	awards.player(name).disabled = true
end

function awards.clear_player(name)
	__player_data[name] = {}
end
