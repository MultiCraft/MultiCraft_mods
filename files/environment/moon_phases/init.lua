local mod_climate_api = minetest.get_modpath("climate_api") ~= nil

local GSCYCLE = 1			-- global step cycle in seconds
local PHASE_LENGTH = 4		-- default moon cycle length in days
local PHASE_COUNT = 8		-- number of phases to go through

local ceil, floor = math.ceil, math.floor

local sky_color = {
	"#1d293aff",
	"#1c4b8dff",
	nil,
	"#579dffff",
	nil,
	"#1c4b8dff",
	"#1d293aff",
	"#000000ff"
}

local horizon_color = {
	"#243347ff",
	"#235fb3ff",
	nil,
	"#73aeffff",
	nil,
	"#3079dfff",
	"#173154ff",
	"#000000ff"
}

moon_phases = {}
local phase = 1
local state = minetest.get_mod_storage()

-- calculate current moon phase from date
-- and stored date offset
local function calculate_phase()
	local time = minetest.get_timeofday()
	local day = minetest.get_day_count() + state:get_int("date_offset")
	if time > 0.5 then
		day = day + 1
	end
	return ((ceil(day / PHASE_LENGTH) - 1) % PHASE_COUNT) + 1
end

-- return the current moon phase
function moon_phases.get_phase()
	return phase
end

-- set the moon texture of a player to the given phase
local function set_texture(player, phase)
	if not player.get_stars then return end -- check for new sky API
	local texture = "moon_" .. phase .. "_classic.png"
	local name = "moon_phases:cycle"
	local sky = {}
	sky.sky_data = {
		type = "regular",
		sky_color = {
			night_sky = sky_color[phase],
			night_horizon = horizon_color[phase]
		}
	}
	sky.moon_data = {
		visible = true,
		texture = texture,
		scale = 0.8
	}
	local playername = player:get_player_name()
	if mod_climate_api then
		sky.priority = 0
		climate_api.skybox.add(playername, name, sky)
	else
		player:set_sky(sky.sky_data)
		player:set_moon(sky.moon_data)
	end
end

-- check for day changes
local function handle_time_progression()
	local n_phase = calculate_phase()
	if n_phase ~= phase then
		phase = n_phase
		for _, player in ipairs(minetest.get_connected_players()) do
			set_texture(player, phase)
		end
	end
end

-- set the current moon phase
-- @param phase int Phase between 1 and PHASE_COUNT
function moon_phases.set_phase(nphase)
	nphase = floor(tonumber(nphase))
	if (not nphase) or nphase < 1 or nphase > PHASE_COUNT then
		return false
	end
	local day = minetest.get_day_count()
	local date_offset = state:get_int("date_offset")
	local progress = (day + date_offset) % PHASE_LENGTH
	local phase_offset = (nphase - phase + PHASE_COUNT) % PHASE_COUNT
	local add_offset = ((phase_offset * PHASE_LENGTH) + date_offset - progress)
	state:set_int("date_offset", add_offset)
	handle_time_progression()
	return true
end

-- set the moon texture of newly joined player
minetest.register_on_joinplayer(function(player)
	set_texture(player, phase)
end)

-- check for day changes and call handlers
local timer = math.huge
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < GSCYCLE then return end
	handle_time_progression()
	timer = 0
end)

-- make moon phase available to weather effects
if mod_climate_api then
	climate_api.register_global_influence("moonphase", moon_phases.get_phase)
end
