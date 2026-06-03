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
- **Undefined Inferred Localization Keys:** 15

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

_No hooks analysis data available._

## Localization Analysis

- **Unique Keys:** 22
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"
- **cancel** in libraries\client.lua:207
  - Context: quitButton:SetText(string.upper(L("cancel")))

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 6 |
| `MODULE.name` | Unlocalized string | `Cinematic Text` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 1 |
| `Privilege.Category` | Missing key | `cinematics` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 11 |
| `Privilege.Name` | Missing key | `useCinematicMenu` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 9 |
| `data.category` | Missing key | `cinematic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 3 |
| `data.category` | Missing key | `cinematic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 11 |
| `data.category` | Missing key | `cinematic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 19 |
| `data.desc` | Missing key | `cinematicMenuDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\commands.lua | 3 |
| `data.desc` | Missing key | `cinematicTextSizeDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 2 |
| `data.desc` | Missing key | `cinematicBigTextSizeDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 10 |
| `data.desc` | Missing key | `cinematicTextMusicDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 18 |
| `data.desc` | Unlocalized string | `Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 6 |
| `lia.config.add:name` | Missing key | `cinematicTextSize` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 1 |
| `lia.config.add:name` | Missing key | `cinematicBigTextSize` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 9 |
| `lia.config.add:name` | Missing key | `cinematicTextMusic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 17 |

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
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext | 0 | 0 |
