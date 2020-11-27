RegisterNetEvent("pz_core:giveDrink")
AddEventHandler("pz_core:giveDrink", function(item)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'unicorn' or xPlayer.job.name == 'bahamas'  then
		xPlayer.addInventoryItem(item,1)
    end
end)

RegisterNetEvent("pz_core:unicorn_state")
AddEventHandler("pz_core:unicorn_state", function(open)
    if open then
        TriggerClientEvent("esx:showNotification", -1, "~s~Votre ~p~Unicorn ~s~est désormais ~g~ouvert ~s~!")
    else
        TriggerClientEvent("esx:showNotification", -1, "~s~Votre ~p~Unicorn ~s~est désormais ~r~fermé ~s~!")
    end
end)