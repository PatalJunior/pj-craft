local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = nil
end)


Citizen.CreateThread(function()
    for _,v in pairs(Config.Craft) do    
     
         RequestModel(v.npcHash)
         while not HasModelLoaded(v.npcHash) do
        
           Wait(1)
         end

 
         ped =  CreatePed(4,v.npcHash, v.coords.x,v.coords.y,v.coords.z-1, 3374176, false, true)
         SetEntityHeading(ped,v.coords.w)
         FreezeEntityPosition(ped, true)
         SetEntityInvincible(ped, true)

         exports['qb-target']:AddEntityZone('craft-ped', ped, {
            name = 'craft-ped',
            debugPoly = false,
        }, {
            options = {
                {
                    icon = 'fas fa-wrench',
                    label = "Craft",
                    action = function()
                        QBCore.Functions.TriggerCallback("pj-craft:callback:items", function(data)
                            QBCore.Functions.TriggerCallback('pj-craft:callback:getxP', function(xp,time)
                                PlayerData = QBCore.Functions.GetPlayerData()
                                SetNuiFocus(true,true)
                                SendNUIMessage({
                                    type = "SET_DATA",
                                    data = Config.CraftItem,
                                    categories = Config.Categories,
                                    xp = xp,
                                    sunucusaati = time,
                                    playerinventory = PlayerData.items,
                                    imageFolder = Config.ImageFolder
                                })
                            end)
                        end)
                    end,
                }
            },
            distance = 1.5,
        })

         SetBlockingOfNonTemporaryEvents(ped, true)
   end

end)



RegisterNUICallback('sendItem', function(data)
    local itemName = data.weaponName
    local craftTime = tonumber(data.weaponMinute)
    local itemLabel = data.weaponLabel
    local itemList = data.itemName
    local craftXp = tonumber(data.xpweapon)
    TriggerServerEvent('pj-craft:server:sendItem',itemName,craftTime,itemLabel,itemList,craftXp)
end)

RegisterNUICallback('escape', function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('claimitem', function(data)
    local item =  data.claimitem
    local itemid = tonumber(data.claimid)
    TriggerServerEvent('pj-craft:server:addItem',item,itemid)
end)

RegisterNUICallback('getAwating', function(data,cb)
    QBCore.Functions.TriggerCallback('pj-craft:callback:getData', function(data)
       
        SendNUIMessage({
            type = "AWAITING_DATA",
            sqldata = data
        })
    end)
end)    



RegisterNetEvent('pj-craft:client:refreshPageAwating', function()
    QBCore.Functions.TriggerCallback('pj-craft:callback:getData', function(data)
       
        SendNUIMessage({
            type = "AWAITING_DATA",
            sqldata = data
        })
    end)
end)



RegisterNetEvent("pj-caft:Notify", function(message, type, time)
    SendNUIMessage({
        type = "send_notification",
        message = message,
        notifytype = type,
        time = time,
    })
end)