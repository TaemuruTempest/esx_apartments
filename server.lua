ESX = nil

TriggerEvent(
    'esx:getSharedObject',
    function(obj)
        ESX = obj
    end
)

-- Check if membership already exists
ESX.RegisterServerCallback(
    'esx_apartments:getProperties',
    function(source, cb)
        local available = MySQL.Sync.fetchAll('SELECT * FROM apartments_available')
        cb(available)
    end
)

-- Rent/Sell specified property
RegisterServerEvent('esx_apartments:assignProperty')
AddEventHandler(
    'esx_apartments:assignProperty',
    function(id, rented)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.getIdentifier()

        -- Check if this property is already owned/rented
        local result = MySQL.Sync.fetchAll('SELECT id, rented FROM apartments_owned WHERE owner = @identifier AND apartment_id = @apartment_id', {['@identifier'] = identifier, ['@apartment_id'] = id})
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
            },
            function()
                xPlayer.showNotification('Thank you for shopping with us')
            end
        )
    end
)
