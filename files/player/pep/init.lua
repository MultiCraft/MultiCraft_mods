local ppa = minetest.get_modpath("playerphysics")

pep = {}

-- Intllib
local S = intllib.make_gettext_pair()

function return_empty_bottle(potiondef, user, itemstack)
	local inventory = user:get_inventory()
	local empty_vessel = "vessels:glass_bottle"
	if (itemstack:is_empty()) then
		return ItemStack(empty_vessel)
	else
		if inventory:room_for_item("main", "vessels:glass_bottle") then
			inventory:add_item("main", "vessels:glass_bottle")
		else
			minetest.add_item(user:get_pos(), empty_vessel)
		end
	end
	return itemstack
end

function pep.register_potion(potiondef)
	local on_use
	on_use = function(itemstack, user, pointed_thing)
		-- Particles
		minetest.add_particlespawner({
			amount = 30,
			time = 0.1,
			minpos = pointed_thing.above,
			maxpos = pointed_thing.above,
			minvel = {x = -1, y = 1, z = -1},
			maxvel = {x = 1, y = 2, z = 1},
			minacc = {x = 0, y = -5, z = 0},
			maxacc = {x = 0, y = -9, z = 0},
			minexptime = 1,
			maxexptime = 3,
			minsize = 1,
			maxsize = 2,
			collisiondetection = false,
			vertical = false,
			texture = "pep_"..potiondef.basename.."_particle.png"
		})
		if(potiondef.effect_type ~= nil) then
			playereffects.apply_effect_type(potiondef.effect_type, potiondef.duration, user)
			itemstack:take_item()
			itemstack = return_empty_bottle(potiondef, user, itemstack)
		else
			itemstack:take_item()
			itemstack = return_empty_bottle(potiondef, user, itemstack)
		end
		return itemstack
	end

	minetest.register_craftitem("pep:"..potiondef.basename, {
		description = S(potiondef.contentstring),
		_doc_items_longdesc = S(potiondef.longdesc),
		_doc_items_usagehelp = S("Hold it in your hand, then left-click to drink it."),
		inventory_image = "pep_"..potiondef.basename..".png",
		wield_image = "pep_"..potiondef.basename..".png",
		on_use = on_use,
		groups = {vessel = 1},
	})
end

pep.moles = {}

function pep.enable_mole_mode(playername)
	pep.moles[playername] = true
end

function pep.disable_mole_mode(playername)
	pep.moles[playername] = false
end

function pep.yaw_to_vector(yaw)
	local tau = math.pi*2

	yaw = yaw % tau
	if yaw < tau/8 then
		return { x=0, y=0, z=1}
	elseif yaw < (3/8)*tau then
		return { x=-1, y=0, z=0 }
	elseif yaw < (5/8)*tau then
		return { x=0, y=0, z=-1 }
	elseif yaw < (7/8)*tau then
		return { x=1, y=0, z=0 }
	else
		return { x=0, y=0, z=1}
	end
end

function pep.moledig(playername)
	local player = minetest.get_player_by_name(playername)

	local yaw = player:get_look_horizontal()

	local pos = vector.round(player:get_pos())

	local v = pep.yaw_to_vector(yaw)

	local digpos1 = vector.add(pos, v)
	local digpos2 = { x = digpos1.x, y = digpos1.y+1, z = digpos1.z }

	local try_dig = function(pos)
		local n = minetest.get_node(pos)
		local ndef = minetest.registered_nodes[n.name]
		if ndef.walkable and ndef.diggable then
			if ndef.can_dig ~= nil then
				if ndef.can_dig() then
					return true
				else
					return false
				end
			else
				return true
			end
		else
			return false
		end
	end

	local dig = function(pos)
		if try_dig(pos) then
			local n = minetest.get_node(pos)
			local ndef = minetest.registered_nodes[n.name]
			if ndef.sounds ~= nil then
				minetest.sound_play(ndef.sounds.dug, { pos = pos })
			end
			-- TODO: Replace this code as soon Minetest removes support for this function
			local drops = minetest.get_node_drops(n.name, "default:pick_steel")
			minetest.dig_node(pos)
			local inv = player:get_inventory()
			local leftovers = {}
			for i=1, #drops do
				table.insert(leftovers, inv:add_item("main", drops[i]))
			end
			for i=1,#leftovers do
				minetest.add_item(pos, leftovers[i])
			end
		end
	end

	dig(digpos1)
	dig(digpos2)
end

if minetest.is_singleplayer() then
	pep.timer = 0
	minetest.register_globalstep(function(dtime)
		pep.timer = pep.timer + dtime
		if pep.timer > 0.5 then
			for playername, is_mole in pairs(pep.moles) do
				if is_mole then
					pep.moledig(playername)
				end
			end
			pep.timer = 0
		end
	end)
end

local add_physic = function(player, attribute, value)
	if ppa then
		playerphysics.add_physics_factor(player, attribute, "pep:"..attribute, value)
	else
		player:set_physics_override({[attribute]=value})
	end
end
local remove_physic = function(player, attribute)
	if ppa then
		playerphysics.remove_physics_factor(player, attribute, "pep:"..attribute)
	else
		player:set_physics_override({[attribute]=1})
	end
end

playereffects.register_effect_type("pepspeedplus", S("High speed"), "pep_speedplus.png", {"speed"},
	function(player)
		add_physic(player, "speed", 2)
	end,
	function(effect, player)
		remove_physic(player, "speed")
	end
)
playereffects.register_effect_type("pepspeedminus", S("Low speed"), "pep_speedminus.png", {"speed"},
	function(player)
		add_physic(player, "speed", 0.5)
	end,
	function(effect, player)
		remove_physic(player, "speed")
	end
)
playereffects.register_effect_type("pepspeedreset", S("Speed neutralizer"), "pep_speedreset.png", {"speed"},
	function() end, function() end)
playereffects.register_effect_type("pepjumpplus", S("High jump"), "pep_jumpplus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 2)
	end,
	function(effect, player)
		remove_physic(player, "jump")
	end
)
playereffects.register_effect_type("pepjumpminus", S("Low jump"), "pep_jumpminus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 0.5)
	end,
	function(effect, player)
		remove_physic(player, "jump")
	end
)
playereffects.register_effect_type("pepjumpreset", S("Jump height neutralizer"), "pep_jumpreset.png", {"jump"},
	function() end, function() end)
playereffects.register_effect_type("pepgrav0", S("No gravity"), "pep_grav0.png", {"gravity"},
	function(player)
		add_physic(player, "gravity", 0)
	end,
	function(effect, player)
		remove_physic(player, "gravity")
	end
)
playereffects.register_effect_type("pepgravreset", S("Gravity neutralizer"), "pep_gravreset.png", {"gravity"},
	function() end, function() end)
playereffects.register_effect_type("pepregen", S("Regeneration"), "pep_regen.png", {"health"},
	function(player)
		player:set_hp(player:get_hp()+1)
	end,
	nil, nil, nil, 2
)
playereffects.register_effect_type("pepregen2", S("Strong regener."), "pep_regen2.png", {"health"},
	function(player)
		player:set_hp(player:get_hp()+2)
	end,
	nil, nil, nil, 1
)
playereffects.register_effect_type("pepbreath", S("Perfect breath"), "pep_breath.png", {"breath"},
	function(player)
		player:set_breath(player:get_breath()+2)
	end,
	nil, nil, nil, 1
)
playereffects.register_effect_type("pepmole", S("Mole mode"), "pep_mole.png", {"autodig"},
	function(player)
		pep.enable_mole_mode(player:get_player_name())
	end,
	function(effect, player)
		pep.disable_mole_mode(player:get_player_name())
	end
)

pep.register_potion({
	basename = "speedplus",
	contentstring = "Running Potion",
	longdesc = "Drinking it will make you run faster for 30 seconds.",
	effect_type = "pepspeedplus",
	duration = 30,
})
pep.register_potion({
	basename = "speedminus",
	contentstring = "Slug Potion",
	longdesc = "Drinking it will make you walk slower for 30 seconds.",
	effect_type = "pepspeedminus",
	duration = 30,
})
pep.register_potion({
	basename = "speedreset",
	contentstring = "Speed Neutralizer Potion",
	longdesc = "Drinking it will stop all speed effects you may currently have.",
	effect_type = "pepspeedreset",
	duration = 0
})
pep.register_potion({
	basename = "breath",
	contentstring = "Air Potion",
	longdesc = "Drinking it gives you breath underwater for 30 seconds.",
	effect_type = "pepbreath",
	duration = 30,
})
pep.register_potion({
	basename = "regen",
	contentstring = "Weak Healing Potion",
	longdesc = "Drinking it makes you regenerate health. Every 2 seconds, you get 1 HP, 15 times in total.",
	effect_type = "pepregen",
	duration = 15,
})
pep.register_potion({
	basename = "regen2",
	contentstring = "Strong Healing Potion",
	longdesc = "Drinking it makes you regenerate health quickly. Every second you get 2 HP, 15 times in total.",
	effect_type = "pepregen2",
	duration = 15,
})
pep.register_potion({
	basename = "grav0",
	contentstring = "Non-Gravity Potion",
	longdesc = "When you drink this potion, gravity stops affecting you, as if you were in space. The effect lasts for 20 seconds.",
	effect_type = "pepgrav0",
	duration = 20,
})
pep.register_potion({
	basename = "gravreset",
	contentstring = "Gravity Neutralizer Potion",
	longdesc = "Drinking it will stop all gravity effects you currently have.",
	effect_type = "pepgravreset",
	duration = 0,
})
pep.register_potion({
	basename = "jumpplus",
	contentstring = "High Jumping Potion",
	longdesc = "Drinking it will make you jump higher for 30 seconds.",
	effect_type = "pepjumpplus",
	duration = 30,
})
pep.register_potion({
	basename = "jumpminus",
	contentstring = "Low Jumping Potion",
	longdesc = "Drinking it will make you jump lower for 30 seconds.",
	effect_type = "pepjumpminus",
	duration = 30,
})
pep.register_potion({
	basename = "jumpreset",
	contentstring = "Jump Neutralizer Potion",
	longdesc = "Drinking it will stop all jumping effects you may currently have.",
	effect_type = "pepjumpreset",
	duration = 0,
})
pep.register_potion({
	basename = "mole",
	contentstring = "Mole Potion",
	longdesc = "Drinking it will start an effect which will magically attempt to mine any two blocks in front of you horizontally, as if you were using a steel pickaxe on them. The effect lasts for 18 seconds.",
	effect_type = "pepmole",
	duration = 18,
})


--[=[ register crafts ]=]
--[[ normal potions ]]
minetest.register_craft({
	type = "shapeless",
	output = "pep:breath",
	recipe = { "default:papyrus", "default:papyrus", "default:papyrus", "default:papyrus",
			"default:papyrus", "default:papyrus", "default:papyrus", "default:papyrus", "vessels:glass_bottle" }
})
minetest.register_craft({
	type = "shapeless",
	output = "pep:speedminus",
	recipe = { "default:dry_grass", "default:ice", "vessels:glass_bottle" }
})
if(minetest.get_modpath("flowers") ~= nil) then
	minetest.register_craft({
	type = "shapeless",
		output = "pep:jumpplus",
		recipe = { "flowers:tulip", "default:grass", "mesecons:wire_00000000_off",
				"mesecons:wire_00000000_off", "vessels:glass_bottle" }
	})
	minetest.register_craft({
		type = "shapeless",
		output = "pep:poisoner",
		recipe = { "flowers:mushroom_red", "flowers:mushroom_red", "flowers:mushroom_red", "vessels:glass_bottle" }
	})

	if(minetest.get_modpath("farming") ~= nil) then
		minetest.register_craft({
			type = "shapeless",
			output = "pep:regen",
			recipe = { "default:cactus", "farming:flour", "flowers:mushroom_brown", "vessels:glass_bottle" }
		})
	end
end
if(minetest.get_modpath("farming") ~= nil) then
	minetest.register_craft({
		type = "shapeless",
		output = "pep:regen2",
		recipe = { "default:gold_ingot", "farming:flour", "pep:regen" }
	})

minetest.register_craft({
	type = "shapeless",
	output = "pep:jumpminus",
	recipe = { "default:leaves", "default:jungleleaves", "default:steel_ingot", "flowers:oxeye_daisy", "vessels:glass_bottle" }
})
minetest.register_craft({
	type = "shapeless",
	output = "pep:grav0",
	recipe = { "mesecons:wire_00000000_off", "vessels:glass_bottle" }
})
minetest.register_craft({
	type = "shapeless",
	output = "pep:mole",
	recipe = { "default:pick_steel", "default:shovel_steel", "vessels:glass_bottle" },
})
minetest.register_craft({
	type = "shapeless",
	output = "pep:gravreset" ,
	recipe = { "pep:grav0", "default:steel_ingot" }
})
end
	minetest.register_craft({
		type = "shapeless",
		output = "pep:speedplus",
		recipe = { "default:pine_sapling", "default:cactus", "flowers:oxeye_daisy", "default:junglegrass", "vessels:glass_bottle" }
	})

--[[ independent crafts ]]
minetest.register_craft({
	type = "shapeless",
	output = "pep:speedreset",
	recipe = { "pep:speedplus", "pep:speedminus" }
})
minetest.register_craft({
	type = "shapeless",
	output = "pep:jumpreset",
	recipe = { "pep:jumpplus", "pep:jumpminus" }
})


--[[ aliases ]]
minetest.register_alias("potionspack:antigravity", "pep:grav0")
minetest.register_alias("potionspack:antigravityii", "pep:gravreset")
minetest.register_alias("potionspack:speed", "pep:speedminus")
minetest.register_alias("potionspack:speedii", "pep:speedplus")
minetest.register_alias("potionspack:inversion", "pep:speedreset")
minetest.register_alias("potionspack:confusion", "pep:breath")
minetest.register_alias("potionspack:whatwillthisdo", "pep:mole")
minetest.register_alias("potionspack:instanthealth", "pep:regen")
minetest.register_alias("potionspack:instanthealthii", "pep:regen2")
minetest.register_alias("potionspack:regen", "pep:regen")
minetest.register_alias("potionspack:regenii", "pep:regen2")
minetest.register_alias("potionspack:harming", "pep:gravreset")
minetest.register_alias("potionspack:harmingii", "pep:gravreset")
