-- "Dungeon Loot" [dungeon_loot]
-- Copyright (c) 2015 BlockMen <blockmen2015@gmail.com>
--
-- init.lua
--
-- This software is provided 'as-is', without any express or implied warranty. In no
-- event will the authors be held liable for any damages arising from the use of
-- this software.
--
-- Permission is granted to anyone to use this software for any purpose, including
-- commercial applications, and to alter it and redistribute it freely, subject to the
-- following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
-- claim that you wrote the original software. If you use this software in a
-- product, an acknowledgment in the product documentation is required.
-- 2. Altered source versions must be plainly marked as such, and must not
-- be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
--

local chest_stuff = {
	{name="default:apple", max = 3},
	{name="default:steel_ingot", max = 2},
	{name="default:gold_ingot", max = 2},
	{name="default:diamond", max = 1},
	{name="default:pick_steel", max = 1},
	{name="default:pick_diamond", max = 1},
	{name="default:acacia_sapling", max = 3}
}

if minetest.get_modpath("farming") then
	chest_stuff[8] = {name="farming:bread", max = 3}
end

local function fill_chest(pos)
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		if n and n.name and n.name == "default:chest" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
			if math.random(1, 10) < 7 then
				return
			end
			for i=1,3,1 do
				local stuff = chest_stuff[math.random(1, #chest_stuff)]
				local stack = ItemStack({name = stuff.name, count = math.random(1, stuff.max)})
				if not inv:contains_item("main", stack) then
					inv:set_stack("main", math.random(1, 32), stack)
				end
			end
		end
	end)
end

-- Place chest in dungeons

local function place_spawner(tab)
	local pos = tab[math.random(1, (#tab or 4))]
	pos.y = pos.y - 1
	local n = core.get_node_or_nil(pos)
	if n and n.name ~= "air" then
		pos.y = pos.y + 1
		core.set_node(pos, {name = "default:chest"})
		fill_chest(pos)
	end
end

core.set_gen_notify("dungeon")
core.register_on_generated(function(minp, maxp, blockseed)
	local ntf = core.get_mapgen_object("gennotify")
	if ntf and ntf.dungeon and #ntf.dungeon > 3 then
		core.after(3, place_spawner, table.copy(ntf.dungeon))
	end
end)
