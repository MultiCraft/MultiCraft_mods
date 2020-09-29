local translator = minetest.get_translator
local S = translator and translator("sponge") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end


local area = 3

-- removing the air-like nodes
local destruct = function(pos)
	for x = pos.x - area, pos.x + area do
	for y = pos.y - area, pos.y + area do
	for z = pos.z - area, pos.z + area do
		local node = minetest.get_node({x = x, y = y, z = z}).name
		if node == "sponge:liquid_stop" then
			minetest.remove_node({x = x, y = y, z = z})
		end
	end
	end
	end
end

-- air-like node
minetest.register_node("sponge:liquid_stop", {
	drawtype = "airlike",
	drop = "",
	groups = {not_in_creative_inventory = 1},
	pointable = false,
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true
})

-- Dry Sponge
minetest.register_node("sponge:sponge", {
	description = S"Sponge",
	tiles = {"sponge_sponge.png"},
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3, not_cuttable = 1},

	after_place_node = function(pos, placer)
		local name = placer:get_player_name()
		if not minetest.is_protected_action(pos, name) then
			local count = 0
			for x = pos.x - area, pos.x + area do
			for y = pos.y - area, pos.y + area do
			for z = pos.z - area, pos.z + area do
				local n = minetest.get_node({x = x, y = y, z = z}).name
				local d = minetest.registered_nodes[n]
				if d ~= nil and (n == "air" or
						d["drawtype"] == "liquid" or
						d["drawtype"] == "flowingliquid") then
					local p = {x = x, y = y, z = z}
					if n ~= "air" then
						count = count + 1 -- counting liquids
					end
					minetest.set_node(p, {name = "sponge:liquid_stop"})
				end
			end
			end
			end

			if count > area then -- turns wet if it removed more than * nodes
				minetest.set_node(pos, {name = "sponge:wet_sponge"})
			end
		end
	end,

	after_dig_node = destruct
})

-- Wet Sponge
minetest.register_node("sponge:wet_sponge", {
	description = S"Wet Sponge",
	tiles = {"sponge_sponge_wet.png"},
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3,
			not_in_creative_inventory = 1},

	on_destruct = destruct
})

-- Cooking wet sponge back into dry sponge
minetest.register_craft({
	type = "cooking",
	recipe = "sponge:wet_sponge",
	output = "sponge:sponge",
	cooktime = 4
})

-- Sponges are found deep in the sea
minetest.register_decoration({
	name = "sponge:sponges",
	deco_type = "simple",
	place_on = {"default:sand"},
	spawn_by = "default:water_source",
	num_spawn_by = 3,
	fill_ratio = 0.0003,
	y_max = -12,
	flags = "force_placement",
	decoration = "sponge:wet_sponge"
})
