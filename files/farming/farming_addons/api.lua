local random = math.random

-- how often node timers for plants will tick, +/- some random value
function farming_addons.tick(pos)
	minetest.get_node_timer(pos):start(random(180, 256))
end
-- how often a growth failure tick is retried (e.g. too dark)
function farming_addons.tick_again(pos)
	minetest.get_node_timer(pos):start(math.random(96, 256))
end

local function check_free(pos)
	local node = minetest.get_node(pos)
	if node.name ~= "air" then
		return false
	end

	local nb = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	local nb_def = minetest.registered_nodes[nb.name]
	if not nb_def or not nb_def.walkable then
		return false
	end

	return true
end

-- grow blocks next to the plant
function farming_addons.grow_block(pos, connect, rotate)
	local node = minetest.get_node(pos)
	local spos = minetest.pos_to_string(pos)
	local def = minetest.registered_nodes[node.name]
	local block_pos
	local right_pos = {x = pos.x + 1, y = pos.y, z = pos.z}
	local front_pos = {x = pos.x, y = pos.y, z = pos.z + 1}
	local left_pos = {x = pos.x - 1, y = pos.y, z = pos.z}
	local back_pos = {x = pos.x, y = pos.y, z = pos.z - 1}
	local right = minetest.get_node(right_pos)
	local front = minetest.get_node(front_pos)
	local left = minetest.get_node(left_pos)
	local back = minetest.get_node(back_pos)

	local children = {}

	-- look for fruits around the stem
	if (right.name == def.next_plant) then
		children.right = right_pos
	end
	if (front.name == def.next_plant) then
		children.front = front_pos
	end
	if (left.name == def.next_plant) then
		children.left = left_pos
	end
	if (back.name == def.next_plant) then
		children.back = back_pos
	end

	-- check if the fruit belongs to this stem
	for _, child_pos in pairs(children) do
		local parent_pos = minetest.get_meta(child_pos):get_string("parent")

		-- disable timer for fully grown plant,
		-- fruit for this stem already exists
		if spos == parent_pos then
			return
		end
	end

	-- make sure that at least one side of the plant has space to put fruit
	local spawn_pos = {}

	if check_free(right_pos) then
		spawn_pos[#spawn_pos+1] = right_pos
	end
	if check_free(front_pos) then
		spawn_pos[#spawn_pos+1] = front_pos
	end
	if check_free(left_pos) then
		spawn_pos[#spawn_pos+1] = left_pos
	end
	if check_free(back_pos) then
		spawn_pos[#spawn_pos+1] = back_pos
	end

	-- plant is closed from all sides
	if #spawn_pos < 1 then
		farming_addons.tick_again(pos)
		return
	else
		-- pick random from the open sides
		local pick_random = random(#spawn_pos)

		for k, v in pairs(spawn_pos) do
			if k == pick_random then
				block_pos = v
			end
		end
	end

	-- check light
	local light = minetest.get_node_light(pos)
	if not light or light < 12 then
		farming_addons.tick_again(pos)
		return
	end

	-- spawn block
	if block_pos then
		local p2_r
		if connect then
			local direction = vector.direction(pos, block_pos)
			local p2 = minetest.dir_to_facedir(direction)
			minetest.swap_node(pos, {name = def.next_stage, param2 = p2})

			if rotate then
				-- FIX me if there is an API
				p2_r = (p2 == 0 and 8) or (p2 == 1 and 17)
					or (p2 == 2 and 6) or (p2 == 3 and 15)
			end
		end

		minetest.set_node(block_pos, {name = def.next_plant, param2 = p2_r})
		minetest.get_meta(block_pos):set_string("parent", spos)
	end
	return
end

function farming_addons.dig_node(meta, node, swap)
	local parent = meta.fields.parent
	local parent_pos_from_child = minetest.string_to_pos(parent)
	local parent_node

	-- make sure we have position
	if parent_pos_from_child then
		parent_node = minetest.get_node(parent_pos_from_child)
	end

	-- tick parent if parent stem still exists
	if parent_node and parent_node.name == node then
		minetest.swap_node(parent_pos_from_child, {name = swap})
		farming_addons.tick(parent_pos_from_child)
	end
end
