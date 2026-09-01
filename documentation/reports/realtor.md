## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 1 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 1

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 4
- **Used Net Messages:** 2
- **Defined But Unused:** 2
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 5

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
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 1
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 1 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `OnPropertyDataReceived`
  - module `realtor` [standard] in `libraries/client.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `OnPropertyDataReceived()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive property creation and management system featuring a specialized Property Creator weapon for intuitive door selection. Supports temporary rentals with daily pricing and permanent faction-owned properties with database persistence, preview positioning, and multi-door property compilation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\module.lua | 7 |
| `MODULE.name` | Missing key | `Realtor` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\module.lua | 5 |
| `Privilege.Category` | Unlocalized string | `Lilia - Realtor` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\entities\weapons\lia_property_creator\shared.lua | 5 |
| `data.desc` | Unlocalized string | `Comprehensive property creation and management system featuring a specialized Property Creator weapon for intuitive door selection. Supports temporary rentals with daily pricing and permanent faction-owned properties with database persistence, preview positioning, and multi-door property compilation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\module.lua | 7 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\entities\weapons\lia_property_creator\shared.lua | 2 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 4
- **Used Net Messages:** 2
- **Defined But Unused:** 2
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
- **Net Handlers Outside netcalls:** 1
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `realtor` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/realtor/libraries/server.lua:64` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor`

### Module Documentation Report

- **Undocumented Hooks:**
  - `OnPropertyDataReceived()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor | 1 | 0 | 0 |
