## Executive Summary

### Function Documentation
- **Total Functions:** 2
- **Documented:** 0 (0.0%)
- **Missing Functions:** 2 unique (2 total occurrences)
  - **Library Functions:** 2
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
- **Undefined Inferred Localization Keys:** 6

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 2 unique functions

### Missing Library Functions
Total: 2 functions

#### lia.caption
Count: 2 functions

- `lia.caption.finish()`
- `lia.caption.start()`

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 5
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **targetNotFound** in commands.lua:29
  - Context: client:notifyLocalized("targetNotFound")
- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\module.lua | 6 |
| `MODULE.name` | Missing key | `Captions` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\module.lua | 1 |
| `Privilege.Name` | Missing key | `sendCaptionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\commands.lua | 20 |
| `data.desc` | Missing key | `sendCaptionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\commands.lua | 18 |
| `data.desc` | Missing key | `broadcastCaptionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\commands.lua | 54 |
| `data.desc` | Unlocalized string | `Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\module.lua | 6 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.caption.finish()`
  - `lia.caption.start()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions | 0 | 2 |
