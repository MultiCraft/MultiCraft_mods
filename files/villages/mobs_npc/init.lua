mobs_npc = {}

local translator = minetest.get_translator
mobs_npc.S = translator and translator("mobs_npc") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		mobs_npc.S = intllib.make_gettext_pair()
	end
end

-- replace npc using the old player model
function mobs_npc.replace_model(self)
	if self.collisionbox[2] ~= -1.0 then
		local pos = self.object:get_pos()
		if pos then
			minetest.add_entity(pos, self.name)
			self.object:remove()
			return true
		end
	end
	return false
end

local path = minetest.get_modpath("mobs_npc")
local npc = {"npc", "trader"}

for _, name in pairs(npc) do
	dofile(path .. "/" .. name .. ".lua")
end
