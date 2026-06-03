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
- **Module Key Conflicts:** 1 keys
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
| `MODULE.desc` | Unlocalized string | `Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\module.lua | 6 |
| `MODULE.name` | Unlocalized string | `Auto Restarter` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\module.lua | 1 |
| `data.category` | Missing key | `general` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 9 |
| `data.desc` | Missing key | `serverRestartIntervalSecondsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 8 |
| `data.desc` | Missing key | `restartCountdownFontDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 16 |
| `data.desc` | Unlocalized string | `Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\module.lua | 6 |
| `lia.config.add:name` | Missing key | `serverRestartIntervalSeconds` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 1 |
| `lia.config.add:name` | Missing key | `restartCountdownFont` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 15 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter | 0 | 0 |
