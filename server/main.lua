local QBCore = exports['qb-core']:GetCoreObject()

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    
    exports.oxmysql:execute(query, function(data)
        result = data
        IsBusy = false
    end)

    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

RegisterServerEvent('pj-craft:server:sendItem', function(itemName, craftTime, itemLabel, _itemList, craftXp)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local identifier = xPlayer.PlayerData.citizenid
    local time = os.time()
    local itemList = json.decode(_itemList)
    local success = true

    local hasItems = true
    for k, v in pairs(itemList) do
        if not QBCore.Functions.HasItem(src, v.name, tonumber(v.amount)) then
            hasItems = false
            break
        end
    end

    
    if hasItems then

        for k, v in pairs(itemList) do
            xPlayer.Functions.RemoveItem(v.name, tonumber(v.amount), false)
        end

        local data = ExecuteSql("INSERT INTO `pj_craft` (`identifier`,`itemName`,`craftTime`,`itemLabel`,`craftStartTime`) VALUES ('" ..identifier .. "','" .. itemName .. "','" .. craftTime .. "','" .. itemLabel .. "','" .. time .. "')")
        
        local JobReputation = xPlayer.PlayerData.metadata["jobrep"] or {}
        JobReputation["crafting"] = JobReputation["crafting"] or 0
        JobReputation["crafting"] = tonumber(JobReputation["crafting"] + craftXp)
        
        xPlayer.Functions.SetMetaData("jobrep", JobReputation)
        TriggerClientEvent("pj-caft:Notify", src, Config.Notifications["success"]["message"],Config.Notifications["success"]["type"], Config.Notifications["success"]["time"])

    else
        TriggerClientEvent("pj-caft:Notify", src, Config.Notifications["error"]["message"],Config.Notifications["error"]["type"], Config.Notifications["error"]["time"])
    end

end)


RegisterServerEvent('pj-craft:server:addItem', function(itemName, id)
        local src = source
        local xPlayer = QBCore.Functions.GetPlayer(src)

        if not (itemName and id) then return end

        xPlayer.Functions.AddItem(itemName, 1)

        ExecuteSql("DELETE FROM `pj_craft` WHERE `id` = '" .. id .. "'")
        TriggerClientEvent('pj-craft:client:refreshPageAwating', src)

end)

Citizen.CreateThread(function()

        QBCore.Functions.CreateCallback('pj-craft:callback:getData', function(source, cb)
            local xPlayer = QBCore.Functions.GetPlayer(source)
            local identifier = xPlayer.PlayerData.citizenid

            local item = ExecuteSql("SELECT * FROM pj_craft WHERE identifier = '" .. identifier .. "'")
            if item then
                cb(item)
            end
        end)

end)

Citizen.CreateThread(function()
        QBCore.Functions.CreateCallback('pj-craft:callback:getxP', function(source, cb)
            local xPlayer = QBCore.Functions.GetPlayer(source)
            cb(xPlayer.PlayerData.metadata["jobrep"]['crafting'] or 0, os.time())
        end)

end)

QBCore.Functions.CreateCallback('pj-craft:callback:items', function(source, cb)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    cb(xPlayer.PlayerData.items)
end)
