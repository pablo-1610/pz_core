Pz_admin = {
    
    utils = {
        keyboard = function(title,mess)
            AddTextEntry("FMMC_MPM_NA", title)
            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", mess, "", "", "", "", 30)
            while (UpdateOnscreenKeyboard() == 0) do
                DisableAllControlActions(0)
                Wait(0)
            end
            if (GetOnscreenKeyboardResult()) then
                local result = GetOnscreenKeyboardResult()
                if result then
                    return result
                end
            end
        end
    },

    functions = {

        [1] = {
            cat = "player",
            sep = "↓ ~b~Téleportations ~s~↓",
            toSub = false,
            label = "Téléportation sur le joueur",
            press = function(selectedPlayer)
                local ped = GetPlayerPed(selectedPlayer.c)
                local pos = GetEntityCoords(ped)
                SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
            end
        },

        [2] = {
            cat = "player",
            sep = nil,
            toSub = false,
            label = "Téleportation sur moi",
            press = function(selectedPlayer)
                local pos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("pz_admin:bring", selectedPlayer.s, pos)
            end
        },

        [3] = {
            cat = "player",
            sep =  "↓ ~o~Actions diverses ~s~↓",
            toSub = false,
            label = "Réanimer le joueur",
            press = function(selectedPlayer)
                TriggerServerEvent("pz_admin:revive", selectedPlayer.s)
            end
        },


        [4] = {
            cat = "player",
            sep = nil,
            toSub = false,
            label = "Envoyer un message",
            press = function(selectedPlayer)
                local message = Pz_admin.utils.keyboard("Message","Entrez un message:")
                TriggerServerEvent("pz_admin:message", selectedPlayer.s, message)
            end
        },

        [5] = {
            cat = "player",
            sep = nil,
            toSub = false,
            label = "Rembourser le joueur",
            press = function(selectedPlayer)
                TriggerEvent("pz_admin:remb", selectedPlayer.s)
            end
        },

        [6] = {
            cat = "player",
            sep =  "↓ ~r~Sanctions ~s~↓",
            toSub = false,
            label = "Expulser le joueur",
            press = function(selectedPlayer)
                local message = Pz_admin.utils.keyboard("Raison","Entrez une raison:")
                if message ~= nil then
                    TriggerServerEvent("pz_admin:kick", selectedPlayer.s, message)
                    ESX.ShowNotification("~g~Kick effectué!")
                end
            end
        },

        [7] = {
            cat = "player",
            sep = nil,
            toSub = false,
            label = "Bannir le joueur",
            press = function(selectedPlayer)
                local reason = Pz_admin.utils.keyboard("Raison", "Entrez une raison")
                if reason ~= nil then 
                    local time = Pz_admin.utils.keyboard("Durée", "Entrez une durée")
                    if time ~= nil then TriggerServerEvent("pz_admin:ban", PlayerId(),selectedPlayer.s, reason, time) end
                end
            end
        },

        -- Partie moi même

        [8] = {
            cat = "self",
            sep = nil,
            toSub = true,
            label = "Paramètres",
            press = function()
                TriggerEvent("pz_admin:options")
            end
        },

        [9] = {
            cat = "self",
            sep = nil,
            toSub = false,
            label = "Se réanimer",
            press = function()
                TriggerServerEvent("pz_admin:revive", GetPlayerServerId(PlayerId()))
            end
        },

        [10] = {
            cat = "self",
            sep = nil,
            toSub = false,
            label = "Téleportation markeur",
            press = function()
                local playerPed = PlayerPedId()
                local WaypointHandle = GetFirstBlipInfoId(8)
                if DoesBlipExist(WaypointHandle) then
                    local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
                    SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.9, false, false, false, true)
                end
            end
        },

        [11] = {
            cat = "self",
            sep = nil,
            toSub = false,
            label = "Print les coordonnées",
            press = function()
                local pos = GetEntityCoords(PlayerPedId())
                pzCore.trace(pos.x..", "..pos.y..", "..pos.z)
            end
        },
        
        [12] = {
            cat = "veh",
            sep = nil,
            toSub = false,
            label = "Faire apparaître un vehicule",
            press = function()
                local model = Pz_admin.utils.keyboard("Modèle","Entrez un modèle:")
                if model ~= nil then
                    model = GetHashKey(model)
                    if IsModelValid(model) then
                        RequestModel(model)
                        local co = GetEntityCoords(PlayerPedId())
                        while not HasModelLoaded(model) do Citizen.Wait(10) end

                        local veh = CreateVehicle(model, co.x, co.y, co.z, GetEntityHeading(PlayerPedId()), true, false)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    end
                end
            end
        },

        [13] = {
            cat = "veh",
            sep = nil,
            toSub = false,
            label = "Réparer le véhicule proche",
            press = function(closestVeh)
                if closestVeh ~= nil then 
                    SetVehicleEngineHealth(closestVeh, 1000)
                    SetVehicleEngineOn(closestVeh, true, true)
                    SetVehicleFixed(closestVeh)
                end
            end
        },

        [14] = {
            cat = "veh",
            sep = nil,
            toSub = false,
            label = "Supprimer le véhicule proche",
            press = function(closestVeh)
                if closestVeh ~= nil then DeleteEntity(closestVeh) end
            end
        }
    },

    ranks = {
        [2] = {
            label = "Admin", 
            color = "~r~",
            outfit = 4,
            permissions = {
                1,2,3,4,5,6,7,8, -- Interactions civiles
                
                9,10,11, -- Interactions sur soit mêmee

                12,13,14 -- Interactions avec un véhicule
            },
        },

        [1] = {
            label = "Modérateur", 
            color = "~o~",
            outfit = 2,
            permissions = {
                1
            },
        }
    },

    staffList ={
        ["LICENSE ROCKSTAR COMME CI DESSOUS"] = 2, 
        ["license:d67dec9ddd7c3d7f4e4740f675224b06eb5a2d008"] = 2 
    }
}