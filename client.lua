local Keys = {['E'] = 38}

ESX = nil
Properties = {}

Types = {Condominiums = 0, Houses = 1, Motels = 2}
TeleportType = {Enter = 0, Exit = 1}
IsInside = false

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                'esx:getSharedObject',
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while not ESX.IsPlayerLoaded() do
            Citizen.Wait(1)
        end

        ESX.TriggerServerCallback(
            'esx_apartments:getProperties',
            function(result, id)
                Properties = result
                CreateBlips()

                -- script probably restarted, check current player spawn
                if id ~= nil and IsInside == false then
                    CheckPlayerSpawn()
                end
            end
        )
    end
)

function CheckPlayerSpawn()
    Citizen.CreateThread(
        function()
            while not ESX.IsPlayerLoaded() do
                Citizen.Wait(0)
            end

            ESX.TriggerServerCallback(
                'esx_apartments:getCurrentApartment',
                function(id)
                    if id ~= nil then
                        while #Properties == 0 do
                            Citizen.Wait(0)
                        end

                        for _, v in pairs(Properties) do
                            if v.id == id then
                                TeleportProperty(TeleportType.Enter, v)
                                break
                            end
                        end
                    end
                end
            )
        end
    )
end

function CreateBlips()
    for _, v in pairs(Properties) do
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

    if v.price_rent >= 0 then
        table.insert(
            elements,
            {
                label = string.format('Rent ($%d)', v.price_rent),
                value = 'rent'
            }
        )
    end
    if v.price_buy >= 0 then
        table.insert(
            elements,
            {
                label = string.format('Buy ($%d)', v.price_buy),
                value = 'buy'
            }
        )
    end
    table.insert(elements, {label = 'Visit', value = 'visit'})

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'properties',
        {
            title = v.label,
            align = Config.MenuPosition,
            elements = elements
        },
        function(data, menu)
            menu.close()

            -- Rent
            if data.current.value == 'rent' then
                TriggerServerEvent('esx_apartments:assignProperty', v.id, true)
            -- TODO: replace blip, reopen menu
            end

            -- Visit
            if data.current.value == 'visit' then
                TeleportProperty(TeleportType.Enter, v)
            end
        end
    )
end

function TeleportProperty(action, v)
    local playerPed = GetPlayerPed(-1)

    -- Fade out
    DoScreenFadeOut(1000)
    while IsScreenFadingOut() do
        Citizen.Wait(0)
    end
    NetworkFadeOutEntity(playerPed, true, false)
    Wait(1000)

    -- Set new coords
    local coords = StringToCoords(action == TeleportType.Enter and v.exit_marker or v.enter_marker)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    SetEntityHeading(playerPed, coords.h)

    if action == TeleportType.Enter then
        TriggerServerEvent('esx_apartments:setCurrentApartment', v.id)
        IsInside = true
    else
        TriggerServerEvent('esx_apartments:unsetCurrentApartment')
        IsInside = false
    end

    -- Fade in
    NetworkFadeInEntity(playerPed, 0)
    Wait(1000)
    DoScreenFadeIn(1000)
    while IsScreenFadingIn() do
        Citizen.Wait(0)
    end
end

function ShowMarker(marker, config)
    DrawMarker(config.Type, marker.x, marker.y, marker.z, 0, 0, 0, 0, 0, 0, config.Size.x, config.Size.y, config.Size.z, config.Colour.r, config.Colour.g, config.Colour.b, config.Alpha, 0, 0, 0, 1)
end

-- Show markers
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)

            local coords = GetEntityCoords(GetPlayerPed(-1))
            local distance

            for _, v in pairs(Properties) do
                -- Enter marker
                marker = StringToCoords(v.enter_marker)
                distance = GetDistanceBetweenCoords(coords, marker.x, marker.y, marker.z, true)
                -- show marker
                if distance < Config.DrawDistance then
                    ShowMarker(marker, Config.Markers.Enter)

                    -- show action text
                    if distance < 1.0 and IsControlJustReleased(0, Keys['E']) then
                        OpenMenu(v)
                    end
                end

                -- Exit marker
                if IsInside then
                    marker = StringToCoords(v.exit_marker)
                    distance = GetDistanceBetweenCoords(coords, marker.x, marker.y, marker.z, true)
                    -- show marker
                    if distance < Config.DrawDistance then
                        ShowMarker(marker, Config.Markers.Exit)

                        if distance < 1.0 and IsControlJustReleased(0, Keys['E']) then
                            TeleportProperty(TeleportType.Exit, v)
                        end
                    end
                end
            end
        end
    end
)
