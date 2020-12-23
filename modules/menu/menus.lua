dynamicMenu,dynamicMenu2,dynamicMenu3,dynamicMenu4 = false,false,false,false
local codesCooldown = false
local returnedPlayerData = nil
local colorVar = "~o~"
local closestPlayer, closestDistance
local currentTask = {}
local WaitForPrendre = false

Menus = {
    

    menus = {
        {cat = "police_clothes", name = "police_clothes_main", title = "Vestiaires", desc = "Changez votre tenue", pos = vector3(451.42, -992.27, 30.68)},
        {cat = "police_armory", name = "police_armory_main", title = "Armurerie", desc = "Obtenez vos armes de service", pos = vector3(457.59, -992.24, 30.68)},
        {cat = "police_vehicle", name = "police_vehicle_main", title = "Garage", desc = "Sortez le véhicule de votre choix", pos = vector3(456.76, -1024.89, 28.44)},
        {cat = "police_heli", name = "police_heli_main", title = "Héliport", desc = "Sortez l'hélicoptère de votre choix", pos = vector3(455.99, -985.68, 43.69)},
        {cat = "police_jail", name = "police_jail_main", title = "Cellules", desc = "Sélectionnez votre tenue", pos = vector3(464.64, -997.61, 24.91)},

        {cat = "fbi_vehicle", name = "fbi_vehicle_main", title = "Garage", desc = "Sortez le véhicule de votre choix", pos = vector3(59.27, -752.09, 44.22)},
        {cat = "fbi_armory", name = "fbi_armory_main", title = "Armurerie", desc = "Obtenez vos armes de service", pos = vector3(98.59, -737.08, 45.75)},

        {cat = "unicorn_barman", name = "unicorn_barman_main", title = "Bar", desc = "Bar de l'unicorn", pos = vector3(129.96, -1283.35, 29.27)},
        {cat = "unicorn_vehicle", name = "unicorn_vehicle_main", title = "Garage", desc = "Sortez le véhicule de votre choix", pos = vector3(147.68, -1294.79, 29.27)},
        {cat = "unicorn_clothes", name = "unicorn_clothes_main", title = "Vestiaires", desc = "Changez votre tenue", pos = vector3(105.48, -1303.11, 28.76)},
        
        
        {cat = "bahamas_barman", name = "bahamas_barman_main", title = "Bar", desc = "Bar du bahamas", pos = vector3(-1376.67, -629.13, 30.81)},
        {cat = "bahamas_clothes", name = "bahamas_clothes_main", title = "Vestiaires", desc = "Changez votre tenue", pos = vector3(-1384.20, -615.96, 30.81)},
        {cat = "bahamas_vehicle", name = "bahamas_vehicle_main", title = "Garage", desc = "Sortez le véhicule de votre choix", pos = vector3(-1381.01, -581.13, 30.14)},

        {cat = "taxi_vehicle", name = "taxi_vehicle_main", title = "Garage", desc = "Sortez le véhicule de votre choix", pos = vector3(915.57, -173.87, 74.35)},
        {cat = "taxi_clothes", name = "taxi_clothes_main", title = "Vestiaires", desc = "Changez votre tenue", pos = vector3(914.05, -159.04, 74.83)},

        {cat = "taxi_clothes", name = "taxi_clothes_main", title = "Vestiaires", desc = "Changez votre tenue", pos = vector3(914.05, -159.04, 74.83)},

        {cat = "ammo_train", name = "ammo_train_main", title = "Entrainement", desc = "Améliorez vos réflexes", pos = vector3(17.47, -1100.56, 29.79)},
        
        {cat = "vigneron_vehicle", name = "vigneron_vehicle_main", title = "Garage", desc = "Sortez le véhicule de votre choix", pos = vector3(-1896.61, 2052.12, 140.89)},
        {cat = "vigneron_clothes", name = "vigneron_clothes_main", title = "Vestiaires", desc = "Changez votre tenue", pos = vector3(-1901.94, 2063.88, 140.88)},
        
        

        
        
    },


    init = function()
        -- Creating menus
        pzCore.trace("Initializing menu thread")
        
        for _,menu in pairs(Menus.menus) do
            RMenu.Add(menu.cat, menu.name, RageUI.CreateMenu(menu.title,menu.desc))
            RMenu:Get(menu.cat, menu.name).Closed = function()end


            
            
        end
        
        Citizen.CreateThread(function()
            while true do
                if colorVar == "~o~" then
                    colorVar = "~r~" 
                else
                    colorVar = "~o~"

                end
                Citizen.Wait(800)
            end
        end)

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(500)
                local pos = GetEntityCoords(PlayerPedId())
                local needToCloseMenus = true
                for _,menu in pairs(Menus.menus) do 
                    if GetDistanceBetweenCoords(pos, menu.pos, true) < 1.5 then needToCloseMenus = false end
                end

                if needToCloseMenus and not dynamicMenu and not dynamicMenu2 and not dynamicMenu3 and not dynamicMenu4 then 
                    RageUI.CloseAll()
                end
            end
        end)

        Citizen.CreateThread(function()
            while true do
                local menu = false



                RageUI.IsVisible(RMenu:Get("ammo_train",'ammo_train_main'),true,true,true,function()
                    pzCore.armory.drawTraining()
                end, function()    
                end, 1)


                RageUI.IsVisible(RMenu:Get("taxi_vehicle",'taxi_vehicle_main'),true,true,true,function()
                    for k,v in pairs(pzCore.jobs["taxi"].config.vehicles) do
                        RageUI.ButtonWithStyle(v.label,nil, {RightLabel = "~b~Sortir~s~ →→"}, not codesCooldown, function(_,_,s)
                            if s then
                                RageUI.CloseAll()
                                pzCore.jobs["taxi"].spawnCar(PlayerPedId(),v.model)
                            end
                        end)
                    end
                end, function()    
                end, 1)

                

                
                
                RageUI.IsVisible(RMenu:Get("unicorn_dynamicmenu",'unicorn_dynamicmenu_main'),true,true,true,function()
                    menu = true
                    RageUI.ButtonWithStyle("Donner une facture",nil, {RightLabel = "~b~Facturer~s~ →→"}, true, function(_,_,s)
                        if s then
                            local raison = ""
                            local montant = 0
                            AddTextEntry("FMMC_MPM_NA", "Raison de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez une raison de la facture:", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    raison = result
                                    result = nil
                                    AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le montant de la facture:", "", "", "", "", 30)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                    if (GetOnscreenKeyboardResult()) then
                                        result = GetOnscreenKeyboardResult()
                                        if result then
                                            montant = result
                                            result = nil
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_unicorn', raison, tonumber(montant))
                                            pzCore.mug("~r~Tablette Unicorn", "Facture envoyée","Vous avez envoyé une facture à la personne: ~b~\""..raison.."\"~s~: ~r~"..montant.."$")
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end)


                    RageUI.ButtonWithStyle("Unicorn ~g~ouvert",nil, {RightLabel = "~b~Annoncer~s~ →→"}, not codesCooldown, function(_,_,s)
                        if s then
                            codesCooldown = true
                            TriggerServerEvent("pz_core:unicorn_state", true)
                            Citizen.SetTimeout(60000, function() codesCooldown = false end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Unicorn ~r~fermé",nil, {RightLabel = "~b~Annoncer~s~ →→"}, not codesCooldown, function(_,_,s)
                        if s then
                            codesCooldown = true 
                            TriggerServerEvent("pz_core:unicorn_state", false)
                            Citizen.SetTimeout(60000, function() codesCooldown = false end)
                        end
                    end)
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("taxi_dynamicmenu",'taxi_dynamicmenu_main'),true,true,true,function()
                    menu = true
                    RageUI.ButtonWithStyle("Donner une facture",nil, {RightLabel = "~b~Facturer~s~ →→"}, true, function(_,_,s)
                        if s then
                            local raison = ""
                            local montant = 0



                            AddTextEntry("FMMC_MPM_NA", "Raison de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez une raison de la facture:", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    raison = result
                                    result = nil
                                    AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le montant de la facture:", "", "", "", "", 30)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                    if (GetOnscreenKeyboardResult()) then
                                        result = GetOnscreenKeyboardResult()
                                        if result then
                                            montant = result
                                            result = nil
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', raison, tonumber(montant))
                                            pzCore.mug("~r~Tablette Taxi", "Facture envoyée","Vous avez envoyé une facture à la personne: ~b~\""..raison.."\"~s~: ~r~"..montant.."$")
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end)
                end, function()    
                end, 1)  

                RageUI.IsVisible(RMenu:Get("bahamas_dynamicmenu",'bahamas_dynamicmenu_main'),true,true,true,function()
                    menu = true
                    RageUI.ButtonWithStyle("Donner une facture",nil, {RightLabel = "~b~Facturer~s~ →→"}, true, function(_,_,s)
                        if s then
                            local raison = ""
                            local montant = 0



                            AddTextEntry("FMMC_MPM_NA", "Raison de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez une raison de la facture:", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    raison = result
                                    result = nil
                                    AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le montant de la facture:", "", "", "", "", 30)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                    if (GetOnscreenKeyboardResult()) then
                                        result = GetOnscreenKeyboardResult()
                                        if result then
                                            montant = result
                                            result = nil
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_bahamas', raison, tonumber(montant))
                                            pzCore.mug("~r~Tablette Bahamas", "Facture envoyée","Vous avez envoyé une facture à la personne: ~b~\""..raison.."\"~s~: ~r~"..montant.."$")
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end)

                    

                    RageUI.ButtonWithStyle("Bahamas ~g~ouvert",nil, {RightLabel = "~b~Annoncer~s~ →→"}, not codesCooldown, function(_,_,s)
                        if s then
                            codesCooldown = true
                            TriggerServerEvent("pz_core:bahamas_state", true)
                            Citizen.SetTimeout(60000, function() codesCooldown = false end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Bahamas ~r~fermé",nil, {RightLabel = "~b~Annoncer~s~ →→"}, not codesCooldown, function(_,_,s)
                        if s then
                            codesCooldown = true 
                            TriggerServerEvent("pz_core:bahamas_state", false)
                            Citizen.SetTimeout(60000, function() codesCooldown = false end)
                        end
                    end)
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("unicorn_barman",'unicorn_barman_main'),true,true,true,function()
                    RageUI.Separator("↓ ~b~Boissons avec alcool ↓")
                    
                    for k,v in pairs(pzCore.jobs["unicorn"].config.drinks.alcool) do
                        RageUI.ButtonWithStyle(v.label,"~b~Cette boisson est alcoolisé", {RightLabel = "~b~Prendre~s~ →→"}, true, function(_,_,s)
                            if s then
                                TriggerServerEvent("pz_core:giveDrink", v.item)
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~b~Boissons sans alcool ↓")

                    for k,v in pairs(pzCore.jobs["unicorn"].config.drinks.noalcool) do
                        RageUI.ButtonWithStyle(v.label,"~b~Cette boisson ~g~ne contient pas~b~ d'alcool", {RightLabel = "~b~Prendre~s~ →→"}, true, function(_,_,s)
                            if s then
                                RageUI.CloseAll()
                                TriggerServerEvent("pz_core:giveDrink", v.item)
                            end
                        end)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("bahamas_barman",'bahamas_barman_main'),true,true,true,function()
                    RageUI.Separator("↓ ~b~Boissons avec alcool ↓")
                    
                    for k,v in pairs(pzCore.jobs["bahamas"].config.drinks.alcool) do
                        RageUI.ButtonWithStyle(v.label,"~b~Cette boisson est alcoolisé", {RightLabel = "~b~Prendre~s~ →→"}, true, function(_,_,s)
                            if s then
                                TriggerServerEvent("pz_core:giveDrink", v.item)
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~b~Boissons sans alcool ↓")

                    for k,v in pairs(pzCore.jobs["bahamas"].config.drinks.noalcool) do
                        RageUI.ButtonWithStyle(v.label,"~b~Cette boisson ~g~ne contient pas~b~ d'alcool", {RightLabel = "~b~Prendre~s~ →→"}, true, function(_,_,s)
                            if s then
                                RageUI.CloseAll()
                                TriggerServerEvent("pz_core:giveDrink", v.item)
                            end
                        end)
                    end
                end, function()    
                end, 1)
                RageUI.IsVisible(RMenu:Get("unicorn_clothes",'unicorn_clothes_main'),true,true,true,function()

                    RageUI.ButtonWithStyle("Tenue de base",nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    
                    for i = 1,#pzCore.jobs["unicorn"].config.clothes do
                        RageUI.ButtonWithStyle(pzCore.jobs["unicorn"].config.clothes[i].label,nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                            if s then
                                pzCore.jobs["unicorn"].setUniform(PlayerPedId(),i)
                            end
                        end)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("taxi_clothes",'taxi_clothes_main'),true,true,true,function()

                    RageUI.ButtonWithStyle("Tenue de base",nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    
                    for i = 1,#pzCore.jobs["taxi"].config.clothes do
                        RageUI.ButtonWithStyle(pzCore.jobs["taxi"].config.clothes[i].label,nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                            if s then
                                pzCore.jobs["unicorn"].setUniform(PlayerPedId(),i)
                            end
                        end)
                    end
                end, function()    
                end, 1)
                

                RageUI.IsVisible(RMenu:Get("bahamas_clothes",'bahamas_clothes_main'),true,true,true,function()

                    RageUI.ButtonWithStyle("Tenue de base",nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    
                    for i = 1,#pzCore.jobs["bahamas"].config.clothes do
                        RageUI.ButtonWithStyle(pzCore.jobs["bahamas"].config.clothes[i].label,nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                            if s then
                                pzCore.jobs["unicorn"].setUniform(PlayerPedId(),i)
                            end
                        end)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("vigneron_clothes",'vigneron_clothes_main'),true,true,true,function()

                    RageUI.ButtonWithStyle("Tenue de base",nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    
                    for i = 1,#pzCore.jobs["vigne"].config.clothes do
                        RageUI.ButtonWithStyle(pzCore.jobs["vigne"].config.clothes[i].label,nil, {RightLabel = "~b~Changer~s~ →→"}, true, function(_,_,s)
                            if s then
                                pzCore.jobs["unicorn"].setUniform(PlayerPedId(),i)
                            end
                        end)
                    end
                end, function()    
                end, 1)

                

                

                

                RageUI.IsVisible(RMenu:Get("police_clothes",'police_clothes_main'),true,true,true,function()

                    RageUI.Separator("↓ ~b~Tenues de civil~s~ ↓")


                    RageUI.ButtonWithStyle("Tenue de civil","Vous permets d'équiper la tenue de civil", {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)
                   

                    RageUI.Separator("↓ ~o~Tenues de service~s~ ↓")

                    for i = 1,5 do
                        RageUI.ButtonWithStyle("Tenue de "..pzCore.jobs["police"].config[i].label,"Vous permets d'équiper la tenue de "..pzCore.jobs["police"].config[i].label, {RightBadge = RageUI.BadgeStyle.Clothes}, ESX.PlayerData.job.grade_name == pzCore.jobs["police"].config[i].grade, function(_,_,s)
                            if s then
                                pzCore.jobs["police"].setUniform(i,PlayerPedId())
                            end
                        end)
                    end
                    RageUI.Separator("↓ ~o~Autre~s~ ↓")
                    for i = 6,7 do
                        RageUI.ButtonWithStyle(pzCore.jobs["police"].config[i].label,"Vous permets d'équiper un "..pzCore.jobs["police"].config[i].label, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                            if s then
                                pzCore.jobs["police"].setUniform(i,PlayerPedId())
                            end
                        end)
                    end

                    
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_armory",'police_armory_main'),true,true,true,function()
                    RageUI.Separator("↓ ~r~Options~s~ ↓")
                    RageUI.ButtonWithStyle("Ranger toutes mes armes.", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PlaySound(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0);
                            RemoveAllPedWeapons(GetPlayerPed(-1), true)
                            TriggerEvent("esx:showAdvancedNotification", '~g~LSPD', 'Armurerie', '~g~Vos armes ont été rangées.', 'CHAR_CALL911', 'spawn', 8)
                        end
                    end)
                    RageUI.Separator("↓ ~r~Armes disponibles~s~ ↓")
                    for i = 1,#pzCore.jobs["police"].config.weapons do
                        RageUI.ButtonWithStyle("Obtenir un "..pzCore.jobs["police"].config.weapons[i].label,"Vous permets d'équiper un "..pzCore.jobs["police"].config.weapons[i].label, {RightBadge = RageUI.BadgeStyle.Gun}, ESX.PlayerData.job.grade >= pzCore.jobs["police"].config.weapons[i].minGrade, function(_,_,s)
                            if s then
                                pzCore.jobs["police"].getWeapon(pzCore.jobs["police"].config.weapons[i].weapon,PlayerPedId())
                            end
                        end)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("fbi_armory",'fbi_armory_main'),true,true,true,function()
                    RageUI.Separator("↓ ~r~Options~s~ ↓")
                    RageUI.ButtonWithStyle("Ranger toutes mes armes.", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PlaySound(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0);
                            RemoveAllPedWeapons(GetPlayerPed(-1), true)
                            TriggerEvent("esx:showAdvancedNotification", '~g~FBI', 'Armurerie', '~g~Vos armes ont été rangées.', 'CHAR_CALL911', 'spawn', 8)
                        end
                    end)
                    RageUI.Separator("↓ ~r~Armes disponibles~s~ ↓")
                    for i = 1,#pzCore.jobs["fbi"].config.weapons do
                        RageUI.ButtonWithStyle("Obtenir un "..pzCore.jobs["fbi"].config.weapons[i].label,"Vous permets d'équiper un "..pzCore.jobs["fbi"].config.weapons[i].label, {RightBadge = RageUI.BadgeStyle.Gun}, ESX.PlayerData.job.grade >= pzCore.jobs["fbi"].config.weapons[i].minGrade, function(_,_,s)
                            if s then
                                pzCore.jobs["police"].getWeapon(pzCore.jobs["fbi"].config.weapons[i].weapon,PlayerPedId())
                            end
                        end)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_vehicle",'police_vehicle_main'),true,true,true,function()
                    for i = 1,#pzCore.jobs["police"].config.vehicles do
                        RageUI.Separator("↓ ~b~"..pzCore.jobs["police"].config.vehicles[i].label.."~s~ ↓")
                        for k,v in pairs(pzCore.jobs["police"].config.vehicles[i].list) do
                            RageUI.ButtonWithStyle(v.name,"Vous permets de sortir ce véhicule", {RightBadge = RageUI.BadgeStyle.Car}, ESX.PlayerData.job.grade >= v.minGrade, function(_,_,s)
                                if s then
                                    RageUI.CloseAll()
                                    pzCore.jobs["police"].spawnCar(v.model,PlayerPedId())
                                end
                            end)
                        end
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("fbi_vehicle",'fbi_vehicle_main'),true,true,true,function()
                    RageUI.ButtonWithStyle("Sortir une voiture normale", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["fbi"].spawnCar("fbi",PlayerPedId())
                        end
                    end)
                    RageUI.ButtonWithStyle("Sortir un SUV",nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["fbi"].spawnCar("fbi2",PlayerPedId())
                        end
                    end)
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("vigneron_vehicle",'vigneron_vehicle_main'),true,true,true,function()
                    RageUI.ButtonWithStyle("Sortir un 4x4",nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["vigne"].spawnCar("sandking2",PlayerPedId())
                        end
                    end)
                end, function()    
                end, 1)

                

                RageUI.IsVisible(RMenu:Get("unicorn_vehicle",'unicorn_vehicle_main'),true,true,true,function()
                    RageUI.ButtonWithStyle("Sortir une voiture normale", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["unicorn"].spawnCar("sultanrs",PlayerPedId())
                        end
                    end)
                    RageUI.ButtonWithStyle("Sortir un SUV",nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["unicorn"].spawnCar("granger",PlayerPedId())
                        end
                    end)
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("bahamas_vehicle",'bahamas_vehicle_main'),true,true,true,function()
                    RageUI.ButtonWithStyle("Sortir une voiture normale", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["bahamas"].spawnCar("sultanrs",PlayerPedId())
                        end
                    end)
                    RageUI.ButtonWithStyle("Sortir un SUV",nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            pzCore.jobs["bahamas"].spawnCar("granger",PlayerPedId())
                        end
                    end)
                end, function()    
                end, 1)

                

                RageUI.IsVisible(RMenu:Get("police_heli",'police_heli_main'),true,true,true,function()
                    for i = 1,#pzCore.jobs["police"].config.helicopters do
                        RageUI.ButtonWithStyle(pzCore.jobs["police"].config.helicopters[i].name,"Vous permets de sortir cet hélicoptère", {RightBadge = RageUI.BadgeStyle.Heli}, ESX.PlayerData.job.grade >= pzCore.jobs["police"].config.helicopters[i].minGrade, function(_,_,s)
                            if s then
                                RageUI.CloseAll()
                                pzCore.jobs["police"].spawnHeli(pzCore.jobs["police"].config.helicopters[i].model,PlayerPedId())
                            end
                        end)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_jail",'police_jail_main'),true,true,true,function()
                    RageUI.Separator("↓ ~b~Tenues de civil~s~ ↓")
                    RageUI.ButtonWithStyle("Tenue de civil","Vous permets d'équiper la tenue de civil", {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)
                    RageUI.Separator("↓ ~o~Tenues de prisonnier~s~ ↓")
                    RageUI.ButtonWithStyle("Tenue de prisonnier","Vous permets d'équiper la tenue de prisonnier", {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                        if s then
                            pzCore.jobs["police"].setUniformJail(PlayerPedId())
                        end
                    end)
                    
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_main'),true,true,true,function()
                    menu = true

                    RageUI.Separator("↓ ~b~Statut de service ~s~↓")
                    RageUI.Checkbox("Statut de service", nil, inServicePolice, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        inServicePolice = Checked;
                    end, function()
                        inServicePolice = true
                        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                        TriggerServerEvent("pz_core:police:code", 4, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                        pzCore.mug("Statut de service","~b~Dept. de la justice","Statut: ~g~en service~s~.")
                    end, function()
                        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                        TriggerServerEvent("pz_core:police:code", 5, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                        pzCore.mug("Statut de service","~b~Dept. de la justice","Statut: ~r~hors service~s~.")
                        Citizen.SetTimeout(580, function()
                            inServicePolice = false
                        end)
                    end)

                    if inServicePolice then

                    RageUI.Separator("↓ ~o~Interactions ~s~↓")

                        RageUI.ButtonWithStyle("Interactions citoyens", "Vous permets d'accéder aux interactions citoyens", { RightLabel = "→→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen'))
                        RageUI.ButtonWithStyle("Interactions véhicules", "Vous permets d'accéder aux interactions véhicules", { RightLabel = "→→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_veh'))
                        
                        RageUI.Separator("↓ ~g~Communication ~s~↓")

                        RageUI.ButtonWithStyle("Effectuer un code radio", "Vous permets d'effectuer un code radio", { RightLabel = "→→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_codes'))

                        if ESX.PlayerData.job.name == "fbi" then
                            RageUI.ButtonWithStyle("Consulter les avis de recherche", "Vous permets de consulter les avis de recherche", { RightLabel = "→→" }, true, function(_,_,s)
                                if s then
                                    fbiADRData = nil
                                    TriggerServerEvent("pz_core:adrGet")
                                end
                            end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adr'))

                            RageUI.ButtonWithStyle("Lancer un avis de recherche", "Vous permets de lancer un avis de recherche", { RightLabel = "→→" }, true, function()
                            end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adrlaunch'))
                        end
                    end

                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_adr'),true,true,true,function()
                    menu = true
                    if fbiADRData == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~c~Il n'y a aucun avis de recherche actif")
                        RageUI.Separator("")
                    else
                        RageUI.Separator("↓ ~r~Avis de recherche ~s~↓")

                        for index,adr in pairs(fbiADRData) do
                            RageUI.ButtonWithStyle(colorVar.."[NV."..adr.dangerosity.."] ~s~"..adr.firstname.." "..adr.lastname.." • "..adr.date, "~o~Motif~s~: "..adr.reason, { RightLabel = "~b~Consulter ~s~→→" }, true, function(_,_,s)
                                if s then
                                    fbiADRindex = index
                                end
                            end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adrcheck'))
                        end
                        
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_adrlaunch'),true,true,true,function()
                    menu = true
                    RageUI.Separator("↓ ~b~Informations personnelles ~s~↓")

                    RageUI.ButtonWithStyle("Prénom: ~s~"..pzCore.notNil(fbiADRBuilder.firstname), "~r~Motif: ~s~"..pzCore.notNil(fbiADRBuilder.reason), { RightLabel = "~g~Définir ~s~→→" }, true, function(_,_,s)
                        if s then
                            fbiADRBuilder.firstname = pzCore.keyboard("Prénom","Prénom de l'individu:")
                        end
                    end)
                    RageUI.ButtonWithStyle("Nom: ~s~"..pzCore.notNil(fbiADRBuilder.lastname), "~r~Motif: ~s~"..pzCore.notNil(fbiADRBuilder.reason), { RightLabel = "~g~Définir ~s~→→" }, true, function(_,_,s)
                        if s then
                            fbiADRBuilder.lastname = pzCore.keyboard("Nom","Nom de l'individu:")
                        end
                    end)

                    RageUI.Separator("↓ ~b~Informations de l'avis ~s~↓")

                    --RageUI.ButtonWithStyle("~o~Date: ~s~"..os.date("*t", 906000490).day.."/"..os.date("*t", 906000490).month.."/"..os.date("*t", 906000490).year.." à "..os.date("*t", 906000490).hour.."h"..os.date("*t", 906000490).min, "~r~Motif: ~s~"..pzCore.notNil(fbiADRBuilder.reason), {}, true, function() end)

                    

                    RageUI.ButtonWithStyle("Définir le motif", "~r~Motif: ~s~"..pzCore.notNil(fbiADRBuilder.reason), { RightLabel = "~g~Définir ~s~→→" }, true, function(_,_,s)
                        if s then
                            fbiADRBuilder.reason = pzCore.bigKeyboard("Raison","Motif de l'avis de recherche:")
                        end
                    end)

                    RageUI.List("Dangerosité: ~s~", fbiADRDangerosities, fbiADRBuilder.dangerosity, "~r~Motif: ~s~"..pzCore.notNil(fbiADRBuilder.reason), {}, true, function(Hovered, Active, Selected, Index)
        
                        fbiADRBuilder.dangerosity = Index
                        
                    end)

                    RageUI.Separator("↓ ~b~Interactions ~s~↓")

                    RageUI.ButtonWithStyle("~g~Sauvegarder et envoyer", "~r~Motif: ~s~"..pzCore.notNil(fbiADRBuilder.reason), { RightLabel = "~g~Envoyer ~s~→→" }, fbiADRBuilder.firstname ~= nil and fbiADRBuilder.lastname ~= nil and fbiADRBuilder.reason ~= nil, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            TriggerServerEvent("pz_core:adrAdd", fbiADRBuilder)
                            fbiADRBuilder = {dangerosity = 1}
                        end
                    end)

                    


                end, function()    
                end, 1)


                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_adrcheck'),true,true,true,function()
                    menu = true

                    RageUI.Separator("↓ ~b~Informations ~s~↓")
                    RageUI.ButtonWithStyle("~g~Auteur: ~s~"..fbiADRData[fbiADRindex].author, "~r~Motif: ~s~"..fbiADRData[fbiADRindex].reason, {}, true, function()end)
                    RageUI.ButtonWithStyle("~g~Date: ~s~"..fbiADRData[fbiADRindex].date, "~r~Motif: ~s~"..fbiADRData[fbiADRindex].reason, {}, true, function()end)
                    RageUI.ButtonWithStyle("~o~Prénom: ~s~"..fbiADRData[fbiADRindex].firstname, "~r~Motif: ~s~"..fbiADRData[fbiADRindex].reason, {}, true, function()end)
                    RageUI.ButtonWithStyle("~o~Nom: ~s~"..fbiADRData[fbiADRindex].lastname, "~r~Motif: ~s~"..fbiADRData[fbiADRindex].reason, {}, true, function()end)
                    RageUI.ButtonWithStyle("~r~Dangerosité: ~s~"..pzCore.jobs["fbi"].getDangerosity(fbiADRData[fbiADRindex].dangerosity), "~r~Motif: ~s~"..fbiADRData[fbiADRindex].reason, {}, true, function()end)

                    if ESX.PlayerData.job.grade >= 1 then
                        RageUI.Separator("↓ ~o~Opérations ~s~↓")
                        RageUI.ButtonWithStyle("~r~Retirer cet avis de recherche", nil, {RightLabel = "~r~Supprimer ~s~→→"}, true, function(_,_,s)
                            if s then
                                RageUI.CloseAll()
                                TriggerServerEvent("pz_core:adrDel", fbiADRindex)
                            end
                        end)
                    end

                end, function()    
                end, 1)


                

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_carinfos'),true,true,true,function()
                    menu = true
                    if vehicleStats == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~o~En attente des données...")
                        RageUI.Separator("")
                    else
                        local owner = ""
                        if not vehicleStats.owner then owner = "Jean Moldu" else owner = vehicleStats.owner end
                        RageUI.Separator("~o~Plaque: ~s~"..vehicleStats.plate)
                        RageUI.Separator("~o~Propriétaire: ~s~"..owner)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_identity'),true,true,true,function()
                    menu = true
                    if identityStats == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~o~En attente des données...")
                        RageUI.Separator("")
                    else
                        RageUI.Separator("~o~Nom: ~s~"..identityStats.firstname.." "..identityStats.lastname)
                        RageUI.Separator("~o~Sexe: ~s~"..identityStats.sex)
                        RageUI.Separator("")
                        RageUI.Separator("~g~Liquide: ~s~"..identityStats.money.."$")
                        RageUI.Separator("")
                        RageUI.Separator("~b~Emploi: ~s~"..identityStats.job.." - "..identityStats.grade)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_bs'),true,true,true,function()
                    menu = true
                    local data = identityStats
                    local display = {
                    }
                    if identityStats == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~o~En attente des données...")
                        RageUI.Separator("")
                    else
                        if #data.accounts > 0 then
                            RageUI.Separator("↓ ~g~Argent ~s~↓")
                            for i=1, #data.accounts, 1 do
                                if data.accounts[i].name == "bank" then
                                    RageUI.ButtonWithStyle("Banque: ~b~"..ESX.Math.Round(data.accounts[i].money).."$", nil, {}, true, function(_,_,_)
                                    end)
                                end
                                if data.accounts[i].name == "money" then 
                                    RageUI.ButtonWithStyle("Liquide: ~g~"..ESX.Math.Round(data.accounts[i].money).."$ ~s~(~r~+ "..data.accounts[1].money.."$~s~)", nil, {}, true, function(_,_,_)
                                    end)
                                end

                                if data.accounts[i].name == "black_money" then 
                                    RageUI.ButtonWithStyle("Argent Sale: ~g~"..ESX.Math.Round(data.accounts[i].money).."$ ~s~(~r~+ "..data.accounts[1].money.."$~s~)", nil, {}, true, function(_,_,s)
                                        if s then
                                            TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(closestPlayer), "item_account", "black_money", data.accounts[1].money)
                                            ESX.SetTimeout(300, function()
                                                RageUI.CloseAll()
                                                identityStats = nil
                                                Wait(500)
                                                RageUI.Visible(RMenu:Get("police_dynamicmenu","police_dynamicmenu_bs"), true)
                                            end)
                                        end
                                    end)
                                end
                            end
                        end
                        if #data.weapons > 0 then
                            RageUI.Separator("↓ ~r~Armes ~s~↓")
                            if WaitForPrendre then RageUI.Separator("~r~Transaction au serveur en cours...") end
                            for i=1, #data.weapons, 1 do
                                RageUI.ButtonWithStyle(colorVar.."[/!\\] ~s~"..pzCore.getWeaponName(data.weapons[i].name), nil, {RightLabel = "~r~Confisquer ~s~→→"}, WaitForPrendre ~= true, function(_,_,s)
                                    if s then
                                        WaitForPrendre = true
                                        TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(closestPlayer), "item_weapon", data.weapons[i].name, data.weapons[i].ammo)
                                    end
                                end)
                                RageUI.ButtonWithStyle("→ Munitions: ~r~x"..data.weapons[i].ammo, nil, {}, true, function(_,_,_)
                                end)
                            end
                        end
                        if #data.inventory > 0 then
                            RageUI.Separator("↓ ~o~Objets ~s~↓")
                            if WaitForPrendre then RageUI.Separator("~r~Transaction au serveur en cours...") end
                            for i=1, #data.inventory, 1 do
                                if data.inventory[i].count > 0 then
                                    RageUI.ButtonWithStyle(data.inventory[i].label.." (~b~x"..data.inventory[i].count.."~s~)", nil, {RightLabel = "~r~Confisquer ~s~→→"}, WaitForPrendre ~= true, function(_,_,s)
                                        if s then
                                            WaitForPrendre = true
                                            TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(closestPlayer), "item_standard", data.inventory[i].name, data.inventory[i].count)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end, function()    
                end, 1)

                
                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_licence'),true,true,true,function()
                    menu = true
                    local data = identityStats
                    if identityStats == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~o~En attente des données...")
                        RageUI.Separator("")
                    else
                        if data.licenses ~= nil then
                            RageUI.Separator("↓ ~o~Licence ~s~↓")
                            if data.licenses ~= nil then
                                for i = 1, #data.licenses, 1 do
                                    if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
                                        RageUI.ButtonWithStyle(data.licenses[i].label ,nil, {RightLabel = "~r~Revoqué ~s~→→"}, true, function(_,_,s)
                                            if s then
                                                TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.licenses[i].type)


                                                ESX.SetTimeout(300, function()
                                                    RageUI.CloseAll()
                                                    identityStats = nil
                                                    Wait(500)
                                                    RageUI.Visible(RMenu:Get("police_dynamicmenu","police_dynamicmenu_citizen"), true)
                                                end)
                                            end
                                        end)
                                    end
                                end
                            else
                                RageUI.Separator("")
                                RageUI.Separator("~o~La personne n'as pas de licence...")
                                RageUI.Separator("")
                            end
                        end
                    end
                end, function()    
                end, 1)         

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_citizen'),true,true,true,function()
                    menu = true
                    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    --closestPlayer = playerTarget

                    RageUI.ButtonWithStyle("Prendre la carte d'identité", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            identityStats = nil
                            local player = GetPlayerServerId(closestPlayer)
                            getInformations(player)
                        end
                    end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_identity'))
                    RageUI.ButtonWithStyle("Fouiller l'individu", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            identityStats = nil
                            local player = GetPlayerServerId(closestPlayer)
                            getInformations(player)
                        end
                    end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_bs'))
                    RageUI.ButtonWithStyle("Gérer les licences", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            identityStats = nil
                            local player = GetPlayerServerId(closestPlayer)
                            getInformations(player)
                        end
                    end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_licence'))
                    RageUI.ButtonWithStyle("Menotter/Démenotter", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Escoter/Arrêter l'escorte", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Mettre dans le véhicule", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Mettre hors du véhicule", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Amendes", nil, { RightLabel = "→→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            local raison = ""
                            local montant = 0



                            AddTextEntry("FMMC_MPM_NA", "Raison de l'amende")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez une raison de l'amende:", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    raison = result
                                    result = nil
                                    AddTextEntry("FMMC_MPM_NA", "Montant de l'amende")
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le montant de l'amende:", "", "", "", "", 30)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                    if (GetOnscreenKeyboardResult()) then
                                        result = GetOnscreenKeyboardResult()
                                        if result then
                                            montant = result
                                            result = nil
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_police', raison, tonumber(montant))
                                            pzCore.mug("~r~Tablette de police", "Amende envoyée","Vous avez envoyé une amende à cette personne: ~b~\""..raison.."\"~s~: ~r~"..montant.."$")
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end)
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_veh'),true,true,true,function()
                    menu = true
                    local coords  = GetEntityCoords(PlayerPedId())
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    RageUI.ButtonWithStyle("Informations du véhicule", nil, { RightLabel = "→→" }, DoesEntityExist(vehicle), function(_,_,s)
                        if s then
                            vehicleStats = nil
                            local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                            pzCore.jobs["police"].getVehicleInfos(vehicleData)
                        end
                    end,RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_carinfos'))

                    RageUI.ButtonWithStyle("Crocheter le véhicule", nil, { RightLabel = "→→" }, DoesEntityExist(vehicle), function(_,_,s)
                        if s then
                            if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                                TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
                                Citizen.Wait(20000)
                                ClearPedTasksImmediately(PlayerPedId())
    
                                SetVehicleDoorsLocked(vehicle, 1)
                                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                ESX.ShowNotification("~o~Véhicule dévérouillé!")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre en fourrière", nil, { RightLabel = "→→" }, DoesEntityExist(vehicle), function(_,_,s)
                        if s then
                            if currentTask.busy then
                                return
                            end

                            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    
                            currentTask.busy = true
                            currentTask.task = ESX.SetTimeout(10000, function()
                                ClearPedTasks(playerPed)
                                ESX.Game.DeleteVehicle(vehicle)
                                ESX.ShowNotification("~o~Mise en fourrière effectuée")
                                currentTask.busy = false
                                Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
                            end)
    
                            -- keep track of that vehicle!
                            Citizen.CreateThread(function()
                                while currentTask.busy do
                                    Citizen.Wait(1000)
    
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                    if not DoesEntityExist(vehicle) and currentTask.busy then
                                        ESX.ShowNotification("~r~Le véhicule a bougé!")
                                        ESX.ClearTimeout(currentTask.task)
                                        ClearPedTasks(playerPed)
                                        currentTask.busy = false
                                        break
                                    end
                                end
                            end)
                        end
                    end)
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_codes'),true,true,true,function()
                    menu = true
                    
                    RageUI.Separator("↓ ~r~Demandes de renfort ~s~↓")

                    RageUI.ButtonWithStyle("~g~Urgence légère", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 11, 3,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~o~Urgence moyenne", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 12, 3,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~Urgence maximale", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 13, 3,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)

        
            
                    RageUI.Separator("↓ ~o~Codes d'interventions  ~s~↓")

                    RageUI.ButtonWithStyle("~r~10-13~s~: Officier blessé", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 7, 2,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-14~s~: Prise d'otage", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 8, 2,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-31~s~: Course poursuite", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 9, 2,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-32~s~: Individu armé", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 10, 2,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)

                    RageUI.Separator("↓ ~g~Codes informatifs ~s~↓")

                    RageUI.ButtonWithStyle("~r~10-4~s~: Affirmatif/Reçu", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 1, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-5~s~: Négatif", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 2, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-6~s~: Pause de service", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 3, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-8~s~: Prise de service", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 4, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-10~s~: Fin de service", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 5, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~10-19~s~: Retour au poste", nil, { RightLabel = "→→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("pz_core:police:code", 6, 1,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            codesCooldown = true
                            Citizen.SetTimeout(1500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                            
                    



                end, function()    
                end, 1)

                dynamicMenu = menu

                

                Citizen.Wait(0)
            end
        end)
    end
}

pzCore.menus = Menus

RegisterNetEvent("TransacServer")
AddEventHandler("TransacServer", function()
    Citizen.Wait(2000)
    waitingForCb = false
end)
