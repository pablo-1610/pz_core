local items = {}


local function getLicense(source)
    local license = nil
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end
    return license
end

local function canUse(source)
    local license = getLicense(source)
    if license == nil then return end
    return Pz_admin.staffList[license] ~= nil
end

local function getRank(source)
    local license = getLicense(source)
    if license == nil then return end
    return Pz_admin.staffList[license], license
end

local function getItems()
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
        return result
    end)
end

RegisterNetEvent("pz_admin:message")
AddEventHandler("pz_admin:message", function(id,mess)
    TriggerClientEvent("esx:showNotification", id, "~r~Message du staff: ~s~"..mess)
end)

RegisterNetEvent("pz_admin:bring")
AddEventHandler("pz_admin:bring", function(id,pos)
    TriggerClientEvent("pz_admin:teleport", id, pos)
end)

RegisterNetEvent("pz_admin:remb")
AddEventHandler("pz_admin:remb", function(id,item,qty)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    xPlayer.addInventoryItem(item,qty)
end)

RegisterNetEvent("pz_admin:revive")
AddEventHandler("pz_admin:revive", function(id)
    TriggerClientEvent("esx_ambulancejob:revive", id)
end)

RegisterNetEvent("pz_admin:ban")
AddEventHandler("pz_admin:ban", function(initial,id,reason,time)
    local _src = source
    local n = GetPlayerName(_src)
    time = tonumber(time)
    local license,identifier,liveid,xblid,discord,playerip
    local targetplayername = GetPlayerName(id)
        for k,v in ipairs(GetPlayerIdentifiers(id))do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                identifier = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                liveid = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xblid  = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                playerip = v
            end
        end
    if time > 0 then
        TriggerEvent("fivemban", initial,license,identifier,liveid,xblid,discord,playerip,targetplayername,n,time,reason,0) --Timed ban here
        DropPlayer(id, "Vous avez été banni(e) temporairement: \""..reason.."\" par "..n)
    else
        TriggerEvent("fivemban", initial,license,identifier,liveid,xblid,discord,playerip,targetplayername,n,time,reason,1)
        DropPlayer(id, "Vous avez été banni(e) à vie: \""..reason.."\" par "..n)
    end
end)

RegisterNetEvent("pz_admin:kick")
AddEventHandler("pz_admin:kick", function(id,mess)
    local _src = source
    DropPlayer(id, "Vous avez été expulsé: \""..mess.."\", par "..GetPlayerName(_src))
end)

RegisterNetEvent("pz_admin:getItems")
AddEventHandler("pz_admin:getItems", function()
    local _src = source
    TriggerClientEvent("pz_admin:getItems", _src, items)
end)

RegisterNetEvent("pz_admin:canUse")
AddEventHandler("pz_admin:canUse", function()
    local _src = source
    local state,license = canUse(_src)
    local rank = -1
    if state then rank = getRank(_src) end
    TriggerClientEvent("pz_admin:canUse", _src, state, rank, license)
end)

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
        items = result
    end)
end)