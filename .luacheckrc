unused_args = true
allow_defined_top = true
max_line_length = 160

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
	"dump",
	"vector",
	"VoxelManip", "VoxelArea",
	"PseudoRandom", "PcgRandom",
	"ItemStack",
	"Settings",
	"unpack",
	"creative",
	"experience",
	"mobs",
	"playerphysics",
	"screwdriver",
	"sscsm",
	"workbench",
	-- Silence errors about custom table methods.
	table = { fields = { "copy", "indexof" } },
	-- Silence warnings about accessing undefined fields of global 'math'
	math = { fields = { "sign" } }
}

globals = {"intllib", "hud", "Sl"}

exclude_files = {
	"files/bluestone/mesecons/internal.lua",
	"files/deprecated/init.lua",
	"files/mobs/mobs_redo/api.lua",
	"files/signs/slugify.lua",
	"files/utf8lib/utf8data.lua",
	"files/workbench/init.lua",
}

files["files/3d_armor/api.lua"].unused = false
files["files/bluestone/mesecons/actionqueue.lua"].unused = false
files["files/bluestone/mesecons_wires/init.lua"].unused = false
files["files/carts/*.lua"].unused = false
files["files/player/playereffects/init.lua"].unused = false
