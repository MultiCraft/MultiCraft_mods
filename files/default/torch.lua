minetest.register_node("default:torch", {
	description = "Torch",
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	tiles = {
		"default_torch_on_floor_top.png",
		"default_torch_on_floor_bottom.png",
		"default_torch_on_floor.png",
		"default_torch_on_floor.png",
		"default_torch_on_floor.png",
		"default_torch_on_floor.png"
	},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = default.LIGHT_MAX - 1,
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	liquids_pointable = false,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.125, 0.0625}, -- NodeBox1
		}
	},
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5 - 0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5 + 0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5 + 0.3, 0.3, 0.1},
	},
})


local function get_chest_neighborpos(pos, param2, side)
    if side == "right" then
        if param2 == 0 then
            return {x=pos.x-1, y=pos.y, z=pos.z}
        elseif param2 == 1 then
            return {x=pos.x, y=pos.y, z=pos.z+1}
        elseif param2 == 2 then
            return {x=pos.x+1, y=pos.y, z=pos.z}
        elseif param2 == 3 then
            return {x=pos.x, y=pos.y, z=pos.z-1}
        end
    else
        if param2 == 0 then
            return {x=pos.x+1, y=pos.y, z=pos.z}
        elseif param2 == 1 then
            return {x=pos.x, y=pos.y, z=pos.z-1}
        elseif param2 == 2 then
            return {x=pos.x-1, y=pos.y, z=pos.z}
        elseif param2 == 3 then
            return {x=pos.x, y=pos.y, z=pos.z+1}
        end
    end
end

local function hacky_swap_node(pos,name, param2)
    local node = minetest.env:get_node(pos)
    local meta = minetest.env:get_meta(pos)
    if node.name == name then
        return
    end
    node.name = name
    node.param2 = param2 or node.param2
    local meta0 = meta:to_table()
    minetest.env:set_node(pos,node)
    meta = minetest.env:get_meta(pos)
    meta:from_table(meta0)
end
