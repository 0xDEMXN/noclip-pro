ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('admin:noClip')
AddEventHandler('admin:noClip', function(player)
    local source = source
    local xPlayer  = ESX.GetPlayerFromId(source)
    local steamID = GetSteamID(source)
    local playerGroup = xPlayer.getGroup(source)
    local authorized = false

    if Config.AllowedGroups then
        if playerGroup then
            for k,v in ipairs(Config.AllowedGroups) do
                if v == playerGroup then
                    TriggerClientEvent('admin:toggleNoClip', source)
                    authorized = true
                end
            end
        end
    end

    if not authorized then
        if Config.AllowedSteamIDs then
            if steamID then 
                for k,v in ipairs(Config.AllowedSteamIDs) do
                    if v == steamID then
                        TriggerClientEvent('admin:toggleNoClip', source)
                    end
                end
            end
        end
    end
end)

function GetSteamID(src)
    local sid = GetPlayerIdentifiers(src)[1] or false

	if (sid == false or sid:sub(1,5) ~= "steam") then
		return false
	end

	return sid
end