## Executive Summary

### Function Documentation
- **Total Functions:** 26
- **Documented:** 0 (0.0%)
- **Missing Functions:** 26 unique (26 total occurrences)
  - **Library Functions:** 26
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 0 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 0

### Localization Analysis
- **Undefined Calls:** 3 unique
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
- **Missing Documentation:** 26 unique functions

### Missing Library Functions
Total: 26 functions

#### lia.utilities
Count: 26 functions

- `lia.utilities.blend()`
- `lia.utilities.colorCycle()`
- `lia.utilities.colorToHex()`
- `lia.utilities.currentLocalTime()`
- `lia.utilities.darken()`
- `lia.utilities.daysBetween()`
- `lia.utilities.deserializeAngle()`
- `lia.utilities.deserializeVector()`
- `lia.utilities.dprint()`
- `lia.utilities.formatTimestamp()`
- `lia.utilities.hMSToSeconds()`
- `lia.utilities.lerpColor()`
- `lia.utilities.lerpHSV()`
- `lia.utilities.lighten()`
- `lia.utilities.rainbow()`
- `lia.utilities.rgb()`
- `lia.utilities.secondsToDHMS()`
- `lia.utilities.serializeAngle()`
- `lia.utilities.serializeVector()`
- `lia.utilities.spawnEntities()`
- `lia.utilities.spawnProp()`
- `lia.utilities.speedTest()`
- `lia.utilities.timeDifference()`
- `lia.utilities.timeUntil()`
- `lia.utilities.toText()`
- `lia.utilities.weekdayName()`

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 5
- **Undefined Calls:** 3
- **Argument Mismatch:** 0

### Undefined Calls

- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"
- **invalidDate** in libs\sh_utils.lua:107
  - Context: if not h then return L("invalidDate") end
- **invalidEntityPosition** in libs\sh_utils.lua:403
  - Context: lia.information(L("invalidEntityPosition"), class)

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\module.lua | 6 |
| `MODULE.name` | Unlocalized string | `Code Utilities` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\module.lua | 1 |
| `data.desc` | Unlocalized string | `Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\module.lua | 6 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.utilities.blend()`
  - `lia.utilities.colorCycle()`
  - `lia.utilities.colorToHex()`
  - `lia.utilities.currentLocalTime()`
  - `lia.utilities.darken()`
  - `lia.utilities.daysBetween()`
  - `lia.utilities.deserializeAngle()`
  - `lia.utilities.deserializeVector()`
  - `lia.utilities.dprint()`
  - `lia.utilities.formatTimestamp()`
  - `lia.utilities.hMSToSeconds()`
  - `lia.utilities.lerpColor()`
  - `lia.utilities.lerpHSV()`
  - `lia.utilities.lighten()`
  - `lia.utilities.rainbow()`
  - `lia.utilities.rgb()`
  - `lia.utilities.secondsToDHMS()`
  - `lia.utilities.serializeAngle()`
  - `lia.utilities.serializeVector()`
  - `lia.utilities.spawnEntities()`
  - `lia.utilities.spawnProp()`
  - `lia.utilities.speedTest()`
  - `lia.utilities.timeDifference()`
  - `lia.utilities.timeUntil()`
  - `lia.utilities.toText()`
  - `lia.utilities.weekdayName()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities | 0 | 26 |
