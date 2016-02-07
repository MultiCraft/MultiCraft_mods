fire = {}
fire.mod = "redo"

-- initial check to see if fire is disabled
local disable_fire = minetest.setting_getbool("disable_fire")

minetest.register_node("fire:basic_flame", {
	description = "Basic Flame",
	drawtype = "plantlike",
	tiles = {
		{
			name = "fire_basic_flame_animated.png",
			animation = {
				type="vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1
			},
		},
	},
	inventory_image = "fire_basic_flame.png",
	paramtype = "light",
	light_source = 14,
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	damage_per_second = 4,
	groups = {igniter = 2, dig_immediate = 3},
	drop = '',
	on_blast = function()
	end, -- unaffected by explosions
})

minetest.register_node("fire:permanent_flame", {
	description = "Permanent Flame",
	drawtype = "firelike",
	tiles = {
		{
			name = "fire_basic_flame_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1
			},
		},
	},
	inventory_image = "fire_basic_flame.png",
	paramtype = "light",
	light_source = 14,
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	damage_per_second = 4,
	groups = {igniter = 2, dig_immediate = 3},
	drop = "",

	on_blast = function()
	end,
})

-- compatibility
minetest.register_alias("fire:eternal_flame", "fire:permanent_flame")

-- extinguish flames quickly with dedicated ABM
minetest.register_abm({
	nodenames = {"fire:basic_flame"},
	interval = 7,
	chance = 2,
	catch_up = false,
	action = function(p0, node, _, _)
		if not disable_fire then return end
		minetest.set_node(p0, {name = "air"})
	end,
})

-- extinguish flames quickly with water, snow, ice
minetest.register_abm({
	nodenames = {"fire:basic_flame", "fire:permanent_flame"},
	neighbors = {"group:puts_out_fire"},
	interval = 3,
	chance = 2,
	catch_up = false,
	action = function(p0, node, _, _)
		minetest.set_node(p0, {name = "air"})
		minetest.sound_play("fire_extinguish_flame",
			{pos = p0, max_hear_distance = 16, gain = 0.15})
	end,
})

-- ignite neighboring nodes
minetest.register_abm({
	nodenames = {"group:flammable"},
	neighbors = {"group:igniter"},
	interval = 7,
	chance = 16,
	catch_up = false,
	action = function(p0, node, _, _)
		-- check to see if fire is still disabled
		disable_fire = minetest.setting_getbool("disable_fire")
		--print ("disable fire set to ", disable_fire)

		-- if there is water or stuff like that around flame, don't ignite
		if disable_fire
		or minetest.find_node_near(p0, 1, {"group:puts_out_fire"}) then
			return
		end
		local p = minetest.find_node_near(p0, 1, {"air"})
		if p then
			minetest.set_node(p, {name = "fire:basic_flame"})
		end
	end,
})

-- remove flammable nodes and flame
minetest.register_abm({
	nodenames = {"fire:basic_flame"},
	interval = 5,
	chance = 16,
	catch_up = false,
	action = function(p0, node, _, _)

		-- If there are no flammable nodes around flame, remove flame
		if not minetest.find_node_near(p0, 1, {"group:flammable"}) then
			minetest.set_node(p0, {name = "air"})
			return
		end

		if math.random(1, 4) == 1 then
			-- remove a flammable node around flame
			local p = minetest.find_node_near(p0, 1, {"group:flammable"})
			if p then
				minetest.set_node(p, {name = "air"})
--				nodeupdate(p)
			end
		end
	end,
})