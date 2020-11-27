RegisterNetEvent("pz_core_ammo:buy")
AddEventHandler("pz_core_ammo:buy", function(item,price,method,isItem)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local money = 0
    if method == 1 then money = xPlayer.getAccount("bank").money else money = xPlayer.getMoney() end
    local total = price
    if money < total then
        TriggerClientEvent("pz_core_ltd:purchaseCb", _src, false)
        return
    end

    if isItem then
        xPlayer.addInventoryItem(item, 1)
    else
        TriggerClientEvent("pz_core_ammo:giveWeapon", _src, item, 265)
    end

    
    if method == 1 then xPlayer.removeAccountMoney("bank", total) else xPlayer.removeMoney(total) end
    TriggerClientEvent("pz_core_ammo:purchaseCb", _src, true)
end)
