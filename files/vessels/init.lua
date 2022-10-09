local S = minetest.get_translator("vessels")

local VER = "3"

local vessels_shelf_formspec =
	default.gui ..
	"item_image[0,-0.1;1,1;vessels:shelf]" ..
	"label[0.9,0.1;" .. S("Potion Shelf") .. "]" ..
	"list[context;vessels;0,1;9,2;]" ..
	"item_image[8,3.2;1,1;default:split_cell]" ..
	"list[context;split;8,3.2;1,1;]" ..
	"listring[context;vessels]" ..
	"listring[current_player;main]"

local function update_vessels_shelf(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local invlist = inv:get_list("vessels")
	if not invlist then
		inv:set_size("vessels", 9 * 2)
		inv:set_size("split", 1)
		invlist = inv:get_list("vessels")
	end

	local formspec = vessels_shelf_formspec
	-- Inventory slots overlay
	local vx, vy = 0, 1
	local n_potions, n_empty = 0, 0
	for i = 1, 18 do
		if i == 10 then
			vx = 0
			vy = vy + 1
		end
		formspec = formspec ..
			"image[" .. vx .. "," .. vy .. ";1,1;formspec_cell.png]"
		local stack = invlist[i]
		if stack:is_empty() then
			formspec = formspec ..
				"image[" .. vx .. "," .. vy .. ";1,1;vessels_shelf_slot.png]"
		else
			if minetest.get_item_group(stack:get_name(), "potion") > 0 then
				n_potions = n_potions + stack:get_count()
			else
				n_empty = n_empty + stack:get_count()
			end
		end
		vx = vx + 1
	end
	meta:set_string("formspec", formspec)
	if n_potions + n_empty == 0 then
		meta:set_string("infotext", S"Empty Potion Shelf")
	else
		meta:set_string("infotext", S"Potion Shelf" .. "\n(" ..
			S("Potions: @1", n_potions) .. ", " .. S("Bottles: @1", n_empty) .. ")")
	end
end

minetest.register_node("vessels:shelf", {
	description = S"Potion Shelf",
	tiles = {
		"default_wood.png",                   "default_wood.png",
		"default_wood.png",                   "default_wood.png",
		"default_wood.png^vessels_shelf.png", "default_wood.png^vessels_shelf.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {vessel = 1, cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("vessels", 9 * 2)
		inv:set_size("split", 1)
		update_vessels_shelf(pos)
		meta:set_string("version", VER)
	end,
	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("vessels")
	end,
	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		if not minetest.is_protected(pos, player:get_player_name()) and
				minetest.get_item_group(stack:get_name(), "vessel") ~= 0 then
			if listname == "split" then
				return 1
			else
				return stack:get_count()
			end
		end
		return 0
	end,
	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_move = function(pos, _, _, to_list, _, count, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		elseif to_list == "split" then
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
	description = S"Empty Glass Bottle",
	drawtype = "plantlike",
	tiles = {"[combine:64x64:0,4=vessels_glass_bottle.png"},
	wield_image = "vessels_glass_bottle.png",
	inventory_image = "vessels_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.35, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_craft({
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

-- LBM for updating Potion Shelf
minetest.register_lbm({
	label = "Potion Shelf updater",
	name = "vessels:shelf_updater_v" .. VER,
	nodenames = "vessels:shelf",
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_string("version") ~= VER then
			update_vessels_shelf(pos)
			meta:set_string("version", VER)
		end
	end
})
