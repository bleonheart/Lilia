## Executive Summary

### Function Documentation
- **Total Functions:** 5
- **Documented:** 0 (0.0%)
- **Missing Functions:** 5 unique (5 total occurrences)
  - **Library Functions:** 5
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
- **Undefined Inferred Localization Keys:** 5

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 5 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 5 functions

#### lia.animations
Count: 5 functions

- `lia.animations.getBoneTable()`
- `lia.animations.performAnimation()`
- `lia.animations.resetBones()`
- `lia.animations.toggleAnimation()`
- `lia.animations.updateAnimation()`

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
| `MODULE.desc` | Unlocalized string | `Advanced bone manipulation system that provides realistic roleplay animations through precise skeletal control. Utilizes ValveBiped bone structure to create natural-looking poses including surrender (hands-up), military salutes, crossed arms, attention stances, typing posture, and various gestures. Features automatic interruption on movement, jumping, weapon switching, or vehicle entry to maintain gameplay flow. Integrates with lia.playerinteract for seamless context menu access, supports timed animations with auto-deactivation, and includes comprehensive cleanup systems for map changes and character respawns. Server-authoritative with networked synchronization ensures all players see consistent animations across the multiplayer environment.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim\module.lua | 4 |
| `MODULE.name` | Missing key | `Anim` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim\module.lua | 2 |
| `data.category` | Missing key | `Animations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim\pim.lua | 281 |
| `data.category` | Missing key | `Animations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim\pim.lua | 296 |
| `data.desc` | Unlocalized string | `Advanced bone manipulation system that provides realistic roleplay animations through precise skeletal control. Utilizes ValveBiped bone structure to create natural-looking poses including surrender (hands-up), military salutes, crossed arms, attention stances, typing posture, and various gestures. Features automatic interruption on movement, jumping, weapon switching, or vehicle entry to maintain gameplay flow. Integrates with lia.playerinteract for seamless context menu access, supports timed animations with auto-deactivation, and includes comprehensive cleanup systems for map changes and character respawns. Server-authoritative with networked synchronization ensures all players see consistent animations across the multiplayer environment.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim\module.lua | 4 |

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.animations.getBoneTable()`
  - `lia.animations.performAnimation()`
  - `lia.animations.resetBones()`
  - `lia.animations.toggleAnimation()`
  - `lia.animations.updateAnimation()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim | 0 | 5 | 0 |
