local vessels_shelf_formspec =
	default.gui ..
	"background[-0.2,-0.26;9.41,9.49;formspec_shelf.png]" ..
	"item_image[0,-0.1;1,1;vessels:shelf]" ..
	"label[0.9,0.1;" .. Sl("Potion Shelf") .. "]" ..
	"list[context;vessels;0,1;9,2;]" ..
	"list[context;split;8,3.14;1,1;]" ..
	"listring[context;vessels]" ..
	"listring[current_player;main]"

local function update_vessels_shelf(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local invlist = inv:get_list("vessels")

	local formspec = vessels_shelf_formspec
	-- Inventory slots overlay
	local vx, vy = 0, 1
	local n_potions, n_empty = 0, 0
	for i = 1, 18 do
		if i == 10 then
			vx = 0
			vy = vy + 1
		end
		local stack = invlist[i]
		if stack:is_empty() then
			formspec = formspec ..
				"image[" .. vx .. "," .. vy .. ";1,1;vessels_shelf_slot.png]"
		else
			local vessel = minetest.registered_items[stack:get_name()] or {}
			if vessel and vessel.groups and vessel.groups.potion then
				n_potions = n_potions + stack:get_count()
			else
				n_empty = n_empty + stack:get_count()
			end
		end
		vx = vx + 1
	end
	meta:set_string("formspec", formspec)
	if n_potions + n_empty == 0 then
		meta:set_string("infotext", Sl("Empty Potion Shelf"))
	else
		meta:set_string("infotext", Sl("Potion Shelf") .. "\n(" ..
			Sl("Potions:") .. " " .. n_potions .. ", " .. Sl("Bottles:") .. " " .. n_empty .. ")")
	end
end

minetest.register_node("vessels:shelf", {
	description = "Potion Shelf",
	tiles = {"default_wood.png", "default_wood.png", "default_wood.png",
		"default_wood.png", "vessels_shelf.png", "vessels_shelf.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("vessels", 9 * 2)
		inv:set_size("split", 1)
		update_vessels_shelf(pos)
	end,
	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("vessels")
	end,
	allow_metadata_inventory_put = function(_, listname, _, stack)
		if minetest.get_item_group(stack:get_name(), "vessel") ~= 0 then
			if listname == "split" then
				return 1
			else
				return stack:get_count()
			end
		end
		return 0
	end,
	allow_metadata_inventory_move = function(_, _, _, to_list, _, count)
		if to_list == "split" then
			return 1
		end
		return count
	end,
	on_metadata_inventory_move = update_vessels_shelf,
	on_metadata_inventory_put = update_vessels_shelf,
	on_metadata_inventory_take = update_vessels_shelf,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "vessels", drops)
		drops[#drops + 1] = "vessels:shelf"
		minetest.remove_node(pos)
		return drops
	end
})

minetest.register_craft({
	output = "vessels:shelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:vessel", "group:vessel", "group:vessel"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_node("vessels:glass_bottle", {
	description = "Empty Glass Bottle",
	drawtype = "plantlike",
	tiles = {"vessels_glass_bottle.png"},
	inventory_image = "vessels_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_alias("potions:glass_bottle", "vessels:glass_bottle")

minetest.register_craft( {
	output = "vessels:glass_bottle 4",
	recipe = {
		{"", "", ""},
		{"default:glass", "", "default:glass"},
		{"", "default:glass", ""}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "vessels:shelf",
	burntime = 30
})
