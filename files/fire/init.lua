-- minetest/fire/init.lua (HybridDog pull request changes)

-- Tweaked by TenPlus1 to add chest drops, also removed sounds which are now
-- handled by Ambience mod.


-- Global namespace for functions

fire = {}
fire.mod = "redo"

-- Register flame nodes

local flamedef = {
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
	end, -- unaffected by explosions
}
minetest.register_node("fire:permanent_flame", table.copy(flamedef))

flamedef.description = "Basic Flame"
flamedef.drawtype = "plantlike" -- quick draw for basic flame, fancy for permanent

minetest.register_node("fire:basic_flame", flamedef)


-- Return positions for flames around a burning node

function fire.find_pos_for_flame_around(pos)
	return minetest.find_node_near(pos, 1, {"air"})
end


-- Detect nearby extinguishing nodes

function fire.flame_should_extinguish(pos)
	return minetest.find_node_near(pos, 1, {"group:puts_out_fire"})
end


-- Extinguish all flames quickly with water, snow, ice

minetest.register_abm({
	nodenames = {"fire:basic_flame", "fire:permanent_flame"},
	neighbors = {"group:puts_out_fire"},
	interval = 3,
	chance = 1,
	catch_up = false,
	action = function(p0)
		-- fire node holds no metadata so quickly swap out for air
		minetest.swap_node(p0, {name = "air"})
		minetest.sound_play("fire_extinguish_flame",
			{pos = p0, max_hear_distance = 16, gain = 0.25})
	end,
})


-- Enable the following ABMs according to 'disable fire' setting

if minetest.setting_getbool("disable_fire") then

	-- Remove basic flames only

	minetest.register_abm({
		nodenames = {"fire:basic_flame"},
		interval = 7,
		chance = 1,
		catch_up = false,
		action = function(p0)
			-- fire node holds no metadata so quickly swap out for air
			minetest.swap_node(p0, {name = "air"})
		end
	})

else

	-- Ignite neighboring nodes, add basic flames

	minetest.register_abm({
		nodenames = {"group:flammable"},
		neighbors = {"group:igniter"},
		interval = 7,
		chance = 16,
		catch_up = false,
		action = function(p0)
			-- If there is water or stuff like that around node, don't ignite
			if fire.flame_should_extinguish(p0) then
				return
			end
			local p = fire.find_pos_for_flame_around(p0)
			if p then
				-- air node holds no metadata so quickly swap out for fire
				minetest.swap_node(p, {name = "fire:basic_flame"})
			end
		end,
	})

	-- Remove basic flames and flammable nodes

	minetest.register_abm({
		nodenames = {"fire:basic_flame"},
		interval = 5,
		chance = 16,
		catch_up = false,
		action = function(p0)
			-- If there are no flammable nodes around flame, remove flame
			if not minetest.find_node_near(p0, 1, {"group:flammable"}) then
				-- fire node holds no metadata so quickly swap out for air
				minetest.swap_node(p0, {name = "air"})
				return
			end
			if math.random(1, 4) ~= 1 then
				return
			end
			-- remove flammable nodes around flame
			local p = minetest.find_node_near(p0, 1, {"group:flammable"})
			if not p then
				return
			end
			local node = minetest.get_node(p)
			local on_burn = minetest.registered_nodes[node.name].on_burn
			if on_burn then
				if type(on_burn) == "string" then
					node.name = on_burn
					minetest.set_node(p, node)
					nodeupdate(p)
					return
				end
				if on_burn(p, node) ~= false then
					return
				end
			end
			minetest.remove_node(p)
			nodeupdate(p)
		end,
	})

end


-- used to drop items inside a chest or container
function fire.drop_items(pos, invstring)

	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()

	for i = 1, inv:get_size(invstring) do

		local m_stack = inv:get_stack(invstring, i)
		local obj = minetest.add_item(pos, m_stack)

		if obj then

			obj:setvelocity({
				x = math.random(-1, 1),
				y = 3,
				z = math.random(-1, 1)
			})
		end
	end

end


-- override chest node so that it's flammable
minetest.override_item("default:chest", {

	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},

	on_burn = function(p)
		fire.drop_items(p, "main")
		minetest.remove_node(p)
	end,

})
