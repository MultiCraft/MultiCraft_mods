mobs_npc = {
	S = minetest.get_translator_auto(true)
}

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

for _, name in ipairs(npc) do
	dofile(path .. "/" .. name .. ".lua")
end
