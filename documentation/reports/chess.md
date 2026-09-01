## Executive Summary

### Function Documentation
- **Total Functions:** 16
- **Documented:** 0 (0.0%)
- **Missing Functions:** 16 unique (16 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 16

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
- **Defined Net Messages:** 9
- **Used Net Messages:** 9
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 7

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 16 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Meta Functions
Total: 16 functions

#### playerMeta
Count: 16 functions

- `playerMeta:chessDraw()`
- `playerMeta:chessWin()`
- `playerMeta:doChessElo()`
- `playerMeta:doDraughtsElo()`
- `playerMeta:draughtsDraw()`
- `playerMeta:draughtsWin()`
- `playerMeta:expectedChessWin()`
- `playerMeta:expectedDraughtsWin()`
- `playerMeta:getChessElo()`
- `playerMeta:getChessEloWithRecognition()`
- `playerMeta:getChessKFactor()`
- `playerMeta:getDraughtsElo()`
- `playerMeta:getDraughtsEloWithRecognition()`
- `playerMeta:getDraughtsKFactor()`
- `playerMeta:setChessElo()`
- `playerMeta:setDraughtsElo()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive chess and draughts (checkers) gaming system featuring fully interactive board games with real-time multiplayer support, Elo rating system with K-factor customization, persistent game statistics tracking, wagering mechanics for competitive play, global leaderboards, draw/resign functionality, pawn promotion selection, and seamless integration with the Lilia framework` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\module.lua | 4 |
| `MODULE.name` | Missing key | `Chess` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\module.lua | 2 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\entities\entities\lia_chess_board.lua | 46 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\entities\entities\lia_draughts_board.lua | 30 |
| `data.desc` | Unlocalized string | `Comprehensive chess and draughts (checkers) gaming system featuring fully interactive board games with real-time multiplayer support, Elo rating system with K-factor customization, persistent game statistics tracking, wagering mechanics for competitive play, global leaderboards, draw/resign functionality, pawn promotion selection, and seamless integration with the Lilia framework` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\module.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\entities\entities\lia_chess_board.lua | 44 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\entities\entities\lia_draughts_board.lua | 28 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 9
- **Used Net Messages:** 9
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

Total suspicious patterns: **9**

- `liaChessClientCallDraw`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1542; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1554
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2169
- `liaChessClientRequestMove`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1445
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2120
- `liaChessClientResign`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1533; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1638; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_draughts_board.lua:774
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2137
- `liaChessClientWager`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1628; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1647
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2226
- `liaChessDrawOffer`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1523; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2164; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_draughts_board.lua:764
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1998; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2144
- `liaChessGameOver`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:236; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:985; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:999; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1380; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1396
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1999
- `liaChessPromotionSelection`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1358; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2031; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2044; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2057; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2070
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2017; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2323
- `liaChessTop10`
  - Reason: Message appears to send and receive only on the client side
  - Send sides: client
  - Receive sides: client
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/chess/cl_top.lua:36
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/chess/cl_top.lua:89
- `liaChessUpdate`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:914
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2083

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
- **Net Handlers Outside netcalls:** 11
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/chess/cl_top.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1998` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1999` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2017` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2083` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2120` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2137` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2144` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2169` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2226` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2323` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess`

### Module Documentation Report

- **Undocumented Meta Functions:**
  - `playerMeta:chessDraw()`
  - `playerMeta:chessWin()`
  - `playerMeta:doChessElo()`
  - `playerMeta:doDraughtsElo()`
  - `playerMeta:draughtsDraw()`
  - `playerMeta:draughtsWin()`
  - `playerMeta:expectedChessWin()`
  - `playerMeta:expectedDraughtsWin()`
  - `playerMeta:getChessElo()`
  - `playerMeta:getChessEloWithRecognition()`
  - `playerMeta:getChessKFactor()`
  - `playerMeta:getDraughtsElo()`
  - `playerMeta:getDraughtsEloWithRecognition()`
  - `playerMeta:getDraughtsKFactor()`
  - `playerMeta:setChessElo()`
  - `playerMeta:setDraughtsElo()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess | 0 | 0 | 16 |
