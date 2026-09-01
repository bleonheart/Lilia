## Executive Summary

### Function Documentation
- **Total Functions:** 2
- **Documented:** 0 (0.0%)
- **Missing Functions:** 2 unique (2 total occurrences)
  - **Library Functions:** 2
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
- **Defined Net Messages:** 6
- **Used Net Messages:** 6
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 24

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 2 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 2 functions

#### lia.crafting
Count: 2 functions

- `lia.crafting.generateCraftingRecipe()`
- `lia.crafting.generateCraftingTable()`

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
| `ITEM.desc` | Unlocalized string | `A notepad that teaches you how to craft something.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\items\base\recipe_book.lua | 2 |
| `ITEM.name` | Unlocalized string | `Recipe Notepad Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\items\base\recipe_book.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive crafting system featuring multiple crafting stations (forge, workbench), recipe-based crafting with time-based progress bars, attribute requirements and skill progression, tool dependencies, faction restrictions, knowledge system with recipe books, dynamic UI with progress tracking and cancellation, item consumption and output with randomized quantities, and automatic entity registration for crafting stations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\module.lua | 9 |
| `MODULE.name` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\module.lua | 7 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\entities\entities\lia_craftingstation\shared.lua | 3 |
| `Privilege.Category` | Unlocalized string | `Crafting Stations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 142 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\items\base\recipe_book.lua | 6 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 15 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 25 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 35 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 45 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 55 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 65 |
| `data.category` | Missing key | `Crafting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 160 |
| `data.desc` | Unlocalized string | `Your ability to craft items and work with crafting stations. Higher crafting skill allows you to craft more complex recipes and reduces crafting time.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\attributes\crafting.lua | 2 |
| `data.desc` | Unlocalized string | `A notepad that teaches you how to craft something.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\items\base\recipe_book.lua | 2 |
| `data.desc` | Unlocalized string | `Raw iron ore, needs to be smelted.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 13 |
| `data.desc` | Unlocalized string | `A refined iron ingot, used for crafting weapons and tools.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 23 |
| `data.desc` | Unlocalized string | `Basic wood material for crafting.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 33 |
| `data.desc` | Unlocalized string | `A raw log from a tree, can be processed into planks.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 43 |
| `data.desc` | Unlocalized string | `A processed wood plank, ready for construction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 53 |
| `data.desc` | Unlocalized string | `A sharp iron sword, good for combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 63 |
| `data.desc` | Unlocalized string | `Teaches you how to craft` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\libraries\shared.lua | 158 |
| `data.desc` | Unlocalized string | `Comprehensive crafting system featuring multiple crafting stations (forge, workbench), recipe-based crafting with time-based progress bars, attribute requirements and skill progression, tool dependencies, faction restrictions, knowledge system with recipe books, dynamic UI with progress tracking and cancellation, item consumption and output with randomized quantities, and automatic entity registration for crafting stations` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\module.lua | 9 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 6
- **Used Net Messages:** 6
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
- **Registered Panels:** 2
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 2
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `liaCraftItemModel` | `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:328` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` |
| `liaCrafting` | `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1267` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 7
- **UI / Derma Code Outside derma:** 2

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1268` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1274` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1346` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1357` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/server.lua:14` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/server.lua:54` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/server.lua:76` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:328` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` | Module Derma code is outside the derma folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1267` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.crafting.generateCraftingRecipe()`
  - `lia.crafting.generateCraftingTable()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting | 0 | 2 | 0 |
