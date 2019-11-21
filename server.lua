ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Check if membership already exists
ESX.RegisterServerCallback('esx_apartments:getProperties', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local available = MySQL.Sync.fetchAll('SELECT * FROM apartments_available')
    local users = MySQL.Sync.fetchAll(
                      'SELECT apartment_id FROM users WHERE identifier = @identifier',
                      {['@identifier'] = xPlayer.getIdentifier()})

    -- assign owned properties to available
    local owned = MySQL.Sync.fetchAll(
                      'SELECT apartment_id, rented FROM apartments_owned WHERE owner = @owner',
                      {['@owner'] = xPlayer.getIdentifier()})
    for k, property in pairs(available) do
        available[k].owned = false
        available[k].rented = false

        for _, v in pairs(owned) do
            if v.apartment_id == property.id then
                available[k].owned = true
                available[k].rented = v.rented
            end
        end
    end
    cb(available, users[1].apartment_id)
end)

-- Rent/Buy specified property
RegisterServerEvent('esx_apartments:assignProperty')
AddEventHandler('esx_apartments:assignProperty', function(id, rented)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    -- Check if this property is already owned/rented
    local result = MySQL.Sync.fetchAll(
                       'SELECT id, rented FROM apartments_owned WHERE owner = @identifier AND apartment_id = @apartment_id',
                       {['@identifier'] = identifier, ['@apartment_id'] = id})
    if #result > 0 then
        -- if we have already rented this property and the current option is to buy
        -- substract money and update the rented flag
        if result[1].rented == 1 and rented == 0 then
            --
        end

        return
    end

    -- TODO: check and substract money

    -- Set apartment owner
    MySQL.Async.insert(
        'INSERT INTO apartments_owned (apartment_id, owner, price, rented) VALUES (@apartment_id, @owner, @price, @rented)',
        {
            ['@apartment_id'] = id,
            ['@owner'] = identifier,
            ['@price'] = 1, -- TODO: get rent/buy price
            ['@rented'] = rented
        }, function()
            xPlayer.showNotification('Thank you for shopping with us')
        end)
end)

-- Sell specified property
RegisterServerEvent('esx_apartments:unassignProperty')
AddEventHandler('esx_apartments:unassignProperty', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    -- Check if this property is already owned/rented
    local result = MySQL.Sync.fetchAll(
                       'SELECT id, rented FROM apartments_owned WHERE owner = @identifier AND apartment_id = @apartment_id',
                       {['@identifier'] = identifier, ['@apartment_id'] = id})
    if #result > 0 then
        -- TODO: if owned, return defined sell_back % to player
        if result[1].rented == 0 then end

        MySQL.Sync.execute(
            'DELETE FROM apartments_owned WHERE owner = @identifier AND apartment_id = @apartment_id',
            {['@identifier'] = identifier, ['@apartment_id'] = id})
    end
end)

ESX.RegisterServerCallback('esx_apartments:getCurrentApartment',
                           function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll(
        'SELECT apartment_id FROM users WHERE identifier = @identifier',
        {['@identifier'] = xPlayer.getIdentifier()},
        function(result) cb(result[1].apartment_id) end)
end)

RegisterServerEvent('esx_apartments:setCurrentApartment')
AddEventHandler('esx_apartments:setCurrentApartment', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute(
        'UPDATE users SET apartment_id = @apartment_id WHERE identifier = @identifier',
        {['@apartment_id'] = id, ['@identifier'] = xPlayer.getIdentifier()})
end)

RegisterServerEvent('esx_apartments:unsetCurrentApartment')
AddEventHandler('esx_apartments:unsetCurrentApartment', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute(
        'UPDATE users SET apartment_id = NULL WHERE identifier = @identifier',
        {['@identifier'] = xPlayer.getIdentifier()})
end)
