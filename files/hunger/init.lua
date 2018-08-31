hunger = {}
hunger.players = {}
hunger.food = {}

HUNGER_TICK = 600 -- time in seconds after that 1 hunger point is taken
HUNGER_HEALTH_TICK = 4 -- time in seconds after player gets healed/damaged
HUNGER_MOVE_TICK = 0.5 -- time in seconds after the movement is checked

HUNGER_EXHAUST_DIG = 3 -- exhaustion increased this value after digged node
HUNGER_EXHAUST_PLACE = 1 -- exhaustion increased this value after placed
HUNGER_EXHAUST_MOVE = 1.5 -- exhaustion increased this value if player movement detected
HUNGER_EXHAUST_LVL = 160 -- at what exhaustion player saturation gets lowered

HUNGER_HEAL = 1 -- number of HP player gets healed after HUNGER_HEALTH_TICK
HUNGER_HEAL_LVL = 15 -- lower level of saturation needed to get healed
HUNGER_STARVE = 1 -- number of HP player gets damaged by hunger after HUNGER_HEALTH_TICK
HUNGER_STARVE_LVL = 3 -- level of staturation that causes starving

HUNGER_MAX = 30 -- maximum level of saturation


local modpath = minetest.get_modpath("hunger")
dofile(modpath .. "/functions.lua")
dofile(modpath .. "/food.lua")

-- legacy functions
hud.item_eat = hunger.item_eat
hud.set_hunger = hunger.save
hud.get_hunger = hunger.load
hud.save_hunger = hunger.save
hud.load_hunger = hunger.load

-- Callbacks
if minetest.settings:get_bool("enable_damage") then

	minetest.register_on_joinplayer(function(player)
		minetest.after(1, function()
			local inv = player:get_inventory()
			inv:set_size("hunger", 1)

			local name = player:get_player_name()
			hunger.players[name] = {}
			hunger.players[name].lvl = hunger.read(player)
			hunger.players[name].exhaus = 0
			local lvl = hunger.players[name].lvl
			if lvl > 20 then
				lvl = 20
			end

			hud.swap_statbar(player, "hunger", "air")
			hud.change_item(player, "hunger", {number = lvl, max = 20})
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
