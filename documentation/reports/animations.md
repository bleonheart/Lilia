## Executive Summary

### Function Documentation
- **Total Functions:** 4
- **Documented:** 0 (0.0%)
- **Missing Functions:** 4 unique (4 total occurrences)
  - **Library Functions:** 4
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
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 3

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 4 unique functions

### Missing Library Functions
Total: 4 functions

#### lia.anim
Count: 4 functions

- `lia.anim.getModelClass()`
- `lia.anim.getModelGender()`
- `lia.anim.getWeaponHoldType()`
- `lia.anim.setModelClass()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 3 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 3
- **Unused Hooks:** 0 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `OnPlayerEnterSequence()`
- `OnPlayerLeaveSequence()`
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
| `MODULE.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations\module.lua | 4 |
| `MODULE.name` | Missing key | `Animations` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations\module.lua | 1 |
| `data.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations\module.lua | 4 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations`

### Module Documentation Report

- **Undocumented Hooks:**
  - `OnPlayerEnterSequence()`
  - `OnPlayerLeaveSequence()`
  - `ShouldWeaponBeRaised()`

- **Undocumented lia.* Functions:**
  - `lia.anim.getModelClass()`
  - `lia.anim.getModelGender()`
  - `lia.anim.getWeaponHoldType()`
  - `lia.anim.setModelClass()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations | 3 | 4 |
