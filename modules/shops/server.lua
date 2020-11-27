RegisterNetEvent("pz_core_ltd:buy")
AddEventHandler("pz_core_ltd:buy", function(item,price,qty,method)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local money = 0
    if method == 1 then money = xPlayer.getAccount("bank").money else money = xPlayer.getMoney() end
    local total = price*qty
    if money < total then
        TriggerClientEvent("pz_core_ltd:purchaseCb", _src, false)
        return
    end
    xPlayer.addInventoryItem(item, qty)
    if method == 1 then xPlayer.removeAccountMoney("bank", total) else xPlayer.removeMoney(total) end
    TriggerClientEvent("pz_core_ltd:purchaseCb", _src, true)
end)

RegisterNetEvent("pz_core_ltd:rewardHoldup")
AddEventHandler("pz_core_ltd:rewardHoldup", function(reward,secret)
    if secret ~= 25 then return end
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    xPlayer.addMoney(reward)
end)




RegisterNetEvent("pz_core_shops:callThePolice")
AddEventHandler("pz_core_shops:callThePolice", function(id)
    local authority = 'LSPD'
    if authority == "LSPD" then
        authority = "police"
    end

    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == authority then 
            TriggerClientEvent("pz_core_shops:initializePoliceBlip", tonumber(xPlayers[i]), 20)
            --TriggerClientEvent("pz_core_shops:initializePoliceBlip", , 20)
        end
    end
end)