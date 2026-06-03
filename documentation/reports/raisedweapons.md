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
- **Undefined Calls:** 1 unique
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
- **Undefined Inferred Localization Keys:** 8

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 3
- **Undefined Calls:** 1
- **Argument Mismatch:** 0

### Undefined Calls

- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\module.lua | 6 |
| `MODULE.name` | Unlocalized string | `Raised Weapons` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\module.lua | 1 |
| `data.desc` | Missing key | `toggleRaiseDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\commands.lua | 4 |
| `data.desc` | Missing key | `weaponRaiseSpeedDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\config.lua | 2 |
| `data.desc` | Unlocalized string | `Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\module.lua | 6 |
| `lia.config.add:name` | Missing key | `weaponRaiseSpeed` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\config.lua | 1 |
| `lia.option.add:desc` | Unlocalized string | `Enable or disable the alternate weapon lowering angles.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\libraries\client.lua | 1 |
| `lia.option.add:name` | Unlocalized string | `Use Alternate Lowering` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\libraries\client.lua | 1 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons | 0 | 0 |
