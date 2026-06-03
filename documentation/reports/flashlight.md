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
- **Undefined Inferred Localization Keys:** 15

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 7
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
| `ITEM.desc` | Unlocalized string | `A standard flashlight that can be toggled.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\items\flashlight.lua | 2 |
| `ITEM.name` | Missing key | `Flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\items\flashlight.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\module.lua | 6 |
| `MODULE.name` | Missing key | `Flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\module.lua | 1 |
| `data.category` | Missing key | `flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 3 |
| `data.category` | Missing key | `flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 9 |
| `data.category` | Missing key | `flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 15 |
| `data.desc` | Missing key | `enableFlashlightDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 2 |
| `data.desc` | Missing key | `flashlightRequiresItemDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 8 |
| `data.desc` | Missing key | `flashlightCooldownDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 14 |
| `data.desc` | Unlocalized string | `A standard flashlight that can be toggled.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\items\flashlight.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\module.lua | 6 |
| `lia.config.add:name` | Missing key | `enableFlashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 1 |
| `lia.config.add:name` | Missing key | `flashlightRequiresItem` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 7 |
| `lia.config.add:name` | Missing key | `flashlightCooldown` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 13 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight | 0 | 0 |
