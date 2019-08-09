ARMOR_LEVEL_MULTIPLIER = 1
ARMOR_HEAL_MULTIPLIER = 1

local armor_def = setmetatable({}, {
	__index = function()
		return setmetatable({
			groups = setmetatable({}, {
				__index = function()
					return 0
				end})
			}, {
			__index = function()
				return 0
			end
		})
	end,
})
local armor_textures = setmetatable({}, {
	__index = function()
		return setmetatable({}, {
			__index = function()
				return "blank.png"
			end
		})
	end
})

armor = {
	player_hp = {},
	elements = {"head", "torso", "legs", "feet"},
	physics = {"jump", "speed", "gravity"},
	--[[formspec = "size[8,8.5]list[detached:player_name_armor;armor;0,1;2,3;]"
		.."image[2,0.75;2,4;armor_preview]"
		.."list[current_player;main;0,4.5;8,4;]"
		.."list[current_player;craft;4,1;3,3;]"
		.."list[current_player;craftpreview;7,2;1,1;]",]]
	def = armor_def,
	textures = armor_textures,
	default_skin = "character"
}

-- Armor Registration

armor.register_armor = function(self, name, def)
	minetest.register_tool(name, def)
end

armor.register_armor_group = function(self, group, base)
	base = base or 100
	self.registered_groups[group] = base
end

armor.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	if self.textures[name] then
		player_api.set_textures(player, {
			self.textures[name].skin,
			self.textures[name].armor,
			self.textures[name].wielditem,
			self.textures[name].cube,
		})
	end
end

armor.set_player_armor = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local armor_inv = self:get_armor_inventory(player)
	if not name then
		minetest.log("error", "Failed to read player name")
		return
	elseif not armor_inv then
		minetest.log("error", "Failed to read player inventory")
		return
	end
	local armor_texture = "blank.png"
	local armor_level = 0
	local armor_heal = 0
	local state = 0
	local items = 0
	local elements = {}
	local textures = {}
	local physics_o = {speed=1,gravity=1,jump=1}
	local material = {type=nil, count=1}
	--local preview = armor:get_player_skin(name).."_preview.png"
	for _,v in ipairs(self.elements) do
		elements[v] = false
	end
	for i=1, 4 do
		local stack = armor_inv:get_stack("armor", i)
		local item = stack:get_name()
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			for k, v in pairs(elements) do
				if v == false then
					local level = def.groups["armor_"..k]
					if level then
						local texture = item:gsub("%:", "_")
						table.insert(textures, texture..".png")
						--preview = preview.."^"..texture.."_preview.png"
						armor_level = armor_level + level
						state = state + stack:get_wear()
						items = items + 1
						local heal = def.groups["armor_heal"] or 0
						armor_heal = armor_heal + heal
						for kk,vv in ipairs(self.physics) do
							local o_value = def.groups["physics_"..vv]
							if o_value then
								physics_o[vv] = physics_o[vv] + o_value
							end
						end
						local mat = string.match(item, "%:.+_(.+)$")
						if material.type then
							if material.type == mat then
								material.count = material.count + 1
							end
						else
							material.type = mat
						end
						elements[k] = true
					end
				end
			end
		end
	end
	if material.type and material.count == #self.elements then
		armor_level = armor_level * 1.1
	end
	armor_level = armor_level * ARMOR_LEVEL_MULTIPLIER
	armor_heal = armor_heal * ARMOR_HEAL_MULTIPLIER
	if #textures > 0 then
		armor_texture = table.concat(textures, "^")
	end
	local armor_groups = {fleshy=100}
	if armor_level > 0 then
		armor_groups.level = math.floor(armor_level / 20)
		armor_groups.fleshy = 100 - armor_level
	end
	player:set_armor_groups(armor_groups)
	player:set_physics_override(physics_o)
	self.textures[name].armor = armor_texture
	--self.textures[name].preview = preview
	self.def[name].state = state
	self.def[name].count = items
	self.def[name].level = armor_level
	self.def[name].heal = armor_heal
	self.def[name].jump = physics_o.jump
	self.def[name].speed = physics_o.speed
	self.def[name].gravity = physics_o.gravity
	self:update_player_visuals(player)
end

armor.update_armor = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local hp = player:get_hp() or 0
	if hp == 0 then
		return
	end

	local armor_inv = self:get_armor_inventory(player)
	if not armor_inv then
		minetest.log("error", "Failed to read detached inventory")
		return
	end
	local state = 0
	local items = 0
	for i=1, 4 do
		local stack = armor_inv:get_stack("armor", i)
		if stack:get_count() > 0 then
			local use = stack:get_definition().groups["armor_use"] or 0
			local item = stack:get_name()
			stack:add_wear(use)
			armor_inv:set_stack("armor", i, stack)
			state = state + stack:get_wear()
			items = items + 1
			if stack:get_count() == 0 then
				local desc = minetest.registered_items[item].description
				if desc then
					minetest.chat_send_player(name, "Your "..desc.." got destroyed!")
				end
				self:set_player_armor(player)
				armor:update_inventory(player)
			end
		end
	end
	self:save_armor_inventory(player)
	self.def[name].state = state
	self.def[name].count = items
end

armor.get_player_skin = function(self, name)
	local skin = nil
	if skins then
		skin = skins.skins[name]
	end
	return skin or armor.default_skin
end

armor.get_armor_formspec = function(self, name)
	local formspec = armor.formspec:gsub("player_name", name)
	--formspec = formspec:gsub("armor_preview", armor.textures[name].preview)
	formspec = formspec:gsub("armor_level", armor.def[name].level)
	return formspec:gsub("armor_heal", armor.def[name].heal)
end

armor.update_inventory = function(self, player) end

armor.get_armor_inventory = function(self, player)
	local name = player:get_player_name()
	if name then
		return minetest.get_inventory({type="detached", name=name.."_armor"})
	end
end

armor.serialize_inventory_list = function(self, list)
	local list_table = {}
	for _, stack in ipairs(list) do
		table.insert(list_table, stack:to_string())
	end
	return minetest.serialize(list_table)
end

armor.deserialize_inventory_list = function(self, list_string)
	local list_table = minetest.deserialize(list_string)
	local list = {}
	for _, stack in ipairs(list_table or {}) do
		table.insert(list, ItemStack(stack))
	end
	return list
end

armor.load_armor_inventory = function(self, player)
	local inv = self:get_armor_inventory(player)
	if inv then
		local armor_list_string = player:get_attribute("3d_armor_inventory")
		if armor_list_string then
			inv:set_list("armor",
				self:deserialize_inventory_list(armor_list_string))
			return true
		end
	end
end

armor.save_armor_inventory = function(self, player)
	local inv = self:get_armor_inventory(player)
	if inv then
		player:set_attribute("3d_armor_inventory",
			self:serialize_inventory_list(inv:get_list("armor")))
	end
end
