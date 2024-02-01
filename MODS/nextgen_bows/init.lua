nextgen_bows = {
	registered_arrows = {},
	registered_bows = {},
	player_bow_sneak = {}
}

local random, max = math.random, math.max
local vector_multiply = vector.multiply
local gravity = tonumber(minetest.settings:get("movement_gravity")) or 9.81

function nextgen_bows.register_bow(name, def)
	if name == nil or name == "" then
		return false
	end

	def.name = "nextgen_bows:" .. name
	def.name_charged = "nextgen_bows:" .. name .. "_charged"
	def.description = def.description or name
	def.uses = def.uses or 150

	nextgen_bows.registered_bows[def.name_charged] = def

	-- not charged bow
	minetest.register_tool(def.name, {
		description = def.description,
		inventory_image = def.inventory_image or "nextgen_bows_bow_wood.png",
		on_place = nextgen_bows.load,
		on_secondary_use = nextgen_bows.load,
		groups = {bow = 1, flammable = 1},
	})

	-- charged bow
	minetest.register_tool(def.name_charged, {
		description = def.description_charged or def.description,
		inventory_image = def.inventory_image_charged or "nextgen_bows_bow_wood_charged.png",
		on_use = nextgen_bows.shoot,
		groups = {bow = 1, flammable = 1, wieldview = 1, not_in_creative_inventory = 1},
		range = 0 -- player can't interact with charged bow
	})

	-- recipes
	if def.recipe then
		minetest.register_craft({
			output = def.name,
			recipe = def.recipe
		})
	end
end

function nextgen_bows.register_arrow(name, def)
	if name == nil or name == "" then
		return false
	end

	def.name = "nextgen_bows:" .. name
	def.description = def.description or name

	nextgen_bows.registered_arrows[def.name] = def

	minetest.register_craftitem("nextgen_bows:" .. name, {
		description = def.description,
		inventory_image = def.inventory_image,
		groups = {arrow = 1, flammable = 1, wieldview = 2}
	})

	-- recipes
	if def.craft then
		minetest.register_craft({
			output = def.name .." " .. (def.craft_count or 4),
			recipe = def.craft
		})
	end
end

function nextgen_bows.load(itemstack, user, pointed_thing)
	local time_load = minetest.get_us_time()
	local inv = user:get_inventory()
	local inv_list = inv:get_list("main")
	local bow_name = itemstack:get_name()

	local bow_def = nextgen_bows.registered_bows[bow_name .. "_charged"]
	local itemstack_arrows = {}

	if pointed_thing.under then
		local node = minetest.get_node(pointed_thing.under)
		local node_def = minetest.registered_nodes[node.name]

		if node_def and node_def.on_rightclick then
			return node_def.on_rightclick(pointed_thing.under, node, user, itemstack, pointed_thing)
		end
	end

	for _, st in ipairs(inv_list) do
		if not st:is_empty() and nextgen_bows.registered_arrows[st:get_name()] then
			itemstack_arrows[#itemstack_arrows + 1] = st
		end
	end

	-- take 1st found arrow in the list
	local itemstack_arrow = itemstack_arrows[1]

	if itemstack_arrow and bow_def then
		local arrow_name = itemstack_arrow:get_name()
		local bow_name_charged = nextgen_bows.registered_arrows[arrow_name].charded_bow or "nextgen_bows:bow_wood_charged"
		local _tool_capabilities = nextgen_bows.registered_arrows[arrow_name].tool_capabilities

		minetest.after(0, function(v_user, v_bow_name, v_bow_name_charged, v_time_load)
			local wielded_item = v_user:get_wielded_item()
			local wielded_item_name = wielded_item:get_name()

			if wielded_item_name == v_bow_name then
				local meta = wielded_item:get_meta()

				meta:set_string("arrow", arrow_name)
				meta:set_string("time_load", tostring(v_time_load))
				wielded_item:set_name(v_bow_name_charged)
				v_user:set_wielded_item(wielded_item)

				if not minetest.is_creative_enabled(user:get_player_name()) then
					inv:remove_item("main", arrow_name)
				end
			end
		end, user, bow_name, bow_name_charged, time_load)

		-- sound plays when charge time reaches full punch interval time
		-- @TODO: find a way to prevent this from playing when not fully charged
		minetest.after(_tool_capabilities.full_punch_interval, function(v_user, v_bow_name_charged)
			local wielded_item = v_user:get_wielded_item()
			local wielded_item_name = wielded_item:get_name()

			if wielded_item_name == v_bow_name_charged then
				minetest.sound_play("nextgen_bows_bow_loaded", {
					to_player = user:get_player_name(),
					gain = 0.6
				}, true)
			end
		end, user, bow_name_charged)

		minetest.sound_play("nextgen_bows_bow_load", {
			to_player = user:get_player_name(),
			gain = 0.6
		}, true)

		return itemstack
	end
end

function nextgen_bows.shoot(itemstack, user)
	local time_shoot = minetest.get_us_time()
	local meta = itemstack:get_meta()
	local meta_arrow = meta:get_string("arrow")
	local time_load = tonumber(meta:get_string("time_load")) or 0
	local tflp = max((time_shoot - time_load) / 1000000, 0)

	local arrow_meta = nextgen_bows.registered_arrows[meta_arrow]

	if not arrow_meta then
		return itemstack
	end

	local bow_name_charged = itemstack:get_name()
	local bow_def = nextgen_bows.registered_bows[bow_name_charged]

	local bow_name = bow_def.uncharged or bow_def.name
	local uses = bow_def.uses
	local crit_chance = bow_def.crit_chance
	local _tool_capabilities = arrow_meta.tool_capabilities
	local entity_node = arrow_meta.entity_node

	local staticdata = {
		arrow = meta_arrow,
		user_name = user:get_player_name(),
		is_critical_hit = false,
		_tool_capabilities = _tool_capabilities,
		_tflp = tflp,
	}

	-- crits, only on full punch interval
	if crit_chance and crit_chance > 1 and tflp >= _tool_capabilities.full_punch_interval then
		if random(1, crit_chance) == 1 then
			staticdata.is_critical_hit = true
		end
	end

	local sound_name = "nextgen_bows_bow_shoot"
	if staticdata.is_critical_hit then
		sound_name = "nextgen_bows_bow_shoot_crit"
	end

	meta:set_string("arrow", "")
	itemstack:set_name(bow_name)

	local pos = user:get_pos()
	local dir = user:get_look_dir()
	local arrow_pos = {x = pos.x, y = pos.y + 1.5, z = pos.z}
	local obj = minetest.add_entity(arrow_pos, "nextgen_bows:arrow_entity", minetest.serialize(staticdata))

	if not obj then
		return itemstack
	end

	obj:set_properties({
		textures = {entity_node}
	})

	local strength_multiplier = tflp

	if strength_multiplier > _tool_capabilities.full_punch_interval then
		strength_multiplier = 1
	end

	local strength = 30 * strength_multiplier

	obj:set_velocity(vector_multiply(dir, strength))
	obj:set_acceleration({x = dir.x * -3, y = -gravity, z = dir.z * -3})
	obj:set_yaw(minetest.dir_to_yaw(dir))

	if not minetest.is_creative_enabled(user:get_player_name()) then
		itemstack:add_wear(65535 / uses)
	end

	minetest.sound_play(sound_name, {
		gain = 0.3,
		pos = user:get_pos(),
		max_hear_distance = 10
	}, true)

	return itemstack
end

function nextgen_bows.particle_effect(pos, type)
	if type == "bubble" then
		return minetest.add_particlespawner({
			amount = 1,
			time = 1,
			minpos = pos,
			maxpos = pos,
			minvel = {x=1, y=1, z=0},
			maxvel = {x=1, y=1, z=0},
			minacc = {x=1, y=1, z=1},
			maxacc = {x=1, y=1, z=1},
			minexptime = 0.2,
			maxexptime = 0.5,
			minsize = 0.5,
			maxsize = 1,
			texture = "bubble.png"
		})
	end
end

-- sneak, fov adjustments when bow is charged
minetest.register_playerstep(function(_, playernames)
	for _, name in ipairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			local stack = player:get_wielded_item()
			local item = stack:get_name()

			if not item then
				return
			end

			if not nextgen_bows.player_bow_sneak[name] then
				nextgen_bows.player_bow_sneak[name] = {}
			end

			if item == "nextgen_bows:bow_wood_charged" and not nextgen_bows.player_bow_sneak[name].sneak then
				pova.add_override(player, "nextgen_bows:speed", {["speed"] = -0.5})
				pova.do_override(player)

				nextgen_bows.player_bow_sneak[name].sneak = true
				player:set_fov(0.9, true, 0.4)
			elseif item ~= "nextgen_bows:bow_wood_charged" and nextgen_bows.player_bow_sneak[name].sneak then
				pova.del_override(player, "nextgen_bows:speed")
				pova.do_override(player)

				nextgen_bows.player_bow_sneak[name].sneak = false
				player:set_fov(1, true, 0.4)
			end
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	nextgen_bows.player_bow_sneak[player:get_player_name()] = nil
end)

local path = minetest.get_modpath("nextgen_bows")
dofile(path .. "/arrow.lua")
dofile(path .. "/items.lua")
