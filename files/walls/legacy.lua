local directions = {
	{x = 1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = -1},
	{x = 0, y = -1, z = 0}
}

local function update_wall(pos)
	local oldnode = minetest.get_node(pos)
	local oldname = oldnode.name

	if minetest.get_item_group(oldname, "wall") == 0 then
		return
	end

	local sum = 0
	for i = 1, 4 do
		local dir = directions[i]
		local node = minetest.get_node({x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z})
		local def = minetest.registered_nodes[node.name]
		if def and def.walkable and def.groups.wall then
			sum = sum + 2 ^ (i - 1)
		end
	end

	local upnode = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
	if sum == 5 or sum == 10 then
		local def = minetest.registered_nodes[upnode.name]
		if def and def.walkable then
			sum = sum + 11
		end
	end

	if sum == 0 then
		sum = 15
	end

	if oldname:find("wallet:wallmossy") == 1 then
		minetest.add_node(pos, {name = "wallet:wallmossy" .. "_" .. sum})
	elseif oldname:find("wallet:wall") == 1 then
		minetest.add_node(pos, {name = "wallet:wall" .. "_" .. sum})
	end
end

local function update_wall_global(pos)
	for i = 1, 5 do
		local dir = directions[i]
		update_wall({x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z})
	end
end

local half_blocks = {
	{ 1/4,  -0.5, -3/16,  0.5,  5/16,  3/16},
	{-3/16, -0.5,  1/4,   3/16, 5/16,  0.5},
	{-0.5,  -0.5, -3/16, -1/4,  5/16,  3/16},
	{-3/16, -0.5, -0.5,   3/16, 5/16, -1/4}
}

local pillar = {-1/4, -0.5, -1/4, 1/4, 0.5, 1/4}

local full_blocks = {
	{-0.5,  -0.5, -3/16, 0.5,  5/16, 3/16},
	{-3/16, -0.5, -0.5,  3/16, 5/16, 0.5}
}

local collision = {
	{-1/4, -0.5, -1/4, 1/4, 1, 1/4}
}

local floor = math.floor
for i = 1, 15 do
	local need = {}
	local need_pillar = false
	for j = 1, 4 do
		if floor(i / 2 ^ (j - 1)) % 2 == 1 then
			need[j] = true
		end
	end

	local take = {}
	if need[1] and need[3] then
		need[1] = nil
		need[3] = nil
		take[#take+1] = full_blocks[1]
	end
	if need[2] and need[4] then
		need[2] = nil
		need[4] = nil
		take[#take+1] = full_blocks[2]
	end
	for k in pairs(need) do
		take[#take+1] = half_blocks[k]
		need_pillar = true
	end
	if i == 15 then need_pillar = true end
	if need_pillar then
		take[#take+1] = pillar
	end

	-- Wall
	minetest.register_node(":wallet:wall_" .. i, {
		collision_box = {
			type = "fixed",
			fixed = collision
		},
		drawtype = "nodebox",
		is_ground_content = false,
		tiles = {"default_cobble.png"},
		paramtype = "light",
		sunlight_propagates = true,
		groups = {cracky = 3, wall = 1, stone = 2},
		drop = "wallet:wall",
		node_box = {
			type = "fixed",
			fixed = take
		}
	})

	-- Mossy wall
	minetest.register_node(":wallet:wallmossy_" .. i, {
		drawtype = "nodebox",
		collision_box = {
			type = "fixed",
			fixed = collision
		},
		tiles = {"default_mossycobble.png"},
		paramtype = "light",
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {cracky = 3, wall = 1, stone = 2},
		drop = "wallet:wallmossy",
		node_box = {
			type = "fixed",
			fixed = take
		}
	})
end

minetest.register_alias("wallet:wall_0", "wallet:wall_15")
minetest.register_alias("wallet:wallmossy_0", "wallet:wallmossy_15")

-- Wall
minetest.register_node(":wallet:wall_16", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_cobble.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wall",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[1]}
	}
})

minetest.register_node(":wallet:wall_21", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_cobble.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wall",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[2]}
	}
})

minetest.register_node(":wallet:wall", {
	description = walls.S"Cobblestone Wall",
	paramtype = "light",
	tiles = {"default_cobble.png"},
	groups = {cracky = 3, wall = 1, stone = 2},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			pillar,
			half_blocks[1],
			half_blocks[3]
		}
	},
	on_construct = update_wall
})

minetest.register_craft({
	output = "wallet:wall 6",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"},
		{"default:cobble", "default:cobble", "default:cobble"}
	}
})

-- Mossy wall
minetest.register_node(":wallet:wallmossy_16", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wallmossy",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[1]}
	}
})

minetest.register_node(":wallet:wallmossy_21", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wallmossy",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[2]}
	}
})

minetest.register_node(":wallet:wallmossy", {
	description = walls.S"Mossy Cobblestone Wall",
	paramtype = "light",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, wall = 1, stone = 2},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			pillar,
			half_blocks[1],
			half_blocks[3]
		}
	},
	on_construct = update_wall
})

minetest.register_craft({
	output = "wallet:wallmossy 6",
	recipe = {
		{"default:mossycobble", "default:mossycobble", "default:mossycobble"},
		{"default:mossycobble", "default:mossycobble", "default:mossycobble"}
	}
})

minetest.register_on_placenode(update_wall_global)
minetest.register_on_dignode(update_wall_global)
