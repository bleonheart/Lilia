## Executive Summary

### Function Documentation
- **Total Functions:** 41
- **Documented:** 0 (0.0%)
- **Missing Functions:** 41 unique (41 total occurrences)
  - **Library Functions:** 37
  - **Hook Functions:** 0
  - **Meta Functions:** 4

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
- **Undefined lia.config.get Keys:** 2
- **Undefined Inferred Localization Keys:** 15

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 41 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 37 functions

#### lia.cellphones
Count: 37 functions

- `lia.cellphones.answerSession()`
- `lia.cellphones.beginTelephoneRinging()`
- `lia.cellphones.buildDialerPayload()`
- `lia.cellphones.buildOriginEndpoint()`
- `lia.cellphones.clearPlayerState()`
- `lia.cellphones.clearTelephoneState()`
- `lia.cellphones.copyEndpoint()`
- `lia.cellphones.createSession()`
- `lia.cellphones.endCallForPlayer()`
- `lia.cellphones.endSession()`
- `lia.cellphones.findPlayerByPhoneNumber()`
- `lia.cellphones.findTelephoneByNumber()`
- `lia.cellphones.generatePhoneNumber()`
- `lia.cellphones.getConnectedPeer()`
- `lia.cellphones.getEndpointUser()`
- `lia.cellphones.getPeerEndpoint()`
- `lia.cellphones.getPlayerCellphoneItem()`
- `lia.cellphones.getPlayerPhoneNumber()`
- `lia.cellphones.getPlayerSession()`
- `lia.cellphones.getSessionByID()`
- `lia.cellphones.getSessionByNumber()`
- `lia.cellphones.hangup()`
- `lia.cellphones.isCellphoneNumberTaken()`
- `lia.cellphones.isPhoneNumberTaken()`
- `lia.cellphones.isTelephoneNumberTaken()`
- `lia.cellphones.linkVoiceUsers()`
- `lia.cellphones.normalizePhoneNumber()`
- `lia.cellphones.openCellphoneDialer()`
- `lia.cellphones.openDialer()`
- `lia.cellphones.openTelephoneDialer()`
- `lia.cellphones.resolveNumber()`
- `lia.cellphones.sendDialer()`
- `lia.cellphones.sendSessionUpdate()`
- `lia.cellphones.setPlayerSessionState()`
- `lia.cellphones.startCall()`
- `lia.cellphones.startCallFromCellphone()`
- `lia.cellphones.stopTelephoneRinging()`

### Missing Meta Functions
Total: 4 functions

#### playerMeta
Count: 4 functions

- `playerMeta:connectedPair()`
- `playerMeta:getPartner()`
- `playerMeta:hasCallPair()`
- `playerMeta:setPartner()`

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
| `ITEM.desc` | Unlocalized string | `A portable phone tied into the local network, ready for calls from payphones and other handsets alike.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\items\cellphone.lua | 2 |
| `ITEM.name` | Unlocalized string | `Mobile Phone` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\items\cellphone.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Connects handheld phones and placed telephones through a shared network with direct dialing, ringing, answering, hangups, and live voice routing between both endpoint types.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\module.lua | 5 |
| `MODULE.name` | Missing key | `Cellphones` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\module.lua | 3 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\entities\entities\telephone.lua | 3 |
| `data.category` | Missing key | `Communication` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\pim.lua | 3 |
| `data.category` | Missing key | `Communication` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\pim.lua | 25 |
| `data.category` | Missing key | `Communication` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\pim.lua | 47 |
| `data.category` | Missing key | `Communication` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\pim.lua | 97 |
| `data.desc` | Unlocalized string | `Call another phone by its number` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\commands.lua | 2 |
| `data.desc` | Unlocalized string | `Send SMS to another player by their phone number` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\commands.lua | 26 |
| `data.desc` | Unlocalized string | `A portable phone tied into the local network, ready for calls from payphones and other handsets alike.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\items\cellphone.lua | 2 |
| `data.desc` | Unlocalized string | `Enable private phone chat between paired players` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\libraries\shared.lua | 18 |
| `data.desc` | Unlocalized string | `Send SMS messages to other players` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\libraries\shared.lua | 31 |
| `data.desc` | Unlocalized string | `Connects handheld phones and placed telephones through a shared network with direct dialing, ringing, answering, hangups, and live voice routing between both endpoint types.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\module.lua | 5 |

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
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/derma/cl_phone_dialer.lua:497` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/derma/cl_phone_dialer.lua:498` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/libraries/server.lua:609` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/libraries/server.lua:614` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/libraries/server.lua:622` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

Total: **2** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `ChatColor` | 2 |

### Details

#### `ChatColor`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\libraries\shared.lua** line 20: `onChatAdd = function(speaker, text) chat.AddText(Color(0, 200, 0), "[Phone] ", lia.config.get("ChatColor"), speaker:Name() .. ": " .. text) end,`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\libraries\shared.lua** line 46: `chat.AddText(Color(0, 150, 255), "[SMS] ", lia.config.get("ChatColor"), "PHONE NUMBER: " .. phoneNumber .. ": " .. text)`

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.cellphones.answerSession()`
  - `lia.cellphones.beginTelephoneRinging()`
  - `lia.cellphones.buildDialerPayload()`
  - `lia.cellphones.buildOriginEndpoint()`
  - `lia.cellphones.clearPlayerState()`
  - `lia.cellphones.clearTelephoneState()`
  - `lia.cellphones.copyEndpoint()`
  - `lia.cellphones.createSession()`
  - `lia.cellphones.endCallForPlayer()`
  - `lia.cellphones.endSession()`
  - `lia.cellphones.findPlayerByPhoneNumber()`
  - `lia.cellphones.findTelephoneByNumber()`
  - `lia.cellphones.generatePhoneNumber()`
  - `lia.cellphones.getConnectedPeer()`
  - `lia.cellphones.getEndpointUser()`
  - `lia.cellphones.getPeerEndpoint()`
  - `lia.cellphones.getPlayerCellphoneItem()`
  - `lia.cellphones.getPlayerPhoneNumber()`
  - `lia.cellphones.getPlayerSession()`
  - `lia.cellphones.getSessionByID()`
  - `lia.cellphones.getSessionByNumber()`
  - `lia.cellphones.hangup()`
  - `lia.cellphones.isCellphoneNumberTaken()`
  - `lia.cellphones.isPhoneNumberTaken()`
  - `lia.cellphones.isTelephoneNumberTaken()`
  - `lia.cellphones.linkVoiceUsers()`
  - `lia.cellphones.normalizePhoneNumber()`
  - `lia.cellphones.openCellphoneDialer()`
  - `lia.cellphones.openDialer()`
  - `lia.cellphones.openTelephoneDialer()`
  - `lia.cellphones.resolveNumber()`
  - `lia.cellphones.sendDialer()`
  - `lia.cellphones.sendSessionUpdate()`
  - `lia.cellphones.setPlayerSessionState()`
  - `lia.cellphones.startCall()`
  - `lia.cellphones.startCallFromCellphone()`
  - `lia.cellphones.stopTelephoneRinging()`

- **Undocumented Meta Functions:**
  - `playerMeta:connectedPair()`
  - `playerMeta:getPartner()`
  - `playerMeta:hasCallPair()`
  - `playerMeta:setPartner()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones | 0 | 37 | 4 |
