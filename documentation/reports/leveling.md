## Executive Summary

### Function Documentation
- **Total Functions:** 21
- **Documented:** 0 (0.0%)
- **Missing Functions:** 21 unique (21 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 21

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
- **Defined Net Messages:** 3
- **Used Net Messages:** 5
- **Defined But Unused:** 0
- **Used But Undefined:** 2

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 27

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 21 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Meta Functions
Total: 21 functions

#### characterMeta
Count: 21 functions

- `characterMeta:acquireSkill()`
- `characterMeta:canAcquireSkill()`
- `characterMeta:canPrestige()`
- `characterMeta:getLevel()`
- `characterMeta:getLevelXP()`
- `characterMeta:getLevelingProgress()`
- `characterMeta:getMaxXPForLevel()`
- `characterMeta:getPrestige()`
- `characterMeta:getSkillPoints()`
- `characterMeta:getXP()`
- `characterMeta:giveSkillPoints()`
- `characterMeta:giveXP()`
- `characterMeta:hasSkill()`
- `characterMeta:isLevel()`
- `characterMeta:isLevelExact()`
- `characterMeta:pastLvlXP()`
- `characterMeta:setPrestige()`
- `characterMeta:setSkillAcquired()`
- `characterMeta:setSkillPoints()`
- `characterMeta:setXP()`
- `characterMeta:spendSkillPoints()`

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
| `MODULE.desc` | Unlocalized string | `A comprehensive character progression system featuring experience points, level advancement, and a skill tree system. Players earn XP through various activities, level up to gain skill points, and invest in three distinct skill paths: Endurance (increases maximum health by 25), Combat Training (boosts weapon damage by 15%), and Engineering (enhances tool effectiveness by 15% and repair speed by 30%). The system includes skill dependencies requiring certain levels, full F1 menu integration for skill management, network synchronization for multiplayer functionality, and administrative tools for XP/skill adjustments. Engineering skill requires Endurance tier 1 as a prerequisite, creating meaningful progression choices.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\module.lua | 4 |
| `MODULE.name` | Missing key | `Leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\module.lua | 2 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 6 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 17 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 28 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 39 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 6 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 25 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 45 |
| `Privilege.Category` | Missing key | `leveling` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 64 |
| `Privilege.Name` | Unlocalized string | `Set XP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 5 |
| `Privilege.Name` | Unlocalized string | `Add XP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 16 |
| `Privilege.Name` | Unlocalized string | `Set Skill Points` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 27 |
| `Privilege.Name` | Unlocalized string | `Add Skill Points` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 38 |
| `Privilege.Name` | Unlocalized string | `Set XP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 5 |
| `Privilege.Name` | Unlocalized string | `Add XP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 24 |
| `Privilege.Name` | Unlocalized string | `Set Skill Points` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 44 |
| `Privilege.Name` | Unlocalized string | `Add Skill Points` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 63 |
| `data.desc` | Unlocalized string | `Set the total XP for a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 3 |
| `data.desc` | Unlocalized string | `Add XP to a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 14 |
| `data.desc` | Unlocalized string | `Set the skill points for a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 25 |
| `data.desc` | Unlocalized string | `Add skill points to a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\client.lua | 36 |
| `data.desc` | Unlocalized string | `Set the total XP for a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 3 |
| `data.desc` | Unlocalized string | `Add XP to a character with optional reason.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 22 |
| `data.desc` | Unlocalized string | `Set the skill points for a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 42 |
| `data.desc` | Unlocalized string | `Add skill points to a character.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\commands\server.lua | 61 |
| `data.desc` | Unlocalized string | `A comprehensive character progression system featuring experience points, level advancement, and a skill tree system. Players earn XP through various activities, level up to gain skill points, and invest in three distinct skill paths: Endurance (increases maximum health by 25), Combat Training (boosts weapon damage by 15%), and Engineering (enhances tool effectiveness by 15% and repair speed by 30%). The system includes skill dependencies requiring certain levels, full F1 menu integration for skill management, network synchronization for multiplayer functionality, and administrative tools for XP/skill adjustments. Engineering skill requires Endurance tier 1 as a prerequisite, creating meaningful progression choices.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\module.lua | 4 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 3
- **Used Net Messages:** 5
- **Defined But Unused:** 0
- **Used But Undefined:** 2

### Used But Undefined

- `liaLevelingPrestige`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:506; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:189
- `liaLevelingSpendAttrib`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:424; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:152

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 2

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

- `liaLevelingPrestige` in module `leveling`
  - Reason: Used only by module "leveling" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:506; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:189
- `liaLevelingSpendAttrib` in module `leveling`
  - Reason: Used only by module "leveling" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:424; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:152

### Direction / Flow Issues

Total suspicious patterns: **1**

- `liaAcquireSkill`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:140

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
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:11` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:35` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:140` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:152` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:189` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling`

### Module Documentation Report

- **Undocumented Meta Functions:**
  - `characterMeta:acquireSkill()`
  - `characterMeta:canAcquireSkill()`
  - `characterMeta:canPrestige()`
  - `characterMeta:getLevel()`
  - `characterMeta:getLevelingProgress()`
  - `characterMeta:getLevelXP()`
  - `characterMeta:getMaxXPForLevel()`
  - `characterMeta:getPrestige()`
  - `characterMeta:getSkillPoints()`
  - `characterMeta:getXP()`
  - `characterMeta:giveSkillPoints()`
  - `characterMeta:giveXP()`
  - `characterMeta:hasSkill()`
  - `characterMeta:isLevel()`
  - `characterMeta:isLevelExact()`
  - `characterMeta:pastLvlXP()`
  - `characterMeta:setPrestige()`
  - `characterMeta:setSkillAcquired()`
  - `characterMeta:setSkillPoints()`
  - `characterMeta:setXP()`
  - `characterMeta:spendSkillPoints()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling | 0 | 0 | 21 |
