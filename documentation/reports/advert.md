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
- **Undefined Inferred Localization Keys:** 10

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 11
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **invalidArg** in commands.lua:13
  - Context: if not arguments[1] then return L("invalidArg") end
- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\module.lua | 6 |
| `MODULE.name` | Missing key | `Advertisements` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\module.lua | 1 |
| `data.category` | Missing key | `advertisements` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 3 |
| `data.category` | Missing key | `advertisements` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 11 |
| `data.desc` | Missing key | `advertCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\commands.lua | 11 |
| `data.desc` | Missing key | `advertPriceDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 2 |
| `data.desc` | Missing key | `advertCooldownDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 10 |
| `data.desc` | Unlocalized string | `Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\module.lua | 6 |
| `lia.config.add:name` | Missing key | `advertPrice` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 1 |
| `lia.config.add:name` | Missing key | `advertCooldown` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 9 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert | 0 | 0 |
