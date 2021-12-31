-- Sticky blocks can be used together with pistons or movestones to push / pull
-- structures that are "glued" together using sticky blocks

local S = mesecon.S
local tinsert = table.insert
local vadd = vector.add

minetest.register_node("bluestone_stickyblocks:slimeblock", {
	description = S("Slime Block"),
	drawtype = "nodebox",
	tiles = {"bluestone_stickyblocks_slime.png"},
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
		}
	},
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 3, fall_damage_add_percent = -100, bouncy = 75, wieldview = 4},
	mvps_sticky = function(pos)
		local connected = {}
		for _, r in ipairs(mesecon.rules.alldirs) do
			tinsert(connected, vadd(pos, r))
		end
		return connected
	end
})

-- Temporary recipe
minetest.register_craft({
	type = "cooking",
	output = "bluestone_stickyblocks:slimeblock",
	recipe = "bluestone_materials:glue",
	cooktime = 15
})
