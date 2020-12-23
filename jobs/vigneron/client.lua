local recolte,traitement,vente = nil,nil,nil
IsVigneron = false
menuThread = false
local JobBlips = {}



RegisterNetEvent("StartRecolteAnimation")
AddEventHandler("StartRecolteAnimation", function(source)
	FreezeEntityPosition(PlayerPedId(), true)
	TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
end)

local function StopAction()
	Citizen.CreateThread(function()
		while IsVigneron do
			if IsControlJustPressed(0, 73) then --X = Stop Action
				TriggerServerEvent("esx:vigneronjob:stopHarvest")
				ClearPedTasksImmediately(PlayerPedId())
				FreezeEntityPosition(PlayerPedId(), false)
				Wait(3000)
				krCore.jobsMarkers.subscribe()
			end
			Citizen.Wait(1)
		end
		menuThread = false

	end)
end


local function init()
	IsVigneron = true
	menuThread = false

	StopAction()
end

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
		RemoveBlip(JobBlips[i])
		JobBlips[i] = nil
		end
	end
end

local function jobblip()
	if ESX.PlayerData.job.name == "vigne" then
		local blip1 = AddBlipForCoord(-1831.8696, 2133.17089843, 124.2925796)
		SetBlipSprite(blip1, 85)
		SetBlipAsShortRange(blip1, true)
		SetBlipColour(blip1, 48)
		SetBlipScale(blip1, 0.5)
		SetBlipCategory(blip1, 12)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vigneron | Récolte 1/3")
		EndTextCommandSetBlipName(blip1)
		table.insert(JobBlips, blip1)

		local blip2 = AddBlipForCoord(259.6047, 2585.924, 44.95418)
		SetBlipSprite(blip2, 85)
		SetBlipAsShortRange(blip2, true)
		SetBlipColour(blip2, 48)
		SetBlipScale(blip2, 0.5)
		SetBlipCategory(blip2, 12)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vigneron | Transformation 2/3")
		EndTextCommandSetBlipName(blip2)
		table.insert(JobBlips, blip2)

		local blip3 = AddBlipForCoord(264.8515, -981.3807, 29.36479)
		SetBlipSprite(blip3, 85)
		SetBlipAsShortRange(blip3, true)
		SetBlipColour(blip3, 48)
		SetBlipScale(blip3, 0.5)
		SetBlipCategory(blip3, 12)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vigneron | Vente 3/3")
		EndTextCommandSetBlipName(blip3)
		table.insert(JobBlips, blip3)
	end
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

	deleteBlips()
	
	jobblip()

	init()
end)

local function jobChanged()
	IsVigneron = true
	menuThread = false

	StopAction()
end

local function createBlip()
	local blip = AddBlipForCoord(-1904.65, 2042.23, 140.74)
	SetBlipSprite(blip, 85)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 48)
	SetBlipScale(blip, 1.0)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vigneron")
	EndTextCommandSetBlipName(blip)
end

local function spawnCar(car, ped)
	local hash = GetHashKey(car)
	local p = vector3(-1911.33, 2038.26, 140.73)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 190.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end

RegisterNetEvent('stoptallVigneron')
AddEventHandler('stoptallVigneron', function(source)
	TriggerServerEvent("esx:vigneronjob:stopHarvest")
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	Wait(5000)
	krCore.jobsMarkers.subscribe()
end)



RegisterNetEvent("RemoveMarkerVigneron")
AddEventHandler("RemoveMarkerVigneron", function(source)
	krCore.markers.unsubscribe("vigneron_recolte")
	krCore.markers.unsubscribe("vigneron_transformation")
	krCore.markers.unsubscribe("vigneron_vente")
end)


local current = "vigne"

pzCore.jobs[current].init = init
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].createBlip = createBlip
pzCore.jobs[current].spawnCar = spawnCar