local atan2, floor, pi, sqrt = math.atan2, math.floor, math.pi, math.sqrt
local vector_distance, vector_multiply, vector_normalize, vector_round, vector_subtract =
	vector.distance, vector.multiply, vector.normalize, vector.round, vector.subtract

-- Gets total armor level from 3d armor
local armor_exists = minetest.get_modpath("3d_armor")
local function get_3d_armor_armor(player)
	if not player:is_player() or not armor_exists or
			not armor.def[player:get_player_name()] then
		return 0
	end

	return armor.def[player:get_player_name()].level
end

-- Limits number `x` between `min` and `max` values
local min, max = math.min, math.max
local function limit(x, vmin, vmax)
	return min(max(x, vmin), vmax)
end

-- Main Arrow Entity
minetest.register_entity("nextgen_bows:arrow_entity", {
	initial_properties = {
		visual = "wielditem",
		visual_size = {x = 0.2, y = 0.2, z = 0.3},
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		physical = false,
		textures = {"air"},
		hp_max = 1
	},

	on_activate = function(self, staticdata)
		if not self or not staticdata or staticdata == "" then
			self.object:remove()
			return
		end

		local _staticdata = minetest.deserialize(staticdata)

		-- set/reset - do not inherit from previous entity table
		self._velocity = {x = 0, y = 0, z = 0}
		self._old_pos = nil
		self._attached = false
		self._attached_to = {
			type = "",
			pos = nil
		}
		self._lifetimer = 60
		self._nodechecktimer = 0.5
		self._is_drowning = false
		self._in_liquid = false
		self._poison_arrow = false
		self._shot_from_pos = self.object:get_pos()
		self.arrow = _staticdata.arrow
		self.user = minetest.get_player_by_name(_staticdata.user_name)
		self._tflp = _staticdata._tflp
		self._tool_capabilities = _staticdata._tool_capabilities
		self._is_critical_hit = _staticdata.is_critical_hit
	end,

	on_death = function(self)
		if not self._old_pos then
			self.object:remove()
			return
		end

		minetest.item_drop(ItemStack(self.arrow), nil, vector_round(self._old_pos))
	end,

	on_step = function(self, dtime)
		local pos = self.object:get_pos()
		self._old_pos = self._old_pos or pos
		local ray = minetest.raycast(self._old_pos, pos, true, true)
		local pointed_thing = ray:next()

		self._lifetimer = self._lifetimer - dtime
		self._nodechecktimer = self._nodechecktimer - dtime

		-- adjust pitch when flying
		if not self._attached then
			local velocity = self.object:get_velocity()
			local v_rotation = self.object:get_rotation()
			local pitch = atan2(velocity.y, sqrt(velocity.x^2 + velocity.z^2))

			self.object:set_rotation({
				x = pitch,
				y = v_rotation.y,
				z = v_rotation.z
			})

			local yaw = self.user:get_look_horizontal()
			if yaw then
				self.object:set_yaw(yaw - pi / 2)
			end
		end

		-- remove attached arrows after lifetime
		if self._lifetimer <= 0 then
			self.object:remove()
			return
		end

		-- remove attached arrows after object dies
		if not self.object:get_attach() and self._attached_to.type == "object" then
			self.object:remove()
			return
		end

		-- arrow falls down when not attached to node any more
		if self._attached_to.type == "node" and self._attached and self._nodechecktimer <= 0 then
			local node = minetest.get_node(self._attached_to.pos)
			self._nodechecktimer = 0.5

			if not node then
				return
			end

			if node.name == "air" then
				self.object:set_velocity({x = 0, y = -3, z = 0})
				self.object:set_acceleration({x = 0, y = -3, z = 0})
				-- reset values
				self._attached = false
				self._attached_to.type = ""
				self._attached_to.pos = nil
				self.object:set_properties({collisionbox = {0, 0, 0, 0, 0, 0}})

				return
			end
		end

		while pointed_thing do
			local ip_pos = pointed_thing.intersection_point
			self.pointed_thing = pointed_thing
			local pointed_ref = pointed_thing.ref

			if pointed_thing.type == "object"
				and pointed_ref ~= self.object
				and pointed_ref:get_hp() > 0
				and ((pointed_ref:is_player() and pointed_ref:get_player_name() ~= self.user:get_player_name()) or
					(pointed_ref:get_luaentity() and pointed_ref:get_luaentity().physical and
					pointed_ref:get_luaentity().name ~= "__builtin:item"))
				and self.object:get_attach() == nil
			then
				if pointed_ref:is_player() then
					minetest.sound_play("nextgen_bows_arrow_successful_hit", {
						to_player = self.user:get_player_name(),
						gain = 0.3
					}, true)
				else
					minetest.sound_play("nextgen_bows_arrow_hit", {
						to_player = self.user:get_player_name(),
						gain = 0.6
					}, true)
				end

				self.object:set_velocity({x = 0, y = 0, z = 0})
				self.object:set_acceleration({x = 0, y = 0, z = 0})

				-- calculate damage
				local target_armor_groups = pointed_ref:get_armor_groups()
				local _damage = 0
				for group, base_damage in pairs(self._tool_capabilities.damage_groups) do
					_damage = _damage
						+ base_damage
						* limit(self._tflp / self._tool_capabilities.full_punch_interval, 0.0, 1.0)
						* ((target_armor_groups[group] or 0) + get_3d_armor_armor(pointed_ref)) / 100.0
				end

				-- crits
				if self._is_critical_hit then
					_damage = _damage * 2
				end

				-- knockback
				local dir = vector_normalize(vector_subtract(self._shot_from_pos, ip_pos))
				local distance = vector_distance(self._shot_from_pos, ip_pos)
				local knockback = minetest.calculate_knockback(
					pointed_ref,
					self.object,
					self._tflp,
					{
						full_punch_interval = self._tool_capabilities.full_punch_interval,
						damage_groups = {fleshy = _damage},
					},
					dir,
					distance,
					_damage
				)

				pointed_ref:add_velocity({
					x = dir.x * knockback * -1,
					y = 1,
					z = dir.z * knockback * -1
				})

				pointed_ref:punch(
					self.user,
					self._tflp,
					{
						full_punch_interval = self._tool_capabilities.full_punch_interval,
						damage_groups = {fleshy = _damage, knockback = knockback}
					},
					{
						x = dir.x * -1,
						y = 1,
						z = dir.z * -1
					}
				)

				self.object:remove()
				return

			elseif pointed_thing.type == "node" and not self._attached then
				local node = minetest.get_node(pointed_thing.under)
				local node_def = minetest.registered_nodes[node.name]

				if not node_def then
					return
				end

				self._velocity = self.object:get_velocity()

				if node_def.drawtype == "liquid" and not self._is_drowning then
					self._is_drowning = true
					self._in_liquid = true
					local drag = 1 / (node_def.liquid_viscosity * 6)
					self.object:set_velocity(vector_multiply(self._velocity, drag))
					self.object:set_acceleration({x = 0, y = -1.0, z = 0})

					nextgen_bows.particle_effect(self._old_pos, "bubble")
				elseif self._is_drowning then
					self._is_drowning = false

					if self._velocity then
						self.object:set_velocity(self._velocity)
					end

					self.object:set_acceleration({x = 0, y = -9.81, z = 0})
				end

			--	if nextgen_bows.mesecons and node.name == "nextgen_bows:target" then
				if node.name == "bluestone_button:button_stone_off" or node.name == "bluestone_button:button_wood_off" then
					local distance = vector_distance(pointed_thing.under, ip_pos)
					distance = floor(distance * 100) / 100

					-- only close to the center of the target will trigger signal
					if distance < 0.54 then
					--	mesecon.receptor_on(pointed_thing.under)
					--	minetest.get_node_timer(pointed_thing.under):start(2)

						mesecon.flipstate(pointed_thing.under, node)
						mesecon.receptor_on(pointed_thing.under, mesecon.rules.buttonlike_get(node))
						minetest.get_node_timer(pointed_thing.under):start(1)
					end
				end

				if node_def.walkable then
					self.object:set_velocity({x=0, y=0, z=0})
					self.object:set_acceleration({x=0, y=0, z=0})
					self.object:set_pos(ip_pos)
					self.object:set_rotation(self.object:get_rotation())
					self._attached = true
					self._attached_to.type = pointed_thing.type
					self._attached_to.pos = pointed_thing.under
					self.object:set_properties({collisionbox = {-0.2, -0.2, -0.2, 0.2, 0.2, 0.2}})

					-- remove last arrow when too many already attached
					local children = {}

					for _, object in ipairs(minetest.get_objects_inside_radius(pointed_thing.under, 1)) do
						if not object:is_player() and object:get_luaentity() and
								object:get_luaentity().name == "nextgen_bows:arrow_entity" then
							children[#children + 1] = object
						end
					end

					if #children >= 5 then
						children[1]:remove()
					end

					minetest.sound_play("nextgen_bows_arrow_hit", {
						pos = pointed_thing.under,
						gain = 0.6,
						max_hear_distance = 16
					}, true)

					return
				end
			end
			pointed_thing = ray:next()
		end

		self._old_pos = pos
	end
})
