-- Minetest: builtin/item_entity.lua (5th October 2015)

-- water flow functions by QwertyMine3 and edited by TenPlus1
local function to_unit_vector(dir_vector)
	local inv_roots = {
		[0] = 1, [1] = 1, [2] = 0.70710678118655, [4] = 0.5,
		[5] = 0.44721359549996, [8] = 0.35355339059327
	}
	local sum = dir_vector.x * dir_vector.x + dir_vector.z * dir_vector.z
	return {
		x = dir_vector.x * inv_roots[sum],
		y = dir_vector.y,
		z = dir_vector.z * inv_roots[sum]
	}
end

local function is_touching(realpos, nodepos, radius)
	return (math.abs(realpos - nodepos) > (0.5 - radius))
end

local function node_ok(pos) -- added by TenPlus1
	local node = minetest.get_node_or_nil(pos)
	if not node then
		return minetest.registered_nodes["default:dirt"]
	end
	local nodef = minetest.registered_nodes[node.name]
	if nodef then
		return node
	end
	return minetest.registered_nodes["default:dirt"]
end


local function is_water(pos)
	return (minetest.get_item_group(
		node_ok({x=pos.x,y=pos.y,z=pos.z}).name, "water") ~= 0)
end

local function is_liquid(pos)
	return (minetest.get_item_group(
		node_ok({x=pos.x,y=pos.y,z=pos.z}).name, "liquid") ~= 0)
end

local function node_is_liquid(node)
	return (minetest.get_item_group(node.name, "liquid") ~= 0)
end

local function quick_flow_logic(node, pos_testing, direction)

	local nodef = minetest.registered_nodes[node.name]

	if minetest.registered_nodes[node.name].liquidtype == "source" then

		local node_testing = node_ok(pos_testing)
		local param2_testing = node_testing.param2

		if minetest.registered_nodes[node_testing.name].liquidtype ~= "flowing" then
			return 0
		else
			return direction
		end

	elseif minetest.registered_nodes[node.name].liquidtype == "flowing" then

		local node_testing = node_ok(pos_testing)
		local param2_testing = node_testing.param2

		if minetest.registered_nodes[node_testing.name].liquidtype == "source" then
			return -direction

		elseif minetest.registered_nodes[node_testing.name].liquidtype == "flowing" then

			if param2_testing < node.param2 then
				if (node.param2 - param2_testing) > 6 then
					return -direction
				else
					return direction
				end

			elseif param2_testing > node.param2 then
				if (param2_testing - node.param2) > 6 then
					return direction
				else
					return -direction
				end
			end
		end
	end
	return 0
end

local function quick_flow(pos, node)
	local x, z = 0, 0
	
	if not node_is_liquid(node)  then
		return {x = 0, y = 0, z = 0}
	end
	
	x = x + quick_flow_logic(node, {x = pos.x - 1, y = pos.y, z = pos.z},-1)
	x = x + quick_flow_logic(node, {x = pos.x + 1, y = pos.y, z = pos.z}, 1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z - 1},-1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z + 1}, 1)

	return to_unit_vector({x = x, y = 0, z = z})
end

--if not in water but touching, move centre to touching block
--x has higher precedence than z -- if pos changes with x, it affects z
local function move_centre(pos, realpos, node, radius)

	if is_touching(realpos.x, pos.x, radius) then

		if is_liquid({x = pos.x - 1, y = pos.y, z = pos.z}) then
			pos = {x = pos.x - 1, y = pos.y, z = pos.z}
			node = node_ok(pos)

		elseif is_liquid({x = pos.x + 1, y = pos.y, z = pos.z}) then
			pos = {x = pos.x + 1, y = pos.y, z = pos.z}
			node = node_ok(pos)
		end
	end

	if is_touching(realpos.z, pos.z, radius) then

		if is_liquid({x = pos.x, y = pos.y, z = pos.z - 1}) then
			pos = {x = pos.x, y = pos.y, z = pos.z - 1}
			node = node_ok(pos)

		elseif is_liquid({x = pos.x, y = pos.y, z = pos.z + 1}) then
			pos = {x = pos.x, y = pos.y, z = pos.z + 1}
			node = node_ok(pos)
		end
	end

	return pos, node
end
-- END water flow functions

function core.spawn_item(pos, item)
	-- take item in any format
	local stack = ItemStack(item)
	local obj = core.add_entity(pos, "__builtin:item")
	-- Don't use obj if it couldn't be added to the map.
	if obj then
		obj:get_luaentity():set_item(stack:to_string())
	end
	return obj
end

-- if item_entity_ttl is not set, enity will have default life time
-- setting to -1 disables the feature
local time_to_live = tonumber(core.setting_get("item_entity_ttl")) or 900

-- if destroy_item is 1 then dropped items will burn inside lava
local destroy_item = tonumber(core.setting_get("destroy_item")) or 1

-- particle effects for when item is destroyed
local function add_effects(pos)
	minetest.add_particlespawner({
		amount = 1,
		time = 0.25,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 5, z = 1},
		minacc = {x = -4, y = -4, z = -4},
		maxacc = {x = 4, y = 4, z = 4},
		minexptime = 1,
		maxexptime = 3,
		minsize = 1,
		maxsize = 4,
		texture = "tnt_smoke.png",
	})
end

-- check if within map limits (-30911 to 30927)
local function within_limits(pos)
	if  pos.x > -30913
	and pos.x <  30928
	and pos.y > -30913
	and pos.y <  30928
	and pos.z > -30913
	and pos.z <  30928 then
		return true -- within limits
	end
	return false -- beyond limits
end

core.register_entity(":__builtin:item", {
	initial_properties = {
		hp_max = 1,
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		visual = "wielditem",
		visual_size = {x = 0.4, y = 0.4},
		textures = {""},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		is_visible = false,
	},

	itemstring = "",
	physical_state = true,
	age = 0,

	set_item = function(self, itemstring)
		self.itemstring = itemstring
		local stack = ItemStack(itemstring)
		local count = stack:get_count()
		local max_count = stack:get_stack_max()
		if count > max_count then
			count = max_count
			self.itemstring = stack:get_name().." "..max_count
		end
		local s = 0.2 + 0.1 * (count / max_count)
		local c = s
		local itemtable = stack:to_table()
		local itemname = itemtable and itemtable.name
		local prop = {
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x = s, y = s},
			collisionbox = {-c, -c, -c, c, c, c},
			--automatic_rotate = math.pi * 0.5,
			automatic_rotate = 1,
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		return core.serialize({
			itemstring = self.itemstring,
			age = self.age
		})
	end,

	on_activate = function(self, staticdata, dtime_s)

		-- special function to fast remove entities (xanadu only)
		if mobs and mobs.entity and mobs.entity == false then
			self.object:remove()
			return
		end

		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = core.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				if data.age then
					self.age = data.age + dtime_s
				else
					self.age = dtime_s
				end
			end
		else
			self.itemstring = staticdata
		end
		self.object:set_armor_groups({immortal = 1})
		self.object:setvelocity({x = 0, y = 2, z = 0})
		self.object:setacceleration({x = 0, y = -10, z = 0})
		self:set_item(self.itemstring)
	end,

	try_merge_with = function(self, own_stack, object, obj)
		local stack = ItemStack(obj.itemstring)
		if own_stack:get_name() == stack:get_name()
		and stack:get_free_space() > 0 then
			local overflow = false
			local count = stack:get_count() + own_stack:get_count()
			local max_count = stack:get_stack_max()
			if count > max_count then
				overflow = true
				count = count - max_count
			else
				self.itemstring = ""
			end
			local pos = object:getpos()
			pos.y = pos.y + (count - stack:get_count()) / max_count * 0.15
			object:moveto(pos, false)
			local s, c
			local max_count = stack:get_stack_max()
			local name = stack:get_name()
			if not overflow then
				obj.itemstring = name .. " " .. count
				s = 0.2 + 0.1 * (count / max_count)
				c = s
				object:set_properties({
					visual_size = {x = s, y = s},
					collisionbox = {-c, -c, -c, c, c, c}
				})
				self.object:remove()
				return true -- merging succeeded
			else
				s = 0.4
				c = 0.3
				object:set_properties({
					visual_size = {x = s, y = s},
					collisionbox = {-c, -c, -c, c, c, c}
				})
				obj.itemstring = name .. " " .. max_count
				s = 0.2 + 0.1 * (count / max_count)
				c = s
				self.object:set_properties({
					visual_size = {x = s, y = s},
					collisionbox = {-c, -c, -c, c, c, c}
				})
				self.itemstring = name .. " " .. count
			end
		end
		return false -- merging didn't succeed
	end,

	on_step = function(self, dtime)
		self.age = self.age + dtime
		local p = self.object:getpos()

		-- remove item if old enough or outside map limits
		if (time_to_live > 0 and self.age > time_to_live)
		or not within_limits(p) then
			self.itemstring = ""
			self.object:remove()
			return
		end

		p.y = p.y - 0.5
		local node = core.get_node_or_nil(p)
		if not node then
			-- don't infinetly fall into unloaded map
			self.object:setvelocity({x = 0, y = 0, z = 0})
			self.object:setacceleration({x = 0, y = 0, z = 0})
			self.physical_state = false
			self.object:set_properties({physical = false})
			return
		end
		local nn = node.name

		-- destroy item when dropped into lava (if enabled)
		if destroy_item > 0 and minetest.get_item_group(nn, "lava") > 0 then
			minetest.sound_play("builtin_item_lava", {
				pos = p,
				max_hear_distance = 6,
				gain = 0.5
			})
			add_effects(p)
			self.object:remove()
			return
		end

		-- flowing water pushes item along (by QwertyMine3)
		local nod = node_ok({x = p.x, y = p.y + 0.5, z = p.z})
		if minetest.registered_nodes[nod.name].liquidtype == "flowing" then

			local vec = quick_flow(self.object:getpos(),
				node_ok(self.object:getpos()))

			if vec then
				local v = self.object:getvelocity()
				self.object:setvelocity(
					{x = vec.x, y = v.y, z = vec.z})
				self.object:setacceleration(
					{x = 0, y = -10, z = 0})
				self.physical_state = true
				self.object:set_properties({
					physical = true
				})
			end

			return
		end

		-- if node is not registered or walkably solid
		local v = self.object:getvelocity()
		if not core.registered_nodes[nn] or core.registered_nodes[nn].walkable and v.y == 0 then
			if self.physical_state then
				local own_stack = ItemStack(self.object:get_luaentity().itemstring)
				-- merge with close entities of the same item
				for _, object in ipairs(core.get_objects_inside_radius(p, 0.8)) do
					local obj = object:get_luaentity()
					if obj and obj.name == "__builtin:item"
							and obj.physical_state == false then
						if self:try_merge_with(own_stack, object, obj) then
							return
						end
					end
				end
				self.object:setvelocity({x = 0, y = 0, z = 0})
				self.object:setacceleration({x = 0, y = 0, z = 0})
				self.physical_state = false
				self.object:set_properties({physical = false})
			end
		else
			if not self.physical_state then
				self.object:setvelocity({x = 0, y = 0, z = 0})
				self.object:setacceleration({x = 0, y = -10, z = 0})
				self.physical_state = true
				self.object:set_properties({physical = true})
			end
		end
	end,

	on_punch = function(self, puncher)
		local inv = puncher:get_inventory()
		if inv and self.itemstring ~= '' then
			local left = inv:add_item("main", self.itemstring)
			if left and not left:is_empty() then
				self.itemstring = left:to_string()
				return
			end
		end
		self.itemstring = ""
		self.object:remove()
	end,
})