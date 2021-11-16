dye = {}

local translator = minetest.get_translator
local S = translator and translator("dye") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

-- Make dye names and descriptions available globally
dye.dyes = {
	{"black",      S("Black"),      S("Black2"),      S("Black3")},
	{"blue",       S("Blue"),       S("Blue2"),       S("Blue3")},
	{"brown",      S("Brown"),      S("Brown2"),      S("Brown3")},
	{"cyan",       S("Cyan"),       S("Cyan2"),       S("Cyan3")},
	{"dark_green", S("Dark Green"), S("Dark Green2"), S("Dark Green3")},
	{"dark_grey",  S("Dark Grey"),  S("Dark Grey2"),  S("Dark Grey3")},
	{"green",      S("Green"),      S("Green2"),      S("Green3")},
	{"grey",       S("Grey"),       S("Grey2"),       S("Grey3")},
	{"magenta",    S("Magenta"),    S("Magenta2"),    S("Magenta3")},
	{"orange",     S("Orange"),     S("Orange2"),     S("Orange3")},
	{"pink",       S("Pink"),       S("Pink2"),       S("Pink3")},
	{"red",        S("Red"),        S("Red2"),        S("Red3")},
	{"violet",     S("Violet"),     S("Violet2"),     S("Violet3")},
	{"white",      S("White"),      S("White2"),      S("White3")},
	{"yellow",     S("Yellow"),     S("Yellow2"),     S("Yellow3")}
}

-- Define items
for _, row in ipairs(dye.dyes) do
	local name = row[1]
	local description = row[2]
	local groups = {dye = 1, nohit = 1}
	groups["color_" .. name] = 1

	minetest.register_craftitem("dye:" .. name, {
		inventory_image = "dye_" .. name .. ".png",
		description = description .. " " .. S("Dye"),
		groups = groups
	})
end

-- Manually add coal -> black dye
minetest.register_craft({
	output = "dye:black 4",
	recipe = {
		{"group:coal"}
	}
})

-- Manually add blueberries->violet dye
minetest.register_craft({
	output = "dye:violet 2",
	recipe = {
		{"default:blueberries"}
	}
})

-- Manually add flowers recipes
local flowers_recipes = {
	"blue", "magenta", "orange", "pink",
	"red", "violet", "yellow"
}

for _, name in ipairs(flowers_recipes) do
	minetest.register_craft({
		output = "dye:" .. name .. " 4",
		recipe = {
			{"group:flower,color_" .. name}
		}
	})
end

minetest.register_craft({
	output = "dye:white",
	recipe = {
		{"group:flower,color_white"}
	}
})

-- Mix recipes
local dye_recipes = {
	-- src1, src2, dst
	-- RYB mixes
	{"red", "blue", "violet"}, -- "purple"
	{"yellow", "red", "orange"},
	{"yellow", "blue", "green"},
	-- RYB complementary mixes
	{"yellow", "violet", "dark_grey"},
	{"blue", "orange", "dark_grey"},
	-- CMY mixes - approximation
	{"cyan", "yellow", "green"},
	{"cyan", "magenta", "blue"},
	{"yellow", "magenta", "red"},
	-- other mixes that result in a color we have
	{"red", "green", "brown"},
	{"magenta", "blue", "violet"},
	{"green", "blue", "cyan"},
	{"pink", "violet", "magenta"},
	-- mixes with black
	{"white", "black", "grey"},
	{"grey", "black", "dark_grey"},
	{"green", "black", "dark_green"},
	{"orange", "black", "brown"},
	-- mixes with white
	{"white", "red", "pink"},
	{"white", "dark_grey", "grey"},
	{"white", "dark_green", "green"}
}

for _, mix in pairs(dye_recipes) do
	minetest.register_craft({
		type = "shapeless",
		output = "dye:" .. mix[3] .. " 2",
		recipe = {"dye:" .. mix[1], "dye:" .. mix[2]}
	})
end

minetest.register_craft({
	output = "dye:white 3",
	recipe = {
		{"default:bone"}
	}
})

minetest.register_craft({
	output = "dye:blue 9",
	recipe = {
		{"default:lapisblock"}
	}
})

minetest.register_craft({
	output = "default:lapisblock",
	recipe = {
		{"dye:blue", "dye:blue", "dye:blue"},
		{"dye:blue", "dye:blue", "dye:blue"},
		{"dye:blue", "dye:blue", "dye:blue"}
	}
})
