local tmp = {}

minetest.register_entity("itemframes:item",{
	visual = "wielditem",
	visual_size = {x = 0.33, y = 0.33},
	collisionbox = {0},
	physical = false,
	textures = {"blank.png"},

	on_activate = function(self, staticdata)
		if tmp.nodename and tmp.texture then
			self.nodename = tmp.nodename
			tmp.nodename = nil
			self.texture = tmp.texture
			tmp.texture = nil
		elseif staticdata and staticdata ~= "" then
			local data = staticdata:split(";")
			if data and data[1] and data[2] then
				self.nodename = data[1]
				self.texture = data[2]
			end
		end
		if self.texture then
			self.object:set_properties({textures = {self.texture}})
		end
	end,

	get_staticdata = function(self)
		if self.nodename and self.texture then
			return self.nodename .. ";" .. self.texture
		end
		return ""
	end
})

local facedir = {
	[2] = {x =  1, y = 0, z =  0},
	[3] = {x = -1, y = 0, z =  0},
	[4] = {x =  0, y = 0, z =  1},
	[5] = {x =  0, y = 0, z = -1}
}

local update_item = function(pos, node)
	local meta = minetest.get_meta(pos)
	local itemstring = meta:get_string("item")
	local posad = facedir[node.param2]
	if not posad or itemstring == "" then return end

	pos = vector.add(pos, vector.multiply(posad, 6.5/16))
	tmp.nodename = node.name
	tmp.texture = ItemStack(itemstring):get_name()

	local entity  = minetest.add_entity(pos, "itemframes:item")
	if node.param2 == 2 or node.param2 == 3 then
		local yaw = math.pi / 2 - node.param2 * math.pi * 2
		entity:set_yaw(yaw)
	end
end

local remove_item = function(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "itemframes:item" then
			obj:remove()
			break
		end
	end
end

local drop_item = function(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end

	minetest.add_item(pos, item)
	meta:set_string("item", "")
	remove_item(pos, node)
end

local function check_item(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end
	local found = false
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "itemframes:item" then
			found = true
			break
		end
	end
	if not found then
		update_item(pos, node)
	end
end

local function after_dig_node(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end
	if not node then
		local node = minetest.get_node(pos)
	end
	drop_item(pos, node)
end

minetest.register_node("itemframes:frame",{
	description = "Item frame",
	drawtype = "nodebox",
	node_box = {
		type = "wallmounted"
	},
	tiles = {"itemframe_background.png"},
	inventory_image = "itemframe_background.png",
	wield_image = "itemframe_background.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	node_placement_prediction = "",
	sunlight_propagates = true,
	groups = {choppy = 2, dig_immediate = 2, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local undery = pointed_thing.under.y
			local posy = pointed_thing.above.y
			if undery == posy then -- allowed wall-mounted only
				itemstack = minetest.item_place(itemstack, placer, pointed_thing)
			end
		end
		return itemstack
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local pn = placer:get_player_name()
		meta:set_string("owner", pn)
		meta:set_string("infotext", Sl("Item frame") .. "\n" .. Sl("Owned by @1", pn))
	end,

	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker or
		minetest.is_protected(pos, clicker:get_player_name()) then return end

		drop_item(pos, node)

		if not itemstack or itemstack:get_name() == "" then return end
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

	can_dig = function(pos, player)
		if minetest.is_protected(pos, player and player:get_player_name()) then
			return false
		end
		return true
	end,

	after_dig_node = after_dig_node,
	on_destruct = after_dig_node
})

minetest.register_lbm({
	label = "Check Itemframe item",
	name = "itemframes:item",
	nodenames = {"itemframes:frame"},
	run_at_every_load = true,
	action = function(pos, node)
		check_item(pos, node)
	end
})

-- Craft
minetest.register_craft({
	output = "itemframes:frame",
	recipe = {
		{"default:stick", "default:stick", "default:stick"},
		{"default:stick", "default:paper", "default:stick"},
		{"default:stick", "default:stick", "default:stick"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "itemframes:frame",
	burntime = 10
})
