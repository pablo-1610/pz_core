pzCore = {}
pzCore.prefix = "[P.ZCore] >> "
ESX = nil

Citizen.CreateThread(function()
    pzCore.loadESX()
    pzCore.loadAll()
    pzCore.markers.init()
    pzCore.markers.registerPublicBlips()
    pzCore.jobsMarkers.subscribe()
    pzCore.menus.init()
    pzCore.jobsFunc.init()
    pzCore.shops.init()
    pzCore.staff.init()
    pzCore.armory.init()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    pzCore.jobsFunc.changed()
    pzCore.jobsMarkers.unsubscribeAll()
    pzCore.jobsMarkers.subscribe()
end)

