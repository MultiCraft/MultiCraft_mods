local show_time = 2
local has_armor = minetest.get_modpath("3d_armor")

local wield_tiles = {}
local wield_cubes = {}
local wield_items = {}
local item_cycle = {}

local function init_wield_items()
	for name, def in pairs(minetest.registered_items) do
		if def.inventory_image and def.inventory_image ~= "" then
			wield_tiles[name] = def.inventory_image
		elseif def.tiles and type(def.tiles[1]) == "string" and
				def.tiles[1] ~= "" and def.drawtype and
				(def.drawtype == "normal" or def.drawtype:sub(1,8) == "allfaces" or
				def.drawtype:sub(1,5) == "glass" or def.drawtype == "liquid") then
			if not (def.tiles[3] ~= "" and type(def.tiles[3]) == "string") then
				wield_cubes[name] = def.tiles[1]
			else
				wield_cubes[name] = def.tiles[3]
			end
		end
	end
end

hud.register("itemname", {
	hud_elem_type = "text",
	position      = {x = 0.5, y =  1},
	alignment     = {x = 0,   y = -10},
	offset        = {x = 0,   y = -25},
	number        = 0xFFFFFF,
	text          = ""
})

local function update_statbar_text(player, stack, item)
	local meta = stack:get_meta()
	local meta_desc = meta:get_string("description")
	meta_desc = meta_desc:gsub("\27", ""):gsub("%(c@#%w%w%w%w%w%w%)", "")
	local def = core.registered_items[item]
	local description = meta_desc ~= "" and meta_desc or
		(def and (def.description:match("(.-)\n") or def.description) or "")
	hud.change_item(player, "itemname", {text = description})
end

local function update_player_visuals(player, item)
	local animation = player_api.get_animation(player) or {}
	local textures = animation.textures or {}
	local skin = textures[1] and textures[1] or "character.png"
	local wield_tile = wield_tiles[item] or "blank.png"
	if not minetest.registered_tools[item] then
		wield_tile = wield_tile.."^[transformR270"
	end
	local wield_cube = wield_cubes[item] or "blank.png"
	if has_armor then
		local name = player:get_player_name()
		armor.textures[name].wielditem = wield_tile
		armor.textures[name].cube = wield_cube
		armor:update_player_visuals(player)
	else
		player_api.set_textures(player, {skin, "blank.png", wield_tile, wield_cube})
	end
end

local function update_wielded_item(dtime, name)
	item_cycle[name] = item_cycle[name] and item_cycle[name] + dtime or 0
	local player = minetest.get_player_by_name(name)
	if not player or not player:is_player() then
		return
	end
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if not item then
		return
	end
	if wield_items[name] and wield_items[name] == item then
		if item_cycle[name] > show_time then
			hud.change_item(player, "itemname", {text = ""})
			item_cycle[name] = 0
		end
		return
	else
		update_statbar_text(player, stack, item)
		item_cycle[name] = 0
		if PLATFORM ~= "Android" and PLATFORM ~= "iOS" then
			update_player_visuals(player, item)
		end
	end
	wield_items[name] = item
end


minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if name then
		wield_items[name] = ""
		item_cycle[name] = 0
	end
end)
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		wield_items[name] = ""
		item_cycle[name] = 0
	end
end)
minetest.register_playerstep(function(dtime, playernames)
	for _, name in pairs(playernames) do
		update_wielded_item(dtime, name)
	end
end, minetest.is_singleplayer()) -- Force step in singlplayer mode only
if PLATFORM ~= "Android" and PLATFORM ~= "iOS" then
	minetest.after(0, init_wield_items)
end
