-- config.lua
Config = {}

-- Mining location and radius
Config.MineLocation = vector3(2947.2007, 2794.8191, 40.6732)
Config.MineRadius = 17.0


Config.MiningDuration = 20000           -- Mining duration in ms (20 seconds)
Config.RespawnTime = 25000              -- Respawn time for rocks in ms (25 seconds)

-- Progress Bar
Config.ProgressLabel = "Mining Rock..."

-- Blip settings
Config.Blip = {
    Sprite = 618,
    Color = 1,
    Scale = 0.8,
    Name = "Mining Area"
}


-- Washing location
Config.WashingLocation = vector3(-1563.6349, 1432.6141, 116.9922)  
Config.WashingRadius = 2.0  


-- Blip settings for washing area
Config.WashingBlip = {
    Sprite = 478,
    Color = 2,
    Scale = 0.8,
    Name = "Stone Washing Area"
}

-- Progress bar settings
Config.ProgressLabel = "Washing Stones..."

-- Random ores
Config.Ores = { "copper_ore", "iron_ore", "gold_ore", "crystal_ore", "platinum_ore" }