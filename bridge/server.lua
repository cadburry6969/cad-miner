if Config.Framework == 'esx' then

ESX = exports.es_extended:getSharedObject()

function GetSource(citizenid)
    local xPlayer = ESX.GetPlayerFromIdentifier(citizenid)
    return xPlayer.source
end

function GetIdentifer(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.identifier
end

elseif Config.Framework == 'qb' then

local QBCore = exports['qb-core']:GetCoreObject()

function GetSource(citizenid)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    return Player.PlayerData.source
end

function GetIdentifer(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.citizenid
end

end

if Config.Inventory == 'ox_inventory' then

function GetCount(src, item)
    local count = exports.ox_inventory:GetItemCount(src, item)
    return count and count
end

function AddItem(src, item, amount)
    return exports.ox_inventory:AddItem(src, item, amount)
end

function RemoveItem(src, item, amount)
    return exports.ox_inventory:RemoveItem(src, item, amount)
end

elseif Config.Inventory == 'qb-inventory' or Config.Inventory == 'ps-inventory' or Config.Inventory == 'lj-inventory' then

function GetCount(src, item)
    local items = exports[Config.Inventory]:GetItemsByName(src, item)
    return items and #items
end

function AddItem(src, item, amount)
    return exports[Config.Inventory]:AddItem(src, item, amount)
end

function RemoveItem(src, item, amount)
    return exports[Config.Inventory]:RemoveItem(src, item, amount)
end

end
