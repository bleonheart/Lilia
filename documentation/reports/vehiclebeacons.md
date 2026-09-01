## Executive Summary

### Function Documentation
- **Total Functions:** 13
- **Documented:** 0 (0.0%)
- **Missing Functions:** 13 unique (13 total occurrences)
  - **Library Functions:** 13
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
- **Defined Net Messages:** 4
- **Used Net Messages:** 4
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 39

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 13 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 13 functions

#### lia.vehiclebeacons
Count: 13 functions

- `lia.vehiclebeacons.checkVehicleRequirements()`
- `lia.vehiclebeacons.getDeploymentTime()`
- `lia.vehiclebeacons.getDespawnTime()`
- `lia.vehiclebeacons.getGroundedVehiclePosition()`
- `lia.vehiclebeacons.getResolvedVehicleClass()`
- `lia.vehiclebeacons.getRestrictedFactionNames()`
- `lia.vehiclebeacons.getRestrictedFactions()`
- `lia.vehiclebeacons.getVehicleData()`
- `lia.vehiclebeacons.getVehicleModel()`
- `lia.vehiclebeacons.isLFSVehicle()`
- `lia.vehiclebeacons.isSimfphysVehicle()`
- `lia.vehiclebeacons.registerVehicle()`
- `lia.vehiclebeacons.validatePlacement()`

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
| `ITEM.desc` | Unlocalized string | `A base item for faction vehicle deployment beacons.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\items\base\vehicle_beacon.lua | 2 |
| `ITEM.name` | Unlocalized string | `Vehicle Beacon Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\items\base\vehicle_beacon.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Faction-based in-world vehicle deployment beacons with ghost placement, secure validation, and support for Source and simfphys vehicle spawning.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\module.lua | 8 |
| `MODULE.name` | Missing key | `Vehiclebeacons` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\module.lua | 6 |
| `Privilege.Category` | Missing key | `Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 3 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 / Synergy` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 11 |
| `Privilege.Category` | Missing key | `Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 17 |
| `Privilege.Category` | Missing key | `Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 23 |
| `Privilege.Category` | Missing key | `Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 29 |
| `Privilege.Category` | Missing key | `Civilian` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 36 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 42 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 48 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 54 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 60 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 66 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 72 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 78 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 84 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 90 |
| `Privilege.Category` | Unlocalized string | `Half Life 2 - Prewar` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 96 |
| `Privilege.Name` | Unlocalized string | `V8 Elite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 2 |
| `Privilege.Name` | Unlocalized string | `Synergy Van` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 10 |
| `Privilege.Name` | Unlocalized string | `1969 Dodge Charger` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 16 |
| `Privilege.Name` | Unlocalized string | `Mad Max Interceptor` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 22 |
| `Privilege.Name` | Unlocalized string | `Alfa Romeo Brera` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 28 |
| `Privilege.Name` | Unlocalized string | `Field Jeep` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 34 |
| `Privilege.Name` | Unlocalized string | `HL2 Hatchback` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 41 |
| `Privilege.Name` | Unlocalized string | `HL2 Van` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 47 |
| `Privilege.Name` | Unlocalized string | `HL2 Moskvich` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 53 |
| `Privilege.Name` | Unlocalized string | `HL2 Trabant` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 59 |
| `Privilege.Name` | Unlocalized string | `HL2 Trabant 2` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 65 |
| `Privilege.Name` | Unlocalized string | `HL2 Volga` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 71 |
| `Privilege.Name` | Unlocalized string | `HL2 ZAZ` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 77 |
| `Privilege.Name` | Unlocalized string | `HL2 GAZ52` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 83 |
| `Privilege.Name` | Unlocalized string | `HL2 Liaz` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 89 |
| `Privilege.Name` | Unlocalized string | `HL2 Avia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\definitions.lua | 95 |
| `data.category` | Unlocalized string | `Vehicle Beacons` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\items\base\vehicle_beacon.lua | 6 |
| `data.desc` | Unlocalized string | `A base item for faction vehicle deployment beacons.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\items\base\vehicle_beacon.lua | 2 |
| `data.desc` | Unlocalized string | `Faction-based in-world vehicle deployment beacons with ghost placement, secure validation, and support for Source and simfphys vehicle spawning.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\module.lua | 8 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 4
- **Used Net Messages:** 4
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Used But Undefined

None

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 0

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

None

### Direction / Flow Issues

Total suspicious patterns: **0**

None

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
- **Net Handlers Outside netcalls:** 5
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/client.lua:243` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/client.lua:270` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/client.lua:271` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/server.lua:663` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/server.lua:668` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.vehiclebeacons.checkVehicleRequirements()`
  - `lia.vehiclebeacons.getDeploymentTime()`
  - `lia.vehiclebeacons.getDespawnTime()`
  - `lia.vehiclebeacons.getGroundedVehiclePosition()`
  - `lia.vehiclebeacons.getResolvedVehicleClass()`
  - `lia.vehiclebeacons.getRestrictedFactionNames()`
  - `lia.vehiclebeacons.getRestrictedFactions()`
  - `lia.vehiclebeacons.getVehicleData()`
  - `lia.vehiclebeacons.getVehicleModel()`
  - `lia.vehiclebeacons.isLFSVehicle()`
  - `lia.vehiclebeacons.isSimfphysVehicle()`
  - `lia.vehiclebeacons.registerVehicle()`
  - `lia.vehiclebeacons.validatePlacement()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons | 0 | 13 | 0 |
