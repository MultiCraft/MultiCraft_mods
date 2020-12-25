--
-- Sounds
--

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "default_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "default_place_node_hard", gain = 1.0}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.3}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_dirt_footstep", gain = 0.4}
	table.dug = table.dug or
			{name = "default_dirt_footstep", gain = 1.0}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_sand_footstep", gain = 0.12}
	table.dug = table.dug or
			{name = "default_sand_footstep", gain = 0.24}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_gravel_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_gravel_footstep", gain = 0.1}
	table.dig = table.dig or
			{name = "default_gravel_dig", gain = 0.35}
	table.dug = table.dug or
			{name = "default_gravel_dug", gain = 1.0}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_wood_footstep", gain = 0.3}
	table.dug = table.dug or
			{name = "default_wood_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_grass_footstep", gain = 0.45}
	table.dug = table.dug or
			{name = "default_grass_footstep", gain = 0.7}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_glass_footstep", gain = 0.3}
	table.dig = table.dig or
			{name = "default_glass_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "default_break_glass", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_metal_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_metal_footstep", gain = 0.4}
	table.dig = table.dig or
			{name = "default_dig_metal", gain = 0.5}
	table.dug = table.dug or
			{name = "default_dug_metal", gain = 0.5}
	table.place = table.place or
			{name = "default_place_node_metal", gain = 0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_water_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_water_footstep", gain = 0.2}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_snow_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_snow_footstep", gain = 0.2}
	table.dig = table.dig or
			{name = "default_snow_footstep", gain = 0.3}
	table.dug = table.dug or
			{name = "default_snow_footstep", gain = 0.3}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wool_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_wool_footstep", gain = 0.4}
	table.dig = table.dig or
			{name = "default_wool_footstep", gain = 0.6}
	table.dug = table.dug or
			{name = "default_wool_footstep", gain = 0.6}
	table.place = table.place or
			{name = "default_wool_footstep", gain = 1.0}
	return table
end

--
-- Lavacooling
--

default.cool_lava = function(pos, node)
	if node.name == "default:lava_source" then
		minetest.set_node(pos, {name = "default:obsidian"})
	else -- Lava flowing
		minetest.set_node(pos, {name = "default:stone"})
	end
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end

if minetest.settings:get_bool("enable_lavacooling") ~= false then
	minetest.register_abm({
		label = "Lava cooling",
		nodenames = {"default:lava_source", "default:lava_flowing"},
		neighbors = {"group:cools_lava", "group:water"},
		interval = 3,
		chance = 2,
		catch_up = false,
		action = function(...)
			default.cool_lava(...)
		end,
	})
end


--
-- Optimized helper to put all items in an inventory into a drops list
--

function default.get_inventory_drops(pos, inventory, drops)
	local inv = minetest.get_meta(pos):get_inventory()
	local n = #drops
	for i = 1, inv:get_size(inventory) do
		local stack = inv:get_stack(inventory, i)
		if stack:get_count() > 0 then
			drops[n+1] = stack:to_table()
			n = n + 1
		end
	end
end


--
-- Sugarcane and cactus growing
--

-- Wrapping the functions in ABM action is necessary to make overriding them possible

function default.grow_cactus(pos, node)
	if node.param2 >= 4 then
		return
	end
	pos.y = pos.y - 1
	if minetest.get_item_group(minetest.get_node(pos).name, "sand") == 0 then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:cactus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	if minetest.get_node_light(pos) < 13 then
		return
	end
	minetest.set_node(pos, {name = "default:cactus"})
	return true
end

function default.grow_sugarcane(pos, node)
	pos.y = pos.y - 1
	local name = minetest.get_node(pos).name
	if name ~= "default:dirt" and
			name ~= "default:dirt_with_grass" and
			name ~= "default:dirt_with_dry_grass" then
		return
	end
	if not minetest.find_node_near(pos, 3, {"group:water"}) then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:sugarcane" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	if minetest.get_node_light(pos) < 13 then
		return
	end
	minetest.set_node(pos, {name = "default:sugarcane"})
	return true
end

minetest.register_abm({
	label = "Grow cactus",
	nodenames = {"default:cactus"},
	neighbors = {"group:sand"},
	interval = 15,
	chance = 75,
	action = function(...)
		default.grow_cactus(...)
	end
})

if not minetest.settings:get_bool("creative_mode") then
	local objects = minetest.get_objects_inside_radius
	minetest.register_abm({
		label = "Cactus damage",
		nodenames = {"default:cactus"},
		interval = 1,
		chance = 1,
		catch_up = false,
		action = function(pos)
			local players = objects(pos, 1)
			for _, player in pairs(players) do
				if player:is_player() then
					player:set_hp(player:get_hp() - 2)
				end
			end
		end
	})
end

minetest.register_abm({
	label = "Grow sugarcane",
	nodenames = {"default:sugarcane"},
	neighbors = {
		"default:dirt",
		"default:dirt_with_grass",
		"default:dirt_with_dry_grass"
	},
	interval = 15,
	chance = 70,
	action = function(...)
		default.grow_sugarcane(...)
	end
})


--
-- Dig upwards
--

function default.dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end

--
-- Dig downwards
--

function default.dig_down(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y - 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end


--
-- Fence registration helper
--

function default.register_fence(name, def)
	minetest.register_craft({
		output = name .. " 4",
		recipe = {
			{def.material, "default:stick", def.material},
			{def.material, "default:stick", def.material}
		}
	})

	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed		  =  {-1/8,  -1/2,  -1/8,   1/8,  1/2,  1/8},
			connect_front = {{-1/16,  2/8, -1/2,   1/16, 7/16, -1/8},
							 {-1/16, -1/8, -1/2,   1/16, 1/16, -1/8}},
			connect_left  = {{-1/2,   2/8, -1/16, -1/8,  7/16,  1/16},
							 {-1/2,  -1/8, -1/16, -1/8,  1/16,  1/16}},
			connect_back  = {{-1/16,  2/8,  1/8,   1/16, 7/16,  1/2},
							 {-1/16, -1/8,  1/8,   1/16, 1/16,  1/2}},
			connect_right = {{ 1/8,   2/8, -1/16,  1/2,  7/16,  1/16},
							 { 1/8,  -1/8, -1/16,  1/2,  1/16,  1/16}}
		},
		collision_box = {
			type = "connected",
			fixed		  = {-1/8, -1/2, -1/8,  1/8, 7/8,  1/8},
			connect_front = {-1/8, -1/2, -1/2,  1/8, 7/8, -1/8},
			connect_left  = {-1/2, -1/2, -1/8, -1/8, 7/8,  1/8},
			connect_back  = {-1/8, -1/2,  1/8,  1/8, 7/8,  1/2},
			connect_right = { 1/8, -1/2, -1/8,  1/2, 7/8,  1/8}
		},
		connects_to = {"group:fence", "group:wood", "group:tree", "group:wall"},
		tiles = {def.texture},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {}
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	-- Always add to the fence group, even if no group provided
	def.groups.fence = 1

	def.texture = nil
	def.material = nil

	minetest.register_node(name, def)
end


--
-- Ladder registration helper
--

function default.register_ladder(name, def)
	minetest.register_craft({
		output = name .. " 2",
		recipe = {
			{def.material, "", def.material},
			{def.material, def.material, def.material},
			{def.material, "", def.material}
		}
	})

	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		paramtype2 = "wallmounted",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.5, -0.5,  -0.25,  -0.375, 0.5},		-- Strut Left
				{ 0.25,  -0.5, -0.5,   0.375, -0.375, 0.5},		-- Strut Right
				{-0.438, -0.5,  0.312, 0.438, -0.35,  0.435},	-- Rung 1
				{-0.438, -0.5,  0.06,  0.438, -0.35,  0.185},	-- Rung 2
				{-0.438, -0.5, -0.185, 0.438, -0.35, -0.06},	-- Rung 3
				{-0.438, -0.5, -0.435, 0.438, -0.35, -0.31}		-- Rung 4
			}
		},
		selection_box = {
			type = "wallmounted",
			wall_top    = {-0.438,  0.35, -0.5,    0.438,  0.5,  0.5},
			wall_bottom = {-0.438, -0.5,  -0.5,    0.438, -0.35, 0.5},
			wall_side   = {-0.5,   -0.5,  -0.438, -0.35,   0.5,  0.438}
		},
		sunlight_propagates = true,
		walkable = false,
		climbable = true,
		is_ground_content = false,
		groups = {}
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	-- Always add to the fence group, even if no group provided
	def.groups.ladder = 1

	def.material = nil

	minetest.register_node(name, def)
end


--
-- Leafdecay
--

-- Prevent decay of placed leaves

default.after_place_leaves = function(pos, placer)
	if placer and placer:is_player() then
		local node = minetest.get_node(pos)
		node.param2 = 1
		minetest.set_node(pos, node)
	end
end

-- Leafdecay
local function leafdecay_after_destruct(pos, _, def)
	for _, v in pairs(minetest.find_nodes_in_area(vector.subtract(pos, def.radius),
			vector.add(pos, def.radius), def.leaves)) do
		local node = minetest.get_node(v)
		local timer = minetest.get_node_timer(v)
		if node.param2 ~= 1 and not timer:is_started() then
			timer:start(math.random(40, 160) / 10)
		end
	end
end

local function leafdecay_on_timer(pos, def)
	if minetest.find_node_near(pos, def.radius, def.trunks) then
		return false
	end

	local node = minetest.get_node(pos)
	local drops = minetest.get_node_drops(node.name)
	for _, item in ipairs(drops) do
		local is_leaf
		for _, v in pairs(def.leaves) do
			if v == item then
				is_leaf = true
			end
		end
		if minetest.get_item_group(item, "leafdecay_drop") ~= 0 or
				not is_leaf then
			minetest.add_item({
				x = pos.x - 0.5 + math.random(),
				y = pos.y - 0.5 + math.random(),
				z = pos.z - 0.5 + math.random()
			}, item)
		end
	end

	minetest.remove_node(pos)
	minetest.check_for_falling(pos)
end

function default.register_leafdecay(def)
	assert(def.leaves)
	assert(def.trunks)
	assert(def.radius)
	for _, v in pairs(def.trunks) do
		minetest.override_item(v, {
			after_destruct = function(pos)
				leafdecay_after_destruct(pos, _, def)
			end
		})
	end
	for _, v in pairs(def.leaves) do
		minetest.override_item(v, {
			on_timer = function(pos)
				leafdecay_on_timer(pos, def)
			end
		})
	end
end


--
-- Convert dirt to something that fits the environment
--

minetest.register_abm({
	label = "Grass spread",
	nodenames = {
		"default:dirt",
		"default:dirt_with_snow"
	},
	neighbors = {
		"air",
		"group:grass",
		"group:dry_grass",
		"default:snow"
	},
	interval = 10,
	chance = 15,
	catch_up = false,
	action = function(pos)
		-- Check for darkness: night, shadow or under a light-blocking node
		-- Returns if ignore above
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above) or 0) < 13 then
			return
		end

		-- Look for spreading dirt-type neighbours
		local p2 = minetest.find_node_near(pos, 1, "group:spreading_dirt_type")
		if p2 then
			local n3 = minetest.get_node(p2)
			minetest.set_node(pos, {name = n3.name})
			return
		end

		-- Else, any seeding nodes on top?
		local name = minetest.get_node(above).name
		-- Snow check is cheapest, so comes first
		if name == "default:snow" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		elseif minetest.get_item_group(name, "grass") ~= 0 then
			minetest.set_node(pos, {name = "default:dirt_with_grass"})
		elseif minetest.get_item_group(name, "dry_grass") ~= 0 then
			minetest.set_node(pos, {name = "default:dirt_with_dry_grass"})
		end
	end
})


--
-- Grass and dry grass removed in darkness
--

minetest.register_abm({
	label = "Grass covered",
	nodenames = {"group:spreading_dirt_type"},
	interval = 10,
	chance = 40,
	catch_up = false,
	action = function(pos)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
				nodedef.paramtype == "light") and
				nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "default:dirt"})
		end
	end
})


--
-- Moss growth on cobble near water
--

local moss_correspondences = {
	["default:cobble"] = "default:mossycobble",
	["stairs:slab_default_cobble"] = "stairs:slab_default_mossycobble",
	["stairs:stair_default_cobble"] = "stairs:stair_default_mossycobble",
	["stairs:innerstair_default_cobble"] = "stairs:innerstair_default_mossycobble",
	["stairs:outerstair_default_cobble"] = "stairs:outerstair_default_mossycobble",
	["walls:cobble"] = "walls:mossycobble"
}
minetest.register_abm({
	label = "Moss growth",
	nodenames = {"default:cobble", "stairs:slab_default_cobble", "stairs:stair_default_cobble",
		"stairs:innerstair_default_cobble", "stairs:outerstair_default_cobble",
		"walls:cobble"
	},
	neighbors = {"group:water"},
	interval = 15,
	chance = 100,
	catch_up = false,
	action = function(pos, node)
		node.name = moss_correspondences[node.name]
		if node.name then
			minetest.set_node(pos, node)
		end
	end
})

--
-- Register a craft to copy the metadata of items
--

function default.register_craft_metadata_copy(ingredient, result)
	minetest.register_craft({
		type = "shapeless",
		output = result,
		recipe = {ingredient, result}
	})

	minetest.register_on_craft(function(itemstack, _, old_craft_grid, craft_inv)
		if itemstack:get_name() ~= result then
			return
		end

		local original
		local index
		for i = 1, #old_craft_grid do
			if old_craft_grid[i]:get_name() == result then
				original = old_craft_grid[i]
				index = i
			end
		end
		if not original then
			return
		end
		local copymeta = original:get_meta():to_table()
		itemstack:get_meta():from_table(copymeta)
		-- put the book with metadata back in the craft grid
		craft_inv:set_stack("craft", index, original)
	end)
end


function default.can_interact_with_node(player, pos)
	if player and player:is_player() then
		if minetest.check_player_privs(player, "protection_bypass") then
			return true
		end
	else
		return false
	end

	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	if not owner or owner == "" or owner == player:get_player_name() then
		return true
	end
	return false
end

--
-- Snowballs
--

-- Shoot snowball
local function snowball_impact(thrower, pos, dir, hit_object)
	if hit_object then
		local punch_damage = {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 1}
		}
		hit_object:punch(thrower, 1.0, punch_damage, dir)
	end
	local node_pos
	local node = minetest.get_node(pos)
	if node.name == "air" then
		local pos_under = vector.subtract(pos, {x = 0, y = 1, z = 0})
		node = minetest.get_node(pos_under)
		if node.name then
			local def = minetest.registered_items[node.name] or {}
			if def.buildable_to then
				node_pos = pos_under
			elseif def.walkable then
				node_pos = pos
			end
		elseif node.name then
			local def = minetest.registered_items[node.name]
			if def and def.buildable_to then
				node_pos = pos
			end
		end
		if node_pos then
			if not minetest.is_protected(node_pos, thrower and thrower:get_player_name() or "") then
				minetest.add_node(pos, {name = "default:snow"})
				minetest.spawn_falling_node(pos)
			end
		end
	end
end

function default.snow_shoot_snowball(itemstack, thrower)
	if not thrower or not thrower:is_player() then
		return
	end
	local playerpos = thrower:get_pos()
	if not minetest.is_valid_pos(playerpos) then
		return
	end
	local obj = minetest.item_throw("default:snowball", thrower, 19, -3,
		snowball_impact)
	if obj then
		obj:set_properties({
			visual = "sprite",
			visual_size = {x = 1, y = 1},
			textures = {"default_snowball.png"}
		})
		minetest.sound_play("throwing_sound", {
			pos = playerpos,
			gain = 0.7,
			max_hear_distance = 10
		})
		if not (creative and creative.is_enabled_for and
				creative.is_enabled_for(thrower)) or
				not minetest.is_singleplayer() then
			itemstack:take_item()
		end
	end
	return itemstack
end

--
-- Liquid particles
--

if minetest.settings:get_bool("enable_liquid_particles") ~= false then
	local add_particlespawner = minetest.add_particlespawner
	local get_node = minetest.get_node
	local registered_nodes = minetest.registered_nodes

	minetest.register_abm({
		label = "Liquid particles",
		nodenames = {"group:liquid"},
		interval = 15,
		chance = 3,
		catch_up = false,
		action = function(pos, node)
			local nname = node.name
			if get_node({x = pos.x, y = pos.y - 2, z = pos.z}).name == "air" then
				local tiles = registered_nodes[nname].tiles
				local texture = tiles[1]
				if texture.name ~= nil then
					texture = texture.name
				end

				add_particlespawner({
					amount = 5,
					time = 15,
					minpos = {x = pos.x - 0.5, y = pos.y - 1, z = pos.z - 0.5},
					maxpos = {x = pos.x + 0.5, y = pos.y - 1, z = pos.z + 0.5},
					minvel = {x = 0, y = -1, z = 0},
					maxvel = {x = 0, y = -1, z = 0},
					minexptime = 2,
					maxexptime = 4,
					vertical = true,
					texture = texture .. "^[resize:16x16^[mask:default_liquid_drop.png"
				})
			end

			if (nname == "default:lava_source" or nname == "default:lava_flowing")
			and get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
				add_particlespawner({
					amount = 5,
					time = 15,
					minpos = {x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5},
					maxpos = {x = pos.x + 0.5, y = pos.y, z = pos.z + 0.5},
					minvel = {x = 0, y = 1, z = 0},
					maxvel = {x = 0, y = 1, z = 0},
					minexptime = 2,
					maxexptime = 2,
					vertical = true,
					texture = "default_lava.png",
					glow = 3
				})
			end
		end
	})
end
