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
- **Defined Net Messages:** 2
- **Used Net Messages:** 2
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 31

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
| `ITEM.desc` | Unlocalized string | `A portable device used to unlock and open doors with clearance restrictions through a mini-game.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\items\hackingdevice.lua | 4 |
| `ITEM.name` | Unlocalized string | `Hacking Device` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\items\hackingdevice.lua | 2 |
| `MODULE.desc` | Unlocalized string | `Implements a comprehensive security clearance level system that controls access to restricted areas through door permissions. Features include character-based clearance levels, administrative management tools, flag-based access control, and integration with the existing door system to enforce security restrictions based on player authorization levels.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\module.lua | 4 |
| `MODULE.name` | Missing key | `Clearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\module.lua | 2 |
| `Privilege.Category` | Missing key | `clearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 15 |
| `Privilege.Category` | Missing key | `clearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 39 |
| `Privilege.Category` | Missing key | `clearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 38 |
| `Privilege.Category` | Missing key | `clearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 94 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\module.lua | 10 |
| `Privilege.Name` | Unlocalized string | `Set Door Clearance Level` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 14 |
| `Privilege.Name` | Unlocalized string | `Set Character Clearance Level` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 38 |
| `Privilege.Name` | Unlocalized string | `Set Door Clearance Level` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 37 |
| `Privilege.Name` | Unlocalized string | `Set Character Clearance Level` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 93 |
| `Privilege.Name` | Unlocalized string | `Can Manage Character Clearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\module.lua | 8 |
| `data.category` | Missing key | `Tools` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\items\hackingdevice.lua | 5 |
| `data.desc` | Unlocalized string | `Set or get the clearance level of a door you` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 2 |
| `data.desc` | Unlocalized string | `Set the clearance level of a target character` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 23 |
| `data.desc` | Unlocalized string | `Set or get the clearance level of a door you` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 25 |
| `data.desc` | Unlocalized string | `Set the clearance level of a target character` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 78 |
| `data.desc` | Unlocalized string | `Public access. No clearance restrictions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 4 |
| `data.desc` | Unlocalized string | `Enlisted access for standard operational areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 20 |
| `data.desc` | Unlocalized string | `Junior NCOs access for standard operational areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 36 |
| `data.desc` | Unlocalized string | `Senior NCOs access for senior operational areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 52 |
| `data.desc` | Unlocalized string | `Junior Officers access for command operational areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 68 |
| `data.desc` | Unlocalized string | `Junior Officers access for senior command operational areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 84 |
| `data.desc` | Unlocalized string | `High Command access for the most restricted operational areas.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\definitions.lua | 100 |
| `data.desc` | Unlocalized string | `A portable device used to unlock and open doors with clearance restrictions through a mini-game.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\items\hackingdevice.lua | 4 |
| `data.desc` | Unlocalized string | `Implements a comprehensive security clearance level system that controls access to restricted areas through door permissions. Features include character-based clearance levels, administrative management tools, flag-based access control, and integration with the existing door system to enforce security restrictions based on player authorization levels.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\module.lua | 4 |
| `data.privilege` | Missing key | `canManageCharacterClearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\client.lua | 3 |
| `data.privilege` | Missing key | `canManageCharacterClearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\commands\server.lua | 26 |
| `lia.flag.add:desc` | Missing key | `flagManageClearance` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\module.lua | 21 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 2
- **Used Net Messages:** 2
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
- **Net Handlers Outside netcalls:** 2
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `clearance` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/clearance/libraries/client.lua:397` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\netcalls` | Module net handler is outside the netcalls folder |
| `clearance` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/clearance/libraries/server.lua:318` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\netcalls` | Module net handler is outside the netcalls folder |

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
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance | 0 | 0 | 0 |
