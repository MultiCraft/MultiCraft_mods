-- Media and code needed to upgrade to the new version.
-- Must be removed no earlier than 12 months after release.

--local path = minetest.get_modpath("deprecated")

-- Localization for better performance
local register_alias = minetest.register_alias

--== default ==--
local default = {
	{"default:pinetree", "default:pine_tree"},
	{"default:pinewood", "default:pine_wood"},
	{"default:gold_nugget", "default:gold_ingot"},
	{"default:ladder", "default:ladder_wood"},
	{"default:reeds", "default:sugarcane"},
	{"default:papyrus", "default:sugarcane"},
	{"hardened_clay:hardened_clay", "default:hardened_clay"},
	{"fences:fence_wood", "default:fence_wood"},
	{"mobs:bucket_milk", "bucket:bucket_milk"}, -- new
	{"default:string", "farming:string"}, -- new
	{"default:haybale", "farming:straw"}, -- new
}

for _, d in pairs(default) do
	register_alias(d[1], d[2])
end

local fnames = {}
for _, f in pairs({"1", "2", "3", "11", "12", "13", "14",
		"21", "22", "23", "24", "32", "33", "34", "35"}) do
	fnames[#fnames + 1] = "fences:fence_wood_" .. f
end 

minetest.register_lbm({
	label = "Replace Fences",
	name = "deprecated:fences",
	nodenames = fnames,
	run_at_every_load = true,
	action = function(pos)
		minetest.set_node(pos, {name = "default:fence_wood"})
	end
})

--== workbench ==--
minetest.after(2, function()
	--
	-- [Delete aliases after December 2020]
	--

	local function match_any(needles, haystack, regex)
		for _, needle in pairs(needles) do
			if haystack:match(regex) == needle then
				return true
			end
		end
		return false
	end

	local aliased_nodes = {}
	local aliased_mods = {"default", "farming", "mobs", "wool"}

	for node in pairs(workbench.nodes) do
		if match_any(aliased_mods, node, "(.*):") then
			aliased_nodes[node] = true
		end
	end

	local stairs_aliases = {
		{"corner",		"outerstair"},
		{"invcorner",	"outerstair"},
		{"stair_outer",	"innerstair"},
		{"stair_inner",	"innerstair"},
		{"nanoslab",	"microslab"}
	}

	for node in pairs(aliased_nodes) do
		for _, d in pairs(workbench.defs) do
			register_alias("stairs:" .. d[1] .. "_" .. node:match(":(.*)"),	"stairs:" .. d[1] .. "_" .. node:gsub(":", "_"))
			register_alias(node .. "_" .. d[1],								"stairs:" .. d[1] .. "_" .. node:gsub(":", "_"))
		end

		for _, e in pairs(stairs_aliases) do
			register_alias("stairs:" .. e[1] .. "_" .. node:match(":(.*)"),	"stairs:" .. e[2] .. "_" .. node:gsub(":", "_"))
			register_alias("stairs:" .. e[1] .. "_" .. node:gsub(":", "_"),	"stairs:" .. e[2] .. "_" .. node:gsub(":", "_"))
			register_alias(node .. "_" .. e[1],								"stairs:" .. e[2] .. "_" .. node:gsub(":", "_"))
		end
	end

	for _, d in pairs(workbench.defs) do
		register_alias("stairs:" .. d[1] .. "_coal",			 "stairs:" .. d[1] .. "_default_coalblock")
		register_alias("stairs:" .. d[1] .. "_lapis_block",		 "stairs:" .. d[1] .. "_default_lapisblock")
		register_alias("stairs:" .. d[1] .. "_mobs_cheeseblock", "stairs:" .. d[1] .. "_mobs_animals_cheeseblock")
	end

	for _, e in pairs(stairs_aliases) do
		register_alias("stairs:" .. e[1] .. "_coal",		"stairs:" .. e[2] .. "_default_coalblock")
		register_alias("stairs:" .. e[1] .. "_lapis_block",	"stairs:" .. e[2] .. "_default_lapisblock")
	end

	register_alias("stairs:stair_steel",	"stairs:stair_default_steelblock")
	register_alias("stairs:slab_steel",		"stairs:slab_default_steelblock")
	register_alias("stairs:corner_steel",	"stairs:outerstair_default_steelblock")
	register_alias("stairs:stair_gold",		"stairs:stair_default_goldblock")
	register_alias("stairs:slab_gold",		"stairs:slab_default_goldblock")
	register_alias("stairs:corner_gold",	"stairs:outerstair_default_goldblock")
	register_alias("stairs:stair_diamond",	"stairs:stair_default_diamondblock")
	register_alias("stairs:slab_diamond",	"stairs:slab_default_diamondblock")
	register_alias("stairs:corner_diamond",	"stairs:outerstair_default_diamondblock")

	--
	-- Remove from Creative inventory [Never delete]
	--

	local remove_nodes = {
		"default:stone_with_bluestone",
		"default:stone_with_coal",
		"default:stone_with_diamond",
		"default:stone_with_emerald",
		"default:stone_with_iron",
		"default:stone_with_gold",
		"default:stone_with_lapis",
		"farming_addons:pumpkin_fruit",
		"sponge:sponge"
	}

	for _, n in pairs(remove_nodes) do
		for _, e in pairs(workbench.defs) do
			register_alias("stairs:" .. e[1] .. "_" .. n:gsub(":", "_"), n)
		end
	end
end)
