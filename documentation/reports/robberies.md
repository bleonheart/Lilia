## Executive Summary

### Function Documentation
- **Total Functions:** 6
- **Documented:** 0 (0.0%)
- **Missing Functions:** 6 unique (6 total occurrences)
  - **Library Functions:** 6
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 3 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 3

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 13
- **Used Net Messages:** 13
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 45

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 6 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 6 functions

#### lia.robberies
Count: 6 functions

- `lia.robberies.beginEntityCooldown()`
- `lia.robberies.canRob()`
- `lia.robberies.registerEntity()`
- `lia.robberies.releaseEntity()`
- `lia.robberies.reserveEntity()`
- `lia.robberies.robberyReward()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 3 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 3
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 3 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `RobberyLootGranted`
  - module `robberies` [standard] in `libraries/server.lua`
- `RobberyMinigameFinished`
  - module `robberies` [standard] in `libraries/server.lua`
- `RobberyMinigameStarted`
  - module `robberies` [standard] in `libraries/server.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `RobberyLootGranted()`
- `RobberyMinigameFinished()`
- `RobberyMinigameStarted()`

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
| `ITEM.desc` | Unlocalized string | `An item obtained from a robbery. It looks valuable.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\items\base\robbery.lua | 7 |
| `ITEM.name` | Unlocalized string | `Robbery Item` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\items\base\robbery.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Six visual robbery examples using timing-hit, rotating-maze, line-trace, rotating-ring, pressure-drill, and laser-mirror minigames with server-authoritative validation and physical stolen loot.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\module.lua | 7 |
| `MODULE.name` | Missing key | `Robberies` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\module.lua | 5 |
| `Privilege.Category` | Missing key | `Robbery` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 338 |
| `data.category` | Missing key | `Robbery` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\items\base\robbery.lua | 5 |
| `data.category` | Missing key | `all` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\client.lua | 67 |
| `data.category` | Missing key | `all` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\client.lua | 381 |
| `data.category` | Missing key | `Robbery` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 310 |
| `data.desc` | Unlocalized string | `An item obtained from a robbery. It looks valuable.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\items\base\robbery.lua | 7 |
| `data.desc` | Unlocalized string | `A bundle of encoded access cards taken from a secured facility.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 13 |
| `data.desc` | Unlocalized string | `A documented collection of rare coins with traceable provenance.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 22 |
| `data.desc` | Unlocalized string | `Unregistered financial instruments requiring a specialist buyer.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 31 |
| `data.desc` | Unlocalized string | `A sealed dossier containing compromising corporate and personal records.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 40 |
| `data.desc` | Unlocalized string | `A bundled stack of stolen currency.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 49 |
| `data.desc` | Unlocalized string | `A sealed cash cartridge removed from an automated teller machine.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 58 |
| `data.desc` | Unlocalized string | `A locked carrier containing high-denomination casino chips.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 67 |
| `data.desc` | Unlocalized string | `A captured rolling-code key fob linked to a high-value vehicle.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 76 |
| `data.desc` | Unlocalized string | `A stolen collection of privileged credentials and access tokens.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 85 |
| `data.desc` | Unlocalized string | `Fresh authorization codes capable of releasing seized or bonded cargo.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 94 |
| `data.desc` | Unlocalized string | `A high-value ring sought by specialist buyers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 103 |
| `data.desc` | Unlocalized string | `A dense encrypted archive copied from a protected server rack.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 112 |
| `data.desc` | Unlocalized string | `A privileged access token issued after a successful social-engineering breach.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 121 |
| `data.desc` | Unlocalized string | `A set of counterfeit credentials accepted by several restricted facilities.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 130 |
| `data.desc` | Unlocalized string | `A valuable watch with identifying marks still attached.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 139 |
| `data.desc` | Unlocalized string | `A confidential casino ledger containing valuable financial and personal records.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 148 |
| `data.desc` | Unlocalized string | `Specialized components stolen from secured warehouse inventory.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 157 |
| `data.desc` | Unlocalized string | `A bag containing assorted stolen jewelry.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 166 |
| `data.desc` | Unlocalized string | `Compact high-end electronics with identifying serial numbers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 175 |
| `data.desc` | Unlocalized string | `A catalogued historical relic removed from a pressure-protected display.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 184 |
| `data.desc` | Unlocalized string | `Unreleased control firmware extracted from a restricted security terminal.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 193 |
| `data.desc` | Unlocalized string | `A valuable shipment removed before its manifest could be verified.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 202 |
| `data.desc` | Unlocalized string | `A stolen drive containing access records and security credentials.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 211 |
| `data.desc` | Unlocalized string | `A confidential schedule detailing patrol assignments and access windows.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 220 |
| `data.desc` | Unlocalized string | `A stolen manifest linking valuable cargo to private delivery routes.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 229 |
| `data.desc` | Unlocalized string | `A distinctive collector piece removed from a protected cabinet.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 238 |
| `data.desc` | Unlocalized string | `Sensitive records that can be sold through criminal contacts.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 247 |
| `data.desc` | Unlocalized string | `A copied archive containing private camera footage and movement records.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 256 |
| `data.desc` | Unlocalized string | `A secured case of uncut stones taken from a private jewelry vault.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 265 |
| `data.desc` | Unlocalized string | `A copied archive of private vault access footage and security schedules.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 274 |
| `data.desc` | Unlocalized string | `A reinforced case packed with traceable stolen currency.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 283 |
| `data.desc` | Unlocalized string | `An encoded control module removed from a secured vehicle compartment.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 292 |
| `data.desc` | Unlocalized string | `Six visual robbery examples using timing-hit, rotating-maze, line-trace, rotating-ring, pressure-drill, and laser-mirror minigames with server-authoritative validation and physical stolen loot.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\module.lua | 7 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\entities\entities\lia_robbery\shared.lua | 6 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\libraries\shared.lua | 337 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 13
- **Used Net Messages:** 13
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
- **Registered Panels:** 3
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 3
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `liaFenceSellPanel` | `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:598` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` |
| `liaFenceBuyPanel` | `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:995` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` |
| `liaRobberyMinigamePanel` | `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1879` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 13
- **UI / Derma Code Outside derma:** 3

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:603` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:613` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:632` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1000` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1005` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1880` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1886` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1891` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1152` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1187` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1382` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1398` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1470` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:598` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` | Module Derma code is outside the derma folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:995` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` | Module Derma code is outside the derma folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1879` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies`

### Module Documentation Report

- **Undocumented Hooks:**
  - `RobberyLootGranted()`
  - `RobberyMinigameFinished()`
  - `RobberyMinigameStarted()`

- **Undocumented lia.* Functions:**
  - `lia.robberies.beginEntityCooldown()`
  - `lia.robberies.canRob()`
  - `lia.robberies.registerEntity()`
  - `lia.robberies.releaseEntity()`
  - `lia.robberies.reserveEntity()`
  - `lia.robberies.robberyReward()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies | 3 | 6 | 0 |
