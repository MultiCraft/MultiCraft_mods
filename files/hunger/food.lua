local register_food = hunger.register_food

register_food("default:apple", 2)

if minetest.get_modpath("farming") ~= nil then
	register_food("farming:bread", 4)
end

if minetest.get_modpath("flowers") ~= nil then
		register_food("flowers:mushroom_brown", 1)
		register_food("flowers:mushroom_red", 1, "", 3)
end

if minetest.get_modpath("mobs") ~= nil then
	if mobs.mod ~= nil and mobs.mod == "redo" then
		register_food("mobs:cheese", 4)
		register_food("mobs:meat", 8)
		register_food("mobs:meat_raw", 4, "", 3)
		register_food("mobs:rat_cooked", 4)
		register_food("mobs:rat_meat", 2)
		register_food("mobs:honey", 2)
		register_food("mobs:pork_raw", 3, "", 3)
		register_food("mobs:pork_cooked", 8)
		register_food("mobs:chicken_cooked", 6)
		register_food("mobs:chicken_raw", 2, "", 3)
		register_food("mobs:chicken_egg_fried", 2)
		if minetest.get_modpath("bucket") then
			register_food("mobs:bucket_milk", 3, "bucket:bucket_empty")
		end
	else
		register_food("mobs:meat", 6)
		register_food("mobs:meat_raw", 3)
		register_food("mobs:rat_cooked", 5)
	end
end

if minetest.get_modpath("moretrees") ~= nil then
	register_food("moretrees:coconut_milk", 1)
	register_food("moretrees:raw_coconut", 2)
	register_food("moretrees:acorn_muffin", 3)
	register_food("moretrees:spruce_nuts", 1)
	register_food("moretrees:pine_nuts", 1)
	register_food("moretrees:fir_nuts", 1)
end

if minetest.get_modpath("dwarves") ~= nil then
	register_food("dwarves:beer", 2)
	register_food("dwarves:apple_cider", 1)
	register_food("dwarves:midus", 2)
	register_food("dwarves:tequila", 2)
	register_food("dwarves:tequila_with_lime", 2)
	register_food("dwarves:sake", 2)
end

if minetest.get_modpath("animalmaterials") ~= nil then
	register_food("animalmaterials:milk", 2)
	register_food("animalmaterials:meat_raw", 3)
	register_food("animalmaterials:meat_pork", 3)
	register_food("animalmaterials:meat_beef", 3)
	register_food("animalmaterials:meat_chicken", 3)
	register_food("animalmaterials:meat_lamb", 3)
	register_food("animalmaterials:meat_venison", 3)
	register_food("animalmaterials:meat_undead", 3, "", 3)
	register_food("animalmaterials:meat_toxic", 3, "", 5)
	register_food("animalmaterials:meat_ostrich", 3)
	register_food("animalmaterials:fish_bluewhite", 2)
	register_food("animalmaterials:fish_clownfish", 2)
end

if minetest.get_modpath("fishing") ~= nil then
	register_food("fishing:fish_raw", 2)
	register_food("fishing:fish_cooked", 5)
	register_food("fishing:sushi", 6)
	register_food("fishing:shark", 4)
	register_food("fishing:shark_cooked", 8)
	register_food("fishing:pike", 4)
	register_food("fishing:pike_cooked", 8)
end

if minetest.get_modpath("glooptest") ~= nil then
	register_food("glooptest:kalite_lump", 1)
end

if minetest.get_modpath("bushes") ~= nil then
	register_food("bushes:sugar", 1)
	register_food("bushes:strawberry", 2)
	register_food("bushes:berry_pie_raw", 3)
	register_food("bushes:berry_pie_cooked", 4)
	register_food("bushes:basket_pies", 15)
end

if minetest.get_modpath("bushes_classic") then
	-- bushes_classic mod, as found in the plantlife modpack
	local berries = {
	    "strawberry",
		"blackberry",
		"blueberry",
		"raspberry",
		"gooseberry",
		"mixed_berry"}
	for _, berry in ipairs(berries) do
		if berry ~= "mixed_berry" then
			register_food("bushes:"..berry, 1)
		end
		register_food("bushes:"..berry.."_pie_raw", 2)
		register_food("bushes:"..berry.."_pie_cooked", 5)
		register_food("bushes:basket_"..berry, 15)
	end
end

if minetest.get_modpath("mushroom") ~= nil then
	register_food("mushroom:brown", 1)
	register_food("mushroom:red", 1, "", 3)
	-- mushroom potions: red = strong poison, brown = light restorative
	if minetest.get_modpath("vessels") then
		register_food("mushroom:brown_essence", 1, "vessels:glass_bottle", nil, 4)
		register_food("mushroom:poison", 1, "vessels:glass_bottle", 10)
	end
end

if minetest.get_modpath("docfarming") ~= nil then
	register_food("docfarming:carrot", 3)
	register_food("docfarming:cucumber", 2)
	register_food("docfarming:corn", 3)
	register_food("docfarming:potato", 4)
	register_food("docfarming:bakedpotato", 5)
	register_food("docfarming:raspberry", 3)
end

if minetest.get_modpath("farming_plus") ~= nil then
	register_food("farming_plus:carrot_item", 3)
	register_food("farming_plus:banana", 2)
	register_food("farming_plus:orange_item", 2)
	register_food("farming:pumpkin_bread", 4)
	register_food("farming_plus:strawberry_item", 2)
	register_food("farming_plus:tomato_item", 2)
	register_food("farming_plus:potato_item", 4)
	register_food("farming_plus:rhubarb_item", 2)
end

if minetest.get_modpath("mtfoods") ~= nil then
	register_food("mtfoods:dandelion_milk", 1)
	register_food("mtfoods:sugar", 1)
	register_food("mtfoods:short_bread", 4)
	register_food("mtfoods:cream", 1)
	register_food("mtfoods:chocolate", 2)
	register_food("mtfoods:cupcake", 2)
	register_food("mtfoods:strawberry_shortcake", 2)
	register_food("mtfoods:cake", 3)
	register_food("mtfoods:chocolate_cake", 3)
	register_food("mtfoods:carrot_cake", 3)
	register_food("mtfoods:pie_crust", 3)
	register_food("mtfoods:apple_pie", 3)
	register_food("mtfoods:rhubarb_pie", 2)
	register_food("mtfoods:banana_pie", 3)
	register_food("mtfoods:pumpkin_pie", 3)
	register_food("mtfoods:cookies", 2)
	register_food("mtfoods:mlt_burger", 5)
	register_food("mtfoods:potato_slices", 2)
	register_food("mtfoods:potato_chips", 3)
	--mtfoods:medicine
	register_food("mtfoods:casserole", 3)
	register_food("mtfoods:glass_flute", 2)
	register_food("mtfoods:orange_juice", 2)
	register_food("mtfoods:apple_juice", 2)
	register_food("mtfoods:apple_cider", 2)
	register_food("mtfoods:cider_rack", 2)
end

if minetest.get_modpath("fruit") ~= nil then
	register_food("fruit:apple", 2)
	register_food("fruit:pear", 2)
	register_food("fruit:bananna", 3)
	register_food("fruit:orange", 2)
end

if minetest.get_modpath("mush45") ~= nil then
	register_food("mush45:meal", 4)
end

if minetest.get_modpath("seaplants") ~= nil then
	register_food("seaplants:kelpgreen", 1)
	register_food("seaplants:kelpbrown", 1)
	register_food("seaplants:seagrassgreen", 1)
	register_food("seaplants:seagrassred", 1)
	register_food("seaplants:seasaladmix", 6)
	register_food("seaplants:kelpgreensalad", 1)
	register_food("seaplants:kelpbrownsalad", 1)
	register_food("seaplants:seagrassgreensalad", 1)
	register_food("seaplants:seagrassgreensalad", 1)
end

if minetest.get_modpath("mobfcooking") ~= nil then
	register_food("mobfcooking:cooked_pork", 6)
	register_food("mobfcooking:cooked_ostrich", 6)
	register_food("mobfcooking:cooked_beef", 6)
	register_food("mobfcooking:cooked_chicken", 6)
	register_food("mobfcooking:cooked_lamb", 6)
	register_food("mobfcooking:cooked_venison", 6)
	register_food("mobfcooking:cooked_fish", 6)
end

if minetest.get_modpath("creatures") ~= nil then
	register_food("creatures:meat", 6)
	register_food("creatures:flesh", 3)
	register_food("creatures:rotten_flesh", 3, "", 3)
end

if minetest.get_modpath("ethereal") then
	register_food("ethereal:strawberry", 1)
	register_food("ethereal:banana", 4)
	register_food("ethereal:pine_nuts", 1)
	register_food("ethereal:bamboo_sprout", 0, "", 3)
	register_food("ethereal:fern_tubers", 1)
	register_food("ethereal:banana_bread", 7)
	register_food("ethereal:mushroom_plant", 2)
	register_food("ethereal:coconut_slice", 2)
	register_food("ethereal:golden_apple", 4, "", nil, 10)
	register_food("ethereal:wild_onion_plant", 2)
	register_food("ethereal:mushroom_soup", 4, "ethereal:bowl")
	register_food("ethereal:mushroom_soup_cooked", 6, "ethereal:bowl")
	register_food("ethereal:hearty_stew", 6, "ethereal:bowl", 3)
	register_food("ethereal:hearty_stew_cooked", 10, "ethereal:bowl")
	if minetest.get_modpath("bucket") then
		register_food("ethereal:bucket_cactus", 2, "bucket:bucket_empty")
	end
	register_food("ethereal:fish_raw", 2)
	register_food("ethereal:fish_cooked", 5)
	register_food("ethereal:seaweed", 1)
	register_food("ethereal:yellowleaves", 1, "", nil, 1)
	register_food("ethereal:sashimi", 4)
end

if minetest.get_modpath("farming") and farming.mod == "redo" then
	register_food("farming:bread", 6)
	register_food("farming:potato", 1)
	register_food("farming:baked_potato", 6)
	register_food("farming:cucumber", 4)
	register_food("farming:tomato", 4)
	register_food("farming:carrot", 3)
	register_food("farming:carrot_gold", 6, "", nil, 8)
	register_food("farming:corn", 3)
	register_food("farming:corn_cob", 5)
	register_food("farming:melon_slice", 2)
	register_food("farming:pumpkin_slice", 1)
	register_food("farming:pumpkin_bread", 9)
	register_food("farming:coffee_cup", 2, "farming:drinking_cup")
	register_food("farming:coffee_cup_hot", 3, "farming:drinking_cup", nil, 2)
	register_food("farming:cookie", 2)
	register_food("farming:chocolate_dark", 3)
	register_food("farming:donut", 4)
	register_food("farming:donut_chocolate", 6)
	register_food("farming:donut_apple", 6)
	register_food("farming:raspberries", 1)
	register_food("farming:blueberries", 1)
	register_food("farming:muffin_blueberry", 4)
	if minetest.get_modpath("vessels") then
		register_food("farming:smoothie_raspberry", 2, "vessels:drinking_glass")
	end
	register_food("farming:rhubarb", 1)
	register_food("farming:rhubarb_pie", 6)
	register_food("farming:beans", 1)
end

if minetest.get_modpath("kpgmobs") ~= nil then
	register_food("kpgmobs:uley", 3)
	register_food("kpgmobs:meat", 6)
	register_food("kpgmobs:rat_cooked", 5)
	register_food("kpgmobs:med_cooked", 4)
  	if minetest.get_modpath("bucket") then
	   register_food("kpgmobs:bucket_milk", 4, "bucket:bucket_empty")
	end
end

if minetest.get_modpath("jkfarming") ~= nil then
	register_food("jkfarming:carrot", 3)
	register_food("jkfarming:corn", 3)
	register_food("jkfarming:melon_part", 2)
	register_food("jkfarming:cake", 3)
end

if minetest.get_modpath("jkanimals") ~= nil then
	register_food("jkanimals:meat", 6)
end

if minetest.get_modpath("jkwine") ~= nil then
	register_food("jkwine:grapes", 2)
	register_food("jkwine:winebottle", 1)
end

if minetest.get_modpath("cooking") ~= nil then
	register_food("cooking:meat_beef_cooked", 4)
	register_food("cooking:fish_bluewhite_cooked", 3)
	register_food("cooking:fish_clownfish_cooked", 1)
	register_food("cooking:meat_chicken_cooked", 2)
	register_food("cooking:meat_cooked", 2)
	register_food("cooking:meat_pork_cooked", 3)
	register_food("cooking:meat_toxic_cooked", -3)
	register_food("cooking:meat_venison_cooked", 3)
	register_food("cooking:meat_undead_cooked", 1)
end

-- ferns mod of plantlife_modpack
if minetest.get_modpath("ferns") ~= nil then
	register_food("ferns:fiddlehead", 1, "", 1)
	register_food("ferns:fiddlehead_roasted", 3)
	register_food("ferns:ferntuber_roasted", 3)
	register_food("ferns:horsetail_01", 1)
end

if minetest.get_modpath("pizza") ~= nil then
	register_food("pizza:pizza", 30, "", nil, 30)
	register_food("pizza:pizzaslice", 5, "", nil, 5)
end
