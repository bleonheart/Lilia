## Executive Summary

### Function Documentation
- **Total Functions:** 1
- **Documented:** 0 (0.0%)
- **Missing Functions:** 1 unique (1 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 1

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
- **Missing Documentation:** 1 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Meta Functions
Total: 1 functions

#### playerMeta
Count: 1 functions

- `playerMeta:hasAchievement()`

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
- `CanPlayerViewAchievements`
  - module `achievements` [standard] in `libraries/client.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `CanPlayerViewAchievements()`

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
| `MODULE.desc` | Unlocalized string | `Full-featured achievement system with real-time progress tracking, visual progress bars, and administrative oversight. Supports multiple achievement types: kill-based tracking (zombies, players, NPCs with specific entity targeting), item collection milestones, playtime rewards, death tracking, and complex multi-objective challenges with nested progress tracking. Features persistent character-based storage via Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements\module.lua | 3 |
| `MODULE.name` | Missing key | `Achievements` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements\module.lua | 1 |
| `data.desc` | Unlocalized string | `Full-featured achievement system with real-time progress tracking, visual progress bars, and administrative oversight. Supports multiple achievement types: kill-based tracking (zombies, players, NPCs with specific entity targeting), item collection milestones, playtime rewards, death tracking, and complex multi-objective challenges with nested progress tracking. Features persistent character-based storage via Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements\module.lua | 3 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements`

### Module Documentation Report

- **Undocumented Hooks:**
  - `CanPlayerViewAchievements()`

- **Undocumented Meta Functions:**
  - `playerMeta:hasAchievement()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements | 1 | 0 | 1 |
