## Executive Summary

### Function Documentation
- **Total Functions:** 11
- **Documented:** 0 (0.0%)
- **Missing Functions:** 11 unique (11 total occurrences)
  - **Library Functions:** 11
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
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 26

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 11 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 11 functions

#### lia.ranking
Count: 11 functions

- `lia.ranking.canDemote()`
- `lia.ranking.canHire()`
- `lia.ranking.canKick()`
- `lia.ranking.canPromote()`
- `lia.ranking.demotePlayer()`
- `lia.ranking.getRankTable()`
- `lia.ranking.hirePlayer()`
- `lia.ranking.kickPlayer()`
- `lia.ranking.promotePlayer()`
- `lia.ranking.registerRank()`
- `lia.ranking.setRank()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive hierarchical ranking system that manages player positions within classes. Provides promotion, demotion, hiring, and kicking functionality with tier-based permissions. Automatically assigns rank-specific weapons, clearance levels, and models. Includes administrative commands and privilege-based access control for class management.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 5 |
| `MODULE.name` | Missing key | `Ranking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 3 |
| `Privilege.Category` | Missing key | `ranking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 5 |
| `Privilege.Category` | Missing key | `ranking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 23 |
| `Privilege.Category` | Missing key | `ranking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 5 |
| `Privilege.Category` | Missing key | `ranking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 43 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 10 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 15 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 20 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 25 |
| `Privilege.Name` | Missing key | `Promote` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 4 |
| `Privilege.Name` | Missing key | `Demote` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 22 |
| `Privilege.Name` | Missing key | `Promote` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 4 |
| `Privilege.Name` | Missing key | `Demote` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 42 |
| `Privilege.Name` | Unlocalized string | `Can Promote Players` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Can Demote Players` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 13 |
| `Privilege.Name` | Unlocalized string | `Can Kick Players From Class` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 18 |
| `Privilege.Name` | Unlocalized string | `Can Hire Players To Class` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 23 |
| `data.category` | Missing key | `ranking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\libraries\client.lua | 116 |
| `data.desc` | Unlocalized string | `Promote a player to the next rank in their class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 2 |
| `data.desc` | Unlocalized string | `Demote a player to the previous rank in their class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 20 |
| `data.desc` | Unlocalized string | `Set a player` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\client.lua | 38 |
| `data.desc` | Unlocalized string | `Promote a player to the next rank in their class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 2 |
| `data.desc` | Unlocalized string | `Demote a player to the previous rank in their class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 40 |
| `data.desc` | Unlocalized string | `Set a player` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\commands\server.lua | 78 |
| `data.desc` | Unlocalized string | `Comprehensive hierarchical ranking system that manages player positions within classes. Provides promotion, demotion, hiring, and kicking functionality with tier-based permissions. Automatically assigns rank-specific weapons, clearance levels, and models. Includes administrative commands and privilege-based access control for class management.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking\module.lua | 5 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

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
- **Net Handlers Outside netcalls:** 0
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

None

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.ranking.canDemote()`
  - `lia.ranking.canHire()`
  - `lia.ranking.canKick()`
  - `lia.ranking.canPromote()`
  - `lia.ranking.demotePlayer()`
  - `lia.ranking.getRankTable()`
  - `lia.ranking.hirePlayer()`
  - `lia.ranking.kickPlayer()`
  - `lia.ranking.promotePlayer()`
  - `lia.ranking.registerRank()`
  - `lia.ranking.setRank()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking | 0 | 11 | 0 |
