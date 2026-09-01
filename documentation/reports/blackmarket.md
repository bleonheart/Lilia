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
- **Defined Net Messages:** 7
- **Used Net Messages:** 7
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 42

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

#### lia.blackmarket
Count: 5 functions

- `lia.blackmarket.getLocations()`
- `lia.blackmarket.loadLocationsFromDisk()`
- `lia.blackmarket.registerBlackMarketItem()`
- `lia.blackmarket.saveLocations()`
- `lia.blackmarket.swapNPCPosition()`

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
| `MODULE.desc` | Unlocalized string | `A comprehensive underground trading system featuring an elusive NPC black market dealer who sells illegal weapons, contraband items, and restricted goods. The system includes dynamic inventory management with limited stock quantities, automatic restock timers that replenish supplies over time, configurable pricing structures, secret location mechanics requiring players to discover the hidden shop, waypoint/package delivery systems for illicit transactions, and administrative tools for managing the black market economy. Perfect for servers seeking enhanced criminal roleplay opportunities with an immersive underground economy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\module.lua | 8 |
| `MODULE.name` | Missing key | `Blackmarket` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\module.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\entities\entities\lia_import_item\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Staff Management` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\module.lua | 13 |
| `Privilege.Name` | Unlocalized string | `Blackmarket Admin Access` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\module.lua | 11 |
| `data.category` | Missing key | `Blackmarket` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 3 |
| `data.category` | Missing key | `Blackmarket` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 12 |
| `data.category` | Missing key | `Blackmarket` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 21 |
| `data.category` | Missing key | `Blackmarket` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 30 |
| `data.category` | Missing key | `Blackmarket` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 37 |
| `data.category` | Missing key | `Stimulants` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 4 |
| `data.category` | Unlocalized string | `Raw Materials` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 12 |
| `data.category` | Missing key | `Opiates` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 20 |
| `data.category` | Unlocalized string | `Raw Materials` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 28 |
| `data.category` | Missing key | `Cannabis` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 36 |
| `data.category` | Unlocalized string | `Raw Materials` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 44 |
| `data.category` | Unlocalized string | `Growing Supplies` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 52 |
| `data.category` | Missing key | `Stimulants` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 60 |
| `data.category` | Unlocalized string | `Raw Materials` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 68 |
| `data.category` | Missing key | `Psychedelics` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 76 |
| `data.category` | Unlocalized string | `Raw Materials` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 84 |
| `data.category` | Missing key | `Empathogens` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 92 |
| `data.category` | Unlocalized string | `Raw Materials` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 100 |
| `data.category` | Missing key | `Equipment` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 108 |
| `data.category` | Unlocalized string | `Growing Supplies` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 116 |
| `data.category` | Unlocalized string | `Growing Supplies` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 124 |
| `data.category` | Unlocalized string | `Growing Supplies` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 132 |
| `data.category` | Missing key | `Tools` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 141 |
| `data.category` | Missing key | `Weapons` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\definitions.lua | 149 |
| `data.desc` | Unlocalized string | `Time in seconds before items are delivered to a drop location.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 7 |
| `data.desc` | Unlocalized string | `Time in seconds before a package despawns.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 16 |
| `data.desc` | Unlocalized string | `Cooldown in seconds between player orders.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 25 |
| `data.desc` | Unlocalized string | `Whether packages spawn at a random drop location.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 32 |
| `data.desc` | Unlocalized string | `Time in minutes between NPC location changes.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 41 |
| `data.desc` | Unlocalized string | `Forces the blackmarket NPC to swap to a random location.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\libraries\server.lua | 417 |
| `data.desc` | Unlocalized string | `A comprehensive underground trading system featuring an elusive NPC black market dealer who sells illegal weapons, contraband items, and restricted goods. The system includes dynamic inventory management with limited stock quantities, automatic restock timers that replenish supplies over time, configurable pricing structures, secret location mechanics requiring players to discover the hidden shop, waypoint/package delivery systems for illicit transactions, and administrative tools for managing the black market economy. Perfect for servers seeking enhanced criminal roleplay opportunities with an immersive underground economy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\module.lua | 8 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\entities\entities\lia_import_item\shared.lua | 5 |
| `lia.config.add:name` | Unlocalized string | `Import Time` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 2 |
| `lia.config.add:name` | Unlocalized string | `Despawn Time` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 11 |
| `lia.config.add:name` | Unlocalized string | `Importing Cooldown` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 20 |
| `lia.config.add:name` | Unlocalized string | `Random Position` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 29 |
| `lia.config.add:name` | Unlocalized string | `Location Change Time` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\config\shared.lua | 36 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 7
- **Used Net Messages:** 7
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
- **Net Handlers Outside netcalls:** 5
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/client.lua:74` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/client.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/client.lua:177` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/server.lua:152` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/server.lua:160` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.blackmarket.getLocations()`
  - `lia.blackmarket.loadLocationsFromDisk()`
  - `lia.blackmarket.registerBlackMarketItem()`
  - `lia.blackmarket.saveLocations()`
  - `lia.blackmarket.swapNPCPosition()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket | 0 | 5 | 0 |
