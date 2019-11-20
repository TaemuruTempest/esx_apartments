ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Check if membership already exists
ESX.RegisterServerCallback('esx_apartments:getApartments', function(source, cb)
    local available = MySQL.Sync.fetchAll("SELECT * FROM apartments_available")
    cb(available)
end)
