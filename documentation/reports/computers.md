## Executive Summary

### Function Documentation
- **Total Functions:** 8
- **Documented:** 0 (0.0%)
- **Missing Functions:** 8 unique (8 total occurrences)
  - **Library Functions:** 8
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 11 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 11

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 21
- **Used Net Messages:** 18
- **Defined But Unused:** 3
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 2
- **Undefined Inferred Localization Keys:** 46

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 8 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 8 functions

#### lia.computers
Count: 8 functions

- `lia.computers.generateButton()`
- `lia.computers.generateComputer()`
- `lia.computers.getAppPanelDefinition()`
- `lia.computers.getButtonsForComputer()`
- `lia.computers.getComputer()`
- `lia.computers.getPopupDefinition()`
- `lia.computers.registerAppPanel()`
- `lia.computers.registerPopup()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 11 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 11
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 11 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `ComputerAppPanelRegistered`
  - module `computers` [standard] in `libraries/shared.lua`
- `ComputerAppWindowClosed`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerAppWindowCreated`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerButtonClicked`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerPopupClosed`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerPopupCreated`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerPopupRegistered`
  - module `computers` [standard] in `libraries/shared.lua`
- `ComputerUIBuilt`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerUIReady`
  - module `computers` [standard] in `libraries/client.lua`
- `GetComputerBackground`
  - module `computers` [standard] in `libraries/client.lua`
- `GetComputerScreenBounds`
  - module `computers` [standard] in `libraries/client.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `ComputerAppPanelRegistered()`
- `ComputerAppWindowClosed()`
- `ComputerAppWindowCreated()`
- `ComputerButtonClicked()`
- `ComputerPopupClosed()`
- `ComputerPopupCreated()`
- `ComputerPopupRegistered()`
- `ComputerUIBuilt()`
- `ComputerUIReady()`
- `GetComputerBackground()`
- `GetComputerScreenBounds()`

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
| `ITEM.desc` | Unlocalized string | `A radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\items\lia_radio.lua | 2 |
| `ITEM.name` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\items\lia_radio.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive computer system featuring interactive computer entities with customizable desktop interfaces, built-in applications including Notes, web browser functionality, and game integration. Provides network communication for computer interactions, popup management, and extensible app panel system for creating custom computer applications within the Lilia RP framework.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 10 |
| `MODULE.desc` | Unlocalized string | `Comprehensive radio communication framework featuring handheld radios and stationary broadcast units with frequency tuning, encrypted faction channels, preset stations, range-based transmission, static noise effects, and Star Wars RP comlink compatibility. Supports both item-based and entity-based radio devices with real-time voice transmission, channel management, and secure communications for different factions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\module.lua | 8 |
| `MODULE.name` | Missing key | `Computers` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 7 |
| `MODULE.name` | Unlocalized string | `Advanced Radio Communication` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\module.lua | 6 |
| `Privilege.Category` | Missing key | `Computers` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\entities\entities\lia_computer\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Computers` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\libraries\shared.lua | 93 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\entities\lia_staticradio\shared.lua | 11 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\weapons\lia_radio\shared.lua | 9 |
| `data.category` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 3 |
| `data.category` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 10 |
| `data.category` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 17 |
| `data.category` | Unlocalized string | `Radio Presets` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 27 |
| `data.category` | Missing key | `General` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 324 |
| `data.desc` | Unlocalized string | `A small handheld console with Tetris installed. Allows access to the game on computers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\items\tetris.lua | 3 |
| `data.desc` | Unlocalized string | `Comprehensive computer system featuring interactive computer entities with customizable desktop interfaces, built-in applications including Notes, web browser functionality, and game integration. Provides network communication for computer interactions, popup management, and extensible app panel system for creating custom computer applications within the Lilia RP framework.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 10 |
| `data.desc` | Unlocalized string | `Oversees ethical conduct, policy enforcement, and internal accountability.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 30 |
| `data.desc` | Unlocalized string | `A specialized task force assigned to high-risk containment, recovery, and security operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 38 |
| `data.desc` | Unlocalized string | `Conducts scientific research, testing, and documentation of anomalies.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 46 |
| `data.desc` | Unlocalized string | `Maintains site security, protects personnel, and responds to internal threats.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 54 |
| `data.desc` | Unlocalized string | `Manages site operations, personnel coordination, and administrative authority.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 62 |
| `data.desc` | Unlocalized string | `A standard Ethics Committee representative responsible for reviewing internal conduct and compliance.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 70 |
| `data.desc` | Unlocalized string | `A senior Ethics Committee authority responsible for final ethical review and high-level oversight.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 78 |
| `data.desc` | Unlocalized string | `A standard Mobile Task Force operative assigned to containment and response operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 86 |
| `data.desc` | Unlocalized string | `A commanding Mobile Task Force officer responsible for tactical leadership and mission coordination.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 94 |
| `data.desc` | Unlocalized string | `A standard Research Division scientist responsible for testing, documentation, and study.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 102 |
| `data.desc` | Unlocalized string | `An experienced Research Division scientist responsible for advanced projects and research supervision.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 110 |
| `data.desc` | Unlocalized string | `A standard Security Division officer responsible for maintaining site order and responding to threats.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 118 |
| `data.desc` | Unlocalized string | `A senior Security Division officer responsible for squad leadership and site defense coordination.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 126 |
| `data.desc` | Unlocalized string | `A Site Administration member responsible for managing daily operations and personnel coordination.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 134 |
| `data.desc` | Unlocalized string | `The highest-ranking site authority responsible for administrative command and strategic decisions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\module.lua | 142 |
| `data.desc` | Missing key | `radioRequireRadioOperatorDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 5 |
| `data.desc` | Missing key | `radioEnableRadioSWEPDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 12 |
| `data.desc` | Missing key | `radioRadioIsStarWarsRPDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 19 |
| `data.desc` | Unlocalized string | `A radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\items\lia_radio.lua | 2 |
| `data.desc` | Unlocalized string | `Radio narrator for feedback messages` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 9 |
| `data.desc` | Unlocalized string | `Enable radio communication for players with tuned radios within range or matching frequency` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 75 |
| `data.desc` | Unlocalized string | `Talk on radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 323 |
| `data.desc` | Unlocalized string | `Comprehensive radio communication framework featuring handheld radios and stationary broadcast units with frequency tuning, encrypted faction channels, preset stations, range-based transmission, static noise effects, and Star Wars RP comlink compatibility. Supports both item-based and entity-based radio devices with real-time voice transmission, channel management, and secure communications for different factions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\module.lua | 8 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\entities\entities\lia_computer\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\entities\lia_staticradio\shared.lua | 10 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\weapons\lia_radio\shared.lua | 7 |
| `lia.config.add:name` | Missing key | `radioRequireRadioOperator` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 2 |
| `lia.config.add:name` | Missing key | `radioEnableRadioSWEP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 9 |
| `lia.config.add:name` | Missing key | `radioRadioIsStarWarsRP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 16 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 21
- **Used Net Messages:** 18
- **Defined But Unused:** 3
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

- `liaBrowserNavigate`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_browser.lua:118
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:168
- `liaEmailFetch`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:846; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:850
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:358
- `liaEmailMarkRead`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:659
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:494
- `liaEmailRegister`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:874
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:363
- `liaEmailSend`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:919
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:408
- `liaNotesDelete`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_notes.lua:486
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:130
- `liaNotesFetch`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_notes.lua:443
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:70
- `liaNotesSave`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_notes.lua:466
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:82
- `liaRadioComlinkAnim`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:340; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:373; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/shared.lua:355; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/shared.lua:427
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:182; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:213
- `liaRadioTransmit`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:335; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:350; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:367; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:383; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/shared.lua:347
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:137; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:168

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
- **Net Handlers Outside netcalls:** 21
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/client.lua:879` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/client.lua:886` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/client.lua:895` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:70` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:82` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:130` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:168` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:358` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:363` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:408` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:494` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/entities/weapons/lia_radio/init.lua:94` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/entities/weapons/lia_radio/init.lua:105` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/entities/weapons/lia_radio/init.lua:112` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/client.lua:154` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/client.lua:179` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:137` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:144` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:157` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:172` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:182` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

Total: **2** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `ChatRange` | 2 |

### Details

#### `ChatRange`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua** line 81: `local speakRange = lia.config.get("ChatRange", 280)`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua** line 147: `local speakRange = lia.config.get("ChatRange", 280)`

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ComputerAppPanelRegistered()`
  - `ComputerAppWindowClosed()`
  - `ComputerAppWindowCreated()`
  - `ComputerButtonClicked()`
  - `ComputerPopupClosed()`
  - `ComputerPopupCreated()`
  - `ComputerPopupRegistered()`
  - `ComputerUIBuilt()`
  - `ComputerUIReady()`
  - `GetComputerBackground()`
  - `GetComputerScreenBounds()`

- **Undocumented lia.* Functions:**
  - `lia.computers.generateButton()`
  - `lia.computers.generateComputer()`
  - `lia.computers.getAppPanelDefinition()`
  - `lia.computers.getButtonsForComputer()`
  - `lia.computers.getComputer()`
  - `lia.computers.getPopupDefinition()`
  - `lia.computers.registerAppPanel()`
  - `lia.computers.registerPopup()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers | 11 | 8 | 0 |
