local ENTITY_UPDATE_TIME = 1
local OBJECT_UPDATE_TIME = 5
local OBJECT_SAVE_TIME = 10
local RELOAD_DISTANCE = 32
local SNAP_DISTANCE = 0.5
local SPEED_MIN = 0.1
local SPEED_MAX = 15

railcart = {
	timer = 0,
	allcarts = {},
	default_entity = {
		physical = false,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
		visual = "mesh",
		mesh = "railcart.b3d",
		visual_size = {x=1, y=1},
		textures = {"railcart.png"},
		cart = nil,
		driver = nil,
		timer = 0,
	},
}

railcart.cart = {
	id = nil,
	pos = nil,
	target = nil,
	prev = nil,
	accel = nil,
	inv = nil,
	dir = {x=0, y=0, z=0},
	vel = {x=0, y=0, z=0},
	acc = {x=0, y=0, z=0},
	timer = 0,
	name = "railcart:cart_entity",
}

function railcart.cart:new(obj)
	obj = obj or {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function railcart.cart:is_loaded()
	for _, player in pairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		if pos then
			local dist = railtrack:get_distance(pos, self.pos)
			if dist <= RELOAD_DISTANCE then
				return true
			end
		end
	end
	return false
end

function railcart.cart:on_step(dtime)
	self.timer = self.timer - dtime
	if self.timer > 0 then
		return
	end
	self.timer = OBJECT_UPDATE_TIME
	local entity = railcart:get_cart_entity(self.id)
	if entity.object then
		return
	end
	if self:is_loaded() then
		local object = minetest.add_entity(self.pos, self.name)
		if object then
			entity = object:get_luaentity() or {}
			entity.cart = self
			object:setvelocity(self.vel)
			object:setacceleration(self.acc)
		end
	else
		self.timer = railcart:update(self, self.timer)
	end
end

function railcart:register_entity(name, def)
	local ref = {}
	for k, v in pairs(railcart.default_entity) do
		ref[k] = def[k] or railtrack:copy(v)
	end
	ref.on_activate = function(self, staticdata, dtime_s)
		if type(def.on_activate) == "function" then
			def.on_activate(self, staticdata, dtime_s)
		end
		self.object:set_armor_groups({immortal=1})
		if staticdata == "expired" then
			self.object:remove()
		end
	end
	ref.on_step = function(self, dtime)
		if type(def.on_step) == "function" then
			def.on_step(self, dtime)
		end
		local cart = self.cart
		local object = self.object
		if not cart or not object then
			return
		end
		self.timer = self.timer - dtime
		if self.timer > 0 then
			return
		end
		self.timer = railcart:update(cart, ENTITY_UPDATE_TIME, object)
		if type(def.on_update) == "function" then
			def.on_update(self)
		end
	end
	ref.get_staticdata = function(self)
		if type(def.get_staticdata) == "function" then
			def.get_staticdata(self)
		end
		if self.cart then
			if self.cart:is_loaded() == false then
				self.cart.timer = 0
				self.object:remove()
			end
		end
		return "expired"
	end
	for k, v in pairs(def) do
		ref[k] = ref[k] or v
	end
	minetest.register_entity(name, ref)
end

function railcart:save()
	local carts = {}
	for id, cart in pairs(railcart.allcarts) do
		local ref = {}
		for k, v in pairs(cart) do
			ref[k] = v
		end
		local inv = {}
		if ref.inv then
			local list = ref.inv:get_list("main")
			for i, stack in ipairs(list) do
			  inv[i] = stack:to_string()
			end
		end
		ref.inv = inv
		table.insert(carts, ref)
	end
	local output = io.open(minetest.get_worldpath().."/railcart.txt",'w')
	if output then
		output:write(minetest.serialize(carts))
		io.close(output)
	end
end

function railcart:remove_cart(id)
	for i, cart in pairs(railcart.allcarts) do
		if cart.id == id then
			railcart.allcarts[i] = nil
			railcart:save()
			break
		end
	end
end

function railcart:get_rail_direction(pos)
	local target = nil
	local cons = railtrack:get_connections(pos)
	local ymax = pos.y
	for _, con in pairs(cons) do
		if con.y >= ymax then
			ymax = con.y
			target = con
		end
	end
	if target then
		if #cons == 1 then
			target.y = pos.y
		end
		return railtrack:get_direction(target, pos)
	end
	return {x=0, y=0, z=0}
end

function railcart:get_new_id()
	local id = 0
	for _, cart in pairs(railcart.allcarts) do
		if cart.id > id then
			id = cart.id
		end
	end
	return id + 1
end

function railcart:get_cart_ref(id)
	for _, cart in pairs(railcart.allcarts) do
		if cart.id == id then
			return cart
		end
	end
end

function railcart:get_cart_entity(id)
	local cart_ref = {}
	for _, ref in pairs(minetest.luaentities) do
		if ref.cart then
			if ref.cart.id == id then
				cart_ref = ref
				break
			end
		end
	end
	return cart_ref
end

function railcart:get_carts_in_radius(pos, rad)
	local carts = {}
	for _, cart in pairs(railcart.allcarts) do
		local px = pos.x - cart.pos.x
		local py = pos.y - cart.pos.y
		local pz = pos.z - cart.pos.z
		if (px * px) + (py * py) + (pz * pz) <= rad * rad then
			table.insert(carts, cart)
		end
	end
	return carts
end

function railcart:get_cart_in_sight(p1, p2)
	local ref = nil
	local dist = railtrack:get_distance(p1, p2) + 1
	local dir = railtrack:get_direction(p2, p1)
	local carts = railcart:get_carts_in_radius(p1, dist)
	for _, cart in pairs(carts) do
		if not vector.equals(p1, cart.pos) then
			local dc = railtrack:get_direction(cart.pos, p1)
			if vector.equals(dc, dir) then
				local d = railtrack:get_distance(p1, cart.pos)
				if d < dist then
					dist = d
					ref = cart
				end
			end
		end
	end
	return ref
end

function railcart:get_delta_time(vel, acc, dist)
	if vel > 0 then
		if acc == 0 then
			return dist / vel
		end
		local r = math.sqrt(vel * vel + 2 * acc * dist)
		if r > 0 then
			return (-vel + r) / acc
		end
	end
	return 9999 --INF
end

function railcart:velocity_to_dir(v)
	if math.abs(v.x) > math.abs(v.z) then
		return {x=railtrack:get_sign(v.x), y=railtrack:get_sign(v.y), z=0}
	else
		return {x=0, y=railtrack:get_sign(v.y), z=railtrack:get_sign(v.z)}
	end
end

function railcart:velocity_to_speed(vel)
	local speed = math.max(math.abs(vel.x), math.abs(vel.z))
	if speed < SPEED_MIN then
		speed = 0
	elseif speed > SPEED_MAX then
		speed = SPEED_MAX
	end
	return speed
end

function railcart:get_target(pos, vel)
	local meta = minetest.get_meta(vector.round(pos))
	local dir = self:velocity_to_dir(vel)
	local targets = {}
	local rots = railtrack.rotations
	local contype = meta:get_string("contype") or ""
	local s_junc = meta:get_string("junctions") or ""
	local s_cons = meta:get_string("connections") or ""
	local s_rots = meta:get_string("rotations") or ""
	if contype == "section" then
		local junctions = minetest.deserialize(s_junc) or {}
		for _, p in pairs(junctions) do
			table.insert(targets, p)
		end
	else
		local cons = minetest.deserialize(s_cons) or {}
		for _, p in pairs(cons) do
			table.insert(targets, p)
		end
		if s_rots ~= "" then
			local fwd = false
			for _, p in pairs(cons) do
				if vector.equals(vector.add(pos, dir), p) then
					fwd = true
				end
			end
			if fwd == true or #cons == 1 then
				rots = s_rots
			end
		end
	end
	local rotations = railtrack:get_rotations(rots, dir)
	for _, r in ipairs(rotations) do
		for _, t in pairs(targets) do
			local d = railtrack:get_direction(t, pos)
			if r.x == d.x and r.z == d.z then
				return t
			end
		end
	end
end

function railcart:update(cart, time, object)
	if object then
		cart.pos = object:getpos()
		cart.vel = object:getvelocity()
	end
	if not cart.target then
		cart.pos = vector.new(cart.prev)
		cart.target = railcart:get_target(cart.pos, cart.vel)
		if object then
			object:moveto(cart.pos)
		end
	end
	local speed = railcart:velocity_to_speed(cart.vel)
	if cart.target then
		cart.dir = railtrack:get_direction(cart.target, cart.pos)
	else
		speed = 0
	end
	if speed > SPEED_MIN then
		local blocked = false
		local cis = railcart:get_cart_in_sight(cart.pos, cart.target)
		if cis then
			if railcart:velocity_to_speed(cis.vel) == 0 then
				cart.target = vector.subtract(cis.pos, cart.dir)
				blocked = true
			end
		end
--[[
		if object then
			local p1 = vector.add(cart.pos, {x=0, y=1, z=0})
			local p2 = vector.add(cart.target, {x=0, y=1, z=0})
			if minetest.get_node_or_nil(p2) then
				local los, bp = minetest.line_of_sight(p1, p2)
				if los == false then
					bp.y = bp.y - 1
					cart.target = vector.subtract(bp, cart.dir)
					blocked = true
				end
			end
		end
]]--
		local d1 = railtrack:get_distance(cart.prev, cart.target)
		local d2 = railtrack:get_distance(cart.prev, cart.pos)
		local dist = d1 - d2
		if dist > SNAP_DISTANCE then
			local accel = railtrack.accel_flat
			if cart.dir.y == -1 then
				accel = railtrack.accel_down
			elseif cart.dir.y == 1 then
				accel = railtrack.accel_up
			end
			accel = cart.accel or accel
			if object then
				dist = math.max(dist - SNAP_DISTANCE, 0)
			end
			local dt = railcart:get_delta_time(speed, accel, dist)
			if dt < time then
				time = dt
			end
			local dp = speed * time + 0.5 * accel * time * time
			local vf = speed + accel * time
			if object then
				if vf <= 0 then
					speed = 0
					accel = 0
				end
				cart.vel = vector.multiply(cart.dir, speed)
				cart.acc = vector.multiply(cart.dir, accel)
			elseif dp > 0 then
				cart.vel = vector.multiply(cart.dir, vf)
				cart.pos = vector.add(cart.pos, vector.multiply(cart.dir, dp))
			end
		else
			if blocked and vector.equals(cart.target, cart.prev) then
				cart.vel = {x=0, y=0, z=0}
				cart.acc = {x=0, y=0, z=0}
			else
				cart.pos = vector.new(cart.target)
				cart.prev = vector.new(cart.target)
				cart.accel = railtrack:get_acceleration(cart.target)
				cart.target = nil
				return 0
			end
		end
	else
		cart.dir = railcart:get_rail_direction(cart.pos)
		cart.vel = {x=0, y=0, z=0}
		cart.acc = {x=0, y=0, z=0}
	end
	if object then
		if cart.dir.y == -1 then
			object:set_animation({x=1, y=1}, 1, 0)
		elseif cart.dir.y == 1 then
			object:set_animation({x=2, y=2}, 1, 0)
		else
			object:set_animation({x=0, y=0}, 1, 0)
		end
		if cart.dir.x < 0 then
			object:setyaw(math.pi / 2)
		elseif cart.dir.x > 0 then
			object:setyaw(3 * math.pi / 2)
		elseif cart.dir.z < 0 then
			object:setyaw(math.pi)
		elseif cart.dir.z > 0 then
			object:setyaw(0)
		end
		object:setvelocity(cart.vel)
		object:setacceleration(cart.acc)
	end
	return time
end

minetest.register_globalstep(function(dtime)
	for _, cart in pairs(railcart.allcarts) do
		cart:on_step(dtime)
	end
	railcart.timer = railcart.timer + dtime
	if railcart.timer > OBJECT_SAVE_TIME then
		railcart:save()
		railcart.timer = 0
	end
end)

