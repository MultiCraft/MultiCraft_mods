--
-- Originally by stujones11, Stuart Jones (LGPLv3.0+, with the permission of the author)
-- Completely redone for MultiCraft_game
--

local wield_tiles = {}
local wield_cubes = {}

minetest.after(1, function()
	for name, def in pairs(minetest.registered_items) do
		if def.inventory_image and def.inventory_image ~= "" then
			if minetest.registered_tools[name] then
				wield_tiles[name] = def.inventory_image
			else
				wield_tiles[name] = def.inventory_image .. "^[transformR270"
			end
		elseif def.tiles and type(def.tiles[1]) == "string" and def.tiles[1] ~= "" then
			if def.drawtype and
					(def.drawtype == "normal" or
					 def.drawtype == "liquid" or
					 def.drawtype:sub(1, 8) == "allfaces" or
					 def.drawtype:sub(1, 5) == "glass") then
				if not def.tiles[3] ~= "" and type(def.tiles[3]) == "string" then
					wield_cubes[name] = def.tiles[1]
				else
					wield_cubes[name] = def.tiles[3]
				end
			else
				if not def.tiles[3] ~= "" and type(def.tiles[3]) == "string" then
					wield_tiles[name] = def.tiles[1]
				else
					wield_tiles[name] = def.tiles[3]
				end
			end
		end
	end
end)

function player_api.update_wielded_item(player, name)
	local item = player:get_wielded_item():get_name()
	local wielded_item = player_api.wielded_item
	if item and (not wielded_item[name] or wielded_item[name] ~= item) then
		local wield_tile = wield_tiles[item] or "blank.png"
		local wield_cube = wield_cubes[item] or "blank.png"
		player_api.set_textures(player, nil, nil, wield_tile, wield_cube)
		wielded_item[name] = item
	end
end
