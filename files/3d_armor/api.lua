local ARMOR_LEVEL_MULTIPLIER = 1
local ARMOR_HEAL_MULTIPLIER = 1
local enable_damage = minetest.settings:get_bool("enable_damage")

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

armor.register_armor = function(_, name, def)
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
			self.textures[name].cube
		})
	end
end

if enable_damage then
	hud.register("armor", {
		hud_elem_type = "statbar",
		position      = {x = 0.5,  y = 1},
		alignment     = {x = -1,   y = -1},
		offset        = {x = -247, y = -120},
		size          = {x = 24,   y = 24},
		text          = "3d_armor_statbar_fg.png",
		background    = "3d_armor_statbar_bg.png",
		number        = 0,
		max           = 20,
		autohide_bg   = true
	})
end

armor.set_player_armor = function(self, player)
	local name = player:get_player_name()
	local armor_inv = self:get_armor_inventory(player)
	if not name then
		minetest.log("error", "Failed to read player name")
		return
	elseif not armor_inv then
		minetest.log("error", "Failed to read player inventory")
		return
	end
	local armor_level = 0
	local armor_heal = 0
	local state = 0
	local count = 0
	local texture = "blank.png"
	local physics = {speed = 1, gravity = 1, jump = 1}
	local material = {type=nil, count=1}
--	local preview = armor:get_player_skin(name).."_preview.png"
	local list = {"1", "3", "2", "4"}
	for _, number in pairs(list) do
		local stack = armor_inv:get_stack("armor", number)
		if stack:get_count() == 1 then
			local stack = armor_inv:get_stack("armor", number)
			local item = stack:get_name()
			if stack:get_count() == 1 then
				local def = stack:get_definition()
				for _, element in pairs(self.elements) do
					local level = def.groups["armor_"..element]
					if level then
						local tex = def.texture or item:gsub("%:", "_")
						tex = tex:gsub(".png$", "")
						local prev = def.preview or tex.."_preview"
						prev = prev:gsub(".png$", "")
						texture = texture.."^"..tex..".png"
					--	preview = preview.."^"..prev..".png"
						armor_level = armor_level + level
						state = state + stack:get_wear()
						count = count + 1
						local heal = def.groups["armor_heal"] or 0
						armor_heal = armor_heal + heal
						for _, phys in pairs(self.physics) do
							local value = def.groups["physics_"..phys] or 0
							physics[phys] = physics[phys] + value
						end
						local mat = string.match(item, "%:.+_(.+)$")
						if material.name then
							if material.name == mat then
								material.count = material.count + 1
							end
						else
							material.name = mat
						end
					end
				end
			end
		end
	end
	if material.name and material.count == #self.elements then
		armor_level = armor_level * 1.1
	end
	armor_level = armor_level * ARMOR_LEVEL_MULTIPLIER
	armor_heal = armor_heal * ARMOR_HEAL_MULTIPLIER
	local armor_groups = {fleshy = 100}
	if armor_level > 0 then
		armor_groups.level = math.floor(armor_level / 20)
		armor_groups.fleshy = 100 - armor_level
	end
	player:set_armor_groups(armor_groups)
	player:set_physics_override(physics)
	self.textures[name].armor = texture
--	self.textures[name].preview = preview
	self.def[name].state = state
	self.def[name].count = count
	self.def[name].level = armor_level
	self.def[name].heal = armor_heal
	self.def[name].jump = physics.jump
	self.def[name].speed = physics.speed
	self.def[name].gravity = physics.gravity
	self:update_player_visuals(player)

	if enable_damage then
		local max_level = 95 -- full diamond armor
		local armor_lvl = math.floor(20 * (armor_level/max_level)) or 0
		hud.change_item(player, "armor", {number = armor_lvl})
	end
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
	local count = 0
	local list = armor_inv:get_list("armor")
	if type(list) ~= "table" then
		return
	end
	for i, stack in pairs(list) do
		if stack:get_count() == 1 then
			local use = stack:get_definition().groups["armor_use"] or 0
			local item = stack:get_name()
			stack:add_wear(use)
			armor_inv:set_stack("armor", i, stack)
			state = state + stack:get_wear()
			count = count + 1
			if stack:get_count() == 0 then
				local desc = minetest.registered_items[item].description
				if name and desc then
					minetest.chat_send_player(name, Sl("Your @1 got destroyed!", desc))
				end
				self:set_player_armor(player)
			end
		end
	end
	self:save_armor_inventory(player)
	self.def[name].state = state
	self.def[name].count = count
end

--[[armor.get_player_skin = function(self, name)
	local skin = nil
	if skins then
		skin = skins.skins[name]
	end
	return skin or armor.default_skin
end

armor.get_armor_formspec = function(self, name)
	local formspec = armor.formspec:gsub("player_name", name)
--	formspec = formspec:gsub("armor_preview", armor.textures[name].preview)
	formspec = formspec:gsub("armor_level", armor.def[name].level)
	return formspec:gsub("armor_heal", armor.def[name].heal)
end]]

armor.get_armor_inventory = function(_, player)
	local name = player:get_player_name()
	if name then
		return minetest.get_inventory({type="detached", name=name.."_armor"})
	end
end

armor.serialize_inventory_list = function(_, list)
	local list_table = {}
	for _, stack in ipairs(list) do
		table.insert(list_table, stack:to_string())
	end
	return minetest.serialize(list_table)
end

armor.deserialize_inventory_list = function(_, list_string)
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
