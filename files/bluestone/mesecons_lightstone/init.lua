

minetest.register_node("mesecons_lightstone:lightstone_off", {
        tiles = {"jeija_lightstone_gray_off.png"},
        groups = {cracky=2, mesecon_effector_off = 1, mesecon = 2},
        description= "Bluestone Lamp",
        sounds = default.node_sound_glass_defaults(),
        mesecons = {effector = {
                action_on = function (pos, node)
                        minetest.swap_node(pos, {name = "mesecons_lightstone:lightstone_on", param2 = node.param2})
                end,
        }}
})

minetest.register_node("mesecons_lightstone:lightstone_on", {
        tiles = {"jeija_lightstone_gray_on.png"},
        groups = {cracky=2,not_in_creative_inventory=1, mesecon = 2},
        drop = "mesecons_lightstone:lightstone_off",
        light_source = default.LIGHT_MAX-2,
        sounds = default.node_sound_glass_defaults(),
        mesecons = {effector = {
                action_off = function (pos, node)
                       minetest.swap_node(pos, {name = "mesecons_lightstone:lightstone_off", param2 = node.param2})
                end,
        }}
})

minetest.register_craft({
    output = "mesecons_lightstone:lightstone_off",
    recipe = {
            {"","default:bluestone_dust",""},
            {"default:bluestone_dust",'default:glowstone',"default:bluestone_dust"},
            {'','default:bluestone_dust',''},
    }
})
