mobs_animal = {}

local translator = minetest.get_translator
mobs_animal.S = translator and translator("mobs_animal") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		mobs_animal.S = intllib.make_gettext_pair()
	end
end

mobs_animal.spawn_nodes = {
	"default:dirt", "default:sand", "default:redsand",
	"default:snow", "default:snowblock",
	"default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"
}

local path = minetest.get_modpath("mobs_animal")
local name = {
	"bunny", "dog", "kitten", "pig"
}

for _, mob in pairs(name) do
	dofile(path .. "/" .. mob .. ".lua")
end
