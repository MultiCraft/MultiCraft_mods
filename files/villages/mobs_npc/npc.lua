-- Npc by TenPlus1

local b = "blank.png"

mobs.npc_drops = {
	"default:pick_steel", "mobs:meat", "default:sword_steel",
	"default:shovel_steel", "farming:bread", "bucket:bucket_water"
}

local mtextures = {}
local mcount = 1
for i = 1, 3 do
for j = 1, 3 do
for k = 1, 3 do
	mtextures[mcount] = {
		"mobs_npc_man.png" .. "^" ..
		"mobs_npc_man_hair" .. i .. ".png" .. "^" ..
		"mobs_npc_man_pants" .. j .. ".png" .. "^" ..
		"mobs_npc_man_shirt" .. k .. ".png", b, b, b, b
	}
	mcount = mcount + 1
end
end
end

mobs:register_mob("mobs_npc:npc_man", {
	type = "npc",
	damage = 2,
	attacks_monsters = true,
	attack_players = false,
--	owner_loyal = true,
--	pathfinding = true,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	visual = "mesh",
	mesh = "mobs_npc.b3d",
	textures = mtextures,
--[[child_texture = {
		{"mobs_npc_baby.png", b, b, b}
	},]]
	makes_footstep_sound = true,
	sounds = {},
	jump = true,
	lava_damage = 3,
--	follow = {"farming:bread", "mobs:meat", "default:diamond"},
--	owner = "",
--	order = "follow",
	fear_height = 3,
	animation = {
		speed_normal = 30,	speed_run = 30,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 187, walk_speed = 15,
		run_start = 168,	run_end = 187,
		punch_start = 189,	punch_end = 198
	},

	do_punch = function(_, hitter)
		if not hitter or not hitter:is_player() then
			return true
		end
	end,

	after_activate = mobs_npc.replace_model,

--[[on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end

		local item = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		-- right clicking with gold lump drops random item from mobs.npc_drops
		if item:get_name() == "default:gold_lump" then
			if not mobs.is_creative(name) then
				item:take_item()
				clicker:set_wielded_item(item)
			end

			local pos = self.object:get_pos()
			pos.y = pos.y + 0.5
			local drops = self.npc_drops or mobs.npc_drops

			minetest.add_item(pos, {
				name = drops[math.random(#drops)]
			})

			minetest.chat_send_player(name, mobs_npc.S("NPC dropped you an item for gold!"))
			return
		end

		-- by right-clicking owner can switch npc between follow and stand
		if self.owner and self.owner == name then
			if self.order == "follow" then
				self.order = "stand"
				minetest.chat_send_player(name, mobs_npc.S("NPC stands still."))
			else
				self.order = "follow"
				minetest.chat_send_player(name, mobs_npc.S("NPC will follow you."))
			end
		end
	end]]
})

local wtextures = {}
local wcount = 1
for i = 1, 3 do
for j = 1, 3 do
for k = 1, 3 do
	wtextures[wcount] = {
		"mobs_npc_woman.png" .. "^" ..
		"mobs_npc_woman_hair" .. i .. ".png" .. "^" ..
		"mobs_npc_woman_pants" .. j .. ".png" .. "^" ..
		"mobs_npc_woman_shirt" .. k .. ".png", b, b, b, b
	}
	wcount = wcount + 1
end
end
end

mobs:register_mob("mobs_npc:npc_woman", {
	type = "npc",
	damage = 1,
	attacks_monsters = true,
	attack_players = false,
--	owner_loyal = true,
--	pathfinding = true,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	visual = "mesh",
	mesh = "mobs_npc.b3d",
	textures = wtextures,
--[[child_texture = {
		{"mobs_npc_baby.png", b, b, b}
	},]]
	makes_footstep_sound = true,
	sounds = {},
	jump = true,
	lava_damage = 3,
--	follow = {"farming:bread", "mobs:meat", "default:diamond"},
--	owner = "",
--	order = "follow",
	fear_height = 3,
	animation = {
		speed_normal = 30,	speed_run = 30,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 187, walk_speed = 15,
		run_start = 168,	run_end = 187,
		punch_start = 189,	punch_end = 198
	},

	do_punch = function(_, hitter)
		if not hitter or not hitter:is_player() then
			return true
		end
	end,

	after_activate = mobs_npc.replace_model,

--[[on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end

		local item = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		-- right clicking with gold lump drops random item from mobs.npc_drops
		if item:get_name() == "default:gold_lump" then
			if not mobs.is_creative(name) then
				item:take_item()
				clicker:set_wielded_item(item)
			end

			local pos = self.object:get_pos()
			pos.y = pos.y + 0.5
			local drops = self.npc_drops or mobs.npc_drops

			minetest.add_item(pos, {
				name = drops[math.random(#drops)]
			})

			minetest.chat_send_player(name, mobs_npc.S("NPC dropped you an item for gold!"))
			return
		end

		-- by right-clicking owner can switch npc between follow and stand
		if self.owner and self.owner == name then
			if self.order == "follow" then
				self.order = "stand"
				minetest.chat_send_player(name, mobs_npc.S("NPC stands still."))
			else
				self.order = "follow"
				minetest.chat_send_player(name, mobs_npc.S("NPC will follow you."))
			end
		end
	end]]
})

mobs:register_egg("mobs_npc:npc_man", mobs_npc.S("NPC Man"), "mobs_npc_man_egg.png")
mobs:register_egg("mobs_npc:npc_woman", mobs_npc.S("NPC Woman"), "mobs_npc_woman_egg.png")
