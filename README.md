# qs-Mining System


A FiveM resource that provides a mining and stone-washing experience. Players can mine rocks, collect stones, and wash them to receive valuable ores. This script uses `ox_target` for interaction and `ox_lib` for progress circles and notifications.

## Features

- **Mining Rocks**: Interact with rocks in a mining area to collect stones.
- **Washing Stones**: Convert collected stones into ores at a designated washing area.
- **Progress Bars**: Displays different progress circles for mining and washing actions.
- **Inventory Management**: Requires specific items (e.g., jackhammer) for mining, checks inventory for stones before washing, and grants rewards accordingly.
- **Customizable Blips**: Blips indicate the mining and washing locations on the map.

## Requirements

- **ESX Framework**: Ensure you have ESX installed for handling player data and inventory.
- **ox_target**: For interaction points (e.g., on rocks for mining, on washing location).
- **ox_lib**: Used for progress circles, input dialogs, and notifications.

## Preview
- https://youtu.be/fWX0W6A9DBY

## Installation

1. **Download and Install Dependencies**:
   - [ESX Framework](https://github.com/esx-framework/esx_core)
   - [ox_target](https://github.com/overextended/ox_target)
   - [ox_lib](https://github.com/overextended/ox_lib)

2. **Place the Script in Resources**:
   - Clone or download this repository.
   - Place the `mining-washing` folder into your FiveM `resources` directory.

3. **Add to Server Configuration**:
   - Open your `server.cfg` file.
   - Add `ensure mining-washing` to ensure the resource starts with your server.

4. **Configure `Config.lua`**:
   - Customize the script's settings in `Config.lua` as needed, including locations, blip settings, and mining/washing durations.

## Usage

1. **Mining Rocks**:
   - Go to the mining area marked on your map.
   - Interact with rocks by pressing the `ox_target` key to start mining.
   - Ensure you have a jackhammer in your inventory. If successful, you’ll collect stones.

2. **Washing Stones**:
   - Go to the washing location marked on your map.
   - Use the `ox_target` key to start washing.
   - Input the number of stones you want to wash. Stones will be removed from your inventory, and you'll receive ores.

3. **Rewards and Notifications**:
   - Successful mining and washing provide you with stones and ores, respectively.
   - Notifications will guide you through errors (e.g., if you lack stones or a jackhammer).

## Configuration

In `Config.lua` (not shown here), you can customize:
- **Mining and Washing Locations** (`MineLocation`, `washingLocation`): Coordinates for where these actions are available.
- **Blip Settings**: Icons, colors, and labels for map markers.
- **Mining and Washing Durations**: Time taken to complete each action.
  
## Example Configuration (in `Config.lua`)

```lua
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
```

## Important Notes

- **Inventory Items**: Ensure that "jackhammer" and "stone" items exist in your ESX inventory.
- **Permission to Trigger Events**: This script assumes players have the correct permissions to trigger certain events. Adjust as needed for your server.
- **Database**: This script doesn’t store data in a database; rewards are handled in real-time.

## Contact Support:
- https://discord.gg/zXB37WgjcW
- https://www.qs-scripts.com
