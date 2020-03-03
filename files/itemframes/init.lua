minetest.register_entity("itemframes:item", {
	visual = "wielditem",
	visual_size = {x = 0.33, y = 0.33},
	collisionbox = {0},
	physical = false,

	on_activate = function(self, staticdata)
		local data = staticdata:split(";")
		self.texture = data and data[2] or "air"
		self.object:set_properties({textures = {self.texture}})
	end,

	get_staticdata = function(self)
		return self.texture and " " .. ";" .. self.texture or ""
	end
})

local pi = math.pi
local postab = {
	[2] = {{x =  1, y = 0, z =  0}, pi * 1.5},
	[3] = {{x = -1, y = 0, z =  0}, pi * 0.5},
	[4] = {{x =  0, y = 0, z =  1}, 0},
	[5] = {{x =  0, y = 0, z = -1}, pi}
}

local update_item = function(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	local param2 = node.param2
	if param2 < 2 or param2 > 5 then return end
	local posad = postab[param2][1]
	if item == "" or not posad then return end

	pos.x = pos.x + posad.x * 0.4
	pos.z = pos.z + posad.z * 0.4
	local entity = minetest.add_entity(pos, "itemframes:item")
	local ent = entity:get_luaentity()
	local item_name = ItemStack(item):get_name()

	ent.texture = item_name
	ent.object:set_properties({textures = {item_name}})
	if param2 ~= 4 then
		entity:set_yaw(postab[param2][2])
	end
end

local drop_item = function(pos)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end

	minetest.add_item(pos, item)
	meta:set_string("item", "")

	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "itemframes:item" then
			obj:remove()
			return
		end
	end
end

local function check_item(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end

	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "itemframes:item" then
			return
		end
	end

	update_item(pos, node)
end

local function after_dig_node(pos)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	if item == "" then return end
	drop_item(pos)
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
				minetest.sound_play({name = "default_place_node_hard", gain = 1},
						{pos = pointed_thing.above})
			end
		end
		return itemstack
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local pn = placer:get_player_name()
		meta:set_string("owner", pn)
		meta:set_string("infotext", Sl("Item frame") .. "\n" .. Sl("Owned by @1", Sl(pn)))
	end,

	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker or
		minetest.is_protected(pos, clicker:get_player_name()) then return end

		drop_item(pos)

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

	can_dig = function(pos, player)
		if minetest.is_protected(pos, player and player:get_player_name()) then
			return false
		end
		return true
	end,

	on_punch = check_item,
	after_dig_node = after_dig_node,
	on_destruct = after_dig_node
})

minetest.register_lbm({
	label = "Check Itemframe item",
	name = "itemframes:item",
	nodenames = {"itemframes:frame"},
	run_at_every_load = true,
	action = check_item
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
