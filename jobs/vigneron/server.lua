local PlayersTransforming = {}
local PlayersSelling = {}
local PlayersHarvesting = {}
local jusr = 1

TriggerEvent('esx_society:registerSociety', 'vigne', 'Vigneron', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'private'})



local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)

		if zone == "RaisinFarm" then

			local itemQuantity = xPlayer.getInventoryItem('raisin').count
			if itemQuantity >= 100 then
				TriggerClientEvent("stoptallVigneron",source)
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de place")
			else
				SetTimeout(1800, function()
					TriggerClientEvent('esx:showNotification', source, "Appuyez sur ~b~X ~w~pour annuler l'action")
					xPlayer.addInventoryItem('raisin', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx:vigneronjob:stopHarvest')
AddEventHandler('esx:vigneronjob:stopHarvest', function()
	local _source = source
	PlayersHarvesting[_source] = false
	PlayersTransforming[_source] = false
	PlayersSelling[_source] = false
end)

RegisterServerEvent('esx:vigneronjob:startHarvest')
AddEventHandler('esx:vigneronjob:startHarvest', function(zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent("RemoveMarkerVigneron",_source)
	TriggerClientEvent('esx:showNotification', _source,"Vous êtes en train de récolté du raisin")
	TriggerClientEvent("StartRecolteAnimation", _source)
	PlayersHarvesting[_source] = true
	Harvest(_source, zone)
end)

local function Transform(source, zone)
	if PlayersTransforming[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)

		if zone == "TraitementVin" then
			local itemQuantity = xPlayer.getInventoryItem('raisin').count

			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de place")
				TriggerClientEvent("stoptallVigneron",source)
			else

				local itemQuantity = xPlayer.getInventoryItem('raisin').count
				
				if itemQuantity <= 0 then
					TriggerClientEvent("stoptallVigneron",source)
					TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de raisin")
					return
				else
					SetTimeout(700, function()
						xPlayer.removeInventoryItem('raisin', 1)
						xPlayer.addInventoryItem('jus_raisin', 1)		
						TriggerClientEvent('esx:showNotification', source, "Appuyez sur ~b~X ~w~pour annuler l'action")			
						Transform(source, zone)
					end)
				end
			end
		end
	end	
end


RegisterServerEvent('esx:vigneronjob:startTrans')
AddEventHandler('esx:vigneronjob:startTrans', function(zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent("RemoveMarkerVigneron",_source)
	TriggerClientEvent('esx:showNotification', _source,"Vous êtes en train de récolté du raisin")
	TriggerClientEvent("StartRecolteAnimation", _source)
	PlayersTransforming[_source] = true
	Transform(_source, zone)
end)



local function Sell(source, zone)
	if PlayersSelling[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('jus_raisin').count <= 0 then
				jusr = 0
			else
				jusr = 1
			end

			if jusr == 0 then
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de produit a vendre")
				TriggerClientEvent("stoptallVigneron",source)

				return
			elseif xPlayer.getInventoryItem('jus_raisin').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de produit a vendre")
				TriggerClientEvent("stoptallVigneron",source)
				jusr = 0
				return
			else
				if (jusr == 1) then
					SetTimeout(800, function()
						TriggerClientEvent('esx:showNotification', source, "Appuyez sur ~b~X ~w~pour annuler l'action")
						local money = 75
						xPlayer.removeInventoryItem('jus_raisin', 1)
						xPlayer.addAccountMoney('cash', money)
						local societyAccount = nil
						TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez gagné ~g~".. money.."$")
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)

						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, "Votre société à gagné ~g~"..money.."$")
						end

						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx:vigneronjob:startVente')
AddEventHandler('esx:vigneronjob:startVente', function(zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if PlayersSelling[_source] == false then
		PlayersSelling[_source] = false
	else
		PlayersSelling[_source] = true
		TriggerClientEvent("RemoveMarkerVigneron",_source)
		TriggerClientEvent('esx:showNotification', _source,"Vous êtes en train de récolté du raisin")
		TriggerClientEvent("StartRecolteAnimation", _source)
		Sell(_source, zone)
	end
end)
