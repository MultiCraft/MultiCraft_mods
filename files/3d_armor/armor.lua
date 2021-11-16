local S = armor.S

-- Regisiter Head Armor

armor:register_armor("3d_armor:helmet_leather", {
	description = S"Leather Helmet",
	inventory_image = "3d_armor_inv_helmet_leather.png",
	groups = {armor_head = 5, armor_heal = 0, armor_use = 100,
		physics_speed = 0.02, physics_jump = 0.02}
})

armor:register_armor("3d_armor:helmet_steel", {
	description = S"Steel Helmet",
	inventory_image = "3d_armor_inv_helmet_steel.png",
	groups = {armor_head = 5, armor_heal = 5, armor_use = 250}
})

armor:register_armor("3d_armor:helmet_gold", {
	description = S"Golden Helmet",
	inventory_image = "3d_armor_inv_helmet_gold.png",
	groups = {armor_head = 5, armor_heal = 10, armor_use = 500}
})

armor:register_armor("3d_armor:helmet_diamond", {
	description = S"Diamond Helmet",
	inventory_image = "3d_armor_inv_helmet_diamond.png",
	groups = {armor_head = 5, armor_heal = 15, armor_use = 750}
})

armor:register_armor("3d_armor:helmet_emerald", {
	description = S"Emerald Helmet",
	desc_color = default.colors.emerald,
	inventory_image = "3d_armor_inv_helmet_emerald.png",
	groups = {armor_head = 13, armor_heal = 20, armor_use = 1000,
		physics_speed = -0.02, physics_jump = -0.02}
})

armor:register_armor("3d_armor:helmet_ruby", {
	description = S"Ruby Helmet",
	desc_color = default.colors.ruby,
	inventory_image = "3d_armor_inv_helmet_ruby.png",
	groups = {armor_head = 5, armor_heal = 15,
		physics_speed = 0.01, physics_jump = 0.01}
})

armor:register_armor("3d_armor:helmet_chain", {
	description = S"Chain Helmet",
	inventory_image = "3d_armor_inv_helmet_chain.png",
	groups = {armor_head = 5, armor_heal = 15, armor_use = 500,
		physics_speed = 0.02, physics_jump = 0.02}
})

armor:register_armor("3d_armor:helmet_mask", {
	description = S"Underwater Mask",
	inventory_image = "3d_armor_inv_helmet_mask.png",
	groups = {armor_head = 1, armor_mask = 10, armor_use = 600, not_in_creative_inventory = 1}
})

-- Regisiter Torso Armor

armor:register_armor("3d_armor:chestplate_leather", {
	description = S"Leather Chestplate",
	inventory_image = "3d_armor_inv_chestplate_leather.png",
	groups = {armor_torso = 15, armor_heal = 0, armor_use = 100,
		physics_speed = 0.03, physics_jump = 0.03}
})

armor:register_armor("3d_armor:chestplate_steel", {
	description = S"Steel Chestplate",
	inventory_image = "3d_armor_inv_chestplate_steel.png",
	groups = {armor_torso = 20, armor_heal = 5, armor_use = 250}
})

armor:register_armor("3d_armor:chestplate_gold", {
	description = S"Golden Chestplate",
	inventory_image = "3d_armor_inv_chestplate_gold.png",
	groups = {armor_torso = 25, armor_heal = 10, armor_use = 500}
})

armor:register_armor("3d_armor:chestplate_diamond",{
	description = S"Diamond Chestplate",
	inventory_image = "3d_armor_inv_chestplate_diamond.png",
	groups = {armor_torso = 30, armor_heal = 15, armor_use = 750}
})

armor:register_armor("3d_armor:chestplate_emerald", {
	description = S"Emerald Chestplate",
	desc_color = default.colors.emerald,
	inventory_image = "3d_armor_inv_chestplate_emerald.png",
	groups = {armor_torso = 30, armor_heal = 20, armor_use = 1000,
		physics_speed = -0.09, physics_jump = -0.03}
})

armor:register_armor("3d_armor:chestplate_ruby", {
	description = S"Ruby Chestplate",
	desc_color = default.colors.ruby,
	inventory_image = "3d_armor_inv_chestplate_ruby.png",
	groups = {armor_torso = 30, armor_heal = 15,
		physics_speed = 0.02, physics_jump = 0.02}
})

armor:register_armor("3d_armor:chestplate_chain", {
	description = S"Chain Chestplate",
	inventory_image = "3d_armor_inv_chestplate_chain.png",
	groups = {armor_torso = 30, armor_heal = 15, armor_use = 500,
		physics_speed = 0.02, physics_jump = 0.02}
})

-- Regisiter Leg Armor

armor:register_armor("3d_armor:leggings_leather", {
	description = S"Leather Leggings",
	inventory_image = "3d_armor_inv_leggings_leather.png",
	groups = {armor_legs = 10, armor_heal = 0, armor_use = 100,
		physics_speed = 0.03, physics_jump = 0.03}
})

armor:register_armor("3d_armor:leggings_steel", {
	description = S"Steel Leggings",
	inventory_image = "3d_armor_inv_leggings_steel.png",
	groups = {armor_legs = 15, armor_heal = 5, armor_use = 250}
})

armor:register_armor("3d_armor:leggings_gold", {
	description = S"Golden Leggings",
	inventory_image = "3d_armor_inv_leggings_gold.png",
	groups = {armor_legs = 20, armor_heal = 10, armor_use = 500}
})

armor:register_armor("3d_armor:leggings_diamond", {
	description = S"Diamond Leggings",
	inventory_image = "3d_armor_inv_leggings_diamond.png",
	groups = {armor_legs = 25, armor_heal = 15, armor_use = 750}
})

armor:register_armor("3d_armor:leggings_emerald", {
	description = S"Emerald Leggings",
	desc_color = default.colors.emerald,
	inventory_image = "3d_armor_inv_leggings_emerald.png",
	groups = {armor_legs = 25, armor_heal = 20, armor_use = 1000,
		physics_speed = -0.03, physics_jump = -0.03}
})

armor:register_armor("3d_armor:leggings_ruby", {
	description = S"Ruby Leggings",
	desc_color = default.colors.ruby,
	inventory_image = "3d_armor_inv_leggings_ruby.png",
	groups = {armor_legs = 25, armor_heal = 15,
		physics_speed = 0.02, physics_jump = 0.02}
})

armor:register_armor("3d_armor:leggings_chain", {
	description = S"Chain Leggings",
	inventory_image = "3d_armor_inv_leggings_chain.png",
	groups = {armor_legs = 25, armor_heal = 15, armor_use = 500,
		physics_speed = 0.02, physics_jump = 0.02}
})

-- Regisiter Boots

armor:register_armor("3d_armor:boots_leather", {
	description = S"Leather Boots",
	inventory_image = "3d_armor_inv_boots_leather.png",
	groups = {armor_feet = 5, armor_heal = 0, armor_use = 100,
		physics_speed = 0.02, physics_jump = 0.02}
})

armor:register_armor("3d_armor:boots_steel", {
	description = S"Steel Boots",
	inventory_image = "3d_armor_inv_boots_steel.png",
	groups = {armor_feet = 5, armor_heal = 5, armor_use = 250}
})

armor:register_armor("3d_armor:boots_gold", {
	description = S"Golden Boots",
	inventory_image = "3d_armor_inv_boots_gold.png",
	groups = {armor_feet = 5, armor_heal = 10, armor_use = 500}
})

armor:register_armor("3d_armor:boots_diamond", {
	description = S"Diamond Boots",
	inventory_image = "3d_armor_inv_boots_diamond.png",
	groups = {armor_feet = 5, armor_heal = 15, armor_use = 750}
})

armor:register_armor("3d_armor:boots_emerald", {
	description = S"Emerald Boots",
	desc_color = default.colors.emerald,
	inventory_image = "3d_armor_inv_boots_emerald.png",
	groups = {armor_feet = 12, armor_heal = 20, armor_use = 1000,
		physics_speed = -0.02, physics_jump = -0.02}
})

armor:register_armor("3d_armor:boots_ruby", {
	description = S"Ruby Boots",
	desc_color = default.colors.ruby,
	inventory_image = "3d_armor_inv_boots_ruby.png",
	groups = {armor_feet = 5, armor_heal = 15,
		physics_speed = 0.01, physics_jump = 0.01}
})

armor:register_armor("3d_armor:boots_chain", {
	description = S"Chain Boots",
	inventory_image = "3d_armor_inv_boots_chain.png",
	groups = {armor_feet = 5, armor_heal = 15, armor_use = 500,
		physics_speed = 0.02, physics_jump = 0.02}
})

-- Register Craft Recipies

local craft_ingreds = {
	leather = "mobs:leather",
	steel   = "default:steel_ingot",
	gold    = "default:gold_ingot",
	diamond = "default:diamond",
	emerald = "default:emerald",
	ruby    = "default:ruby",
	chain   = "fire:basic_flame"
}

for k, v in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "3d_armor:helmet_" .. k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{"", "", ""}
		}
	})
	minetest.register_craft({
		output = "3d_armor:chestplate_" .. k,
		recipe = {
			{v, "", v},
			{v, v, v},
			{v, v, v}
		}
	})
	minetest.register_craft({
		output = "3d_armor:leggings_" .. k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{v, "", v}
		}
	})
	minetest.register_craft({
		output = "3d_armor:boots_" .. k,
		recipe = {
			{v, "", v},
			{v, "", v}
		}
	})
end
