## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 2 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 2

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 11
- **Used Net Messages:** 11
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 3

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 2 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 2
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 2 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `CorpseInventorySet`
  - module `corpselooting` [standard] in `libraries/sv_hooks.lua`
- `OnCorpseCreated`
  - module `corpselooting` [standard] in `libraries/sv_hooks.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `CorpseInventorySet()`
- `OnCorpseCreated()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive corpse management and looting system that creates realistic player corpses upon death with full inventory and money transfer. Features include: automatic corpse creation with player appearance preservation, dual inventory interface for seamless item transfer between player and corpse, bidirectional money deposit/withdrawal system with real-time synchronization, distance-based looting mechanics with anti-spam protection, multi-user corpse access with shared state management, automatic cleanup of corpse inventories on removal, and visual/audio feedback for all transactions. The system handles equipped items by unequipping them before transfer and supports both modern inventory instances and legacy item systems.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\module.lua | 4 |
| `MODULE.name` | Missing key | `Corpselooting` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\module.lua | 2 |
| `data.desc` | Unlocalized string | `Comprehensive corpse management and looting system that creates realistic player corpses upon death with full inventory and money transfer. Features include: automatic corpse creation with player appearance preservation, dual inventory interface for seamless item transfer between player and corpse, bidirectional money deposit/withdrawal system with real-time synchronization, distance-based looting mechanics with anti-spam protection, multi-user corpse access with shared state management, automatic cleanup of corpse inventories on removal, and visual/audio feedback for all transactions. The system handles equipped items by unequipping them before transfer and supports both modern inventory instances and legacy item systems.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\module.lua | 4 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 11
- **Used Net Messages:** 11
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

Total suspicious patterns: **10**

- `lialootDpMny`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:64
  - Receiver sites: None
- `lialootExit`
  - Reason: Message has senders but no detected receivers
  - Send sides: client, server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:89; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:131; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:107
  - Receiver sites: None
- `lialootMoney`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:143
  - Receiver sites: None
- `lialootOpen`
  - Reason: Message has senders but no detected receivers
  - Send sides: client, server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:20; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:121
  - Receiver sites: None
- `lialootWdMny`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:43
  - Receiver sites: None
- `lootDpMny`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:183
- `lootExit`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:113
- `lootMoney`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:33
- `lootOpen`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client, server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:161; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:129
- `lootWdMny`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:163

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
- **Net Handlers Outside netcalls:** 7
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:33` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:161` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:113` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:129` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:163` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:183` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_networking.lua:9` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting`

### Module Documentation Report

- **Undocumented Hooks:**
  - `CorpseInventorySet()`
  - `OnCorpseCreated()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting | 2 | 0 | 0 |
