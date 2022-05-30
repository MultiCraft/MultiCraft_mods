if minetest.settings:get_bool("enable_weather") == false then
	return
end

local S = minetest.get_translator_auto({"ru"})

local vadd, vmultiply, vround = vector.add, vector.multiply, vector.round
local random = math.random
local snow_covers = minetest.settings:get_bool("weather_snow_covers") ~= false

local weather = {
	type = "none",
	wind = {x = 0, y = 0, z = 0}
}


--
-- Save and restore weather condition
--

local mod_storage = minetest.get_mod_storage()

do
	local saved_weather = minetest.deserialize(
			mod_storage:get_string("weather"))
	if type(saved_weather) == "table" then
		weather = saved_weather
	end
end

minetest.register_on_shutdown(function()
	mod_storage:set_string("weather", minetest.serialize(
			({type = weather.type, wind = weather.wind})))
end)


--
-- Registration of weather types
--

weather.registered = {}
function weather.register(id, def)
	local ndef = table.copy(def)
	weather.registered[id] = ndef
end

-- Rain
weather.register("rain", {
	desc = S("Rain"),
	falling_speed = 5,
	amount = 6,
	size = 20,
	height = 3,
	vertical = true,
	texture = "weather_lite_rain.png"
})

-- Snow
weather.register("snow", {
	desc = S("Snow"),
	falling_speed = 2,
	amount = 5,
	size = 35,
	height = 2,
	texture = "weather_lite_snow.png"
})


--
-- Change of weather
--

function weather.set(weather_type, wind)
	weather.type = weather_type
	if wind then
		weather.wind = wind
	end
	if minetest.global_exists("sscsm") then
		sscsm.com_send_all("weather_lite:set", {
			type = weather_type,
			wind = wind
		})
	end
end

local function weather_change(disable)
	if weather.type == "none" and not disable then
		for w in pairs(weather.registered) do
			if random(3) == 1 then
				weather.set(w, {
					x = random(0, 8),
					y = 0,
					z = random(0, 8)
				})

				break
			end
		end
		minetest.after(random(60, 300), function() weather_change(true) end)
	else
		weather.set("none")
		minetest.after(random(1800, 3600), weather_change)
	end
end
minetest.after(random(600, 1800), weather_change)


--
-- Processing players
--

local is_valid_pos = minetest.is_valid_pos
if not is_valid_pos then
	is_valid_pos = function() return true end
end

-- This is a separate function to prevent "return" from breaking.
local function process_player(player, current_downfall)
	local player_name = player:get_player_name()
	if not player:is_player() or (sscsm and sscsm.has_sscsms_enabled(player_name)) then
		return
	end

	local ppos = vround(player:get_pos())
	ppos.y = ppos.y + 1.5
	-- Higher than clouds
	local cloud_height = player:get_clouds().height
	cloud_height = cloud_height ~= 0 and cloud_height or 120
	if not is_valid_pos(ppos) or ppos.y > cloud_height or ppos.y < -8 then return end
	-- Inside liquid
	local head_inside = minetest.get_node_or_nil(ppos)
	local def_inside = head_inside and minetest.registered_nodes[head_inside.name]
	if def_inside and def_inside.drawtype == "liquid" then return end
	-- Too dark, probably not under the sky
	local light = minetest.get_node_light(ppos, 0.5)
	if light and light < 12 then return end

	local wind_pos = vmultiply(weather.wind, -1)
	local minp = vadd(vadd(ppos, {x = -8, y = current_downfall.height, z = -8}), wind_pos)
	local maxp = vadd(vadd(ppos, {x =  8, y = current_downfall.height, z =  8}), wind_pos)
	local vel = {x = weather.wind.x, y = -current_downfall.falling_speed, z = weather.wind.z}
	local vert = current_downfall.vertical or false

	minetest.add_particlespawner({
		amount = current_downfall.amount,
		time = 0.1,
		minpos = minp,
		maxpos = maxp,
		minvel = vel,
		maxvel = vel,
		minsize = current_downfall.size,
		maxsize = current_downfall.size,
		collisiondetection = true,
		collision_removal = true,
		vertical = vert,
		texture = current_downfall.texture,
		glow = 1,
		playername = player_name
	})
end

minetest.register_globalstep(function()
	local current_downfall = weather.registered[weather.type]
	if current_downfall == nil then return end

	for _, player in ipairs(minetest.get_connected_players()) do
		process_player(player, current_downfall)
	end
end)


--
-- Snow will cover the blocks and melt after some time
--

if snow_covers then
	-- Temp node to start the node timer
	minetest.register_node("weather_lite:snow_cover", {
		tiles = {"blank.png"},
		drawtype = "signlike",
		paramtype = "light",
		buildable_to = true,
		groups = {not_in_creative_inventory = 1, dig_immediate = 3},
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(random(60, 180))
			minetest.swap_node(pos, {name = "default:snow"})
		end
	})

	minetest.override_item("default:snow", {
		on_timer = function(pos)
			if weather and weather.type and weather.type == "snow" then
				return true
			end

			minetest.remove_node(pos)
		end
	})

	minetest.register_abm({
		label = "Weather: snow cover",
		nodenames = {"group:crumbly", "group:snappy", "group:cracky", "group:choppy"},
		neighbors = {"air"},
		interval = 15,
		chance = 500,
		catch_up = false,
		action = function(pos, node)
			if weather.type == "snow" then
				if pos.y < -8 or pos.y > 120 then return end
				if minetest.registered_nodes[node.name].drawtype == "normal"
				or minetest.registered_nodes[node.name].drawtype == "allfaces_optional" then
					pos.y = pos.y + 1
					if minetest.get_node(pos).name ~= "air" then return end
					local light_day = minetest.get_node_light(pos, 0.5)
					local light_night = minetest.get_node_light(pos, 0)
					if  light_day   and light_day  == 15
					and light_night and light_night < 10 then
						minetest.add_node(pos, {name = "weather_lite:snow_cover"})
					end
				end
			end
		end
	})
end

minetest.register_privilege("weather", {
	description = "Allows changing the weather",
	give_to_singleplayer = minetest.settings:get_bool("creative_mode")
})

minetest.register_chatcommand("weather", {
	params = "<weather>",
	description = S("Setting the weather type"),
	privs = {weather = true},
	func = function(name, param)
		if param and (weather.registered[param] or param == "none") then
			weather.set(param)
			if param == "none" then
				minetest.chat_send_player(name, S("Set clear weather."))
			else
				local setw = weather.registered[param].desc or param:gsub("^%l", string.upper)
				minetest.chat_send_player(name, S("Set weather type: @1.", setw))
			end
		else
			local types = "none"
			for w in pairs(weather.registered) do
				types = types .. ", " .. w
			end
			minetest.chat_send_player(name, S("Available weather types: @1.", types))
		end
	end
})

if not minetest.global_exists("sscsm") then
	return
end

sscsm.register({
	name = "weather_lite",
	file = minetest.get_modpath("weather_lite") .. "/sscsm.lua"
})

local liquids
sscsm.register_on_sscsms_loaded(function(name)
	if not liquids then
		liquids = {}
		for node, def in pairs(minetest.registered_nodes) do
			if def.drawtype == "liquid" then
				liquids[node] = true
			end
		end
	end

	local player = minetest.get_player_by_name(name)
	sscsm.com_send(name, "weather_lite:set", {
		type = weather.type,
		wind = weather.wind,
		registered = weather.registered,
		cloud_height = player:get_clouds().height,
		liquids = liquids
	})
end)
