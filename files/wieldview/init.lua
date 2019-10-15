if PLATFORM == "Android" and PLATFORM == "iOS" then
	return
end

local has_armor = minetest.get_modpath("3d_armor")
local wield_tiles = {}
local wield_cubes = {}
local wield_items = {}

minetest.after(1, function()
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
end)

local function update_player_visuals(player, name, item)
	local animation = player_api.get_animation(player) or {}
	local textures = animation.textures or {}
	local skin = textures[1] and textures[1] or "character.png"
	local wield_tile = wield_tiles[item] or "blank.png"
	if not minetest.registered_tools[item] then
		wield_tile = wield_tile.."^[transformR270"
	end
	local wield_cube = wield_cubes[item] or "blank.png"
	if has_armor then
		armor.textures[name].wielditem = wield_tile
		armor.textures[name].cube = wield_cube
		armor:update_player_visuals(player)
	else
		player_api.set_textures(player, {skin, "blank.png", wield_tile, wield_cube})
	end
end

local function update_wielded_item(name)
	local player = minetest.get_player_by_name(name)
	if not player then return end
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if item and wield_items[name] and wield_items[name] == item then
		return
	else
		update_player_visuals(player, name, item)
	end
	wield_items[name] = item
end

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		wield_items[name] = nil
	end
end)
minetest.register_playerstep(function(dtime, playernames)
	for _, name in pairs(playernames) do
		update_wielded_item(name)
	end
end, minetest.is_singleplayer()) -- Force step in singlplayer mode only
