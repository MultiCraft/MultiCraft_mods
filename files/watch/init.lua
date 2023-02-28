local S = minetest.get_translator("watch")

for hour = 0, 12 do
	local group = {watch = hour, wieldview = 1, no_change_anim = 1}
	if hour ~= 0 then
		group.not_in_creative_inventory = 1
	end
	local img = "watch_watch.png^" .. (hour ~= 0 and "watch_" .. hour or "blank") .. ".png"

	minetest.register_tool("watch:" .. hour, {
		description = S("Watch"),
		inventory_image = img,
		wield_image = img,
		groups = group
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
	for _, name in ipairs(playernames) do
		local player = get_player_by_name(name)

		if player then
			local inv = player:get_inventory()
			for i, stack in ipairs(inv:get_list("main")) do
				if i <= 9 then
					local tools = registered_tools[stack:get_name()]
					if tools and tools.groups.watch and tools.groups.watch ~= now then
						inv:set_stack("main", i, "watch:" .. now)
					end
				end
			end
		end
	end
end)
