local MAX_SECTION_LEN = 20

railtrack = {
	rotations = "FLR",
	accel_flat = -0.5,
	accel_up = -2,
	accel_down = 2,
}

railtrack.default_rail = {
	description = "Rail",
	drawtype = "raillike",
	tiles = {"default_rail.png", "default_rail_curved.png",
		"default_rail_t_junction.png", "default_rail_crossing.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy = 2, dig_immediate = 2, attached_node = 1,
		connect_to_raillike = minetest.raillike_group("rail")},
	railtype = "rail",
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		local def = itemstack:get_definition() or {}
		if def.acceleration then
			meta:set_string("acceleration", def.acceleration)
		end
		local junc = {}
		local contype = meta:get_string("contype") or ""
		local s_cons = meta:get_string("connections") or ""
		if contype == "section" then
			railtrack:limit_section_len(placer, pos, meta)
		elseif s_cons ~= "" then
			local cons = minetest.deserialize(s_cons)
			for _, con in pairs(cons) do
				if railtrack:limit_section_len(placer, con) then
					break
				end
			end
		end
	end,
	on_construct = function(pos)
		railtrack:update_rails(pos)
	end,
	after_destruct = function(pos, oldnode)
		local cons = railtrack:get_connections(pos)
		for _, p in pairs(cons) do
			railtrack:update_rails(p)
		end
	end,
}

function railtrack:copy(t)
	if type(t) ~= "table" then
		return t
	end
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

function railtrack:register_rail(name, def)
	local udef = {}
	for k, v in pairs(railtrack.default_rail) do
		if not def[k] then
			def[k] = railtrack:copy(v)
		end
		udef[k] = railtrack:copy(def[k])
	end
	def.inventory_image = def.inventory_image or def.tiles[1]
	def.wield_image = def.wield_image or def.tiles[1]
	minetest.register_node(name, def)
	udef.drop = name
	udef.railtype = udef.railtype.."_union"
	udef.groups.not_in_creative_inventory=1
	minetest.register_node(name.."_union", udef)
end

function railtrack:limit_section_len(player, pos, meta)
	meta = meta or minetest.get_meta(pos)
	local contype = meta:get_string("contype") or ""
	if contype == "section" then
		local s_junc = meta:get_string("junctions") or ""
		if s_junc ~= "" then
			local junc = minetest.deserialize(s_junc)
			if #junc == 2 then
				local dist = railtrack:get_distance(junc[1], junc[2])
				if dist > MAX_SECTION_LEN then
					local node = minetest.get_node(pos) or {}
					if node.name then
						minetest.swap_node(pos, {name=node.name.."_union"})
						railtrack:update_rails(pos)
					end
				end
			end
		end
	end
end

function railtrack:is_railnode(pos)
	local node = minetest.get_node(pos)
	if node then
		return minetest.get_item_group(node.name, "connect_to_raillike") > 0
	end
end

function railtrack:get_sign(z)
	if z == 0 then
		return 0
	else
		return z / math.abs(z)
	end
end

function railtrack:get_rotations(s_rots, dir)
	local rots = {}
	for i = 1, string.len(s_rots) do
		local r = string.sub(s_rots, i, i)
		local rot = nil
		if r == "F" then
			rot = {x=dir.x, z=dir.z}
		elseif r == "L" then
			rot = {x=-dir.z, z=dir.x}
		elseif r == "R" then
			rot = {x=dir.z, z=-dir.x}
		elseif r == "B" then
			rot = {x=-dir.x, z=-dir.z}
		end
		if rot then
			table.insert(rots, rot)
		end
	end
	return rots
end

function railtrack:get_acceleration(pos)
	local meta = minetest.get_meta(pos)
	local accel = meta:get_string("acceleration") or ""
	if accel ~= "" then
		return tonumber(accel)
	end
end

function railtrack:get_direction(p1, p2)
	local v = vector.subtract(p1, p2)
	return {
		x = railtrack:get_sign(v.x),
		y = railtrack:get_sign(v.y),
		z = railtrack:get_sign(v.z),
	}
end

function railtrack:get_distance(p1, p2)
	local dx = p1.x - p2.x
	local dz = p1.z - p2.z
	return math.abs(dx) + math.abs(dz)
end


function railtrack:get_railtype(pos)
	local node = minetest.get_node(pos) or {}
	if node.name then
		local ref = minetest.registered_items[node.name] or {}
		return ref.railtype
	end
end

function railtrack:get_connection_type(pos, cons)
	local railtype = railtrack:get_railtype(pos)
	if #cons == 0 then
		return "single"
	elseif #cons == 1 then
		return "junction"
	elseif #cons == 2 then
		if cons[1].x == cons[2].x or cons[1].z == cons[2].z then
			if (cons[1].y == cons[2].y and cons[1].y == pos.y) or
					(math.abs(cons[1].y - cons[2].y) == 2) then
				if railtype == railtrack:get_railtype(cons[1]) and
						railtype == railtrack:get_railtype(cons[2]) then
					return "section"
				end
			end
		end
	end
	return "junction"
end

function railtrack:get_connections(pos)
	local connections = {}
	for y = 1, -1, -1 do
		for x = -1, 1 do
			for z = -1, 1 do
				if math.abs(x) ~= math.abs(z) then
					local p = vector.add(pos, {x=x, y=y, z=z})
					if railtrack:is_railnode(p) then
						table.insert(connections, p)
					end
				end
			end
		end
	end
	return connections
end

function railtrack:get_junctions(pos, last_pos, junctions)
	junctions = junctions or {}
	local cons = railtrack:get_connections(pos)
	local contype = railtrack:get_connection_type(pos, cons)
	if contype == "junction" then
		table.insert(junctions, pos)
	elseif contype == "section" then
		if last_pos then
			for i, p in pairs(cons) do
				if vector.equals(p, last_pos) then
					cons[i] = nil
				end
			end
		end
		for _, p in pairs(cons) do
			railtrack:get_junctions(p, pos, junctions)
		end
	end
	return junctions
end

function railtrack:set_acceleration(pos, accel)
	local meta = minetest.get_meta(pos)
	local contype = meta:get_string("contype")
	if contype == "section" then
		local s_junc = meta:get_string("junctions") or ""
		local junc = minetest.deserialize(s_junc) or {}
		if #junc == 2 then
			local p = vector.new(junc[2])
			local dir = railtrack:get_direction(junc[1], junc[2])
			local dist = railtrack:get_distance(junc[1], junc[2])
			for i = 0, dist do
				local m = minetest.get_meta(p)
				if m then
					m:set_string("acceleration", tostring(accel))
				end
				p = vector.add(dir, p)
			end
		end
	else
		meta:set_string("acceleration", tostring(accel))
	end
end

function railtrack:update_rails(pos, last_pos, level)
	local connections = {}
	local junctions = {}
	local meta = minetest.get_meta(pos)
	local cons = railtrack:get_connections(pos)
	local contype = railtrack:get_connection_type(pos, cons)
	level = level or 0
	for i, p in pairs(cons) do
		connections[i] = p
	end
	if contype == "junction" then
		level = level + 1
	end
	if contype == "section" or level < 2 then
		if last_pos then
			for i, p in pairs(cons) do
				if vector.equals(p, last_pos) then
					cons[i] = nil
				end
			end
		end
		for _, p in pairs(cons) do
			railtrack:update_rails(p, pos, level)
		end
	end
	if contype == "section" then
		junctions = railtrack:get_junctions(pos)
		connections = {}
	end
	meta:set_string("connections", minetest.serialize(connections))
	meta:set_string("junctions", minetest.serialize(junctions))
	meta:set_string("contype", contype)
end

