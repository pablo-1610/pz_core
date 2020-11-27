local dangerosityTable = {[1] = "Coopératif",[2] = "Dangereux",[3] = "Dangereux et armé",[4] = "Terroriste"}

fbiADRDangerosities = {"Coopératif","Dangereux","Dangereux et armé","Terroriste"}
fbiADRBuilder = {dangerosity = 1}
fbiADRData = nil
fbiADRindex = 0


local function init()
    -- Special
	isPolice = true
	inServicePolice = false
	pzCore.mug("Statut de service","~b~Agence fédérale","Vous êtes actuellement considéré comme étant ~r~hors service~s~. Vous pouvez changer ce statut avec votre menu ~o~[F6]")
	pzCore.jobs["police"].jobMenu()
end

local function jobChanged()
end

local function getDangerosityNameByInt(dangerosity)
    if dangerosityTable[dangerosity] ~= nil then
        return dangerosityTable[dangerosity]
    else
        return dangerosity
    end
end

local function spawnCar(car, ped)
	local hash = GetHashKey(car)
	local p = vector3(56.80, -741.81, 44.17)
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, p.x, p.y, p.z, 190.0, true, false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end

-- TODO -> Enlever quand terminé
RegisterCommand("co", function(source, args, rawcommand)
    local p = GetEntityCoords(PlayerPedId())
    pzCore.trace(p.x..", "..p.y..", "..p.z.."   |  "..GetEntityHeading(PlayerPedId()))
end, false)

RegisterNetEvent("pz_core:adrGet")
AddEventHandler("pz_core:adrGet", function(result)
    local found = 0
    for k,v in pairs(result) do
        found = found + 1
    end
    if found > 0 then fbiADRData = result end
end)

RegisterNetEvent("pz_core:adrDel")
AddEventHandler("pz_core:adrDel", function()
    pzCore.mug("Rapport d'interaction","~b~Agence fédérale","L'avis de recherche a été ~r~supprimé ~s~!")
end)

RegisterNetEvent("pz_core:adrAdd")
AddEventHandler("pz_core:adrAdd", function()
    pzCore.mug("Rapport d'interaction","~b~Agence fédérale","L'avis de recherche a été ~g~posté ~s~!")
end)

local function createBlip()
    local blip = AddBlipForCoord(59.27, -752.09, 44.22)
	SetBlipSprite(blip, 88)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 57)
	SetBlipScale(blip, 1.0)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Locaux du F.B.I")
	EndTextCommandSetBlipName(blip)
end

local current = "fbi"

pzCore.jobs[current].init = init
pzCore.jobs[current].getDangerosity = getDangerosityNameByInt
pzCore.jobs[current].jobChanged = jobChanged
pzCore.jobs[current].spawnCar = spawnCar
pzCore.jobs[current].hasBlip = true
pzCore.jobs[current].createBlip = createBlip