unused_args = true
allow_defined_top = true
max_line_length = 140

ignore = {
	"431", -- shadowing an upvalue
	"432", -- shadowing an upvalue argument
	"542", -- empty if branch
}

globals = {
	"minetest",
	"areas",
	"experience",
	"invisibility",
	"mobs",
	"screwdriver",
	"workbench",
	"brewing",
}

read_globals = {
	"DIR_DELIM",
	"PLATFORM",
	"climate_api",
	"hud",
	"hunger",
	"dump",
	"vector",
	"utf8",
	"VoxelManip", "VoxelArea",
	"PseudoRandom", "PcgRandom",
	"ItemStack",
	"unpack",
	"playerphysics",
	"node_attacher",
	"bonemeal",
	"sscsm",
	"hopper",
	"workbench",
	-- Silence errors about custom table and string methodss.
	table = { fields = { "copy", "indexof", "insert_all" } },
	string = { fields = { "split" } },
	-- Silence warnings about accessing undefined fields of global 'math'
	math = { fields = { "sign" } }
}

exclude_files = {
	"files/deprecated/init.lua",
	"files/workbench/init.lua",
	"files/signs/slugify.lua",
	"MODS/mobs/mobs_redo/api.lua",
}

files["files/bluestone/mesecons/actionqueue.lua"].unused = false
files["files/carts/*.lua"].unused = false
files["files/player/playereffects/init.lua"].unused = false
files["MODS/achievements/awards/src/api_triggers.lua"].unused = false
files["MODS/3d_armor/3d_armor/api.lua"].unused = false
