## Executive Summary

### Function Documentation
- **Total Functions:** 5
- **Documented:** 0 (0.0%)
- **Missing Functions:** 5 unique (5 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 5

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
- **Defined Net Messages:** 17
- **Used Net Messages:** 14
- **Defined But Unused:** 6
- **Used But Undefined:** 3

### Config Analysis
- **Undefined lia.config.get Keys:** 2
- **Undefined Inferred Localization Keys:** 15

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 5 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Meta Functions
Total: 5 functions

#### entMeta
Count: 5 functions

- `entMeta:GetBonemergedChildren()`
- `entMeta:GetBonemergedChildrenBySlot()`
- `entMeta:GetGender()`
- `entMeta:IsFemale()`
- `entMeta:IsMale()`

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
- `entity_killed`
  - module `bonemerge` [standard] in `cl_bonemerge.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `entity_killed()`

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
| `ITEM.desc` | Missing key | `Bonemerge` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_bonemerge.lua | 2 |
| `ITEM.desc` | Missing key | `Tie` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_ties.lua | 2 |
| `ITEM.name` | Missing key | `Bonemerge` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_bonemerge.lua | 1 |
| `ITEM.name` | Missing key | `Tie` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_ties.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive bonemerge-based clothing system that allows players to equip and customize outfits with multiple clothing slots. Features dynamic model merging, slot-based inventory management, gender-specific clothing, VIP items, plastic surgery, and a complete vendor system for purchasing and managing clothing items including hats, shirts, pants, shoes, accessories, and full outfits.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\module.lua | 4 |
| `MODULE.name` | Missing key | `Bonemerge` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\module.lua | 2 |
| `Privilege.Name` | Unlocalized string | `Access to VIP bonemerge items` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\module.lua | 8 |
| `data.category` | Missing key | `Clothing` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_bonemerge.lua | 6 |
| `data.category` | Missing key | `Ties` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_ties.lua | 6 |
| `data.category` | Missing key | `Bonemerge` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\sh_config.lua | 2 |
| `data.desc` | Missing key | `Bonemerge` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_bonemerge.lua | 2 |
| `data.desc` | Missing key | `Tie` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\items\base\sh_ties.lua | 2 |
| `data.desc` | Unlocalized string | `Comprehensive bonemerge-based clothing system that allows players to equip and customize outfits with multiple clothing slots. Features dynamic model merging, slot-based inventory management, gender-specific clothing, VIP items, plastic surgery, and a complete vendor system for purchasing and managing clothing items including hats, shirts, pants, shoes, accessories, and full outfits.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\module.lua | 4 |
| `data.desc` | Unlocalized string | `Price for plastic surgery at bonemerge vendor` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\sh_config.lua | 6 |
| `lia.config.add:name` | Missing key | `bonemergeSurgeryPrice` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\sh_config.lua | 1 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 17
- **Used Net Messages:** 14
- **Defined But Unused:** 6
- **Used But Undefined:** 3

### Used But Undefined

- `liaFeaturePositionsRequest`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sh_config.lua:129
- `liaInvAct`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:1019; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:1034
- `liaSetFeaturePosition`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sh_config.lua:65

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

Total suspicious patterns: **3**

- `Bonemerge.ConvertModel`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:181
  - Receiver sites: None
- `Bonemerge.RequestSync`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sh_clothing.lua:29999
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:469
- `Bonemerge.StartAdjustingItem`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:172

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 4
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 4
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `ClothingVendor` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:612` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `playerEquipSlot` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:738` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `playerPanel` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:887` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `playerEquipSlot` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:1097` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 10
- **UI / Derma Code Outside derma:** 4

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:121` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:122` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:156` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:172` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:173` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:368` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:410` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:416` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:422` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:469` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:612` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:738` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:887` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:1097` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

Total: **2** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `bonemergeSurgeryPrice` | 2 |

### Details

#### `bonemergeSurgeryPrice`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\cl_network.lua** line 83: `local surgeryPrice = lia.config.get("bonemergeSurgeryPrice", 5000)`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\sv_network.lua** line 92: `Response = function() return "Excellent! Plastic surgery costs " .. lia.currency.get(lia.config.get("bonemergeSurgeryPrice", 5000)) .. ". Would you like to proceed?" end,`

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge`

### Module Documentation Report

- **Undocumented Hooks:**
  - `entity_killed()`

- **Undocumented Meta Functions:**
  - `entMeta:GetBonemergedChildren()`
  - `entMeta:GetBonemergedChildrenBySlot()`
  - `entMeta:GetGender()`
  - `entMeta:IsFemale()`
  - `entMeta:IsMale()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge | 1 | 0 | 5 |
