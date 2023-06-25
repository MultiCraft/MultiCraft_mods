local S = minetest.get_translator("itemframes")

local pi = math.pi
local vadd, vmultiply = vector.add, vector.multiply
local wallmounted_to_dir = minetest.wallmounted_to_dir
local dir_to_yaw = minetest.dir_to_yaw
local singleplayer = minetest.is_singleplayer()

local NODE = "itemframes:frame"
local ENTITY = "itemframes:item"

minetest.register_entity(ENTITY, {
	visual = "wielditem",
	visual_size = {x = 0.33, y = 0.33},
	collisionbox = {0},
	physical = false,

	on_activate = function(self, staticdata)
		local ent = self.object

		-- remove entity with missing frames
		local node = minetest.get_node_or_nil(ent:get_pos())
		if not node or node.name ~= NODE then
			ent:remove()
			return
		end

		-- Compatible with the previous implementation
		local texture = staticdata
		if texture:sub(2, 2) == ";" then
			texture = texture:sub(3)
		end

		ent:set_properties({textures = {texture}})
		self.texture = texture
	end,

	get_staticdata = function(self)
		return self.texture or "air"
	end
})

local function update_rotation(entity, dir, rotation)
	entity:set_rotation({
		x = dir.y * pi / 2,
		y = dir_to_yaw(dir),
		z = rotation * pi / 4,
	})
end

local function update_item(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	local item_name = ItemStack(item):get_name()
	if item_name == "" then return end

	local param2 = node.param2 or 0
	if param2 < 0 or param2 > 5 then return end
	local dir = wallmounted_to_dir(param2)
	pos = vadd(pos, vmultiply(dir, 0.41))

	local entity = minetest.add_entity(pos, ENTITY, item_name)
	local rotation = meta:get_int("rotation")
	if param2 ~= 4 or rotation > 0 then
		update_rotation(entity, dir, rotation)
	end
end

local function find_entity(pos, remove)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	local entity
	for _, obj in ipairs(objects) do
		local ent = obj:get_luaentity()
		if ent and ent.name == ENTITY then
			-- remove entity duplicateы
			if remove or entity then
				obj:remove()
			else
				entity = obj
			end
		end
	end
	return entity
end

local function drop_item(pos)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")

	if item ~= "" then
		minetest.add_item(pos, item)
		meta:set_string("item", "")
		meta:set_string("rotation", "")
	end

	find_entity(pos, true)
end

local function check_item(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end

	if not find_entity(pos) then
		update_item(pos, node)
	end
end

local function after_dig_node(pos)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end
	drop_item(pos)
end

minetest.register_node(NODE,{
	description = S("Item frame"),
	drawtype = "nodebox",
	node_box = {
		type = "wallmounted",
		wall_side = {-0.5, -14/32, -14/32, -7/16, 14/32, 14/32}
	},
	tiles = {"itemframe.png"},
	inventory_image = "itemframe_inv.png",
	wield_image = "itemframe.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	groups = {choppy = 2, dig_immediate = 2, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),

	on_rotate = function(pos, node, _, mode, new_param2)
		if mode == screwdriver.ROTATE_FACE then
			-- Rotate the item clockwise when left-clicking
			local meta = minetest.get_meta(pos)
			local new_rotation = (meta:get_int("rotation") + 1) % 8
			if new_rotation == 0 then
				meta:set_string("rotation", "")
			else
				meta:set_int("rotation", new_rotation)
			end

			local entity = find_entity(pos)
			if entity then
				local param2 = node.param2 or 0
				if param2 < 0 or param2 > 5 then return end
				local dir = wallmounted_to_dir(param2)
				update_rotation(entity, dir, new_rotation)
			else
				update_item(pos, node)
			end

			return false
		end

		-- Otherwise just remove and replace the entity
		find_entity(pos, true)
		node.param2 = new_param2
		update_item(pos, node)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local pn = placer and placer:get_player_name() or ""
		local infotext = S("Item frame")
		if not singleplayer then
			infotext = infotext .. "\n" .. S("Owned by @1", pn)
		end
		meta:set_string("infotext", infotext)
	end,

	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker or
				minetest.is_protected(pos, clicker:get_player_name()) then
			return itemstack
		end

		drop_item(pos)

		if not itemstack or itemstack:get_name() == "" then
			return itemstack
		end
		local item = clicker:get_wielded_item():get_name() -- get real item name
		local meta = minetest.get_meta(pos)

		if minetest.registered_tools[item] then
			meta:set_string("item", itemstack:take_item():to_string())
		else
			meta:set_string("item", item)
			itemstack:take_item() -- take 1 item
		end

		update_item(pos, node)
		return itemstack
	end,

	on_punch = check_item,
	after_dig_node = after_dig_node,
	on_destruct = after_dig_node
})

minetest.register_lbm({
	label = "Check Itemframe item",
	name = "itemframes:check_item",
	nodenames = NODE,
	run_at_every_load = true,
	action = check_item
})

-- Craft
minetest.register_craft({
	output = NODE,
	recipe = {
		{"default:stick", "default:stick", "default:stick"},
		{"default:stick", "default:paper", "default:stick"},
		{"default:stick", "default:stick", "default:stick"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = NODE,
	burntime = 10
})

-- MVPS Stopper
if mesecon and mesecon.register_mvps_stopper then
	mesecon.register_mvps_stopper(NODE)
	mesecon.register_mvps_unmov(ENTITY)
end
