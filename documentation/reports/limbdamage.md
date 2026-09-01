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
- **Undefined Inferred Localization Keys:** 9

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

## Hooks Documentation Analysis

_No hooks analysis data available._

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
| `MODULE.desc` | Unlocalized string | `Advanced limb damage system that simulates realistic leg injuries. When players are shot in the legs (left or right leg hitgroups), they experience a temporary sprint disability with configurable duration. Features include automatic healing after the damage duration, visual HUD indicators with red screen effects and text warnings, server-side damage validation with blast damage immunity, toggleable system enable/disable functionality, and proper cleanup on player disconnection. The system uses networked variables for synchronized client-server state and provides immersive gameplay feedback through notifications and visual effects.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 3 |
| `MODULE.name` | Missing key | `Limbdamage` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 1 |
| `data.category` | Unlocalized string | `Limb Damage` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 9 |
| `data.category` | Unlocalized string | `Limb Damage` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 15 |
| `data.desc` | Unlocalized string | `Advanced limb damage system that simulates realistic leg injuries. When players are shot in the legs (left or right leg hitgroups), they experience a temporary sprint disability with configurable duration. Features include automatic healing after the damage duration, visual HUD indicators with red screen effects and text warnings, server-side damage validation with blast damage immunity, toggleable system enable/disable functionality, and proper cleanup on player disconnection. The system uses networked variables for synchronized client-server state and provides immersive gameplay feedback through notifications and visual effects.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 3 |
| `data.desc` | Unlocalized string | `How long leg damage prevents sprinting (in seconds)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 5 |
| `data.desc` | Unlocalized string | `Whether leg damage system is enabled` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 13 |
| `lia.config.add:name` | Unlocalized string | `Leg Damage Delay` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 4 |
| `lia.config.add:name` | Unlocalized string | `Leg Damage Enabled` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage\module.lua | 12 |

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

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage | 0 | 0 | 0 |
