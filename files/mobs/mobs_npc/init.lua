mobs_npc = {}

local translator = minetest.get_translator
mobs_npc.S = translator and translator("mobs_npc") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		mobs_npc.S = intllib.make_gettext_pair()
	end
end

-- Compatible for MultiCraft Engine 2.0
mobs_npc.cbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35}
if minetest.features and minetest.features.object_independent_selectionbox then
	mobs_npc.cbox = {-0.35, 0, -0.35, 0.35, 1.8, 0.35}
end

local path = minetest.get_modpath("mobs_npc")
local npc = {"npc", "trader"}

for _, name in pairs(npc) do
	dofile(path .. "/" .. name .. ".lua")
end
