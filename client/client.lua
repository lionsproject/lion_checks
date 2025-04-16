local globalAdams = {}
local globalUnions = {}
local playerAdam = nil
local playerUnion = nil

local config = require 'config'

RegisterCommand(config.Checks.command, function()
    local isLEO = lib.callback.await('lion_checks:server:checkpdjob', source)

    if isLEO then
        lib.registerContext({
            id = 'check_menu_main',
            title = "Check Menu",
            options = {
                {
                    title = 'Adam Checks',
                    description = 'Adam checks for patrol in two!',
                    icon = 'person',
                    arrow = true,
                    onSelect = function()
                        TriggerEvent('check:openAdamMenu')
                    end
                },
                {
                    title = 'Union Checks',
                    description = 'Union checks for patrol in three!',
                    icon = 'people-group',
                    arrow = true,
                    onSelect = function()
                        TriggerEvent('check:openUnionMenu')
                    end
                },
            }
        })
        lib.showContext('check_menu_main')
    else
        lib.notify({
            title = 'Dispatch',
            description = "You are not LEO!",
            icon = "fas fa-display",
            iconColor = "#6082B6",
            duration = 2500
        })
    end
end, false)

RegisterNetEvent('check:openAdamMenu', function()
    local options = {}

    if playerAdam then
        table.insert(options, {
            title = "Leave Adam " .. playerAdam,
            icon = "right-from-bracket",
            onSelect = function()
                TriggerServerEvent('check:toggleAdam', playerAdam)
            end
        })
    else
        for i = 1, config.Checks.maxadams do
            local taken = globalAdams[i] ~= nil
            local label = taken and ("Adam " .. i .. " (Occupied)") or ("Adam " .. i)

            table.insert(options, {
                title = label,
                disabled = taken,
                icon = taken and "xmark" or "check",
                onSelect = function()
                    TriggerServerEvent('check:toggleAdam', i)
                end
            })
        end
    end

    lib.registerContext({
        id = 'check_menu_adam',
        title = 'Adam Checks',
        options = options,
    })
    lib.showContext('check_menu_adam')
end)

RegisterNetEvent('check:openUnionMenu', function()
    local options = {}

    if playerUnion then
        table.insert(options, {
            title = "Leave Union " .. playerUnion,
            icon = "right-from-bracket",
            onSelect = function()
                TriggerServerEvent('check:toggleUnion', playerUnion)
            end
        })
    else
        for i = 1, config.Checks.maxunions do
            local taken = globalUnions[i] ~= nil
            local label = taken and ("Union " .. i .. " (Occupied)") or ("Union " .. i)

            table.insert(options, {
                title = label,
                disabled = taken,
                icon = taken and "xmark" or "check",
                onSelect = function()
                    TriggerServerEvent('check:toggleUnion', i)
                end
            })
        end
    end

    lib.registerContext({
        id = 'check_menu_union',
        title = 'Union Checks',
        options = options,
    })
    lib.showContext('check_menu_union')
end)

RegisterNetEvent('check:updateMenu', function(updatedAdams, updatedUnions)
    globalAdams = updatedAdams or {}
    globalUnions = updatedUnions or {}
end)

RegisterNetEvent('check:updatePlayerMenu', function(updatedAdams, updatedUnions)
    globalAdams = updatedAdams or {}
    globalUnions = updatedUnions or {}
    playerAdam = nil
    playerUnion = nil

    for index, playerId in pairs(globalAdams) do
        if playerId == GetPlayerServerId(PlayerId()) then
            playerAdam = index
            break
        end
    end

    for index, playerId in pairs(globalUnions) do
        if playerId == GetPlayerServerId(PlayerId()) then
            playerUnion = index
            break
        end
    end
end)

RegisterNetEvent('check:notify', function(message, type)
    if config.Checks.notify == "ox_lib" then
        lib.notify({
            description = message,
            type = type or 'inform',
        })
    elseif config.Checks.notify == "custom" then
        --ADD BY YOURSELF
    end
end)
