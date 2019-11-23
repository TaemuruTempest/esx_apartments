local Keys = {['E'] = 38}

ESX = nil
Properties = {}
Blips = {}
GarageBlips = {}

Types = {Condominium = 0, House = 1, Motel = 2}
TeleportType = {Enter = 0, Exit = 1}
IsInside = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.IsPlayerLoaded() do Citizen.Wait(1) end

    ESX.TriggerServerCallback('esx_apartments:getProperties',
                              function(result, id)
        Properties = result
        CreateBlips()

        -- script probably restarted, check current player spawn
        if id ~= nil and IsInside == 0 then CheckPlayerSpawn() end
    end)
end)

function CheckPlayerSpawn()
    Citizen.CreateThread(function()
        while not ESX.IsPlayerLoaded() do Citizen.Wait(0) end

        ESX.TriggerServerCallback('esx_apartments:getCurrentApartment',
                                  function(id)
            if id ~= nil then
                while #Properties == 0 do Citizen.Wait(0) end

                for _, v in pairs(Properties) do
                    if v.id == id then
                        TeleportProperty(TeleportType.Enter, v)
                        break
                    end
                end
            end
        end)
    end)
end

function CreateBlips()
    local marker
    for _, v in pairs(Properties) do
        if v.enter_marker ~= nil and
            ((v.kind == Types.Condominium and Config.EnableCondominiums) or
                (v.kind == Types.House and Config.EnableHouses) or
                (v.kind == Types.Motel and Config.EnableMotels)) then

            if v.garage_get ~= nil and Config.EnableGarages then
                marker = StringToCoords(v.garage_get)
                GarageBlips[v.id] =
                    AddBlipForCoord(marker.x, marker.y, marker.z)
            end

            marker = StringToCoords(v.enter_marker)
            Blips[v.id] = AddBlipForCoord(marker.x, marker.y, marker.z)
            SetBlip(v)
        end
    end
end

function SetBlip(v)
    if v.parent ~= 0 then
        local parent = GetPropertyById(v.parent)
        SetBlip(parent)
        return
    end

    local blipConfig = {}
    local blipText = ""
    if v.kind == Types.Condominium then
        blipText = "Apartment"

        -- check childrens
        if v.exit_marker == nil then
            for _, child in pairs(Properties) do
                if child.parent == v.id then
                    if child.owned then v.owned = true end
                    break
                end
            end
        end

        if v.owned then
            blipConfig = Config.Blips.Condominiums.Owned
        else
            blipConfig = Config.Blips.Condominiums.Available
        end
    end

    if v.kind == Types.House then
        blipText = "House"

        if v.owned then
            blipConfig = Config.Blips.Houses.Owned
        else
            blipConfig = Config.Blips.Houses.Available
        end
    end

    if v.kind == Types.Motel then
        blipText = "Motel"
        blipConfig = Config.Blips.Motels
    end

    SetBlipSprite(Blips[v.id], blipConfig.Sprite)
    SetBlipDisplay(Blips[v.id], blipConfig.Display)
    SetBlipScale(Blips[v.id], blipConfig.Scale)
    SetBlipColour(Blips[v.id], blipConfig.Colour)
    SetBlipAsShortRange(Blips[v.id], true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipText)
    EndTextCommandSetBlipName(Blips[v.id])

    -- Check garage blip
    if GarageBlips[v.id] ~= nil then
        SetBlipSprite(GarageBlips[v.id], Config.Blips.Garages.Sprite)
        SetBlipScale(GarageBlips[v.id], Config.Blips.Garages.Scale)
        SetBlipColour(GarageBlips[v.id], Config.Blips.Garages.Colour)
        SetBlipAsShortRange(GarageBlips[v.id], true)
        if v.owned then
            SetBlipDisplay(GarageBlips[v.id], Config.Blips.Garages.Display)
        else
            SetBlipDisplay(GarageBlips[v.id], 0)
        end
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Garage')
        EndTextCommandSetBlipName(GarageBlips[v.id])
    end
end

function SetOwned(id, value, rented)
    for k, v in pairs(Properties) do
        if v.id == id then
            Properties[k].owned = value
            Properties[k].rented = rented
            if v.parent ~= 0 then
                for pk, pv in pairs(Properties) do
                    if pv.id == v.parent then
                        Properties[pk].owned = value
                        break
                    end
                end
            end
            break
        end
    end
end

function GetPropertyById(id)
    for _, v in pairs(Properties) do if v.id == id then return v end end
end

function OpenCondominiumMenu(v)
    local elements = {}

    -- get available properties on this condominium
    for _, child in pairs(Properties) do
        if child.parent == v.id then
            table.insert(elements, {label = child.label, value = child})
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'condominium', {
        title = v.label,
        align = Config.MenuPosition,
        elements = elements
    }, function(data, menu)
        menu.close()
        OpenPropertyMenu(data.current.value)
    end)
end

function OpenPropertyMenu(v)
    local elements = {}

    if v.owned then
        table.insert(elements, {label = 'Enter', value = 'enter'})
        table.insert(elements, {
            label = v.rented and 'End contract' or 'Sell',
            value = 'sell'
        })
    else
        if v.price_rent > 0 then
            table.insert(elements, {
                label = string.format('Rent ($%d)', v.price_rent),
                value = 'rent'
            })
        end
        if v.price_buy > 0 then
            table.insert(elements, {
                label = string.format('Buy ($%d)', v.price_buy),
                value = 'buy'
            })
        end

        if v.kind ~= Types.Motel then
            table.insert(elements, {label = 'Visit', value = 'visit'})
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'properties', {
        title = v.label,
        align = Config.MenuPosition,
        elements = elements
    }, function(data, menu)
        menu.close()

        -- Rent
        if data.current.value == 'rent' then
            TriggerServerEvent('esx_apartments:assignProperty', v.id, true)
            v.owned = true
            v.rented = true
            SetOwned(v.id, true, true)
            SetBlip(v)

            if v.kind == Types.Motel then
                TeleportProperty(TeleportType.Enter, v)
            else
                OpenPropertyMenu(v)
            end
        end

        -- Sell
        if data.current.value == 'sell' then
            TriggerServerEvent('esx_apartments:unassignProperty', v.id)
            v.owned = false
            v.rented = false
            SetOwned(v.id, false, false)
            SetBlip(v)
            OpenPropertyMenu(v)
        end

        -- Enter/Visit
        if data.current.value == 'enter' or data.current.value == 'visit' then
            TeleportProperty(TeleportType.Enter, v)
        end
    end)
end

function OpenGarageMenu(p)
    local elements = {}

    ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
        for _, v in pairs(vehicles) do
            local vehicleName = GetDisplayNameFromVehicleModel(v.vehicle.model)

            if v.state then
                table.insert(elements, {
                    label = vehicleName .. " (" .. v.vehicle.plate .. ")",
                    value = v.vehicle
                })
            end
        end

        if #elements == 0 then
            table.insert(elements, {label = 'No vehicles found', value = nil})
        end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage', {
            title = 'Garage',
            align = Config.MenuPosition,
            elements = elements
        }, function(data, menu)
            menu.close()
            if data.current.value == nil then return end

            local vehicle = data.current.value
            local marker = StringToCoords(p.garage_get)

            ESX.Game.SpawnVehicle(vehicle.model,
                                  {x = marker.x, y = marker.y, z = marker.z},
                                  marker.h, function(model)

                ESX.Game.SetVehicleProperties(model, vehicle)
                SetVehicleBodyHealth(model, vehicle.bodyHealth * 1.0)
                if vehicle.engineHealth == 0 then
                    vehicle.engineHealth = 100
                end
                SetVehicleEngineHealth(model, vehicle.engineHealth * 1.0)
                if exports["LegacyFuel"] ~= nil then
                    exports["LegacyFuel"]:SetFuel(model, vehicle.fuelLevel * 1.0)
                end
                SetVehicleFuelLevel(model, vehicle.fuelLevel * 1.0)
                SetVehRadioStation(model, "OFF")
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), model, -1)
            end)
            TriggerServerEvent('eden_garage:modifystate', vehicle.plate, false)
        end)
    end)
end

function TeleportProperty(action, v)
    local playerPed = GetPlayerPed(-1)

    -- check where to teleport player
    local teleportCoords
    if action == TeleportType.Enter then
        teleportCoords = v.exit_marker
    else
        if v.parent ~= 0 then
            local parent = GetPropertyById(v.parent)
            teleportCoords = parent.enter_marker
        else
            teleportCoords = v.enter_marker
        end
    end

    -- Fade out
    DoScreenFadeOut(1000)
    while IsScreenFadingOut() do Citizen.Wait(0) end
    NetworkFadeOutEntity(playerPed, true, false)
    Wait(1000)

    -- Set new coords
    local coords = StringToCoords(teleportCoords)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    SetEntityHeading(playerPed, coords.h)

    if action == TeleportType.Enter then
        TriggerServerEvent('esx_apartments:setCurrentApartment', v.id)
        IsInside = v.id
    else
        TriggerServerEvent('esx_apartments:unsetCurrentApartment')
        IsInside = 0
    end

    -- Fade in
    NetworkFadeInEntity(playerPed, 0)
    Wait(1000)
    DoScreenFadeIn(1000)
    while IsScreenFadingIn() do Citizen.Wait(0) end
end

function ShowMarker(marker, config)
    DrawMarker(config.Type, marker.x, marker.y, marker.z, 0, 0, 0, 0, 0, 0,
               config.Size.x, config.Size.y, config.Size.z, config.Colour.r,
               config.Colour.g, config.Colour.b, config.Alpha, 0, 0, 0, 1)
end

-- Show markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local coords = GetEntityCoords(GetPlayerPed(-1))
        local distance

        for _, v in pairs(Properties) do
            -- Enter marker
            if v.enter_marker ~= nil then
                marker = StringToCoords(v.enter_marker)
                distance = GetDistanceBetweenCoords(coords, marker.x, marker.y,
                                                    marker.z, true)
                -- show marker
                if distance < Config.DrawDistance then
                    ShowMarker(marker, Config.Markers.Enter)

                    -- show action text
                    if distance < 1.0 and IsControlJustReleased(0, Keys['E']) then
                        -- Condominium/Motel: show child properties
                        if (v.kind == Types.Condominium or v.kind == Types.Motel) and
                            v.parent == 0 and v.exit_marker == nil then
                            OpenCondominiumMenu(v)
                        else
                            OpenPropertyMenu(v)
                        end
                    end
                end
            end

            -- Exit marker
            if IsInside == v.id and v.exit_marker ~= nil then
                marker = StringToCoords(v.exit_marker)
                distance = GetDistanceBetweenCoords(coords, marker.x, marker.y,
                                                    marker.z, true)
                -- show marker
                if distance < Config.DrawDistance then
                    ShowMarker(marker, Config.Markers.Exit)

                    if distance < 1.0 and IsControlJustReleased(0, Keys['E']) then
                        if v.kind == Types.Motel then
                            TriggerServerEvent(
                                'esx_apartments:unassignProperty', v.id)
                        end
                        TeleportProperty(TeleportType.Exit, v)
                    end
                end
            end

            -- Garage markers
            if Config.EnableGarages then
                local playerPed = GetPlayerPed(-1)

                if v.owned and v.garage_get ~= nil then
                    marker = StringToCoords(v.garage_get)
                    distance = GetDistanceBetweenCoords(coords, marker.x,
                                                        marker.y, marker.z, true)
                    -- show marker
                    if distance < Config.DrawDistanceGarage then
                        ShowMarker(marker, Config.Markers.GarageGet)

                        if distance < 2.0 and
                            IsPedInAnyVehicle(playerPed, false) == false then
                            SetTextComponentFormat("STRING")
                            AddTextComponentString(
                                "Press ~INPUT_CONTEXT~ to enter garage")
                            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                            if IsControlJustReleased(0, Keys['E']) then
                                OpenGarageMenu(v)
                            end
                        end
                    end
                end

                if v.owned and v.garage_put ~= nil then
                    marker = StringToCoords(v.garage_put)
                    distance = GetDistanceBetweenCoords(coords, marker.x,
                                                        marker.y, marker.z, true)
                    -- show marker
                    if distance < Config.DrawDistanceGarage then
                        ShowMarker(marker, Config.Markers.GaragePut)

                        if distance < 2.0 and
                            IsPedInAnyVehicle(playerPed, false) then
                            SetTextComponentFormat("STRING")
                            AddTextComponentString(
                                "Press ~INPUT_CONTEXT~ to deposit vehicle")
                            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                            if IsControlJustReleased(0, Keys['E']) then
                                local vehicle =
                                    GetVehiclePedIsIn(playerPed, false)
                                local vehicleProps =
                                    ESX.Game.GetVehicleProperties(vehicle)
                                vehicleProps.engineHealth =
                                    GetVehicleEngineHealth(vehicle)
                                vehicleProps.bodyHealth =
                                    GetVehicleBodyHealth(vehicle)

                                ESX.TriggerServerCallback('eden_garage:stockv',
                                                          function(result)
                                    if result == true then
                                        ESX.Game.DeleteVehicle(vehicle)
                                        TriggerServerEvent(
                                            'eden_garage:modifystate',
                                            vehicleProps.plate, true)
                                    end
                                end, vehicleProps)
                            end
                        end
                    end
                end
            end
        end
    end
end)
