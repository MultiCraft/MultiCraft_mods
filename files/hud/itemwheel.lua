local hb = {}
local scale = tonumber(core.setting_get("hud_scaling")) or 1

local function update_wheel(player)
	local name = player:get_player_name()
	if not player or not name then
		return
	end

	local i = player:get_wield_index()
	local i1 = i - 1
	local i3 = i + 1

	-- it's a wheel
	if i1 < 1 then
		i1 = HUD_IW_MAX
	end
	if i3 > HUD_IW_MAX then
		i3 = 1
	end

	-- get the displayed items
	local inv = player:get_inventory()
	local item = hb[name].item
	local index = hb[name].index
	local item2 = player:get_wielded_item():get_name()

	-- update all items when wielded has changed
	if item and item2 and item ~= item2 or item == "wheel_init" or (index and index ~= i) then
		local items = {}
		items[1] = inv:get_stack("main", i1):get_name() or nil
		items[2] = item2
		items[3] = inv:get_stack("main", i3):get_name() or nil
		local num = player:get_wielded_item():get_count()
		local wear = player:get_wielded_item():get_wear()
		if num < 2 then
			num = ""
		else
			num = tostring(num)
		end
		if wear > 0 then
			num = tostring(100 - math.floor((wear/65535)*100)) .. "%"
		end

		for n, m in pairs(items) do
			-- some default values
			local image = "hud_wielded.png"
			local need_scale = false
			local s1 = {x = 1*scale, y = 1*scale}
			local s2 = {x = 3*scale, y = 3*scale}
			if n ~= 2 then
				s1 = {x = 0.6*scale, y = 0.6*scale}
				s2 = {x = 2*scale, y = 2*scale}
			end

			-- get the images
			local def = minetest.registered_items[m]
			if def then
				if def.tiles and (def.tiles[1] and not def.tiles[1].name) then
					image = minetest.inventorycube(def.tiles[1], def.tiles[6] or def.tiles[3] or def.tiles[1], def.tiles[3] or def.tiles[1])
					need_scale = true
				end
				if def.inventory_image and def.inventory_image ~= "" then
					image = def.inventory_image
					need_scale = false
				end
				if def.wielded_image and def.wielded_image ~= "" then
					image = def.wielded_image
					need_scale = false
				end
				-- needed for nodes with inventory cube inv imges, e.g. glass
				if string.find(image, 'inventorycube') then
					need_scale = true
				end
			end

			-- get the id and update hud elements
			local id = hb[name].id[n]
			if id and image then
				if need_scale then
					player:hud_change(id, "scale", s1)
				else
					player:hud_change(id, "scale", s2)
				end
				-- make previous and next item darker
				--if n ~= 2 then
					--image = image .. "^[colorize:#0005"
				--end
				player:hud_change(id, "text", image)
			end
		end
		if hb[name].id[4] then
			player:hud_change(hb[name].id[4], "text", num)
		end
	end

	-- update wielded buffer
	if hb[name].id[2] ~= nil then
		hb[name].item = item2
		hb[name].index = i
	end
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    hb[name]= {}
    hb[name].id = {}
    hb[name].item = "wheel_init"
    hb[name].index = 1

    minetest.after(0.1, function()

	-- hide builtin hotbar
	local hud_flags = player:hud_get_flags()
	hud_flags.hotbar = false
	player:hud_set_flags(hud_flags)

	player:hud_add({
		hud_elem_type = "image",
		text = "hud_new.png",
		position = {x = 0.5, y = 1},
		scale = {x = 1*scale, y = 1*scale},
		alignment = {x = 0, y = -1},
		offset = {x = 0, y = 0}
	})

	hb[name].id[1] = player:hud_add({
		hud_elem_type = "image",
		text = "hud_wielded.png",
		position = {x = 0.5, y = 1},
		scale = {x = 1*scale, y = 1*scale},
		alignment = {x = 0, y = -1},
		offset = {x = -75*scale, y = -8*scale}
	})

	hb[name].id[2] = player:hud_add({
		hud_elem_type = "image",
		text = "hud_wielded.png",
		position = {x = 0.5, y = 1},
		scale = {x = 3*scale, y = 3*scale},
		alignment = {x = 0, y = -1},
		offset = {x = 0, y = -12*scale}
	})

	hb[name].id[3] = player:hud_add({
		hud_elem_type = "image",
		text = "hud_wielded.png",
		position = {x = 0.5, y = 1},
		scale = {x = 1*scale, y = 1*scale},
		alignment = {x = 0, y = -1},
		offset = {x = 75*scale, y = -8*scale}
	})

	hb[name].id[4] = player:hud_add({
		hud_elem_type = "text",
		position = {x = 0.5, y = 1},
		offset = {x = 35*scale, y = -55*scale},
		alignment = {x = 0, y = -1},
		number = 0xffffff,
		text = "",
	})

	-- init item wheel
	minetest.after(0, function()
		hb[name].item = "wheel_init"
		update_wheel(player)
	end)
    end)
end)

local function update_wrapper(a, b, player)
	local name = player:get_player_name()
	if not name then
		return
	end
	minetest.after(0, function()
		hb[name].item = "wheel_init"
		update_wheel(player)
	end)
end

minetest.register_on_placenode(update_wrapper)
minetest.register_on_dignode(update_wrapper)


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= HUD_IW_TICK then
		timer = 0
		for _, player in ipairs(minetest.get_connected_players()) do
			update_wheel(player)
		end
	end--timer
end)