-- mods/default/tools.lua

--
-- Picks
--

minetest.register_tool("default:pick_wood", {
	description = "Wooden Pickaxe",
	inventory_image = "default_tool_woodpick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {
			cracky = {times = {[3]=2.50}, uses = 20, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_stone", {
	description = "Stone Pickaxe",
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
	description = "Steel Pickaxe",
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
	description = "Gold Pickaxe",
	inventory_image = "default_tool_goldpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps = {
			cracky = {times = {[1]=2.4, [2]=1.8, [3]=1.5}, uses = 40, maxlevel = 3}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:pick_diamond", {
	description = "Diamond Pickaxe",
	inventory_image = "default_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps = {
			cracky = {times = {[1]=2.0, [2]=1.5, [3]=1.0}, uses = 60, maxlevel = 3}
		},
		damage_groups = {fleshy = 5}
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Shovels
--

minetest.register_tool("default:shovel_wood", {
	description = "Wooden Shovel",
	inventory_image = "default_tool_woodshovel.png",
	wield_image = "default_tool_woodshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1]=3.0, [2]=2.5, [3]=2.0}, uses = 20, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_stone", {
	description = "Stone Shovel",
	inventory_image = "default_tool_stoneshovel.png",
	wield_image = "default_tool_stoneshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1]=2.0, [2]=1.75, [3]=2.0}, uses = 40, maxlevel = 1}
		},
		damage_groups = {fleshy = 2}
	},
	sound = {breaks = "default_tool_breaks"}
})
minetest.register_tool("default:shovel_steel", {
	description = "Steel Shovel",
	inventory_image = "default_tool_steelshovel.png",
	wield_image = "default_tool_steelshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1]=1.80, [2]=1.50, [3]=1.75}, uses = 60, maxlevel = 2}
		},
		damage_groups = {fleshy = 3}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_gold", {
	description = "Gold Shovel",
	inventory_image = "default_tool_goldshovel.png",
	wield_image = "default_tool_goldshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps = {
			crumbly = {times = {[1]=1.50, [2]=1.20, [3]=1.5}, uses = 40, maxlevel = 3}
		},
		damage_groups = {fleshy = 3}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:shovel_diamond", {
	description = "Diamond Shovel",
	inventory_image = "default_tool_diamondshovel.png",
	wield_image = "default_tool_diamondshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1]=1.30, [2]=1.5, [3]=1.0}, uses = 60, maxlevel = 3}
		},
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Axes
--

minetest.register_tool("default:axe_wood", {
	description = "Wooden Axe",
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
	description = "Stone Axe",
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
	description = "Steel Axe",
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
	description = "Gold Axe",
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
	description = "Diamond Axe",
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

--
-- Swords
--

minetest.register_tool("default:sword_wood", {
	description = "Wooden Sword",
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
	description = "Stone Sword",
	inventory_image = "default_tool_stonesword.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		damage_groups = {fleshy = 4}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_steel", {
	description = "Steel Sword",
	inventory_image = "default_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		damage_groups = {fleshy = 6}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_gold", {
	description = "Gold Sword",
	inventory_image = "default_tool_goldsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 1,
		damage_groups = {fleshy = 7}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_tool("default:sword_diamond", {
	description = "Diamond Sword",
	inventory_image = "default_tool_diamondsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 1,
		damage_groups = {fleshy = 8}
	},
	sound = {breaks = "default_tool_breaks"}
})

--
-- Fishing Pole
--

minetest.register_tool("default:pole", {
	description = "Fishing Pole",
	inventory_image = "default_tool_fishing_pole.png",
	groups = {flammable = 2},
	liquids_pointable = true,
	sound = {breaks = "default_tool_breaks"},
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing and pointed_thing.under then
			local node = minetest.get_node(pointed_thing.under)
			if string.find(node.name, "water_source") then
				if math.random(8) == 8 then
					local inv = user:get_inventory()
					if inv:room_for_item("main", "default:fish_raw") then
						inv:add_item("main", "default:fish_raw")
					end
				end
				itemstack:add_wear(65535/65) -- 65 uses
				return itemstack
			end
		end
		return
	end
})
