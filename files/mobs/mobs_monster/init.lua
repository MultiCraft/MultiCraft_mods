mobs_monster = {}

local translator = minetest.get_translator
mobs_monster.S = translator and translator("mobs_monster") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		mobs_monster.S = intllib.make_gettext_pair()
	end
end

mobs_monster.spawn_nodes = {
	"default:dirt", "default:sandstone", "default:stone",
	"default:sand", "default:redsand",
	"default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass",
	"default:cobble", "default:mossycobble"
}

local path = minetest.get_modpath("mobs_monster")
local monsters = {
	"skeleton", "spider", "zombie"
}

for _, name in pairs(monsters) do
	dofile(path .. "/" .. name .. ".lua")
end
