## Executive Summary

### Function Documentation
- **Total Functions:** 34
- **Documented:** 0 (0.0%)
- **Missing Functions:** 34 unique (34 total occurrences)
  - **Library Functions:** 34
  - **Hook Functions:** 0
  - **Meta Functions:** 0

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
- **Defined Net Messages:** 3
- **Used Net Messages:** 3
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 19

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 34 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 34 functions

#### lia.scpcomputer
Count: 34 functions

- `lia.scpcomputer.canAccessApp()`
- `lia.scpcomputer.canAccessSection()`
- `lia.scpcomputer.canManageLogin()`
- `lia.scpcomputer.canManagePermissions()`
- `lia.scpcomputer.canManagePersonnel()`
- `lia.scpcomputer.canManageSubjects()`
- `lia.scpcomputer.canSubmitReport()`
- `lia.scpcomputer.canUploadDocuments()`
- `lia.scpcomputer.getActions()`
- `lia.scpcomputer.getAppDefinition()`
- `lia.scpcomputer.getAppDefinitions()`
- `lia.scpcomputer.getCharacterClearance()`
- `lia.scpcomputer.getCharacterDepartment()`
- `lia.scpcomputer.getClassData()`
- `lia.scpcomputer.getComboData()`
- `lia.scpcomputer.getDepartments()`
- `lia.scpcomputer.getEffectiveRule()`
- `lia.scpcomputer.getFactionData()`
- `lia.scpcomputer.getProfile()`
- `lia.scpcomputer.getReportTypes()`
- `lia.scpcomputer.getSectionOrder()`
- `lia.scpcomputer.getSections()`
- `lia.scpcomputer.hasBaseAccess()`
- `lia.scpcomputer.makeInfoCard()`
- `lia.scpcomputer.makeLabel()`
- `lia.scpcomputer.makeSectionHeader()`
- `lia.scpcomputer.makeWorkflowHeader()`
- `lia.scpcomputer.notifyPayloadError()`
- `lia.scpcomputer.paintFlatButton()`
- `lia.scpcomputer.paintFlatField()`
- `lia.scpcomputer.registerCallback()`
- `lia.scpcomputer.requestData()`
- `lia.scpcomputer.sendAction()`
- `lia.scpcomputer.unregisterCallback()`

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
- `ComputerAppPanelRegistered`
  - module `scp_computer` [standard] in `libraries/shared.lua`
- `ComputerUIReady`
  - module `scp_computer` [standard] in `libraries/shared.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `ComputerAppPanelRegistered()`
- `ComputerUIReady()`

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
| `MODULE.desc` | Unlocalized string | `Adds an SCP-specific computer environment on top of the shared computer framework, including document control, report submission, personnel access management, SCP browsing, and server-enforced permissions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 4 |
| `MODULE.name` | Unlocalized string | `SCP Computer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 2 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 9 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 14 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 19 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 24 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 29 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 34 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 39 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 44 |
| `Privilege.Name` | Unlocalized string | `SCP Computer Override` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 7 |
| `Privilege.Name` | Unlocalized string | `Manage SCP Personnel` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Manage SCP Computer Permissions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 17 |
| `Privilege.Name` | Unlocalized string | `Manage SCP Computer Access` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 22 |
| `Privilege.Name` | Unlocalized string | `Upload SCP Computer Documents` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 27 |
| `Privilege.Name` | Unlocalized string | `Bypass SCP Internal Affairs Restrictions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 32 |
| `Privilege.Name` | Unlocalized string | `Bypass SCP Administration Restrictions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 37 |
| `Privilege.Name` | Unlocalized string | `View Restricted SCP Entries` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 42 |
| `data.desc` | Unlocalized string | `Adds an SCP-specific computer environment on top of the shared computer framework, including document control, report submission, personnel access management, SCP browsing, and server-enforced permissions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\module.lua | 4 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 3
- **Used Net Messages:** 3
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
| `scp_computer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/scp_computer/libraries/client.lua:131` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\netcalls` | Module net handler is outside the netcalls folder |
| `scp_computer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/scp_computer/libraries/server.lua:1143` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\netcalls` | Module net handler is outside the netcalls folder |
| `scp_computer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/scp_computer/libraries/server.lua:1184` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ComputerAppPanelRegistered()`
  - `ComputerUIReady()`

- **Undocumented lia.* Functions:**
  - `lia.scpcomputer.canAccessApp()`
  - `lia.scpcomputer.canAccessSection()`
  - `lia.scpcomputer.canManageLogin()`
  - `lia.scpcomputer.canManagePermissions()`
  - `lia.scpcomputer.canManagePersonnel()`
  - `lia.scpcomputer.canManageSubjects()`
  - `lia.scpcomputer.canSubmitReport()`
  - `lia.scpcomputer.canUploadDocuments()`
  - `lia.scpcomputer.getActions()`
  - `lia.scpcomputer.getAppDefinition()`
  - `lia.scpcomputer.getAppDefinitions()`
  - `lia.scpcomputer.getCharacterClearance()`
  - `lia.scpcomputer.getCharacterDepartment()`
  - `lia.scpcomputer.getClassData()`
  - `lia.scpcomputer.getComboData()`
  - `lia.scpcomputer.getDepartments()`
  - `lia.scpcomputer.getEffectiveRule()`
  - `lia.scpcomputer.getFactionData()`
  - `lia.scpcomputer.getProfile()`
  - `lia.scpcomputer.getReportTypes()`
  - `lia.scpcomputer.getSectionOrder()`
  - `lia.scpcomputer.getSections()`
  - `lia.scpcomputer.hasBaseAccess()`
  - `lia.scpcomputer.makeInfoCard()`
  - `lia.scpcomputer.makeLabel()`
  - `lia.scpcomputer.makeSectionHeader()`
  - `lia.scpcomputer.makeWorkflowHeader()`
  - `lia.scpcomputer.notifyPayloadError()`
  - `lia.scpcomputer.paintFlatButton()`
  - `lia.scpcomputer.paintFlatField()`
  - `lia.scpcomputer.registerCallback()`
  - `lia.scpcomputer.requestData()`
  - `lia.scpcomputer.sendAction()`
  - `lia.scpcomputer.unregisterCallback()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer | 2 | 34 | 0 |
