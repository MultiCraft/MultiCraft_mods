local S = default.S
local C = default.colors

local esc = minetest.formspec_escape

local function formspec_string(lpp, page, lines, string)
	for i = ((lpp * page) - lpp) + 1, lpp * page do
		if not lines[i] then break end
		string = string .. lines[i] .. "\n"
	end
	return string
end

local lpp = 14 -- Lines per book's page
local function book_on_use(itemstack, user)
	local player_name = user:get_player_name()
	local meta = itemstack:get_meta()
	local title, text, owner = "", "", player_name
	local page, page_max, lines, string = 1, 1, {}, ""

	-- Backwards compatibility
	local old_data = minetest.deserialize(itemstack:get_metadata())
	if old_data then
		meta:from_table({fields = old_data})
	end

	local data = meta:to_table().fields

	if data.owner then
		title = data.title or ""
		text = data.text or ""
		owner = data.owner

		for str in (text .. "\n"):gmatch("([^\n]*)[\n]") do
			lines[#lines + 1] = str
		end

		if data.page then
			page = data.page
			page_max = data.page_max
			string = formspec_string(lpp, page, lines, string)
		end
	end

	local item_name = itemstack:get_name()
	local formspec = "size[9,8.75]" ..
		default.gui_bg .. default.gui_bg_img ..
		"image_button_exit[8.4,-0.1;0.75,0.75;close.png;exit;;true;false;close_pressed.png]" ..
		"item_image[0,-0.1;1,1;" .. item_name .. "]"

	if owner == player_name then
		formspec = formspec ..
			"label[0.9,0.1;" .. esc(S("Book")) .. "]" ..
			"field[0.5,1.8;8.5,0;title;" .. esc(S("Title:")) .. ";" ..
				esc(title) .. "]" ..
			"textarea[0.5,2.25;8.6,6.75;text;" .. esc(S("Contents:")) .. ";" ..
				esc(text) .. "]" ..
			"button_exit[3,8.1;3,1;save;" .. esc(S("Save")) .. "]"
	else
		formspec = formspec ..
			"label[0.9,0.1;" .. esc(S("Book")) .. ": " ..
				C.gold .. "\"" .. esc(title) .. "\", " ..
				C.white .. esc(S("by @1", owner)) .. "]" ..
			"textarea[0.5,0.9;8.5,8;;" .. esc(string ~= "" and string or text) .. ";]" ..
			"button[2.4,8;0.8,0.8;book_prev;<]" ..
			"image_button[3,8;3,0.8;blank.png;;" ..
				S("Page: @1 of @2", page, page_max) .. ";false;false;]" ..
				"button[5.8,8;0.8,0.8;book_next;>]"
	end

	minetest.show_formspec(player_name, "default:book", formspec)
	return itemstack
end

local max_text_size = 10000
local max_title_size = 50
local short_title_size = 30
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "default:book" then return end
	local inv = player:get_inventory()
	local stack = player:get_wielded_item()

	if fields.save and fields.title and fields.text
			and fields.title ~= "" and fields.text ~= "" then
		local new_stack, data
		if stack:get_name() ~= "default:book_written" then
			local count = stack:get_count()
			if count == 1 then
				stack:set_name("default:book_written")
			else
				stack:set_count(count - 1)
				new_stack = ItemStack("default:book_written")
			end
		else
			data = stack:get_meta():to_table().fields
		end

		if data and data.owner and data.owner ~= player:get_player_name() then
			return
		end

		if not data then data = {} end
		data.title = fields.title:sub(1, max_title_size)
		data.owner = player:get_player_name()
		local short_title = data.title
		-- Don't bother triming the title if the trailing dots would make it longer
		if #short_title > short_title_size + 3 then
			short_title = short_title:sub(1, short_title_size) .. "..."
		end
		data.description = S("\"@1\" by @2", short_title, data.owner)
		data.text = fields.text:sub(1, max_text_size)
		data.text = data.text:gsub("\r\n", "\n"):gsub("\r", "\n")
		data.page = 1
		data.page_max = math.ceil((#data.text:gsub("[^\n]", "") + 1) / lpp)

		if new_stack then
			new_stack:get_meta():from_table({fields = data})
			if inv:room_for_item("main", new_stack) then
				inv:add_item("main", new_stack)
			else
				minetest.add_item(player:get_pos(), new_stack)
			end
		else
			stack:get_meta():from_table({fields = data})
		end

	elseif fields.book_next or fields.book_prev then
		local data = stack:get_meta():to_table().fields
		if not data or not data.page then
			return
		end

		data.page = tonumber(data.page)
		data.page_max = tonumber(data.page_max)

		if fields.book_next then
			data.page = data.page + 1
			if data.page > data.page_max then
				data.page = 1
			end
		else
			data.page = data.page - 1
			if data.page == 0 then
				data.page = data.page_max
			end
		end

		stack:get_meta():from_table({fields = data})
		stack = book_on_use(stack, player)
	end

	-- Update stack (check current stack first)
	local wield_item = player:get_wielded_item():get_name()
	if wield_item == "default:book" or
			wield_item == "default:book_written" then
		player:set_wielded_item(stack)
	end
end)

--
-- Craftitem registry
--

minetest.register_craftitem("default:blueberries", {
	description = S("Blueberries"),
	inventory_image = "default_blueberries.png",
	groups = {food = 1, food_blueberries = 1, food_berry = 1},
	on_use = minetest.item_eat(1)
})

minetest.register_craftitem("default:book", {
	description = S("Book"),
	inventory_image = "default_book.png",
	groups = {book = 1, flammable = 3},
	on_use = book_on_use
})

minetest.register_craftitem("default:book_written", {
	description = S("Book with Text"),
	inventory_image = "default_book_written.png",
	groups = {book = 1, not_in_creative_inventory = 1, flammable = 3},
	stack_max = 1,
	on_use = book_on_use
})

minetest.register_craftitem("default:clay_brick", {
	description = S("Clay Brick"),
	inventory_image = "default_clay_brick.png"
})

minetest.register_craftitem("default:clay_lump", {
	description = S("Clay Lump"),
	inventory_image = "default_clay_lump.png"
})

minetest.register_craftitem("default:coal_lump", {
	description = S("Coal Lump"),
	inventory_image = "default_coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("default:charcoal_lump", {
	description = S("Charcoal Lump"),
	inventory_image = "default_charcoal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("default:diamond", {
	description = S("Diamond"),
	inventory_image = "default_diamond.png"
})

minetest.register_craftitem("default:flint", {
	description = S("Flint"),
	inventory_image = "default_flint.png"
})

minetest.register_craftitem("default:gold_ingot", {
	description = S("Gold Ingot"),
	inventory_image = "default_gold_ingot.png"
})

minetest.register_craftitem("default:paper", {
	description = S("Paper"),
	inventory_image = "default_paper.png",
	groups = {flammable = 3}
})

minetest.register_craftitem("default:steel_ingot", {
	description = S("Steel Ingot"),
	inventory_image = "default_steel_ingot.png"
})

minetest.register_craftitem("default:stick", {
	description = S("Stick"),
	inventory_image = "default_stick.png",
	groups = {stick = 1, flammable = 2, wieldview = 2}
})

minetest.register_craftitem("default:emerald", {
	description = C.emerald .. S("Emerald"),
	inventory_image = "default_emerald.png"
})

minetest.register_craftitem("default:ruby", {
	description = C.ruby .. S("Ruby"),
	inventory_image = "default_ruby.png"
})

minetest.register_craftitem("default:gunpowder", {
	description = S("Gunpowder"),
	inventory_image = "default_gunpowder.png"
})

minetest.register_craftitem("default:bone", {
	description = S("Bone"),
	inventory_image = "default_bone.png",
	groups = {wieldview = 2}
})

minetest.register_craftitem("default:glowstone_dust", {
	description = S("Glowstone Dust"),
	inventory_image = "default_glowstone_dust.png"
})

minetest.register_craftitem("default:sugar", {
	description = S("Sugar"),
	inventory_image = "default_sugar.png"
})

minetest.register_craftitem("default:snowball", {
	description = S("Snowball"),
	inventory_image = "default_snowball.png",
	stack_max = 16,
	groups = {flammable = 3},
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.item_place_node(ItemStack("default:snow"), placer, pointed_thing) then
			if not minetest.is_creative_enabled(placer:get_player_name()) then
				itemstack:take_item()
			end
		end
		return itemstack
	end
})

--
-- Crafting recipes
--

minetest.register_craft({
	output = "default:book",
	recipe = {
		{"default:paper"},
		{"default:paper"},
		{"default:paper"}
	}
})

default.register_craft_metadata_copy("default:book", "default:book_written")

minetest.register_craft({
	output = "default:clay_brick 4",
	recipe = {
		{"default:brick"}
	}
})

minetest.register_craft({
	output = "default:coal_lump 9",
	recipe = {
		{"default:coalblock"}
	}
})

minetest.register_craft({
	output = "default:diamond 9",
	recipe = {
		{"default:diamondblock"}
	}
})

minetest.register_craft({
	output = "default:gold_ingot 9",
	recipe = {
		{"default:goldblock"}
	}
})

minetest.register_craft({
	output = "default:paper",
	recipe = {
		{"default:sugarcane", "default:sugarcane", "default:sugarcane"}
	}
})

minetest.register_craft({
	output = "default:steel_ingot 9",
	recipe = {
		{"default:steelblock"}
	}
})

minetest.register_craft({
	output = "default:stick 4",
	recipe = {
		{"group:wood"},
		{"group:wood"}
	}
})

minetest.register_craft({
	output = "default:snowball 9",
	recipe = {
		{"default:snowblock"}
	}
})

minetest.register_craft({
	output = "default:emerald 9",
	recipe = {
		{"default:emeraldblock"}
	}
})

minetest.register_craft({
	output = "default:ruby 9",
	recipe = {
		{"default:rubyblock"}
	}
})

minetest.register_craft({
	output = "default:glowstone_dust 4",
	recipe = {
		{"default:glowstone"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:gunpowder",
	recipe = {
		"default:sand",
		"default:gravel"
	}
})

minetest.register_craft({
	output = "default:sugar 2",
	recipe = {
		{"default:sugarcane"}
	}
})

--
-- Cooking recipes
--

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "default:clay_lump"
})

minetest.register_craft({
	type = "cooking",
	output = "default:hardened_clay",
	recipe = "default:clay"
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "default:stone_with_gold"
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "default:stone_with_iron"
})

minetest.register_craft({
	type = "cooking",
	output = "default:diamond",
	recipe = "default:stone_with_diamond"
})

minetest.register_craft({
	type = "cooking",
	output = "default:charcoal_lump",
	recipe = "group:tree"
})

minetest.register_craft({
	type = "cooking",
	output = "default:coal_lump",
	recipe = "default:stone_with_coal"
})

--
-- Fuels
--

minetest.register_craft({
	type = "fuel",
	recipe = "default:book",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:book_written",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coal_lump",
	burntime = 60
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:charcoal_lump",
	burntime = 60
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:paper",
	burntime = 1
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:stick",
	burntime = 1
})
