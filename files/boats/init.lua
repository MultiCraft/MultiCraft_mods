handlers = {}

minetest.register_on_leaveplayer(function(player)
	handlers[player:get_player_name()] = nil
end)

--
-- Helper functions
--

local function is_water(pos)

	return minetest.get_item_group(minetest.get_node(pos).name, "water") ~= 0
end

local function get_sign(i)

	if i == 0 then
		return 0
	else
		return i / math.abs(i)
	end
end

local function get_velocity(v, yaw, y)

	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v

	return {x = x, y = y, z = z}
end

local square = math.sqrt

local function get_v(v)

	return square(v.x *v.x + v.z *v.z)
end

--
-- Boat entity
--

local boat = {
	physical = true,
	collisionbox = {-0.5, -0.4, -0.5, 0.5, 0.3, 0.5},
	visual = "mesh",
	mesh = "rowboat.x",
	textures = {"default_wood.png"},
	driver = nil,
	v = 0,
	last_v = 0,
	removed = false
}

function boat.on_rightclick(self, clicker)

	if not clicker or not clicker:is_player() then
		return
	end

	local name = clicker:get_player_name()

	if self.driver and clicker == self.driver then

		handlers[name] = nil
		self.driver = nil

		clicker:set_detach()

		default.player_attached[name] = false
		default.player_set_animation(clicker, "stand" , 30)

		local pos = clicker:getpos()

		minetest.after(0.1, function()
			clicker:setpos({x=pos.x, y=pos.y+0.2, z=pos.z})
		end)

	elseif not self.driver then

		if handlers[name] and handlers[name].driver then
			handlers[name].driver = nil
		end

		handlers[name] = self.object:get_luaentity()
		self.driver = clicker

		clicker:set_attach(self.object, "",
			{x = 0, y = 11, z = -3}, {x = 0, y = 0, z = 0})

		default.player_attached[name] = true

		minetest.after(0.2, function()
			default.player_set_animation(clicker, "sit" , 30)
		end)

		self.object:setyaw(clicker:get_look_yaw() - math.pi / 2)
	end
end

function boat.on_activate(self, staticdata, dtime_s)

	if mobs and mobs.entity and mobs.entity == false then
		self.object:remove()
		return
	end

	self.object:set_armor_groups({immortal = 1})
	self.v = 0
	self.v2 = self.v
	self.last_v = self.v
	self.count = 0
end

function boat.on_punch(self, puncher)

	if not puncher or not puncher:is_player() or self.removed then
		return
	end

	if self.driver and puncher == self.driver then
		local name = puncher:get_player_name()
		puncher:set_detach()
		self.driver = nil
		handlers[name] = nil
		default.player_attached[name] = false
	end

	if not self.driver then

		self.removed = true

		if not minetest.setting_getbool("creative_mode") then

			local inv = puncher:get_inventory()

			if inv:room_for_item("main", "boats:boat") then
				inv:add_item("main", "boats:boat")
			else
				minetest.add_item(self.object:getpos(), "boats:boat")
			end
		end

		self.object:remove()
	end
end

function boat.on_step(self, dtime)

	-- after 10 seconds remove boat and drop as item if not boarded
	self.count = self.count + dtime

	if self.count > 10 then
		minetest.add_item(self.object:getpos(), "boats:boat")
		self.object:remove()
		return
	end

	self.v = get_v(self.object:getvelocity()) * get_sign(self.v)

	if self.driver then

		self.count = 0

		local ctrl = self.driver:get_player_control()
		local yaw = self.object:getyaw()

		if ctrl.up then
			self.v = self.v + 0.1
		elseif ctrl.down then
			self.v = self.v - 0.1
		end

		if ctrl.left then

			if self.v < 0 then
				self.object:setyaw(yaw - (1 + dtime) * 0.08) -- 0.03 changed to speed up turning
			else
				self.object:setyaw(yaw + (1 + dtime) * 0.08) -- 0.03
			end

		elseif ctrl.right then

			if self.v < 0 then
				self.object:setyaw(yaw + (1 + dtime) * 0.08) -- 0.03
			else
				self.object:setyaw(yaw - (1 + dtime) * 0.08) -- 0.03
			end
		end
	end

	local velo = self.object:getvelocity()

	if self.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		--self.object:setpos(self.object:getpos())
		return
	end

	local s = get_sign(self.v)
	self.v = self.v - 0.02 * s

	if s ~= get_sign(self.v) then

		self.object:setvelocity({x = 0, y = 0, z = 0})
		self.v = 0

		return
	end

	if math.abs(self.v) > 4.5 then
		self.v = 4.5 * get_sign(self.v)
	end

	local p = self.object:getpos()
	local new_velo = {x = 0, y = 0, z = 0}
	local new_acce = {x = 0, y = 0, z = 0}

	p.y = p.y - 0.5

	if not is_water(p) then

		local nodedef = minetest.registered_nodes[minetest.get_node(p).name]

		if (not nodedef) or nodedef.walkable then
			self.v = 0
			new_acce = {x = 0, y = 0, z = 0} -- y was 1
		else
			new_acce = {x = 0, y = -9.8, z = 0}
		end

		new_velo = get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y)
		--self.object:setpos(self.object:getpos())
	else
		p.y = p.y + 1

		if is_water(p) then

			local y = self.object:getvelocity().y

			if y >= 4.5 then
				y = 4.5
			elseif y < 0 then
				new_acce = {x = 0, y = 20, z = 0}
			else
				new_acce = {x = 0, y = 5, z = 0}
			end

			new_velo = get_velocity(self.v, self.object:getyaw(), y)
			--self.object:setpos(self.object:getpos())
		else
			new_acce = {x = 0, y = 0, z = 0}

			if math.abs(self.object:getvelocity().y) < 1 then
				local pos = self.object:getpos()
				pos.y = math.floor(pos.y) + 0.5
				self.object:setpos(pos)
				new_velo = get_velocity(self.v, self.object:getyaw(), 0)
			else
				new_velo = get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y)
				--self.object:setpos(self.object:getpos())
			end
		end
	end

	self.object:setvelocity(new_velo)
	self.object:setacceleration(new_acce)

	-- if boat comes to sudden stop then it has crashed, destroy boat and drop 3x wood
	if self.v2 - self.v >= 3 then

		if self.driver then
--print ("Crash! with driver", self.v2 - self.v)
			self.driver:set_detach()
			default.player_attached[self.driver:get_player_name()] = false
			default.player_set_animation(self.driver, "stand" , 30)
		else
--print ("Crash! no driver")
		end
		
		minetest.add_item(self.object:getpos(), "default:wood 3")

		self.object:remove()

		return
	end

	self.v2 = self.v

end

minetest.register_entity("boats:boat", boat)

minetest.register_craftitem("boats:boat", {
	description = "Boat",
	inventory_image = "rowboat_inventory.png",
	wield_image = "rowboat_inventory.png",
	wield_scale = {x = 2, y = 2, z = 1},
	liquids_pointable = true,

	on_place = function(itemstack, placer, pointed_thing)

		if pointed_thing.type ~= "node"
		or not is_water(pointed_thing.under) then
			return
		end

		pointed_thing.under.y = pointed_thing.under.y + 0.5

		minetest.add_entity(pointed_thing.under, "boats:boat")

		if not minetest.setting_getbool("creative_mode") then
			itemstack:take_item()
		end

		return itemstack
	end,
})

minetest.register_craft({
	output = "boats:boat",
	recipe = {
		{"", "", ""},
		{"group:wood", "", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

minetest.register_alias("ds_rowboat:ds_rowboat", "boats:boat")