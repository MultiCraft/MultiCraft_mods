unused_args = true
allow_defined_top = true
max_line_length = 140

ignore = {
	"122", -- setting a read-only field of a global variable
	"431", -- shadowing an upvalue
	"432", -- shadowing an upvalue argument
	"542", -- empty if branch
}

read_globals = {
	"DIR_DELIM",
	"PLATFORM",
	"minetest",
	"intllib",
	"hud",
	"Sl",
	"dump",
	"vector",
	"utf8",
	"VoxelManip", "VoxelArea",
	"PseudoRandom", "PcgRandom",
	"ItemStack",
	"Settings",
	"unpack",
	"creative",
	"experience",
	"mobs",
	"playerphysics",
	"node_attacher",
	"screwdriver",
	"bonemeal",
	"sscsm",
	"hunger",
	"hopper",
	"workbench",
	-- Silence errors about custom table methods.
	table = { fields = { "copy", "indexof" } },
	-- Silence warnings about accessing undefined fields of global 'math'
	math = { fields = { "sign" } }
}

exclude_files = {
	"files/deprecated/init.lua",
	"files/mobs/mobs_redo/api.lua",
	"files/workbench/init.lua",
	"files/signs/slugify.lua"
}

files["files/bluestone/mesecons/actionqueue.lua"].unused = false
files["files/3d_armor/api.lua"].unused = false
files["files/carts/*.lua"].unused = false
files["files/player/playereffects/init.lua"].unused = false
