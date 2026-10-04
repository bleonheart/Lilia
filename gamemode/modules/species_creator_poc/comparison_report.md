# Sam Module Audit: species_creator_poc

- **Scanned source:** `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc`
- **Nested modules detected:** 0

## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 25 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 25

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
- **Undefined lia.config.get Keys:** 2
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
- **Missing Hooks:** 25 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 25
- **Method Hooks:** 15 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 10 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Method-Style Hooks:
These hooks are defined as `function GM:HookName(...)`, `function MODULE:HookName(...)`, or `function SCHEMA:HookName(...)`.
- `GetAttributeGroups(species, origin)`
- `GetAvailableSpecies(client)`
- `GetCreationFaction(client, species)`
- `GetFactionByIdentifier(identifier)`
- `GetInnateLanguages(species, origin)`
- `GetLanguageTokenBudget(species, origin, selectedTraits)`
- `GetLanguages(species, origin)`
- `GetOrderedSpeciesProfiles()`
- `GetPreviewModels(profile)`
- `GetSpeciesModels(faction, client)`
- `GetSpeciesOrigins(species)`
- `GetSpeciesSexes(species)`
- `GetSpeciesTraits(species, origin)`
- `GetStartingKit(species, origin)`
- `GetStartingOutfits(species, origin)`

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `GetAttributeGroups`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetAvailableSpecies`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetCreationFaction`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetFactionByIdentifier`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetInnateLanguages`
  - module `species_creator_poc` [standard] in `module.lua`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetLanguages`
  - module `species_creator_poc` [standard] in `module.lua`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetLanguageTokenBudget`
  - module `species_creator_poc` [standard] in `module.lua`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetOrderedSpeciesProfiles`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetPreviewModels`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetSpeciesModels`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetSpeciesOrigins`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetSpeciesSexes`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetSpeciesTraits`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetStartingKit`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `GetStartingOutfits`
  - module `species_creator_poc` [standard] in `libraries/shared.lua`
- `PreDrawEffects`
  - module `species_creator_poc` [standard] in `derma/client.lua`
- `PreDrawPlayerHands`
  - module `species_creator_poc` [standard] in `derma/client.lua`
- `PreDrawViewModel`
  - module `species_creator_poc` [standard] in `derma/client.lua`
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
- `VGUIMousePressed`
  - module `species_creator_poc` [standard] in `derma/client.lua`

### Other Hook Registration Locations:
These entries show hooks registered outside libraries and outside external module/submodule scans.
- `GetAttributeGroups`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetAvailableSpecies`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetCreationFaction`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetFactionByIdentifier`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetInnateLanguages`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetLanguages`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetLanguageTokenBudget`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetOrderedSpeciesProfiles`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetPreviewModels`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetSpeciesModels`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetSpeciesOrigins`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetSpeciesSexes`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetSpeciesTraits`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetStartingKit`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `GetStartingOutfits`
  - other [method] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorBuildPayload`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua`
- `SpeciesCreatorCharacterCreated`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua`
- `SpeciesCreatorGetAttributeGroups`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetCreationFaction`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetInnateLanguages`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetLanguages`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetLanguageTokenBudget`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetStartingKit`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetStartingOutfits`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`
- `SpeciesCreatorGetTraits`
  - other [standard] in `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `GetAttributeGroups(species, origin)`
- `GetAvailableSpecies(client)`
- `GetCreationFaction(client, species)`
- `GetFactionByIdentifier(identifier)`
- `GetInnateLanguages(species, origin)`
- `GetLanguages(species, origin)`
- `GetLanguageTokenBudget(species, origin, selectedTraits)`
- `GetOrderedSpeciesProfiles()`
- `GetPreviewModels(profile)`
- `GetSpeciesModels(faction, client)`
- `GetSpeciesOrigins(species)`
- `GetSpeciesSexes(species)`
- `GetSpeciesTraits(species, origin)`
- `GetStartingKit(species, origin)`
- `GetStartingOutfits(species, origin)`
- `SpeciesCreatorBuildPayload(payload, species, origin, data)`
- `SpeciesCreatorCharacterCreated(characterID, creationData, arg3)`
- `SpeciesCreatorGetAttributeGroups(species, origin)`
- `SpeciesCreatorGetCreationFaction(client, species)`
- `SpeciesCreatorGetInnateLanguages(species, origin)`
- `SpeciesCreatorGetLanguages(species, origin)`
- `SpeciesCreatorGetLanguageTokenBudget(species, origin, selectedTraits)`
- `SpeciesCreatorGetStartingKit(species, origin)`
- `SpeciesCreatorGetStartingOutfits(species, origin)`
- `SpeciesCreatorGetTraits(species, origin)`

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
| `MODULE.desc` | Unlocalized string | `A cinematic world-space species, origin, and multi-stage character creation interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua | 3 |
| `MODULE.name` | Unlocalized string | `Species Creator POC` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua | 1 |
| `data.desc` | Unlocalized string | `Opens the cinematic species character creator.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\libraries\shared.lua | 279 |
| `data.desc` | Unlocalized string | `A cinematic world-space species, origin, and multi-stage character creation interface.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\module.lua | 3 |

## Language File Comparison

### Summary
- **Languages Compared:** 6
- **Total Missing Keys:** 95

### French

- **Missing Keys:**
  - **From English:** 19 keys
    - `adminStickHUDControls()`
    - `adminStickHUDLeftClick()`
    - `adminStickHUDMode()`
    - `adminStickHUDReload()`
    - `adminStickHUDRightClick()`
    - `adminStickInstructionSwitchMode()`
    - `administrativeMode()`
    - `changeBodygroupsPrivilege()`
    - `changeBodygroupsPrivilegeDesc()`
    - `debugMode()`
    - `vendorBuyPriceLabel()`
    - `vendorFactionAccessSubtitle()`
    - `vendorGeneralInfoSubtitle()`
    - `vendorItemsSubtitle()`
    - `vendorSellPriceLabel()`
    - `vendorStockCurrentShort()`
    - `vendorStockMaxShort()`
    - `vendorStockToggle()`
    - `worldConfigurationMode()`

### German

- **Missing Keys:**
  - **From English:** 19 keys
    - `adminStickHUDControls()`
    - `adminStickHUDLeftClick()`
    - `adminStickHUDMode()`
    - `adminStickHUDReload()`
    - `adminStickHUDRightClick()`
    - `adminStickInstructionSwitchMode()`
    - `administrativeMode()`
    - `changeBodygroupsPrivilege()`
    - `changeBodygroupsPrivilegeDesc()`
    - `debugMode()`
    - `vendorBuyPriceLabel()`
    - `vendorFactionAccessSubtitle()`
    - `vendorGeneralInfoSubtitle()`
    - `vendorItemsSubtitle()`
    - `vendorSellPriceLabel()`
    - `vendorStockCurrentShort()`
    - `vendorStockMaxShort()`
    - `vendorStockToggle()`
    - `worldConfigurationMode()`

### Portuguese

- **Missing Keys:**
  - **From English:** 19 keys
    - `adminStickHUDControls()`
    - `adminStickHUDLeftClick()`
    - `adminStickHUDMode()`
    - `adminStickHUDReload()`
    - `adminStickHUDRightClick()`
    - `adminStickInstructionSwitchMode()`
    - `administrativeMode()`
    - `changeBodygroupsPrivilege()`
    - `changeBodygroupsPrivilegeDesc()`
    - `debugMode()`
    - `vendorBuyPriceLabel()`
    - `vendorFactionAccessSubtitle()`
    - `vendorGeneralInfoSubtitle()`
    - `vendorItemsSubtitle()`
    - `vendorSellPriceLabel()`
    - `vendorStockCurrentShort()`
    - `vendorStockMaxShort()`
    - `vendorStockToggle()`
    - `worldConfigurationMode()`

### Russian

- **Missing Keys:**
  - **From English:** 19 keys
    - `adminStickHUDControls()`
    - `adminStickHUDLeftClick()`
    - `adminStickHUDMode()`
    - `adminStickHUDReload()`
    - `adminStickHUDRightClick()`
    - `adminStickInstructionSwitchMode()`
    - `administrativeMode()`
    - `changeBodygroupsPrivilege()`
    - `changeBodygroupsPrivilegeDesc()`
    - `debugMode()`
    - `vendorBuyPriceLabel()`
    - `vendorFactionAccessSubtitle()`
    - `vendorGeneralInfoSubtitle()`
    - `vendorItemsSubtitle()`
    - `vendorSellPriceLabel()`
    - `vendorStockCurrentShort()`
    - `vendorStockMaxShort()`
    - `vendorStockToggle()`
    - `worldConfigurationMode()`

### Spanish

- **Missing Keys:**
  - **From English:** 19 keys
    - `adminStickHUDControls()`
    - `adminStickHUDLeftClick()`
    - `adminStickHUDMode()`
    - `adminStickHUDReload()`
    - `adminStickHUDRightClick()`
    - `adminStickInstructionSwitchMode()`
    - `administrativeMode()`
    - `changeBodygroupsPrivilege()`
    - `changeBodygroupsPrivilegeDesc()`
    - `debugMode()`
    - `vendorBuyPriceLabel()`
    - `vendorFactionAccessSubtitle()`
    - `vendorGeneralInfoSubtitle()`
    - `vendorItemsSubtitle()`
    - `vendorSellPriceLabel()`
    - `vendorStockCurrentShort()`
    - `vendorStockMaxShort()`
    - `vendorStockToggle()`
    - `worldConfigurationMode()`

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

## Font Analysis

### Used But Not Registered Fonts

- `LiliaFont.15`
- `LiliaFont.16`
- `LiliaFont.18`
- `LiliaFont.22`
- `LiliaFont.30`

### Registered Fonts

None

## Derma Panel Analysis

### Summary
- **Registered Panels:** 1
- **Referenced Panels:** 55
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

Total: **2** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `MaxCharacters` | 1 |
| `MinDescLen` | 1 |

### Details

#### `MaxCharacters`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua** line 4342: `local maxCharacters = hook.Run("GetMaxPlayerChar", LocalPlayer()) or lia.config.get("MaxCharacters", 5)`

#### `MinDescLen`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc\derma\client.lua** line 3535: `local minimumDescription = lia.config.get("MinDescLen", 16)`

---

## Additional Static Audits

- **Commands:** 0 findings
- **Entities:** 0 findings
- **Timers:** 0 findings
- **Performance:** 0 findings
- **Duplicate language keys:** 0
- **Duplicate table keys:** 0
- **Privilege modules analyzed:** 1

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc`

### Module Documentation Report

- **Undocumented Hooks:**
  - `GetAttributeGroups()`
  - `GetAvailableSpecies()`
  - `GetCreationFaction()`
  - `GetFactionByIdentifier()`
  - `GetInnateLanguages()`
  - `GetLanguages()`
  - `GetLanguageTokenBudget()`
  - `GetOrderedSpeciesProfiles()`
  - `GetPreviewModels()`
  - `GetSpeciesModels()`
  - `GetSpeciesOrigins()`
  - `GetSpeciesSexes()`
  - `GetSpeciesTraits()`
  - `GetStartingKit()`
  - `GetStartingOutfits()`
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

- **Functions Used but Not Defined in Either Library:**
  - `lia.MousePos()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions | Undefined Functions |
|---|---:|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\.modules\species_creator_poc | 25 | 0 | 0 | 1 |
