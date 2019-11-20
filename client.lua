local Keys = {["E"] = 38}

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
            marker = StringToCoords(v.enter_marker)

            local blip = AddBlipForCoord(marker.x, marker.y, marker.z)

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

function OpenMenu(v)
    local elements = {}

    table.insert(elements, {label = 'Rent', value = 'rent'})
    table.insert(elements, {label = 'Buy', value = 'buy'})
    table.insert(elements, {label = 'Visit', value = 'visit'})

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'apartments', {
        title = 'test',
        align = Config.MenuPosition,
        elements = elements
    }, function(data, menu) menu.close() end)

end

-- Show markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(Apartments) do
            -- Enter marker
            marker = StringToCoords(v.enter_marker)
            local distance = GetDistanceBetweenCoords(coords, marker.x,
                                                      marker.y, marker.z, true)
            -- show marker
            if distance < Config.DrawDistance then
                DrawMarker(Config.Markers.Enter.Type, marker.x, marker.y,
                           marker.z, 0, 0, 0, 0, 0, 0,
                           Config.Markers.Enter.Size.x,
                           Config.Markers.Enter.Size.y,
                           Config.Markers.Enter.Size.z,
                           Config.Markers.Enter.Colour.r,
                           Config.Markers.Enter.Colour.g,
                           Config.Markers.Enter.Colour.b,
                           Config.Markers.Enter.Alpha, 0, 0, 0, 1)

                -- show action text
                if distance < 1.0 and IsControlJustReleased(0, Keys['E']) then
                    OpenMenu(v)
                end
            end
        end
    end
end)
