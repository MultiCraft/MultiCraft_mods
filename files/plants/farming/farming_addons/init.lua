farming_addons = {
	S = minetest.get_translator("farming_addons")
}

local path = minetest.get_modpath("farming_addons")
local farming = {
	"api", "seeds",
	"cocoa", "watermelon", "pumpkin"
}

for _, name in ipairs(farming) do
	dofile(path .. "/" .. name .. ".lua")
end

minetest.after(1, function()
	-- Add bonemeal support
	if minetest.global_exists("bonemeal") then
		bonemeal.add_crop({
			{"farming_addons:cocoa_", 3, "farming_addons:seed_cocoa"},
			{"farming_addons:melon_", 8, "farming_addons:seed_melon"},
			{"farming_addons:pumpkin_", 8, "farming_addons:seed_pumpkin"}
		})
	end
end)

-- Register dungeon loot
if minetest.global_exists("dungeon_loot") then
	dungeon_loot.register({
		{name = "farming_addons:cocoa_bean", chance = 0.5, count = {2, 4}},
		{name = "farming_addons:seed_melon", chance = 0.5, count = {1, 2}},
		{name = "farming_addons:seed_pumpkin", chance = 0.5, count = {1, 2}}
	})
end
