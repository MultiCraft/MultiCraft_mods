-- Global farming namespace
farming = {}

local S = minetest.get_translator_auto({"ru"})
farming.S = S

-- Load files
local path = minetest.get_modpath("farming")
dofile(path .. "/api.lua")
dofile(path .. "/nodes.lua")
dofile(path .. "/hoes.lua")

-- WHEAT

farming.register_plant("farming:wheat", {
	description = S"Wheat Seed",
	harvest_description = S"Wheat",
	paramtype2 = "meshoptions",
	inventory_image = "farming_wheat_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland"},
	place_param2 = 3,
	groups = {food_wheat = 1, flammable = 4, wieldview = 2}
})

minetest.register_craftitem("farming:flour", {
	description = S"Flour",
	inventory_image = "farming_flour.png",
	groups = {food_flour = 1, flammable = 1, farming = 1}
})

minetest.register_craftitem("farming:bread", {
	description = S"Bread",
	inventory_image = "farming_bread.png",
	on_use = minetest.item_eat(5),
	groups = {food_bread = 1, flammable = 2, food = 1}
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:flour",
	recipe = {"farming:wheat", "farming:wheat", "farming:wheat"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:bread",
	recipe = "farming:flour"
})

-- String

minetest.register_craftitem("farming:string",{
	description = S"String",
	inventory_image = "farming_string.png",
	groups = {materials = 1}
})

minetest.register_craft({
	output = "farming:string",
	recipe = {{"default:paper", "default:paper"}}
})

-- Straw

minetest.register_craft({
	output = "farming:straw 3",
	recipe = {
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", "farming:wheat", "farming:wheat"}
	}
})

minetest.register_craft({
	output = "farming:wheat 3",
	recipe = {{"farming:straw"}}
})

-- Fuels

minetest.register_craft({
	type = "fuel",
	recipe = "farming:straw",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:wheat",
	burntime = 1
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:cotton",
	burntime = 1
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:string",
	burntime = 1
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:hoe_wood",
	burntime = 5
})

-- Register farming items as dungeon loot
if minetest.global_exists("dungeon_loot") then
	dungeon_loot.register({
		{name = "farming:string", chance = 0.5, count = {1, 8}},
		{name = "farming:wheat", chance = 0.5, count = {2, 5}},
		{name = "farming:hoe_steel", chance = 0.25},
		{name = "farming:hoe_gold", chance = 0.2},
		{name = "farming:hoe_diamond", chance = 0.05}
	})
end
