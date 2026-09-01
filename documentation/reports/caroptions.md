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
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 1
- **Used Net Messages:** 1
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 96

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 1
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 1 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `ToggleLock`
  - module `caroptions` [standard] in `pim.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `ToggleLock()`

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
| `ITEM.desc` | Unlocalized string | `A compact disc containing music tracks.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\base\cd.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A storage box for compact discs.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\cdbox.lua | 2 |
| `ITEM.name` | Unlocalized string | `CD Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\base\cd.lua | 1 |
| `ITEM.name` | Unlocalized string | `CD Box` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\cdbox.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive vehicle enhancement system featuring CD player with music track management, album organization, and audio streaming for in-car entertainment. Includes passenger detection and management for both players and bots, supporting various vehicle types including LVS and SCars with proper seat identification and driver/passenger tracking.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\module.lua | 4 |
| `MODULE.name` | Missing key | `Caroptions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\module.lua | 2 |
| `data.category` | Missing key | `Music` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\base\cd.lua | 3 |
| `data.category` | Unlocalized string | `Car Options` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\pim.lua | 58 |
| `data.category` | Unlocalized string | `Car Options` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\pim.lua | 170 |
| `data.category` | Unlocalized string | `Car Options` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\pim.lua | 195 |
| `data.category` | Unlocalized string | `Car Options` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\pim.lua | 265 |
| `data.category` | Unlocalized string | `Car Options` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\pim.lua | 318 |
| `data.desc` | Unlocalized string | `A compact disc containing music tracks.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\base\cd.lua | 2 |
| `data.desc` | Unlocalized string | `A storage box for compact discs.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\items\cdbox.lua | 2 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 8 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 15 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 22 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 29 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 36 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 43 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 50 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 57 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 64 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 71 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 78 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 85 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 92 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 99 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 106 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 113 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 120 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 127 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 134 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 141 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 148 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 155 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 162 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 169 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 176 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 183 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 190 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 197 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 204 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 211 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 218 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 225 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 232 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 239 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 246 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 253 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 260 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 267 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 274 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 281 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 288 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 295 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 302 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 309 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 316 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 323 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 330 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 337 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 344 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 351 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 358 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 365 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 372 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 379 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 386 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 393 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 400 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 407 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 414 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 421 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 428 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 435 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 442 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 449 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 456 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 463 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 470 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 477 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 484 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 491 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 498 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 505 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 512 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 519 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 526 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 533 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 540 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 547 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 554 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 561 |
| `data.desc` | Unlocalized string | `A single-track CD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\libraries\shared.lua | 568 |
| `data.desc` | Unlocalized string | `Comprehensive vehicle enhancement system featuring CD player with music track management, album organization, and audio streaming for in-car entertainment. Includes passenger detection and management for both players and bots, supporting various vehicle types including LVS and SCars with proper seat identification and driver/passenger tracking.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions\module.lua | 4 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 1
- **Used Net Messages:** 1
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Used But Undefined

None

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 0

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

None

### Direction / Flow Issues

Total suspicious patterns: **0**

None

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 0
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 0
- **Registered But Unused:** 0

### Module Panels Outside derma

None

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 0
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

None

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ToggleLock()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions | 1 | 0 | 0 |
