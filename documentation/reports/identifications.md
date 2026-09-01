## Executive Summary

### Function Documentation
- **Total Functions:** 1
- **Documented:** 0 (0.0%)
- **Missing Functions:** 1 unique (1 total occurrences)
  - **Library Functions:** 1
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 2 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 2

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 2
- **Used Net Messages:** 2
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 10

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 1 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 1 functions

#### lia.identifications
Count: 1 functions

- `lia.identifications.generateDescription()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 2 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 2
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 2 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `getModelGender`
  - module `identifications` [standard] in `config.lua`
- `OnDescGeneratorCompleted`
  - module `identifications` [standard] in `libraries/client.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `getModelGender()`
- `OnDescGeneratorCompleted()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive identification system featuring customizable character profiles with physical attributes (age, sex, ethnicity, weight, eye/hair color, blood type), multiple regional ID card designs (California, German, Florida, New York, Southside, Yorkshire), character recognition mechanics, and interactive ID viewing/requesting functionality. Includes gender-based model filtering, persistent character data storage, and administrative ID management tools for immersive roleplaying scenarios.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\module.lua | 5 |
| `MODULE.name` | Missing key | `Identifications` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\module.lua | 3 |
| `data.category` | Missing key | `identifications` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\libraries\shared.lua | 51 |
| `data.category` | Missing key | `Identification` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\pim.lua | 3 |
| `data.category` | Missing key | `Identification` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\pim.lua | 26 |
| `data.category` | Missing key | `Identification` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\pim.lua | 57 |
| `data.category` | Missing key | `Identification` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\pim.lua | 89 |
| `data.desc` | Unlocalized string | `Selects the visual style, layout, and name pools used for ID cards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\libraries\shared.lua | 50 |
| `data.desc` | Unlocalized string | `Comprehensive identification system featuring customizable character profiles with physical attributes (age, sex, ethnicity, weight, eye/hair color, blood type), multiple regional ID card designs (California, German, Florida, New York, Southside, Yorkshire), character recognition mechanics, and interactive ID viewing/requesting functionality. Includes gender-based model filtering, persistent character data storage, and administrative ID management tools for immersive roleplaying scenarios.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\module.lua | 5 |
| `lia.config.add:name` | Unlocalized string | `ID Type` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\libraries\shared.lua | 49 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 2
- **Used Net Messages:** 2
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
| `liaCharacterDescGenerator` | `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:579` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 3
- **UI / Derma Code Outside derma:** 1

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:312` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\netcalls` | Module net handler is outside the netcalls folder |
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:318` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\netcalls` | Module net handler is outside the netcalls folder |
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/server.lua:53` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:579` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications`

### Module Documentation Report

- **Undocumented Hooks:**
  - `getModelGender()`
  - `OnDescGeneratorCompleted()`

- **Undocumented lia.* Functions:**
  - `lia.identifications.generateDescription()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications | 2 | 1 | 0 |
