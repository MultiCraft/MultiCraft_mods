-- global
pova = {}

-- local
local pova_list = {}
local min, max = math.min, math.max

-- main loop that totals override list on timer
minetest.register_playerstep(function(_, playernames)
	for _, name in ipairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			pova.do_override(player, name)
		end
	end
end)

-- global functions
function pova.add_override(name, item, def)
	-- nil check
	if not name or not item then return end

	if name:is_player() then
		name = name:get_player_name()
	end

	-- priority defaults to 50 when not included
	def.priority = tonumber(def.priority) or 50

	-- if same item is assigned with lower priority then change ignored
	local pova_item = pova_list[name][item]
	if pova_item and pova_item.priority and pova_item.priority > def.priority then
		return
	end

	pova_list[name][item] = def
end

function pova.get_override(name, item)
	return pova_list[name][item]
end

function pova.del_override(name, item)
	-- nil check
	if not name or not item then return end

	if name:is_player() then
		name = name:get_player_name()
	end

	pova_list[name][item] = nil
end

function pova.do_override(player, name)
	name = name or player:get_player_name()

	-- somehow player list is missing
	if not pova_list[name] then
		return
	end

	-- set base defaults
	local speed, jump, gravity = 1, 1, 1

	-- check for new defaults
	if pova_list[name]["default"] then
		speed = pova_list[name]["default"].speed or 1
		jump = pova_list[name]["default"].jump or 1
		gravity = pova_list[name]["default"].gravity or 1
	end

	-- loop through list of named overrides
	for id, var in pairs(pova_list[name]) do
		-- skip any custom names
		if var
				and id ~= "default"
				and id ~= "min"
				and id ~= "max"
				and id ~= "force" then
			-- add any additional changes
			speed = speed + (pova_list[name][id].speed or 0)
			jump = jump + (pova_list[name][id].jump or 0)
			gravity = gravity + (pova_list[name][id].gravity or 0)
		end
	end

	-- make sure total doesn't go below minimum values
	if pova_list[name]["min"] then
		speed = max(pova_list[name]["min"].speed or 0, speed)
		jump = max(pova_list[name]["min"].jump or 0, jump)
		gravity = max(pova_list[name]["min"].gravity or 0, gravity)
	end

	-- make sure total doesn't go above maximum values
	if pova_list[name]["max"] then
		speed = min(pova_list[name]["max"].speed or speed, speed)
		jump = min(pova_list[name]["max"].jump or jump, jump)
		gravity = min(pova_list[name]["max"].gravity or gravity, gravity)
	end

	-- force values (for things like sleeping in bed when speed is 0)
	if pova_list[name]["force"] then
		speed = pova_list[name]["force"].speed or speed
		jump = pova_list[name]["force"].jump or jump
		gravity = pova_list[name]["force"].gravity or gravity
	end

	-- set new overrides
	player:set_physics_override({
		speed = speed,
		jump = jump,
		gravity = gravity
	})
end


-- set player table on join
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	pova_list[name] = {}
	pova.do_override(player, name)
end)

-- reset player table on respawn
minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	pova_list[name] = {}
	pova.do_override(player, name)
end)

-- blank player table on leave
minetest.register_on_leaveplayer(function(player)
	pova_list[player:get_player_name()] = nil
end)
