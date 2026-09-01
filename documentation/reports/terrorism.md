## Executive Summary

### Function Documentation
- **Total Functions:** 13
- **Documented:** 0 (0.0%)
- **Missing Functions:** 13 unique (13 total occurrences)
  - **Library Functions:** 13
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
- **Undefined Inferred Localization Keys:** 15

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 13 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 13 functions

#### lia.terrorism
Count: 13 functions

- `lia.terrorism.armWithManualDetonator()`
- `lia.terrorism.armWithTimer()`
- `lia.terrorism.explodeDoor()`
- `lia.terrorism.explodePlantedBomb()`
- `lia.terrorism.explodeVehicle()`
- `lia.terrorism.explodeWorldBomb()`
- `lia.terrorism.getBombsByOwner()`
- `lia.terrorism.getPlantedBombs()`
- `lia.terrorism.placeWorldBombDetonator()`
- `lia.terrorism.placeWorldBombTimer()`
- `lia.terrorism.registerBomb()`
- `lia.terrorism.setupPlantedBomb()`
- `lia.terrorism.unregisterBomb()`

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
| `ITEM.desc` | Unlocalized string | `Explosive device` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\bomb.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A handheld detonator used to remotely trigger explosive charges. Essential for controlled demolitions or sabotage.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\detonator.lua | 2 |
| `ITEM.name` | Unlocalized string | `Explosive Device` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\bomb.lua | 1 |
| `ITEM.name` | Missing key | `Detonator` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\detonator.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive terrorism system featuring vehicle car bombs that detonate on engine start and door breach explosives. Both bomb types support timed detonation (0-60 seconds) and remote detonation using handheld detonators. Includes realistic explosion physics with debris creation, player interaction menus for remote detonation, and a complete item system with explosive devices and detonators. Perfect for sabotage operations, controlled demolitions, and asymmetric warfare scenarios.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\module.lua | 5 |
| `MODULE.name` | Missing key | `Terrorism` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\module.lua | 3 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\entities\entities\lia_planted_bomb\shared.lua | 3 |
| `data.category` | Missing key | `Terrorism` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\bomb.lua | 6 |
| `data.category` | Missing key | `Terrorism` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\detonator.lua | 6 |
| `data.category` | Missing key | `Terrorism` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\pim.lua | 2 |
| `data.desc` | Unlocalized string | `Explosive device` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\bomb.lua | 2 |
| `data.desc` | Unlocalized string | `Disarmed explosive device with reusable components.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\bomb.lua | 152 |
| `data.desc` | Unlocalized string | `A handheld detonator used to remotely trigger explosive charges. Essential for controlled demolitions or sabotage.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\items\detonator.lua | 2 |
| `data.desc` | Unlocalized string | `Comprehensive terrorism system featuring vehicle car bombs that detonate on engine start and door breach explosives. Both bomb types support timed detonation (0-60 seconds) and remote detonation using handheld detonators. Includes realistic explosion physics with debris creation, player interaction menus for remote detonation, and a complete item system with explosive devices and detonators. Perfect for sabotage operations, controlled demolitions, and asymmetric warfare scenarios.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\module.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism\entities\entities\lia_planted_bomb\shared.lua | 6 |

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.terrorism.armWithManualDetonator()`
  - `lia.terrorism.armWithTimer()`
  - `lia.terrorism.explodeDoor()`
  - `lia.terrorism.explodePlantedBomb()`
  - `lia.terrorism.explodeVehicle()`
  - `lia.terrorism.explodeWorldBomb()`
  - `lia.terrorism.getBombsByOwner()`
  - `lia.terrorism.getPlantedBombs()`
  - `lia.terrorism.placeWorldBombDetonator()`
  - `lia.terrorism.placeWorldBombTimer()`
  - `lia.terrorism.registerBomb()`
  - `lia.terrorism.setupPlantedBomb()`
  - `lia.terrorism.unregisterBomb()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism | 0 | 13 | 0 |
