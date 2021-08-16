if Config.ESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

RegisterNetEvent('admin:noClip')
AddEventHandler('admin:noClip', function()
    local playerGroup = false
    if Config.ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerGroup = xPlayer.getGroup()
    end
    local steamID = GetSteamID(source)
    local authorized = false

    if Config.AllowedGroups then
        if playerGroup then
            for _,v in ipairs(Config.AllowedGroups) do
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
                for _,v in ipairs(Config.AllowedSteamIDs) do
                    if v == steamID then
                        TriggerClientEvent('admin:toggleNoClip', source)
                    end
                end
            end
        end
    end
end)

function GetSteamID(source)
    local sid = false

    for _,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            sid = v
        end
    end

	return sid
end