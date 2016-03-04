local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/railtrack.lua")

railtrack:register_rail(":default:rail", {
	description = "Rail",
	tiles = {"default_rail.png", "default_rail_curved.png",
		"default_rail_t_junction.png", "default_rail_crossing.png"},
	railtype = "rail",
})

railtrack:register_rail("railtrack:superrail", {
	description = "Superconducting Rail",
	tiles = {"carts_rail_sup.png", "carts_rail_curved_sup.png",
		"carts_rail_t_junction_sup.png", "carts_rail_crossing_sup.png"},
	railtype = "superrail",
	acceleration = 0,
})

railtrack:register_rail("railtrack:powerrail", {
	description = "Powered Rail",
	tiles = {"carts_rail_pwr.png", "carts_rail_curved_pwr.png",
		"carts_rail_t_junction_pwr.png", "carts_rail_crossing_pwr.png"},
	railtype = "powerrail",
	acceleration = 4,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				railtrack:set_acceleration(pos, 4)
			end,
			action_off = function(pos, node)
				railtrack:set_acceleration(pos, nil)
			end,
		},
	},
})

railtrack:register_rail("railtrack:brakerail", {
	description = "Braking Rail",
	tiles = {"carts_rail_brk.png", "carts_rail_curved_brk.png",
		"carts_rail_t_junction_brk.png", "carts_rail_crossing_brk.png"},
	railtype = "brakerail",
	acceleration = -4,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				railtrack:set_acceleration(pos, -4)
			end,
			action_off = function(pos, node)
				railtrack:set_acceleration(pos, nil)
			end,
		},
	},
})

railtrack:register_rail("railtrack:switchrail", {
	description = "Switching Rail",
	tiles = {"carts_rail_swt.png", "carts_rail_curved_swt.png",
		"carts_rail_t_junction_swt.png", "carts_rail_crossing_swt.png"},
	railtype = "switchrail",
	acceleration = 0,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				local meta = minetest.get_meta(pos)
				meta:set_string("rotations", "RFLB")
			end,
			action_off = function(pos, node)
				local meta = minetest.get_meta(pos)
				meta:set_string("rotations", nil)
			end,
		},
	},
})

minetest.register_privilege("rails", "Player can dig and place rails.")

minetest.register_tool("railtrack:fixer", {
	description = "Rail Fixer",
	inventory_image = "railtrack_fixer.png",
	wield_image = "railtrack_fixer.png",
	on_use = function(itemstack, user, pointed_thing)
		local pos = minetest.get_pointed_thing_position(pointed_thing, false)
		local name = user:get_player_name()
		if not pos or not name or pointed_thing.type ~= "node" then
			return
		end
		if not railtrack:is_railnode(pos) then
			minetest.chat_send_player(name, "Not a rail node!")
			return
		end
		if not minetest.is_singleplayer() then
			if not minetest.check_player_privs(name, {rails=true}) then
				minetest.chat_send_player(name, "Requires rails privilege")
				return
			end
		end
		local node = minetest.get_node(pos)
		if node then
			minetest.remove_node(pos)
			minetest.set_node(pos, node)
			local def = minetest.registered_items[node.name] or {}
			local itemstack = ItemStack(node.name)
			if type(def.after_place_node) == "function" then
				def.after_place_node(pos, user, itemstack)
			end
		end
	end,
})

minetest.register_tool("railtrack:inspector", {
	description = "Rail Inspector",
	inventory_image = "railtrack_inspector.png",
	wield_image = "railtrack_inspector.png",
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		local pos = minetest.get_pointed_thing_position(pointed_thing, false)
		if not name or not pos then
			return
		end
		local node = minetest.get_node(pos) or {}
		if not railtrack:is_railnode(pos) or not node.name then
			minetest.chat_send_player(name, "Not a rail node!")
			return
		end
		local ref = minetest.registered_items[node.name] or {}
		local meta = minetest.get_meta(pos)
		local form = ""
		local size = 2.5
		form = form.."label[0.5,0.5;POS: "..minetest.pos_to_string(pos).."]"
		local railtype = ref.railtype or "NIL"
		form = form.."label[0.5,1.0;RAILTYPE: "..railtype.."]"
		local contype = meta:get_string("contype") or "NIL"
		form = form.."label[0.5,1.5;CONTYPE: "..contype.."]"
		local accel = meta:get_string("acceleration") or "NIL"
		form = form.."label[0.5,2.0;ACCEL: "..accel.."]"
		local s_junc = meta:get_string("junctions")
		if s_junc then
			local junctions = minetest.deserialize(s_junc)
			if junctions then
				form = form.."label[0.5,2.5;JUNCTIONS:]"
				for i, p in ipairs(junctions) do
					size = size + 0.5
					form = form.."label[0.5,"..size..";#"..i.." "
							..minetest.pos_to_string(p).."]"
				end
			end
		end
		local s_cons = meta:get_string("connections")
		if s_cons then
			local cons = minetest.deserialize(s_cons)
			if cons then
				size = size + 0.5
				form = form.."label[0.5,"..size..";CONNECTIONS:]"
				for i, p in pairs(cons) do
					size = size + 0.5
					form = form.."label[0.5,"..size..";#"..i.." "
							..minetest.pos_to_string(p).."]"
				end
			end
		end
		local s_rots = meta:get_string("rotations")
		if s_rots then
			size = size + 0.5
			form = form.."label[0.5,"..size..";ROTATIONS: "..s_rots.."]"
		end
		form = form.."button_exit[3.0,"..(size + 1)..";2,0.5;;Ok]"
		form = "size[8,"..(size + 2).."]"..form
		minetest.show_formspec(name, "info", form)
	end,
})

minetest.register_craft({
	output = "railtrack:powerrail 2",
	recipe = {
		{"default:rail", "default:mese_crystal_fragment", "default:rail"},
	}
})

minetest.register_craft({
	output = "railtrack:brakerail 2",
	recipe = {
		{"default:rail", "default:coal_lump", "default:rail"},
	}
})

minetest.register_craft({
	output = "railtrack:switchrail 2",
	recipe = {
		{"default:rail", "default:mese", "default:rail"},
	}
})

minetest.register_craft({
	output = "railtrack:superrail 2",
	recipe = {
		{"default:rail", "default:diamond", "default:rail"},
	}
})

