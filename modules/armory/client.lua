local AmoOpen = false


local function initializeNPCLoop()
    Citizen.CreateThread(function()
        while true do
            local p = GetEntityCoords(PlayerPedId())
            for k,v in pairs(pzCore.armory.config.list) do
                local pos = v.loc
                local dist = GetDistanceBetweenCoords(p, pos, 1)
                local npc = pzCore.armory.config.pedModel
                if v.currentNPC == nil and dist < 60 then
                    local hash = GetHashKey(npc)
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do Citizen.Wait(1) end
                    local npcPos = v.npc
                    v.currentNPC = CreatePed(9, hash, v.npc.x, v.npc.y, v.npc.z, v.npcHeading, false, false)
                    SetEntityAsMissionEntity(v.currentNPC, false, false)
                    SetBlockingOfNonTemporaryEvents(v.currentNPC, true)
                    SetEntityInvincible(v.currentNPC, true)
                    Citizen.SetTimeout(2500, function()
                        FreezeEntityPosition(v.currentNPC, true)
                        TaskStartScenarioInPlace(v.currentNPC, "WORLD_HUMAN_AA_COFFEE", 0, true)
                    end)
                end
            end
            Citizen.Wait(100)
        end
    end)
end

local function deleteMenus()
    RMenu:Delete("pz_core_ammo", "pz_core_ammo_main")
    RMenu:Delete("pz_core_ammo", "pz_core_ammo_item")
    RageUI.CloseAll()
end

local function createMenu(infos,id)
    if pzCore.armory.config.list[id].currentNPC ~= nil then PlayAmbientSpeech1(pzCore.armory.config.list[id].currentNPC, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR") end
    RMenu.Add("pz_core_ammo", "pz_core_ammo_main", RageUI.CreateMenu("Armurerie","Faites votre choix"))
    RMenu:Get('pz_core_ammo', 'pz_core_ammo_main').Closed = function()end

    RMenu.Add('pz_core_ammo', 'pz_core_ammo_item', RageUI.CreateSubMenu(RMenu:Get('pz_core_ammo', 'pz_core_ammo_main'), "Armurerie", "Faites votre choix"))
    RMenu:Get('pz_core_ammo', 'pz_core_ammo_item').Closed = function()end
    if not AmoOpen then 
    AmoOpen = true
    RageUI.Visible(RMenu:Get('pz_core_ammo', 'pz_core_ammo_main'), not RageUI.Visible(RMenu:Get('pz_core_ammo', 'pz_core_ammo_main')))
    Citizen.CreateThread(function()
        local dist,actualItem = 0,{}
        while dist < 1.5 do
            dist = GetDistanceBetweenCoords(infos.loc, GetEntityCoords(PlayerPedId()), false)
            dynamicMenu4 = true
            RageUI.IsVisible(RMenu:Get("pz_core_ammo",'pz_core_ammo_main'),true,true,true,function()
                for i = 1,#pzCore.armory.config.items do
                    local itemInfos = pzCore.armory.config.items[i]
                    if itemInfos.category ~= nil then
                        RageUI.Separator(itemInfos.category)
                    else
                        RageUI.ButtonWithStyle(itemInfos.label, "Appuyez pour acheter cet article", {RightLabel = "~g~"..itemInfos.price.."$ ~s~→→"}, true, function(_,_,s)
                            if s then
                                actualItem = itemInfos
                            end
                        end, RMenu:Get('pz_core_ammo', 'pz_core_ammo_item'))
                    end
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_core_ammo",'pz_core_ammo_item'),true,true,true,function()
                RageUI.Separator("~b~Sélection: ~s~"..actualItem.label)
                RageUI.Separator("↓ ~g~Paiement ~s~↓")
                RageUI.ButtonWithStyle("Payer avec son ~b~compte en banque", nil, {RightLabel = "~g~"..actualItem.price.."$ ~s~→→"}, true, function(_,_,s)
                    if s then
                        deleteMenus()
                        TriggerServerEvent("pz_core_ammo:buy", actualItem.item, actualItem.price, 1, actualItem.isItem)
                    end
                end)
                RageUI.ButtonWithStyle("Payer en ~r~liquide", nil, {RightLabel = "~g~"..actualItem.price.."$ ~s~→→"}, true, function(_,_,s)
                    if s then
                        deleteMenus()
                        TriggerServerEvent("pz_core_ammo:buy", actualItem.item, actualItem.price, 2, actualItem.isItem)
                    end
                end)
            end, function()    
            end, 1)
            Citizen.Wait(0)
        end
        dynamicMenu4 = false
        deleteMenus()
    end)
end
end

local function initializeMarkers()
    for k,v in pairs(pzCore.armory.config.list) do
        local markerID = "ammunation"..k
        local data = {
            position = vector3(v.loc.x, v.loc.y, v.loc.z),
            drawDist = 25,
            itrDist = 1.5,
            color = {r = 255, g = 0, b = 0},
            condition = nil,
            help = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'armurerie",
            interact = function() createMenu(v,k) end
        }
        pzCore.markers.add(markerID,data)
        pzCore.markers.subscribe(markerID)
    end
end

local function init()
    for _,v in pairs(pzCore.armory.config.list) do pzCore.armory.config.createBlip(v.loc) end


    local blip = AddBlipForCoord(17.47, -1100.56, 29.79)
    SetBlipSprite(blip, 433)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 49)
    SetBlipScale(blip, 0.75)
    SetBlipCategory(blip, 12)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Stand de tir")
    EndTextCommandSetBlipName(blip)

    initializeNPCLoop()
    initializeMarkers()
end

local trainingConfing = {}
trainingConfing.series,trainingConfing.selectedSerie = {"Série de 5", "Série de 15", "Série de 35","Série de 60","Série de 100"},1
trainingConfing.difficulties,trainingConfing.selectedDifficulty = {"Facile","Intermediaire","Difficile","Expert"},1
trainingConfing.waitByDifficulty = {[1] = 6000, [2] = 3000, [3] = 1300, [4] = 600}
trainingConfing.waitByDifficulty2 = {[1] = 6, [2] = 3, [3] = 1.3, [4] = 0.6}
trainingConfing.ped = nil
trainingConfing.totalByValue,trainingConfing.total = {[1] = 5, [2] = 15, [3] = 35, [4] = 60, [5] = 100},0
trainingConfing.killed,trainingConfing.count = 0,0
trainingConfing.vectors = {
    vector3(13.85, -1087.53, 29.79), vector3(20.55, -1089.00, 29.79), vector3(16.47, -1088.23, 29.79),

    vector3(15.34, -1081.88, 29.79), vector3(19.14, -1083.35, 29.79), vector3(22.79, -1084.46, 29.79),

    vector3(23.58, -1080.56, 29.79), vector3(19.84, -1079.01, 29.79), vector3(16.44, -1077.40, 29.79),

    vector3(18.21, -1073.79, 29.79), vector3(22.05, -1075.12, 29.79), vector3(25.57, -1076.32, 29.79)
}
local currentlyTraining = false


displayDoneMission = false
gain = 0
str = "Entraînement terminé"

local rt = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")





local function initTraining()
    RequestModel(GetHashKey("s_m_y_clown_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_clown_01")) do Citizen.Wait(1) end

    Citizen.CreateThread(function()
        while currentlyTraining and trainingConfing.killed <= trainingConfing.total and trainingConfing.count <= trainingConfing.total do
            RageUI.Text({message = "Cibles atteintes: ~b~"..trainingConfing.killed.."~s~/~b~"..trainingConfing.count.."~s~ (~b~"..trainingConfing.total.."max~s~) | Intervalle: ~r~"..trainingConfing.waitByDifficulty2[trainingConfing.selectedDifficulty].."s",time_display = 1})
            Citizen.Wait(1)
        end
    end)

    Citizen.CreateThread(function()
        while currentlyTraining and trainingConfing.killed <= trainingConfing.total and trainingConfing.count <= trainingConfing.total do
            if trainingConfing.ped ~= nil then DeleteEntity(trainingConfing.ped) end
            local skip = false
            local dead = false
            local ped = GetHashKey("s_m_y_clown_01")
            local pos = trainingConfing.vectors[math.random(1,#trainingConfing.vectors)]
            trainingConfing.ped = CreatePed(9, ped, pos.x, pos.y, pos.z, 159.0, false, false)
            SetBlockingOfNonTemporaryEvents(trainingConfing.ped, true)
            Citizen.CreateThread(function()
                while not skip and not dead do
                    Citizen.Wait(1)
                    if GetEntityHealth(trainingConfing.ped) < 1 then
                        trainingConfing.killed = trainingConfing.killed + 1
                        dead = true
                    else
                        local pos = GetEntityCoords(trainingConfing.ped)
                        DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255,0,0, 170, 0, 1, 2, 0, nil, nil, 0)
                    end

                end
            end)
            PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
            local wait = trainingConfing.waitByDifficulty[trainingConfing.selectedDifficulty] 
            Citizen.Wait(tonumber(wait))
            skip = true
            trainingConfing.count = trainingConfing.count + 1
        end
        if trainingConfing.ped ~= nil then DeleteEntity(trainingConfing.ped) end
        displayDoneMission = true
        currentlyTraining = false
    end)
end

local function draw()
    if currentlyTraining then
        RageUI.ButtonWithStyle("Finir l'entrainement",nil, {RightLabel = "→→"}, not codesCooldown, function(_,_,s)
            if s then
                RageUI.CloseAll()
                currentlyTraining = false
            end
        end)
    else
        if not IsPedArmed(PlayerPedId(), 4) then
            RageUI.Separator("~r~Vous devez avoir une arme en main")
        else
            RageUI.Separator("↓ ~o~Configuration ~s~↓")

            RageUI.List("Série: ~s~", trainingConfing.series, trainingConfing.selectedSerie, nil, {}, true, function(Hovered, Active, Selected, Index)
            
                trainingConfing.selectedSerie = Index
                trainingConfing.total = trainingConfing.totalByValue[Index]
                
            end)

            RageUI.List("Difficulté: ~s~", trainingConfing.difficulties, trainingConfing.selectedDifficulty, nil, {}, true, function(Hovered, Active, Selected, Index)
            
                trainingConfing.selectedDifficulty = Index
                
            end)

            RageUI.Separator("↓ ~o~Actions ~s~↓")

            RageUI.ButtonWithStyle("Démarrer l'entraînement",nil, {RightLabel = "→→"}, not codesCooldown, function(_,_,s)
                if s then
                    RageUI.CloseAll()
                    currentlyTraining = true
                    trainingConfing.killed,trainingConfing.count =0,0
                    PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset") 
                    local count,need = 5,true
                    Citizen.SetTimeout(6000, function() 
                        need = false 
                        initTraining()
                    end)
                    Citizen.CreateThread(function()
                        while need do
                            RageUI.Text({message = "Début de l'entraînement dans ~b~"..count.." seconde(s)~s~ !",time_display = 1000})
                            count = count -1
                            Citizen.Wait(1000)
                        end
                    end)
                end
            end)
        end
    end
end

Citizen.CreateThread(function()
	while true do
		if displayDoneMission then
			StartScreenEffect("SuccessTrevor",  2500,  false)
			curMsg = "SHOW_MISSION_PASSED_MESSAGE"
			SetAudioFlag("AvoidMissionCompleteDelay", true)
			PlayMissionCompleteAudio("FRANKLIN_BIG_01")
			Citizen.Wait(3000)
			StopScreenEffect()
			curMsg = "TRANSITION_OUT"
			PushScaleformMovieFunction(rt, "TRANSITION_OUT")
			PopScaleformMovieFunction()
			Citizen.Wait(2000)
			displayDoneMission = false
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		if(HasScaleformMovieLoaded(rt) and displayDoneMission)then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()

			if (curMsg == "SHOW_MISSION_PASSED_MESSAGE") then
			
			PushScaleformMovieFunction(rt, curMsg)
 
            ---BeginScaleformMovieMethod(rt, 'SHOW_SHARD_WASTED_MP_MESSAGE')
            PushScaleformMovieMethodParameterString(str)
            PushScaleformMovieMethodParameterString("Cibles atteintes: "..(trainingConfing.killed-1).."/"..(trainingConfing.count-1))
            EndScaleformMovieMethod()
			--BeginTextComponent("STRING")
			--AddTextComponentString(str)
			--EndTextComponent()
			--BeginTextComponent("STRING")
			--AddTextComponentString("Gain: "..gain.."$")
			--EndTextComponent()

			PushScaleformMovieFunctionParameterInt(145)
			PushScaleformMovieFunctionParameterBool(false)
			PushScaleformMovieFunctionParameterInt(1)
			PushScaleformMovieFunctionParameterBool(true)
			PushScaleformMovieFunctionParameterInt(69)

			PopScaleformMovieFunctionVoid()

			Citizen.InvokeNative(0x61bb1d9b3a95d802, 1)
			end
			
			DrawScaleformMovieFullscreen(rt, 255, 255, 255, 255)
		end
    end
end)

RegisterNetEvent("pz_core_ammo:giveWeapon")
AddEventHandler("pz_core_ammo:giveWeapon", function(item,secret)
    if secret ~= 265 then return end
    local weapon = GetHashKey(item)
    GiveWeaponToPed(PlayerPedId(), weapon, 1000, false, true)
end)

RegisterNetEvent("pz_core_ammo:purchaseCb")
AddEventHandler("pz_core_ammo:purchaseCb", function(ok)
    if ok then ESX.ShowNotification("~g~Achat effectué") else ESX.ShowNotification("~r~Vous n'avez pas assez d'argent") end
end)

pzCore.armory.init = init
pzCore.armory.drawTraining = draw