mobs_animal = {
	S = minetest.get_translator_auto(true)
}

mobs_animal.spawn_nodes = {
	"default:dirt", "default:sand", "default:redsand",
	"default:snow", "default:snowblock",
	"default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"
}

local path = minetest.get_modpath("mobs_animal")
local name = {"dog", "kitten", "pig"}

for _, mob in ipairs(name) do
	dofile(path .. "/" .. mob .. ".lua")
end
