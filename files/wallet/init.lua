local function rshift(x, by)
	return math.floor(x / 2 ^ by)
end

local directions = {
	{x = 1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = -1},
	{x = 0, y = -1, z = 0}
}

function update_wall(pos)
	local typewall = 0

	if minetest.get_node(pos).name:find("wallet:wall") == 1 then
		typewall = typewall + 1
	end

	if minetest.get_node(pos).name:find("wallet:wallmossy") == 1 then
		typewall = typewall + 1
	end

	if typewall == 0 then return end

	local sum = 0
	for i = 1, 4 do
		local node = minetest.get_node({x = pos.x + directions[i].x, y = pos.y + directions[i].y, z = pos.z + directions[i].z})
		if minetest.registered_nodes[node.name].walkable then
			sum = sum + 2 ^ (i - 1)
		end
	end

	local node = minetest.get_node({x = pos.x, y = pos.y+1, z = pos.z})
	if sum == 5 or sum == 10 then
		if minetest.registered_nodes[node.name].walkable or node.name == "torches:floor" then
			sum = sum + 11
		end
	end

	if sum == 0 then
		sum = 15
	end

	if typewall == 1 then
		minetest.add_node(pos, {name = "wallet:wall_"..sum})
	else
		minetest.add_node(pos, {name = "wallet:wallmossy_"..sum})
	end
end

function update_wall_global(pos)
	for i = 1,5 do
		update_wall({x = pos.x + directions[i].x, y = pos.y + directions[i].y, z = pos.z + directions[i].z})
	end
end

local half_blocks = {
	{4/16, -0.5, -3/16, 0.5, 5/16, 3/16},
	{-3/16, -0.5, 4/16, 3/16, 5/16, 0.5},
	{-0.5, -0.5, -3/16, -4/16, 5/16, 3/16},
	{-3/16, -0.5, -0.5, 3/16, 5/16, -4/16}
}

local pillar = {-4/16, -0.5, -4/16, 4/16, 0.5, 4/16}

local full_blocks = {
	{-0.5, -0.5, -3/16, 0.5, 5/16, 3/16},
	{-3/16, -0.5, -0.5, 3/16, 5/16, 0.5}
}

local collision = {
	{-4/16, -1, -4/16, 4/16, 1, 4/16}
}

for i = 0, 15 do
	local need = {}
	local need_pillar = false
	for j = 1, 4 do
		if rshift(i, j - 1) % 2 == 1 then
			need[j] = true
		end
	end

	local take = {}
	if need[1] and need[3] then
		need[1] = nil
		need[3] = nil
		table.insert(take, full_blocks[1])
	end
	if need[2] and need[4] then
		need[2] = nil
		need[4] = nil
		table.insert(take, full_blocks[2])
	end
	for k in pairs(need) do
		table.insert(take, half_blocks[k])
		need_pillar = true
	end
	if i == 15 or i == 0 then need_pillar = true end
	if need_pillar then table.insert(take, pillar) end

	minetest.register_node("wallet:wall_"..i, {
		collision_box = {
			type = "fixed",
			fixed = collision
		},
		drawtype = "nodebox",
		tiles = {"default_cobble.png"},
		paramtype = "light",
		groups = {cracky = 3, wall = 1, stone = 2},
		drop = "wallet:wall",
		node_box = {
			type = "fixed",
			fixed = take
		}
	})
end

minetest.register_node("wallet:wall_0", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_cobble.png"},
	paramtype = "light",
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wall",
	node_box = {
		type = "fixed",
		fixed = pillar
	}
})

minetest.register_node("wallet:wall_16", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_cobble.png"},
	paramtype = "light",
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wall",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[1]}
	}
})

minetest.register_node("wallet:wall_21", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_cobble.png"},
	paramtype = "light",
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wall",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[2]}
	}
})

minetest.register_node("wallet:wall", {
	description = "Cobblestone Wall",
	paramtype = "light",
	tiles = {"default_cobble.png"},
	inventory_image = "cobblestone_wallet.png",
	groups = {cracky = 3, wall = 1, stone = 2},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = pillar
	},
	collision_box = {
		type = "fixed",
		fixed = collision
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

-- Mossy wallet

for i = 0, 15 do
	local need = {}
	local need_pillar = false
	for j = 1, 4 do
		if rshift(i, j - 1) % 2 == 1 then
			need[j] = true
		end
	end

	local take = {}
	if need[1] and need[3] then
		need[1] = nil
		need[3] = nil
		table.insert(take, full_blocks[1])
	end
	if need[2] and need[4] then
		need[2] = nil
		need[4] = nil
		table.insert(take, full_blocks[2])
	end
	for k in pairs(need) do
		table.insert(take, half_blocks[k])
		need_pillar = true
	end
	if i == 15 or i == 0 then need_pillar = true end
	if need_pillar then table.insert(take, pillar) end

	minetest.register_node("wallet:wallmossy_"..i, {
		drawtype = "nodebox",
		collision_box = {
			type = "fixed",
			fixed = collision
		},
		tiles = {"default_mossycobble.png"},
		paramtype = "light",
		groups = {cracky = 3, wall = 1, stone = 2},
		drop = "wallet:wallmossy",
		node_box = {
			type = "fixed",
			fixed = take
		}
	})
end

minetest.register_node("wallet:wallmossy_0", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	paramtype = "light",
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wallmossy",
	node_box = {
		type = "fixed",
		fixed = pillar
	}
})

minetest.register_node("wallet:wallmossy_16", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	paramtype = "light",
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wallmossy",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[1]}
	}
})

minetest.register_node("wallet:wallmossy_21", {
	drawtype = "nodebox",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	paramtype = "light",
	groups = {cracky = 3, wall = 1, stone = 2},
	drop = "wallet:wallmossy",
	node_box = {
		type = "fixed",
		fixed = {pillar, full_blocks[2]}
	}
})

minetest.register_node("wallet:wallmossy", {
	description = "Mossy Cobblestone Wall",
	paramtype = "light",
	collision_box = {
		type = "fixed",
		fixed = collision
	},
	tiles = {"default_mossycobble.png"},
	inventory_image = "cobblestonemossy_wallet.png",
	groups = {cracky = 3, wall = 1, stone = 2},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = pillar
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
