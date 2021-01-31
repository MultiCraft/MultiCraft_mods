local abs, floor, min, pi = math.abs, math.floor, math.min, math.pi
local vector_add, vector_equals, vector_length, vector_multiply, vector_round =
	vector.add, vector.equals, vector.length, vector.multiply, vector.round
local sp = minetest.is_singleplayer()

local cart_entity = {
	initial_properties = {
		physical = false,
		collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		visual = "mesh",
		mesh = "carts_cart.b3d",
		textures = {"carts_cart.png"}
	},

	owner = nil,
	driver = nil,
	punched = false, -- used to re-send velocity and position
	velocity = {x=0, y=0, z=0}, -- only used on punch
	old_dir = {x=1, y=0, z=0}, -- random value to start the cart on punch
	old_pos = nil,
	old_switch = 0,
	railtype = nil,
	attached_items = {}
}

function cart_entity:on_rightclick(clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local player_name = clicker:get_player_name()
	if self.driver and player_name == self.driver then
		self.driver = nil
		carts:manage_attachment(clicker, nil)
	elseif not self.driver then
		self.driver = player_name
		carts:manage_attachment(clicker, self.object)
		minetest.after(0.1, function()
			if clicker then
				player_api.set_animation(clicker, "sit", 30)
			end
		end)
	end
end

function cart_entity:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	if staticdata:sub(1, 6) ~= "return" then
		return
	end
	local data = minetest.deserialize(staticdata)
	if type(data) ~= "table" then
		return
	end
	self.railtype = data.railtype
	self.old_dir = data.old_dir or self.old_dir
	self.old_pos = data.old_pos or self.old_pos
	-- Correct the position when the cart drives further after the last 'step()'
	if self.old_pos and carts:is_rail(self.old_pos, self.railtype) then
		self.object:set_pos(self.old_pos)
	end
	self.owner = data.owner
	self.age = (data.age or 0) + dtime_s
end

function cart_entity:get_staticdata()
	return minetest.serialize({
		railtype = self.railtype,
		old_dir = self.old_dir,
		old_pos = self.old_pos,
		owner = self.owner,
		age = self.age
	})
end

-- 0.5.x and later: When the driver leaves
function cart_entity:on_detach_child(child)
	if child and child:get_player_name() == self.driver then
		self.driver = nil
		carts:manage_attachment(child, nil)
	end
end

function cart_entity:on_punch(puncher, time_from_last_punch, tool_capabilities)
	local pos = self.object:get_pos()
	local vel = self.object:get_velocity()
	if not self.railtype or vector_equals(vel, {x=0, y=0, z=0}) then
		local node = minetest.get_node(pos).name
		self.railtype = minetest.get_item_group(node, "connect_to_raillike")
	end
	-- Punched by non-player
	if not puncher or not puncher:is_player() then
		local cart_dir = carts:get_rail_direction(pos, self.old_dir, nil, nil, self.railtype)
		if vector_equals(cart_dir, {x=0, y=0, z=0}) then
			return
		end
		self.velocity = vector_multiply(cart_dir, 3)
		self.punched = true
		return
	end
	local puncher_name = puncher:get_player_name()
	-- Player digs cart by sneak-punch
	if puncher:get_player_control().sneak then
		local owner = self.owner
		if owner and owner ~= puncher_name then
			minetest.chat_send_player(puncher_name,
				carts.S"You cannot pick up a Cart!" .. " " .. carts.S("Owned by @1", owner))
			return
		end
		if self.sound_handle then
			minetest.sound_stop(self.sound_handle)
		end
		-- Detach driver and items
		if self.driver then
			if self.old_pos then
				self.object:set_pos(self.old_pos)
			end
			local player = minetest.get_player_by_name(self.driver)
			carts:manage_attachment(player, nil)
		end
		for _, obj in pairs(self.attached_items) do
			if obj then
				obj:set_detach()
			end
		end
		-- Pick up cart
		local inv = puncher:get_inventory()
		if not minetest.is_creative_enabled(puncher_name)
				or not inv:contains_item("main", "carts:cart") then
			local leftover = inv:add_item("main", "carts:cart")
			-- If no room in inventory add a replacement cart to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		self.object:remove()
		return
	end

	-- Player punches cart to alter velocity
	if puncher_name == self.driver then
		if abs(vel.x + vel.z) > carts.punch_speed_max then
			return
		end
	end

	local punch_dir = carts:velocity_to_dir(puncher:get_look_dir())
	punch_dir.y = 0
	local cart_dir = carts:get_rail_direction(pos, punch_dir, nil, nil, self.railtype)
	if vector_equals(cart_dir, {x=0, y=0, z=0}) then
		return
	end

	local punch_interval = 1
	if tool_capabilities and tool_capabilities.full_punch_interval then
		punch_interval = tool_capabilities.full_punch_interval
	end
	time_from_last_punch = min(time_from_last_punch or punch_interval, punch_interval)
	local f = 3 * (time_from_last_punch / punch_interval)

	self.velocity = vector_multiply(cart_dir, f)
	self.old_dir = cart_dir
	self.punched = true
end

-- sound refresh interval = 1.0sec
local function rail_sound(self, dtime)
	if not self.sound_ttl then
		self.sound_ttl = 1.0
		return
	elseif self.sound_ttl > 0 then
		self.sound_ttl = self.sound_ttl - dtime
		return
	end
	self.sound_ttl = 1.0
	if self.sound_handle then
		local handle = self.sound_handle
		self.sound_handle = nil
		minetest.after(0.2, minetest.sound_stop, handle)
	end
	local vel = self.object:get_velocity()
	if not vel then
		return
	end
	local speed = vector_length(vel)
	if speed > 0 then
		self.sound_handle = minetest.sound_play(
			"carts_cart_moving", {
			object = self.object,
			gain = (speed / carts.speed_max) / 2,
			loop = true,
		})
	end
end

local drop_timer = 180 -- 3 min
local function rail_on_step(self, dtime)
	-- Drop cart if there is no player or items inside.
	if not sp then
		if not self.driver and #self.attached_items == 0 then
			self.age = (self.age or 0) + dtime
			if self.age > drop_timer then
				if self.sound_handle then
					minetest.sound_stop(self.sound_handle)
				end
				minetest.add_item(self.object:get_pos(), "carts:cart")
				self.object:remove()
				return
			end
		else
			self.age = 0
		end
	end

	local ctrl, player

	-- Get player controls
	if self.driver then
		player = minetest.get_player_by_name(self.driver)
		if player then
			ctrl = player:get_player_control()
		end
	end

	if ctrl and ctrl.jump then
		self.driver = nil
		carts:manage_attachment(player, nil)
	end

	local vel = self.object:get_velocity()

	if self.punched then
		vel = vector_add(vel, self.velocity)

		if not minetest.is_valid_pos(vel) then
			self.punched = false
			return
		end

		self.object:set_velocity(vel)
		self.old_dir.y = 0
	elseif vector_equals(vel, {x=0, y=0, z=0}) then
		return
	end

	local pos = self.object:get_pos()
	local cart_dir = carts:velocity_to_dir(vel)
	local same_dir = vector_equals(cart_dir, self.old_dir)
	local update = {}

	if self.old_pos and not self.punched and same_dir then
		local flo_pos = vector_round(pos)
		local flo_old = vector_round(self.old_pos)
		if vector_equals(flo_pos, flo_old) then
			-- Do not check one node multiple times
			return
		end
	end

	local distance = 1

	local stop_wiggle = false
	if self.old_pos and same_dir then
		-- Detection for "skipping" nodes (perhaps use average dtime?)
		-- It's sophisticated enough to take the acceleration in account
		local acc = self.object:get_acceleration()
		distance = dtime * (vector_length(vel) + 0.5 * dtime * vector_length(acc))

		local new_pos, new_dir = carts:pathfinder(
			pos, self.old_pos, self.old_dir, distance, ctrl,
			self.old_switch, self.railtype
		)

		if new_pos then
			-- No rail found: set to the expected position
			pos = new_pos
			update.pos = true
			cart_dir = new_dir
		end
	elseif self.old_pos and self.old_dir.y ~= 1 and not self.punched then
		-- Stop wiggle
		stop_wiggle = true
	end

	-- dir:			New moving direction of the cart
	-- switch_keys:	Currently pressed L(1) or R(2) key,
	--				used to ignore the key on the next rail node
	local dir, switch_keys = carts:get_rail_direction(
		pos, cart_dir, ctrl, self.old_switch, self.railtype
	)
	local dir_changed = not vector_equals(dir, self.old_dir)

	local acc = 0
	if stop_wiggle or vector_equals(dir, {x=0, y=0, z=0}) then
		vel = {x=0, y=0, z=0}
		local pos_r = vector_round(pos)
		if not carts:is_rail(pos_r, self.railtype)
				and self.old_pos then
			pos = self.old_pos
		elseif not stop_wiggle then
			pos = pos_r
		else
			pos.y = floor(pos.y + 0.5)
		end
		update.pos = true
		update.vel = true
	else
		-- Direction change detected
		if dir_changed then
			vel = vector_multiply(dir, abs(vel.x + vel.z))
			update.vel = true
			if dir.y ~= self.old_dir.y then
				pos = vector_round(pos)
				update.pos = true
			end
		end
		-- Center on the rail
		if dir.z ~= 0 and floor(pos.x + 0.5) ~= pos.x then
			pos.x = floor(pos.x + 0.5)
			update.pos = true
		end
		if dir.x ~= 0 and floor(pos.z + 0.5) ~= pos.z then
			pos.z = floor(pos.z + 0.5)
			update.pos = true
		end

		-- Calculate current cart acceleration
		acc = nil

		local acc_meta = minetest.get_meta(pos):get_string("cart_acceleration")
		if acc_meta == "halt" and not self.punched then
			-- Stop rail
			vel = {x=0, y=0, z=0}
			acc = false
			pos = vector_round(pos)
			update.pos = true
			update.vel = true
		end
		if acc == nil then
			-- Meta speed modifier
			local speed_mod = tonumber(acc_meta)
			if speed_mod and speed_mod ~= 0 then
				-- Try to make it similar to the original carts mod
				acc = speed_mod * 10
			end
		end
		if acc ~= false then
			-- Handbrake
			if ctrl and ctrl.down then
				acc = (acc or 0) - 2
			elseif acc == nil then
				acc = -0.4
			end
		end

		if acc then
			-- Slow down or speed up, depending on Y direction
			acc = acc + dir.y * -2.1
		else
			acc = 0
		end
	end

	-- Limit cart speed
	local vel_len = vector_length(vel)
	if vel_len > carts.speed_max then
		vel = vector_multiply(vel, carts.speed_max / vel_len)
		update.vel = true
	end
	if vel_len >= carts.speed_max and acc > 0 then
		acc = 0
	end

	self.object:set_acceleration(vector_multiply(dir, acc))

	self.old_pos = vector_round(pos)
	local old_y_dir = self.old_dir.y
	if not vector_equals(dir, {x=0, y=0, z=0}) and not stop_wiggle then
		self.old_dir = dir
	else
		-- Cart stopped, set the animation to 0
		self.old_dir.y = 0
	end
	self.old_switch = switch_keys

	carts:on_rail_step(self, self.old_pos, distance)

	if self.punched then
		-- Collect dropped items
		for _, obj_ in pairs(minetest.get_objects_inside_radius(pos, 1)) do
			if not obj_:is_player() and
					obj_:get_luaentity() and
					not obj_:get_luaentity().physical_state and
					obj_:get_luaentity().name == "__builtin:item" then

				obj_:set_attach(self.object, "", {x=0, y=0, z=0}, {x=0, y=0, z=0})
				self.attached_items[#self.attached_items + 1] = obj_
			end
		end
		self.punched = false
		update.vel = true
	end

	if not (update.vel or update.pos) then
		return
	end
	-- Re-use "dir", localize self.old_dir
	dir = self.old_dir

	local yaw = 0
	if dir.x < 0 then
		yaw = 0.5
	elseif dir.x > 0 then
		yaw = 1.5
	elseif dir.z < 0 then
		yaw = 1
	end
	self.object:set_yaw(yaw * pi)

	local anim = {x=0, y=0}
	if dir.y == -1 then
		anim = {x=1, y=1}
	elseif dir.y == 1 then
		anim = {x=2, y=2}
	end
	self.object:set_animation(anim, 1, 0)

	-- Change player model rotation, depending on the Y direction
	if player and dir.y ~= old_y_dir then
		local feet = {x=0, y=0, z=0}
		local eye = {x=0, y=-4, z=0}
		feet.y = 6
		if dir.y ~= 0 then
			-- TODO: Find a better way to calculate this
			feet.y = feet.y + 2
			feet.z = -dir.y * 6
			eye.z = -dir.y * 8
		end
		player:set_attach(self.object, "", feet,
			{x=dir.y * -30, y=0, z=0})
		player:set_eye_offset(eye, eye)
	end

	if update.vel then
		self.object:set_velocity(vel)
	end
	if update.pos then
		if dir_changed then
			self.object:set_pos(pos)
		else
			self.object:move_to(pos)
		end
	end
end

function carts:on_rail_step(_, pos)
	if minetest.global_exists("mesecon") then
		carts:signal_detector_rail(pos)
	end
end

function cart_entity:on_step(dtime)
	rail_on_step(self, dtime)
	rail_sound(self, dtime)
end

minetest.register_entity("carts:cart", cart_entity)

minetest.register_node("carts:cart", {
	description = carts.S"Cart (Sneak+Click to pick up)",
	drawtype = "mesh",
	mesh = "carts_cart.b3d",
	tiles = {"carts_cart.png"},
	visual_scale = 0.1,
	wield_scale = {x = 0.1, y = 0.1, z = 0.1},
	node_placement_prediction = "",
	stack_max = 1,
	sounds = default.node_sound_metal_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local cart
			if carts:is_rail(pointed_thing.under) then
				cart = minetest.add_entity(pointed_thing.under, "carts:cart")
			elseif carts:is_rail(pointed_thing.above) then
				cart = minetest.add_entity(pointed_thing.above, "carts:cart")
			else
				return itemstack
			end

			local player_name = placer:get_player_name()

			cart:get_luaentity().owner = player_name

			minetest.sound_play({name = "default_place_node_metal", gain = 0.5},
				{pos = pointed_thing.above})

			if not minetest.is_creative_enabled(player_name) or
					not sp then
				itemstack:take_item()
			end
		end

		return itemstack
	end
})

minetest.register_craft({
	output = "carts:cart",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})
