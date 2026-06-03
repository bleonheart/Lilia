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
- **Undefined Inferred Localization Keys:** 8

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 8
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **invalidTarget** in commands.lua:22
  - Context: ply:notify(L("invalidTarget"))
- **liliaplayer** in module.lua:5
  - Context: MODULE.discord = "@liliaplayer"

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 7 |
| `MODULE.name` | Missing key | `Cutscenes` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 2 |
| `Privilege.Category` | Missing key | `cutscenes` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 12 |
| `Privilege.Name` | Missing key | `cutsceneCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\commands.lua | 13 |
| `Privilege.Name` | Missing key | `useCutscenes` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 10 |
| `data.desc` | Missing key | `cutsceneCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\commands.lua | 11 |
| `data.desc` | Missing key | `globalCutsceneCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\commands.lua | 45 |
| `data.desc` | Unlocalized string | `Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 7 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes | 0 | 0 |
