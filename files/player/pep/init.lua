pep = {}

-- Intllib
local S = intllib.make_gettext_pair()

--
-- Apply Potion
--

local function apply_potion(player, pos, potion)
	-- Particles
	minetest.add_particlespawner({
		amount = 50,
		time = 0.2,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 2, z = 1},
		minacc = {x = 0, y = -4, z = 0},
		maxacc = {x = 0, y = -8, z = 0},
		minexptime = 2,
		maxexptime = 2,
		minsize = 0.5,
		maxsize = 1.5,
		collisiondetection = false,
		vertical = false,
		glow = 3,
		texture = potion:gsub(":", "_") .. "_particle.png"
	})

	local def = minetest.registered_craftitems[potion]
	if def.effect_type then
		playereffects.apply_effect_type(def.effect_type, def.duration, player)
		minetest.sound_play("mobs_spell",
			{pos = pos, max_hear_distance = 10})
	end
end

--
-- Throw Potion
--

local function throw_potion(player, potion)
	local ppos = player:get_pos()
	if not minetest.is_valid_pos(ppos) then
		return
	end

	local function throw_potion_impact(_, ipos, _, hit_object)
		minetest.sound_play("default_break_glass",
			{pos = ipos, max_hear_distance = 20})

		if hit_object and hit_object:is_player() then
			apply_potion(hit_object, ipos, potion)
		else
			-- player search in the affected area
			for _, obj in pairs(minetest.get_objects_inside_radius(ipos, 1.5)) do
				if obj:is_player() then
					apply_potion(obj, ipos, potion)
					break
				end
			end
		end
	end

	local obj = minetest.item_throw(potion, player,
			19, 0, throw_potion_impact)
	if obj then
		local def = minetest.registered_craftitems[potion]
		local inventory_image = def and def.inventory_image
		if inventory_image then
			obj:set_properties({
				visual = "sprite",
				visual_size = {x = 0.5, y = 0.5},
				textures = {inventory_image}
			})
		end
		local ent = obj:get_luaentity()
		if ent then
			minetest.sound_play("throwing_sound", {
				pos = ppos, gain = 0.7, max_hear_distance = 10})
		else
			obj:remove()
		end
	end
end

--
-- Use Potion
--

local function use_potion(itemstack, user, pointed_thing, throw)
	if pointed_thing.type == "node" then
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local node_def = minetest.registered_nodes[node.name]
		if node_def and node_def.on_rightclick and
				not (user and user:is_player() and
				user:get_player_control().sneak) then
			return node_def.on_rightclick(under, node, user, itemstack,
				pointed_thing) or itemstack
		end
	end

	local potion = itemstack:get_name()
	local pos = user:get_pos()

	if throw then
		-- Throwing
		throw_potion(user, potion)
	else
		-- Drinking
		pos.y = pos.y + 1.2

		apply_potion(user, pos, potion)
	end

	if not (creative and creative.is_enabled_for
			and creative.is_enabled_for(user:get_player_name())) or
			not minetest.is_singleplayer() then
		itemstack:take_item()
		if not throw then
			local inventory = user:get_inventory()
			local empty_vessel = "vessels:glass_bottle"
			if inventory:room_for_item("main", empty_vessel) then
				inventory:add_item("main", empty_vessel)
			else
				minetest.add_item(pos, empty_vessel)
			end
		end
	end

	return itemstack
end

function pep.register_potion(potiondef)
	local potionname = potiondef.basename

	if potiondef.recipe then
		minetest.register_craft({
			type = "shapeless",
			output = "pep:" .. potionname,
			recipe = potiondef.recipe
		})
	end

	minetest.register_craftitem("pep:" .. potionname, {
		description = S(potiondef.contentstring),
		_doc_items_longdesc = S(potiondef.longdesc),
		inventory_image = "pep_" .. potionname .. ".png",
		wield_image = "pep_" .. potionname .. ".png",
		groups = {vessel = 1, potion = 1},
		effect_type = potiondef.effect_type,
		duration = potiondef.duration or 0,

		-- drink potion
		on_place = use_potion,
		on_secondary_use = use_potion,

		-- throw potion
		on_use = function(itemstack, user, pointed_thing)
			return use_potion(itemstack, user, pointed_thing, true)
		end
	})
end

--
-- Physics
--

local ppa = minetest.get_modpath("playerphysics")

local add_physic = function(player, attribute, value)
	if ppa then
		playerphysics.add_physics_factor(player, attribute, "pep:" .. attribute, value)
	else
		player:set_physics_override({[attribute] = value})
	end
end

local remove_physic = function(player, attribute)
	if ppa then
		playerphysics.remove_physics_factor(player, attribute, "pep:" .. attribute)
	else
		player:set_physics_override({[attribute] = 1})
	end
end

--
-- Potions
--

playereffects.register_effect_type("pepspeedplus", S("High Speed"), "pep_speedplus.png", {"speed"},
	function(player)
		add_physic(player, "speed", 2.5)
	end,
	function(_, player)
		remove_physic(player, "speed")
	end
)
pep.register_potion({
	basename = "speedplus",
	contentstring = "Running Potion",
	longdesc = "Drinking it will make you run faster for 60 seconds.",
	effect_type = "pepspeedplus",
	duration = 60,
	recipe = {
		"default:pine_sapling", "default:cactus", "flowers:oxeye_daisy",
		"default:junglegrass", "vessels:glass_bottle"
	}
})

playereffects.register_effect_type("pepspeedminus", S("Low Speed"), "pep_speedminus.png", {"speed"},
	function(player)
		add_physic(player, "speed", 0.5)
	end,
	function(_, player)
		remove_physic(player, "speed")
	end
)
pep.register_potion({
	basename = "speedminus",
	contentstring = "Slug Potion",
	longdesc = "Drinking it will make you walk slower for 60 seconds.",
	effect_type = "pepspeedminus",
	duration = 60,
	recipe = {"default:dry_grass", "default:ice", "vessels:glass_bottle"}
})

playereffects.register_effect_type("pepbreath", S("Perfect Breath"), "pep_breath.png", {"breath"},
	function(player)
		if player:get_breath() < 10 then
			player:set_breath(10)
		end
	end,
	nil, nil, nil, 2
)
pep.register_potion({
	basename = "breath",
	contentstring = "Air Potion",
	longdesc = "Drinking it gives you breath underwater for 60 seconds.",
	effect_type = "pepbreath",
	duration = 30,
	recipe = {
		"default:sugarcane", "default:sugarcane", "default:sugarcane",
		"default:sugarcane", "default:sugarcane", "default:sugarcane",
		"default:sugarcane", "default:sugarcane", "vessels:glass_bottle"
	}
})

playereffects.register_effect_type("pepregen", S("Regeneration"), "pep_regen.png", {"health"},
	function(player)
		player:set_hp(player:get_hp() + 1)
	end,
	nil, nil, nil, 2
)
pep.register_potion({
	basename = "regen",
	contentstring = "Healing Potion",
	longdesc = "Drinking it makes you regenerate health. Every 2 seconds, you get 1 HP, 20 times in total.",
	effect_type = "pepregen",
	duration = 20,
	recipe = {
		"default:cactus", "farming:flour", "flowers:mushroom_brown",
		"vessels:glass_bottle"
	}
})

playereffects.register_effect_type("pepregen2", S("Regeneration II"), "pep_regen2.png", {"health"},
	function(player)
		player:set_hp(player:get_hp() + 2)
	end,
	nil, nil, nil, 1
)
pep.register_potion({
	basename = "regen2",
	contentstring = "Healing Potion II",
	longdesc = "Drinking it makes you regenerate health quickly. Every second you get 2 HP, 30 times in total.",
	effect_type = "pepregen2",
	duration = 30,
	recipe = {"default:gold_ingot", "farming:flour", "pep:regen"}
})

playereffects.register_effect_type("pepgrav0", S("No Gravity"), "pep_grav0.png", {"gravity"},
	function(player)
		add_physic(player, "gravity", 0)
	end,
	function(_, player)
		remove_physic(player, "gravity")
	end
)
pep.register_potion({
	basename = "grav0",
	contentstring = "Non-Gravity Potion",
	longdesc = "When you drink this potion, gravity stops affecting you, as if you were in space. The effect lasts for 30 seconds.",
	effect_type = "pepgrav0",
	duration = 30,
	recipe = {"mesecons:wire_00000000_off", "vessels:glass_bottle"}
})

playereffects.register_effect_type("pepgravreset", S("Gravity Neutralizer"), "pep_gravreset.png", {"gravity"},
	function() end, function() end)
pep.register_potion({
	basename = "gravreset",
	contentstring = "Gravity Neutralizer Potion",
	longdesc = "Drinking it will stop all gravity effects you currently have.",
	effect_type = "pepgravreset",
	recipe = {"pep:grav0", "default:steel_ingot"}
})

playereffects.register_effect_type("pepjumpplus", S("High Jump"), "pep_jumpplus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 2.5)
	end,
	function(_, player)
		remove_physic(player, "jump")
	end
)
pep.register_potion({
	basename = "jumpplus",
	contentstring = "High Jumping Potion",
	longdesc = "Drinking it will make you jump higher for 60 seconds.",
	effect_type = "pepjumpplus",
	duration = 60,
	recipe = {
		"flowers:tulip", "default:grass", "mesecons:wire_00000000_off",
		"mesecons:wire_00000000_off", "vessels:glass_bottle"
	}
})

playereffects.register_effect_type("pepjumpminus", S("Low Jump"), "pep_jumpminus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 0.5)
	end,
	function(_, player)
		remove_physic(player, "jump")
	end
)
pep.register_potion({
	basename = "jumpminus",
	contentstring = "Low Jumping Potion",
	longdesc = "Drinking it will make you jump lower for 60 seconds.",
	effect_type = "pepjumpminus",
	duration = 60,
	recipe = {
		"default:leaves", "default:jungleleaves", "default:steel_ingot",
		"flowers:oxeye_daisy", "vessels:glass_bottle"
	}
})

local dark = {}
playereffects.register_effect_type("pepnightvision", S("Night Vision"), "pep_nightvision.png", {"nightvision"},
	function(player)
		player:override_day_night_ratio(
			math.min(1, minetest.get_timeofday() + 0.6))

		if not dark[player:get_player_name()] then
			local hud = player:hud_add({
				hud_elem_type = "image",
				position = {x = 0.5, y = 0.5},
				scale = {x = -100, y = -100},
				text = "pep_dark.png"
			})
			dark[player:get_player_name()] = hud
		end
	end,
	function(_, player)
		player:override_day_night_ratio(nil)

		player:hud_remove(dark[player:get_player_name()])
		dark[player:get_player_name()] = nil
	end
)
pep.register_potion({
	basename = "nightvision",
	contentstring = "Night Vision Potion",
	longdesc = "Drinking it, you will see in the dark for 60 seconds",
	effect_type = "pepnightvision",
	duration = 60,
	recipe = {
		"default:glowstone_dust","default:glowstone_dust", "default:glowstone_dust",
		"flowers:mushroom_red", "flowers:mushroom_brown", "vessels:glass_bottle"
	}
})

--
-- Invisible
--

invisibility = {} -- for compatibility with other mods

playereffects.register_effect_type("pepinvisible", S("Invisible"), "pep_invisible.png", {"invisible"},
	function(player)
		player:set_properties({
			visual_size = {x = 0, y = 0}
		})
		local nametag = player:get_nametag_attributes()
		nametag.color.a = 0
		player:set_nametag_attributes(nametag)
		invisibility[player:get_player_name()] = true
	end,
	function(_, player)
		player:set_properties({
			visual_size = {x = 1, y = 1}
		})
		local nametag = player:get_nametag_attributes()
		nametag.color.a = 255
		player:set_nametag_attributes(nametag)
		invisibility[player:get_player_name()] = nil
	end,
	nil, false
)

pep.register_potion({
	basename = "invisible",
	contentstring = "Invisible Potion",
	longdesc = "Drinking it, you will invisible for 30 seconds",
	effect_type = "pepinvisible",
	duration = 30,
	recipe = {
		"default:sapling", "default:junglesapling", "default:pine_sapling",
		"default:acacia_sapling", "default:birch_sapling", "flowers:mushroom_red",
		"vessels:glass_bottle"
	}
})

--
-- Mole
--

pep.moles = {}

function pep.moledig(playername)
	local player = minetest.get_player_by_name(playername)
	if not player then return end

	local dir = minetest.yaw_to_dir(player:get_look_horizontal())
	local pos = vector.round(player:get_pos())

	local digpos1 = vector.add(pos, dir)
	local digpos2 = {x = digpos1.x, y = digpos1.y + 1, z = digpos1.z}

	local function dig(digpos)
		if not minetest.is_protected(digpos, playername) then
			local node = minetest.get_node(digpos)
			local def = minetest.registered_nodes[node.name]
			if def.walkable and def.diggable and
					(def.can_dig == nil or def.can_dig(digpos, player)) then
				minetest.node_dig(digpos, node, player)

				if def.sounds and def.sounds.dug then
					minetest.sound_play(def.sounds.dug, {pos = digpos})
				end
			end
		end
	end

	dig(digpos1)
	dig(digpos2)
end

local mtimer = 0
minetest.register_globalstep(function(dtime)
	mtimer = mtimer + dtime
	if mtimer > 0.5 then
		for playername, is_mole in pairs(pep.moles) do
			if is_mole then
				pep.moledig(playername)
			end
		end
		mtimer = 0
	end
end)

playereffects.register_effect_type("pepmole", S("Autodig Mode"), "pep_mole.png", {"autodig"},
	function(player)
		pep.moles[player:get_player_name()] = true
	end,
	function(_, player)
		pep.moles[player:get_player_name()] = false
	end
)
pep.register_potion({
	basename = "mole",
	contentstring = "Autodig Potion",
	longdesc = "Drinking it will start an effect which will attempt to mine any two blocks in front of you, as if you were using a diamond pickaxe on them. The effect lasts for 30 seconds.",
	effect_type = "pepmole",
	duration = 30,
	recipe = {"default:pick_steel", "default:shovel_steel", "vessels:glass_bottle"}
})
