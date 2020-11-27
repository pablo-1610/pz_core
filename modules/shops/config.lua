Shops = {

    possibleHoldupRewards = {1000,2000,3000,4000,5000},

    groups = {
        ["ltd"] = {
            createBlip = function(coords)
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blip, 59)
                SetBlipAsShortRange(blip, true)
                SetBlipColour(blip, 69)
                SetBlipScale(blip, 1.0)
                SetBlipCategory(blip, 12)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Magasin 24/7")
                EndTextCommandSetBlipName(blip)
            end,

            canBeRobbed = true,

            npc = {
                have = true,
                model = "mp_m_shopkeep_01"
            },

            items = {
                [1] = {category = "↓ ~b~Boissons ~s~↓"},
                [2] = {item = "water", label = "Bouteille d'eau", price = 20, maxQty = 20},
                [3] = {item = "soda", label = "Canette de coca", price = 90, maxQty = 20},
                [4] = {item = "icetea", label = "Canette d'ice-tea", price = 90, maxQty = 20},
                [5] = {item = "rhum", label = "Bouteille de rhum", price = 260, maxQty = 20},
                [6] = {item = "mojito", label = "Bouteille de mojito", price = 350, maxQty = 20},
                [7] = {item = "martini", label = "Bouteille de martini", price = 450, maxQty = 20},
                [8] = {category = "↓ ~b~Aliments ~s~↓"},
                [9] = {item = "saucisson", label = "Saucisson sec", price = 25, maxQty = 20},
                [10] = {item = "frites", label = "Barquette de frites fraîches", price = 45, maxQty = 20}
            }
        }
        
    },

    list = {
        [1] = {type = "ltd", loc = vector3(26.85, -1346.81, 29.49), npc = vector3(24.30, -1346.89, 29.49), npcHeading = 269.0, recentlyRobbed = false, currentNPC = nil, state = true},
        [2] = {type = "ltd", loc = vector3(374.77, 326.44, 103.56), npc = vector3(372.66, 327.11, 103.56), npcHeading = 259.0, recentlyRobbed = false, currentNPC = nil, state = true},
        [3] = {type = "ltd", loc = vector3(2556.56, 382.84, 108.62), npc = vector3(2556.70, 380.61, 108.62), npcHeading = 358.30, recentlyRobbed = false, currentNPC = nil, state = true},
        [4] = {type = "ltd", loc = vector3(-3040.09, 586.33, 7.90), npc = vector3(-3039.46, 584.17, 7.90), npcHeading = 17.0, recentlyRobbed = false, currentNPC = nil, state = true},
        [5] = {type = "ltd", loc = vector3(-3242.78, 1002.22, 12.83), npc = vector3(-3242.95, 999.87, 12.83), npcHeading = 351.46, recentlyRobbed = false, currentNPC = nil, state = true},
        [6] = {type = "ltd", loc = vector3(547.15, 2670.44, 42.15), npc = vector3(549.37, 2670.79, 42.15), npcHeading = 99.73, recentlyRobbed = false, currentNPC = nil, state = true},
        [7] = {type = "ltd", loc = vector3(1961.64, 3741.64, 32.34), npc = vector3(1959.68, 3740.35, 32.34), npcHeading = 310.0, recentlyRobbed = false, currentNPC = nil, state = true},
        [8] = {type = "ltd", loc = vector3(2678.62, 3281.56, 55.24), npc = vector3(2677.38, 3279.54, 55.24), npcHeading = 331.0, recentlyRobbed = false, currentNPC = nil, state = true},
        [9] = {type = "ltd", loc = vector3(1730.12, 6414.67, 35.03), npc = vector3(1727.86, 6415.66, 35.03), npcHeading = 246.72, recentlyRobbed = false, currentNPC = nil, state = true},

        [10] = {type = "ltd", loc = vector3(1136.57, -982.00, 46.41), npc = vector3(1133.96, -981.74, 46.41), npcHeading = 280.25, recentlyRobbed = false, currentNPC = nil, state = true},
        [11] = {type = "ltd", loc = vector3(-1223.72, -906.34, 12.32), npc = vector3(-1222.27, -908.85, 12.32), npcHeading = 35.21, recentlyRobbed = false, currentNPC = nil, state = true},
        [12] = {type = "ltd", loc = vector3(-1487.71, -379.96, 40.16), npc = vector3(-1485.87, -377.87, 40.16), npcHeading = 133.73,recentlyRobbed = false, currentNPC = nil, state = true},
        [13] = {type = "ltd", loc = vector3(-2968.72, 390.25, 15.04), npc = vector3(-2966.14, 390.36, 15.04), npcHeading = 83.13,recentlyRobbed = false, currentNPC = nil, state = true},
        [14] = {type = "ltd", loc = vector3(1166.76, 2708.43, 38.15), npc = vector3(1166.44, 2711.02, 38.15), npcHeading = 186.32,recentlyRobbed = false, currentNPC = nil, state = true},
        [15] = {type = "ltd", loc = vector3(1392.79, 3604.02, 34.98), npc = vector3(1392.16, 3606.24, 34.98), npcHeading = 200.0,recentlyRobbed = false, currentNPC = nil, state = true},

        [16] = {type = "ltd", loc = vector3(-48.37, -1756.90, 29.42), npc = vector3(-46.52, -1758.61, 29.42), npcHeading = 48.57,recentlyRobbed = false, currentNPC = nil, state = true},
        [17] = {type = "ltd", loc = vector3(1162.77, -323.43, 69.20), npc = vector3(1165.11, -322.50, 69.20), npcHeading = 102.76,recentlyRobbed = false, currentNPC = nil, state = true},
        [18] = {type = "ltd", loc = vector3(-708.11, -913.71, 19.21), npc = vector3(-705.53, -913.39, 19.21), npcHeading = 88.41,recentlyRobbed = false, currentNPC = nil, state = true},
        [19] = {type = "ltd", loc = vector3(-1821.52, 792.69, 138.12), npc = vector3(-1819.71, 794.33, 138.08), npcHeading = 131.73,recentlyRobbed = false, currentNPC = nil, state = true},
        [20] = {type = "ltd", loc = vector3(1699.34, 4924.60, 42.06), npc = vector3(1698.07, 4922.35, 42.06), npcHeading = 326.17,recentlyRobbed = false, currentNPC = nil, state = true}
    }
}
