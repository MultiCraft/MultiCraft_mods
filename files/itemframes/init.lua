local translator = minetest.get_translator
local S = translator and translator("itemframes") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

minetest.register_entity("itemframes:item", {
	visual = "wielditem",
	visual_size = {x = 0.33, y = 0.33},
	collisionbox = {0},
	physical = false,

	on_activate = function(self, staticdata)
		local ent = self.object

		-- remove entity for missing frames
		local node = minetest.get_node_or_nil(ent:get_pos())
		if not node or node.name ~= "itemframes:frame" then
			ent:remove()
			return
		end

		local data = staticdata:split(";")

		ent:set_properties({textures = {data[2]}})
		self.texture = data[2]
	end,

	get_staticdata = function(self)
		local texture = self.texture or "air"
		return " ;" .. texture
	end
})

local pi = math.pi
local postab = {
	[2] = {{x =  0.41, z =  0}, pi * 1.5},
	[3] = {{x = -0.41, z =  0}, pi * 0.5},
	[4] = {{x =  0,    z =  0.41}, 0},
	[5] = {{x =  0,    z = -0.41}, pi}
}

local update_item = function(pos, node)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")
	local item_name = ItemStack(item):get_name()
	if item_name == "" then return end

	local param2 = node.param2 or 0
	if param2 < 2 or param2 > 5 then return end
	local posad = postab[param2][1]
	pos.x = pos.x + posad.x
	pos.z = pos.z + posad.z

	-- Strange to stay compatible with the previous implementation
	local staticdata = " ;" .. item_name

	local entity = minetest.add_entity(pos, "itemframes:item", staticdata)
	if param2 ~= 4 then
		entity:set_yaw(postab[param2][2])
	end
end

local drop_item = function(pos)
	local meta = minetest.get_meta(pos)
	local item = meta:get_string("item")

	if item ~= "" then
		minetest.add_item(pos, item)
		meta:set_string("item", "")
	end

	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "itemframes:item" then
			obj:remove()
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
	description = S"Item frame",
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
	node_placement_prediction = "",
	sunlight_propagates = true,
	groups = {choppy = 2, dig_immediate = 2, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),
	on_rotate = false,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local pt_above = pointed_thing.above
			local undery = pointed_thing.under.y
			local abovey = pt_above.y
			if undery == abovey then -- allowed wall-mounted only
				itemstack = minetest.item_place(itemstack, placer, pointed_thing)
				minetest.sound_play({name = "default_place_node_hard"},
						{pos = pt_above})
			end
		end
		return itemstack
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local pn = placer and placer:get_player_name() or ""
		meta:set_string("infotext", S"Item frame" .. "\n" .. S("Owned by @1", S(pn)))
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

	can_dig = function(pos, player)
		if not player or
				minetest.is_protected(pos, player:get_player_name()) then
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

-- MVPS Stopper
if mesecon and mesecon.register_mvps_stopper then
	mesecon.register_mvps_stopper("itemframes:frame")
end
