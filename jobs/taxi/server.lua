RegisterNetEvent("pz_core:taxi_state")
AddEventHandler("pz_core:taxi_state", function(open)
    if open then
        TriggerClientEvent("esx:showNotification", -1, "~s~Le taxi est désormais ~g~ouvert ~s~!")
    else
        TriggerClientEvent("esx:showNotification", -1, "~s~Le taxi est désormais ~r~fermé ~s~!")
    end
end)