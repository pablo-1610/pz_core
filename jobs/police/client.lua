isPolice = false 
inServicePolice = false
dragStatus = {}
dragStatus.isDragged = false
identityStats = nil
vehicleStats = nil
orgByService = {["police"] = "~b~Dept. de la justice",["fbi"] = "~b~Agence fédérale"}
local menuThread = false
local blips = {}
local isHandcuffed = false


RMenu.Add("police_dynamicmenu", "police_dynamicmenu_main", RageUI.CreateMenu("Tablette de police","Interactions possibles"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_main").Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_citizen', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions citoyens", "Interactions avec un citoyen"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen').Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_veh', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions véhicules", "Interactions avec un véhicule"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_veh').Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_carinfos', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_veh'), "Informations véhicule", "Informations du véhicule"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_carinfos').Closed = function()end


RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_identity', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen'), "Carte d'identité", "Carte d'identité de la personne"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_identity').Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_bs', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen'), "Fouille", "Inventaire de la personne"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_bs').Closed = function()end


RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_codes', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Communications radio", "Communication avec le reste des effectifs"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_codes').Closed = function()end

-- FBI

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_adrlaunch', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Avis de recherche", "Lancer un avis de recherche"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adrlaunch').Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_adr', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Avis de recherche", "Consulter les avis de recherche"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adr').Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_adrcheck', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adr'), "Avis de recherche", "Consulter un avis de recherche"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_adrcheck').Closed = function()end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_announce', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Annonce fédérale", "Émettre une annonce fédérale"))
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_announce').Closed = function()end


local policeOpen = false
local function jobMenu()
	if menuThread then return end
	menuThread = true
	if not policeOpen then 
		policeOpen = true
	Citizen.CreateThread(function()
		while isPolice do
			if IsControlJustPressed(1, 167) then
				RageUI.Visible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_main'), not RageUI.Visible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_main')))
			end
			Citizen.Wait(1)
		end
		menuThread = false
	end)
	end
end

local function init()
	menuThread = false
	isPolice = true
	inServicePolice = false
	pzCore.mug("Statut de service",orgByService[ESX.PlayerData.job.name],"Vous êtes actuellement considéré comme étant ~r~hors service~s~. Vous pouvez changer ce statut avec votre menu ~o~[F6]")
	jobMenu()
end

local function jobChanged()

	if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "fbi" then
		isPolice = true
		inServicePolice = false
		pzCore.mug("Statut de service",orgByService[ESX.PlayerData.job.name],"Vous êtes actuellement considéré comme étant ~r~hors service~s~. Vous pouvez changer ce statut avec votre menu ~o~[F6]") 
		jobMenu()
	else
		isPolice = false
		inServicePolice = false
		menuThread = false 
	end
end



function getInformations(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		Citizen.SetTimeout(1100, function()
		identityStats = data
		end)
	end, GetPlayerServerId(player))
end

local function getVehicleInfos(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(data)
		Citizen.SetTimeout(1100, function()
		vehicleStats = data
		end)
	end, vehicleData.plate)
end


local function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = pzCore.jobs[ESX.PlayerData.job.name].config[uniform].male
		else
			uniformObject = pzCore.jobs[ESX.PlayerData.job.name].config[uniform].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 6 then
				SetPedArmour(playerPed, 100)
			end
		else
			-- Rien
		end
	end)
end

local function getWeapon(weapon, ped)
    local hash = GetHashKey(weapon)
    GiveWeaponToPed(ped, hash, 10000, false, true)
end

local function spawnCar(car, ped)
	local hash = GetHashKey(car)
	local p = vector3(449.95, -1020.11, 28.44)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 90.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end

local function spawnHeli(heli, ped)
	local hash = GetHashKey(heli)
	local p = vector3(449.330, -981.193, 43.69)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 180.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end

local function setUniformJail(ped)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = pzCore.jobs[ESX.PlayerData.job.name].config.jail.male
		else
			uniformObject = pzCore.jobs[ESX.PlayerData.job.name].config.jail.female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 6 then
				SetPedArmour(playerPed, 100)
			end
		else
			-- Rien
		end
	end)
end



AddEventHandler('playerSpawned', function(spawn)
	TriggerEvent('esx_policejob:unrestrain')
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copId)
	if isHandcuffed then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(100)
		end

		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		FreezeEntityPosition(playerPed, true)
		DisplayRadar(false)

	else

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent("pz_core:police:code")
AddEventHandler("pz_core:police:code", function(typeIndex, index, typeDesc, codeDesc, _, _, name, initialLoc, src)
	if isPolice and inServicePolice then
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(src))
		ESX.ShowAdvancedNotification("Agent ~y~"..name, typeDesc, codeDesc, mugshotStr, 1)
		UnregisterPedheadshot(mugshot)
		if typeIndex > 1 and index <= 10 then 
			SendNUIMessage({
				transactionType     = 'playSound',
				transactionFile     = "callback",
				transactionVolume   = 1.0
			})
			Citizen.CreateThread(function()
				local color = 47
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(blip, 162)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 1.0)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Statut d'intervention ("..name..")")
				EndTextCommandSetBlipName(blip)
				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(800)
						if color == 47 then
							color = 71
						else
							color = 47
						end
						SetBlipColour(blip, color)
						if thiefBlip ~= nil then SetBlipColour(thiefBlip, color) end
					end
				end)

				local thiefBlip = AddBlipForRadius(initialLoc.x, initialLoc.y, initialLoc.z, 40.0)

				SetBlipHighDetail(thiefBlip, true)
				SetBlipColour(thiefBlip, color)
				SetBlipAlpha(thiefBlip, 200)
				SetBlipAsShortRange(thiefBlip, true)

				Citizen.SetTimeout(40000, function()
					active = false
					RemoveBlip(blip)
					RemoveBlip(thiefBlip)
				end)

			end)
		end

		if index == 11 then
			SendNUIMessage({
				transactionType     = 'playSound',
				transactionFile     = "code2",
				transactionVolume   = 1.0
			})

			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				local color = 69
				SetBlipSprite(blip, 304)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 1.0)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Code 2")
				EndTextCommandSetBlipName(blip)
				
				local radius = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(radius, 161)
				SetBlipScale(radius, 2.0)
				SetBlipColour(radius, color)
				PulseBlip(radius)

				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(600)
						if color == 69 then
							color = 37
						else
							color = 69
						end
						SetBlipColour(blip, color)
					end
				end)
				Citizen.Wait(60000)
				RemoveBlip(blip)
				RemoveBlip(radius)

			end)
			
		end

		if index == 12 then
			SendNUIMessage({
				transactionType     = 'playSound',
				transactionFile     = "code3",
				transactionVolume   = 1.0
			})
			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				local color = 47
				SetBlipSprite(blip, 304)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 1.0)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Code 3")
				EndTextCommandSetBlipName(blip)
				
				local radius = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(radius, 161)
				SetBlipScale(radius, 2.0)
				SetBlipColour(radius, color)
				PulseBlip(radius)

				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(400)
						if color == 47 then
							color = 37
						else
							color = 47
						end
						SetBlipColour(blip, color)
					end
				end)
				Citizen.Wait(60000)
				RemoveBlip(blip)
				RemoveBlip(radius)

			end)
		end

		if index == 13 then
			SendNUIMessage({
				transactionType     = 'playSound',
				transactionFile     = "code99",
				transactionVolume   = 1.0
			})
			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				local color = 59
				SetBlipSprite(blip, 304)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 1.0)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Code 99")
				EndTextCommandSetBlipName(blip)
				
				local radius = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(radius, 161)
				SetBlipScale(radius, 2.0)
				SetBlipColour(radius, color)
				PulseBlip(radius)

				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(150)
						if color == 59 then
							color = 37
						else
							color = 59
						end
						SetBlipColour(blip, color)
					end
				end)
				Citizen.Wait(60000)
				RemoveBlip(blip)
				RemoveBlip(radius)

			end)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if IsAnyVehicleNearPoint(coords, 5.0) then
			local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
					dragStatus.isDragged = false
				end
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 64)
	end
end)


local function createBlip()
	local policeDept = vector3(442.69, -983.51, 30.68)

	local blip = AddBlipForCoord(policeDept.x, policeDept.y, policeDept.z)
	SetBlipSprite(blip, 60)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 38)
	SetBlipScale(blip, 1.0)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Commissariat")
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	local wasDragged



	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if isHandcuffed and dragStatus.isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Citizen.Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(playerPed, true, false)
		else
			Citizen.Wait(500)
		end
	end
end)

local current = "police"

pzCore.jobs[current].jobMenu = jobMenu
pzCore.jobs[current].setUniform = setUniform
pzCore.jobs[current].getWeapon = getWeapon
pzCore.jobs[current].spawnCar = spawnCar
pzCore.jobs[current].spawnHeli = spawnHeli
pzCore.jobs[current].setUniformJail = setUniformJail
pzCore.jobs[current].init = init
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].getIdentity = getInformations
pzCore.jobs[current].getVehicleInfos = getVehicleInfos
pzCore.jobs[current].hasBlip = true
pzCore.jobs[current].createBlip = createBlip