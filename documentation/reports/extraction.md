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
- **Defined Net Messages:** 1
- **Used Net Messages:** 1
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 9

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
| `ITEM.desc` | Unlocalized string | `A grenade that releases a bright flare upon use.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\items\grenade\flare.lua | 2 |
| `ITEM.name` | Unlocalized string | `Flare Grenade` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\items\grenade\flare.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Extraction flare system that allows players to signal extraction points by throwing throwable flares. Includes configurable extraction positions per map, flare grenade items, visual effects, and network messaging for extraction coordination. Provides raid-style extraction mechanics with countdown timers and escape zone functionality.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\module.lua | 4 |
| `MODULE.name` | Missing key | `Extraction` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\module.lua | 2 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\entities\entities\lia_flare.lua | 7 |
| `data.category` | Missing key | `OneUseSWEP` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\items\grenade\flare.lua | 3 |
| `data.desc` | Unlocalized string | `A grenade that releases a bright flare upon use.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\items\grenade\flare.lua | 2 |
| `data.desc` | Unlocalized string | `Extraction flare system that allows players to signal extraction points by throwing throwable flares. Includes configurable extraction positions per map, flare grenade items, visual effects, and network messaging for extraction coordination. Provides raid-style extraction mechanics with countdown timers and escape zone functionality.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\module.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\entities\entities\lia_flare.lua | 6 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 1
- **Used Net Messages:** 1
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

Total suspicious patterns: **1**

- `ReceiveSyringeMessage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/extraction/libraries/client.lua:1

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
- **Net Handlers Outside netcalls:** 1
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `extraction` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/extraction/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\netcalls` | Module net handler is outside the netcalls folder |

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
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction | 0 | 0 | 0 |
