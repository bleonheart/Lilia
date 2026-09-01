## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 0 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 0

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 2
- **Used Net Messages:** 2
- **Defined But Unused:** 1
- **Used But Undefined:** 1

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 11

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 0
- **Undefined Calls:** 0
- **Argument Mismatch:** 0

### Undefined Calls

- None

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `ITEM.desc` | Unlocalized string | `A crate that can spawn vehicles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\items\base\vehiclespawner.lua | 2 |
| `ITEM.name` | Unlocalized string | `Vehicle Spawner` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\items\base\vehiclespawner.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive vehicle spawning system that provides players with an interactive GUI menu to browse, purchase, and spawn various vehicles. Features include customizable car registration system, physical car crate entities, intelligent spawn positioning with collision detection, currency integration, and support for both LVS and custom vehicle classes. The system includes server-side vehicle management, client-side interface with scrollable car listings, and automatic vehicle ownership assignment through CPPI.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\module.lua | 4 |
| `MODULE.name` | Missing key | `Carspawner` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\module.lua | 2 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\entities\entities\lia_cardealer\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\entities\entities\lia_imperialcarcrate\shared.lua | 6 |
| `data.category` | Missing key | `Vehicles` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\items\base\vehiclespawner.lua | 6 |
| `data.desc` | Unlocalized string | `A crate that can spawn vehicles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\items\base\vehiclespawner.lua | 2 |
| `data.desc` | Unlocalized string | `Comprehensive vehicle spawning system that provides players with an interactive GUI menu to browse, purchase, and spawn various vehicles. Features include customizable car registration system, physical car crate entities, intelligent spawn positioning with collision detection, currency integration, and support for both LVS and custom vehicle classes. The system includes server-side vehicle management, client-side interface with scrollable car listings, and automatic vehicle ownership assignment through CPPI.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\module.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\entities\entities\lia_cardealer\shared.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\entities\entities\lia_imperialcarcrate\shared.lua | 5 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 2
- **Used Net Messages:** 2
- **Defined But Unused:** 1
- **Used But Undefined:** 1

### Used But Undefined

- `liaCarSpawnOpenMenu`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/entities/entities/lia_cardealer/init.lua:82; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:1

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 1

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

- `liaCarSpawnOpenMenu` in module `carspawner`
  - Reason: Used only by module "carspawner" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/entities/entities/lia_cardealer/init.lua:82; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:1

### Direction / Flow Issues

Total suspicious patterns: **1**

- `car_spawner_purchase`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:85
  - Receiver sites: None

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 0
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 0
- **Registered But Unused:** 0

### Module Panels Outside derma

None

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 1
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `carspawner` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner | 0 | 0 | 0 |
