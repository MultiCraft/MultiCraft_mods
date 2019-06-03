playerplus = {}

-- get node but use fallback for nil or unknown
local node_ok = function(pos, fallback)
	fallback = fallback or "air"
	local node = minetest.get_node_or_nil(pos)
	if node and minetest.registered_nodes[node.name] then
		return node.name
	end
	return fallback
end

local time = 0
-- check interval
local check = 0.5
if not minetest.is_singleplayer() then
	local check = 1
end

minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time < check then
		return
	end
	-- reset time for next check
	time = 0
	-- define locals outside loop
	local name, pos, ndef, nslow

	-- loop through players
	for _,player in ipairs(minetest.get_connected_players()) do

		name = player:get_player_name()
		pos = player:get_pos()
		pos.y = pos.y - 0.1 -- standing on
		playerplus[name].nod_stand = node_ok(pos)

		-- Does the node below me have an on_walk_over function set?
		ndef = minetest.registered_nodes[playerplus[name].nod_stand]
		if ndef and ndef.on_walk_over then
			ndef.on_walk_over(pos, ndef, player)
		end

		pos.y = pos.y + 1.5 -- head level
		playerplus[name].nod_head = node_ok(pos)

		pos.y = pos.y - 1.2 -- feet level
		playerplus[name].nod_feet = node_ok(pos)

		pos.y = pos.y - 0.2 -- reset pos

		-- are we standing on any nodes that slow player down?
		nslow = nil
		if playerplus[name].nod_stand == "default:snow"
		or playerplus[name].nod_stand == "default:snowblock"
		or playerplus[name].nod_stand == "default:bedrock"
		or playerplus[name].nod_stand == "default:slimeblock"
		or playerplus[name].nod_stand == "mobs:cobweb"
		or playerplus[name].nod_feet  == "mobs:cobweb"
		or playerplus[name].nod_head  == "mobs:cobweb" then
			nslow = true
		end

		-- apply slowdown changes
		if nslow and not playerplus[name].nslow then
			playerphysics.add_physics_factor(player, "speed", "playerplusslow", 0.7)
			playerplus[name].nslow = true

		elseif not nslow and playerplus[name].nslow then
			playerphysics.remove_physics_factor(player, "speed", "playerplusslow")
			playerplus[name].nslow = nil
		end
	end
end)

-- set to blank on join (for 3rd party mods)
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()

	playerplus[name] = {}
	playerplus[name].nod_head = ""
	playerplus[name].nod_feet = ""
	playerplus[name].nod_stand = ""
end)

-- clear when player leaves
minetest.register_on_leaveplayer(function(player)
	playerplus[ player:get_player_name() ] = nil
end)
