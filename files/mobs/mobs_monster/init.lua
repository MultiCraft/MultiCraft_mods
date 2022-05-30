mobs_monster = {
	S = minetest.get_translator_auto(true)
}

mobs_monster.spawn_nodes = {
	"default:sandstone", "default:redsandstone",
	"default:ice", "default:snow", "default:snowblock",
	"group:sand", "group:soil", "group:stone"
}

local path = minetest.get_modpath("mobs_monster")
local monsters = {
	"skeleton", "spider", "zombie"
}

for _, name in ipairs(monsters) do
	dofile(path .. "/" .. name .. ".lua")
end
