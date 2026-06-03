## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 1 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 1

### Localization Analysis
- **Undefined Calls:** 2 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 2 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 2
- **Undefined Inferred Localization Keys:** 11

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 1
- **Unused Hooks:** 0 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `AddTextField()`

## Localization Analysis

- **Unique Keys:** 23
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"
- **submit** in derma\client.lua:90
  - Context: self.submit:SetText(L("submit"))

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `ITEM.desc` | Unlocalized string | `A Broken Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\broken_radio.lua | 2 |
| `ITEM.desc` | Unlocalized string | `Radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\radio.lua | 2 |
| `ITEM.name` | Unlocalized string | `Broken Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\broken_radio.lua | 1 |
| `ITEM.name` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\radio.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\module.lua | 6 |
| `MODULE.name` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\module.lua | 1 |
| `data.desc` | Missing key | `radioFontDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\config.lua | 2 |
| `data.desc` | Unlocalized string | `A Broken Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\broken_radio.lua | 2 |
| `data.desc` | Unlocalized string | `Radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\radio.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\module.lua | 6 |
| `lia.config.add:name` | Missing key | `radioFont` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\config.lua | 1 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

Total: **2** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `ChatRange` | 2 |

### Details

#### `ChatRange`

- **D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\libraries\shared.lua** line 13: `local speakRange = lia.config.get("ChatRange", 280)`
- **D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\libraries\shared.lua** line 37: `local speakRange = lia.config.get("ChatRange", 280)`

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio`

### Module Documentation Report

- **Undocumented Hooks:**
  - `AddTextField()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio | 1 | 0 |
