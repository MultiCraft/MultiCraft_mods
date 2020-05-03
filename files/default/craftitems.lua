-- mods/default/craftitems.lua

local lpp = 14 -- Lines per book's page
local function book_on_use(itemstack, user)
	local player_name = user:get_player_name()
	local meta = itemstack:get_meta()
	local title, text, owner = "", "", player_name
	local page, page_max, lines, string = 1, 1, {}, ""

	-- Backwards compatibility
	local old_data = minetest.deserialize(itemstack:get_metadata())
	if old_data then
		meta:from_table({ fields = old_data })
	end

	local data = meta:to_table().fields

	if data.owner then
		title = data.title
		text = data.text
		owner = data.owner

		for str in (text .. "\n"):gmatch("([^\n]*)[\n]") do
			lines[#lines+1] = str
		end

		if data.page then
			page = data.page
			page_max = data.page_max

			for i = ((lpp * page) - lpp) + 1, lpp * page do
				if not lines[i] then break end
				string = string .. lines[i] .. "\n"
			end
		end
	end

	local formspec
	local esc = minetest.formspec_escape
	if owner == player_name then
		formspec = "size[8,8]" ..
			"field[0.5,1;7.5,0;title;" .. Sl("Title:") .. ";" ..
				esc(title) .. "]" ..
			"textarea[0.5,1.5;7.5,7;text;" .. Sl("Contents:") .. ";" ..
				esc(text) .. "]" ..
			"button_exit[2.5,7.5;3,1;save;" .. Sl("Save") .. "]"
	else
		formspec = "size[8,8]" ..
			"label[0.5,0.5;" .. Sl("by @1", owner) .. "]" ..
			"tablecolumns[color;text]" ..
			"tableoptions[background=#00000000;highlight=#00000000;border=false]" ..
			"table[0.4,0;7,0.5;title;#FFFF00," .. esc(title) .. "]" ..
			"textarea[0.5,1.5;7.5,7;;" ..
				minetest.formspec_escape(string ~= "" and string or text) .. ";]" ..
			"button[2.4,7.6;0.8,0.8;book_prev;<]" ..
			"label[3.2,7.7;" .. Sl("Page: @1 of @2", page, page_max) .. "]" ..
			"button[4.9,7.6;0.8,0.8;book_next;>]"
	end

	minetest.show_formspec(player_name, "default:book", formspec)
	return itemstack
end

local max_text_size = 10000
local max_title_size = 80
local short_title_size = 35
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
		data.description = Sl("\"@1\" by @2", short_title, data.owner)
		data.text = fields.text:sub(1, max_text_size)
		data.text = data.text:gsub("\r\n", "\n"):gsub("\r", "\n")
		data.page = 1
		data.page_max = math.ceil((#data.text:gsub("[^\n]", "") + 1) / lpp)

		if new_stack then
			new_stack:get_meta():from_table({ fields = data })
			if inv:room_for_item("main", new_stack) then
				inv:add_item("main", new_stack)
			else
				minetest.add_item(player:get_pos(), new_stack)
			end
		else
			stack:get_meta():from_table({ fields = data })
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

	-- Update stack
	player:set_wielded_item(stack)
end)

minetest.register_craftitem("default:book", {
	description = "Book",
	inventory_image = "default_book.png",
	groups = {book = 1, flammable = 3},
	on_use = book_on_use
})

minetest.register_craftitem("default:book_written", {
	description = "Book With Text",
	inventory_image = "default_book_written.png",
	groups = {book = 1, not_in_creative_inventory = 1, flammable = 3},
	stack_max = 1,
	on_use = book_on_use
})

minetest.register_craftitem("default:coal_lump", {
	description = "Coal Lump",
	inventory_image = "default_coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("default:charcoal_lump", {
	description = "Charcoal Lump",
	inventory_image = "default_charcoal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_craftitem("default:diamond", {
	description = "Diamond",
	inventory_image = "default_diamond.png"
})

minetest.register_craftitem("default:clay_lump", {
	description = "Clay Lump",
	inventory_image = "default_clay_lump.png"
})

minetest.register_craftitem("default:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
	groups = {flammable = 3}
})

minetest.register_craftitem("default:steel_ingot", {
	description = "Steel Ingot",
	inventory_image = "default_steel_ingot.png"
})

minetest.register_craftitem("default:stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	groups = {stick = 1, flammable = 2}
})


minetest.register_craftitem("default:gold_ingot", {
	description = "Gold Ingot",
	inventory_image = "default_gold_ingot.png"
})

minetest.register_craftitem("default:emerald", {
	description = default.colors.emerald .. Sl("Emerald"),
	inventory_image = "default_emerald.png"
})

minetest.register_craftitem("default:ruby", {
	description = default.colors.ruby .. Sl("Ruby"),
	inventory_image = "default_ruby.png"
})

minetest.register_craftitem("default:clay_brick", {
	description = "Clay Brick",
	inventory_image = "default_clay_brick.png"
})

minetest.register_craftitem("default:gunpowder", {
	description = "Gunpowder",
	inventory_image = "default_gunpowder.png"
})

minetest.register_craftitem("default:bone", {
	description = "Bone",
	inventory_image = "default_bone.png"
})

minetest.register_craftitem("default:glowstone_dust", {
	description = "Glowstone Dust",
	inventory_image = "default_glowstone_dust.png"
})

minetest.register_craftitem("default:fish_raw", {
	description = "Raw Fish",
	inventory_image = "default_fish.png",
	groups = {food_fish_raw = 1, food = 1},
	on_use = minetest.item_eat(2, nil, -3)
})

minetest.register_craftitem("default:fish", {
	description = "Cooked Fish",
	inventory_image = "default_fish_cooked.png",
	groups = {food = 1},
	on_use = minetest.item_eat(6)
})

minetest.register_craftitem("default:sugar", {
	description = "Sugar",
	inventory_image = "default_sugar.png"
})

minetest.register_craftitem("default:quartz_crystal", {
	description = "Quartz Crystal",
	inventory_image = "default_quartz_crystal.png"
})

minetest.register_craftitem("default:flint", {
	description = "Flint",
	inventory_image = "default_flint.png"
})

minetest.register_craftitem("default:snowball", {
	description = "Snowball",
	inventory_image = "default_snowball.png",
	stack_max = 16,
	groups = {flammable = 3},
	on_use = default.snow_shoot_snowball,
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.item_place_node(ItemStack("default:snow"), placer, pointed_thing) then
			if not (creative and creative.is_enabled_for
					and creative.is_enabled_for(placer)) then
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
		{"default:paper"},
	}
})

default.register_craft_metadata_copy("default:book", "default:book_written")
