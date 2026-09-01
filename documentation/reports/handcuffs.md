## Executive Summary

### Function Documentation
- **Total Functions:** 15
- **Documented:** 0 (0.0%)
- **Missing Functions:** 15 unique (15 total occurrences)
  - **Library Functions:** 2
  - **Hook Functions:** 0
  - **Meta Functions:** 13

### Hooks Documentation
- **Missing Hooks:** 2 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 2

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
- **Undefined Inferred Localization Keys:** 21

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 15 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 2 functions

#### lia.tying
Count: 2 functions

- `lia.tying.searchPlayer()`
- `lia.tying.stopSearching()`

### Missing Meta Functions
Total: 13 functions

#### playerMeta
Count: 13 functions

- `playerMeta:GetDragee()`
- `playerMeta:GetDragger()`
- `playerMeta:GetTyingData()`
- `playerMeta:HandcuffPlayer()`
- `playerMeta:IsBeingSearched()`
- `playerMeta:IsBlinded()`
- `playerMeta:IsDragged()`
- `playerMeta:IsDraggingSomeone()`
- `playerMeta:IsGagged()`
- `playerMeta:IsHandcuffed()`
- `playerMeta:RemoveHandcuffs()`
- `playerMeta:SetDrag()`
- `playerMeta:SetTyingData()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 2 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 2
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 2 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `PlayerHandcuffed`
  - module `handcuffs` [standard] in `meta/server.lua`
- `PlayerReleased`
  - module `handcuffs` [standard] in `meta/server.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `PlayerHandcuffed()`
- `PlayerReleased()`

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
| `MODULE.desc` | Unlocalized string | `Comprehensive player restraint system featuring handcuff items and weapons, rope-based tying mechanics, complete weapon and movement restrictions for restrained players, drag functionality with submodule support, blindfold and gag features, lockpicking mechanics, realistic restraint sounds, and robust hostage scenario tools for immersive roleplay interactions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\module.lua | 5 |
| `MODULE.name` | Missing key | `Handcuffs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\module.lua | 3 |
| `Privilege.Category` | Missing key | `Cuffs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\entities\entities\cuffs\shared.lua | 7 |
| `Privilege.Category` | Missing key | `Cuffs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\entities\weapons\handcuffed\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Cuffs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\entities\weapons\handcuffs\shared.lua | 4 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 6 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 59 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 71 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 84 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 106 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 116 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 130 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 144 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 158 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 172 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 375 |
| `data.category` | Missing key | `Tying` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\pim.lua | 426 |
| `data.desc` | Unlocalized string | `Comprehensive player restraint system featuring handcuff items and weapons, rope-based tying mechanics, complete weapon and movement restrictions for restrained players, drag functionality with submodule support, blindfold and gag features, lockpicking mechanics, realistic restraint sounds, and robust hostage scenario tools for immersive roleplay interactions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\module.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\entities\entities\cuffs\shared.lua | 6 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\entities\weapons\handcuffed\shared.lua | 2 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\entities\weapons\handcuffs\shared.lua | 2 |

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
- **Net Handlers Outside netcalls:** 3
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `handcuffs` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/handcuffs/libraries/client.lua:61` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\netcalls` | Module net handler is outside the netcalls folder |
| `handcuffs` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/handcuffs/libraries/client.lua:88` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\netcalls` | Module net handler is outside the netcalls folder |
| `handcuffs` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/handcuffs/libraries/server.lua:383` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs`

### Module Documentation Report

- **Undocumented Hooks:**
  - `PlayerHandcuffed()`
  - `PlayerReleased()`

- **Undocumented lia.* Functions:**
  - `lia.tying.searchPlayer()`
  - `lia.tying.stopSearching()`

- **Undocumented Meta Functions:**
  - `playerMeta:GetDragee()`
  - `playerMeta:GetDragger()`
  - `playerMeta:GetTyingData()`
  - `playerMeta:HandcuffPlayer()`
  - `playerMeta:IsBeingSearched()`
  - `playerMeta:IsBlinded()`
  - `playerMeta:IsDragged()`
  - `playerMeta:IsDraggingSomeone()`
  - `playerMeta:IsGagged()`
  - `playerMeta:IsHandcuffed()`
  - `playerMeta:RemoveHandcuffs()`
  - `playerMeta:SetDrag()`
  - `playerMeta:SetTyingData()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs | 2 | 2 | 13 |
