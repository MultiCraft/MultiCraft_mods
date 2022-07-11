local S = minetest.get_translator_auto(true)

for hour = 0, 12 do
	local img = hour ~= 0 and "watch_" .. hour or "blank"
	minetest.register_tool("watch:" .. hour, {
		description = S"Watch",
		inventory_image = "watch_watch.png^" .. img .. ".png",
		wield_image = "watch_watch.png^" .. img .. ".png",
		groups = {watch = hour, wieldview = 1, not_in_creative_inventory = (hour == 0 and 0) or 1}
	})
end

minetest.register_craft({
	output = "watch:0",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:gold_ingot", "bluestone:dust", "default:gold_ingot"},
		{"", "default:gold_ingot", ""}
	}
})

local floor = math.floor
local get_timeofday = minetest.get_timeofday
local registered_tools = minetest.registered_tools
local get_player_by_name = minetest.get_player_by_name

minetest.register_playerstep(function(_, playernames)
	local now = floor((get_timeofday() * 24) % 12)
	for _, name in pairs(playernames) do
		local player = get_player_by_name(name)
		if not player or not player:is_player() then return end
		local inv = player:get_inventory()
		for i, stack in pairs(inv:get_list("main")) do
			local tools = registered_tools[stack:get_name()]
			if tools and tools.groups.watch and tools.groups.watch ~= now then
				inv:set_stack("main", i, "watch:" .. now)
			end
		end
	end
end)
