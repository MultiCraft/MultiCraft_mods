local S = farming_addons.S

-- spawn snow golem
--[[local function pumpkin_on_construct(pos)
	if not minetest.get_modpath("mobs_npc") then return end

	for i = 1, 2 do
		if minetest.get_node({x = pos.x, y = pos.y - i, z=pos.z}).name ~= "default:snowblock" then
			return
		end
	end

	-- if 3 snow block are placed, this will make snow golem
	for i = 0, 2 do
		minetest.remove_node({x=pos.x,y=pos.y-i,z=pos.z})
	end

	minetest.add_entity({x = pos.x, y = pos.y - 1, z = pos.z}, "mobs_npc:snow_golem")
end]]

farming.register_plant("farming_addons:pumpkin", {
	description = S"Pumpkin Seed",
	harvest_description = S"Pumpkin",
	inventory_image = "farming_addons_pumpkin_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland", "desert"},
	groups = {flammable = 4, food = 1}
})

-- how often node timers for plants will tick
local function tick(pos)
	minetest.get_node_timer(pos):start(math.random(512, 1024))
end

-- PUMPKIN FRUIT - HARVEST
minetest.register_node("farming_addons:pumpkin_fruit", {
	description = S"Pumpkin",
	tiles = {"farming_addons_pumpkin_top.png", "farming_addons_pumpkin_top.png", "farming_addons_pumpkin_side.png"},
	paramtype2 = "facedir",
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	groups = {snappy = 3, flammable = 4, fall_damage_add_percent = -30, food = 1, not_cuttable = 1, falling_node = 1},
	after_dig_node = function(_, _, oldmetadata)
		local parent = oldmetadata.fields.parent
		local parent_pos_from_child = minetest.string_to_pos(parent)
		local parent_node

		-- make sure we have position
		if parent_pos_from_child
			and parent_pos_from_child ~= nil then
			parent_node = minetest.get_node(parent_pos_from_child)
		end

		-- tick parent if parent stem still exists
		if parent_node ~= nil
				and parent_node.name == "farming_addons:pumpkin_8" then
			tick(parent_pos_from_child)
		end
	end,
--	on_construct = pumpkin_on_construct
})

minetest.register_alias_force("farming_addons:pumpkin", "farming_addons:seed_pumpkin")

-- take over the growth from farming from here
minetest.override_item("farming_addons:pumpkin_8", {
	next_plant = "farming_addons:pumpkin_fruit",
	on_timer = farming_addons.grow_block,
	drop = {
		items = {
			{items = {"farming_addons:seed_pumpkin"}},
			{items = {"farming_addons:seed_pumpkin"}, rarity = 2},
			{items = {"farming_addons:seed_pumpkin"}, rarity = 3}
		}
	}
})

--
-- Recipes
--

-- Seed
minetest.register_craft({
	output = "farming_addons:seed_pumpkin 3",
	recipe = {{"farming_addons:pumpkin_fruit"}}
})

-- Fuel
minetest.register_craft({
	type = "fuel",
	recipe = "farming_addons:pumpkin_fruit",
	burntime = 20
})

--
-- Generation
--

minetest.register_decoration({
	name = "default:grass",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 80,
	fill_ratio = 0.0001,
	y_max = 40,
	y_min = 1,
	decoration = "farming_addons:pumpkin_fruit"
})
