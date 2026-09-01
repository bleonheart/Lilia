## Executive Summary

### Function Documentation
- **Total Functions:** 1
- **Documented:** 0 (0.0%)
- **Missing Functions:** 1 unique (1 total occurrences)
  - **Library Functions:** 1
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
- **Defined Net Messages:** 2
- **Used Net Messages:** 0
- **Defined But Unused:** 2
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 4
- **Undefined Inferred Localization Keys:** 9

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 1 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 1 functions

#### lia.territories
Count: 1 functions

- `lia.territories.register()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive territory control system that allows factions to capture, defend, and hold strategic control points. Features include configurable capture zones with customizable radius and capture timers, automatic NPC defender spawning, real-time HUD status displays showing current ownership and capture progress, faction-based ownership mechanics with collision prevention to ensure proper point distribution, reward systems for holding territories, persistent entity saving, and administrative tools for managing control points. The system supports dynamic territory warfare where factions can contest control points through presence-based capture mechanics requiring minimum defenders to secure areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\module.lua | 11 |
| `MODULE.name` | Missing key | `Territories` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\module.lua | 9 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\shared.lua | 7 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\libraries\shared.lua | 13 |
| `data.category` | Missing key | `categoryLiliaGeneral` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\libraries\client.lua | 7 |
| `data.desc` | Unlocalized string | `Comprehensive territory control system that allows factions to capture, defend, and hold strategic control points. Features include configurable capture zones with customizable radius and capture timers, automatic NPC defender spawning, real-time HUD status displays showing current ownership and capture progress, faction-based ownership mechanics with collision prevention to ensure proper point distribution, reward systems for holding territories, persistent entity saving, and administrative tools for managing control points. The system supports dynamic territory warfare where factions can contest control points through presence-based capture mechanics requiring minimum defenders to secure areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\module.lua | 11 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\shared.lua | 4 |
| `lia.option.add:desc` | Unlocalized string | `Toggle radius visualization for control points (Staff Only)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\libraries\client.lua | 6 |
| `lia.option.add:name` | Unlocalized string | `Control Point Radius` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\libraries\client.lua | 6 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 2
- **Used Net Messages:** 0
- **Defined But Unused:** 2
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

Total: **4** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `ControlConquestable` | 1 |
| `ControlMinPlayers` | 1 |
| `ControlRadius` | 1 |
| `ControlSpawnUnowned` | 1 |

### Details

#### `ControlConquestable`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\init.lua** line 52: `if settings.conquestable == nil then settings.conquestable = (definition and definition.conquestable) or lia.config.get("ControlConquestable", true) end`

#### `ControlMinPlayers`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\init.lua** line 51: `if settings.minDefenders == nil then settings.minDefenders = (definition and definition.minDefenders) or lia.config.get("ControlMinPlayers", MODULE.DEFAULT_MIN_DEFENDERS or 1) end`

#### `ControlRadius`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\init.lua** line 50: `if settings.radius == nil then settings.radius = (definition and definition.radius) or lia.config.get("ControlRadius", MODULE.DEFAULT_RADIUS or 200) end`

#### `ControlSpawnUnowned`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\libraries\server.lua** line 107: `if settings.owner == nil and not lia.config.get("ControlSpawnUnowned", false) then`

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.territories.register()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories | 0 | 1 | 0 |
