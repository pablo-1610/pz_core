RegisterNetEvent("pz_core:bahamas_state")
AddEventHandler("pz_core:bahamas_state", function(open)
    if open then
        TriggerClientEvent("esx:showNotification", -1, "~s~Votre ~p~Bahamas ~s~est désormais ~g~ouvert ~s~!")
    else
        TriggerClientEvent("esx:showNotification", -1, "~s~Votre ~p~Bahamas ~s~est désormais ~r~fermé ~s~!")
    end
end)