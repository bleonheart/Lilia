## Executive Summary

### Function Documentation
- **Total Functions:** 36
- **Documented:** 0 (0.0%)
- **Missing Functions:** 36 unique (36 total occurrences)
  - **Library Functions:** 36
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 3 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 3

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 4
- **Used Net Messages:** 4
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 18

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 36 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 36 functions

#### lia.keycards
Count: 36 functions

- `lia.keycards.BeginPlacementEdit()`
- `lia.keycards.BuildPlacementData()`
- `lia.keycards.BuildPlacementTransform()`
- `lia.keycards.CheckAccess()`
- `lia.keycards.CheckBiometricAccess()`
- `lia.keycards.CheckKeycardAccess()`
- `lia.keycards.ClampClearance()`
- `lia.keycards.ClearPlacementTarget()`
- `lia.keycards.FormatBiometricSubjectID()`
- `lia.keycards.GetBiometricSubjects()`
- `lia.keycards.GetCardHolderLines()`
- `lia.keycards.GetDefaultFactionKey()`
- `lia.keycards.GetDefaultScannerVariant()`
- `lia.keycards.GetFactionConfig()`
- `lia.keycards.GetHeldKeycard()`
- `lia.keycards.GetItemCardRecord()`
- `lia.keycards.GetKeycardDefinitions()`
- `lia.keycards.GetPlacableScannerClasses()`
- `lia.keycards.GetPlacementTrace()`
- `lia.keycards.GetPlayerKeycards()`
- `lia.keycards.GetScannerBiometricAccess()`
- `lia.keycards.GetScannerVariantConfig()`
- `lia.keycards.GetScannerVariantDefinitions()`
- `lia.keycards.IsPersistentScannerEntity()`
- `lia.keycards.IsPlacableScannerClass()`
- `lia.keycards.IsSupportedDoor()`
- `lia.keycards.NormalizeFactionID()`
- `lia.keycards.NormalizeOptionalFactionID()`
- `lia.keycards.NormalizeRequiredKeycardType()`
- `lia.keycards.NormalizeScannerVariant()`
- `lia.keycards.OpenAdminPanel()`
- `lia.keycards.RegisterKeycardWeapons()`
- `lia.keycards.ResolveBiometricEntry()`
- `lia.keycards.ResolveFactionKeyAlias()`
- `lia.keycards.SafeKeycardClassSuffix()`
- `lia.keycards.WeaponToCardRecord()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 3 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 3
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 3 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `Vkeycards_PostRenderScreen`
  - module `keycards` [standard] in `entities/entities/scp_access_scanner/cl_init.lua`
- `VKeycardsOverrideRender`
  - module `keycards` [standard] in `entities/entities/scp_access_scanner/cl_init.lua`
- `VKeycardsPreventRender`
  - module `keycards` [standard] in `entities/entities/scp_access_scanner/cl_init.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `Vkeycards_PostRenderScreen()`
- `VKeycardsOverrideRender()`
- `VKeycardsPreventRender()`

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
| `MODULE.desc` | Unlocalized string | `Scanner and keycard access control built as a native Lilia module.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 4 |
| `MODULE.name` | Missing key | `Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 2 |
| `Privilege.Category` | Unlocalized string | `Lilia - Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\entities\entities\scp_access_scanner\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Lilia - Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\entities\entities\scp_biometric_scanner\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Lilia - Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\entities\entities\scp_keycard_reader\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Lilia - Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\entities\weapons\scp_keycard_base.lua | 3 |
| `Privilege.Category` | Unlocalized string | `Lilia - Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\entities\weapons\scp_scanner_config.lua | 3 |
| `Privilege.Category` | Unlocalized string | `Lilia - Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\libraries\sh_keycards.lua | 443 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 10 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 15 |
| `Privilege.Name` | Unlocalized string | `Manage keycard scanners` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Clear keycard scanner persistence` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 13 |
| `data.category` | Missing key | `Keycards` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\libraries\sv_keycards.lua | 692 |
| `data.desc` | Unlocalized string | `Give yourself the keycard scanner configuration tool.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\libraries\sv_keycards.lua | 574 |
| `data.desc` | Unlocalized string | `Clear all saved keycard scanners for the current map.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\libraries\sv_keycards.lua | 585 |
| `data.desc` | Unlocalized string | `Delete all live and saved keycard scanner data for the current map.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\libraries\sv_keycards.lua | 601 |
| `data.desc` | Unlocalized string | `Dump keycard button debug information for a func_button entity index.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\libraries\sv_keycards.lua | 619 |
| `data.desc` | Unlocalized string | `Scanner and keycard access control built as a native Lilia module.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\module.lua | 4 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 4
- **Used Net Messages:** 4
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
- **Net Handlers Outside netcalls:** 4
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/derma/cl_scanneradmin.lua:342` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/libraries/cl_keycards.lua:134` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/libraries/sv_keycards.lua:500` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/libraries/sv_keycards.lua:522` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards`

### Module Documentation Report

- **Undocumented Hooks:**
  - `Vkeycards_PostRenderScreen()`
  - `VKeycardsOverrideRender()`
  - `VKeycardsPreventRender()`

- **Undocumented lia.* Functions:**
  - `lia.keycards.BeginPlacementEdit()`
  - `lia.keycards.BuildPlacementData()`
  - `lia.keycards.BuildPlacementTransform()`
  - `lia.keycards.CheckAccess()`
  - `lia.keycards.CheckBiometricAccess()`
  - `lia.keycards.CheckKeycardAccess()`
  - `lia.keycards.ClampClearance()`
  - `lia.keycards.ClearPlacementTarget()`
  - `lia.keycards.FormatBiometricSubjectID()`
  - `lia.keycards.GetBiometricSubjects()`
  - `lia.keycards.GetCardHolderLines()`
  - `lia.keycards.GetDefaultFactionKey()`
  - `lia.keycards.GetDefaultScannerVariant()`
  - `lia.keycards.GetFactionConfig()`
  - `lia.keycards.GetHeldKeycard()`
  - `lia.keycards.GetItemCardRecord()`
  - `lia.keycards.GetKeycardDefinitions()`
  - `lia.keycards.GetPlacableScannerClasses()`
  - `lia.keycards.GetPlacementTrace()`
  - `lia.keycards.GetPlayerKeycards()`
  - `lia.keycards.GetScannerBiometricAccess()`
  - `lia.keycards.GetScannerVariantConfig()`
  - `lia.keycards.GetScannerVariantDefinitions()`
  - `lia.keycards.IsPersistentScannerEntity()`
  - `lia.keycards.IsPlacableScannerClass()`
  - `lia.keycards.IsSupportedDoor()`
  - `lia.keycards.NormalizeFactionID()`
  - `lia.keycards.NormalizeOptionalFactionID()`
  - `lia.keycards.NormalizeRequiredKeycardType()`
  - `lia.keycards.NormalizeScannerVariant()`
  - `lia.keycards.OpenAdminPanel()`
  - `lia.keycards.RegisterKeycardWeapons()`
  - `lia.keycards.ResolveBiometricEntry()`
  - `lia.keycards.ResolveFactionKeyAlias()`
  - `lia.keycards.SafeKeycardClassSuffix()`
  - `lia.keycards.WeaponToCardRecord()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards | 3 | 36 | 0 |
