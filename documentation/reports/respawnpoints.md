## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
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
- **Used Net Messages:** 10
- **Defined But Unused:** 0
- **Used But Undefined:** 3

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 6

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

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
| `MODULE.desc` | Unlocalized string | `A comprehensive spawn respawn management system that allows administrators to place faction-specific respawn terminals. Players can respawn at designated spawn points based on their faction affiliation, with support for multiple spawn points per faction, temporary or permanent spawns, per-player cooldowns, and map-specific configurations. The system includes client-server synchronization, administrative placement tools, and automatic respawn location selection.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\module.lua | 5 |
| `MODULE.name` | Missing key | `Respawnpoints` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\module.lua | 2 |
| `data.category` | Missing key | `respawnpoints` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\module.lua | 27 |
| `data.desc` | Unlocalized string | `A comprehensive spawn respawn management system that allows administrators to place faction-specific respawn terminals. Players can respawn at designated spawn points based on their faction affiliation, with support for multiple spawn points per faction, temporary or permanent spawns, per-player cooldowns, and map-specific configurations. The system includes client-server synchronization, administrative placement tools, and automatic respawn location selection.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\module.lua | 5 |
| `data.desc` | Unlocalized string | `Sets the rotation of the respawn points map preview PNG.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\module.lua | 26 |
| `lia.config.add:name` | Unlocalized string | `Respawn Points Map Rotation` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\module.lua | 25 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 7
- **Used Net Messages:** 10
- **Defined But Unused:** 0
- **Used But Undefined:** 3

### Used But Undefined

- `liaFeaturePositionsRequest`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/shared.lua:233
- `liaPlayerRespawn`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:661
- `liaSetFeaturePosition`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/shared.lua:143

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

- `liaFOBRequestRespawnList`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:293

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
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:920` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:966` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:971` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:208` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:293` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:299` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:327` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints | 0 | 0 | 0 |
