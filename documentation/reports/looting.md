## Executive Summary

### Function Documentation
- **Total Functions:** 5
- **Documented:** 0 (0.0%)
- **Missing Functions:** 5 unique (5 total occurrences)
  - **Library Functions:** 5
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
- **Defined Net Messages:** 3
- **Used Net Messages:** 3
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 6

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 5 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 5 functions

#### lia.loot
Count: 5 functions

- `lia.loot.checkSkillRequirements()`
- `lia.loot.generateContents()`
- `lia.loot.generateWeightedContents()`
- `lia.loot.pickWeightedItem()`
- `lia.loot.registerLoot()`

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
| `MODULE.desc` | Unlocalized string | `Lootable container system with two-panel UI. Containers generate flat item tables on chance roll. Players pick up or deposit items one at a time. Container resets timer when fully depleted.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\module.lua | 8 |
| `MODULE.name` | Missing key | `Looting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\module.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\entities\entities\lia_loot\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Lootables` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\libraries\shared.lua | 123 |
| `data.desc` | Unlocalized string | `Lootable container system with two-panel UI. Containers generate flat item tables on chance roll. Players pick up or deposit items one at a time. Container resets timer when fully depleted.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\module.lua | 8 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\libraries\shared.lua | 120 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 3
- **Used Net Messages:** 3
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
| `liaLootMenu` | `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:260` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\derma` |

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
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:312` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\netcalls` | Module net handler is outside the netcalls folder |
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:321` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\netcalls` | Module net handler is outside the netcalls folder |
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/server.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:260` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.loot.checkSkillRequirements()`
  - `lia.loot.generateContents()`
  - `lia.loot.generateWeightedContents()`
  - `lia.loot.pickWeightedItem()`
  - `lia.loot.registerLoot()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting | 0 | 5 | 0 |
