-- Intllib
local S = intllib.make_gettext_pair()

local b = "blank.png"

mobs:register_mob("mobs_npc:trader", {
	type = "npc",
	damage = 1,
	attacks_monsters = true,
	armor = 0,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	visual = "mesh",
	mesh = "character.b3d",
	textures = {
		{"mobs_trader.png^mobs_trader1.png", b, b, b},
		{"mobs_trader.png^mobs_trader2.png", b, b, b},
		{"mobs_trader.png^mobs_trader3.png", b, b, b}
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 2,
	run_velocity = 2,
	jump = false,
	drops = {},
	lava_damage = 3,
	order = "stand",
	fear_height = 3,
	animation = {
		speed_normal = 30,	speed_run = 30,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 187, walk_speed = 15,
		run_start = 168,	run_end = 187,
		punch_start = 189,	punch_end = 198
	},

	on_punch = function(self, clicker)
		mobs_trader(self, clicker, nil, mobs.human)
	end,

	on_rightclick = function(self, clicker)
		mobs_trader(self, clicker, nil, mobs.human)
	end,

	on_spawn = function(self)
		self.nametag = S("Trader")
		self.object:set_properties({
			nametag = self.nametag,
			nametag_color = "#FFFFFF"
		})
		return true -- return true so on_spawn is run once only
	end,

	after_activate = function(self)
		if not self.game_name then
			self.object:set_properties({
				nametag_color = "#FFFFFF"
			})
		end
	end
})

-- This code comes almost exclusively from the trader and inventory of mobf, by Sapier.
-- The copyright notice below is from mobf:
-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
--
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice.
-- And of course you are NOT allow to pretend you have written it.
--
--! @file inventory.lua
--! @brief component containing mob inventory related functions
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-02
--
--! @defgroup Inventory Inventory subcomponent
--! @brief Component handling mob inventory
--! @ingroup framework_int
--! @{
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

-- This code has been heavily modified by isaiah658.
-- Trades are saved in entity metadata so they always stay the same after
-- initially being chosen. Also the formspec uses item image buttons instead of
-- inventory slots.

-- Define tabe containing names for use and shop items for sale
mobs.human = {
	names = {
		"Bob", "Duncan", "Bill", "Tom", "James", "Ian", "Lenny",
		"Dylan", "Ethan"
	},

	-- Item for sale, price, chance of appearing in trader's inventory
	items = {
		{"default:apple 8", "default:emerald 1", 10},
		{"farming:bread 8", "default:emerald 2", 5},
		{"default:clay 8", "default:emerald 1", 12},
		{"default:brick 8", "default:emerald 2", 17},
		{"default:glass 8", "default:emerald 2", 17},
		{"default:obsidian 16", "default:emerald 8", 50},
		{"default:diamond 1", "default:emerald 2", 40},
		{"farming:wheat 8", "default:emerald 2", 17},
		{"default:tree 4", "default:emerald 1", 20},
		{"default:stone 8", "default:emerald 2", 17},
		{"default:sapling 1", "default:emerald 1", 7},
		{"default:pick_gold 1", "default:emerald 2", 7},
		{"default:sword_gold 1", "default:emerald 2", 17},
		{"default:shovel_gold 1", "default:emerald 1", 17},
		{"default:cactus 4", "default:emerald 2", 40},
		{"default:sugarcane 4", "default:emerald 2", 40}
	}
}

function mobs.add_goods(self, _, race)
	local trade_index = 1
	local trades_already_added = {}
	local trader_pool_size = 6
	local item_pool_size = #race.items -- get number of items on list

	self.trades = {}

	if item_pool_size < trader_pool_size then
		trader_pool_size = item_pool_size
	end

	for i = 1, trader_pool_size do
		-- If there are more trades than the amount being added, they are
		-- randomly selected. If they are equal, there is no reason to randomly
		-- select them
		local random_trade

		if item_pool_size == trader_pool_size then
			random_trade = i
		else
			while random_trade == nil do
				local num = math.random(item_pool_size)

				if trades_already_added[num] == nil then
					trades_already_added[num] = true
					random_trade = num
				end
			end
		end

		if math.random(0, 100) > race.items[random_trade][3] then
			self.trades[trade_index] = {
				race.items[random_trade][1],
				race.items[random_trade][2]
			}

			trade_index = trade_index + 1
		end
	end
end

function mobs_trader(self, clicker, entity, race)
	if not self.id then
		self.id = (math.random(1000) * math.random(10000))
				.. self.name .. (math.random(1000) ^ 2)
	end

	if not self.game_name then
		self.game_name = tostring(S(race.names[math.random(#race.names)]))
		self.nametag = S("Trader @1", self.game_name)
		self.object:set_properties({
			nametag = self.nametag,
			nametag_color = "#00FF00"
		})
	end

	if self.trades == nil then
		mobs.add_goods(self, entity, race)
	end

	local player = clicker:get_player_name()
	local player_name = (player == "Player" and S("Player")) or player
	minetest.chat_send_player(player,
		S("<[NPC] Trader @1> Hello, @2, have a look at my wares.",
			self.game_name, player_name))

	-- Make formspec trade list
	local formspec_trade_list = ""
	local x, y

	for i = 1, 6 do
		if self.trades[i] and self.trades[i] ~= "" then
			if i < 4 then
				x = 1
				y = i - 0.2
			else
				x = 5
				y = i - 3.2
			end

			formspec_trade_list = formspec_trade_list ..
					"item_image[" .. x .. "," .. y .. ";1,1;" .. self.trades[i][2] .. "]" ..
					"image_button[" .. x .. "," .. y .. ";1,1;blank.png;prices#" .. i .. "#" .. self.id .. ";;;false;default_item_pressed.png]" ..
				--	"tooltip[prices#".. i .. "#" .. self.id .. ";"..tooltip.."]" ..
					"item_image[" .. x + 2 .. "," .. y .. ";1,1;" .. self.trades[i][1] .. "]" ..
					"image_button[" .. x + 2 .. "," .. y .. ";1,1;blank.png;goods#" .. i .. "#" .. self.id .. ";;;false;default_item_pressed.png]"
				--	"tooltip[prices#".. i .. "#" .. self.id .. ";"..tooltip.."]"
		end
	end

	minetest.show_formspec(player, "mobs_npc:trade",
		default.gui ..
		"background[7.95,3.1;1,1;default_background.png]" ..
		"background[-0.2,-0.26;9.41,9.49;formspec_trader.png]" ..
		"item_image[0,-0.1;1,1;default:emerald]" ..
		"label[0.9,0.1;" .. S("Trader @1's stock", self.game_name) .. "]" ..
		formspec_trade_list)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "mobs_npc:trade" then return end

	if fields then
		local trade = ""
		for k, _ in pairs(fields) do
			trade = tostring(k)
		end

		local id = trade:split("#")[3]
		local self

		if id ~= nil then
			for _, v in pairs(minetest.luaentities) do
				if v.object and v.id and v.id == id then
					self = v
					break
				end
			end
		end

		if self ~= nil then
			local trade_number = tonumber(trade:split("#")[2])

			if trade_number ~= nil and self.trades[trade_number] ~= nil then
				local price = self.trades[trade_number][2]
				local goods = self.trades[trade_number][1]
				local inv = player:get_inventory()

				if inv:contains_item("main", price) then
					inv:remove_item("main", price)
					local leftover = inv:add_item("main", goods)

					if leftover:get_count() > 0 then
						-- Drop items in front of player
						local droppos = player:get_pos()
						local dir = player:get_look_dir()

						droppos.x = droppos.x + dir.x
						droppos.z = droppos.z + dir.z

						minetest.add_item(droppos, leftover)
					end
				end
			end
		end
	end
end)

mobs:register_egg("mobs_npc:trader", S("Trader"), "mobs_trader_egg.png")
