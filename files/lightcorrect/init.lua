--
-- LightCorrect mod
-- By MoNTE48
-- License: CC-BY-NC-SA
--

lightcorrect = {}
	minetest.register_globalstep(
	function(dtime)
	local light = (minetest.get_timeofday()*2)
	if light < 0.4 then
		for _,player in ipairs(minetest.get_connected_players()) do
		player:override_day_night_ratio((light)+0.2)
		end
	else
		for _,player in ipairs(minetest.get_connected_players()) do
		player:override_day_night_ratio(nil)
	end
	end
end
)