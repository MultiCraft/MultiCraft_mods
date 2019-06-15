local register_food = hunger.register_food

if minetest.get_modpath("flowers") then
		register_food("flowers:mushroom_red", 1, "", 3)
end

if minetest.get_modpath("mobs") then
	if mobs.mod ~= nil and mobs.mod == "redo" then
		register_food("mobs:meat_raw", 4, "", 3)
		register_food("mobs:pork_raw", 3, "", 3)
		register_food("mobs:chicken_raw", 2, "", 3)
		register_food("mobs:rabbit_raw", 2, "", 3)
		register_food("mobs_monster:rotten_flesh", 1, "", 4)
	end
end
