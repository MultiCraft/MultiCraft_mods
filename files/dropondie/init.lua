local remi = minetest.setting_getbool("remove_items") or false
local crea = minetest.setting_getbool("creative_mode")

local drop = function(pos, itemstack)

	-- is remove_items enabled?
	if remi == true then
		return
	end

	local obj = core.add_item(pos, itemstack:take_item(itemstack:get_count()))

	if obj then

		-- drop stack random distances from player
		obj:setvelocity({
			x = math.random(-10, 10) / 9,
			y = 5,
			z = math.random(-10, 10) / 9,
		})
	end
end

minetest.register_on_dieplayer(function(player)

	-- are we in creative?
	if crea then
		return
	end

	local pos = player:getpos()

	-- display death coordinates
	minetest.chat_send_player(player:get_player_name(),
		'last known coords were '
		.. minetest.pos_to_string(vector.round(pos)))

	local player_inv = player:get_inventory()

	-- drop inventory items
	for i = 1, player_inv:get_size("main") do

		drop(pos, player_inv:get_stack("main", i))

		player_inv:set_stack("main", i, nil)
	end

	-- drop crafting grid items
	for i = 1, player_inv:get_size("craft") do

		drop(pos, player_inv:get_stack("craft", i))

		player_inv:set_stack("craft", i, nil)
	end
end)
