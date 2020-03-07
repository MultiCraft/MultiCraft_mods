dungeon_loot.registered_loot = {
	-- buckets
	{name = "bucket:bucket_empty", chance = 0.55},
	-- water in deserts or above ground, lava otherwise
	{name = "bucket:bucket_water", chance = 0.45, types = {"sandstone", "desert"}},
	{name = "bucket:bucket_water", chance = 0.45, y = {0, 256}, types = {"normal"}},
	{name = "bucket:bucket_lava", chance = 0.45, y = {-64, -1}, types = {"normal"}},

	-- various items
	{name = "default:stick", chance = 0.6, count = {3, 6}},
	{name = "default:flint", chance = 0.4, count = {1, 3}},
	{name = "vessels:glass_bottle", chance = 0.35, count = {1, 4}},
	{name = "carts:rail", chance = 0.35, count = {1, 6}},

	-- farming / consumable
	{name = "farming:string", chance = 0.5, count = {1, 8}},
	{name = "farming:wheat", chance = 0.5, count = {2, 5}},
	{name = "farming_addons:seed_carrot", chance = 0.5, count = {2, 4}},
	{name = "farming_addons:cocoa", chance = 0.5, count = {2, 4}},
	{name = "farming_addons:corn", chance = 0.5, count = {1, 2}},
	{name = "farming_addons:melon", chance = 0.5, count = {1, 2}},
	{name = "farming_addons:seed_potato", chance = 0.5, count = {2, 4}},
	{name = "farming_addons:pumpkin", chance = 0.5, count = {1, 2}},
	{name = "default:apple", chance = 0.4, count = {1, 4}},
	{name = "default:cactus", chance = 0.4, count = {1, 4}, types = {"sandstone", "desert"}},

	-- trees sappling

	{name = "default:sapling", chance = 0.5, count = {1, 2}},
	{name = "default:pine_sapling", chance = 0.5, count = {1, 2}},
	{name = "default:junglesapling", chance = 0.5, count = {1, 2}},
	{name = "default:acacia_sapling", chance = 0.5, count = {1, 2}},

	-- minerals
	{name = "default:coal_lump", chance = 0.9, count = {1, 12}},
	{name = "default:gold_ingot", chance = 0.5},
	{name = "default:steel_ingot", chance = 0.4, count = {1, 6}},
	{name = "default:diamond", chance = 0.15, count = {1, 2}},
	{name = "default:emerald", chance = 0.1, count = {1, 2}},

	-- tools
	{name = "default:sword_steel", chance = 0.6},
	{name = "default:sword_gold", chance = 0.3},
	{name = "default:sword_diamond", chance = 0.05},

	{name = "default:pick_steel", chance = 0.3},
	{name = "default:pick_gold", chance = 0.2},
	{name = "default:pick_diamond", chance = 0.05},

	{name = "default:shovel_steel", chance = 0.3},
	{name = "default:shovel_gold", chance = 0.2},
	{name = "default:shovel_diamond", chance = 0.05},

	{name = "default:axe_steel", chance = 0.4},
	{name = "default:axe_gold", chance = 0.2},
	{name = "default:axe_diamond", chance = 0.05},

	-- natural materials
	{name = "default:sand", chance = 0.8, count = {4, 32}, y = {-64, 256}, types = {"normal"}},
	{name = "default:sandstonesmooth", chance = 0.8, count = {4, 32}, y = {-64, 256}, types = {"sandstone"}},
	{name = "default:mossycobble", chance = 0.8, count = {4, 32}, types = {"desert"}},
	{name = "default:dirt", chance = 0.6, count = {2, 16}, y = {-64, 256}},
	{name = "default:obsidian", chance = 0.25, count = {1, 3}, y = {-32, -64}},

	-- ruby
	{name = "default:ruby", chance = 0.2, count = {1, 2}}
}

function dungeon_loot.register(t)
	if t.name ~= nil then
		t = {t} -- single entry
	end
	for _, loot in ipairs(t) do
		table.insert(dungeon_loot.registered_loot, loot)
	end
end

function dungeon_loot._internal_get_loot(pos_y, dungeontype)
	-- filter by y pos and type
	local ret = {}
	for _, l in ipairs(dungeon_loot.registered_loot) do
		if l.y == nil or (pos_y >= l.y[1] and pos_y <= l.y[2]) then
			if l.types == nil or table.indexof(l.types, dungeontype) ~= -1 then
				table.insert(ret, l)
			end
		end
	end
	return ret
end
