## Executive Summary

### Function Documentation
- **Total Functions:** 3
- **Documented:** 0 (0.0%)
- **Missing Functions:** 3 unique (3 total occurrences)
  - **Library Functions:** 3
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
- **Undefined Inferred Localization Keys:** 53

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 3 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 3 functions

#### lia.gathering
Count: 3 functions

- `lia.gathering.generateEntity()`
- `lia.gathering.generateItems()`
- `lia.gathering.handleReward()`

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
| `MODULE.desc` | Unlocalized string | `A complete resource gathering system featuring tree harvesting (spruce wood, sticks, tree sap, logs, wood planks) with axe-based chopping mechanics, ore mining from rocks (iron, gold, silver ore, coal, stone) for smelting into ingots, an interactive fishing system requiring poles and bait that yields various fish types (lake trout, bass, catfish, perch) plus junk items (old boots, trash), comprehensive crafting materials processing (raw resources into refined materials like iron ingots, wood planks, and weapons such as iron swords), and full stackable inventory management with configurable max quantities for all gathered items.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\module.lua | 7 |
| `MODULE.name` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\module.lua | 5 |
| `Privilege.Category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\entities\entities\lia_gatherable\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\entities\weapons\lia_axe\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\entities\weapons\lia_pickaxe\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\libraries\shared.lua | 8 |
| `Privilege.Category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\module.lua | 47 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 38 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 48 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 58 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 68 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 78 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 88 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 98 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 108 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 118 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 128 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 138 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 148 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 158 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 168 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 178 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 188 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 198 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 208 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 218 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 228 |
| `data.category` | Missing key | `Gathering` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\module.lua | 15 |
| `data.desc` | Unlocalized string | `A sturdy tree, perfect for gathering wood.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 3 |
| `data.desc` | Unlocalized string | `A piece of spruce wood, known for its strength.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 36 |
| `data.desc` | Unlocalized string | `A simple wooden stick.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 46 |
| `data.desc` | Unlocalized string | `Raw iron ore, needs to be smelted.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 56 |
| `data.desc` | Unlocalized string | `Precious gold ore, valuable and rare.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 66 |
| `data.desc` | Unlocalized string | `Silver ore, used in various crafts.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 76 |
| `data.desc` | Unlocalized string | `Coal for fuel and smelting.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 86 |
| `data.desc` | Unlocalized string | `A chunk of rock, useful for crafting or building.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 96 |
| `data.desc` | Unlocalized string | `Sticky sap collected from trees. Can be used for crafting.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 106 |
| `data.desc` | Unlocalized string | `A Lake Trout` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 116 |
| `data.desc` | Unlocalized string | `A largemouth bass.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 126 |
| `data.desc` | Unlocalized string | `A slippery catfish.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 136 |
| `data.desc` | Unlocalized string | `A small perch.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 146 |
| `data.desc` | Unlocalized string | `An old, waterlogged boot. Not very tasty.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 156 |
| `data.desc` | Unlocalized string | `A piece of trash.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 166 |
| `data.desc` | Unlocalized string | `A refined iron ingot, used for crafting weapons and tools.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 176 |
| `data.desc` | Unlocalized string | `Basic wood material for crafting.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 186 |
| `data.desc` | Unlocalized string | `A sharp iron sword, good for combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 196 |
| `data.desc` | Unlocalized string | `A raw log from a tree, can be processed into planks.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 206 |
| `data.desc` | Unlocalized string | `A processed wood plank, ready for construction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 216 |
| `data.desc` | Unlocalized string | `A solid stone, useful for building and crafting.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\definitions.lua | 226 |
| `data.desc` | Unlocalized string | `A complete resource gathering system featuring tree harvesting (spruce wood, sticks, tree sap, logs, wood planks) with axe-based chopping mechanics, ore mining from rocks (iron, gold, silver ore, coal, stone) for smelting into ingots, an interactive fishing system requiring poles and bait that yields various fish types (lake trout, bass, catfish, perch) plus junk items (old boots, trash), comprehensive crafting materials processing (raw resources into refined materials like iron ingots, wood planks, and weapons such as iron swords), and full stackable inventory management with configurable max quantities for all gathered items.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\module.lua | 7 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\entities\entities\lia_gatherable\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\entities\weapons\lia_axe\shared.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering\entities\weapons\lia_pickaxe\shared.lua | 3 |

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.gathering.generateEntity()`
  - `lia.gathering.generateItems()`
  - `lia.gathering.handleReward()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering | 0 | 3 | 0 |
