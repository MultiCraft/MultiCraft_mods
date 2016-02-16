-- "Dungeon Loot" [dungeon_loot]
-- Original by BlockMen, this entire file by Amoeba
--
-- config.lua
--
-- Note: All positive heights (above water level) are treated as depth 0.
-- Also, no comma after the item of a list.

-- Minimum number of rooms a dungeon should have for a chest to be generated
dungeon_loot.min_num_of_rooms = 4
-- Items on basic lists have three depth ranges for their listed amount 
-- maximums; they get max/2 before first increase point (minimum of 1 if 
-- amount is >0), the given max between the 1st and 2nd increase point, 
-- and max*2 after the 2nd.
dungeon_loot.depth_first_basic_increase = 200
dungeon_loot.depth_second_basic_increase = 2000

-- The master list of loot types
-- Note that tools and weapons should always have max_amount = 1.
-- Chance is a probability between 0 (practically never) and 1 (always),
-- so change a chance to 0 if you don't want a type (eg. weapons) included 
-- in your game (or -0.001 if you want to be REALLY sure). 
dungeon_loot.loot_types = { 
	{name="treasure", max_amount = 10, chance = 0.7, type = "depth_cutoff"},
	{name="tools", max_amount = 1, chance = 0.5, type = "depth_cutoff"},
	{name="weapons", max_amount = 1, chance = 0.1, type = "depth_cutoff"},
	{name="consumables", max_amount = 80, chance = 0.9, type = "basic_list"},
	{name="seedlings", max_amount = 5, chance = 0.3, type = "basic_list"}
}

-- Loot type lists; these names MUST be exactly of the format:
-- "dungeon_loot.name_list" where "name" is in the above list

-- Depth cutoff lists
-- These must be in order of increasing depth (but can include the same item
-- more than once).  Method: a random number between 1 and chest depth is 
-- chosen, and the item in that range is added to the loot.  Then, there's 
-- a chance additional items of the same type are added to stack; if the 
-- random number is much greater than the item's min_depth, the amount 
-- can grow pretty big.
dungeon_loot.treasure_list = {
	{name="default:steel_ingot", min_depth = 0},
	{name="default:bronze_ingot", min_depth = 20},
	{name="default:gold_ingot", min_depth = 45},
	{name="default:diamond", min_depth = 150},
	{name="default:gold_block", min_depth = 777},
	{name="default:emerald", min_depth = 800},
	{name="default:diamond_block", min_depth = 1800},
	{name="default:emerald", min_depth = 2000}
}

dungeon_loot.tools_list = {
	{name="default:pick_steel", min_depth = 0},
	{name="default:shovel_diamond", min_depth = 38},
	{name="default:pick_bronze", min_depth = 40},
	{name="default:axe_diamond", min_depth = 95},
	{name="default:pick_diamond", min_depth = 100}
}

dungeon_loot.weapons_list = {
	{name="default:sword_steel", min_depth = 0},
	{name="default:sword_bronze", min_depth = 50},
	{name="default:sword_diamond", min_depth = 250}
}


-- Basic lists
-- These can be of two types, either with combined chance and amount, 
-- or with the two variables separated.  "chance" means each item has a 
-- N/M chance of being chosen, where N is it's own chance and M is the 
-- total sum of chances on the list.  "amount" is the maximum amount of
-- items given at the middle depth range.
dungeon_loot.consumables_list = {
	{name="default:apple", chance_and_amount = 20},
	{name="default:torch", chance_and_amount = 30},
	{name="default:stick", chance_and_amount = 10}
}

dungeon_loot.seedlings_list = {
	{name="default:sapling", chance = 5, amount = 2},
	{name="default:pine_sapling", chance = 10, amount = 2},
	{name="default:junglesapling", chance = 15, amount = 2},
	{name="default:acacia_sapling", chance = 15, amount = 2}
}

-- Add items from other mods here inside the appropriate 
-- "if ... then ... end" test
-- For basic lists, just using insert without a value works fine.
-- For depth cutoff lists, you can use insert with a table index, eg.
--   table.insert(dungeon_loot.treasure_list, 5, {name="your_mod:platinum_ingot", min_depth = 120}
-- The above would add a new item to the treasure list as the 5th item,
-- moving diamond and all below it one down in the list.  Just make sure 
-- that the increasing min_depth order is kept.  
-- Tips: With multiple insertions in a depth cutoff list, start from the 
-- last item and work towards the beginning, then you don't have to calculate
-- your number of additions.  Also, trying to make sure too many different 
-- mods work together in a single list will probably give you a headache;
-- just create a new list (or two) for mods with lots of additions. 

if minetest.get_modpath("farming") then
 	table.insert(dungeon_loot.consumables_list, {name="farming:bread", chance_and_amount = 10})
 	table.insert(dungeon_loot.seedlings_list, {name="farming:seed_wheat", chance = 1, amount = 10})
 	table.insert(dungeon_loot.seedlings_list, {name="farming:seed_cotton", chance = 20, amount = 5})
end
