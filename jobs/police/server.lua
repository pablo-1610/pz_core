local Codes = {
    types = {
        [1] = "~g~Information de l'agent",
        [2] = "~o~Statut de l'intervention",
        [3] = "~r~Demande de renforts",
    },

    codes = {
        [1] = "10-4: Affirmatif!",
        [2] = "10-5: Négatif!",
        [3] = "10-6: Pause de service",
        [4] = "10-8: Prise de service",
        [5] = "10-10: Fin de service",
        [6] = "10-19: Retour au poste",

        [7] = "10-13: Officier blessé!",
        [8] = "10-14: Prise d'otage",
        [9] = "10-31: Course poursuite",
        [10] = "10-32: Individu armé",

        [11] = "~r~URGENCE~s~: ~g~Légère~n~",
        [12] = "~r~URGENCE~s~: ~o~Moyenne~n~",
        [13] = "~r~URGENCE~s~: ~r~Maximale~n~~s~> ~r~Toutes les unités doivent se rendre sur les lieux"
    },

}

local function getLicense(source)
	local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

	for k,v in pairs(GetPlayerIdentifiers(source))do
			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		end
	end

	return license:gsub("license:","")
end


RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_policejob:handcuff', target)
    end
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {plate = plate}

		if result[1] then
			local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)

			-- is the owner online?
			--[[if xPlayer then
				retrivedInfo.owner = xPlayer.getName()
				cb(retrivedInfo)--]]
			--elseif Config.EnableESXIdentity then
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
					['@identifier'] = result[1].owner
				}, function(result2)
					if result2[1] then
                        retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
						cb(retrivedInfo)
					else
						cb(retrivedInfo)
					end
                end)
                --[[
			else
				cb(retrivedInfo)
            end
            --]]
		else
			cb(retrivedInfo)
		end
	end)
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_policejob:putInVehicle', target)
    end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
    end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_policejob:drag', target, source)
    end
end)

RegisterNetEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' or sourceXPlayer.job.name == 'fbi' then
		return
	end

	if itemType == 'item_standard' then
		TriggerClientEvent("TransacServer")
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		
		-- does the target player have enough in their inventory?

		if targetItem.count > 0 and targetItem.count >= amount then
			targetXPlayer.removeInventoryItem(itemName, amount)
			sourceXPlayer.addInventoryItem   (itemName, amount)
		end

	elseif itemType == 'item_weapon' then
		TriggerClientEvent("TransacServer")
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon(itemName, amount)

	elseif itemType == 'item_account' then
		TriggerClientEvent("TransacServer")

		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)
	end
end)




ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	local targer = target
	local xPlayer = ESX.GetPlayerFromId(targer)

	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(target),
			job = xPlayer.job,
			job2 = xPlayer.job2,
			inventory = xPlayer.inventory,
			accounts = xPlayer.accounts,
			weapons = xPlayer.getLoadout(),
			firstname = result[1]['firstname'],
			grade = result[1]['job_grade'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			dob = result[1]['dateofbirth'],
			height = result[1]['height']
		}
	
		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	
	end)
end)

RegisterNetEvent("pz_core:police:code")
AddEventHandler("pz_core:police:code", function(index,type,mugshot, mugshotStr, loc, id)
	local _src = source
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent("pz_core:police:code", xPlayers[i], type, index, Codes.types[type], Codes.codes[index],mugshot, mugshotStr, GetPlayerName(_src),  loc, id)
		end
	end
end)


TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})
