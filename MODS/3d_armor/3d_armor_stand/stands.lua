local S = armor_stand.S

armor_stand.register_armor_stand("3d_armor_stand:armor_stand", {
	description =  S("Armor Stand") .. " (" .. S("Apple Wood") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_wood"
})

armor_stand.register_armor_stand("3d_armor_stand:armor_stand_acacia_wood", {
	description =  S("Armor Stand") .. " (" .. S("Acacia Wood") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_acacia.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_acacia_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_acacia_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_acacia_wood"
})

armor_stand.register_armor_stand("3d_armor_stand:armor_stand_birch_wood", {
	description =  S("Armor Stand") .. " (" .. S("Birch Wood") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_birch.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_birch_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_birch_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_birch_wood"
})

armor_stand.register_armor_stand("3d_armor_stand:armor_stand_jungle_wood", {
	description =  S("Armor Stand") .. " (" .. S("Jungle Wood") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_jungle.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_jungle_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_jungle_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_jungle_wood"
})

armor_stand.register_armor_stand("3d_armor_stand:armor_stand_pine_wood", {
	description =  S("Armor Stand") .. " (" .. S("Pine Wood") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_pine.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_pine_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_pine_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_pine_wood"
})

armor_stand.register_armor_stand("3d_armor_stand:armor_stand_cherry_blossom_wood", {
	description =  S("Armor Stand") .. " (" .. S("Cherry Blossom Wood") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_wood_cherry_blossom.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_cherry_blossom_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_wood_cherry_blossom_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	material = "default:fence_cherry_blossom_wood"
})

armor_stand.register_armor_stand("3d_armor_stand:armor_stand_ice", {
	description =  S("Armor Stand") .. " (" .. S("Ice") .. ")",
	tiles = {"3d_armor_stand_platform.png^3d_armor_stand_ice.png"},
	inventory_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_ice_inv.png",
	wield_image = "3d_armor_stand_platform_inv.png^3d_armor_stand_ice_inv.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_glass_defaults(),
	material = "default:fence_ice"
})
