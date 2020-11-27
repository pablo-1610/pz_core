local menuThread = false
local isBahamas = false

RMenu.Add("bahamas_dynamicmenu", "bahamas_dynamicmenu_main", RageUI.CreateMenu("Tablette Bahamas","Interactions possibles"))
RMenu:Get("bahamas_dynamicmenu", "bahamas_dynamicmenu_main").Closed = function()end


local menuOpened = false
local function jobMenu()
	if menuThread then return end
	menuThread = true
	if not menuOpened then
		menuOpened = true
	Citizen.CreateThread(function()
		while isBahamas do
			if IsControlJustPressed(1, 167) then
				RageUI.Visible(RMenu:Get("bahamas_dynamicmenu",'bahamas_dynamicmenu_main'), not RageUI.Visible(RMenu:Get("bahamas_dynamicmenu",'bahamas_dynamicmenu_main')))
			end
			Citizen.Wait(1)
		end
		menuThread = false
	end)
end
end

local function init()
	menuThread = false
	isBahamas = true
	jobMenu()
end

local function jobChanged()

	if ESX.PlayerData.job.name == "bahamas" then
		isBahamas = true
		jobMenu()
	else
		isBahamas = false
		menuThread = false 
	end
end


local function createBlip()
    local blip = AddBlipForCoord(-1376.67, -629.13, 30.81)
	SetBlipSprite(blip, 93)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 61)
	SetBlipScale(blip, 1.0)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Bahamas")
	EndTextCommandSetBlipName(blip)
end

local function spawnCar(car, ped)
	local hash = GetHashKey(car)
	local p = vector3(-1380.307, -568.70, 30.22)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 90.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)
end

local current = "bahamas"

pzCore.jobs[current].init = init
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].spawnCar = spawnCar
pzCore.jobs[current].hasBlip = true
pzCore.jobs[current].createBlip = createBlip