mobs_monster = {}

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
