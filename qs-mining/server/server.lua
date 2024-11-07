

local function giveReward(playerId, item, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)


    if xPlayer.getInventoryItem("jackhammer").count > 0 then

        xPlayer.addInventoryItem("stone", amount)

        if rewardAmount > 0 then
            xPlayer.addInventoryItem("stone", rewardAmount)


            TriggerClientEvent('lib.notify', playerId, {
                id = 'reward_' .. playerId, 
                title = "Success",
                description = "You received " .. rewardAmount .. " stone(s)!",
                type = "success",
                duration = 5000
            })
        else

            TriggerClientEvent('lib.notify', playerId, {
                id = 'error_inventory_full_' .. playerId,
                title = "Error",
                description = "You cannot hold more stones in your inventory!",
                type = "error",
                duration = 5000
            })
        end
    else

        TriggerClientEvent('lib.notify', playerId, {
            id = 'error_no_jackhammer_' .. playerId,
            title = "Error",
            description = "You need a jackhammer to mine!",
            type = "error",
            duration = 5000
        })
    end
end


RegisterNetEvent("mining:reward")
AddEventHandler("mining:reward", function()
    local playerId = source
    local amount = math.random(1, 4)  
    giveReward(playerId, "stone", amount)
end)




RegisterNetEvent("washing:deductStones")
AddEventHandler("washing:deductStones", function(amount)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)


    local stoneCount = xPlayer.getInventoryItem("stone").count
    if stoneCount < amount then
        TriggerClientEvent('lib.notify', playerId, {
            id = 'error_not_enough_stones',
            title = "Error",
            description = "You don't have enough stones to wash.",
            type = "error",
            duration = 5000
        })
        return
    end


    xPlayer.removeInventoryItem("stone", amount)


    TriggerClientEvent('lib.notify', playerId, {
        id = 'stone_deduction',
        title = "Stones Removed",
        description = "You have removed " .. amount .. " stone(s) for washing.",
        type = "success",
        duration = 5000
    })
end)


RegisterNetEvent("washing:rewardOres")
AddEventHandler("washing:rewardOres", function(amount)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)


    local ores = { "copper_ore", "iron_ore", "gold_ore", "crystal_ore", "platinum_ore" }
    local totalReward = 0
    for i = 1, amount do
        local randomOre = ores[math.random(1, #ores)]
        local randomAmount = math.random(1, 3)
        xPlayer.addInventoryItem(randomOre, randomAmount)
        totalReward = totalReward + randomAmount
    end


    TriggerClientEvent('lib.notify', playerId, {
        id = 'reward_ores_' .. playerId,
        title = "Reward",
        description = "You received " .. totalReward .. " ores from washing your stones.",
        type = "success",
        duration = 5000
    })
end)
