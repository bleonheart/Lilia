## Executive Summary

### Function Documentation
- **Total Functions:** 17
- **Documented:** 0 (0.0%)
- **Missing Functions:** 17 unique (17 total occurrences)
  - **Library Functions:** 17
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 8 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 8

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 32
- **Used Net Messages:** 32
- **Defined But Unused:** 3
- **Used But Undefined:** 3

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 58

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 17 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 17 functions

#### lia.police
Count: 17 functions

- `lia.police.askQuizQuestion()`
- `lia.police.clearAllWarrants()`
- `lia.police.finishQuiz()`
- `lia.police.getJailFilePath()`
- `lia.police.getJailMapKey()`
- `lia.police.getJails()`
- `lia.police.getLegalArrestReasons()`
- `lia.police.getQuizResults()`
- `lia.police.getQuizResultsByCharID()`
- `lia.police.hasActiveWarrants()`
- `lia.police.issueFine()`
- `lia.police.payAllFinesFromAccount()`
- `lia.police.payFine()`
- `lia.police.payFineFromAccount()`
- `lia.police.saveJails()`
- `lia.police.saveQuizResult()`
- `lia.police.syncJails()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 8 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 8
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 8 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `FineIssued`
  - module `policesuite` [standard] in `libraries/server.lua`
- `FinePaid`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PlayerArrested`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PlayerReleasedFromJail`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PlayerReleasedOffline`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PoliceComputerAddRegistrySection`
  - module `policesuite` [standard] in `libraries/client.lua`
- `WarrantIssued`
  - module `policesuite` [standard] in `libraries/server.lua`
- `WarrantsCleared`
  - module `policesuite` [standard] in `libraries/server.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `FineIssued()`
- `FinePaid()`
- `PlayerArrested()`
- `PlayerReleasedFromJail()`
- `PlayerReleasedOffline()`
- `PoliceComputerAddRegistrySection()`
- `WarrantIssued()`
- `WarrantsCleared()`

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
| `ITEM.desc` | Unlocalized string | `A file to scratch the serial number off a gun.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\items\file.lua | 2 |
| `ITEM.name` | Missing key | `File` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\items\file.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Complete law enforcement management system featuring 23-tier police rank hierarchy with progressive salaries and equipment kits, comprehensive criminal code with detailed offenses and sentencing guidelines, advanced police computer database with real-time criminal records, warrant management, and serial number tracking, specialized police equipment including tasers, nightsticks, and finebooks, dynamic jail cell management system with map-specific configurations, police locker and NPC integration, dispatcher system for citizen help requests, internal affairs oversight, and extensive administrative privileges for police faction management.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 4 |
| `MODULE.name` | Missing key | `Policesuite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 2 |
| `Privilege.Category` | Missing key | `policesuite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\client.lua | 49 |
| `Privilege.Category` | Missing key | `policesuite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\server.lua | 207 |
| `Privilege.Category` | Unlocalized string | `Police Suite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\entities\lia_policecomputer\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Police Suite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\entities\lia_policelocker\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Police Suite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\weapons\lia_finebook\shared.lua | 11 |
| `Privilege.Category` | Unlocalized string | `Police Suite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\weapons\lia_nightstick\shared.lua | 19 |
| `Privilege.Category` | Unlocalized string | `Police Suite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\weapons\lia_taser\shared.lua | 5 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 28 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 33 |
| `Privilege.Name` | Missing key | `policeSetRank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\client.lua | 48 |
| `Privilege.Name` | Missing key | `policeSetRank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\server.lua | 206 |
| `Privilege.Name` | Unlocalized string | `Bypass Police Faction Check` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 26 |
| `Privilege.Name` | Unlocalized string | `Bypass Police Promotion Check` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 31 |
| `data.category` | Missing key | `Police` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 3 |
| `data.category` | Missing key | `Police` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 11 |
| `data.category` | Missing key | `Police` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 19 |
| `data.category` | Missing key | `Police` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 25 |
| `data.category` | Missing key | `policesuite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\hooks\client.lua | 179 |
| `data.category` | Missing key | `policesuite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\hooks\client.lua | 194 |
| `data.category` | Missing key | `policesuite` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\hooks\client.lua | 224 |
| `data.category` | Missing key | `Police` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\pim.lua | 2 |
| `data.desc` | Unlocalized string | `Call emergency services` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\client.lua | 2 |
| `data.desc` | Unlocalized string | `Promote a police officer to the next rank (or specific rank with privileges)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\client.lua | 13 |
| `data.desc` | Unlocalized string | `Demote a police officer to the previous rank (or specific rank with privileges)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\client.lua | 24 |
| `data.desc` | Unlocalized string | `Set a police officer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\client.lua | 35 |
| `data.desc` | Unlocalized string | `Call emergency services` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\server.lua | 3 |
| `data.desc` | Unlocalized string | `Promote a police officer to the next rank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\server.lua | 70 |
| `data.desc` | Unlocalized string | `Demote a police officer to the previous rank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\server.lua | 137 |
| `data.desc` | Unlocalized string | `Set a police officer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\commands\server.lua | 204 |
| `data.desc` | Unlocalized string | `Duration of nightstick stun in seconds` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1249 |
| `data.desc` | Unlocalized string | `Duration of taser ragdoll effect in seconds` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1257 |
| `data.desc` | Unlocalized string | `Maximum range of the taser cable in units` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1265 |
| `data.desc` | Unlocalized string | `Delay between taser shots in seconds` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1273 |
| `data.desc` | Unlocalized string | `Damage dealt per shock when using secondary fire` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1281 |
| `data.desc` | Unlocalized string | `Cooldown between 911 calls in seconds` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1289 |
| `data.desc` | Missing key | `policeJailTimeMultiplierDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 7 |
| `data.desc` | Missing key | `policeFineMultiplierDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 15 |
| `data.desc` | Missing key | `policeAutoJailDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 21 |
| `data.desc` | Missing key | `policeRequireWarrantDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 27 |
| `data.desc` | Unlocalized string | `A file to scratch the serial number off a gun.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\items\file.lua | 2 |
| `data.desc` | Unlocalized string | `Complete law enforcement management system featuring 23-tier police rank hierarchy with progressive salaries and equipment kits, comprehensive criminal code with detailed offenses and sentencing guidelines, advanced police computer database with real-time criminal records, warrant management, and serial number tracking, specialized police equipment including tasers, nightsticks, and finebooks, dynamic jail cell management system with map-specific configurations, police locker and NPC integration, dispatcher system for citizen help requests, internal affairs oversight, and extensive administrative privileges for police faction management.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\module.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\entities\lia_policecomputer\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\entities\lia_policelocker\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\entities\weapons\lia_nightstick\shared.lua | 16 |
| `lia.config.add:name` | Unlocalized string | `Nightstick Stun Duration` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1248 |
| `lia.config.add:name` | Unlocalized string | `Taser Ragdoll Duration` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1256 |
| `lia.config.add:name` | Unlocalized string | `Taser Range` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1264 |
| `lia.config.add:name` | Unlocalized string | `Taser Fire Delay` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1272 |
| `lia.config.add:name` | Unlocalized string | `Taser Shock Damage` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1280 |
| `lia.config.add:name` | Unlocalized string | `911 Call Cooldown` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config.lua | 1288 |
| `lia.config.add:name` | Missing key | `policeJailTimeMultiplier` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 2 |
| `lia.config.add:name` | Missing key | `policeFineMultiplier` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 10 |
| `lia.config.add:name` | Missing key | `policeAutoJail` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 18 |
| `lia.config.add:name` | Missing key | `policeRequireWarrant` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\config\shared.lua | 24 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 32
- **Used Net Messages:** 32
- **Defined But Unused:** 3
- **Used But Undefined:** 3

### Used But Undefined

- `liaBankingReceiveBankBalance`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:939; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:1056
- `liaBankingSendBankGUI`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/hooks/client.lua:315
- `liaJobNpcCloseDialog`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:1763; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2629

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

Total suspicious patterns: **9**

- `liaJailerOpenViewPrisoners`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2636
- `liaJobNpcCloseDialog`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:852; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:908; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1420; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1550; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1606
  - Receiver sites: None
- `liaPoliceComputerOpen`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2641
- `liaPoliceJailsSync`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:49
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:65
- `liaPolicePayAllFinesFromAccount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2646
- `liaPolicePayFineFromAccount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2633
- `liaPoliceSetRank`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2893
- `liaReportsFetch`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:2040; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:2048
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3299
- `liaReportsSave`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:1982
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3325

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 1
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 1
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `liaPoliceComputer` | `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:1572` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 26
- **UI / Derma Code Outside derma:** 1

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:1573` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2061` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2557` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2595` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2636` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2641` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2694` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2868` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:3128` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:3134` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:3142` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:1906` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2374` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2496` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2542` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2633` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2646` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2658` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2670` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2874` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2893` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2949` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2981` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3299` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3325` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:65` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:1572` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite`

### Module Documentation Report

- **Undocumented Hooks:**
  - `FineIssued()`
  - `FinePaid()`
  - `PlayerArrested()`
  - `PlayerReleasedFromJail()`
  - `PlayerReleasedOffline()`
  - `PoliceComputerAddRegistrySection()`
  - `WarrantIssued()`
  - `WarrantsCleared()`

- **Undocumented lia.* Functions:**
  - `lia.police.askQuizQuestion()`
  - `lia.police.clearAllWarrants()`
  - `lia.police.finishQuiz()`
  - `lia.police.getJailFilePath()`
  - `lia.police.getJailMapKey()`
  - `lia.police.getJails()`
  - `lia.police.getLegalArrestReasons()`
  - `lia.police.getQuizResults()`
  - `lia.police.getQuizResultsByCharID()`
  - `lia.police.hasActiveWarrants()`
  - `lia.police.issueFine()`
  - `lia.police.payAllFinesFromAccount()`
  - `lia.police.payFine()`
  - `lia.police.payFineFromAccount()`
  - `lia.police.saveJails()`
  - `lia.police.saveQuizResult()`
  - `lia.police.syncJails()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite | 8 | 17 | 0 |
