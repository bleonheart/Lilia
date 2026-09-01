## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 3 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 3

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 6
- **Used Net Messages:** 6
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 9

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 3 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 3
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 3 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `WarOperationEnded`
  - module `factionrelationships` [standard] in `libraries/server.lua`
- `WarOperationStarted`
  - module `factionrelationships` [standard] in `libraries/server.lua`
- `WarRelationChanged`
  - module `factionrelationships` [standard] in `libraries/server.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `WarOperationEnded()`
- `WarOperationStarted()`
- `WarRelationChanged()`

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
| `MODULE.desc` | Unlocalized string | `Standalone faction relation, war operation, and Derma manager system.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 5 |
| `MODULE.name` | Missing key | `Factionrelationships` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 3 |
| `Privilege.Category` | Unlocalized string | `Faction War` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 11 |
| `Privilege.Category` | Unlocalized string | `Faction War` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 16 |
| `Privilege.Name` | Unlocalized string | `Manage War Relations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 9 |
| `Privilege.Name` | Unlocalized string | `Manage War Operations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 14 |
| `data.desc` | Unlocalized string | `Opens the War Manager.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\libraries\client.lua | 1174 |
| `data.desc` | Unlocalized string | `Opens the War Manager.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\libraries\server.lua | 378 |
| `data.desc` | Unlocalized string | `Standalone faction relation, war operation, and Derma manager system.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\module.lua | 5 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 6
- **Used Net Messages:** 6
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
- **Registered Panels:** 1
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 1
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `liaWarManager` | `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1073` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 6
- **UI / Derma Code Outside derma:** 1

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1097` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1103` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:355` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:356` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:363` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:370` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1073` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships`

### Module Documentation Report

- **Undocumented Hooks:**
  - `WarOperationEnded()`
  - `WarOperationStarted()`
  - `WarRelationChanged()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships | 3 | 0 | 0 |
