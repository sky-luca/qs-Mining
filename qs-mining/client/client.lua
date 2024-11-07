local rocks = {}
local miningActive = {}

local function spawnRocks()
    for i = 1, 10 do
        local randomOffset = vector3(math.random(-Config.MineRadius, Config.MineRadius), math.random(-Config.MineRadius, Config.MineRadius), 0)
        local rockPos = Config.MineLocation + randomOffset
        local rock = CreateObject(GetHashKey("prop_rock_4_big2"), rockPos.x, rockPos.y, rockPos.z, false, false, false)

        PlaceObjectOnGroundProperly(rock)
        FreezeEntityPosition(rock, true)

        table.insert(rocks, {object = rock, position = rockPos})

        exports.ox_target:addLocalEntity(rock, {
            {
                name = 'mine_rock_' .. i,
                event = 'mining:startMining',
                icon = 'fa-solid fa-hammer',
                label = 'Mine Rock',
                rock = rock
            }
        })
    end
end

CreateThread(function()
    local blip = AddBlipForCoord(Config.MineLocation)
    SetBlipSprite(blip, Config.Blip.Sprite)
    SetBlipColour(blip, Config.Blip.Color)
    SetBlipScale(blip, Config.Blip.Scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.Name)
    EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
    spawnRocks()
end)

RegisterNetEvent('mining:startMining', function(data)
    print("Mining started with data:", json.encode(data))

    if not data or not data.rock or not DoesEntityExist(data.rock) then
        print("Error: Invalid rock data.")
        lib.notify({
            title = "Error",
            description = "Invalid rock data.",
            type = "error",
            duration = 5000
        })
        return
    end

    local rock = data.rock
    if miningActive[rock] then 
        print("Already mining this rock.")
        lib.notify({
            title = "Warning",
            description = "You are already mining this rock.",
            type = "warning",
            duration = 5000
        })
        return 
    end

    miningActive[rock] = true  

    local playerPed = PlayerPedId()
    local playerData = ESX.GetPlayerData()

    if not playerData or not playerData.inventory then
        print("Error: Player data is invalid.")
        lib.notify({
            title = "Error",
            description = "Unable to retrieve player data.",
            type = "error",
            duration = 5000
        })
        miningActive[rock] = false
        return
    end

    local hasjackhammer = false
    for _, item in pairs(playerData.inventory) do
        if item.name == "jackhammer" and item.count > 0 then
            hasjackhammer = true
            break
        end
    end

    if not hasjackhammer then
        lib.notify({
            title = "Error",
            description = "You need a jackhammer to mine!",
            type = "error",
            duration = 5000
        })
        miningActive[rock] = false  
        return
    end


    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CONST_DRILL", 0, true)

    local progress = lib.progressCircle({
        duration = Config.MiningDuration,
        position = 'bottom', 
        label = "Mining Rocks...",  
        useWhileDead = false,
        canCancel = true,
        scenario = "WORLD_HUMAN_CONST_DRILL", 
    })

    if progress then
        ClearPedTasks(playerPed)
        TriggerServerEvent('mining:reward')

        lib.notify({
            title = "Success",
            description = "Mining successful! You received stones.",
            type = "success",
            duration = 5000
        })

        local rockIndex = nil
        for index, r in ipairs(rocks) do
            if r.object == rock then
                rockIndex = index
                break
            end
        end

        if rockIndex then
            DeleteObject(rock)
            local rockData = rocks[rockIndex]
            table.remove(rocks, rockIndex)
            respawnRock(rockData.position)
        else
            print("Error: Rock not found in rocks table.")
        end
    else
        ClearPedTasks(playerPed)
    end

    miningActive[rock] = false  
end)

function respawnRock(rockPos)
    Wait(Config.RespawnTime) 
    local respawnedRock = CreateObject(GetHashKey("prop_rock_4_big2"), rockPos.x, rockPos.y, rockPos.z, false, false, false)
    PlaceObjectOnGroundProperly(respawnedRock)
    FreezeEntityPosition(respawnedRock, true)

    exports.ox_target:addLocalEntity(respawnedRock, {
        {
            name = 'mine_rock_respawned_' .. math.random(1000, 9999),
            event = 'mining:startMining',
            icon = 'fa-solid fa-hammer',
            label = 'Mine Rock',
            rock = respawnedRock
        }
    })

    table.insert(rocks, {object = respawnedRock, position = rockPos})
end


local washingLocation = vector3(-1563.6349, 1432.6141, 116.9922)
local washingActive = {}

CreateThread(function()
    local blip = AddBlipForCoord(washingLocation)
    SetBlipSprite(blip, 478)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Stone Washing Area")
    EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = washingLocation,
        size = vec3(2.0, 2.0, 2.0),
        options = {
            {
                name = "wash_stones",
                event = "washing:startWashing",
                icon = "fa-solid fa-water",
                label = "Wash Stones",
            }
        }
    })
end)

RegisterNetEvent('washing:startWashing', function()
    local playerPed = PlayerPedId()
    local playerData = ESX.GetPlayerData()
    
    if not playerData or not playerData.inventory then
        lib.notify({
            title = "Error",
            description = "Unable to retrieve player data.",
            type = "error",
            duration = 5000
        })
        return
    end

    local amountToWash = lib.inputDialog('How many stones do you want to wash?', { { type = 'number', label = 'Number of stones' } })
    if not amountToWash or not amountToWash[1] then return end

    local amount = tonumber(amountToWash[1])
    if amount <= 0 then
        lib.notify({
            title = "Error",
            description = "Invalid number of stones.",
            type = "error",
            duration = 5000
        })
        return
    end

    local stoneCount = 0
    for _, item in ipairs(playerData.inventory) do
        if item.name == "stone" then
            stoneCount = item.count
            break
        end
    end

    if stoneCount < amount then
        lib.notify({
            title = "Error",
            description = "You don't have enough stones to wash.",
            type = "error",
            duration = 5000
        })
        return
    end

    TriggerServerEvent("washing:deductStones", amount)

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_BUM_WASH", 0, true)

    local washDuration = amount * 15000
    local progress = lib.progressCircle({
        duration = washDuration,
        position = 'bottom',
        label = "Washing Stones...",  
        useWhileDead = false,
        canCancel = true,
        scenario = "WORLD_HUMAN_BUM_WASH",
    })

    if progress then
        ClearPedTasks(playerPed)
        lib.notify({
            title = "Success",
            description = "Washing complete! You received new ores.",
            type = "success",
            duration = 5000
        })

        TriggerServerEvent("washing:rewardOres", amount)
    else
        ClearPedTasks(playerPed)
        lib.notify({
            title = "Cancelled",
            description = "Washing process cancelled.",
            type = "error",
            duration = 5000
        })
    end
end)
