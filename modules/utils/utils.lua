local Utils = {
    help = function(mess)
        AddTextEntry("TEST", mess)
        DisplayHelpTextThisFrame("TEST", false)
    end,
}   

local function loadESX()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
    -- PlayerData
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    ESX.PlayerData = ESX.GetPlayerData()
end

local function trace(mess)
    print(pzCore.prefix..mess)
end

local function showLoading(message)
    if type(message) == "string" then
        Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
        AddTextComponentSubstringPlayerName(message)
        Citizen.InvokeNative(0xBD12F8228410D9B4, 3)
    else
        Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
        AddTextComponentSubstringPlayerName("")
        Citizen.InvokeNative(0xBD12F8228410D9B4, -1)
    end
end

local function mug(title, subject, msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end

local function loadAll()
    local wait = {30,60,50,80}
    pzCore.load("Initialisation pz_core")
    Citizen.Wait(1000)
    local i = 0
    local max = 0
    for k,v in pairs(pzCore.markers.list) do
        max = max + 1
    end
    for k,v in pairs(pzCore.markers.list) do
        i = i + 1
        pzCore.load("Initialisation pz_core - Zones ("..i.."/"..max..")")
        Citizen.Wait(wait[math.random(1,#wait)])
    end
    pzCore.load("Initialisation pz_core - Métiers..")
    Citizen.Wait(1400)
    wait = {100,200,300,100}
    i = 0
    max = 0
    for k,v in pairs(pzCore.jobs) do
        max = max + 1
    end
    for k,v in pairs(pzCore.jobs) do
        i = i + 1
        pzCore.load("Initialisation pz_core - Métiers ("..i.."/"..max..")")
        Citizen.Wait(wait[math.random(1,#wait)])
    end
    pzCore.load("Initialisation pz_core - Lancement..")
    Citizen.Wait(1500)
    pzCore.load(false)
end

local function notNilString(str)
    if str == nil then
        return ""
    else
        return str
    end
end

local function getWeaponName(name)
    local wp = {
        ["weapon_nightstick"] = "Matraque"
    }

    if wp[string.lower(name)] == nil then
        return string.lower(name)
    else
        return wp[string.lower(name)]
    end
end

local function getItemName(name)
    local items = {
        ["bread"] = "Pain",
        ["bandage"] = "Bandage"
    }

    if items[string.lower(name)] == nil then
        return string.lower(name)
    else
        return items[string.lower(name)]
    end
end

local function keyboard(title,mess)
    AddTextEntry("FMMC_MPM_NA", title)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", mess, "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
end

local function bigKeyboard(title,mess)
    AddTextEntry("FMMC_KEY_TIP8", title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", mess, "", "", "", "", 5000)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
end

local function getGround(vector)
    return vector3(vector.x, vector.y, GetGroundZFor_3dCoord(vector.x,vector.y,vector.z,0))
end

pzCore.loadESX = loadESX
pzCore.trace = trace
pzCore.utils = Utils
pzCore.load = showLoading
pzCore.mug = mug
pzCore.loadAll = loadAll
pzCore.getWeaponName = getWeaponName
pzCore.getItemName = getItemName
pzCore.notNil = notNilString
pzCore.keyboard = keyboard
pzCore.bigKeyboard = bigKeyboard
pzCore.getGround = getGround