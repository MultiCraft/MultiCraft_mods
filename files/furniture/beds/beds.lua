beds.box = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5}

function beds.dyeing(pos, _, clicker, itemstack)
	local player_name = clicker:get_player_name()
	if minetest.is_protected(pos, player_name) then
		return false
	end

	local itemname = itemstack:get_name()
	if itemname:find("dye:") then
		minetest.swap_node(pos, {
			name = "beds:bed_" .. itemname:split(":")[2],
			param2 = minetest.get_node(pos).param2
		})

		if not minetest.is_creative_enabled(player_name) then
			itemstack:take_item()
		end

		return true
	end

	return false
end


beds.register_bed("beds:bed", {
	description = beds.S"Bed",
	inventory_image = "beds_bed_inv.png",
	wield_image = "beds_bed_inv.png",
	tiles = {"beds_bed.png", "beds_red.png"},
	mesh = "beds_bed.b3d",
	selectionbox = beds.box,
	collisionbox = beds.box,
	recipe = {
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"}
	},

	on_rightclick = beds.dyeing
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:bed",
	burntime = 12
})

minetest.register_alias("beds:bed_bottom", "beds:bed")
minetest.register_alias("beds:bed_top", "air")
