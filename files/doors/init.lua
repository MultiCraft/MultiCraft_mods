-- our API object
doors = {}

doors.registered_doors = {}
doors.registered_trapdoors = {}
doors.registered_fencegates = {}

local function replace_old_owner_information(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("doors_owner")
	if owner and owner ~= "" then
		meta:set_string("owner", owner)
		meta:set_string("doors_owner", "")
	end
end

-- returns an object to a door object or nil
function doors.get(pos)
	local node_name = minetest.get_node(pos).name
	if doors.registered_doors[node_name] then
		-- A normal upright door
		return {
			pos = pos,
			open = function(self, player)
				if self:state() then
					return false
				end
				return doors.door_toggle(self.pos, nil, player)
			end,
			close = function(self, player)
				if not self:state() then
					return false
				end
				return doors.door_toggle(self.pos, nil, player)
			end,
			toggle = function(self, player)
				return doors.door_toggle(self.pos, nil, player)
			end,
			state = function(self)
				local state = minetest.get_meta(self.pos):get_int("state")
				return state %2 == 1
			end
		}
	elseif doors.registered_trapdoors[node_name] then
		-- A trapdoor
		return {
			pos = pos,
			open = function(self, player)
				if self:state() then
					return false
				end
				return doors.trapdoor_toggle(self.pos, nil, player)
			end,
			close = function(self, player)
				if not self:state() then
					return false
				end
				return doors.trapdoor_toggle(self.pos, nil, player)
			end,
			toggle = function(self, player)
				return doors.trapdoor_toggle(self.pos, nil, player)
			end,
			state = function(self)
				return minetest.get_node(self.pos).name:sub(-5) == "_open"
			end
		}
	elseif doors.registered_fencegates[node_name] then
		-- A fencegate
		return {
			pos = pos,
			open = function(self, player)
				if self:state() then
					return false
				end
				return doors.fencegate_toggle(self.pos, nil, player)
			end,
			close = function(self, player)
				if not self:state() then
					return false
				end
				return doors.fencegate_toggle(self.pos, nil, player)
			end,
			toggle = function(self, player)
				return doors.fencegate_toggle(self.pos, nil, player)
			end,
			state = function(self)
				return minetest.get_node(self.pos).name:sub(-5) == "_open"
			end
		}
	else
		return nil
	end
end

-- table used to aid door opening/closing
local transform = {
	{
		{v = "_a", param2 = 3},
		{v = "_a", param2 = 0},
		{v = "_a", param2 = 1},
		{v = "_a", param2 = 2}
	},
	{
		{v = "_b", param2 = 1},
		{v = "_b", param2 = 2},
		{v = "_b", param2 = 3},
		{v = "_b", param2 = 0}
	},
	{
		{v = "_b", param2 = 1},
		{v = "_b", param2 = 2},
		{v = "_b", param2 = 3},
		{v = "_b", param2 = 0}
	},
	{
		{v = "_a", param2 = 3},
		{v = "_a", param2 = 0},
		{v = "_a", param2 = 1},
		{v = "_a", param2 = 2}
	}
}

function doors.door_toggle(pos, node, clicker)
	local meta = minetest.get_meta(pos)
	node = node or minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	local name = def.door.name

	local state = meta:get_string("state")
	if state == "" then
		-- fix up lvm-placed right-hinged doors, default closed
		if node.name:sub(-2) == "_b" then
			state = 2
		else
			state = 0
		end
	else
		state = tonumber(state)
	end

	replace_old_owner_information(pos)

	if clicker and not default.can_interact_with_node(clicker, pos) then
		return false
	end

	-- until Lua-5.2 we have no bitwise operators :(
	if state % 2 == 1 then
		state = state - 1
	else
		state = state + 1
	end

	local dir = node.param2

	-- It's possible param2 is messed up, so, validate before using
	-- the input data. This indicates something may have rotated
	-- the door, even though that is not supported.
	if not transform[state + 1] or not transform[state + 1][dir + 1] then
		return false
	end

	if state % 2 == 0 then
		minetest.sound_play(def.door.sounds[1],
			{pos = pos, gain = 0.3, max_hear_distance = 10})
	else
		minetest.sound_play(def.door.sounds[2],
			{pos = pos, gain = 0.3, max_hear_distance = 10})
	end

	minetest.swap_node(pos, {
		name = name .. transform[state + 1][dir+1].v,
		param2 = transform[state + 1][dir+1].param2
	})
	meta:set_int("state", state)

	return true
end


local function on_place_node(place_to, newnode,
	placer, oldnode, itemstack, pointed_thing)
	-- Run script hook
	for _, callback in ipairs(minetest.registered_on_placenodes) do
		-- Deepcopy pos, node and pointed_thing because callback can modify them
		local place_to_copy = {x = place_to.x, y = place_to.y, z = place_to.z}
		local newnode_copy =
			{name = newnode.name, param1 = newnode.param1, param2 = newnode.param2}
		local oldnode_copy =
			{name = oldnode.name, param1 = oldnode.param1, param2 = oldnode.param2}
		local pointed_thing_copy = {
			type  = pointed_thing.type,
			above = vector.new(pointed_thing.above),
			under = vector.new(pointed_thing.under),
			ref   = pointed_thing.ref,
		}
		callback(place_to_copy, newnode_copy, placer,
			oldnode_copy, itemstack, pointed_thing_copy)
	end
end

local function can_dig_door(pos, digger)
	replace_old_owner_information(pos)
	return default.can_interact_with_node(digger, pos)
end

function doors.register(name, def)
	if not name:find(":") then
		name = "doors:" .. name
	end

	minetest.register_craftitem(":" .. name, {
		description = def.description,
		inventory_image = def.inventory_image,
		groups = table.copy(def.groups),

		on_place = function(itemstack, placer, pointed_thing)
			local pos

			if not pointed_thing.type == "node" then
				return itemstack
			end

			local node = minetest.get_node(pointed_thing.under)
			local pdef = minetest.registered_nodes[node.name]
			if pdef and pdef.on_rightclick and
					not (placer and placer:is_player() and
					placer:get_player_control().sneak) then
				return pdef.on_rightclick(pointed_thing.under,
						node, placer, itemstack, pointed_thing)
			end

			if pdef and pdef.buildable_to then
				pos = pointed_thing.under
			else
				pos = pointed_thing.above
				node = minetest.get_node(pos)
				pdef = minetest.registered_nodes[node.name]
				if not pdef or not pdef.buildable_to then
					return itemstack
				end
			end

			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			local top_node = minetest.get_node_or_nil(above)
			local topdef = top_node and minetest.registered_nodes[top_node.name]

			if not topdef or not topdef.buildable_to then
				return itemstack
			end

			local pn = placer and placer:get_player_name() or ""
			if minetest.is_protected_action(pos, pn) or minetest.is_protected(above, pn) then
				return itemstack
			end

			local dir = placer and minetest.dir_to_facedir(placer:get_look_dir()) or 0

			local ref = {
				{x = -1, y = 0, z = 0},
				{x = 0, y = 0, z = 1},
				{x = 1, y = 0, z = 0},
				{x = 0, y = 0, z = -1}
			}

			local aside = {
				x = pos.x + ref[dir + 1].x,
				y = pos.y + ref[dir + 1].y,
				z = pos.z + ref[dir + 1].z
			}

			local state = 0
			if minetest.get_item_group(minetest.get_node(aside).name, "door") == 1 then
				state = state + 2
				minetest.set_node(pos, {name = name .. "_b", param2 = dir})
			else
				minetest.set_node(pos, {name = name .. "_a", param2 = dir})
			end

			local meta = minetest.get_meta(pos)
			meta:set_int("state", state)

			if def.protected then
				meta:set_string("owner", pn)
				meta:set_string("infotext", def.description .. "\n" .. Sl("Owned by @1", pn))
			end

			if not (creative and creative.is_enabled_for and creative.is_enabled_for(pn)) then
				itemstack:take_item()
			end

			minetest.sound_play(def.sounds.place, {pos = pos})

			on_place_node(pos, minetest.get_node(pos),
				placer, node, itemstack, pointed_thing)

			return itemstack
		end
	})
	def.inventory_image = nil

	if def.fuel then
		minetest.register_craft({
			type = "fuel",
			recipe = name,
			burntime = def.fuel
		})
	end
	def.fuel = nil

	if def.recipe then
		minetest.register_craft({
			output = name,
			recipe = def.recipe,
		})
	end
	def.recipe = nil

	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
	end

	if not def.sound_open then
		def.sound_open = "doors_door_open"
	end

	if not def.sound_close then
		def.sound_close = "doors_door_close"
	end

	def.groups.not_in_creative_inventory = 1
	def.groups.door = 1
	def.drop = name
	def.door = {
		name = name,
		sounds = {def.sound_close, def.sound_open}
	}

	if not def.on_rightclick then
		def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			doors.door_toggle(pos, node, clicker)
			return itemstack
		end
	end

	def.mesecons = {effector = {
		action_on = function(pos, node)
			local door = doors.get(pos)
			if door then
				door:open()
			end
		end,
		action_off = function(pos, node)
			local door = doors.get(pos)
			if door then
				door:close()
			end
		end
	}}

	def.after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
		minetest.check_for_falling({x = pos.x, y = pos.y + 1, z = pos.z})
	end

	def.on_rotate = function(pos, node, user, mode, new_param2)
		return false
	end

	if def.protected then
		def.can_dig = can_dig_door
		def.on_blast = function() end
		def.node_dig_prediction = ""
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end

	def.on_destruct = function(pos)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
	end

	def.drawtype = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.sunlight_propagates = true
	def.walkable = true
	def.is_ground_content = false
	def.buildable_to = false
	def.selection_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}}
	def.collision_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}}

	def.mesh = "door_a.obj"
	minetest.register_node(":" .. name .. "_a", def)

	def.mesh = "door_b.obj"
	minetest.register_node(":" .. name .. "_b", def)

	doors.registered_doors[name .. "_a"] = true
	doors.registered_doors[name .. "_b"] = true
end

-- Apple Wood Doors --

doors.register("door_wood", {
	tiles = {{name = "doors_door_wood.png", backface_culling = true}},
	description = "Apple Wood Door",
	inventory_image = "doors_item_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"}
	}
})

-- Acacia Wood Doors --

doors.register("door_acacia_wood", {
	tiles = {{name = "doors_door_acacia_wood.png", backface_culling = true}},
	description = "Acacia Wood Door",
	inventory_image = "doors_item_acacia_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:acacia_wood", "default:acacia_wood"},
		{"default:acacia_wood", "default:acacia_wood"},
		{"default:acacia_wood", "default:acacia_wood"}
	}
})

-- Birch Wood Doors --

doors.register("door_birch_wood", {
	tiles = {{name = "doors_door_birch_wood.png", backface_culling = true}},
	description = "Birch Wood Door",
	inventory_image = "doors_item_birch_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:birch_wood", "default:birch_wood"},
		{"default:birch_wood", "default:birch_wood"},
		{"default:birch_wood", "default:birch_wood"}
	}
})

-- Jungle Wood Doors --

doors.register("door_jungle_wood", {
	tiles = {{name = "doors_door_jungle_wood.png", backface_culling = true}},
	description = "Jungle Wood Door",
	inventory_image = "doors_item_jungle_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:junglewood", "default:junglewood"},
		{"default:junglewood", "default:junglewood"},
		{"default:junglewood", "default:junglewood"}
	}
})

-- Pine Wood Doors --

doors.register("door_pine_wood", {
	tiles = {{name = "doors_door_pine_wood.png", backface_culling = true}},
	description = "Pine Wood Door",
	inventory_image = "doors_item_pine_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:pine_wood", "default:pine_wood"},
		{"default:pine_wood", "default:pine_wood"},
		{"default:pine_wood", "default:pine_wood"}
	}
})

doors.register("door_steel", {
	tiles = {{name = "doors_door_steel.png", backface_culling = true}},
	description = "Steel Door",
	inventory_image = "doors_item_steel.png",
	protected = true,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"}
	}
})

-- Aliases

local doors_aliases = {
	{"acacia_b_1",		"doors:door_acacia_wood_a"},
	{"acacia_b_2",		"doors:door_acacia_wood_b"},
	{"acacia_t_1",		"air"},
	{"acacia_t_2",		"air"},
	{"birch_b_1",		"doors:door_birch_wood_a"},
	{"birch_b_2",		"doors:door_birch_wood_b"},
	{"birch_t_1",		"air"},
	{"birch_t_2",		"air"},
	{"dark_oak_b_1",	"doors:door_pine_wood_a"},
	{"dark_oak_b_2",	"doors:door_pine_wood_b"},
	{"dark_oak_t_1",	"air"},
	{"dark_oak_t_2",	"air"},
	{"jungle_b_1",		"doors:door_jungle_wood_a"},
	{"jungle_b_2",		"doors:door_jungle_wood_a"},
	{"jungle_t_1",		"air"},
	{"jungle_t_2",		"air"},
	{"wood_b_1",		"doors:door_wood_a"},
	{"wood_b_2",		"doors:door_wood_b"},
	{"wood_t_1",		"air"},
	{"wood_t_2",		"air"},
	{"steel_b_1",		"doors:door_steel_a"},
	{"steel_b_2",		"doors:door_steel_b"},
	{"steel_t_1",		"air"},
	{"steel_t_2",		"air"}
}

for i = 1, #doors_aliases do
	local old, new = unpack(doors_aliases[i])
	minetest.register_alias("doors:door_" .. old, new)
end

minetest.register_alias("doors:door_acacia", "doors:door_acacia_wood")
minetest.register_alias("doors:door_birch", "doors:door_birch_wood")
minetest.register_alias("doors:door_dark_oak", "doors:door_pine_wood")
minetest.register_alias("doors:door_jungle", "doors:door_jungle_wood")
minetest.register_alias("doors:hidden", "air")

---- Trapdoor ----

function doors.trapdoor_toggle(pos, node, clicker)
	node = node or minetest.get_node(pos)

	replace_old_owner_information(pos)

	if clicker and not default.can_interact_with_node(clicker, pos) then
		return false
	end

	local def = minetest.registered_nodes[node.name]

	if string.sub(node.name, -5) == "_open" then
		minetest.sound_play(def.sound_close,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = string.sub(node.name, 1,
			string.len(node.name) - 5), param1 = node.param1, param2 = node.param2})
	else
		minetest.sound_play(def.sound_open,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = node.name .. "_open",
			param1 = node.param1, param2 = node.param2})
	end
end

function doors.register_trapdoor(name, def)
	if not name:find(":") then
		name = "doors:" .. name
	end

	local name_closed = name
	local name_opened = name .. "_open"

	def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		doors.trapdoor_toggle(pos, node, clicker)
		return itemstack
	end

	def.mesecons = {effector = {
		action_on = function(pos, node)
			local door = doors.get(pos)
			if door then
				door:open()
			end
		end,
		action_off = function(pos, node)
			local door = doors.get(pos)
			if door then
				door:close()
			end
		end
	}}

	-- Common trapdoor configuration
	def.drawtype = "nodebox"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.is_ground_content = false

	if def.protected then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("owner", pn)
			meta:set_string("infotext", def.description .. "\n" .. Sl("Owned by @1", pn))

			return (creative and creative.is_enabled_for and creative.is_enabled_for(pn))
		end

		def.on_blast = function() end
		def.node_dig_prediction = ""
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end

	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
	end

	if not def.sound_open then
		def.sound_open = "doors_door_open"
	end

	if not def.sound_close then
		def.sound_close = "doors_door_close"
	end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -6/16, 0.5}
	}
	def_closed.tiles = {
		def.tile_front,
		def.tile_front .. "^[transformFY",
		def.tile_side,
		def.tile_side,
		def.tile_side,
		def.tile_side
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5}
	}
	def_opened.tiles = {
		def.tile_side,
		def.tile_side .. "^[transform2",
		def.tile_side .. "^[transform3",
		def.tile_side .. "^[transform1",
		def.tile_front .. "^[transform46",
		def.tile_front .. "^[transform6"
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	doors.registered_trapdoors[name_opened] = true
	doors.registered_trapdoors[name_closed] = true
end

doors.register_trapdoor("doors:trapdoor", {
	description = "Wooden Trapdoor",
	inventory_image = "doors_trapdoor.png",
	wield_image = "doors_trapdoor.png",
	tile_front = "doors_trapdoor.png",
	tile_side = "doors_trapdoor_side.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_steel", {
	description = "Steel Trapdoor",
	inventory_image = "doors_trapdoor_steel.png",
	wield_image = "doors_trapdoor_steel.png",
	tile_front = "doors_trapdoor_steel.png",
	tile_side = "doors_trapdoor_steel_side.png",
	protected = true,
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	groups = {cracky = 1, level = 2, door = 1}
})

minetest.register_craft({
	output = "doors:trapdoor 2",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "doors:trapdoor_steel",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "doors:trapdoor",
	burntime = 7
})

---- Fence Gate ----

function doors.fencegate_toggle(pos, node, clicker)
	node = node or minetest.get_node(pos)

	replace_old_owner_information(pos)

	if clicker and not default.can_interact_with_node(clicker, pos) then
		return false
	end

	local def = minetest.registered_nodes[node.name]

	if string.sub(node.name, -5) == "_open" then
		minetest.sound_play(def.sound_close,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = string.sub(node.name, 1,
			string.len(node.name) - 5), param1 = node.param1, param2 = node.param2})
	else
		minetest.sound_play(def.sound_open,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = node.name .. "_open",
			param1 = node.param1, param2 = node.param2})
	end
end

function doors.register_fencegate(name, def)
	if not name:find(":") then
		name = "doors:" .. name
	end

	local name_closed = name
	local name_opened = name .. "_open"

	def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		doors.fencegate_toggle(pos, node, clicker)
		return itemstack
	end

	def.mesecons = {effector = {
		action_on = function(pos, node)
			local door = doors.get(pos)
			if door then
				door:open()
			end
		end,
		action_off = function(pos, node)
			local door = doors.get(pos)
			if door then
				door:close()
			end
		end
	}}

	-- Common fencegate configuration
	def.drawtype = "nodebox"
	def.tiles = {}
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.sunlight_propagates = true
	def.is_ground_content = false
	def.connect_sides = {"left", "right"}
	def.groups = def.groups
	def.sounds = def.sounds
	def.groups.fence = 1

	if type(def.texture) == "string" then
		def.tiles[1] = {name = def.texture, backface_culling = true}
	elseif def.texture.backface_culling == nil then
		def.tiles[1] = table.copy(def.texture)
		def.tiles[1].backface_culling = true
	else
		def.tiles[1] = def.texture
	end

	if not def.sound_open then
		def.sound_open = "doors_fencegate_open"
	end

	if not def.sound_close then
		def.sound_close = "doors_fencegate_close"
	end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{-1/2, -1/2+5/16, -1/16, -1/2+2/16, 1/2, 1/16},		-- Left completion
			{1/2-2/16, -1/2+5/16, -1/16, 1/2, 1/2, 1/16},		-- Right completion
			{-2/16, -1/2+6/16, -1/16, 0, 1/2-1/16, 1/16},		-- Center Left
			{0, -1/2+6/16, -1/16, 2/16, 1/2-1/16, 1/16},		-- Center Right
			{-2/16, 1/2-4/16, 1/16, -1/2, 1/2-1/16, -1/16},		-- Above (cross) -z
			{-2/16, -1/2+6/16, 1/16, -1/2, -1/2+9/16, -1/16},	-- Bottom (cross) -z
			{2/16, 1/2-4/16, -1/16, 1/2, 1/2-1/16, 1/16},		-- Above (transverse) z
			{2/16, -1/2+6/16, -1/16, 1/2, -1/2+9/16, 1/16},		-- Below (across) z
			{-2/16, 1/2, -2/16, -2/16, 1/2+8/16, -2/16},
			{-2/16, 1/2, 2/16, -2/16, 1/2+8/16, 2/16},
			{2/16, 1/2, -2/16, 2/16, 1/2+8/16, -2/16},
			{2/16, 1/2, 2/16, 2/16, 1/2+8/16, 2/16},
			{-6/16, 1/2-1/16, 1/16, -6/16, 1/2+8/16, 1/16},		-- Top block (cross) -x 1 side
			{-6/16, 1/2-1/16, -1/16, -6/16, 1/2+8/16, -1/16},	-- Top block (cross) -x 2 side
			{5/16, 1/2-1/16, 1/16, 5/16, 1/2+8/16, 1/16},		-- Top block (cross) x 1 side
			{5/16, 1/2-1/16, -1/16, 5/16, 1/2+8/16, -1/16}		-- Top block (cross) x 2 side
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-1/2, -1/2+5/16, -1/16, 1/2, 1/2, 1/16}			-- Gate
		}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{-1/2, -1/2+5/16, -1/16, -1/2+2/16, 1/2, 1/16},		-- Left completion
			{1/2-2/16, -1/2+5/16, -1/16, 1/2, 1/2, 1/16},		-- Right completion
			{-1/2, 1/2-4/16, 1/16, -1/2+2/16, 1/2-1/16, 1/2-2/16}, -- Top-left (transverse) x
			{-1/2, -1/2+6/16, 1/16, -1/2+2/16, -1/2+9/16, 1/2-2/16}, -- Bottom-left (transverse) x
			{1/2-2/16, 1/2-4/16, 1/16, 1/2, 1/2-1/16, 1/2},		-- Top-right (transverse) x
			{1/2-2/16, -1/2+6/16, 1/16, 1/2, -1/2+9/16, 1/2},	-- Bottom-right (transverse) x
			{-1/2, -1/2+6/16, 6/16, -1/2+2/16, 1/2-1/16, 1/2},	-- Center Left
			{1/2-2/16, 1/2-4/16, 1/2, 1/2, -1/2+9/16, 6/16}		-- Center Right
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {
			{-1/2, -1/2+5/16, -1/16, -1/2+2/16, 1/2, 1/2},		-- Left
			{1/2-2/16, -1/2+5/16, -1/16, 1/2, 1/2, 1/2}			-- Right
		}
	}

	def_opened.drop = name_closed

	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	doors.registered_fencegates[name_opened] = true
	doors.registered_fencegates[name_closed] = true

	minetest.register_craft({
		output = name,
		recipe = {
			{"default:stick", def.material, "default:stick"},
			{"default:stick", def.material, "default:stick"}
		}
	})
end

doors.register_fencegate("doors:gate_wood", {
	description = "Apple Wood Fence Gate",
	texture = "default_wood.png",
	inventory_image = "doors_fencegate_wood.png",
	wield_image = "doors_fencegate_wood.png",
	material = "default:wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:fencegate_wood",
	burntime = 10
})

minetest.register_alias("fences:fencegate_open", "doors:gate_wood_open")
minetest.register_alias("fences:fencegate", "doors:gate_wood")
minetest.register_alias("doors:gate_wood_closed", "doors:gate_wood")
