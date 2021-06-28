doors = {
	registered_doors = {},
	registered_trapdoors = {},
	registered_fencegates = {}
}

local translator = minetest.get_translator
local S = translator and translator("doors") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local table_copy = table.copy
local vnew = vector.new

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

	local pn = clicker and clicker:get_player_name() or ""
	if clicker and minetest.is_protected(pos, pn) and
			not default.can_interact_with_node(clicker, pos) then
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
		param2 = transform[state + 1][dir + 1].param2
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
			above = vnew(pointed_thing.above),
			under = vnew(pointed_thing.under),
			ref   = pointed_thing.ref
		}
		callback(place_to_copy, newnode_copy, placer,
			oldnode_copy, itemstack, pointed_thing_copy)
	end
end

function doors.register(name, def)
	if not name:find(":") then
		name = "doors:" .. name
	end

	minetest.register_craftitem(":" .. name, {
		description = S(def.description),
		inventory_image = def.inventory_image,
		groups = table_copy(def.groups),

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
			if minetest.is_protected(pos, pn) or minetest.is_protected(above, pn) then
				return itemstack
			end

			local dir = placer and minetest.dir_to_facedir(placer:get_look_dir()) or 0

			local ref = {
				{x = -1, y = 0, z =  0},
				{x =  0, y = 0, z =  1},
				{x =  1, y = 0, z =  0},
				{x =  0, y = 0, z = -1}
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
				meta:set_string("infotext", S(def.description) .. "\n" .. S("Owned by @1", S(pn)))
			end

			if not minetest.is_creative_enabled(pn) then
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
		def.on_rightclick = function(pos, node, clicker, itemstack)
			doors.door_toggle(pos, node, clicker)
			return itemstack
		end
	end

	def.mesecons = {effector = {
		action_on = function(pos)
			local door = doors.get(pos)
			if door then
				door:open()
			end
		end,
		action_off = function(pos)
			local door = doors.get(pos)
			if door then
				door:close()
			end
		end
	}}

	def.on_rotate = function()
		return false
	end

	if def.protected then
		def.on_blast = function() end
		def.node_dig_prediction = ""
	else
		def.on_blast = function(pos)
			minetest.remove_node(pos)
			return {name}
		end
	end

	def.drawtype = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.sunlight_propagates = true
	def.walkable = true
	def.is_ground_content = false
	def.buildable_to = false

	local box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, -3/8}}
	def.selection_box = box
	def.collision_box = box

	def.mesh = "door_a.obj"
	minetest.register_node(":" .. name .. "_a", def)

	def.mesh = "door_b.obj"
	minetest.register_node(":" .. name .. "_b", def)

	doors.registered_doors[name .. "_a"] = true
	doors.registered_doors[name .. "_b"] = true
end

---- Trapdoor ----

function doors.trapdoor_toggle(pos, node, clicker)
	node = node or minetest.get_node(pos)

	local pn = clicker and clicker:get_player_name() or ""
	if clicker and minetest.is_protected(pos, pn) and
			not default.can_interact_with_node(clicker, pos) then
		return false
	end

	local def = minetest.registered_nodes[node.name]

	if node.name:sub(-5) == "_open" then
		minetest.sound_play(def.sound_close,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = node.name:sub(1,
			node.name:len() - 5), param1 = node.param1, param2 = node.param2})
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

	def.description = S(def.description)

	def.on_rightclick = function(pos, node, clicker, itemstack)
		doors.trapdoor_toggle(pos, node, clicker)
		return itemstack
	end

	def.mesecons = {effector = {
		action_on = function(pos)
			local door = doors.get(pos)
			if door then
				door:open()
			end
		end,
		action_off = function(pos)
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
		def.after_place_node = function(pos, placer)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("owner", pn)
			meta:set_string("infotext", def.description .. "\n" .. S("Owned by @1", S(pn)))

			return minetest.is_creative_enabled(pn)
		end

		def.on_blast = function() end
		def.node_dig_prediction = ""
	else
		def.on_blast = function(pos)
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

	local def_opened = table_copy(def)
	local def_closed = table_copy(def)

	def_closed.node_box = def.node_box_close or {
		type = "fixed",
		fixed = {
			{-3/8,  -0.5,  5/16, 3/8,  -3/8,  0.5},  -- top
			{-5/16, -0.5, -1/8,  5/16, -3/8,  1/8},  -- middle
			{-3/8,  -0.5, -0.5,  3/8,  -3/8, -5/16}, -- bottom
			{-0.5,  -0.5, -0.5, -5/16, -3/8,  0.5},  -- left
			{ 5/16, -0.5, -0.5,  0.5,  -3/8,  0.5},  -- right
			{-1/8,  -0.5,  1/8, 1/8,   -3/8,  5/16}, -- middle top
			{-1/8,  -0.5, -5/16, 1/8,  -3/8, -1/8}   -- middle bottom

		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -3/8, 0.5}
	}
	def.tile_bottom = def.tile_bottom or def.tile_front
	def_closed.tiles = {
		def.tile_front,
		def.tile_bottom .. "^[transformFY",
		def.tile_side,
		def.tile_side,
		def.tile_side,
		def.tile_side
	}

	def_opened.node_box = def.node_box_open or {
		type = "fixed",
		fixed = {
			{-5/16,  5/16, 3/8,  5/16,  0.5,  0.5}, -- top
			{-5/16, -1/8,  3/8,  5/16,  1/8,  0.5}, -- middle
			{-5/16, -0.5,  3/8,  5/16, -5/16, 0.5}, -- bottom
			{-0.5,  -0.5,  3/8, -5/16,  0.5,  0.5}, -- left
			{ 5/16, -0.5,  3/8,  0.5,   0.5,  0.5}, -- right
			{-1/8,   1/8,  3/8,  1/8,   5/16, 0.5}, -- middle top
			{-1/8,  -5/16, 3/8,  1/8,  -1/8,  0.5}  -- middle bottom

		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 3/8, 0.5, 0.5, 0.5}
	}
	def_opened.tiles = {
		def.tile_side,
		def.tile_side .. "^[transform2",
		def.tile_side .. "^[transform3",
		def.tile_side .. "^[transform1",
		def.tile_front .. "^[transform46",
		def.tile_bottom .. "^[transform6"
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	doors.registered_trapdoors[name_opened] = true
	doors.registered_trapdoors[name_closed] = true

	minetest.register_craft({
		output = name_closed .. " 2",
		recipe = {
			{def.material, def.material, def.material},
			{def.material, def.material, def.material}
		}
	})

	if def.fuel then
		minetest.register_craft({
			type = "fuel",
			recipe = name_closed,
			burntime = def.fuel
		})
	end
end

---- Fence Gate ----

function doors.fencegate_toggle(pos, node, clicker)
	node = node or minetest.get_node(pos)

	local pn = clicker and clicker:get_player_name() or ""
	if clicker and minetest.is_protected(pos, pn) and
			not default.can_interact_with_node(clicker, pos) then
		return false
	end

	local def = minetest.registered_nodes[node.name]

	if node.name:sub(-5) == "_open" then
		minetest.sound_play(def.sound_close,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = node.name:sub(1,
			node.name:len() - 5), param1 = node.param1, param2 = node.param2})
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

	def.description = S(def.description)

	local name_closed = name
	local name_opened = name .. "_open"

	def.on_rightclick = function(pos, node, clicker, itemstack)
		doors.fencegate_toggle(pos, node, clicker)
		return itemstack
	end

	def.mesecons = {effector = {
		action_on = function(pos)
			local door = doors.get(pos)
			if door then
				door:open()
			end
		end,
		action_off = function(pos)
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
		def.tiles[1] = table_copy(def.texture)
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

	local def_opened = table_copy(def)
	local def_closed = table_copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{-1/2, -3/16, -1/16, -3/8, 1/2,   1/16}, -- Left completion
			{ 3/8, -3/16, -1/16,  1/2, 1/2,   1/16}, -- Right completion
			{-1/8, -1/8,  -1/16,  0,   7/16,  1/16}, -- Center Left
			{ 0,   -1/8,  -1/16,  1/8, 7/16,  1/16}, -- Center Right
			{-1/8,  1/4,   1/16, -3/8, 7/16, -1/16}, -- Above  (cross) -z
			{-1/8, -1/8,   1/16, -3/8, 1/16, -1/16}, -- Bottom (cross) -z
			{ 1/8,  1/4,  -1/16,  3/8, 7/16,  1/16}, -- Above  (transverse) z
			{ 1/8, -1/8,  -1/16,  3/8, 1/16,  1/16}  -- Below  (across) z
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-1/2, -3/16, -1/16, 1/2, 1/2, 1/16}
		}
	}
	def_closed.collision_box = {
		type = "fixed",
		fixed = {
			{-1/2, -3/16, -1/16, 1/2, 1, 1/16}
		}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{-1/2, -3/16, -1/16, -3/8, 1/2, 1/16}, -- Left completion
			{ 3/8, -3/16, -1/16,  1/2, 1/2, 1/16}, -- Right completion
			{-1/2,  1/4,   1/16, -3/8, 7/16, 3/8}, -- Top-left     (transverse) x
			{-1/2, -1/8,   1/16, -3/8, 1/16, 3/8}, -- Bottom-left  (transverse) x
			{ 3/8,  1/4,   1/16,  1/2, 7/16, 1/2}, -- Top-right    (transverse) x
			{ 3/8, -1/8,   1/16,  1/2, 1/16, 1/2}, -- Bottom-right (transverse) x
			{-1/2, -1/8,   3/8,  -3/8, 7/16, 1/2}, -- Center Left
			{ 3/8,  1/4,   1/2,   1/2, 1/16, 3/8}  -- Center Right
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {
			{-1/2, -3/16, -1/16, -3/8, 1/2, 1/2}, -- Left
			{ 3/8, -3/16, -1/16,  1/2, 1/2, 1/2}  -- Right
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

-- Register nodes
dofile(minetest.get_modpath("doors") .. "/doors.lua")
