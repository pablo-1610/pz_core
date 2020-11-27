local recolte,traitement,vente = nil,nil,nil

local function init()
    
end

local function jobChanged()
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

local current = "vigne"

pzCore.jobs[current].init = init
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].createBlip = createBlip
pzCore.jobs[current].spawnCar = spawnCar