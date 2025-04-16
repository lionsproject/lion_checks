local globalAdams = {}
local globalUnions = {}

local config = require 'config'

RegisterServerEvent('check:toggleAdam')
AddEventHandler('check:toggleAdam', function(index)
    local src = source

    if globalAdams[index] and globalAdams[index] ~= src then
        TriggerClientEvent('check:notify', src, 'Adam ' .. index .. ' is already taken!', 'error')
        return
    end

    if globalAdams[index] == src then
        globalAdams[index] = nil
    else
        globalAdams[index] = src
    end

    TriggerClientEvent('check:updatePlayerMenu', src, globalAdams, globalUnions)
    TriggerClientEvent('check:updateMenu', -1, globalAdams, globalUnions)
end)

RegisterServerEvent('check:toggleUnion')
AddEventHandler('check:toggleUnion', function(index)
    local src = source

    if globalUnions[index] and globalUnions[index] ~= src then
        TriggerClientEvent('check:notify', src, 'Union ' .. index .. ' is already taken!', 'error')
        return
    end

    if globalUnions[index] == src then
        globalUnions[index] = nil
    else
        globalUnions[index] = src
    end
    TriggerClientEvent('check:updatePlayerMenu', src, globalAdams, globalUnions)
    TriggerClientEvent('check:updateMenu', -1, globalAdams, globalUnions)
end)

AddEventHandler('playerDropped', function()
    local src = source
    for index, player in pairs(globalAdams) do
        if player == src then
            globalAdams[index] = nil
        end
    end

    for index, player in pairs(globalUnions) do
        if player == src then
            globalUnions[index] = nil
        end
    end

    TriggerClientEvent('check:updateMenu', -1, globalAdams, globalUnions)
end)

function IsLEO(src)
    ESX = exports["es_extended"]:getSharedObject()
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer and xPlayer.job.name == config.Checks.policejob then --ADD HERE MORE BY YOURSELF
        return true
    else
        return false
    end
end

lib.callback.register('lion_checks:server:checkpdjob', function(source)
    return IsLEO(source)
end)
