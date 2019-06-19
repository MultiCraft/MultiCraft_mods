hunger = {}
hunger.players = {}
hunger.food = {}

HUNGER_TICK = 600 -- time in seconds after that 1 hunger point is taken
HUNGER_HEALTH_TICK = 4 -- time in seconds after player gets healed/damaged
HUNGER_MOVE_TICK = 0.5 -- time in seconds after the movement is checked

HUNGER_EXHAUST_DIG = 2 -- exhaustion increased this value after digged node
HUNGER_EXHAUST_PLACE = 1 -- exhaustion increased this value after placed
HUNGER_EXHAUST_MOVE = 2 -- exhaustion increased this value if player movement detected
HUNGER_EXHAUST_LVL = 160 -- at what exhaustion player saturation gets lowered

HUNGER_HEAL = 1 -- number of HP player gets healed after HUNGER_HEALTH_TICK
HUNGER_HEAL_LVL = 15 -- lower level of saturation needed to get healed
HUNGER_STARVE = 1 -- number of HP player gets damaged by hunger after HUNGER_HEALTH_TICK
HUNGER_STARVE_LVL = 3 -- level of staturation that causes starving

HUNGER_MAX = 30 -- maximum level of saturation

-- Callbacks
if minetest.settings:get_bool("enable_damage") then

	local modpath = minetest.get_modpath("hunger")
	dofile(modpath .. "/functions.lua")
	dofile(modpath .. "/food.lua")

	hud.register("hunger", {
		hud_elem_type = "statbar",
		position      = {x = 0.5, y = 1},
		alignment     = {x = -1,  y = -1},
		offset        = {x = 8,   y = -108},
		size          = {x = 24,  y = 24},
		text          = "hunger_statbar_fg.png",
		background    = "hunger_statbar_bg.png",
		number        = 20
	})

	minetest.register_on_joinplayer(function(player)
		minetest.after(0.5, function()
			local inv = player:get_inventory()
			if inv then
				inv:set_size("hunger", 1)

				local name = player:get_player_name()
				hunger.players[name] = {}
				hunger.players[name].lvl = hunger.read(player)
				hunger.players[name].exhaus = 0
				local lvl = hunger.players[name].lvl
				if lvl > 20 then
					lvl = 20
				end

				hud.change_item(player, "hunger", {number = lvl})
			end
		end)
	end)

	minetest.register_on_leaveplayer(function(player)
		local name = player:get_player_name()
		hunger.players[name] = nil
	end)

	-- for exhaustion
	minetest.register_on_placenode(hunger.handle_node_actions)
	minetest.register_on_dignode(hunger.handle_node_actions)
	minetest.register_on_respawnplayer(function(player)
		hunger.update_hunger(player, 20)
 	end)
end
