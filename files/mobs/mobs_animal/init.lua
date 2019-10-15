mobs_animal = {}

mobs_animal.spawn_nodes = {
	"default:dirt", "default:sand", "default:redsand",
	"default:snow", "default:snowblock",
	"default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"
}

local path = minetest.get_modpath("mobs_animal")
local name = {
	"bear", "bunny", "dog",
	"kitten", "pig", "sheep"
}

for _, name in pairs(name) do
	dofile(path .. "/" .. name .. ".lua")
end
