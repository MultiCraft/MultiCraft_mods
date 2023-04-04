local S = minetest.get_translator("signs")

local pi = math.pi
local upper = string.upper
local tconcat = table.concat
local vadd = vector.add
local b = "blank.png"
local esc = minetest.formspec_escape
local function obj_inside_radius(p)
	return minetest.get_objects_inside_radius(p, 0.5)
end

local ENTITY = "signs:sign_text"

-- Cyrillic transliteration library
local slugify = dofile(minetest.get_modpath("signs") .. "/slugify.lua")

local sign_positions = {
	[0] = {{x =  0,    y = 0.18, z = -0.07}, pi},
	[1] = {{x = -0.07, y = 0.18, z =  0},    pi * 0.5},
	[2] = {{x =  0,    y = 0.18, z =  0.07}, 0},
	[3] = {{x =  0.07, y = 0.18, z =  0},    pi * 1.5}
}

local wall_sign_positions = {
	[0] = {{x =  0.43, y = 0, z =  0},    pi * 0.5},
	[1] = {{x = -0.43, y = 0, z =  0},    pi * 1.5},
	[2] = {{x =  0,    y = 0, z =  0.43}, pi},
	[3] = {{x =  0,    y = 0, z = -0.43}, 0}
}

local font = {width = 16, height = 20}
local lenght, rows = 20, 5

local colors_list = {
	"Black", "Silver", "Gray", "White",
	"Maroon", "Red", "Purple", "Fuchsia",
	"Green", "Lime", "Olive", "Yellow",
	"Navy", "Blue", "Teal", "Aqua"
}

local function generate_sign_line_texture(str, row)
	local leftover = (lenght - #str) * font.width / 2
	row = (row - 0.85) * 0.85
	local texture = {}

	for i = 1, lenght do
		local byte = str:byte(i)
		if not byte or byte < 32 or byte > 126 then
			byte = 32 -- space
		end

		texture[#texture + 1] = (":%u,%u=signs_%u.png"):format(
			font.width * (i - 1) + leftover,
			font.height * row + (font.height / rows), byte)
	end

	return tconcat(texture)
end

local function find_any(str, pair, start)
	local ret = 0 -- 0 if not found (indices start at 1)
	for _, needle in ipairs(pair) do
		local first = str:find(needle, start)
		if first then
			if ret == 0 or first < ret then
				ret = first
			end
		end
	end

	return ret
end

local disposable_chars = {
	["\n"] = true, ["\r"] = true, ["\t"] = true, [" "] = true
}

local wrap_chars = {
	"\n", "\r", "\t", " ", "-", "/", ";", ":", ",", ".", "?", "!"
}

local function generate_sign_texture(str, color)
	local result = {}

	-- Transliterate text
	str = slugify(str)

	while #str > 0 do
		if #result >= (rows) then
			break
		end
		local wrap_i = 0
		local keep_i = 0 -- The last character that was kept
		while wrap_i < #str do
			wrap_i = find_any(str, wrap_chars, wrap_i + 1)
			if wrap_i > lenght then
				if keep_i > 1 then
					wrap_i = keep_i
				else
					wrap_i = lenght
				end
				break
			elseif wrap_i == 0 then
				if #str <= lenght then
					wrap_i = #str
				elseif keep_i > 0 then
					wrap_i = keep_i
				else
					wrap_i = #str
				end
				break
			elseif str:sub(wrap_i, wrap_i) == "\n" then
				break
			end
			if not disposable_chars[str:sub(wrap_i, wrap_i)] then
				keep_i = wrap_i
			elseif wrap_i > 1 and
					not disposable_chars[str:sub(wrap_i - 1, wrap_i - 1)] then
				keep_i = wrap_i - 1
			end
		end
		if wrap_i > lenght then
			wrap_i = lenght
		end
		local start_remove = 0
		if disposable_chars[str:sub(1, 1)] then
			start_remove = 1
		end
		local end_remove = 0
		if disposable_chars[str:sub(wrap_i, wrap_i)] then
			end_remove = 1
		end
		local line_string = str:sub(1 + start_remove, wrap_i - end_remove)
		if line_string ~= "" then
			result[#result + 1] = line_string
		end
		str = str:sub(wrap_i + 1)
	end

	local empty = 0
	if #result == 1 then
		empty = 2
	elseif #result == (rows - 1) then
		empty = 0.5
	elseif #result < (rows - 1) then
		empty = 1
	end

	-- Generate texture modifier
	local texture = {
		("[combine:%ux%u"):format(font.width * lenght, font.height * rows)
	}

	for r, s in ipairs(result) do
		texture[#texture + 1] = generate_sign_line_texture(s, r + empty)
	end

	if color and color ~= "" then
		texture[#texture + 1] = "^[colorize:" .. color
	end

	return tconcat(texture)
end

minetest.register_entity(ENTITY, {
	visual = "upright_sprite",
	visual_size = {x = 0.7, y = 0.7},
	textures = {b, b},
	collisionbox = {0},
	physical = false,

	on_activate = function(self)
		local ent = self.object
		local pos = ent:get_pos()

		-- remove entity for missing sign
		local node_name = minetest.get_node(pos).name
		if node_name ~= "signs:sign" and
				node_name ~= "signs:wall_sign" then
			ent:remove()
			return
		end

		local meta = minetest.get_meta(pos)
		local meta_texture = meta:get_string("sign_texture")

		local texture
		if meta_texture and meta_texture ~= "" then
			texture = meta_texture
		else
			local meta_text = meta:get_string("sign_text")
			if meta_text and meta_text ~= "" then
				local meta_color = meta:get_string("sign_color")
				texture = generate_sign_texture(meta_text, meta_color)
			else
				texture = b
			end
			meta:set_string("sign_texture", texture)
		end

		ent:set_properties({
			textures = {texture, b}
		})
	end
})

local function place(itemstack, placer, pointed_thing)
	if pointed_thing.type == "node" then
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local node_def = minetest.registered_nodes[node.name]
		if node_def and node_def.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return node_def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local undery = pointed_thing.under.y
		local posy = pointed_thing.above.y

		local _, result
		if undery < posy then -- Floor sign
			itemstack, result = minetest.item_place(itemstack,
					placer, pointed_thing)
		elseif undery == posy then -- Wall sign
			_, result = minetest.item_place(ItemStack("signs:wall_sign"),
					placer, pointed_thing)
			if result and not
					minetest.is_creative_enabled(placer:get_player_name()) then
				itemstack:take_item()
			end
		end
		if result then
			minetest.sound_play({name = "default_place_node_hard"}, {pos = result})
		end
	end

	return itemstack
end

local function destruct(pos)
	for _, obj in ipairs(obj_inside_radius(pos)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == ENTITY then
			obj:remove()
		end
	end
end

local function check_text(pos)
	local meta = minetest.get_meta(pos)
	local text = meta:get_string("sign_text")

	if text and text ~= "" then
		local count = 0
		for _, obj in ipairs(obj_inside_radius(pos)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == ENTITY then
				count = count + 1
				if count > 1 then
					obj:remove()
				end
			end
		end
		if count == 0 then
			local node = minetest.get_node(pos)
			local p2 = node.param2 or -1
			local sign_pos = sign_positions
			if node.name == "signs:wall_sign" then
				p2 = p2 - 2
				sign_pos = wall_sign_positions
			end
			if p2 > 3 or p2 < 0 then return end
			local sign = minetest.add_entity(vadd(pos, sign_pos[p2][1]), ENTITY)
			if not sign then
				return
			end
			sign:set_yaw(sign_pos[p2][2])
		end
	else
		for _, obj in ipairs(obj_inside_radius(pos)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == ENTITY then
				obj:remove()
			end
		end
	end

	-- Remove old node meta
	local old_meta = {"formspec", "sign_texture2", "sign_texture3"}
	for _, field in ipairs(old_meta) do
		meta:set_string(field, "")
	end
end

local function edit_text(pos, _, clicker)
	local player_name = clicker:get_player_name()

	local meta = minetest.get_meta(pos)
	local text = esc(meta:get_string("sign_text"))

	local edit_fs = "size[5,3.4]" ..
		"background[0,0;0,0;formspec_background_color.png^formspec_backround.png;true]"
	if not minetest.is_protected(pos, player_name) then
		local ccolor = meta:get_string("sign_color")
		if ccolor then
			ccolor = ccolor:gsub("^%l", upper)
		end

		local clist = {}
		local csel = 1
		for i, clr in ipairs(colors_list) do
			if ccolor == clr then
				csel = i
			end
			clist[#clist + 1] = clr
		end
		clist = tconcat(clist, ",")

		edit_fs = edit_fs ..
			"textarea[1.15,0.2;3.3,2;Dtext;" ..
			S("Enter your text:") .. ";" .. text .. "]" ..
			"dropdown[0.86,1.93;3.36;color;" .. clist .. ";" .. csel .. "]" ..
			"button_exit[0.86,2.66;3.3,1;;" .. S("Save") .. "]" ..
			"field[0,0;0,0;spos;;" .. minetest.pos_to_string(pos) .. "]"
	else
		edit_fs = edit_fs ..
			"textarea[1.15,0.2;3.3,2.7;read_only;" ..
			S("Sign") .. ":;" .. text .. "]" ..
			"button_exit[0.86,2.66;3.3,1;;" .. S("Close") .. "]"
	end

	minetest.show_formspec(player_name, "signs:edit_text", edit_fs)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "signs:edit_text" then
		return
	end

	local pos = fields.spos and minetest.string_to_pos(fields.spos)

	if not pos then
		return
	end

	local meta = minetest.get_meta(pos)

	local text = fields.Dtext
	local color = fields.color

	if not text and not color then
		return
	elseif not text then
		text = meta:get_string("sign_text")
	end

	if color then
		color = color:lower()
	end

	if minetest.is_protected(pos, player:get_player_name()) then
		return
	end

	local node = minetest.get_node(pos)
	local p2 = node.param2
	local sign_pos = sign_positions

	if node.name:find("wall") then
		p2 = p2 - 2
		sign_pos = wall_sign_positions
	end
	if not p2 or p2 > 3 or p2 < 0 then
		return
	end

	local sign
	for _, obj in ipairs(obj_inside_radius(pos)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == ENTITY then
			sign = obj
			break
		end
	end
	if not sign then
		sign = minetest.add_entity(vadd(pos, sign_pos[p2][1]), ENTITY)
	else
		sign:set_pos(vadd(pos, sign_pos[p2][1]))
	end
	if not sign then
		return
	end

	local texture = b
	if text and text ~= "" then
		-- Serialization longer values may cause a crash
		-- because we are serializing the texture too
		text = text:sub(1, 256)

		texture = generate_sign_texture(text, color)
		sign:set_properties({
			textures = {texture, b}
		})
	end

	sign:set_yaw(sign_pos[p2][2])

	meta:set_string("sign_text", text)
	meta:set_string("sign_texture", texture)
	meta:set_string("sign_color", color)
	meta:set_string("infotext", text)
end)


-- Sign nodes
minetest.register_node("signs:sign", {
	description = S("Sign"),
	tiles = {
		"signs_top.png", "signs_top.png", "signs_top.png",
		"signs_top.png", "signs_sign.png", "signs_sign.png"
	},
	inventory_image = "signs_item.png",
	wield_image = "signs_item.png",
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_placement_prediction = "",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.125, -0.063, 0.375,  0.5,   0.063},
			{-0.063, -0.5,   -0.063, 0.063, -0.125, 0.063}
		}
	},
	groups = {oddly_breakable_by_hand = 1, choppy = 3, attached_node = 1},
	on_rotate = function(pos, node, user, mode)
		local pn = user and user:get_player_name() or ""
		if not minetest.is_protected(pos, pn) and mode == 1 then
			node.param2 = (node.param2 % 8) + 1
			if node.param2 > 3 then
				node.param2 = 0
			end
			minetest.swap_node(pos, node)

			-- Checks can be skipped if there is no text
			local meta = minetest.get_meta(pos)
			local text = meta:get_string("sign_text")
			if text and text ~= "" then
				destruct(pos)
				check_text(pos)
			end

			return true
		end

		return false
	end,

	mesecon = {on_mvps_move = check_text},

	on_place = place,
	on_destruct = destruct,
	on_punch = check_text,
	on_rightclick = edit_text
})

minetest.register_node("signs:wall_sign", {
	tiles = {"signs_wall_sign.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	node_box = {
		type = "wallmounted",
		wall_side = {-0.5, -0.313, -0.438, -0.438, 0.313, 0.438}
	},
	drop = "signs:sign",
	walkable = false,
	groups = {oddly_breakable_by_hand = 1, choppy = 3, attached_node = 1,
		not_in_creative_inventory = 1},
	on_rotate = false,

	mesecon = {on_mvps_move = check_text},
	mvps_sticky = function(pos, node)
		local dir = minetest.wallmounted_to_dir(node.param2)
		return {vadd(pos, dir)}
	end,

	on_destruct = destruct,
	on_punch = check_text,
	on_rightclick = edit_text
})

-- Craft
minetest.register_craft({
	output = "signs:sign 3",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
		{"", "default:stick", ""}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "signs:sign",
	burntime = 10
})

-- LBM for restoring text
minetest.register_lbm({
	label = "Check for sign text",
	name = "signs:check_text",
	nodenames = {"signs:sign", "signs:wall_sign"},
	run_at_every_load = true,
	action = check_text
})

if mesecon and mesecon.register_mvps_stopper then
	mesecon.register_mvps_unmov(ENTITY)
end
