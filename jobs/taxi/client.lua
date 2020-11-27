local menuThread = false
local isTaxi = false

RMenu.Add("taxi_dynamicmenu", "taxi_dynamicmenu_main", RageUI.CreateMenu("Tablette Taxi","Interactions possibles"))
RMenu:Get("taxi_dynamicmenu", "taxi_dynamicmenu_main").Closed = function()end

local menuOpene = false
local function jobMenu()
	if menuThread then return end
	menuThread = true
	if not menuOpene then 
		menuOpene = true
	Citizen.CreateThread(function()
		while isTaxi do
			if IsControlJustPressed(1, 167) then
				RageUI.Visible(RMenu:Get("taxi_dynamicmenu",'taxi_dynamicmenu_main'), not RageUI.Visible(RMenu:Get("taxi_dynamicmenu",'taxi_dynamicmenu_main')))
			end
			Citizen.Wait(1)
		end
		menuThread = false
	end)
end
end

local function init()
	menuThread = false
	isTaxi = true
	jobMenu()
end

local function jobChanged()

	if ESX.PlayerData.job.name == "taxi" then
		isTaxi = true
		jobMenu()
	else
		isTaxi = false
		menuThread = false 
	end
end


local function createBlip()
    local blip = AddBlipForCoord(914.07, -179.21, 74.18)
	SetBlipSprite(blip, 225)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 46)
	SetBlipScale(blip, 1.0)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Taxi")
	EndTextCommandSetBlipName(blip)
end

local function spawnCar(ped, car)
	local hash = GetHashKey(car)
	local p = vector3(914.07, -179.21, 74.18)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 90.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)
end


local current = "taxi"

pzCore.jobs[current].init = init
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].spawnCar = spawnCar
pzCore.jobs[current].hasBlip = true
pzCore.jobs[current].createBlip = createBlip