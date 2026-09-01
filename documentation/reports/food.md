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
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 32

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

#### lia.food
Count: 1 functions

- `lia.food.registerFood()`

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
| `ITEM.desc` | Unlocalized string | `A basic consumable item.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\items\base\food.lua | 2 |
| `ITEM.name` | Unlocalized string | `Zero Consumable Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\items\base\food.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive survival system that manages player hunger and thirst levels. Features dynamic food registration with customizable hunger/thirst values, stamina penalties for low hunger, automatic hunger degradation over time, and a variety of food items including canned goods, beverages, and MREs. Integrates with character factions and includes staff exemptions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\module.lua | 7 |
| `MODULE.name` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\module.lua | 5 |
| `data.category` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 2 |
| `data.category` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 11 |
| `data.category` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 20 |
| `data.category` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 29 |
| `data.category` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 38 |
| `data.category` | Missing key | `Food` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 45 |
| `data.category` | Missing key | `Consumable` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\items\base\food.lua | 8 |
| `data.desc` | Unlocalized string | `Seconds between hunger decreases (hunger drops by 1 each interval).` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 6 |
| `data.desc` | Unlocalized string | `Seconds between thirst decreases (thirst drops by 1 each interval).` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 15 |
| `data.desc` | Unlocalized string | `At or below this hunger value, stamina drains.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 24 |
| `data.desc` | Unlocalized string | `At or below this thirst value, sprinting is disabled.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 33 |
| `data.desc` | Unlocalized string | `Enable hunger decreasing over time.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 40 |
| `data.desc` | Unlocalized string | `Enable thirst decreasing over time.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 47 |
| `data.desc` | Unlocalized string | `A metal can filled with preserved beans. It` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 3 |
| `data.desc` | Unlocalized string | `A clear plastic bottle filled with somewhat clean water.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 11 |
| `data.desc` | Unlocalized string | `A loaf of stale bread. Better than nothing.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 19 |
| `data.desc` | Unlocalized string | `A can of bubbly, sugary soda.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 27 |
| `data.desc` | Unlocalized string | `A carton of pasteurized milk.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 35 |
| `data.desc` | Unlocalized string | `A large, juicy watermelon.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 43 |
| `data.desc` | Unlocalized string | `A Military Ration, Meal Ready-to-Eat. It` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\definitions.lua | 51 |
| `data.desc` | Unlocalized string | `A basic consumable item.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\items\base\food.lua | 2 |
| `data.desc` | Unlocalized string | `Comprehensive survival system that manages player hunger and thirst levels. Features dynamic food registration with customizable hunger/thirst values, stamina penalties for low hunger, automatic hunger degradation over time, and a variety of food items including canned goods, beverages, and MREs. Integrates with character factions and includes staff exemptions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\module.lua | 7 |
| `lia.config.add:name` | Unlocalized string | `Hunger Timer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 1 |
| `lia.config.add:name` | Unlocalized string | `Thirst Timer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 10 |
| `lia.config.add:name` | Unlocalized string | `Hunger Threshold` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 19 |
| `lia.config.add:name` | Unlocalized string | `Thirst Threshold` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 28 |
| `lia.config.add:name` | Unlocalized string | `Enable Hunger Timer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 37 |
| `lia.config.add:name` | Unlocalized string | `Enable Thirst Timer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food\config\shared.lua | 44 |

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.food.registerFood()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food | 0 | 1 | 0 |
