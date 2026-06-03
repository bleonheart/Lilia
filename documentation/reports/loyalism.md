## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 1 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 1

### Localization Analysis
- **Undefined Calls:** 4 unique
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
- **Undefined Inferred Localization Keys:** 8

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 1
- **Unused Hooks:** 0 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `AddTextField()`

## Localization Analysis

- **Unique Keys:** 11
- **Undefined Calls:** 4
- **Argument Mismatch:** 0

### Undefined Calls

- **noPerm** in commands.lua:25
  - Context: client:notifyLocalized("noPerm")
- **targetNotFound** in commands.lua:30
  - Context: client:notifyLocalized("targetNotFound")
- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"
- **generalinfo** in libraries\client.lua:11
  - Context: hook.Run("AddTextField", L("generalinfo"), "partytier", L("partyTier"), function() return self.Tiers[tier] end)

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `MODULE.desc` | Unlocalized string | `Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 6 |
| `MODULE.name` | Missing key | `Loyalism` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 1 |
| `Privilege.Category` | Missing key | `loyalism` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 12 |
| `Privilege.Name` | Missing key | `partytierCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\commands.lua | 16 |
| `Privilege.Name` | Missing key | `managementAssignPartyTiers` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 10 |
| `data.desc` | Missing key | `partytierCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\commands.lua | 14 |
| `data.desc` | Unlocalized string | `Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 6 |
| `lia.flag.add:desc` | Unlocalized string | `Access to /partytier` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 7 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism`

### Module Documentation Report

- **Undocumented Hooks:**
  - `AddTextField()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism | 1 | 0 |
