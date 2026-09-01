## Executive Summary

### Function Documentation
- **Total Functions:** 25
- **Documented:** 0 (0.0%)
- **Missing Functions:** 25 unique (25 total occurrences)
  - **Library Functions:** 25
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
- **Defined Net Messages:** 1
- **Used Net Messages:** 2
- **Defined But Unused:** 0
- **Used But Undefined:** 1

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 35

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 25 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 25 functions

#### lia.cardealer
Count: 25 functions

- `lia.cardealer.addGarage()`
- `lia.cardealer.checkVehicleRequirements()`
- `lia.cardealer.getAllGarages()`
- `lia.cardealer.getData()`
- `lia.cardealer.getNPCCategorySelection()`
- `lia.cardealer.getNearestAvailableGarage()`
- `lia.cardealer.getNearestGarage()`
- `lia.cardealer.getOwnedCars()`
- `lia.cardealer.getRestrictedFactionNames()`
- `lia.cardealer.getRestrictedFactions()`
- `lia.cardealer.getVehicleCategories()`
- `lia.cardealer.getVehicleCategory()`
- `lia.cardealer.getVehicleModel()`
- `lia.cardealer.getVehiclesForNPC()`
- `lia.cardealer.hasValidModel()`
- `lia.cardealer.loadDataFromDisk()`
- `lia.cardealer.loadStoredGarages()`
- `lia.cardealer.normalizeCategorySelection()`
- `lia.cardealer.npcAllowsVehicle()`
- `lia.cardealer.openCategoryConfigUI()`
- `lia.cardealer.registerVehicle()`
- `lia.cardealer.removeGarage()`
- `lia.cardealer.renameGarage()`
- `lia.cardealer.repairVehicleByID()`
- `lia.cardealer.saveData()`

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
| `FACTION.desc` | Unlocalized string | `A Car Fixing` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\factions\mechanics.lua | 2 |
| `FACTION.name` | Missing key | `Mechanics` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\factions\mechanics.lua | 1 |
| `MODULE.desc` | Unlocalized string | `A comprehensive vehicle management system that provides NPC-based vehicle purchasing, ownership tracking, and maintenance services. Features include interactive dealer NPCs for vehicle sales with configurable pricing, vehicle return and repair systems with fee-based services, custom paint jobs and bodygroup modifications with individual pricing, secure garage storage for owned vehicles, full integration with popular driving addons, administrative privileges for staff vehicle access, and persistent vehicle ownership data across server restarts.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\module.lua | 7 |
| `MODULE.name` | Missing key | `Cardealer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\module.lua | 5 |
| `Privilege.Category` | Missing key | `Misc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\definitions.lua | 4 |
| `Privilege.Category` | Missing key | `Standard` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\definitions.lua | 14 |
| `Privilege.Category` | Missing key | `Military` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\definitions.lua | 24 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\entities\entities\lia_garage\shared.lua | 6 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\module.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Couch Car` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\definitions.lua | 2 |
| `Privilege.Name` | Missing key | `Dukes` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\definitions.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Combine APC` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\definitions.lua | 22 |
| `Privilege.Name` | Unlocalized string | `Access Any Car` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\module.lua | 10 |
| `data.category` | Missing key | `categoryLiliaGeneral` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\client.lua | 1518 |
| `data.category` | Unlocalized string | `Car Dealer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 210 |
| `data.category` | Unlocalized string | `Car Dealer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 219 |
| `data.category` | Unlocalized string | `Car Dealer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 228 |
| `data.category` | Unlocalized string | `Car Dealer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 237 |
| `data.desc` | Unlocalized string | `A Car Fixing` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\factions\mechanics.lua | 2 |
| `data.desc` | Unlocalized string | `Open the car dealer buy menu.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\client.lua | 1507 |
| `data.desc` | Unlocalized string | `Open the garage management interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\client.lua | 1513 |
| `data.desc` | Unlocalized string | `Open the garage management interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\server.lua | 1335 |
| `data.desc` | Unlocalized string | `Open the garage management interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\server.lua | 1346 |
| `data.desc` | Missing key | `carDealerInactivityTimerDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 214 |
| `data.desc` | Missing key | `cardealerGarageMaxDistanceDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 223 |
| `data.desc` | Missing key | `carDealerTrunkInvWDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 232 |
| `data.desc` | Missing key | `carDealerTrunkInvHDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 241 |
| `data.desc` | Unlocalized string | `A comprehensive vehicle management system that provides NPC-based vehicle purchasing, ownership tracking, and maintenance services. Features include interactive dealer NPCs for vehicle sales with configurable pricing, vehicle return and repair systems with fee-based services, custom paint jobs and bodygroup modifications with individual pricing, secure garage storage for owned vehicles, full integration with popular driving addons, administrative privileges for staff vehicle access, and persistent vehicle ownership data across server restarts.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\module.lua | 7 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\entities\entities\lia_garage\shared.lua | 5 |
| `lia.config.add:name` | Missing key | `carDealerInactivityTimer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 209 |
| `lia.config.add:name` | Missing key | `cardealerGarageMaxDistance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 218 |
| `lia.config.add:name` | Missing key | `carDealerTrunkInvW` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 227 |
| `lia.config.add:name` | Missing key | `carDealerTrunkInvH` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\shared.lua | 236 |
| `lia.option.add:desc` | Unlocalized string | `Display spheres showing the maximum garage distance from car dealer NPCs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\client.lua | 1517 |
| `lia.option.add:name` | Unlocalized string | `Show Garage Distance Spheres` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\libraries\client.lua | 1517 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 1
- **Used Net Messages:** 2
- **Defined But Unused:** 0
- **Used But Undefined:** 1

### Used But Undefined

- `liaJobNpcCloseDialog`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:852; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:908; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1420

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

Total suspicious patterns: **1**

- `liaJobNpcCloseDialog`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:852; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:908; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1420; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1550; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1606
  - Receiver sites: None

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 1
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 1
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `liaFramePlain` | `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/client.lua:10` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 2
- **UI / Derma Code Outside derma:** 1

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/client.lua:1549` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\netcalls` | Module net handler is outside the netcalls folder |
| `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:569` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/client.lua:10` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.cardealer.addGarage()`
  - `lia.cardealer.checkVehicleRequirements()`
  - `lia.cardealer.getAllGarages()`
  - `lia.cardealer.getData()`
  - `lia.cardealer.getNearestAvailableGarage()`
  - `lia.cardealer.getNearestGarage()`
  - `lia.cardealer.getNPCCategorySelection()`
  - `lia.cardealer.getOwnedCars()`
  - `lia.cardealer.getRestrictedFactionNames()`
  - `lia.cardealer.getRestrictedFactions()`
  - `lia.cardealer.getVehicleCategories()`
  - `lia.cardealer.getVehicleCategory()`
  - `lia.cardealer.getVehicleModel()`
  - `lia.cardealer.getVehiclesForNPC()`
  - `lia.cardealer.hasValidModel()`
  - `lia.cardealer.loadDataFromDisk()`
  - `lia.cardealer.loadStoredGarages()`
  - `lia.cardealer.normalizeCategorySelection()`
  - `lia.cardealer.npcAllowsVehicle()`
  - `lia.cardealer.openCategoryConfigUI()`
  - `lia.cardealer.registerVehicle()`
  - `lia.cardealer.removeGarage()`
  - `lia.cardealer.renameGarage()`
  - `lia.cardealer.repairVehicleByID()`
  - `lia.cardealer.saveData()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer | 0 | 25 | 0 |
