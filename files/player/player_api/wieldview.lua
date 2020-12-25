--
-- Originally by stujones11, Stuart Jones (LGPLv3.0+, with the permission of the author)
-- Completely redone for MultiCraft_game
--

local wield_tiles = {}
local wield_cubes = {}

local function prepare()
	for name, def in pairs(minetest.registered_items) do
		local inv_img = def.inventory_image
		if inv_img and inv_img ~= "" then
			if minetest.registered_tools[name] or (def.groups.wieldview == 2) then
				wield_tiles[name] = inv_img
			else
				wield_tiles[name] = inv_img .. "^[transformR270"
			end
		elseif def.tiles and type(def.tiles[1]) == "string" and def.tiles[1] ~= "" then
			if def.drawtype and
					(def.drawtype == "normal" or
					 def.drawtype == "liquid" or
					 def.drawtype:sub(1, 8) == "allfaces" or
					 def.drawtype:sub(1, 5) == "glass") then
				if def.tiles[3] ~= "" and type(def.tiles[3]) == "string" then
					wield_cubes[name] = def.tiles[3]
				else
					wield_cubes[name] = def.tiles[1]
				end
			else
				if (def.tiles[6] ~= "" and type(def.tiles[6]) == "string") then
					wield_tiles[name] = def.tiles[6]
				elseif (def.tiles[3] ~= "" and type(def.tiles[3]) == "string") then
					wield_tiles[name] = def.tiles[3]
				else
					wield_tiles[name] = def.tiles[1]
				end
			end
		end
	end
end

if minetest.register_on_mods_loaded then
	minetest.register_on_mods_loaded(function()
		minetest.after(1, function()
			prepare()
		end)
	end)
else -- legacy MultiCraft Engine
	minetest.after(1, function()
		prepare()
	end)
end

local set_textures = player_api.set_textures
local wielded_item = player_api.wielded_item
function player_api.update_wielded_item(player, name)
	local item = player:get_wielded_item():get_name()
	local b = "blank.png"
	if item and (not wielded_item[name] or wielded_item[name] ~= item) then
		local wield_tile = wield_tiles[item] or b
		local wield_cube = wield_cubes[item] or b
		set_textures(player, nil, nil, wield_tile, wield_cube)
		wielded_item[name] = item
	end
end
