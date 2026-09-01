## Executive Summary

### Function Documentation
- **Total Functions:** 18
- **Documented:** 0 (0.0%)
- **Missing Functions:** 18 unique (18 total occurrences)
  - **Library Functions:** 18
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
- **Undefined Inferred Localization Keys:** 11

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 18 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 18 functions

#### lia.medical
Count: 18 functions

- `lia.medical.AddWound()`
- `lia.medical.ApplyWounds()`
- `lia.medical.ClearWounds()`
- `lia.medical.GetHealResultText()`
- `lia.medical.GetTreatmentTarget()`
- `lia.medical.GetTreatmentVerb()`
- `lia.medical.GetWounds()`
- `lia.medical.GetWoundsHealed()`
- `lia.medical.HasWounds()`
- `lia.medical.HealAllWounds()`
- `lia.medical.HealPerson()`
- `lia.medical.HealPersonFully()`
- `lia.medical.HealWound()`
- `lia.medical.HealYourself()`
- `lia.medical.HealYourselfFully()`
- `lia.medical.RestoreMaxHealth()`
- `lia.medical.SetWounds()`
- `lia.medical.TreatWounds()`

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
| `ITEM.desc` | Unlocalized string | `A basic treatment kit that removes 1 mortal wound.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\medical_kit.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A full treatment kit that removes all mortal wounds.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\surgery_kit.lua | 2 |
| `ITEM.name` | Unlocalized string | `Medical Kit` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\medical_kit.lua | 1 |
| `ITEM.name` | Unlocalized string | `Surgery Kit` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\surgery_kit.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Adds a simple persistent wound system. If you are killed by NPCs, your character can gain mortal wounds that stay until treated, lowering your effective health. It also includes medical items that let players treat wounds and recover lost health.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\module.lua | 4 |
| `MODULE.name` | Unlocalized string | `Medical NPC Injuries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\module.lua | 2 |
| `data.category` | Missing key | `Medical` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\medical_kit.lua | 3 |
| `data.category` | Missing key | `Medical` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\surgery_kit.lua | 3 |
| `data.desc` | Unlocalized string | `A basic treatment kit that removes 1 mortal wound.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\medical_kit.lua | 2 |
| `data.desc` | Unlocalized string | `A full treatment kit that removes all mortal wounds.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\items\surgery_kit.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a simple persistent wound system. If you are killed by NPCs, your character can gain mortal wounds that stay until treated, lowering your effective health. It also includes medical items that let players treat wounds and recover lost health.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries\module.lua | 4 |

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.medical.AddWound()`
  - `lia.medical.ApplyWounds()`
  - `lia.medical.ClearWounds()`
  - `lia.medical.GetHealResultText()`
  - `lia.medical.GetTreatmentTarget()`
  - `lia.medical.GetTreatmentVerb()`
  - `lia.medical.GetWounds()`
  - `lia.medical.GetWoundsHealed()`
  - `lia.medical.HasWounds()`
  - `lia.medical.HealAllWounds()`
  - `lia.medical.HealPerson()`
  - `lia.medical.HealPersonFully()`
  - `lia.medical.HealWound()`
  - `lia.medical.HealYourself()`
  - `lia.medical.HealYourselfFully()`
  - `lia.medical.RestoreMaxHealth()`
  - `lia.medical.SetWounds()`
  - `lia.medical.TreatWounds()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries | 0 | 18 | 0 |
