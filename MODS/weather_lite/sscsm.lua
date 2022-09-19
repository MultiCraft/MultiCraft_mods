local vadd, vmultiply, vround = vector.add, vector.multiply, vector.round

local weather = {
	type = "none",
	wind = {x = 0, y = 0, z = 0},
	registered = {},
	liquids = {}
}

--
-- Change of weather
--

sscsm.register_on_com_receive("weather_lite:set", function(msg)
	for k, v in pairs(msg) do
		weather[k] = v
	end
end)

--
-- Processing players
--

sscsm.every(0.09, function()
	local current_downfall = weather.registered[weather.type]
	if current_downfall == nil then return end

	local ppos = vround(minetest.localplayer:get_pos())
	ppos.y = ppos.y + 1.5

	-- Higher than clouds
	local cloud_height = weather.cloud_height
	cloud_height = cloud_height ~= 0 and cloud_height or 120
	if not minetest.is_valid_pos(ppos) or ppos.y > cloud_height or ppos.y < -8 then return end

	-- Inside liquid
	local head_inside = minetest.get_node_or_nil(ppos)
	if head_inside and weather.liquids[head_inside.name] then return end

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
		glow = 1
	})
end)
