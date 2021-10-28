pep = {}

local sp = minetest.is_singleplayer()

local translator = minetest.get_translator
local S = translator and translator("pep") or intllib.make_gettext_pair()

if translator and not sp then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

--
-- Apply Potion
--

local function apply_potion(player, pos, potion)
	-- Particles
	minetest.add_particlespawner({
		amount = 75,
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

	if not minetest.is_creative_enabled(user:get_player_name()) or not sp then
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
		inventory_image = potiondef.item_image or "pep_" .. potionname .. ".png",
		wield_image = potiondef.item_image or "pep_" .. potionname .. ".png",
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
local pova_exists = minetest.global_exists("pova")

local add_physic = function(player, attribute, value)
	if ppa then
		playerphysics.add_physics_factor(player, attribute, "pep:" .. attribute, value)
	elseif pova_exists then
		local item = "pep:" .. attribute
		if attribute == "gravity" then
			item = "force"
		else
			value = value - 1.0
		end
		pova.add_override(player, item, {[attribute] = value})
		pova.do_override(player)
	else
		player:set_physics_override({[attribute] = value})
	end
end

local remove_physic = function(player, attribute)
	if ppa then
		playerphysics.remove_physics_factor(player, attribute, "pep:" .. attribute)
	elseif pova_exists then
		local item = "pep:" .. attribute
		if attribute == "gravity" then
			item = "force"
		end
		pova.del_override(player, item)
		pova.do_override(player)
	else
		player:set_physics_override({[attribute] = 1})
	end
end

--
-- Potions
--

local speedplus_image = "pep_speedplus.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepspeedplus", S("High Speed"),
		{image = speedplus_image}, {"speed"},
	function(player)
		add_physic(player, "speed", 2.5)
	end,
	function(_, player)
		remove_physic(player, "speed")
	end
)
pep.register_potion({
	basename = "speedplus",
	item_image = speedplus_image,
	contentstring = "Running Potion",
	longdesc = "Drinking it will make you run faster for 60 seconds",
	effect_type = "pepspeedplus",
	duration = 60,
	recipe = {
		"default:pine_sapling", "default:cactus", "flowers:oxeye_daisy",
		"default:junglegrass", "vessels:glass_bottle"
	}
})

local speedminus_image = "pep_speedminus.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepspeedminus", S("Low Speed"),
		{image = speedminus_image}, {"speed"},
	function(player)
		add_physic(player, "speed", 0.5)
	end,
	function(_, player)
		remove_physic(player, "speed")
	end
)
pep.register_potion({
	basename = "speedminus",
	item_image = speedminus_image,
	contentstring = "Slug Potion",
	longdesc = "Drinking it will make you walk slower for 60 seconds",
	effect_type = "pepspeedminus",
	duration = 60,
	recipe = {"group:dry_grass", "default:ice", "vessels:glass_bottle"}
})

local breath_image = "pep_breath.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepbreath", S("Perfect Breath"),
		{image = breath_image}, {"breath"},
	function(player)
		local breath = player:get_breath()
		if breath and breath < 10 then
			player:set_breath(10)
		end
	end,
	nil, nil, nil, 2
)
pep.register_potion({
	basename = "breath",
	item_image = breath_image,
	contentstring = "Air Potion",
	longdesc = "Drinking it gives you breath underwater for 60 seconds",
	effect_type = "pepbreath",
	duration = 30,
	recipe = {
		"default:sugarcane", "default:sugarcane", "default:sugarcane",
		"default:sugarcane", "default:sugarcane", "default:sugarcane",
		"default:sugarcane", "default:sugarcane", "vessels:glass_bottle"
	}
})

local regen_image = "pep_regen.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepregen", S("Regeneration"),
		{image = regen_image}, {"health"},
	function(player)
		player:set_hp(player:get_hp() + 1)
	end,
	nil, nil, nil, 2
)
pep.register_potion({
	basename = "regen",
	item_image = regen_image,
	contentstring = "Healing Potion",
	longdesc = "Drinking it makes you regenerate health.\nEvery 2 seconds, you get 1 HP, 20 times in total",
	effect_type = "pepregen",
	duration = 20,
	recipe = {
		"default:cactus", "farming:flour", "flowers:mushroom_brown",
		"vessels:glass_bottle"
	}
})

local regen2_image = "pep_regen2.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepregen2", S("Regeneration II"),
		{image = regen2_image}, {"health"},
	function(player)
		player:set_hp(player:get_hp() + 2)
	end,
	nil, nil, nil, 1
)
pep.register_potion({
	basename = "regen2",
	item_image = regen2_image,
	contentstring = "Healing Potion II",
	longdesc = "Drinking it makes you regenerate health quickly.\nEvery second you get 2 HP, 30 times in total",
	effect_type = "pepregen2",
	duration = 30,
	recipe = {"default:gold_ingot", "farming:flour", "pep:regen"}
})

local grav0_image = "pep_grav0.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepgrav0", S("No Gravity"),
		{image = grav0_image}, {"gravity"},
	function(player)
		add_physic(player, "gravity", 0.1)
	end,
	function(_, player)
		remove_physic(player, "gravity")
	end
)
pep.register_potion({
	basename = "grav0",
	item_image = grav0_image,
	contentstring = "Non-Gravity Potion",
	longdesc = "When you drink this potion, gravity stops affecting you, as if you were in space.\nThe effect lasts for 30 seconds",
	effect_type = "pepgrav0",
	duration = 30,
	recipe = {"mesecons:wire_00000000_off", "vessels:glass_bottle"}
})

local gravreset_image = "pep_gravreset.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepgravreset", S("Gravity Normalizer"),
		{image = gravreset_image}, {"gravity"},
	function() end, function() end)
pep.register_potion({
	basename = "gravreset",
	item_image = "pep_gravreset.png^vessels_glass_bottle.png",
	contentstring = "Gravity Normalizer Potion",
	longdesc = "Drinking it will stop all gravity effects you currently have",
	effect_type = "pepgravreset",
	recipe = {"pep:grav0", "default:steel_ingot"}
})

local jumpplus_image = "pep_jumpplus.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepjumpplus", S("High Jump"),
		{image = jumpplus_image}, {"jump"},
	function(player)
		add_physic(player, "jump", 2.5)
	end,
	function(_, player)
		remove_physic(player, "jump")
	end
)
pep.register_potion({
	basename = "jumpplus",
	item_image = jumpplus_image,
	contentstring = "High Jumping Potion",
	longdesc = "Drinking it will make you jump higher for 60 seconds",
	effect_type = "pepjumpplus",
	duration = 60,
	recipe = {
		"flowers:tulip", "group:grass", "mesecons:wire_00000000_off",
		"mesecons:wire_00000000_off", "vessels:glass_bottle"
	}
})

local jumpminus_image = "pep_jumpminus.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepjumpminus", S("Low Jump"),
		{image = jumpminus_image}, {"jump"},
	function(player)
		add_physic(player, "jump", 0.5)
	end,
	function(_, player)
		remove_physic(player, "jump")
	end
)
pep.register_potion({
	basename = "jumpminus",
	item_image = jumpminus_image,
	contentstring = "Low Jumping Potion",
	longdesc = "Drinking it will make you jump lower for 60 seconds",
	effect_type = "pepjumpminus",
	duration = 60,
	recipe = {
		"default:leaves", "default:jungleleaves", "default:steel_ingot",
		"flowers:oxeye_daisy", "vessels:glass_bottle"
	}
})

local dark = {}
local nightvision_image = "pep_nightvision.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepnightvision", S("Night Vision"),
		{image = nightvision_image}, {"nightvision"},
	function(player)
		local player_name = player:get_player_name()

		player:override_day_night_ratio(
			math.min(1, minetest.get_timeofday() + 0.6))

		if not dark[player_name] then
			local hud = player:hud_add({
				hud_elem_type = "image",
				position = {x = 0.5, y = 0.5},
				scale = {x = -100, y = -100},
				text = "pep_dark.png"
			})
			dark[player_name] = hud
		end
	end,
	function(_, player)
		local player_name = player:get_player_name()

		player:override_day_night_ratio(nil)
		player:hud_remove(dark[player_name])
		dark[player_name] = nil
	end
)
pep.register_potion({
	basename = "nightvision",
	item_image = nightvision_image,
	contentstring = "Night Vision Potion",
	longdesc = "Drinking it, you will see in the dark for 60 seconds.\nThe potion works only outdoors",
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
local invisible_image = "pep_invisible.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepinvisible", S("Invisible"),
		{image = invisible_image}, {"invisible"},
	function(player)
		player:set_properties({visual_size = {x = 0, y = 0}})
		local nametag = player:get_nametag_attributes()
		nametag.color.a = 0
		player:set_nametag_attributes(nametag)
		invisibility[player:get_player_name()] = true
	end,
	function(_, player)
		player:set_properties({visual_size = {x = 1, y = 1}})
		local nametag = player:get_nametag_attributes()
		nametag.color.a = 255
		player:set_nametag_attributes(nametag)
		invisibility[player:get_player_name()] = nil
	end,
	nil, false
)

pep.register_potion({
	basename = "invisible",
	item_image = invisible_image,
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
-- Immortal
-- Fall damage overriding API was added in 5.4.
--

pep.immortals = {}
local immortal_image = "pep_immortal.png^vessels_glass_bottle.png"
playereffects.register_effect_type("pepimmortal", S("Immortal"),
		{image = immortal_image}, {"immortal"},
	function(player)
		local player_name = player:get_player_name()
		local player_armor = player:get_armor_groups()

		if player_armor then
			pep.immortals[player_name] = table.copy(player_armor)
			player_armor.fleshy = 0
			player_armor.fall_damage_add_percent = -100
			player:set_armor_groups(player_armor)
		end
	end,
	function(_, player)
		local player_name = player:get_player_name()
		local player_armor = pep.immortals[player_name]
		if player_armor then
			player:set_armor_groups(player_armor)
			pep.immortals[player_name] = nil
		end
	end
)

pep.register_potion({
	basename = "immortal",
	item_image = immortal_image,
	contentstring = "Immortal Potion",
	longdesc = "After drinking it, you will become immortal. Does not apply to fall and node damage.\nThe effect lasts for 20 seconds",
	effect_type = "pepimmortal",
	duration = 20,
	recipe = {
		"default:gold_ingot", "default:glowstone_dust",
		"flowers:mushroom_red", "vessels:glass_bottle"
	}
})

-- Replace useless Mole
minetest.register_alias("pep:mole", "pep:immortal")
