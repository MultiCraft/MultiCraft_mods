local translator = minetest.get_translator
local S = translator and translator("3d_armor_stand") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local pi, vround = math.pi, vector.round

local armor_stand_formspec = default.gui ..
	"label[0.9,0.05;" .. S"Armor Stand" .. "]" ..
	"list[current_name;armor_head;3.5,1;1,1;]" ..
	"list[current_name;armor_legs;4.5,1;1,1;]" ..
	"list[current_name;armor_torso;3.5,2;1,1;]" ..
	"list[current_name;armor_feet;4.5,2;1,1;]" ..
	"image[3.5,1;1,1;formspec_cell.png^3d_armor_inv_helmet.png]" ..
	"image[4.5,1;1,1;formspec_cell.png^3d_armor_inv_leggings.png]" ..
	"image[3.5,2;1,1;formspec_cell.png^3d_armor_inv_chestplate.png]" ..
	"image[4.5,2;1,1;formspec_cell.png^3d_armor_inv_boots.png]"..
	"image[7.95,3.1;1.1,1.1;^[colorize:#D6D5E6]]"

local elements = {"head", "torso", "legs", "feet"}

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
	local objects = minetest.get_objects_inside_radius(pos, 0.5) or {}
	for _, obj in pairs(objects) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "3d_armor_stand:armor_entity" then
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

local function update_entity(pos)
	local node = minetest.get_node(pos)
	local object = get_stand_object(pos)
	if object then
		if not node.name:find("3d_armor_stand:") then
			object:remove()
			return
		end
	else
		object = minetest.add_entity(pos, "3d_armor_stand:armor_entity")
	end
	if object then
		local texture = "blank.png"
		local textures = {}
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local yaw = 0
		if inv then
			for _, element in pairs(elements) do
				local stack = inv:get_stack("armor_" .. element, 1)
				if stack:get_count() == 1 then
					local item = stack:get_name() or ""
					local def = stack:get_definition() or {}
					local groups = def.groups or {}
					if groups["armor_" .. element] then
						if def.texture then
							table.insert(textures, def.texture)
						else
							table.insert(textures, item:gsub("%:", "_") .. ".png")
						end
					end
				end
			end
		end
		if #textures > 0 then
			texture = table.concat(textures, "^")
		end
		if node.param2 then
			local rot = node.param2 % 4
			if rot == 1 then
				yaw = 3 * pi / 2
			elseif rot == 2 then
				yaw = pi
			elseif rot == 3 then
				yaw = pi / 2
			end
		end
		object:set_yaw(yaw)
		object:set_properties({textures={texture}})
	end
end

local function check_item(pos)
	local num = #minetest.get_objects_inside_radius(pos, 0.5)
	if num > 0 then return end
	update_entity(pos)
end


--
-- Armor Stand registration helper
--

local stand_nodes = {}
local function register_armor_stand(name, def)
	stand_nodes[#stand_nodes+1] = name

	minetest.register_craft({
		output = name,
		recipe = {
			{"", def.material, ""},
			{"", def.material, ""},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
		}
	})

	-- Allow almost everything to be overridden
	local default_fields = {
		drawtype = "mesh",
		mesh = "3d_armor_stand.b3d",
		paramtype = "light",
		paramtype2 = "facedir",
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
		},
		groups = {},

		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)
			local pn = placer and placer:get_player_name() or ""
			meta:set_string("infotext", S"Armor Stand" .. "\n" .. S("Owned by @1", S(pn)))
			local formspec = armor_stand_formspec ..
				"item_image[0,-0.1;1,1;" .. name .. "]"
			meta:set_string("formspec", formspec)
			local inv = meta:get_inventory()
			for _, element in pairs(elements) do
				inv:set_size("armor_" .. element, 1)
			end

			minetest.add_entity(pos, "3d_armor_stand:armor_entity")
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
			local pn = player and player:get_player_name() or ""
			if minetest.is_protected(pos, pn) then
				return 0
			end
			return stack:get_count()
		end,
		allow_metadata_inventory_move = function() return 0 end,
		on_metadata_inventory_put = update_entity,
		on_metadata_inventory_take = update_entity,
		after_destruct = update_entity,
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

	def.material = nil

	minetest.register_node(name, def)

	if mesecon and mesecon.register_mvps_stopper then
		mesecon.register_mvps_stopper(name)
	end
end


--
-- Register Stands
--

register_armor_stand("3d_armor_stand:armor_stand", {
	description = S"Apple Wood Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_wood"
})

register_armor_stand("3d_armor_stand:armor_stand_acacia_wood", {
	description = S"Acacia Wood Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_acacia.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_acacia_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_acacia_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_acacia_wood"
})

register_armor_stand("3d_armor_stand:armor_stand_birch_wood", {
	description = S"Birch Wood Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_birch.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_birch_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_birch_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_birch_wood"
})

register_armor_stand("3d_armor_stand:armor_stand_jungle_wood", {
	description = S"Jungle Wood Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_jungle.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_jungle_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_jungle_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_jungle_wood"
})

register_armor_stand("3d_armor_stand:armor_stand_pine_wood", {
	description = S"Pine Wood Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_pine.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_pine_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_pine_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_pine_wood"
})

register_armor_stand("3d_armor_stand:armor_stand_cherry_blossom_wood", {
	description = S"Cherry Blossom Wood Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_cherry_blossom.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_cherry_blossom_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_cherry_blossom_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_cherry_blossom_wood"
})

register_armor_stand("3d_armor_stand:armor_stand_ice", {
	description = S"Ice Armor Stand",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_ice.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_ice_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_ice_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_glass_defaults(),
	material = "default:fence_ice"
})


--
-- Entity
--

minetest.register_entity("3d_armor_stand:armor_entity", {
	physical = false,
	visual = "mesh",
	mesh = "3d_armor_entity.b3d",
	visual_size = {x = 1, y = 1},
	collisionbox = {0},
	textures = {"blank.png"},

	on_activate = function(self)
		local pos = self.object:get_pos()
		if pos then
			self.pos = vround(pos)
			update_entity(pos)
		end
	end
})

minetest.register_lbm({
	label = "Check Armor Stand",
	name = "3d_armor_stand:armor_stand",
	nodenames = stand_nodes,
	run_at_every_load = true,
	action = check_item
})
