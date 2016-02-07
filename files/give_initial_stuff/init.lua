minetest.register_on_newplayer(function(player)
	player:get_inventory():add_item('main', 'default:sword_steel')
	player:get_inventory():add_item('main', 'default:torch 8')
end)
