ESX = nil
Apartments = {}

Types = {Condominiums = 0, Houses = 1, Motels = 2}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.TriggerServerCallback('esx_apartments:getApartments', function(result)
        Apartments = result
        createBlips()
    end)
end)

function createBlips()
    for k, v in pairs(Apartments) do
        local blipConfig = {}
        if v.kind == Types.Condominiums then
            blipConfig = Config.Blips.Condominiums.Available
        end

        if v.kind == Types.Condominiums and Config.EnableCondominiums then
            marker = split(v.enter_marker, ",")
            print(marker[1] .. " " .. marker[2] .. " " .. marker[3])

            local blip = AddBlipForCoord(tonumber(marker[1]),
                                         tonumber(marker[2]),
                                         tonumber(marker[3]))

            SetBlipSprite(blip, blipConfig.Sprite)
            SetBlipDisplay(blip, blipConfig.Display)
            SetBlipScale(blip, blipConfig.Scale)
            SetBlipColour(blip, blipConfig.Colour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.label)
            EndTextCommandSetBlipName(blip)
        end

    end
end
