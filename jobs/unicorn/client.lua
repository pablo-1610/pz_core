local menuThread = false
local isUnicorn = false

RMenu.Add("unicorn_dynamicmenu", "unicorn_dynamicmenu_main", RageUI.CreateMenu("Tablette Unicorn","Interactions possibles"))
RMenu:Get("unicorn_dynamicmenu", "unicorn_dynamicmenu_main").Closed = function()end



local menuOpen = false
local function jobMenu()
	if menuThread then return end
	menuThread = true
	if not menuOpen then 
		menuOpen = true 
	Citizen.CreateThread(function()
		while isUnicorn do
			if IsControlJustPressed(1, 167) then
				RageUI.Visible(RMenu:Get("unicorn_dynamicmenu",'unicorn_dynamicmenu_main'), not RageUI.Visible(RMenu:Get("unicorn_dynamicmenu",'unicorn_dynamicmenu_main')))
			end
			Citizen.Wait(1)
		end
		menuThread = false
	end)
end
end

local function init()
	menuThread = false
	isUnicorn = true
	jobMenu()
end

local function jobChanged()

	if ESX.PlayerData.job.name == "unicorn" then
		isUnicorn = true
		jobMenu()
	else
		isUnicorn = false
		menuThread = false 
	end
end

local function createBlip()
    local blip = AddBlipForCoord(130.77, -1302.67, 29.23)
	SetBlipSprite(blip, 121)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 61)
	SetBlipScale(blip, 1.0)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Unicorn")
	EndTextCommandSetBlipName(blip)
end

local function spawnCar(car, ped)
	local hash = GetHashKey(car)
	local p = vector3(116.54, -1318.81, 28.98)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 90.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end

local function setUniform(ped,id)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = pzCore.jobs[ESX.PlayerData.job.name].config.clothes[id].male
		else
			uniformObject = pzCore.jobs[ESX.PlayerData.job.name].config.clothes[id].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
		else
			-- Rien
		end
	end)
end

local current = "unicorn"

pzCore.jobs[current].init = init
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].spawnCar = spawnCar
pzCore.jobs[current].setUniform = setUniform
pzCore.jobs[current].hasBlip = true
pzCore.jobs[current].createBlip = createBlip