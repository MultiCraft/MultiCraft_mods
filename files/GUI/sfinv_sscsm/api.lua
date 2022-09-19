sfinv = {
	pages = {},
	pages_unordered = {},
	contexts = {},
	enabled = true
}

local inventory_formspec
local inventory_open = false

local dump = rawget(_G, "dump")
if not dump then
	function dump(raw)
		return minetest.serialize(raw):sub(8)
	end
end

function sfinv.register_page(name, def)
	assert(name, "Invalid sfinv page. Requires a name")
	assert(def, "Invalid sfinv page. Requires a def[inition] table")
	assert(def.get, "Invalid sfinv page. Def requires a get function.")
	assert(not sfinv.pages[name], "Attempt to register already registered sfinv page " .. dump(name))

	sfinv.pages[name] = def
	def.name = name
	table.insert(sfinv.pages_unordered, def)
end

function sfinv.override_page(name, def)
	assert(name, "Invalid sfinv page override. Requires a name")
	assert(def, "Invalid sfinv page override. Requires a def[inition] table")
	local page = sfinv.pages[name]
	assert(page, "Attempt to override sfinv page " .. dump(name) .. " which does not exist.")
	for key, value in pairs(def) do
		page[key] = value
	end
end

function sfinv.get_nav_fs(context, nav, current_idx) -- luacheck: ignore
	-- Only show tabs if there is more than one page
	if nav and #nav > 1 then
		return "tabheader[0,0;sfinv_nav_tabs;" .. table.concat(nav, ",") ..
				";" .. current_idx .. ";true;false]"
	else
		return ""
	end
end

local theme_inv = [[
	list[current_player;main;0.01,4.51;9,3;9]
	list[current_player;main;0.01,7.74;9,1;]
]]

function sfinv.make_formspec(context, content, show_inv, size)
	local tmp = {
		size or "size[9,8.75]",
		sfinv.get_nav_fs(context, context.nav_titles, context.nav_idx),
		show_inv and theme_inv or "",
		content
	}
	return table.concat(tmp, "")
end

function sfinv.get_homepage_name()
	return "sfinv:inventory"
end

function sfinv.get_formspec(context)
	-- Generate navigation tabs
	local nav = {}
	local nav_ids = {}
	local current_idx = 1
	for _, pdef in pairs(sfinv.pages_unordered) do
		if not pdef.is_in_nav or pdef:is_in_nav(context) then
			nav[#nav + 1] = pdef.title
			nav_ids[#nav_ids + 1] = pdef.name
			if pdef.name == context.page then
				current_idx = #nav_ids
			end
		end
	end
	context.nav = nav_ids
	context.nav_titles = nav
	context.nav_idx = current_idx

	-- Generate formspec
	local page = sfinv.pages[context.page] or sfinv.pages["404"]
	if page then
		return page:get(context)
	else
		local old_page = context.page
		local home_page = sfinv.get_homepage_name()

		if old_page == home_page then
			minetest.log("error", "[sfinv] Couldn't find " .. dump(old_page) ..
					", which is also the old page")

			return ""
		end

		context.page = home_page
		assert(sfinv.pages[context.page], "[sfinv] Invalid homepage")
		minetest.log("warning", "[sfinv] Couldn't find " .. dump(old_page) ..
				" so switching to homepage")

		return sfinv.get_formspec(context)
	end
end

function sfinv.get_or_create_context()
	local context = sfinv.context
	if not context then
		context = {
			page = sfinv.get_homepage_name()
		}
		sfinv.context = context
	end
	return context
end

function sfinv.set_context(context)
	sfinv.context = context
end

function sfinv.set_player_inventory_formspec(context)
	local fs = sfinv.get_formspec(context or sfinv.get_or_create_context())
	inventory_formspec = fs
	if inventory_open then
		sfinv.open_formspec()
	end
end

function sfinv.set_page(pagename)
	local context = sfinv.get_or_create_context()
	local oldpage = sfinv.pages[context.page]
	if oldpage and oldpage.on_leave then
		oldpage:on_leave(context)
	end
	context.page = pagename
	local page = sfinv.pages[pagename]
	if not page then
		inventory_formspec = nil
	elseif page.on_enter then
		page:on_enter(context)
	end
	sfinv.set_player_inventory_formspec(context)
end

function sfinv.get_page()
	local context = sfinv.context
	return context and context.page or sfinv.get_homepage_name()
end

local function on_formspec_input(formname, fields)
	if formname ~= "sfinv_sscsm:fs" or not sfinv.enabled then
		return false
	end

	if fields.quit then
		inventory_open = false
	end

	-- Get Context
	local context = sfinv.context
	if not context then
		sfinv.set_player_inventory_formspec()
		return false
	end

	-- Was a tab selected?
	if fields.sfinv_nav_tabs and context.nav then
		local tid = tonumber(fields.sfinv_nav_tabs)
		if tid and tid > 0 then
			local id = context.nav[tid]
			local page = sfinv.pages[id]
			if id and page then
				sfinv.set_page(id)
			end
		end
	else
		-- Pass event to page
		local page = sfinv.pages[context.page]
		if page and page.on_player_receive_fields then
			local res = page:on_player_receive_fields(context, fields)
			if res then
				return true
			elseif res == false then
				-- Pass fields to the server
				sscsm.com_send("sfinv_sscsm:fields", fields)
			end
		end
	end
end

minetest.register_on_formspec_input(on_formspec_input)

function sfinv.open_formspec()
	inventory_open = true
	minetest.show_formspec("sfinv_sscsm:fs", inventory_formspec)
end

-- Tells the SSCSM that the inventory is no longer open.
function sfinv.inventory_closed()
	inventory_open = false
end

minetest.register_on_inventory_open(function()
	if inventory_formspec then
		sfinv.open_formspec()
		return true
	end
end)

-- Allow mods to defer the takeover of the inventory.
local blockers = 0
function sfinv.defer_takeover()
	blockers = blockers + 1
	return function()
		blockers = blockers - 1
		assert(blockers >= 0)
		if blockers == 0 then
			sscsm.com_send("sfinv_sscsm:takeover")
			sfinv.set_player_inventory_formspec()
		end
	end
end

sscsm.register_on_mods_loaded(sfinv.defer_takeover())

sfinv.register_page("sfinv:inventory", {
	get = function(_, player, context)
		return sfinv.make_formspec(player, context, "")
	end
})

sscsm.register_on_com_receive("sfinv_sscsm:set_page", function(msg)
	sfinv.set_page(msg[1])
	if msg[2] then
		sfinv.open_formspec()
	end
end)
sscsm.register_on_com_receive("sfinv_sscsm:open_formspec", sfinv.open_formspec)
sscsm.register_on_com_receive("sfinv_sscsm:handover", function(msg)
	if sfinv.pages[msg[1]] then sfinv.set_page(msg[1]) end
	sfinv.open_formspec()
	on_formspec_input("sfinv_sscsm:fs", msg[2])
end)

-- Disable the SSCSM inventory formspec on request from the server
sscsm.register_on_com_receive("sfinv_sscsm:disable", function()
	inventory_formspec = nil
	blockers = math.huge
	if inventory_open then
		-- CSMs can't close formspecs, ask the server to close it
		sscsm.com_send("sfinv_sscsm:close_formspec")
		inventory_open = false
	end
end)

-- Update player previews.
sscsm.register_on_com_receive("player_api:preview", function()
	if blockers == 0 then
		minetest.after(0, sfinv.set_player_inventory_formspec)
	end
end)
