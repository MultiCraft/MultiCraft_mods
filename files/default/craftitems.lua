-- mods/default/craftitems.lua

--
-- Crafting items
--

minetest.register_craftitem("default:stick", {
    description = "Stick",
    inventory_image = "default_stick.png",
    groups = {materials = 1},

})

minetest.register_craftitem("default:paper", {
    description = "Paper",
    inventory_image = "default_paper.png",
    groups = {misc = 1},
})

minetest.register_craftitem("default:book", {
    description = "Book",
    inventory_image = "default_book.png",
    groups = {misc = 1},
})

minetest.register_craftitem("default:coal_lump", {
    description = "Coal Lump",
    inventory_image = "default_coal_lump.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:charcoal_lump", {
    description = "Charcoal Lump",
    inventory_image = "default_charcoal_lump.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:diamond", {
    description = "Diamond",
    inventory_image = "default_diamond.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:clay_lump", {
    description = "Clay Lump",
    inventory_image = "default_clay_lump.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:steel_ingot", {
    description = "Steel Ingot",
    inventory_image = "default_steel_ingot.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:gold_ingot", {
    description = "Gold Ingot",
    inventory_image = "default_gold_ingot.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:emerald", {
    description = "Emerald",
    inventory_image = "default_emerald.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:clay_brick", {
    description = "Clay Brick",
    inventory_image = "default_clay_brick.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:gunpowder", {
    description = "Gunpowder",
    inventory_image = "default_gunpowder.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:bone", {
    description = "Bone",
    inventory_image = "default_bone.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:glowstone_dust", {
    description = "Glowstone Dust",
    inventory_image = "default_glowstone_dust.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:fish_raw", {
    description = "Raw Fish",
    groups = {},
    inventory_image = "default_fish.png",
    on_use = minetest.item_eat(2),
    groups = {foodstuffs = 1},
})

minetest.register_craftitem("default:fish", {
    description = "Cooked Fish",
    groups = {},
    inventory_image = "default_fish_cooked.png",
    on_use = minetest.item_eat(4),
    groups = {foodstuffs = 1},
})

minetest.register_craftitem("default:sugar", {
    description = "Sugar",
    inventory_image = "default_sugar.png",
    groups = {materials = 1},
})

minetest.register_craftitem("default:string",{
    description = "String",
    inventory_image = "default_string.png",
    groups = {materials = 1},
})


minetest.register_craftitem("default:quartz_crystal", {
    description = "Quartz Crystal",
    inventory_image = "default_quartz_crystal.png",
    groups = {materials = 1},
})