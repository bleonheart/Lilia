## Executive Summary

### Function Documentation
- **Total Functions:** 4
- **Documented:** 0 (0.0%)
- **Missing Functions:** 4 unique (4 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 4

### Hooks Documentation
- **Missing Hooks:** 1 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 1

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 11
- **Used Net Messages:** 9
- **Defined But Unused:** 2
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 12

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 4 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Meta Functions
Total: 4 functions

#### playerMeta
Count: 4 functions

- `playerMeta:addInjury()`
- `playerMeta:clearAllInjuries()`
- `playerMeta:hasInjury()`
- `playerMeta:removeInjury()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 1
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 1 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `liaInjuriesPostPlayerRevive`
  - module `injuries` [standard] in `entities/weapons/lia_defibrilator/init.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `liaInjuriesPostPlayerRevive()`

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
| `MODULE.desc` | Unlocalized string | `A comprehensive injury management system featuring multiple injury types including broken legs, bleeding wounds, head concussions, and pain effects. Each injury has unique side effects, healing requirements, and medical treatment options. Includes medical items, treatment minigames, and persistent injury tracking across player sessions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\module.lua | 4 |
| `MODULE.name` | Missing key | `Injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\module.lua | 2 |
| `Privilege.Category` | Missing key | `injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_defibrilator\shared.lua | 2 |
| `Privilege.Category` | Missing key | `injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_grizzly\shared.lua | 8 |
| `Privilege.Category` | Missing key | `injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_injectormorphine\shared.lua | 7 |
| `Privilege.Category` | Missing key | `injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_salewa\shared.lua | 9 |
| `Privilege.Category` | Missing key | `injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_surgicalkit\shared.lua | 7 |
| `data.desc` | Unlocalized string | `A comprehensive injury management system featuring multiple injury types including broken legs, bleeding wounds, head concussions, and pain effects. Each injury has unique side effects, healing requirements, and medical treatment options. Includes medical items, treatment minigames, and persistent injury tracking across player sessions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\module.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_grizzly\shared.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_injectormorphine\shared.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_salewa\shared.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\entities\weapons\lia_surgicalkit\shared.lua | 3 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 11
- **Used Net Messages:** 9
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

Total suspicious patterns: **4**

- `liaInjuryTestAdd`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:180
- `liaInjuryTestClearAll`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:241
- `liaInjuryTestRemove`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:209
- `liaInjuryTestUpdate`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:205; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:237; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:257
  - Receiver sites: None

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
- **Net Handlers Outside netcalls:** 8
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/entities/weapons/lia_surgicalkit/cl_init.lua:49` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/entities/weapons/lia_surgicalkit/cl_init.lua:54` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/client.lua:156` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:173` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:180` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:209` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:241` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries`

### Module Documentation Report

- **Undocumented Hooks:**
  - `liaInjuriesPostPlayerRevive()`

- **Undocumented Meta Functions:**
  - `playerMeta:addInjury()`
  - `playerMeta:clearAllInjuries()`
  - `playerMeta:hasInjury()`
  - `playerMeta:removeInjury()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries | 1 | 0 | 4 |
