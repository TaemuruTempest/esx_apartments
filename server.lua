ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetPropertyById(id)
    local properties = MySQL.Sync.fetchAll(
                           'SELECT * FROM apartments_available WHERE id = @id',
                           {['@id'] = id})
    return properties[1]
end

-- Check if membership already exists
ESX.RegisterServerCallback('esx_apartments:getProperties', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local available = MySQL.Sync.fetchAll(
                          'SELECT * FROM apartments_available ORDER BY name')
    local users = MySQL.Sync.fetchAll(
                      'SELECT apartment_id FROM users WHERE identifier = @identifier',
                      {['@identifier'] = xPlayer.getIdentifier()})

    local owned = MySQL.Sync.fetchAll(
                      'SELECT apartment_id, rented FROM apartments_owned WHERE owner = @owner',
                      {['@owner'] = xPlayer.getIdentifier()})

    local last_property

    for k, property in pairs(available) do
        available[k].owned = false
        available[k].rented = false
        available[k].parent = 0

        -- assign owned properties to available
        for _, v in pairs(owned) do
            if v.apartment_id == property.id then
                available[k].owned = true
                available[k].rented = v.rented
            end
        end

        -- check if property is a child of previous property
        if last_property ~= nil and last_property.name == property.name then
            available[k].parent = last_property.id
        end

        if last_property == nil or last_property.name ~= property.name then
            last_property = property
        end
    end
    cb(available, users[1].apartment_id)
end)

-- Rent/Buy specified property
ESX.RegisterServerCallback('esx_apartments:assignProperty',
                           function(source, cb, id, rented, payment_method)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    -- Check if this property is already owned/rented
    local result = MySQL.Sync.fetchAll(
                       'SELECT id, rented FROM apartments_owned WHERE owner = @identifier AND apartment_id = @apartment_id',
                       {['@identifier'] = identifier, ['@apartment_id'] = id})
    if #result > 0 then return end

    -- get property
    local property = GetPropertyById(id)

    -- check and substract money
    if rented == false then
        local playerMoney = 0
        if payment_method == 'cash' then playerMoney = xPlayer.getMoney() end
        if payment_method == 'bank' then playerMoney = xPlayer.getBank() end
        if playerMoney < property.price_buy then
            cb(false)
            return
        end

        if payment_method == 'cash' then
            xPlayer.removeMoney(property.price_buy)
        end
        if payment_method == 'bank' then
            xPlayer.removeAccountMoney('bank', property.price_buy)
        end
    end

    -- Set apartment owner
    MySQL.Async.insert(
        'INSERT INTO apartments_owned (apartment_id, owner, price, rented) VALUES (@apartment_id, @owner, @price, @rented)',
        {
            ['@apartment_id'] = id,
            ['@owner'] = identifier,
            ['@price'] = rented == true and property.price_rent or
                property.price_buy,
            ['@rented'] = rented
        }, function()
            xPlayer.showNotification('Thank you for shopping with us')
        end)

    cb(true)
end)

-- Sell specified property
RegisterServerEvent('esx_apartments:unassignProperty')
AddEventHandler('esx_apartments:unassignProperty', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    -- Check if this property is owned/rented
    local result = MySQL.Sync.fetchAll(
                       'SELECT id, price, rented FROM apartments_owned WHERE owner = @identifier AND apartment_id = @apartment_id',
                       {['@identifier'] = identifier, ['@apartment_id'] = id})
    if #result > 0 then
        local property = GetPropertyById(id)

        -- if owned, return defined sell_back % to player
        if result[1].rented == false and property.cash_back > 0 then
            xPlayer.addAccountMoney('bank', result[1].price *
                                        (property.cash_back / 100.0))
        end

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
