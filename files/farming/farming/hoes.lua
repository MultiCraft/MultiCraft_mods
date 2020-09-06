local S = farming.S

farming.register_hoe("farming:hoe_wood", {
	description = S"Wooden Hoe",
	inventory_image = "farming_tool_woodhoe.png",
	max_uses = 30,
	material = "group:wood",
	groups = {hoe = 1, flammable = 2},
})

farming.register_hoe("farming:hoe_stone", {
	description = S"Stone Hoe",
	inventory_image = "farming_tool_stonehoe.png",
	max_uses = 90,
	material = "group:stone",
	groups = {hoe = 1}
})

farming.register_hoe("farming:hoe_steel", {
	description = S"Steel Hoe",
	inventory_image = "farming_tool_steelhoe.png",
	max_uses = 500,
	material = "default:steel_ingot",
	groups = {hoe = 1}
})

farming.register_hoe("farming:hoe_gold", {
	description = S"Gold Hoe",
	inventory_image = "farming_tool_goldhoe.png",
	max_uses = 350,
	material = "default:gold_ingot",
	groups = {hoe = 1}
})

farming.register_hoe("farming:hoe_diamond", {
	description = S"Diamond Hoe",
	inventory_image = "farming_tool_diamondhoe.png",
	max_uses = 750,
	material = "default:diamond",
	groups = {hoe = 1}
})

farming.register_hoe("farming:hoe_emerald", {
	description = default.colors.emerald .. S"Emerald Hoe",
	inventory_image = "farming_tool_emeraldhoe.png",
	max_uses = 1000,
	material = "default:emerald",
	groups = {hoe = 1}
})

farming.register_hoe("farming:hoe_ruby", {
	description = default.colors.ruby .. S"Ruby Hoe",
	inventory_image = "farming_tool_rubyhoe.png",
	max_uses = -1,
	material = "default:ruby",
	groups = {hoe = 1}
})
