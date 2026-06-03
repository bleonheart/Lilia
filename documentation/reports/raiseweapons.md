## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
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
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 10

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 2 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 2
- **Unused Hooks:** 0 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `ShouldPreventLoweredWeaponView()`
- `ShouldWeaponBeRaised()`

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
| `MODULE.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 4 |
| `MODULE.name` | Unlocalized string | `Raise Weapons` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 1 |
| `data.category` | Missing key | `animations` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 7 |
| `data.category` | Missing key | `animations` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 13 |
| `data.desc` | Unlocalized string | `Toggle whether your current weapon is raised.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\libraries\shared.lua | 4 |
| `data.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 4 |
| `data.desc` | Unlocalized string | `Whether lowered/passive weapon states should be disabled.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 6 |
| `data.desc` | Unlocalized string | `How long raising or holstering a weapon takes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 12 |
| `lia.config.add:name` | Unlocalized string | `Weapons Always Raised` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 5 |
| `lia.config.add:name` | Unlocalized string | `Weapon Toggle Time` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 11 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ShouldPreventLoweredWeaponView()`
  - `ShouldWeaponBeRaised()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons | 2 | 0 |
