## Executive Summary

### Function Documentation
- **Total Functions:** 10
- **Documented:** 0 (0.0%)
- **Missing Functions:** 10 unique (10 total occurrences)
  - **Library Functions:** 9
  - **Hook Functions:** 0
  - **Meta Functions:** 1

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
- **Defined Net Messages:** 10
- **Used Net Messages:** 7
- **Defined But Unused:** 3
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 2
- **Undefined Inferred Localization Keys:** 24

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 10 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 9 functions

#### lia.radio
Count: 9 functions

- `lia.radio.canAccessEncryptedFrequency()`
- `lia.radio.canAccessStaticalRadio()`
- `lia.radio.checkEncryptedFrequencyStatus()`
- `lia.radio.getPresetName()`
- `lia.radio.isVoiceViable()`
- `lia.radio.registerEncryptedFrequency()`
- `lia.radio.registerPresetFrequency()`
- `lia.radio.startStaticMonitoring()`
- `lia.radio.stopStaticMonitoring()`

### Missing Meta Functions
Total: 1 functions

#### playerMeta
Count: 1 functions

- `playerMeta:getPlayerRadioFrequency()`

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
- `ShouldRadioBeep`
  - submodule `radio` [standard] in `libraries/shared.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `ShouldRadioBeep()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive radio communication framework featuring handheld radios and stationary broadcast units with frequency tuning, encrypted faction channels, preset stations, range-based transmission, static noise effects, and Star Wars RP comlink compatibility. Supports both item-based and entity-based radio devices with real-time voice transmission, channel management, and secure communications for different factions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\module.lua | 8 |
| `MODULE.name` | Unlocalized string | `Advanced Radio Communication` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\module.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\entities\lia_staticradio\shared.lua | 11 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\weapons\lia_radio\shared.lua | 9 |
| `data.category` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 3 |
| `data.category` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 10 |
| `data.category` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 17 |
| `data.category` | Unlocalized string | `Radio Presets` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 27 |
| `data.category` | Missing key | `General` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 324 |
| `data.desc` | Missing key | `radioRequireRadioOperatorDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 5 |
| `data.desc` | Missing key | `radioEnableRadioSWEPDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 12 |
| `data.desc` | Missing key | `radioRadioIsStarWarsRPDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 19 |
| `data.desc` | Unlocalized string | `A radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\items\lia_radio.lua | 2 |
| `data.desc` | Unlocalized string | `Radio narrator for feedback messages` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 9 |
| `data.desc` | Unlocalized string | `Enable radio communication for players with tuned radios within range or matching frequency` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 75 |
| `data.desc` | Unlocalized string | `Talk on radio` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua | 323 |
| `data.desc` | Unlocalized string | `Comprehensive radio communication framework featuring handheld radios and stationary broadcast units with frequency tuning, encrypted faction channels, preset stations, range-based transmission, static noise effects, and Star Wars RP comlink compatibility. Supports both item-based and entity-based radio devices with real-time voice transmission, channel management, and secure communications for different factions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\module.lua | 8 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\entities\lia_staticradio\shared.lua | 10 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\entities\weapons\lia_radio\shared.lua | 7 |
| `lia.config.add:name` | Missing key | `radioRequireRadioOperator` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 2 |
| `lia.config.add:name` | Missing key | `radioEnableRadioSWEP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 9 |
| `lia.config.add:name` | Missing key | `radioRadioIsStarWarsRP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\config\shared.lua | 16 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 10
- **Used Net Messages:** 7
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

Total suspicious patterns: **2**

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
- **Net Handlers Outside netcalls:** 10
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ShouldRadioBeep()`

- **Undocumented lia.* Functions:**
  - `lia.radio.canAccessEncryptedFrequency()`
  - `lia.radio.canAccessStaticalRadio()`
  - `lia.radio.checkEncryptedFrequencyStatus()`
  - `lia.radio.getPresetName()`
  - `lia.radio.isVoiceViable()`
  - `lia.radio.registerEncryptedFrequency()`
  - `lia.radio.registerPresetFrequency()`
  - `lia.radio.startStaticMonitoring()`
  - `lia.radio.stopStaticMonitoring()`

- **Undocumented Meta Functions:**
  - `playerMeta:getPlayerRadioFrequency()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio | 1 | 9 | 1 |
