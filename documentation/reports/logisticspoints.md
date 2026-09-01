## Executive Summary

### Function Documentation
- **Total Functions:** 30
- **Documented:** 0 (0.0%)
- **Missing Functions:** 30 unique (30 total occurrences)
  - **Library Functions:** 30
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
- **Defined Net Messages:** 7
- **Used Net Messages:** 7
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 8

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 30 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 30 functions

#### lia.resourcesystem
Count: 30 functions

- `lia.resourcesystem.addLP()`
- `lia.resourcesystem.addLog()`
- `lia.resourcesystem.buildState()`
- `lia.resourcesystem.calculateDepositLP()`
- `lia.resourcesystem.canPurchaseReward()`
- `lia.resourcesystem.canSpendLP()`
- `lia.resourcesystem.depositResource()`
- `lia.resourcesystem.getAverageResourceDemand()`
- `lia.resourcesystem.getAverageResourceSupply()`
- `lia.resourcesystem.getLP()`
- `lia.resourcesystem.getLogPage()`
- `lia.resourcesystem.getLogs()`
- `lia.resourcesystem.getNodeResourceField()`
- `lia.resourcesystem.getResourceChoices()`
- `lia.resourcesystem.getResourceDemand()`
- `lia.resourcesystem.getResourceIDFromItem()`
- `lia.resourcesystem.getStoredResources()`
- `lia.resourcesystem.getSupplyDemandMultiplier()`
- `lia.resourcesystem.initializePersistence()`
- `lia.resourcesystem.openDepot()`
- `lia.resourcesystem.purchaseReward()`
- `lia.resourcesystem.registerNode()`
- `lia.resourcesystem.registerResource()`
- `lia.resourcesystem.registerReward()`
- `lia.resourcesystem.removeResourceItems()`
- `lia.resourcesystem.sendLogPage()`
- `lia.resourcesystem.setLP()`
- `lia.resourcesystem.setLogs()`
- `lia.resourcesystem.setStoredResources()`
- `lia.resourcesystem.syncState()`

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
| `MODULE.desc` | Unlocalized string | `Server-wide logistics economy with dynamic supply and demand LP values, depot deposits, reward purchasing, and F1 visibility.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\module.lua | 8 |
| `MODULE.name` | Missing key | `Logisticspoints` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\module.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\entities\entities\lia_resource_depot\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Logistics` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\entities\entities\lia_resource_node\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Logistics` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\libraries\shared.lua | 241 |
| `Privilege.Category` | Missing key | `logisticsPointSystem` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\module.lua | 19 |
| `Privilege.Name` | Missing key | `spendLogisticsPoints` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\module.lua | 17 |
| `data.desc` | Unlocalized string | `Server-wide logistics economy with dynamic supply and demand LP values, depot deposits, reward purchasing, and F1 visibility.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\module.lua | 8 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 7
- **Used Net Messages:** 7
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
- **Net Handlers Outside netcalls:** 7
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/client.lua:351` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/client.lua:352` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/client.lua:363` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:351` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:352` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:357` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:389` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.resourcesystem.addLog()`
  - `lia.resourcesystem.addLP()`
  - `lia.resourcesystem.buildState()`
  - `lia.resourcesystem.calculateDepositLP()`
  - `lia.resourcesystem.canPurchaseReward()`
  - `lia.resourcesystem.canSpendLP()`
  - `lia.resourcesystem.depositResource()`
  - `lia.resourcesystem.getAverageResourceDemand()`
  - `lia.resourcesystem.getAverageResourceSupply()`
  - `lia.resourcesystem.getLogPage()`
  - `lia.resourcesystem.getLogs()`
  - `lia.resourcesystem.getLP()`
  - `lia.resourcesystem.getNodeResourceField()`
  - `lia.resourcesystem.getResourceChoices()`
  - `lia.resourcesystem.getResourceDemand()`
  - `lia.resourcesystem.getResourceIDFromItem()`
  - `lia.resourcesystem.getStoredResources()`
  - `lia.resourcesystem.getSupplyDemandMultiplier()`
  - `lia.resourcesystem.initializePersistence()`
  - `lia.resourcesystem.openDepot()`
  - `lia.resourcesystem.purchaseReward()`
  - `lia.resourcesystem.registerNode()`
  - `lia.resourcesystem.registerResource()`
  - `lia.resourcesystem.registerReward()`
  - `lia.resourcesystem.removeResourceItems()`
  - `lia.resourcesystem.sendLogPage()`
  - `lia.resourcesystem.setLogs()`
  - `lia.resourcesystem.setLP()`
  - `lia.resourcesystem.setStoredResources()`
  - `lia.resourcesystem.syncState()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints | 0 | 30 | 0 |
