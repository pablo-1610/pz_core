pzCore = {}
pzCore.prefix = "[P.ZCore] >> "
ESX = nil

local function trace(mess)
    print(pzCore.prefix..mess)
end

pzCore.trace = trace

Citizen.CreateThread(function()
    Citizen.Wait(200)
    pzCore.jobs.func.loadItems()
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

