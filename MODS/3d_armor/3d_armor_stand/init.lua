armor_stand = {
	S = minetest.get_translator("3d_armor_stand")
}

local S = armor_stand.S

local VER = "3"

local pi = math.pi
local tconcat = table.concat
local b = "blank.png"
local singleplayer = minetest.is_singleplayer()
local function objects_inside_radius(p)
	return minetest.get_objects_inside_radius(p, 0.5)
end

local ENTITY = "3d_armor_stand:armor_entity"

local function armor_stand_formspec(pos, name)
	local poss = pos.x .. "," .. pos.y .. "," .. pos.z

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local buf = string.buffer.new()
	buf:put(default.gui)
	buf:put("formspec_version[3]")
	buf:putf("item_image[0,-0.1;1,1;%s]", name)
	buf:putf("label[0.9,0.05;%s]", S("Armor Stand"))

	buf:put("item_image[3.5,0.5;1,1;default:cell]")
	buf:put("item_image[3.5,1.5;1,1;default:cell]")
	buf:put("item_image[3.5,2.5;1,1;default:cell]")
	buf:put("item_image[3.5,3.5;1,1;default:cell]")
	if inv:is_empty("armor_head", 1) then
		buf:put("image[3.5,0.5;1,1;3d_armor_inv_helmet.png]")
	end
	if inv:is_empty("armor_torso", 1) then
		buf:put("image[3.5,1.5;1,1;3d_armor_inv_chestplate.png]")
	end
	if inv:is_empty("armor_legs", 1) then
		buf:put("image[3.5,2.5;1,1;3d_armor_inv_leggings.png]")
	end
	if inv:is_empty("armor_feet", 1) then
		buf:put("image[3.5,3.5;1,1;3d_armor_inv_boots.png]")
	end
	buf:putf("list[nodemeta:%s;armor_head;3.5,0.5;1,1;]", poss)
	buf:putf("list[nodemeta:%s;armor_torso;3.5,1.5;1,1;]", poss)
	buf:putf("list[nodemeta:%s;armor_legs;3.5,2.5;1,1;]", poss)
	buf:putf("list[nodemeta:%s;armor_feet;3.5,3.5;1,1;]", poss)

	buf:put("image[4.33,2.1;0.8,0.8;3d_armor_stand_line_icon.png]")
	buf:put("item_image[5,2;1,1;default:cell]")
	if inv:is_empty("armor_wield", 1) then
		buf:put("image[5,2;1,1;3d_armor_stand_wield_icon.png]")
	end
	buf:putf("list[nodemeta:%s;armor_wield;5,2;1,1;]", poss)

	return buf:tostring()
end

local elements = {"head", "torso", "legs", "feet", "wield"}

local function drop_armor(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for _, element in pairs(elements) do
		local stack = inv:get_stack("armor_" .. element, 1)
		if stack and stack:get_count() > 0 then
			minetest.item_drop(stack, nil, pos)
			inv:set_stack("armor_" .. element, 1, nil)
		end
	end
end

local function get_stand_object(pos)
	local object
	local objects = objects_inside_radius(pos)
	for _, obj in pairs(objects) do
		local ent = obj:get_luaentity()
		if ent and ent.name == ENTITY then
			-- Remove duplicates
			if object then
				obj:remove()
			else
				object = obj
			end
		end
	end

	return object
end

local function update_entity(pos, node)
	local object = get_stand_object(pos) or minetest.add_entity(pos, ENTITY)
	object = object or minetest.add_entity(pos, ENTITY)
	if not object then return end

	local wield_texture = b
	local armor_textures = {}
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if not inv then return end

	for _, element in pairs(elements) do
		local stack = inv:get_stack("armor_" .. element, 1)
		if stack:get_count() == 1 then
			local item = stack:get_name() or ""
			local def = stack:get_definition()
			local groups = def and def.groups
			if groups and groups["armor_" .. element] then
				if def.texture then
					armor_textures[#armor_textures + 1] = def.texture
				else
					armor_textures[#armor_textures + 1] = item:gsub("%:", "_") .. ".png"
				end
			else
				wield_texture = def.inventory_image
			end
		end
	end

	local armor_texture = b
	if #armor_textures > 0 then
		armor_texture = tconcat(armor_textures, "^")
	end

	local param2 = node.param2 or 0
	local dir = minetest.facedir_to_dir(param2)
	local yaw = minetest.dir_to_yaw(dir) - pi
	object:set_yaw(yaw)

	object:set_properties({textures = {armor_texture, wield_texture}})
end

local function put_take(pos, _, _, _, player)
	local player_name = player:get_player_name()
	local node = minetest.get_node(pos)

	local fs = armor_stand_formspec(pos, node.name)
	minetest.show_formspec(player_name, "3d_armor_stand:fs", fs)

	update_entity(pos, node)
end

local function check_item(pos)
	local num = #objects_inside_radius(pos)
	if num > 0 then return end
	local node = minetest.get_node(pos)
	update_entity(pos, node)
end


--
-- Armor Stand registration helper
--

function armor_stand.register_armor_stand(name, def)
	minetest.register_craft({
		output = name,
		recipe = {
			{"", def.material, ""},
			{"", def.material, ""},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
		}
	})
	def.material = nil

	-- Allow almost everything to be overridden
	local default_fields = {
		drawtype = "mesh",
		mesh = "3d_armor_stand.b3d",
		use_texture_alpha = "clip",
		paramtype = "light",
		paramtype2 = "facedir",
		param2 = 1,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
		},

		on_rotate = function(pos, node, user, mode)
			if not minetest.is_protected(pos, user:get_player_name()) and mode == 1 then
				node.param2 = (node.param2 % 8) + 1
				if node.param2 > 3 then
					node.param2 = 0
				end
				minetest.swap_node(pos, node)
				update_entity(pos, node)

				return true
			end

			return false
		end,

		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)
			local pn = placer and placer:get_player_name() or ""
			local infotext = S("Armor Stand")
			if not singleplayer then
				infotext = infotext .. "\n" .. S("Owned by @1", pn)
			end
			meta:set_string("infotext", infotext)
			local inv = meta:get_inventory()
			for _, element in pairs(elements) do
				inv:set_size("armor_" .. element, 1)
			end

			minetest.add_entity(pos, ENTITY)
		end,

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("version", VER)
		end,

		on_rightclick = function(pos, node, clicker, itemstack)
			local player_name = clicker:get_player_name()
			if not minetest.is_protected(pos, player_name) then
				local fs = armor_stand_formspec(pos, node.name)
				minetest.show_formspec(player_name, "3d_armor_stand:fs", fs)
			end

			return itemstack
		end,

		can_dig = function(pos, player)
			local pn = player and player:get_player_name() or ""
			return not minetest.is_protected(pos, pn)
		end,

		on_dig = function(pos, node, player)
			local pn = player and player:get_player_name() or ""
			if not minetest.is_protected(pos, pn) then
				drop_armor(pos)
				minetest.node_dig(pos, node, player)
			end
		end,

		on_punch = check_item,

		allow_metadata_inventory_put = function(pos, listname, _, stack, player)
			local pn = player and player:get_player_name() or ""
			if minetest.is_protected(pos, pn) then
				return 0
			end

			local item = minetest.registered_tools[stack:get_name()]
			local group = item and item.groups
			if group then
				if listname == "armor_wield" then
					return 1
				end

				for _, element in pairs(elements) do
					if listname == "armor_" .. element and
							group["armor_" .. element] then
						return 1
					end
				end
			end

			return 0
		end,

		allow_metadata_inventory_take = function(pos, _, _, stack, player)
			if not minetest.is_protected(pos, player:get_player_name()) then
				return stack:get_count()
			end

			return 0
		end,

		allow_metadata_inventory_move = function() return 0 end,

		on_metadata_inventory_put = put_take,

		on_metadata_inventory_take = put_take,

		after_destruct = function(pos)
			local object = get_stand_object(pos)
			if object then
				object:remove()
			end
		end,

		on_blast = function(pos)
			drop_armor(pos)
			minetest.remove_node(pos)
		end
	}

	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end
	def.groups.armor_stand = 1

	minetest.register_node(name, def)

	if mesecon and mesecon.register_mvps_stopper then
		mesecon.register_mvps_stopper(name)
	end
end


--
-- Entity
--

minetest.register_entity(ENTITY, {
	physical = false,
	visual = "mesh",
	mesh = "3d_armor_entity.b3d",
	visual_size = {x = 1, y = 1},
	collisionbox = {0},
	textures = {b, b},

	on_activate = function(self)
		local pos = self.object:get_pos()
		if pos then
			local node = minetest.get_node(pos)
			if node.name:split(":")[1] == "3d_armor_stand" then
				update_entity(pos, node)
				return
			end
		end

		self.object:remove()
	end
})


--
-- LBM
--

minetest.register_lbm({
	label = "Check Armor Stand",
	name = "3d_armor_stand:armor_stand",
	nodenames = "group:armor_stand",
	run_at_every_load = true,
	action = check_item
})

-- LBM for updating Armor Stand
minetest.register_lbm({
	label = "Armor Stand updater",
	name = "3d_armor_stand:stand_updater_v" .. VER,
	nodenames = "group:armor_stand",
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_string("version") ~= VER then
			meta:set_string("version", VER)
			meta:set_string("formspec", "")

			meta:get_inventory():set_size("armor_wield", 1)
		end
	end
})

local path = minetest.get_modpath("3d_armor_stand")
dofile(path .. "/stands.lua")
