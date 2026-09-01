## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 10 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 10

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
- **Undefined Inferred Localization Keys:** 4

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 10 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 10
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 10 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `SpeciesCreatorBuildPayload`
  - module `species_creator_poc` [standard] in `derma/client.lua`
- `SpeciesCreatorCharacterCreated`
  - module `species_creator_poc` [standard] in `derma/client.lua`
- `SpeciesCreatorGetAttributeGroups`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetCreationFaction`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetInnateLanguages`
  - module `species_creator_poc` [standard] in `module.lua`
  - module `species_creator_poc` [standard] in `derma/client.lua`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetLanguages`
  - module `species_creator_poc` [standard] in `module.lua`
  - module `species_creator_poc` [standard] in `derma/client.lua`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetLanguageTokenBudget`
  - module `species_creator_poc` [standard] in `module.lua`
  - module `species_creator_poc` [standard] in `derma/client.lua`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetStartingKit`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetStartingOutfits`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `SpeciesCreatorGetTraits`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `SpeciesCreatorBuildPayload()`
- `SpeciesCreatorCharacterCreated()`
- `SpeciesCreatorGetAttributeGroups()`
- `SpeciesCreatorGetCreationFaction()`
- `SpeciesCreatorGetInnateLanguages()`
- `SpeciesCreatorGetLanguages()`
- `SpeciesCreatorGetLanguageTokenBudget()`
- `SpeciesCreatorGetStartingKit()`
- `SpeciesCreatorGetStartingOutfits()`
- `SpeciesCreatorGetTraits()`

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
| `MODULE.desc` | Unlocalized string | `A cinematic world-space species, origin, and multi-stage character creation interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc\module.lua | 3 |
| `MODULE.name` | Unlocalized string | `Species Creator POC` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc\module.lua | 1 |
| `data.desc` | Unlocalized string | `Opens the cinematic species character creator.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc\libraries\shared.lua | 279 |
| `data.desc` | Unlocalized string | `A cinematic world-space species, origin, and multi-stage character creation interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc\module.lua | 3 |

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

Total suspicious patterns: **0**

None

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 1
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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc`

### Module Documentation Report

- **Undocumented Hooks:**
  - `SpeciesCreatorBuildPayload()`
  - `SpeciesCreatorCharacterCreated()`
  - `SpeciesCreatorGetAttributeGroups()`
  - `SpeciesCreatorGetCreationFaction()`
  - `SpeciesCreatorGetInnateLanguages()`
  - `SpeciesCreatorGetLanguages()`
  - `SpeciesCreatorGetLanguageTokenBudget()`
  - `SpeciesCreatorGetStartingKit()`
  - `SpeciesCreatorGetStartingOutfits()`
  - `SpeciesCreatorGetTraits()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc | 10 | 0 | 0 |
