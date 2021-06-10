if Config.ESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

RegisterNetEvent('admin:noClip')
AddEventHandler('admin:noClip', function(player)
    local source = source
    local steamID = GetSteamID(source)
    local playerGroup = GetPlayerGroup(source)
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

function GetPlayerGroup(src)
    if Config.ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer.getGroup() or false
    else 
        local license = GetPlayerIdentifiers(src)[2] or false

        if (license == false or license:sub(1,7) ~= "license") then
            return false
        end

        license = string.sub(license, 9)

        local player = MySQL.Sync.fetchAll('SELECT `group` FROM users WHERE identifier = @identifier', {
            ['@identifier'] = license
        })

        return player[1].group or false
    end
end