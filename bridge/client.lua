if Config.Inventory == 'ox_inventory' then

function HasItem(item, amount)
    local count = exports.ox_inventory:GetItemCount(item)
    amount = amount or 0
    return count and count > 0
end

function GetCount(item)
    local count = exports.ox_inventory:GetItemCount(item)
    return count and count
end

elseif Config.Inventory == 'qb-inventory' or Config.Inventory == 'ps-inventory' or Config.Inventory == 'lj-inventory' then

local QBCore = exports['qb-core']:GetCoreObject()

function HasItem(item, amount)
    return exports[Config.Inventory]:HasItem(item, amount)
end

function GetCount(item)
    local playerData = QBCore.Functions.GetPlayerData()
    local count = 0
    if not playerData.items then return 0 end
    for _, data in pairs(playerData.items) do
        if data.name:lower() == item:lower() then
            count = count + 1
        end
    end
    return count
end

end