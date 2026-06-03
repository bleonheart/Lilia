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
- **Undefined Inferred Localization Keys:** 7

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 9
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"
- **edit** in netcalls\client.lua:48
  - Context: button:SetText(L("edit"))

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 6 |
| `MODULE.name` | Unlocalized string | `Extended Descriptions` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 1 |
| `Privilege.Category` | Missing key | `descriptions` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 11 |
| `Privilege.Name` | Missing key | `changeDescription` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 9 |
| `data.desc` | Missing key | `viewExtDescCommand` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\commands.lua | 3 |
| `data.desc` | Missing key | `setExtDescCommand` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\commands.lua | 16 |
| `data.desc` | Unlocalized string | `Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 6 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions | 0 | 0 |
