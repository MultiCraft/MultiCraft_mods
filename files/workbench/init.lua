local workbench = {}
local min, ceil = math.min, math.ceil

-- Nodes allowed to be cut
-- Only the regular, solid blocks without metas or explosivity can be cut
local nodes = {}
for node, def in pairs(minetest.registered_nodes) do
	if 	(def.drawtype == "normal" or def.drawtype:sub(1,5) == "glass" or def.drawtype:sub(1,8) == "allfaces") and
		(def.tiles and type(def.tiles[1]) == "string") and
		not def.on_rightclick and
		not def.on_blast and
		not def.on_metadata_inventory_put and
		not (def.groups.not_in_creative_inventory == 1) and
		not (def.groups.not_cuttable == 1) and
		not def.groups.colorglass and
		not def.mesecons
	then
		nodes[#nodes+1] = node
	end
end

setmetatable(nodes, {
	__concat = function(t1, t2)
		for i=1, #t2 do
			t1[#t1+1] = t2[i]
		end
		return t1
	end
})

local valid_block = {}
for _, v in pairs(nodes) do
	valid_block[v] = true
end

-- Nodeboxes definitions
workbench.defs = {
	-- Name		  Yield   X  Y   Z  W   H  L
	{"micropanel",	8,	{ 0, 0,  0, 16, 1, 8  }},
	{"microslab",	4,	{ 0, 0,  0, 16, 1, 16 }},
	{"thinstair",	4,	{ 0, 7,  0, 16, 1, 8   },
						{ 0, 15, 8, 16, 1, 8  }},
	{"cube",		4,	{ 0, 0,  0, 8,  8, 8  }},
	{"panel",		4,	{ 0, 0,  0, 16, 8, 8  }},
	{"slab",		2,	{ 0, 0,  0, 16, 8, 16 }},
	{"doublepanel",	2,	{ 0, 0,  0, 16, 8, 8   },
						{ 0, 8,  8, 16, 8, 8  }},
	{"halfstair",	2,	{ 0, 0,  0, 8,  8, 16  },
						{ 0, 8,  8, 8,  8, 8  }},
	{"outerstair",	1,	{ 0, 0,  0, 16, 8, 16  },
						{ 0, 8,  8, 8,  8, 8  }},
	{"stair",		1,	{ 0, 0,  0, 16, 8, 16  },
						{ 0, 8,  8, 16, 8, 8  }},
	{"slope",		2,	nil					   },
	{"innerstair",	1,	{ 0, 0,  0, 16, 8, 16  },
						{ 0, 8,  8, 16, 8, 8   },
						{ 0, 8,  0, 8,  8, 8  }}
}

-- Tools allowed to be repaired
function workbench:repairable(stack)
	local tools = {"pick", "axe", "shovel", "sword", "hoe", "armor", "shield"}
	for _, t in pairs(tools) do
		if stack:find(t) then return true end
	end
	return false
end

function workbench:get_output(inv, input, name)
	local output = {}
	for _, n in pairs(self.defs) do
		local count = min(n[2] * input:get_count(), input:get_stack_max())
		local item = "stairs:"..n[1].."_"..name:gsub(":", "_")
		output[#output+1] = item.." "..count
	end
	inv:set_list("forms", output)
end

-- Thanks to kaeza for this function
function workbench:pixelbox(size, boxes)
	local fixed = {}
	for _, box in pairs(boxes) do
		-- `unpack` has been changed to `table.unpack` in newest Lua versions
		local x, y, z, w, h, l = unpack(box)
		fixed[#fixed+1] = {
			(x / size) - 0.5,
			(y / size) - 0.5,
			(z / size) - 0.5,
			((x + w) / size) - 0.5,
			((y + h) / size) - 0.5,
			((z + l) / size) - 0.5
		}
	end
	return {type="fixed", fixed=fixed}
end

local formspecs = {
	--	Workbench formspec
	[[	background[-0.2,-0.26;9.41,9.49;formspec_workbench_crafting.png]
		button[0,0;2,1;creating;Creating]
		button[0,1;2,1;anvil;Repairing]
		list[current_player;craft;2,0.5;3,3;]
		list[current_player;craftpreview;6.055,1.505;1,1;] ]],
	--	Creating formspec
	[[ 	background[-0.2,-0.26;9.41,9.49;formspec_workbench_creating.png]
		button[0,0;1.5,1;back;< Back]
		image[0,1.52;1,1;workbench_saw.png]
		list[context;input;1.195,1.505;1,1;]
		list[context;forms;4.01,0.51;4,3;] ]],
	--	Repair formspec
	[[ 	background[-0.2,-0.26;9.41,9.49;formspec_workbench_anvil.png]
		button[0,0;1.5,1;back;< Back]
		image[0,1.52;1,1;workbench_anvil.png]
		list[context;tool;1.195,1.505;1,1;]
		image[4.04,1.55;1,1;hammer_layout.png]
		list[context;hammer;4.06,1.50;1,1;]	]],
}

function workbench:set_formspec(meta, id)
	meta:set_string("formspec", "size[9,8.75;]"..
		"background[-0.2,-0.26;9.41,9.49;formspec_inventory.png]" ..
		default.gui_bg..
		default.listcolors..
		"image_button_exit[8.4,-0.1;0.75,0.75;close.png;exit;;true;true;]" ..
		"list[detached:split;main;8,3.14;1,1;]"..
		"list[current_player;main;0.01,4.51;9,3;9]"..
		"list[current_player;main;0.01,7.75;9,1;]"..
		formspecs[id])
end

function workbench.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("tool", 1)
	inv:set_size("input", 1)
	inv:set_size("hammer", 1)
	inv:set_size("forms", 4*3)
	inv:set_size("storage", 9*3)

	meta:set_string("infotext", "Workbench")
	workbench:set_formspec(meta, 1)
end

function workbench.fields(pos, _, fields, sender)
	local meta = minetest.get_meta(pos)
	if		fields.back		then workbench:set_formspec(meta, 1)
	elseif	fields.creating	then workbench:set_formspec(meta, 2)
	elseif	fields.anvil	then workbench:set_formspec(meta, 3)
	elseif	fields.quit and pos and sender then
		local inv = sender:get_inventory()
		if inv then
			for i, stack in ipairs(inv:get_list("craft")) do
				minetest.item_drop(stack, nil, pos)
				stack:clear()
				inv:set_stack("craft", i, stack)
			end
		end
		inv = meta:get_inventory()
		if inv then
			for _, name in pairs({"input", "tool", "hammer"}) do
				local stack = inv:get_stack(name, 1)
				minetest.item_drop(stack, nil, pos)
				stack:clear()
				inv:set_stack(name, 1, stack)
			end
			for i, stack in ipairs(inv:get_list("forms")) do
				stack:clear()
				inv:set_stack("forms", i, stack)
			end
		end
	end
end

function workbench.timer(pos)
	local timer = minetest.get_node_timer(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	local tool = inv:get_stack("tool", 1)
	local hammer = inv:get_stack("hammer", 1)

	if tool:is_empty() or hammer:is_empty() or tool:get_wear() == 0 then
		timer:stop()
		return
	end

	-- Tool's wearing range: 0-65535 | 0 = new condition
	tool:add_wear(-500)
	hammer:add_wear(700)

	inv:set_stack("tool", 1, tool)
	inv:set_stack("hammer", 1, hammer)
	return true
end

function workbench.put(_, listname, _, stack)
	local stackname = stack:get_name()
	if (listname == "tool" and stack:get_wear() > 0 and
		workbench:repairable(stackname)) or
		(listname == "input" and valid_block[stackname]) or
		(listname == "hammer" and stackname == "workbench:hammer") or
		listname == "storage" then
		return stack:get_count()
	end
	return 0
end

function workbench.move(_, from_list, _, to_list, _, count)
	return (to_list == "storage" and from_list ~= "forms") and count or 0
end

function workbench.on_put(pos, listname, _, stack)
	local inv = minetest.get_meta(pos):get_inventory()
	if listname == "input" then
		local input = inv:get_stack("input", 1)
		workbench:get_output(inv, input, stack:get_name())
	elseif listname == "tool" or listname == "hammer" then
		local timer = minetest.get_node_timer(pos)
		timer:start(0.5)
	end
end

function workbench.on_take(pos, listname, index, stack, player)
	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("input", 1)
	local inputname = input:get_name()
	local stackname = stack:get_name()
	if listname == "input" then
		if stackname == inputname and valid_block[stackname] then
			workbench:get_output(inv, input, stackname)
		else
			inv:set_list("forms", {})
		end
	elseif listname == "forms" then
		local fromstack = inv:get_stack(listname, index)
		if not fromstack:is_empty() and fromstack:get_name() ~= stackname then
			local player_inv = player:get_inventory()
			if player_inv:room_for_item("main", fromstack) then
				player_inv:add_item("main", fromstack)
			end
		end

		input:take_item(ceil(stack:get_count() / workbench.defs[index][2]))
		inv:set_stack("input", 1, input)
		workbench:get_output(inv, input, inputname)
	end
end

minetest.register_node("workbench:workbench", {
	description = "Workbench",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	tiles = {"workbench_top.png", "workbench_top.png",
		 "workbench_sides.png", "workbench_sides.png",
		 "workbench_front.png", "workbench_front.png"},
	on_timer = workbench.timer,
	on_construct = workbench.construct,
	on_receive_fields = workbench.fields,
	on_metadata_inventory_put = workbench.on_put,
	on_metadata_inventory_take = workbench.on_take,
	allow_metadata_inventory_put = workbench.put,
	allow_metadata_inventory_move = workbench.move
})

for _, d in pairs(workbench.defs) do
	for i=1, #nodes do
		local node = nodes[i]
		local def = minetest.registered_nodes[node]

		if d[3] then
			local groups = {}
			local tiles
			groups.stairs = 1

			for k, v in pairs(def.groups) do
				if k ~= "wood" and k ~= "stone" and k ~= "level" then
					groups[k] = v
				end
			end

			if def.tiles then
				if #def.tiles > 1 and (def.drawtype:sub(1,5) ~= "glass") then
					tiles = def.tiles
				else
					tiles = {def.tiles[1]}
				end
			else
				tiles = {def.tiles[1]}
			end

			minetest.register_node(":stairs:"..d[1].."_"..node:gsub(":", "_"), {
				description = def.description.." "..d[1]:gsub("^%l", string.upper),
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "nodebox",
				sounds = def.sounds,
				tiles = tiles,
				groups = groups,
				light_source = def.light_source / 2,
				-- `unpack` has been changed to `table.unpack` in newest Lua versions
				node_box = workbench:pixelbox(16, {unpack(d, 3)}),
				sunlight_propagates = true,
				is_ground_content = false,
				on_place = minetest.rotate_node
			})

			minetest.register_node(":stairs:slope_" .. node:gsub(":", "_"), {
				description = def.description .. " Slope",
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "mesh",
				mesh = "workbench_slope.obj",
				sounds = def.sounds,
				tiles = def.tiles,
				groups = groups,
				light_source = def.light_source / 2,
				sunlight_propagates = true,
				is_ground_content = false,
				use_texture_alpha = def.use_texture_alpha,
				on_place = minetest.rotate_node,
				collision_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.5, 0.5, -0.1875, 0.5},
						{-0.5, -0.1875, -0.1875, 0.5, 0.1875, 0.5},
						{-0.5, 0.1875, 0.1875, 0.5, 0.5, 0.5},
					},
				},
			})

		end
	end
end

-- Aliases. A lot of aliases...
local stairs_aliases = {
	{"corner",		"outerstair"},
	{"invcorner",	"outerstair"},
	{"stair_outer",	"innerstair"},
	{"stair_inner",	"innerstair"},
	{"nanoslab",	"microslab"}
}

for i=1, #nodes do
	local node = nodes[i]
	for _, d in pairs(workbench.defs) do
		minetest.register_alias("stairs:"..d[1].."_"..node:match(":(.*)"), "stairs:"..d[1].."_"..node:gsub(":", "_"))
		minetest.register_alias(node.."_"..d[1],                           "stairs:"..d[1].."_"..node:gsub(":", "_"))
	end

	for _, e in pairs(stairs_aliases) do
		minetest.register_alias("stairs:"..e[1].."_"..node:match(":(.*)"), "stairs:"..e[2].."_"..node:gsub(":", "_"))
		minetest.register_alias("stairs:"..e[1].."_"..node:gsub(":", "_"), "stairs:"..e[2].."_"..node:gsub(":", "_"))
		minetest.register_alias(node.."_"..e[1],                           "stairs:"..e[2].."_"..node:gsub(":", "_"))
	end
end

for _, d in pairs(workbench.defs) do
	minetest.register_alias("stairs:"..d[1].."_coal",        "stairs:"..d[1].."_default_coalblock")
	minetest.register_alias("stairs:"..d[1].."_lapis_block", "stairs:"..d[1].."_default_lapisblock")
end

for _, e in pairs(stairs_aliases) do
	minetest.register_alias("stairs:"..e[1].."_coal",        "stairs:"..e[2].."_default_coalblock")
	minetest.register_alias("stairs:"..e[1].."_lapis_block", "stairs:"..e[2].."_default_lapisblock")
end

minetest.register_alias("stairs:stair_steel",    "stairs:stair_default_steelblock")
minetest.register_alias("stairs:slab_steel",     "stairs:slab_default_steelblock")
minetest.register_alias("stairs:corner_steel",   "stairs:corner_default_steelblock")
minetest.register_alias("stairs:stair_gold",     "stairs:stair_default_goldblock")
minetest.register_alias("stairs:slab_gold",      "stairs:slab_default_goldblock")
minetest.register_alias("stairs:corner_gold",    "stairs:corner_default_goldblock")
minetest.register_alias("stairs:stair_diamond",  "stairs:stair_default_diamondblock")
minetest.register_alias("stairs:slab_diamond",   "stairs:slab_default_diamondblock")
minetest.register_alias("stairs:corner_diamond", "stairs:corner_default_diamondblock")

-- Craft items

minetest.register_craftitem("workbench:hammer", {
	description = "Hammer",
	inventory_image = "workbench_hammer.png",
	on_use = function() do return end end
})

minetest.register_craft({
	output = "workbench:workbench",
	recipe = {
		{"group:wood", "group:wood"},
		{"group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "workbench:hammer",
	recipe = {
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"", "group:stick", ""}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "workbench:workbench",
	burntime = 30,
})
