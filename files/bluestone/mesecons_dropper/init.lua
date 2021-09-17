--[[ This mod registers 3 nodes:
- One node for the horizontal-facing dropper (mesecons_dropper:dropper)
- One node for the upwards-facing droppers (mesecons_dropper:dropper_up)
- One node for the downwards-facing droppers (mesecons_dropper:dropper_down)

3 node definitions are needed because of the way the textures are defined.
All node definitions share a lot of code, so this is the reason why there
are so many weird tables below.
]]

local S = mesecon.S

local random, pi = math.random, math.pi
local tcopy, tinsert = table.copy, table.insert
local vsubtract = vector.subtract

local screwdriver_exists = minetest.global_exists("screwdriver")
local hopper_exists = minetest.global_exists("hopper")

local cells = ""
for x = 1, 3 do
for y = 1, 3 do
	cells = cells ..
		"item_image[" .. x + 2 .. "," .. y - 0.5 .. ";1,1;default:cell]"
end
end

-- For after_place_node
local function setup_dropper(pos)
	-- Set formspec and inventory
	local form = default.gui ..
	"item_image[0,-0.1;1,1;mesecons_dropper:dropper]" ..
	"label[0.9,0.1;" .. S("Dropper") .. "]" ..
	cells ..
	"list[current_name;main;3,0.5;3,3;]" ..
	"list[context;split;8,3.14;1,1;]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", form)
	local inv = meta:get_inventory()
	inv:set_size("main", 3 * 3)
	inv:set_size("split", 1)
end

local function orientate_dropper(pos, placer)
	-- Not placed by player
	if not placer then return end

	-- Pitch in degrees
	local pitch = placer:get_look_vertical() * (180 / pi)

	if pitch > 55 then
		minetest.swap_node(pos, {name = "mesecons_dropper:dropper_up"})
	elseif pitch < -55 then
		minetest.swap_node(pos, {name = "mesecons_dropper:dropper_down"})
	end
end

-- Shared core definition table
local dropperdef = {
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 3, dropper = 1},
	on_rotate = screwdriver_exists and screwdriver.rotate_simple,
	after_dig_node = function(pos, _, oldmetadata)
		local meta = minetest.get_meta(pos)
		local meta2 = meta
		meta:from_table(oldmetadata)
		local inv = meta:get_inventory()
		for i = 1, inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				minetest.item_drop(stack, nil, pos)
			end
		end
		meta:from_table(meta2:to_table())
	end,

	allow_metadata_inventory_move = function(pos, _, _, to_list, _, count, player)
		local name = player and player:get_player_name() or ""
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return 0
		elseif to_list == "split" then
			return 1
		else
			return count
		end
	end,

	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		local name = player and player:get_player_name() or ""
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return 0
		else
			return stack:get_count()
		end
	end,

	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		local name = player and player:get_player_name() or ""
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return 0
		else
			if listname == "split" then
				return stack:get_count() / 2
			else
				return stack:get_count()
			end
		end
	end,

	mesecons = {effector = {
		-- Drop random item when triggered
		action_on = function(pos, node)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()

			local node_name = node.name
			local droppos = pos
			if node_name == "mesecons_dropper:dropper" then
				droppos = vsubtract(pos, minetest.facedir_to_dir(node.param2))
			elseif node_name == "mesecons_dropper:dropper_up" then
				droppos.y = droppos.y + 1
			elseif node_name == "mesecons_dropper:dropper_down" then
				droppos.y = droppos.y - 1
			end

			local dropnode = minetest.get_node(droppos)
			local dropnode_name = dropnode.name

			-- Upwards-Facing Dropper can move items to Hopper
			local hopper = hopper_exists and
					(node_name == "mesecons_dropper:dropper_up" and
					dropnode_name == "hopper:hopper") or
					(node_name == "mesecons_dropper:dropper_down" and
					dropnode_name == "hopper:hopper" or dropnode_name == "hopper:hopper_side")

			if not hopper then
				-- Do not drop into solid nodes
				local dropnodedef = minetest.registered_nodes[dropnode_name]
				if dropnodedef.walkable then
					return
				end
			end

			local stacks = {}
			for i = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", i)
				if not stack:is_empty() then
					tinsert(stacks, {stack = stack, stackpos = i})
				end
			end

			if #stacks >= 1 then
				local r = random(1, #stacks)
				local stack = stacks[r].stack
				local dropitem = ItemStack(stack)
				dropitem:set_count(1)
				local stack_id = stacks[r].stackpos

				if hopper then
					-- Move to Hopper
					local hopper_inv = minetest.get_meta(droppos):get_inventory()
					if not hopper_inv or
							not hopper_inv:room_for_item("main", dropitem) then
						return
					end
					hopper_inv:add_item("main", dropitem)
				else
					-- Drop item
					minetest.add_item(droppos, dropitem)
				end
				stack:take_item()
				inv:set_stack("main", stack_id, stack)
			end
		end,

		rules = mesecon.rules.alldirs
	}}
}

local ttop = "default_furnace_top.png"
local tside = "default_furnace_side.png"

-- Horizontal dropper
local horizontal_def = tcopy(dropperdef)
horizontal_def.description = S("Dropper")
horizontal_def.after_place_node = function(pos, placer)
	local name = placer and placer:get_player_name() or ""
	minetest.get_meta(pos):set_string("owner", name)

	setup_dropper(pos, placer)
	orientate_dropper(pos, placer)
end
horizontal_def.tiles = {
	ttop, ttop,
	tside, tside,
	tside, tside ..
		"^mesecons_dropper_front.png^mesecons_dropper_front_horizontal.png"
}
horizontal_def.paramtype2 = "facedir"
minetest.register_node("mesecons_dropper:dropper", horizontal_def)

-- Down dropper
local down_def = tcopy(dropperdef)
down_def.after_place_node = function(pos, placer)
	local name = placer and placer:get_player_name() or ""
	minetest.get_meta(pos):set_string("owner", name)

	setup_dropper(pos, placer)
end
down_def.tiles = {
	ttop, ttop .. "^mesecons_dropper_front_vertical.png",
	tside, tside,
	tside, tside
}
down_def.groups.not_in_creative_inventory = 1
down_def.drop = "mesecons_dropper:dropper"
minetest.register_node("mesecons_dropper:dropper_down", down_def)

-- Up dropper
local up_def = tcopy(down_def)
up_def.tiles = {
	ttop .. "^mesecons_dropper_front_vertical.png", ttop,
	tside, tside,
	tside, tside
}
minetest.register_node("mesecons_dropper:dropper_up", up_def)

minetest.register_craft({
	output = "mesecons_dropper:dropper",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"},
		{"default:cobble", "mesecons:wire_00000000_off", "default:cobble"},
		{"default:cobble", "default:chest", "default:cobble"},
	}
})

if hopper_exists then
	hopper.add_container({
		{"bottom", "mesecons_dropper:dropper", "main"},
		{"tside", "mesecons_dropper:dropper", "main"},
		{"bottom", "mesecons_dropper:dropper_down", "main"},
		{"tside", "mesecons_dropper:dropper_down", "main"},
		{"tside", "mesecons_dropper:dropper_up", "main"}
	})
end
