local items = {}
local itemsSelected = {}
local playerItems = {}
local waitingForCb = false

local qty = {}
local selectedQty = 1

local function deleteMenus()
    RageUI.CloseAll()
    RMenu:Delete("pz_core_inv", "pz_core_inv_main")
    RMenu:Delete("pz_core_inv", "pz_core_inv_deposit")
    RMenu:Delete("pz_core_inv", "pz_core_inv_take")
end

RegisterNetEvent("pz_core:getInventoryData")
AddEventHandler("pz_core:getInventoryData", function(cache,p,coords,jobName)
    playerItems = p
    playerItems = {}
    for k,v in pairs(p) do
        playerItems[v.name] = {count = v.count, label = v.label}
    end

    local closed = false
    items = {}

    for k,v in pairs(cache) do
        items[v.name] = {count = v.count, label = v.label}
    end

    RMenu.Add("pz_core_inv", "pz_core_inv_main", RageUI.CreateMenu("Inventaire","Inventaire de l'entreprise"))
    RMenu:Get('pz_core_inv', 'pz_core_inv_main').Closed = function() closed = true end

    RMenu.Add('pz_core_inv', 'pz_core_inv_deposit', RageUI.CreateSubMenu(RMenu:Get('pz_core_inv', 'pz_core_inv_main'), "Inventaire", "Déposer un objet"))
    RMenu:Get('pz_core_inv', 'pz_core_inv_deposit').Closed = function() end

    RMenu.Add('pz_core_inv', 'pz_core_inv_take', RageUI.CreateSubMenu(RMenu:Get('pz_core_inv', 'pz_core_inv_main'), "Inventaire", "Prendre un objet"))
    RMenu:Get('pz_core_inv', 'pz_core_inv_take').Closed = function() end


    RageUI.Visible(RMenu:Get('pz_core_inv', 'pz_core_inv_main'), not RageUI.Visible(RMenu:Get('pz_core_inv', 'pz_core_inv_main')))
    Citizen.CreateThread(function()
        local menu = false
        local dist = 0
        while dist < 1.5 and not closed do
            menu = false
            dist = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false)
            dynamicMenu4 = true
            RageUI.IsVisible(RMenu:Get("pz_core_inv",'pz_core_inv_main'),true,true,true,function()
                menu = true
                RageUI.Separator("↓ ~b~Action~s~↓")

                RageUI.ButtonWithStyle("Déposer un objet",nil, {RightLabel = "~b~Déposer~s~ →→"}, true, function(_,_,s)
                    if s then
                        qty = {}
                        selectedQty = 1
                        for i = 1,50 do
                            table.insert(qty,i)
                        end
                    end
                end, RMenu:Get('pz_core_inv', 'pz_core_inv_deposit'))

                RageUI.Separator("↓ ~b~Contenu~s~↓")
                local count = 0
                for k,v in pairs(items) do
                    if v.count > 0 then
                        count = count + 1
                        RageUI.ButtonWithStyle(v.label.." (~b~x"..v.count.."~s~)",nil, {RightLabel = "~b~Prendre~s~ →→"}, waitingForCb ~= true, function(_,_,s)
                            if s then 
                                itemsSelected = {item = k, count = v.count, label = v.label}
                                qty = {}
                                selectedQty = 1
                                for i = 1,v.count do
                                    table.insert(qty,i)
                                end
                            end
                        end, RMenu:Get('pz_core_inv', 'pz_core_inv_take'))
                    end
                end
                if count == 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~Vous n'avez aucun item disponible")
                    RageUI.Separator("")
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_core_inv",'pz_core_inv_take'),true,true,true,function()
                menu = true
                if waitingForCb then RageUI.Separator("~r~Transaction au serveur en cours...") end
                RageUI.Separator("↓ ~b~Action~s~↓")
                RageUI.ButtonWithStyle(itemsSelected.label..": ~b~x"..itemsSelected.count,nil, {}, true, function() end)
                RageUI.List("Prendre: ~s~", qty, selectedQty, nil, {}, selectedQty <= itemsSelected.count, function(Hovered, Active, Selected, Index) selectedQty = Index end)
                RageUI.ButtonWithStyle("Prendre",nil, {RightLabel = "→→"}, waitingForCb ~= true and selectedQty <= itemsSelected.count, function(_,_,s)
                    if s then
                        waitingForCb = true 
                        TriggerServerEvent("pz_core:take", itemsSelected.item, selectedQty, jobName)
                    end
                end)
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_core_inv",'pz_core_inv_deposit'),true,true,true,function()
                menu = true
                if waitingForCb then RageUI.Separator("~r~Transaction au serveur en cours...") end
                RageUI.Separator("↓ ~b~Préfèrence~s~↓")

                RageUI.List("Quantité: ~s~", qty, selectedQty, nil, {}, true, function(Hovered, Active, Selected, Index) selectedQty = Index end)

                RageUI.Separator("↓ ~b~Liste~s~↓")
                local count = 0
                for k,v in pairs(playerItems) do
                    if v.count > 0 then
                        count = count + 1
                        RageUI.ButtonWithStyle(v.label.." (~b~x"..v.count.."~s~)",nil, {RightLabel = "~b~Déposer ~s~→→"}, selectedQty <= v.count and waitingForCb ~= true, function(_,_,s)
                            if s then
                                waitingForCb = true 
                                TriggerServerEvent("pz_core:deposit", k, selectedQty, jobName)
                            end
                        end)
                    end
                end

                if count == 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~Vous n'avez aucun item disponible")
                    RageUI.Separator("")
                end

            end, function()    
            end, 1)

            if not menu then closed = true end

            Citizen.Wait(0)
        end
        dynamicMenu4 = false
        deleteMenus()
    end)
end)

RegisterNetEvent("pz_core:callbackDeposit")
AddEventHandler("pz_core:callbackDeposit", function(name,qty,toAdd,item)
    Citizen.Wait(500)

    playerItems[name].count = playerItems[name].count - qty 
    if not items[name] then 
        items[name] = {count = 0, label = item.label}
    end

    items[name].count = items[name].count + toAdd

    Citizen.Wait(500)
    waitingForCb = false
end)

RegisterNetEvent("pz_core:callbackTake")
AddEventHandler("pz_core:callbackTake", function(name,qty,toRemove,item)
    Citizen.Wait(500)

    items[name].count = items[name].count - toRemove

    if playerItems[name].count == nil then 
        playerItems[name] = {count = qty, label = item.label}
    end

    itemsSelected.count = items[name].count

    Citizen.Wait(500)
    waitingForCb = false
end)