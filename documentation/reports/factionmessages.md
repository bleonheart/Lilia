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
- **Defined Net Messages:** 3
- **Used Net Messages:** 3
- **Defined But Unused:** 0
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
| `MODULE.desc` | Unlocalized string | `Shows custom loadout messages when players load into a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\module.lua | 3 |
| `MODULE.name` | Missing key | `Factionmessages` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\module.lua | 1 |
| `Privilege.Category` | Unlocalized string | `Load Messages` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\module.lua | 10 |
| `Privilege.Name` | Unlocalized string | `Manage Load Messages` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\module.lua | 8 |
| `data.desc` | Unlocalized string | `Shows custom loadout messages when players load into a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\module.lua | 3 |

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
- **Net Handlers Outside netcalls:** 3
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `factionmessages` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionmessages/libraries/client.lua:103` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\netcalls` | Module net handler is outside the netcalls folder |
| `factionmessages` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionmessages/libraries/server.lua:76` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\netcalls` | Module net handler is outside the netcalls folder |
| `factionmessages` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionmessages/libraries/server.lua:81` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\netcalls` | Module net handler is outside the netcalls folder |

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
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages | 0 | 0 | 0 |
