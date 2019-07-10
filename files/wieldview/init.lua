local update_time = 1
local has_armor = minetest.get_modpath("3d_armor")
local time = 0

local wield_tiles = {}
local wield_cubes = {}
local wield_items = {}
local wield_cycle = {}

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

local function update_player_visuals(player, item)
	local name = player:get_player_name()
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

local function update_wielded_item(dtime, name)
	wield_cycle[name] = wield_cycle[name] or 0
	wield_cycle[name] = wield_cycle[name] + dtime
	if wield_cycle[name] < update_time then
		return
	end
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
		return
	else
		update_player_visuals(player, item)
	end
	wield_items[name] = item
	wield_cycle[name] = 0
end

if PLATFORM ~= "Android" or PLATFORM ~= "iOS" then
	minetest.register_on_joinplayer(function(player)
		local name = player:get_player_name()
		if name then
			wield_items[name] = ""
			wield_cycle[name] = 0
			minetest.after(0, function()
				update_wielded_item(0, name)
			end)
		end
	end)
	minetest.register_on_leaveplayer(function(player)
		local name = player:get_player_name()
		if name then
			wield_items[name] = ""
			wield_cycle[name] = 0
		end
	end)
	minetest.register_playerstep(function(dtime, playernames)
		for _, name in pairs(playernames) do
			update_wielded_item(dtime, name)
		end
	end)
	minetest.after(0, init_wield_items)
end
