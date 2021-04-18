local S = default.S
local C = default.colors

--
-- Picks
--

minetest.register_tool("default:pick_wood", {
	description = S("Wooden Pickaxe"),
	inventory_image = "default_tool_woodpick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {
			cracky = {times = {[3]=2.5}, uses = 20, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_stone", {
	description = S("Stone Pickaxe"),
	inventory_image = "default_tool_stonepick.png",
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level = 0,
		groupcaps = {
			cracky = {times = {[2]=2.5, [3]=2.0}, uses = 40, maxlevel = 1}
		},
		damage_groups = {fleshy = 3}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_steel", {
	description = S("Steel Pickaxe"),
	inventory_image = "default_tool_steelpick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			cracky = {times = {[1]=4.0, [2]=2.0, [3]=1.75}, uses = 40, maxlevel = 2}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_gold", {
	description = S("Gold Pickaxe"),
	inventory_image = "default_tool_goldpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 3,
		groupcaps = {
			cracky = {times = {[1]=2.4, [2]=1.8, [3]=1.5}, uses = 40, maxlevel = 3}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_diamond", {
	description = S("Diamond Pickaxe"),
	inventory_image = "default_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 3,
		groupcaps = {
			cracky = {times = {[1]=2.0, [2]=1.5, [3]=1.0}, uses = 60, maxlevel = 3}
		},
		damage_groups = {fleshy = 5}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_emerald", {
	description = C.emerald .. S("Emerald Pickaxe"),
	inventory_image = "default_tool_emeraldpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 3,
		groupcaps = {
			cracky = {times = {[1]=2.0, [2]=1.5, [3]=1.0}, uses = 80, maxlevel = 3}
		},
		damage_groups = {fleshy = 5}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_ruby", {
	description = C.ruby .. S("Ruby Pickaxe"),
	inventory_image = "default_tool_rubypick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 3,
		groupcaps = {
			cracky = {times = {[1]=2.3, [2]=1.7, [3]=1.4}, uses = 0, maxlevel = 3}
		},
		damage_groups = {fleshy = 5},
		punch_attack_uses = 0
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Shovels
--

minetest.register_tool("default:shovel_wood", {
	description = S("Wooden Shovel"),
	inventory_image = "default_tool_woodshovel.png",
	wield_image = "default_tool_woodshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1]=3.0, [2]=2.5, [3]=1.5}, uses = 20, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_stone", {
	description = S("Stone Shovel"),
	inventory_image = "default_tool_stoneshovel.png",
	wield_image = "default_tool_stoneshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1]=2.0, [2]=1.75, [3]=1.25}, uses = 40, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_steel", {
	description = S("Steel Shovel"),
	inventory_image = "default_tool_steelshovel.png",
	wield_image = "default_tool_steelshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1]=1.8, [2]=1.5, [3]=1.1}, uses = 60, maxlevel = 2}
		},
		damage_groups = {fleshy = 3}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_gold", {
	description = S("Gold Shovel"),
	inventory_image = "default_tool_goldshovel.png",
	wield_image = "default_tool_goldshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 3,
		groupcaps = {
			crumbly = {times = {[1]=1.5, [2]=1.2, [3]=1.0}, uses = 40, maxlevel = 3}
		},
		damage_groups = {fleshy = 3}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_diamond", {
	description = S("Diamond Shovel"),
	inventory_image = "default_tool_diamondshovel.png",
	wield_image = "default_tool_diamondshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1]=1.3, [2]=1.0, [3]=0.9}, uses = 60, maxlevel = 3}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_emerald", {
	description = C.emerald .. S("Emerald Shovel"),
	inventory_image = "default_tool_emeraldshovel.png",
	wield_image = "default_tool_emeraldshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1]=1.3, [2]=1.0, [3]=0.9}, uses = 80, maxlevel = 3}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_ruby", {
	description = C.ruby .. S("Ruby Shovel"),
	inventory_image = "default_tool_rubyshovel.png",
	wield_image = "default_tool_rubyshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1]=1.4, [2]=1.1, [3]=1.0}, uses = 0, maxlevel = 3}
		},
		damage_groups = {fleshy = 4},
		punch_attack_uses = 0
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Axes
--

minetest.register_tool("default:axe_wood", {
	description = S("Wooden Axe"),
	inventory_image = "default_tool_woodaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			choppy = {times = {[2]=4.0, [3]=3.0}, uses = 20, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:axe_stone", {
	description = S("Stone Axe"),
	inventory_image = "default_tool_stoneaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {
			choppy={times = {[1]=3.5, [2]=2.5, [3]=1.75}, uses = 40, maxlevel = 1}
		},
		damage_groups = {fleshy = 3}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:axe_steel", {
	description = S("Steel Axe"),
	inventory_image = "default_tool_steelaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			choppy = {times = {[1]=3.25, [2]=2.0, [3]=1.5}, uses = 40, maxlevel = 2}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:axe_gold", {
	description = S("Gold Axe"),
	inventory_image = "default_tool_goldaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			choppy={times = {[1]=3.0, [2]=1.75, [3]=1.25}, uses = 40, maxlevel = 3}
		},
		damage_groups = {fleshy = 5}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:axe_diamond", {
	description = S("Diamond Axe"),
	inventory_image = "default_tool_diamondaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			choppy={times = {[1]=2.5, [2]=1.5, [3]=1.0}, uses = 60, maxlevel = 3}
		},
		damage_groups = {fleshy = 6}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:axe_emerald", {
	description = C.emerald .. S("Emerald Axe"),
	inventory_image = "default_tool_emeraldaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			choppy={times = {[1]=2.5, [2]=1.5, [3]=1.0}, uses = 80, maxlevel = 3}
		},
		damage_groups = {fleshy = 6}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:axe_ruby", {
	description = C.ruby .. S("Ruby Axe"),
	inventory_image = "default_tool_rubyaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			choppy={times = {[1]=2.9, [2]=1.65, [3]=1.15}, uses = 0, maxlevel = 3}
		},
		damage_groups = {fleshy = 6},
		punch_attack_uses = 0
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Swords
--

minetest.register_tool("default:sword_wood", {
	description = S("Wooden Sword"),
	inventory_image = "default_tool_woodsword.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level = 0,
		damage_groups = {fleshy = 3}
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_stone", {
	description = S("Stone Sword"),
	inventory_image = "default_tool_stonesword.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_steel", {
	description = S("Steel Sword"),
	inventory_image = "default_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		damage_groups = {fleshy = 6}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_gold", {
	description = S("Gold Sword"),
	inventory_image = "default_tool_goldsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 1,
		damage_groups = {fleshy = 7}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_diamond", {
	description = S("Diamond Sword"),
	inventory_image = "default_tool_diamondsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 1,
		damage_groups = {fleshy = 8}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_emerald", {
	description = C.emerald .. S("Emerald Sword"),
	inventory_image = "default_tool_emeraldsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 1,
		damage_groups = {fleshy = 8}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_ruby", {
	description = C.ruby .. S("Ruby Sword"),
	inventory_image = "default_tool_rubysword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 1,
		damage_groups = {fleshy = 7},
		punch_attack_uses = 0
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Register Craft Recipies
--

local craft_ingreds = {
	wood = "group:wood",
	stone = "group:stone",
	steel = "default:steel_ingot",
	gold = "default:gold_ingot",
	diamond = "default:diamond",
	emerald = "default:emerald",
	ruby = "default:ruby"
}

for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:pick_" .. name,
		recipe = {
			{mat, mat, mat},
			{"", "default:stick", ""},
			{"", "default:stick", ""}
		}
	})

	minetest.register_craft({
		output = "default:shovel_" .. name,
		recipe = {
			{mat},
			{"default:stick"},
			{"default:stick"}
		}
	})

	minetest.register_craft({
		output = "default:axe_" .. name,
		recipe = {
			{mat, mat},
			{mat, "default:stick"},
			{"", "default:stick"}
		}
	})

	minetest.register_craft({
		output = "default:sword_" .. name,
		recipe = {
			{mat},
			{mat},
			{"default:stick"}
		}
	})
end

--
-- Fuel
--

local wood_tool_fuel = {
	pick = 6,
	shovel = 4,
	axe = 6,
	sword = 5
}

for tool, burn in pairs(wood_tool_fuel) do
	minetest.register_craft({
		type = "fuel",
		recipe = "default:" .. tool .. "_wood",
		burntime = burn
	})
end
