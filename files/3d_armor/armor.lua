ARMOR_INIT_DELAY = 1
ARMOR_INIT_TIMES = 1
ARMOR_BONES_DELAY = 1
ARMOR_UPDATE_TIME = 1
ARMOR_DROP = minetest.get_modpath("bones") ~= nil
ARMOR_DESTROY = false
ARMOR_LEVEL_MULTIPLIER = 1
ARMOR_HEAL_MULTIPLIER = 1

local modpath = minetest.get_modpath(ARMOR_MOD_NAME)
local worldpath = minetest.get_worldpath()
local input = io.open(modpath.."/armor.conf", "r")
if input then
    dofile(modpath.."/armor.conf")
    input:close()
    input = nil
end
input = io.open(worldpath.."/armor.conf", "r")
if input then
    dofile(worldpath.."/armor.conf")
    input:close()
    input = nil
end

local time = 0

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
    physics = {"jump","speed","gravity"},
    --[[formspec = "size[8,8.5]list[detached:player_name_armor;armor;0,1;2,3;]"
        .."image[2,0.75;2,4;armor_preview]"
        .."list[current_player;main;0,4.5;8,4;]"
        .."list[current_player;craft;4,1;3,3;]"
        .."list[current_player;craftpreview;7,2;1,1;]",]]
    def = armor_def,
    textures = armor_textures,
    default_skin = "character",
}

--[[if inventory_plus then
    armor.formspec = "size[8,8.5]button[0,0;2,0.5;main;Back]"
        .."list[detached:player_name_armor;armor;0,1;2,3;]"
        .."image[2.5,0.75;2,4;armor_preview]"
        .."label[5,1;Level: armor_level]"
        .."label[5,1.5;Heal:  armor_heal]"
        .."list[current_player;main;0,4.5;8,4;]"
elseif unified_inventory then
    unified_inventory.register_button("armor", {
        type = "image",
        image = "inventory_plus_armor.png",
    })
    unified_inventory.register_page("armor", {
        get_formspec = function(player)
            local name = player:get_player_name()
            local formspec = "background[0.06,0.99;7.92,7.52;3d_armor_ui_form.png]"
                .."label[0,0;Armor]"
                .."list[detached:"..name.."_armor;armor;0,1;2,3;]"
                .."image[2.5,0.75;2,4;"..armor.textures[name].preview.."]"
                .."label[5,1;Level: "..armor.def[name].level.."]"
                .."label[5,1.5;Heal:  "..armor.def[name].heal.."]"
            return {formspec=formspec}
        end,
    })
end]]

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
    local armor_texture = "3d_armor_trans.png"
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
    --[[if minetest.get_modpath("shields") then
        armor_level = armor_level * 0.9
    end]]
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
    elseif u_skins then
        skin = u_skins.u_skins[name]
    end
    return skin or armor.default_skin
end

armor.get_armor_formspec = function(self, name)
    local formspec = armor.formspec:gsub("player_name", name)
    --formspec = formspec:gsub("armor_preview", armor.textures[name].preview)
    formspec = formspec:gsub("armor_level", armor.def[name].level)
    return formspec:gsub("armor_heal", armor.def[name].heal)
end

--[[armor.update_inventory = function(self, player)
    local name = player:get_player_name()
    if unified_inventory then
        if unified_inventory.current_page[name] == "armor" then
            unified_inventory.set_inventory_formspec(player, "armor")
        end
    else
        local formspec = armor:get_armor_formspec(name)
        if inventory_plus then
            local page = player:get_inventory_formspec()
            if page:find("detached:"..name.."_armor") then
                inventory_plus.set_inventory_formspec(player, formspec)
            end
        else
            player:set_inventory_formspec(formspec)
        end
    end
end]]
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

-- Register Player Model

player_api.register_model("3d_armor_character.b3d", {
    animation_speed = 30,
    textures = {
        armor.default_skin..".png",
        "3d_armor_trans.png",
        "3d_armor_trans.png",
    },
    animations = {
        stand = {x=0, y=79},
        lay = {x=162, y=166},
        walk = {x=168, y=187},
        mine = {x=189, y=198},
        walk_mine = {x=200, y=219},
        sit = {x=81, y=160},
    },
})

-- Register Callbacks

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    --if inventory_plus and fields.armor then
        --local formspec = armor:get_armor_formspec(name)
        --inventory_plus.set_inventory_formspec(player, formspec)
        --return
    --end
    for field, _ in pairs(fields) do
        if string.find(field, "skins_set_") then
            minetest.after(0, function(player)
                local skin = armor:get_player_skin(name)
                armor.textures[name].skin = skin..".png"
                armor:set_player_armor(player)
            end, player)
        end
    end
end)

minetest.register_on_joinplayer(function(player)
    player_api.set_model(player, "3d_armor_character.b3d")
    local name = player:get_player_name()
    local armor_inv = minetest.create_detached_inventory(name.."_armor",{
        allow_put = function(inv, listname, index, stack, player)
            local item = stack:get_name()
            if not minetest.registered_items[item] then return end
            if not minetest.registered_items[item].groups then return end
            if  minetest.registered_items[item].groups['armor_head']
            and index == 1
            then
                return 1
            end
            if  minetest.registered_items[item].groups['armor_torso']
            and index == 2
            then
                return 1
            end
            if  minetest.registered_items[item].groups['armor_legs']
            and index == 3
            then
                return 1
            end
            if  minetest.registered_items[item].groups['armor_feet']
            and index == 4
            then
                return 1
            end
            return 0
        end,
        on_put = function(inv, listname, index, stack, player)
            armor:save_armor_inventory(player)
            armor:set_player_armor(player)
            --armor:update_inventory(player)
        end,
        on_take = function(inv, listname, index, stack, player)
            armor:save_armor_inventory(player)
            armor:set_player_armor(player)
            --armor:update_inventory(player)
        end,
        on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
            armor:save_armor_inventory(player)
            armor:set_player_armor(player)
            --armor:update_inventory(player)
        end,
        allow_take = function(inv, listname, index, stack, player)
            return stack:get_count()
        end,
        allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
            return 0
        end,
    })
    --[[if inventory_plus then
        inventory_plus.register_button(player,"armor", "Armor")
    end]]

    armor_inv:set_size("armor", 4)
	if not armor:load_armor_inventory(player) then
		local player_inv = player:get_inventory()
		if player_inv then
			player_inv:set_size("armor", 4)
			for i=1, 4 do
				local stack = player_inv:get_stack("armor", i)
				armor_inv:set_stack("armor", i, stack)
			end
			player_inv:set_size("armor", 0)
		end
		armor:save_armor_inventory(player)
	end

    armor.player_hp[name] = 0
    armor.def[name] = {
        state = 0,
        count = 0,
        level = 0,
        heal = 0,
        jump = 1,
        speed = 1,
        gravity = 1,
    }
    armor.textures[name] = {
        skin = armor.default_skin..".png",
        armor = "3d_armor_trans.png",
        wielditem = "3d_armor_trans.png",
        preview = armor.default_skin.."_preview.png",
    }
    if minetest.get_modpath("skins") then
        local skin = skins.skins[name]
        if skin and skins.get_type(skin) == skins.type.MODEL then
            armor.textures[name].skin = skin..".png"
        end
    elseif minetest.get_modpath("simple_skins") then
        local skin = skins.skins[name]
        if skin then
            armor.textures[name].skin = skin..".png"
        end
    --[[elseif minetest.get_modpath("u_skins") then
        local skin = u_skins.u_skins[name]
        if skin and u_skins.get_type(skin) == u_skins.type.MODEL then
            armor.textures[name].skin = skin..".png"
        end]]
    end
    if minetest.get_modpath("player_textures") then
        local filename = minetest.get_modpath("player_textures").."/textures/player_"..name
        local f = io.open(filename..".png")
        if f then
            f:close()
            armor.textures[name].skin = "player_"..name..".png"
        end
    end
    for i=1, ARMOR_INIT_TIMES do
        minetest.after(ARMOR_INIT_DELAY * i, function(player)
            armor:set_player_armor(player)
            --if inventory_plus == nil and unified_inventory == nil then
                --armor:update_inventory(player)
            --end
        end, player)
    end
end)

if ARMOR_DROP == true or ARMOR_DESTROY == true then
    minetest.register_on_dieplayer(function(player)
        local name = player:get_player_name()
        local pos = player:get_pos()
        if name and pos then
            local drop = {}
            local armor_inv = self:get_armor_inventory(player)
			if armor_inv then
				for i=1, armor_inv:get_size("armor") do
					local stack = armor_inv:get_stack("armor", i)
					if stack:get_count() > 0 then
						table.insert(drop, stack)
						armor_inv:set_stack("armor", i, nil)
					end
				end
			end
			armor:save_armor_inventory(player)
			armor:set_player_armor(player)
            --[[if unified_inventory then
                unified_inventory.set_inventory_formspec(player, "craft")
            elseif inventory_plus then
                local formspec = inventory_plus.get_formspec(player,"main")
                inventory_plus.set_inventory_formspec(player, formspec)
            else
                armor:update_inventory(player)
            end]]
            if ARMOR_DESTROY == false then
                if minetest.get_modpath("bones") then
                    minetest.after(ARMOR_BONES_DELAY, function()
                        pos = vector.round(pos)
                        local node = minetest.get_node(pos)
                        if node.name == "bones:bones" then
                            local meta = minetest.get_meta(pos)
                            local owner = meta:get_string("owner")
                            local inv = meta:get_inventory()
                            if name == owner then
                                for _,stack in ipairs(drop) do
                                    if inv:room_for_item("main", stack) then
                                        inv:add_item("main", stack)
                                    end
                                end
                            end
                        end
                    end)
                else
                    for _,stack in ipairs(drop) do
                        local obj = minetest.add_item(pos, stack)
                        if obj then
                            local x = math.random(1, 5)
                            if math.random(1,2) == 1 then
                                x = -x
                            end
                            local z = math.random(1, 5)
                            if math.random(1,2) == 1 then
                                z = -z
                            end
                            obj:setvelocity({x=1/x, y=obj:get_velocity().y, z=1/z})
                        end
                    end
                end
            end
        end
    end)
end

minetest.register_on_player_hpchange(function(player, hp_change)
	if player and hp_change < 0 then
		local name = player:get_player_name()
		if name then
			if armor.def[name].heal > math.random(100) then
				hp_change = 0
		    end
		end
		armor:update_armor(player)
	end
	return hp_change
end)
