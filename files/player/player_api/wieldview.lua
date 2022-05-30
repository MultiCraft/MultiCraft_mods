--
-- Originally by stujones11, Stuart Jones (LGPLv3.0+, with the permission of the author)
-- Completely redone for MultiCraft_game
--

local wielded_item = {}
local wield_tiles = {}
local wield_cubes = {}

local set_textures = player_api.set_textures

local function prepare()
	for name, def in pairs(minetest.registered_items) do
		local inv_img = def.inventory_image
		local wield_img = def.wield_image
		local wield_img2 = def.wield_image2
		local tiles = def.tiles
		local group = def.groups
		local wieldview = group.wieldview
		local not_in_inv = group.not_in_creative_inventory
		if wield_img2 and wield_img2 ~= "" then
			wield_tiles[name] = wield_img2 .. "^[transformR270"
		elseif (not not_in_inv or not_in_inv < 1) or wieldview ~= nil then
			if wield_img and wield_img ~= "" then
				if wieldview == 2 then
					wield_tiles[name] = wield_img
				else
					wield_tiles[name] = wield_img .. "^[transformR270"
				end
			elseif inv_img and inv_img ~= "" then
					if (minetest.registered_tools[name] or
							wieldview == 2) and wieldview ~= 3 then
					wield_tiles[name] = inv_img
				else
					wield_tiles[name] = inv_img .. "^[transformR270"
				end
			elseif tiles and type(tiles[1]) == "string" and tiles[1] ~= "" then
				local wield_cube = def.wield_cube
				local drawtype = def.drawtype
				if wield_cube and wield_cube ~= "" then
					wield_cubes[name] = wield_cube
				elseif drawtype and
						(drawtype == "normal" or
						 drawtype == "liquid" or
						 drawtype:sub(1, 8) == "allfaces" or
						 drawtype:sub(1, 5) == "glass") or
						wieldview == 4 then
					if tiles[3] ~= "" and type(tiles[3]) == "string" then
						wield_cubes[name] = tiles[3]
					else
						wield_cubes[name] = tiles[1]
					end
				else
					if (tiles[6] ~= "" and type(tiles[6]) == "string") then
						wield_tiles[name] = tiles[6]
					elseif (tiles[3] ~= "" and type(tiles[3]) == "string") then
						wield_tiles[name] = tiles[3]
					else
						wield_tiles[name] = tiles[1]
					end
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

local sfinv_exists = minetest.global_exists("sfinv")
local sfinv_sscsm_exists = minetest.global_exists("sfinv_sscsm")
function player_api.update_wielded_item(player, name)
	local item = player:get_wielded_item():get_name()
	local b = "blank.png"
	if item and (not wielded_item[name] or wielded_item[name] ~= item) then
		local wield_tile = wield_tiles[item] or b
		local wield_cube = wield_cubes[item] or b
		set_textures(player, nil, nil, nil, wield_tile, wield_cube)
		wielded_item[name] = item

		if sfinv_exists and (not sfinv_sscsm_exists or not sfinv_sscsm.has_sscsm_inv(name)) then
			sfinv.set_player_inventory_formspec(player)
		end
	end
end

minetest.register_on_leaveplayer(function(player)
	wielded_item[player:get_player_name()] = nil
end)
