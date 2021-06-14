farming_addons = {}

local translator = minetest.get_translator
farming_addons.S = translator and translator("farming") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		farming_addons.S = intllib.make_gettext_pair()
	end
end

local path = minetest.get_modpath("farming_addons")
local farming = {
	"api", "seeds",
	"carrot", "cocoa",
	"watermelon", "pumpkin"
}

for _, name in pairs(farming) do
	dofile(path .. "/" .. name .. ".lua")
end

minetest.after(1, function()
	-- Add bonemeal support
	if minetest.global_exists("bonemeal") then
		bonemeal.add_crop({
			{"farming_addons:carrot_", 4, "farming_addons:seed_carrot"},
			{"farming_addons:cocoa_", 3, "farming_addons:seed_cocoa"},
			{"farming_addons:melon_", 8, "farming_addons:seed_melon"},
			{"farming_addons:pumpkin_", 8, "farming_addons:seed_pumpkin"}
		})
	end
end)

-- Register dungeon loot
if minetest.global_exists("dungeon_loot") then
	dungeon_loot.register({
		{name = "farming_addons:seed_carrot", chance = 0.5, count = {2, 4}},
		{name = "farming_addons:cocoa_3", chance = 0.5, count = {2, 4}},
		{name = "farming_addons:seed_melon", chance = 0.5, count = {1, 2}},
		{name = "farming_addons:seed_pumpkin", chance = 0.5, count = {1, 2}}
	})
end
