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
- **Undefined Calls:** 2 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 11

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 19
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **invalidArg** in commands.lua:13
  - Context: if not message then return L("invalidArg") end
- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 6 |
| `MODULE.name` | Missing key | `Broadcasts` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 1 |
| `Privilege.Category` | Missing key | `broadcasts` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 11 |
| `Privilege.Category` | Missing key | `broadcasts` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 16 |
| `Privilege.Name` | Missing key | `canUseFactionBroadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 9 |
| `Privilege.Name` | Missing key | `canUseClassBroadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 14 |
| `data.desc` | Missing key | `classBroadcastTitle` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\commands.lua | 10 |
| `data.desc` | Missing key | `factionBroadcastTitle` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\commands.lua | 64 |
| `data.desc` | Unlocalized string | `Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 6 |
| `lia.flag.add:desc` | Unlocalized string | `Access to Faction Broadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 20 |
| `lia.flag.add:desc` | Unlocalized string | `Access to Class Broadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 21 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts | 0 | 0 |
