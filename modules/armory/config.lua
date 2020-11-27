Armory_Config = {
    pedModel = "s_m_y_ammucity_01",

    createBlip = function(coords)
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 313)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 49)
        SetBlipScale(blip, 1.0)
        SetBlipCategory(blip, 12)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Armurerie")
        EndTextCommandSetBlipName(blip)
    end,

    items = {
        {category = "↓ ~r~Armes de mêlée ~s~↓"},
        {item = "weapon_knife", label = "Couteau",price = 1200, isItem = false},
        {item = "weapon_bat", label = "Batte",price = 1200, isItem = false},
        {category = "↓ ~r~Armes de poing ~s~↓"},
        {item = "weapon_combatpistol", label = "Pistolet 9mn",price = 3500, isItem = false},
        {item = "weapon_pistol50", label = "Pistolet cal.50",price = 4000, isItem = false},
        {item = "weapon_appistol", label = "Pistolet automatique",price = 6000, isItem = false},
        {category = "↓ ~r~Fusils à pompe ~s~↓"},
        {item = "weapon_pumpshotgun", label = "Fusil à pompe",price = 10000, isItem = false},
        {item = "weapon_musket", label = "Mousquet",price = 10000, isItem = false},
    },

    list = {
        {loc = vector3(21.30, -1107.22, 29.79), npc = vector3(22.17, -1104.98, 29.79), npcHeading = 155.0, currentNPC = nil},
        {loc = vector3(-663.03, -935.92, 21.82), npc = vector3(-663.55, -933.22, 21.82), npcHeading = 181.52, currentNPC = nil},
        {loc = vector3(810.53, -2156.74, 29.61), npc = vector3(810.36, -2159.40, 29.61), npcHeading = 4.4, currentNPC = nil},
        {loc = vector3(1693.54, 3758.93, 34.70), npc = vector3(1691.46, 3760.72, 34.70), npcHeading = 234.17, currentNPC = nil},
        {loc = vector3(-330.61, 6082.96, 31.45), npc = vector3(-332.13, 6085.01, 31.45), npcHeading = 221.18, currentNPC = nil},
        {loc = vector3(252.32, -49.07, 69.94), npc = vector3(254.50, -49.81, 69.94), npcHeading = 79.17, currentNPC = nil},
        {loc = vector3(2568.94, 294.81, 108.73), npc = vector3(2568.60, 292.36, 108.73), npcHeading = 8.60, currentNPC = nil},
        {loc = vector3(-1118.20, 2697.40, 18.55), npc = vector3(-1119.82, 2699.58, 18.55), npcHeading = 222.71, currentNPC = nil},
        {loc = vector3(843.22, -1033.38, 28.19), npc = vector3(843.16, -1035.62, 28.19), npcHeading = 5.25, currentNPC = nil},
        
    }
}

pzCore.armory = {}
pzCore.armory.config = Armory_Config