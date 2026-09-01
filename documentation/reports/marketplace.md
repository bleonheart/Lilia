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
- **Defined Net Messages:** 12
- **Used Net Messages:** 12
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 14

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

#### lia.marketplace
Count: 13 functions

- `lia.marketplace.adminChangeItemValue()`
- `lia.marketplace.adminRemoveItem()`
- `lia.marketplace.buyItem()`
- `lia.marketplace.getCharListings()`
- `lia.marketplace.getListingInfo()`
- `lia.marketplace.getListings()`
- `lia.marketplace.listItem()`
- `lia.marketplace.openAdminMenu()`
- `lia.marketplace.openMarketplace()`
- `lia.marketplace.openValueChangeDialog()`
- `lia.marketplace.receivePage()`
- `lia.marketplace.showListMenu()`
- `lia.marketplace.unlistItem()`

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
| `MODULE.desc` | Unlocalized string | `A comprehensive player-to-player trading marketplace system featuring persistent database storage, configurable listing limits and pricing controls, intuitive GUI interfaces for buyers and sellers, administrative management tools with item removal and price modification capabilities, automatic economic transactions with money transfers, NPC vendor integration for marketplace access, real-time listing updates and search functionality, item validation and blacklist support, and robust server economy integration.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 6 |
| `MODULE.name` | Missing key | `Marketplace` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 3 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 11 |
| `Privilege.Name` | Unlocalized string | `Manage Marketplace` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 9 |
| `data.category` | Missing key | `Marketplace` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 21 |
| `data.category` | Missing key | `Marketplace` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 29 |
| `data.category` | Missing key | `Marketplace` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 37 |
| `data.desc` | Unlocalized string | `A comprehensive player-to-player trading marketplace system featuring persistent database storage, configurable listing limits and pricing controls, intuitive GUI interfaces for buyers and sellers, administrative management tools with item removal and price modification capabilities, automatic economic transactions with money transfers, NPC vendor integration for marketplace access, real-time listing updates and search functionality, item validation and blacklist support, and robust server economy integration.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 6 |
| `data.desc` | Unlocalized string | `Maximum number of marketplace listings per player` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 20 |
| `data.desc` | Unlocalized string | `Minimum price for marketplace listings` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 28 |
| `data.desc` | Unlocalized string | `Model used for marketplace NPC` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 36 |
| `lia.config.add:name` | Unlocalized string | `Max Listings` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 19 |
| `lia.config.add:name` | Unlocalized string | `Minimum Listing Price` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 27 |
| `lia.config.add:name` | Unlocalized string | `NPC Model` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\module.lua | 35 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 12
- **Used Net Messages:** 12
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

Total suspicious patterns: **1**

- `liaMarketplaceRequestListMenu`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:323

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
- **Net Handlers Outside netcalls:** 13
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:2` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:341` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:346` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:355` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:859` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:869` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:291` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:297` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:303` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:308` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:323` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:473` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:484` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.marketplace.adminChangeItemValue()`
  - `lia.marketplace.adminRemoveItem()`
  - `lia.marketplace.buyItem()`
  - `lia.marketplace.getCharListings()`
  - `lia.marketplace.getListingInfo()`
  - `lia.marketplace.getListings()`
  - `lia.marketplace.listItem()`
  - `lia.marketplace.openAdminMenu()`
  - `lia.marketplace.openMarketplace()`
  - `lia.marketplace.openValueChangeDialog()`
  - `lia.marketplace.receivePage()`
  - `lia.marketplace.showListMenu()`
  - `lia.marketplace.unlistItem()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace | 0 | 13 | 0 |
