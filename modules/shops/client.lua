local npcToCreate = {}
local ShopOpen = false

local function onGround(x,y,z) 
    local _,groundZ,_ = GetGroundZAndNormalFor_3dCoord(x,y,z)
    return vector3(x,y,groundZ)
end

local function initializeNPCLoop()
    Citizen.CreateThread(function()
        while true do
            local p = GetEntityCoords(PlayerPedId())
            for k,v in pairs(pzCore.shops.config.list) do
                local pos = v.loc
                local dist = GetDistanceBetweenCoords(p, pos, 1)
                local npc = pzCore.shops.config.groups[v.type].npc.model
                if v.currentNPC == nil and dist < 60 then
                    local hash = GetHashKey(npc)
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do Citizen.Wait(1) end
                    local npcPos = v.npc
                    v.currentNPC = CreatePed(9, hash, v.npc.x, v.npc.y, v.npc.z, v.npcHeading, false, false)
                    SetEntityAsMissionEntity(v.currentNPC, false, false)
                    SetBlockingOfNonTemporaryEvents(v.currentNPC, true)
                    SetEntityInvincible(v.currentNPC, true)
                    Citizen.SetTimeout(2500, function()
                        FreezeEntityPosition(v.currentNPC, true)
                        TaskStartScenarioInPlace(v.currentNPC, "WORLD_HUMAN_CLIPBOARD", 0, true)
                    end)
                end
            end
            Citizen.Wait(100)
        end
    end)
end

local function deleteMenus()
    RMenu:Delete("pz_core_ltd", "pz_core_ltd_main")
    RMenu:Delete("pz_core_ltd", "pz_core_ltd_item")
    RageUI.CloseAll()
end

local function robb(id)
    if pzCore.shops.config.list[id].currentNPC ~= nil then 
        pzCore.shops.config.list[id].state = false
        Citizen.SetTimeout(60000*15, function() pzCore.shops.config.list[id].state = true end)
        deleteMenus()
        FreezeEntityPosition(PlayerPedId(),true)
        TaskAimGunAtEntity(PlayerPedId(), pzCore.shops.config.list[id].currentNPC, -1, false)
        SetGameplayEntityHint(pzCore.shops.config.list[id].currentNPC, 0.0, 0.0, 0.0, true, 3000, 1000, 1000, 0)
        DisableControlAction(0, 1, true)
        Citizen.SetTimeout(3000, function() 
            ClearPedTasks(PlayerPedId()) 
            FreezeEntityPosition(PlayerPedId(),false)
            EnableControlAction(0, 1, false)
        end)
        Citizen.SetTimeout(3500, function()
            if math.random(1,3) == 1 then
                PlayAmbientSpeech1(pzCore.shops.config.list[id].currentNPC, "GENERIC_INSULT_HIGH_RANDOM", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                TaskStartScenarioInPlace(pzCore.shops.config.list[id].currentNPC, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
                Citizen.SetTimeout(2500, function()
                    ClearPedTasksImmediately(pzCore.shops.config.list[id].currentNPC)
                    SetEntityInvincible(pzCore.shops.config.list[id].currentNPC, false)
                    FreezeEntityPosition(pzCore.shops.config.list[id].currentNPC, false)
                    GiveWeaponToPed(pzCore.shops.config.list[id].currentNPC, GetHashKey("WEAPON_PISTOL50"), 10000, false, true)
                    TaskCombatPed(pzCore.shops.config.list[id].currentNPC, PlayerPedId(), 0, 16)
                    Citizen.CreateThread(function()
                        local blip = AddBlipForEntity(pzCore.shops.config.list[id].currentNPC)
                        SetBlipAsShortRange(blip, false)
                        SetBlipColour(blip, 1)
                        while GetEntityHealth(pzCore.shops.config.list[id].currentNPC) > 0 and GetEntityHealth(PlayerPedId()) > 0 do 
                            RageUI.Text({message = "Neutraliez ~r~le vendeur~s~ pour récuperer le butin",time_display = 1})
                            Citizen.Wait(1) 
                        end
                        if GetEntityHealth(PlayerPedId()) > 0 then
                            RemoveBlip(blip)
                            local markerID = "ltdRobb"..id
                            local data = {
                                position = vector3(pzCore.shops.config.list[id].npc.x, pzCore.shops.config.list[id].npc.y, pzCore.shops.config.list[id].npc.z),
                                drawDist = 25,
                                itrDist = 1.5,
                                color = {r = 0, g = 255, b = 0},
                                condition = nil,
                                help = "Appuyez sur ~INPUT_CONTEXT~ pour ramasser le butin",
                                interact = function()
                                    SetEntityCoords(PlayerPedId(), pzCore.shops.config.list[id].npc.x, pzCore.shops.config.list[id].npc.y, pzCore.shops.config.list[id].npc.z, false,false,false,false)
                                    TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, 0)
                                    --TaskPlayAnim(GetPlayerPed(-1), "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
                                    Wait(12000)
                                    -- Appelle de la police
                                    TriggerServerEvent("pz_core_shops:callThePolice")
                                    Wait(12000)            
                                    ClearPedTasks(GetPlayerPed(-1))
                                    pzCore.markers.unsubscribe(markerID)
                                    pzCore.markers.delete(markerID)
                                    local reward = pzCore.shops.config.possibleHoldupRewards[math.random(1,#pzCore.shops.config.possibleHoldupRewards)]
                                    ESX.ShowNotification("Vous avez reçu ~g~"..reward.."$")
                                    TriggerServerEvent("pz_core_ltd:rewardHoldup", reward, 25)
                                end
                            }
                            pzCore.markers.add(markerID,data)
                            pzCore.markers.subscribe(markerID)
                            Citizen.SetTimeout(60000*15, function()
                                DeleteEntity(pzCore.shops.config.list[id].currentNPC)
                                pzCore.shops.config.list[id].currentNPC = nil
                            end)
                        else
                            DeleteEntity(pzCore.shops.config.list[id].currentNPC)
                            ESX.ShowNotification("~r~Échec: Vous êtes mort!")
                            RemoveBlip(blip)
                            Citizen.SetTimeout(60000*15, function()
                                DeleteEntity(pzCore.shops.config.list[id].currentNPC)
                                pzCore.shops.config.list[id].currentNPC = nil
                            end)
                        end
                    end)
                end)
            else
                PlayAmbientSpeech1(pzCore.shops.config.list[id].currentNPC, "GENERIC_FRIGHTENED_HIGH_RANDOM", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                FreezeEntityPosition(pzCore.shops.config.list[id].currentNPC,false)
                TaskSmartFleePed(pzCore.shops.config.list[id].currentNPC, PlayerPedId(), 9000.0, -1, false, false)
                local markerID = "ltdRobb"..id
                local data = {
                    position = vector3(pzCore.shops.config.list[id].npc.x, pzCore.shops.config.list[id].npc.y, pzCore.shops.config.list[id].npc.z),
                    drawDist = 25,
                    itrDist = 1.5,
                    color = {r = 0, g = 255, b = 0},
                    condition = nil,
                    help = "Appuyez sur ~INPUT_CONTEXT~ pour ramasser le butin",
                    interact = function()
                        SetEntityCoords(PlayerPedId(), pzCore.shops.config.list[id].npc.x, pzCore.shops.config.list[id].npc.y, pzCore.shops.config.list[id].npc.z, false,false,false,false)
                        TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, 0)
                        --TaskPlayAnim(GetPlayerPed(-1), "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
                        Wait(12000)
                        -- Appelle de la police
                        TriggerServerEvent("pz_core_shops:callThePolice", pzCore.shops.config.list[id].npc.x, pzCore.shops.config.list[id].npc.y, pzCore.shops.config.list[id].npc.z)
                        Wait(12000)            
                        ClearPedTasks(GetPlayerPed(-1))
                        pzCore.markers.unsubscribe(markerID)
                        pzCore.markers.delete(markerID)
                        local reward = pzCore.shops.config.possibleHoldupRewards[math.random(1,#pzCore.shops.config.possibleHoldupRewards)]
                        ESX.ShowNotification("Vous avez reçu ~g~"..reward.."$")
                        TriggerServerEvent("pz_core_ltd:rewardHoldup", reward, 25)
                    end
                }
                pzCore.markers.add(markerID,data)
                pzCore.markers.subscribe(markerID)
                Citizen.SetTimeout(10000, function() DeleteEntity(pzCore.shops.config.list[id].currentNPC) end)
                Citizen.SetTimeout(60000*15, function()
                    DeleteEntity(pzCore.shops.config.list[id].currentNPC)
                    pzCore.shops.config.list[id].currentNPC = nil
                end)
            end
        end)
    end
end

local function createMenu(id)
    local actualItem,actualQty,qty,position,infos,descByState = 0,1,{},pzCore.shops.config.list[id].loc,pzCore.shops.config.groups[pzCore.shops.config.list[id].type],{[true] = "Vous pouvez braquer le vendeur",[false] = "Vous devez être armé"}
    RMenu.Add("pz_core_ltd", "pz_core_ltd_main", RageUI.CreateMenu("Shop","Faites votre choix"))
    RMenu:Get('pz_core_ltd', 'pz_core_ltd_main').Closed = function()end
    RMenu.Add('pz_core_ltd', 'pz_core_ltd_item', RageUI.CreateSubMenu(RMenu:Get('pz_core_ltd', 'pz_core_ltd_main'), "Shop", "Faites votre choix"))
    RMenu:Get('pz_core_ltd', 'pz_core_ltd_item').Closed = function()end
    RageUI.Visible(RMenu:Get('pz_core_ltd', 'pz_core_ltd_main'), not RageUI.Visible(RMenu:Get('pz_core_ltd', 'pz_core_ltd_main')))
    Citizen.CreateThread(function()
        local dist = 0
        while dist < 1.5 do
            dist = GetDistanceBetweenCoords(pzCore.shops.config.list[id].loc, GetEntityCoords(PlayerPedId()), false)
            dynamicMenu4 = true
            RageUI.IsVisible(RMenu:Get("pz_core_ltd",'pz_core_ltd_main'),true,true,true,function()
                if not pzCore.shops.config.list[id].state then
                    RageUI.Separator("~r~Ce shop est actuellement fermé, repassez plus tard") 
                else
                    if infos.canBeRobbed then 
                        RageUI.ButtonWithStyle("~r~Braquer ce magasin", descByState[IsPedArmed(PlayerPedId(), 4)], {RightLabel = "~s~→→"}, IsPedArmed(PlayerPedId(), 4), function(_,_,s)
                            if s then robb(id) end
                        end)
                    end
                    for i = 1,#infos.items do 
                        local itemInfo = infos.items[i]
                        
                        if itemInfo.category ~= nil then 
                            RageUI.Separator(itemInfo.category) 
                        else
                            RageUI.ButtonWithStyle(itemInfo.label, "Appuyez pour acheter cet article", {RightLabel = "~g~"..itemInfo.price.."$ ~s~→→"}, true, function(_,_,s)
                                if s then
                                    actualItem = itemInfo
                                    actualQty = 1
                                    qty = {}
                                    for i = 1,itemInfo.maxQty do
                                        table.insert(qty, i)
                                    end
                                end
                            end, RMenu:Get('pz_core_ltd', 'pz_core_ltd_item'))
                        end
                    end
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_core_ltd",'pz_core_ltd_item'),true,true,true,function()
                RageUI.List("Quantité: ~s~", qty, actualQty, nil, {}, true, function(Hovered, Active, Selected, Index) actualQty = Index end)
                RageUI.Separator("↓ ~g~Paiement ~s~↓")
                RageUI.ButtonWithStyle("Payer avec son ~b~compte en banque", nil, {RightLabel = "~g~"..actualItem.price*actualQty.."$ ~s~→→"}, true, function(_,_,s)
                    if s then
                        deleteMenus()
                        TriggerServerEvent("pz_core_ltd:buy", actualItem.item, actualItem.price, actualQty, 1)
                    end
                end)
                RageUI.ButtonWithStyle("Payer en ~r~liquide", nil, {RightLabel = "~g~"..actualItem.price*actualQty.."$ ~s~→→"}, true, function(_,_,s)
                    if s then
                        deleteMenus()
                        TriggerServerEvent("pz_core_ltd:buy", actualItem.item, actualItem.price, actualQty, 2)
                    end
                end)
            end, function()    
            end, 1)
            Citizen.Wait(0)
        end
        dynamicMenu4 = false
        deleteMenus()
    end)
end

local function openShop(id)
    if pzCore.shops.config.list[id].currentNPC ~= nil then PlayAmbientSpeech1(pzCore.shops.config.list[id].currentNPC, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR") end
    if RMenu:Get("pz_core_ltd", "pz_core_ltd_main") ~= nil then deleteMenus() end
    if not ShopOpen then
        RageUI.CloseAll()
        ShopOpen = false
        createMenu(id)
        ShopOpen = true
    end
end

local function initializeMarkers()
    for k,v in pairs(pzCore.shops.config.list) do
        local markerID = "ltd"..k
        local data = {
            position = vector3(v.loc.x, v.loc.y, v.loc.z),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin",
            interact = function() openShop(k) end
        }
        pzCore.markers.add(markerID,data)
        pzCore.markers.subscribe(markerID)
    end
end

local function initializeShops()
    for k,v in pairs(pzCore.shops.config.list) do pzCore.shops.config.groups[v.type].createBlip(v.loc) end
    initializeNPCLoop()
    initializeMarkers()
end

RegisterNetEvent("pz_core_ltd:purchaseCb")
AddEventHandler("pz_core_ltd:purchaseCb", function(ok)
    if ok then ESX.ShowNotification("~g~Achat effectué") else ESX.ShowNotification("~r~Vous n'avez pas assez d'argent") end
end)


RegisterNetEvent("pz_core_shops:initializePoliceBlip")
AddEventHandler("pz_core_shops:initializePoliceBlip", function(id)
    local duration = 20
    PlaySoundFrontend(-1, "Enemy_Deliver", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 1)
    DrawAdvancedNotification_("Central de police","~r~Appel téléphonique","Un civil a appellé la police à cause d'un possible braquage de supérette.","CHAR_CALL911",9)


    local position = GetEntityCoords(GetPlayerPed(-1))

    print(position)
    
    local shops = AddBlipForCoord(position)
	SetBlipSprite(shops , 161)
	SetBlipScale(shops , 3.0)
	SetBlipColour(shops, 47)
    PulseBlip(shops)

    Citizen.Wait(1000*duration)

    RemoveBlip(shops)
end)


pzCore.shops = {}
pzCore.shops.init = initializeShops
pzCore.shops.config = Shops