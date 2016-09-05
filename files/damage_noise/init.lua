
damage = {}

minetest.register_on_joinplayer(function(player)
	damage[player:get_player_name()] = player:get_hp()
end)

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local newhp = player:get_hp()
		local oldhp = damage[player:get_player_name()]
		
		if oldhp > newhp then
			local pos = player:getpos()
			minetest.sound_play("hurt", {
				pos = pos,
				max_hear_distance = 10,
				gain = 0.5,
			})
		end
		damage[player:get_player_name()] = newhp
	end
end)
