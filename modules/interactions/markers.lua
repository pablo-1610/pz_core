

Markers = {
    public = {"police_jail","ammo_train"},
    threadActive = false,
    subscribed = {},
    init = function()
        Citizen.CreateThread(function()
            pzCore.trace("Creating markers thread")
            Markers.threadActive = true 
            while true do
                local itv = 250
                local p = GetEntityCoords(PlayerPedId())
                for id,m in pairs(Markers.subscribed) do
                    local dist = GetDistanceBetweenCoords(p, m.position, true)
                    if dist < m.drawDist then 
                        itv = 1 
                        DrawMarker(22, m.position.x, m.position.y, m.position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, m.color.r, m.color.g, m.color.b, 255, 55555, false, true, 2, false, false, false, false)
                        if dist < m.itrDist then
                            if m.condition == nil then
                                pzCore.utils.help(m.help)
                                if IsControlJustPressed(1, 51) then m.interact() end
                            else
                                if m.condition == "vehicle" then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        pzCore.utils.help(m.help)
                                        if IsControlJustPressed(1, 51) then m.interact() end
                                    end
                                elseif m.condition == "boss" then
                                    if ESX.PlayerData.job.grade_label == "boss" then
                                        pzCore.utils.help(m.help)
                                        if IsControlJustPressed(1, 51) then m.interact() end
                                    end
                                end
                            end
                        end
                    end
                end
                Citizen.Wait(itv)
            end
        end)
    end,

    registerPublicBlips = function()
        for k,v in pairs(Markers.public) do Markers.subscribe(v)end
    end,

    add = function(id,data)
        Markers.list[id] = {
            position = data.position,
            drawDist = data.drawDist,
            itrDist = data.itrDist,
            color = data.color,
            condition = data.condition,
            help = data.help,
            interact = data.interact
        }
        
        pzCore.trace("Adding marker ID:"..id)


    end,

    delete = function(id)
        Markers.list[id] = nil
    end,

    subscribe = function(id)
        Markers.subscribed[id] = Markers.list[id]
        pzCore.trace("Subscribed to marker \""..id.."\"")
    end,

    unsubscribe = function(id)
        Markers.subscribed[id] = nil
        pzCore.trace("Unsubscribed from marker \""..id.."\"")
    end,
    
    list = {
        ["police_clothes"] = {
            position = vector3(451.42, -992.27, 30.68),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder aux vestiaires",
            interact = function()
                RageUI.Visible(RMenu:Get("police_clothes",'police_clothes_main'), not RageUI.Visible(RMenu:Get("police_clothes",'police_clothes_main')))
            end,
        },

        ["police_armory"] = {
            position = vector3(457.59, -992.24, 30.68),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'armurerie",
            interact = function()
                RageUI.Visible(RMenu:Get("police_armory",'police_armory_main'), not RageUI.Visible(RMenu:Get("police_armory",'police_armory_main')))
            end,
        },

        ["police_vehicle"] = {
            position = vector3(456.76, -1024.89, 28.44),
            drawDist = 45,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage",
            interact = function()
                RageUI.Visible(RMenu:Get("police_vehicle",'police_vehicle_main'), not RageUI.Visible(RMenu:Get("police_vehicle",'police_vehicle_main')))
            end,
        },

        ["police_vehicleClear"] = {
            position = vector3(456.31, -1017.32, 28.39),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 255, g = 0, b = 0},
            condition = "vehicle",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule",
            interact = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= nil then DeleteEntity(veh) end
            end,
        },

        ["police_helicopter"] = {
            position = vector3(455.99, -985.68, 43.69),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour sortir un hélicoptère",
            interact = function()
                RageUI.Visible(RMenu:Get("police_heli",'police_heli_main'), not RageUI.Visible(RMenu:Get("police_heli",'police_heli_main')))
            end,
        },

        ["police_jail"] = {
            position = vector3(464.64, -997.61, 24.91),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour vous changer",
            interact = function()
                RageUI.Visible(RMenu:Get("police_jail",'police_jail_main'), not RageUI.Visible(RMenu:Get("police_jail",'police_jail_main')))
            end,
        },

        ["police_boss"] = {
            position = vector3(451.108, -974.99, 30.68),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = "boss",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour gérer la société",
            interact = function()
                TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
                    menu.close()
                end, { wash = false })
            end,
        },


        ["police_inventory"] = {
            position = vector3(441.91, -991.39, 30.68),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'inventaire",
            interact = function()
                TriggerServerEvent("pz_core:openEntrepriseInventory", "police", GetEntityCoords(PlayerPedId()))
            end,
        },

        -- FBI

        ["fbi_vehicleClear"] = {
            position = vector3(61.85, -727.55, 44.179),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 255, g = 0, b = 0},
            condition = "vehicle",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule",
            interact = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= nil then DeleteEntity(veh) end
            end,
        },

        ["fbi_vehicle"] = {
            position = vector3(59.27, -752.09, 44.22),
            drawDist = 45,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage",
            interact = function()
                RageUI.Visible(RMenu:Get("fbi_vehicle",'fbi_vehicle_main'), not RageUI.Visible(RMenu:Get("fbi_vehicle",'fbi_vehicle_main')))
            end,
        },

        ["fbi_armory"] = {
            position = vector3(98.59, -737.08, 45.75),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'armurerie",
            interact = function()
                RageUI.Visible(RMenu:Get("fbi_armory",'fbi_armory_main'), not RageUI.Visible(RMenu:Get("fbi_armory",'fbi_armory_main')))
            end,
        },

        ["fbi_boss"] = {
            position = vector3(97.47, -750.01, 45.75),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = "boss",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour gérer la société",
            interact = function()
                TriggerEvent('esx_society:openBossMenu', 'fbi', function(data, menu)
                    menu.close()
                end, { wash = false })
            end,
        },

        ["fbi_inventory"] = {
            position = vector3(147.56, -769.16, 242.15),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'inventaire",
            interact = function()
                TriggerServerEvent("pz_core:openEntrepriseInventory", "fbi", GetEntityCoords(PlayerPedId()))
            end,
        },


        -- Unicorn

        ["unicorn_barman"] = {
            position = vector3(129.96, -1283.35, 29.27),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au bar",
            interact = function()
                RageUI.Visible(RMenu:Get("unicorn_barman",'unicorn_barman_main'), not RageUI.Visible(RMenu:Get("unicorn_barman",'unicorn_barman_main')))
                
            end,
        },

        ["unicorn_boss"] = {
            position = vector3(107.59, -1304.84, 28.7),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = "boss",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la gestion de l'Unicorn",
            interact = function()
                TriggerEvent('esx_society:openBossMenu', 'unicorn', function(data, menu)
                    menu.close()
                end, { wash = false })
            end,
        },

        ["unicorn_bar_entry"] = {
            position = vector3(132.72, -1293.87, 29.26),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 0, g = 255, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour être téléporté au bar",
            interact = function()
                SetEntityCoords(PlayerPedId(), 132.22, -1287.09, 29.27, false,false,false,false)
            end,
        },

        ["unicorn_bar_exit"] = {
            position = vector3(132.22, -1287.09, 29.27),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour être téléporté à l'entrée du bar",
            interact = function()
                SetEntityCoords(PlayerPedId(), 132.72, -1293.87, 29.26, false,false,false,false)
            end,
        },

        ["unicorn_garage"] = {
            position = vector3(147.68, -1294.79, 29.27),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage",
            interact = function()
                RageUI.Visible(RMenu:Get("unicorn_vehicle",'unicorn_vehicle_main'), not RageUI.Visible(RMenu:Get("unicorn_vehicle",'unicorn_vehicle_main')))
            end,
        },

        ["unicorn_vehicleClear"] = {
            position = vector3(145.25, -1313.73, 28.93),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 221, g = 74, b = 237},
            condition = "vehicle",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule",
            interact = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= nil then DeleteEntity(veh) end
            end,
        },

        ["unicorn_clothes"] = {
            position = vector3(105.48, -1303.11, 28.76),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder aux vestiaires",
            interact = function()
                RageUI.Visible(RMenu:Get("unicorn_clothes",'unicorn_clothes_main'), not RageUI.Visible(RMenu:Get("unicorn_clothes",'unicorn_clothes_main')))
                
            end,
        },

        ["unicorn_inventory"] = {
            position = vector3(92.66, -1291.70, 29.23),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'inventaire",
            interact = function()
                TriggerServerEvent("pz_core:openEntrepriseInventory", "unicorn", GetEntityCoords(PlayerPedId()))
            end,
        },


        -- Bahamas

        ["bahamas_bar_exit"] = {
            position = vector3(-1372.04, -626.20, 30.81),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour être téléporté à l'entrée du bar",
            interact = function()
                SetEntityCoords(PlayerPedId(), -1374.51, -623.53, 30.81, false,false,false,false)
            end,
        },

        ["bahamas_bar_entry"] = {
            position = vector3(-1374.51, -623.53, 30.81),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 0, g = 255, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour être téléporté au bar",
            interact = function()
                SetEntityCoords(PlayerPedId(), -1372.04, -626.20, 30.81, false,false,false,false)
            end,
        },

        ["bahamas_barman"] = {
            position = vector3(-1376.67, -629.13, 30.81),
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au bar",
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            interact = function()
                RageUI.Visible(RMenu:Get("bahamas_barman",'bahamas_barman_main'), not RageUI.Visible(RMenu:Get("bahamas_barman",'bahamas_barman_main')))
            end,
        },

        ["bahamas_boss"] = {
            position = vector3(-1382.12, -632.47, 30.81),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = "boss",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la gestion du Bahamas",
            interact = function()
                TriggerEvent('esx_society:openBossMenu', 'bahamas', function(data, menu)
                    menu.close()
                end, { wash = false })
            end,
        },

        ["bahamas_clothes"] = {
            position = vector3(-1384.20, -615.96, 30.81),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder aux vestiaires",
            interact = function()
                RageUI.Visible(RMenu:Get("bahamas_clothes",'bahamas_clothes_main'), not RageUI.Visible(RMenu:Get("bahamas_clothes",'bahamas_clothes_main')))
                
            end,
        },

        ["bahamas_garage"] = {
            position = vector3(-1381.01, -581.13, 30.14),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage",
            interact = function()
                RageUI.Visible(RMenu:Get("bahamas_vehicle",'bahamas_vehicle_main'), not RageUI.Visible(RMenu:Get("bahamas_vehicle",'bahamas_vehicle_main')))
            end,
        },

        ["bahamas_vehicleClear"] = {
            position = vector3(-1394.55, -581.97, 30.18),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 221, g = 74, b = 237},
            condition = "vehicle",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule",
            interact = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= nil then DeleteEntity(veh) end
            end,
        },

        ["bahamas_inventory"] = {
            position = vector3(-1386.31, -627.32, 30.81),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'inventaire",
            interact = function()
                TriggerServerEvent("pz_core:openEntrepriseInventory", "bahamas", GetEntityCoords(PlayerPedId()))
            end,
        },

        -- Taxi

        ["taxi_vehicleClear"] = {
            position = vector3(899.23, -180.61, 73.83),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 255, g = 0, b = 0},
            condition = "vehicle",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule",
            interact = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= nil then DeleteEntity(veh) end
            end,
        },

        ["taxi_garage"] = {
            position = vector3(915.57, -173.87, 74.35),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 0, g = 255, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule",
            interact = function()
                RageUI.Visible(RMenu:Get("taxi_vehicle",'taxi_vehicle_main'), not RageUI.Visible(RMenu:Get("taxi_vehicle",'taxi_vehicle_main')))
            end,
        },

        ["taxi_boss"] = {
            position = vector3(904.30, -173.59, 74.07),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 216, b = 41},
            condition = "boss",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la gestion du Taxi",
            interact = function()
                TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
                    menu.close()
                end, { wash = false })
            end,
        },

        ["taxi_clothes"] = {
            position = vector3(914.05, -159.04, 74.83),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 216, b = 41},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder aux vestiaires",
            interact = function()
                RageUI.Visible(RMenu:Get("taxi_clothes",'taxi_clothes_main'), not RageUI.Visible(RMenu:Get("taxi_clothes",'taxi_clothes_main')))
            end,
        },

        ["taxi_inventory"] = {
            position = vector3(894.95, -179.25, 74.70),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'inventaire",
            interact = function()
                TriggerServerEvent("pz_core:openEntrepriseInventory", "taxi", GetEntityCoords(PlayerPedId()))
            end,
        },

        -- Ammunation

        ["ammo_train"] = {
            position = vector3(17.47, -1100.56, 29.79),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 216, b = 41},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'entraînement",
            interact = function()
                RageUI.Visible(RMenu:Get("ammo_train",'ammo_train_main'), not RageUI.Visible(RMenu:Get("ammo_train",'ammo_train_main')))
            end,
        },

        -- Vigneron

        ["vigneron_vehicle"] = {
            position = vector3( -1896.61, 2052.12, 140.89),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage",
            interact = function()
                RageUI.Visible(RMenu:Get("vigneron_vehicle",'vigneron_vehicle_main'), not RageUI.Visible(RMenu:Get("vigneron_vehicle",'vigneron_vehicle_main')))
            end,
        },


        ["vigneron_vehicleClear"] = {
            position = vector3(-1891.27, 2045.61, 140.86),
            drawDist = 45,
            itrDist = 2.5,
            color = {r = 221, g = 74, b = 237},
            condition = "vehicle",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule",
            interact = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= nil then DeleteEntity(veh) end
            end,
        },

        ["vigneron_boss"] = {
            position = vector3(-1911.88, 2072.30, 140.38),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = "boss",
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la gestion du Taxi",
            interact = function()
                TriggerEvent('esx_society:openBossMenu', 'vigne', function(data, menu)
                    menu.close()
                end, { wash = false })
            end,
        },

        ["vigneron_clothes"] = {
            position = vector3(-1901.94, 2063.88, 140.88),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder aux vestiaires",
            interact = function()
                RageUI.Visible(RMenu:Get("vigneron_clothes",'vigneron_clothes_main'), not RageUI.Visible(RMenu:Get("vigneron_clothes",'vigneron_clothes_main')))
            end,
        },

        ["vigneron_inventory"] = {
            position = vector3(-1928.64, 2060.81, 140.83),
            drawDist = 20,
            itrDist = 1.5,
            color = {r = 221, g = 74, b = 237},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'inventaire",
            interact = function()
                TriggerServerEvent("pz_core:openEntrepriseInventory", "vigne", GetEntityCoords(PlayerPedId()))
            end,
        }

        



       


        
    },
}

pzCore.markers = Markers