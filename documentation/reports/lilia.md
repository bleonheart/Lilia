## Executive Summary

### Function Documentation
- **Total Functions:** 633
- **Documented:** 626 (98.9%)
- **Missing Functions:** 7 unique (7 total occurrences)
  - **Library Functions:** 7
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 16 (used but undocumented)
- **Unused Hooks:** 3 (documented but unused)
- **Total Documented Hooks:** 432
- **Total Registered Hooks:** 440

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 215
- **Used Net Messages:** 214
- **Defined But Unused:** 1
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 42
- **Missing Documentation:** 7 unique functions

### Missing Library Functions
Total: 7 functions

#### lia.admin
Count: 5 functions

- `lia.admin.getCommandPrivilegeID(cmd)`
- `lia.admin.getExternalPrivilegeName(id)`
- `lia.admin.isProtectedStaffTarget(cmd, target)`
- `lia.admin.normalizePrivilege(privilege)`
- `lia.admin.notifyProtectedStaffTarget(admin)`

#### lia.class
Count: 2 functions

- `lia.class.getBodygroups(class)`
- `lia.class.getMergedBodygroups(character)`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 16 (used in code but not documented)
- **Documented Hooks:** 432
- **Registered Hooks:** 440
- **Unused Hooks:** 3 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `AddReservedKeybinds(reserved)`
- `CanDrawEntityHoverInfo(e, category)`
- `CanPlayerUseAmmoBox(activator, self)`
- `IsCharacterCreationOverridden()`
- `LiliaNoticeOverride(msg, ntype)`
- `OnAmmoBoxUsed(activator, self, weapon, ammoType, givenAmount)`
- `OnWeaponRuntimeOverrideUpdated(className, dotPath, value)`
- `OnWeaponRuntimeOverridesBulkSynced(overrides)`
- `OpenCharacterMenu()`
- `OpenCharacterMenuOverride()`
- `SAM.LoadedRanks()`
- `ShouldDrawCrosshair(client, wpn)`
- `SuppressHint(hint)`
- `VendorItemBuyPriceUpdated(vendor, itemType, value)`
- `VendorItemSellPriceUpdated(vendor, itemType, value)`
- `VendorPropertyUpdated(vendor, propertyName, propertyValue)`

### Unused Hook Documentation:
These hooks are documented but not registered in code:
- `GetVendorSaleScale()`
- `OnPlayerEnterSequence()`
- `VendorItemPriceUpdated()`

## Localization Analysis

- **Unique Keys:** 3818
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
| `data.category` | Unlocalized string | `.. lia.db.convertDataType(category),` | modules\administration\submodules\logs\libraries\server.lua | 16 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 215
- **Used Net Messages:** 214
- **Defined But Unused:** 1
- **Used But Undefined:** 0

### Used But Undefined

None

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 73
- **Module-Specific Used But Undefined:** 0

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

- `liaActiveTickets` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/tickets/libraries/client.lua:121; net.Start at modules/administration/submodules/tickets/libraries/server.lua:217
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaAdminSetCharProperty` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/netcalls/server.lua:1
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaAllFlags` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/administration/libraries/client.lua:976; lia.net.writeBigTable at modules/administration/libraries/server.lua:351
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaAllPks` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/libraries/client.lua:864; net.Start at modules/administration/libraries/server.lua:234
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaAllPlayers` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/administration/libraries/client.lua:1109; lia.net.writeBigTable at modules/administration/libraries/server.lua:507
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaAllWarnings` in module `warnings`
  - Reason: Used only by module "warnings" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/warnings/libraries/client.lua:20; net.Start at modules/administration/submodules/warnings/libraries/server.lua:77
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaClearAllTicketFrames` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/tickets/libraries/client.lua:267; net.Start at modules/administration/submodules/tickets/libraries/server.lua:100
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaFactionMembers` in module `teams`
  - Reason: Used only by module "teams" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/teams/libraries/client.lua:301; lia.net.writeBigTable at modules/teams/libraries/server.lua:267
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaFeaturePositions` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/entities/weapons/lia_mapconfigurer/cl_init.lua:54; net.Start at modules/administration/libraries/server.lua:150; net.Start at modules/administration/libraries/server.lua:161; net.Start at modules/administration/libraries/server.lua:184; net.Start at modules/administration/libraries/server.lua:215
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaFeaturePositionsRequest` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/entities/weapons/lia_mapconfigurer/cl_init.lua:35; net.Start at modules/administration/entities/weapons/lia_mapconfigurer/cl_init.lua:48; net.Receive at modules/administration/libraries/server.lua:140; net.Start at modules/administration/libraries/shared.lua:184; net.Start at modules/administration/libraries/shared.lua:268
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaFullCharList` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/administration/libraries/client.lua:1233; lia.net.writeBigTable at modules/administration/libraries/server.lua:312
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaKickCharacterToBase` in module `teams`
  - Reason: Used only by module "teams" but defined outside that module
  - Usage sites: net.Start at modules/teams/libraries/client.lua:273; net.Receive at modules/teams/libraries/server.lua:274
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaMainCharacterSet` in module `mainmenu`
  - Reason: Used only by module "mainmenu" but defined outside that module
  - Usage sites: net.Start at modules/mainmenu/libraries/server.lua:66; net.Receive at modules/mainmenu/module.lua:184
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaManagesitroomsAction` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:830; net.Receive at modules/administration/libraries/server.lua:105
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaMapEntities` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: lia.net.writeBigTable at modules/administration/libraries/server.lua:535
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaOnlineStaffData` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/libraries/client.lua:1245; net.Start at modules/administration/libraries/server.lua:563; net.Start at modules/administration/libraries/server.lua:596
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaPksCount` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/server.lua:244
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaPlayerWarnings` in module `warnings`
  - Reason: Used only by module "warnings" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/warnings/libraries/client.lua:104; net.Start at modules/administration/submodules/warnings/libraries/server.lua:99
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestActiveTickets` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/tickets/libraries/client.lua:13; net.Receive at modules/administration/submodules/tickets/libraries/server.lua:200
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestAllFlags` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:555; net.Receive at modules/administration/libraries/server.lua:316
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestAllPks` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:570; net.Receive at modules/administration/libraries/server.lua:230
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestAllWarnings` in module `warnings`
  - Reason: Used only by module "warnings" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/warnings/libraries/client.lua:11; net.Receive at modules/administration/submodules/warnings/libraries/server.lua:73
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestFactionMembers` in module `teams`
  - Reason: Used only by module "teams" but defined outside that module
  - Usage sites: net.Start at modules/teams/libraries/client.lua:60; net.Start at modules/teams/libraries/client.lua:122; net.Receive at modules/teams/libraries/server.lua:229
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestFullCharList` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:536; net.Start at modules/administration/libraries/client.lua:1240; net.Receive at modules/administration/libraries/server.lua:256
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestMapEntities` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/libraries/server.lua:511
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestPksCount` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/libraries/server.lua:240
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestPlayers` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:314; net.Receive at modules/administration/libraries/server.lua:488
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestRemoveWarning` in module `warnings`
  - Reason: Used only by module "warnings" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/warnings/libraries/server.lua:32
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestStaffSummary` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:301; net.Receive at modules/administration/libraries/server.lua:482
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestTicketsCount` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/tickets/libraries/server.lua:222
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRequestWarningsCount` in module `warnings`
  - Reason: Used only by module "warnings" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/warnings/libraries/server.lua:83
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRestoreOverflowItems` in module `gridinv`
  - Reason: Used only by module "gridinv" but defined outside that module
  - Usage sites: net.Start at modules/inventory/types/gridinv/derma/cl_grid_inventroy.lua:14; net.Receive at modules/inventory/types/gridinv/libraries/server.lua:163
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaRgnDone` in module `recognition`
  - Reason: Used only by module "recognition" but defined outside that module
  - Usage sites: net.Receive at modules/recognition/libraries/client.lua:44; net.Start at modules/recognition/libraries/server.lua:18; net.Start at modules/recognition/pim.lua:50; net.Start at modules/recognition/pim.lua:94
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSendLogs` in module `logs`
  - Reason: Used only by module "logs" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/administration/submodules/logs/libraries/client.lua:288; lia.net.writeBigTable at modules/administration/submodules/logs/libraries/server.lua:49
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSendLogsCategories` in module `logs`
  - Reason: Used only by module "logs" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/logs/libraries/client.lua:263; net.Start at modules/administration/submodules/logs/libraries/server.lua:64
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSendLogsCategoriesRequest` in module `logs`
  - Reason: Used only by module "logs" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/logs/libraries/client.lua:16; net.Receive at modules/administration/submodules/logs/libraries/server.lua:52
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSendLogsRequest` in module `logs`
  - Reason: Used only by module "logs" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/logs/libraries/client.lua:62; net.Start at modules/administration/submodules/logs/libraries/client.lua:241; net.Receive at modules/administration/submodules/logs/libraries/server.lua:44
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSetFeaturePosition` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Receive at modules/administration/libraries/server.lua:168; net.Start at modules/administration/libraries/shared.lua:150; net.Start at modules/administration/libraries/shared.lua:233; net.Start at modules/administration/libraries/shared.lua:295
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSpawnMenuGiveItem` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:634; net.Receive at modules/administration/libraries/server.lua:92
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaSpawnMenuSpawnItem` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/libraries/client.lua:627; net.Receive at modules/administration/libraries/server.lua:55
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaStaffSummary` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/administration/libraries/client.lua:984; lia.net.writeBigTable at modules/administration/libraries/server.lua:485
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaStorageExit` in module `storage`
  - Reason: Used only by module "storage" but defined outside that module
  - Usage sites: net.Start at modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:8; net.Receive at modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:1
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaStorageSetPassword` in module `storage`
  - Reason: Used only by module "storage" but defined outside that module
  - Usage sites: net.Start at modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:72; net.Receive at modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:83
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaStorageTransfer` in module `storage`
  - Reason: Used only by module "storage" but defined outside that module
  - Usage sites: net.Receive at modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:34
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaStorageUnlock` in module `storage`
  - Reason: Used only by module "storage" but defined outside that module
  - Usage sites: net.Start at modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua:73; net.Start at modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:15; net.Receive at modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua:1; net.Receive at modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:7
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaTicketsCount` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/tickets/libraries/server.lua:229
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaTicketSystem` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/tickets/libraries/client.lua:229; net.Start at modules/administration/submodules/tickets/libraries/server.lua:10
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaTicketSystemClaim` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/tickets/libraries/client.lua:88; net.Receive at modules/administration/submodules/tickets/libraries/client.lua:238; net.Start at modules/administration/submodules/tickets/libraries/server.lua:150; net.Receive at modules/administration/submodules/tickets/libraries/server.lua:132
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaTicketSystemClose` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/tickets/libraries/client.lua:95; net.Start at modules/administration/submodules/tickets/libraries/client.lua:248; net.Receive at modules/administration/submodules/tickets/libraries/client.lua:259; net.Start at modules/administration/submodules/tickets/libraries/server.lua:113; net.Start at modules/administration/submodules/tickets/libraries/server.lua:185
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaTrunkInitStorage` in module `storage`
  - Reason: Used only by module "storage" but defined outside that module
  - Usage sites: net.Receive at modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua:67
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorAllowClass` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:88; net.Receive at modules/vendor/libraries/client.lua:140; net.Start at modules/vendor/libraries/server.lua:231
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorAllowFaction` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:69; net.Receive at modules/vendor/libraries/client.lua:126; net.Start at modules/vendor/libraries/server.lua:222
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorBuyPrice` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Receive at modules/vendor/libraries/client.lua:72
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorDeletePreset` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/derma/client.lua:2128; net.Receive at modules/vendor/libraries/server.lua:425
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorExit` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/derma/client.lua:428; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:99; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:179; net.Receive at modules/vendor/libraries/client.lua:54; net.Receive at modules/vendor/libraries/server.lua:382
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorFaction` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Receive at modules/vendor/libraries/client.lua:67
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorFactionBuyScale` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/shared.lua:111; net.Receive at modules/vendor/libraries/client.lua:154; net.Start at modules/vendor/libraries/server.lua:195
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorFactionSellScale` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/shared.lua:123; net.Receive at modules/vendor/libraries/client.lua:164; net.Start at modules/vendor/libraries/server.lua:206
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorInitialSync` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Receive at modules/vendor/libraries/client.lua:231; net.Start at modules/vendor/libraries/server.lua:246
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorLoadPreset` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/derma/client.lua:2048; net.Receive at modules/vendor/libraries/server.lua:414
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorMaxStock` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:55; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:170; net.Receive at modules/vendor/libraries/client.lua:115
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorMode` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:123; net.Receive at modules/vendor/libraries/client.lua:94
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorOpen` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Receive at modules/vendor/libraries/client.lua:43; net.Start at modules/vendor/libraries/server.lua:166
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorRequestData` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/cl_init.lua:26; net.Start at modules/vendor/libraries/client.lua:47; net.Receive at modules/vendor/libraries/server.lua:482
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorSavePreset` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/derma/client.lua:1427; net.Receive at modules/vendor/libraries/server.lua:453
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorSellPrice` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Receive at modules/vendor/libraries/client.lua:83
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorStock` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:32; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:159; net.Receive at modules/vendor/libraries/client.lua:105
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorSync` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:263; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:280; net.Receive at modules/vendor/libraries/client.lua:11
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorSyncMessages` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/entities/entities/lia_vendor/shared.lua:157; net.Receive at modules/vendor/libraries/client.lua:174; net.Start at modules/vendor/libraries/server.lua:215
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorTrade` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/derma/client.lua:155; net.Start at modules/vendor/derma/client.lua:162; net.Receive at modules/vendor/libraries/server.lua:398
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVerifyCheats` in module `protection`
  - Reason: Used only by module "protection" but defined outside that module
  - Usage sites: net.Receive at modules/protection/libraries/client.lua:3251; net.Start at modules/protection/libraries/server.lua:317
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaViewClaims` in module `tickets`
  - Reason: Used only by module "tickets" but defined outside that module
  - Usage sites: net.Receive at modules/administration/submodules/tickets/libraries/client.lua:216; net.Start at modules/administration/submodules/tickets/libraries/server.lua:125; net.Receive at modules/administration/submodules/tickets/libraries/server.lua:122
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaWarningsCount` in module `warnings`
  - Reason: Used only by module "warnings" but defined outside that module
  - Usage sites: net.Start at modules/administration/submodules/warnings/libraries/server.lua:87
  - Definition sites: init.lua networkStrings at init.lua:2

#### Module-Specific Used But Undefined

None

### Direction / Flow Issues

Total suspicious patterns: **27**

- `liaAdminSetCharProperty`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:1
- `liaButtonRequestCancel`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:859
- `liaDoorData`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:1410
- `liaItemData`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:546
- `liaJobNpcCloseDialog`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:1579
- `liaKickCharacter`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:197
- `liaMapEntities`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/libraries/server.lua:535
  - Receiver sites: None
- `liaNetMessage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client, server
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:1220; core/netcalls/server.lua:1104
- `liaNPCWeaponChange`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:640
- `liaPksCount`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/libraries/server.lua:244
  - Receiver sites: None
- `liaPopupQuestionRequestCancel`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:844
- `liaProvideServerPassword`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:365
- `liaRequestMapEntities`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/libraries/server.lua:511
- `liaRequestPksCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/libraries/server.lua:240
- `liaRequestRemoveWarning`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/libraries/server.lua:32
- `liaRequestTicketsCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/tickets/libraries/server.lua:222
- `liaRequestWarningsCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/libraries/server.lua:83
- `liaRunInteraction`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:906
- `liaSeqSet`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:397
- `liaSetWaypointWithLogo`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:8
- `liaStorageTransfer`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:34
- `liaTicketsCount`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/submodules/tickets/libraries/server.lua:229
  - Receiver sites: None
- `liaTrunkInitStorage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: shared
  - Sender sites: None
  - Receiver sites: modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua:67
- `liaVendorBuyPrice`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/libraries/client.lua:72
- `liaVendorFaction`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/libraries/client.lua:67
- `liaVendorSellPrice`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/libraries/client.lua:83
- `liaWarningsCount`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/submodules/warnings/libraries/server.lua:87
  - Receiver sites: None

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 69
- **Referenced Panels:** 66
- **Module Panels Outside derma:** 0
- **Registered But Unused:** 30

### Module Panels Outside derma

None

### Registered But Unused Panels

| Panel | Module | Location |
|---|---|---|
| `liaAttribBar` | `framework` | `core/derma/panels/attribs.lua:124` |
| `liaBlurredDFrame` | `framework` | `core/derma/panels/panels.lua:50` |
| `liaCategory` | `framework` | `core/derma/panels/category.lua:116` |
| `liaCharacterAttribs` | `framework` | `core/derma/panels/attribs.lua:199` |
| `liaCharacterAttribsRow` | `framework` | `core/derma/panels/attribs.lua:321` |
| `liaCharacterCreation` | `framework` | `core/derma/mainmenu/creation.lua:389` |
| `liaClasses` | `framework` | `core/derma/panels/f1menu.lua:978` |
| `liaHeaderPanel` | `framework` | `core/derma/panels/headerpanel.lua:22` |
| `liaHorizontalScroll` | `framework` | `core/derma/panels/horizontal_scroll.lua:70` |
| `liaHorizontalScrollBar` | `framework` | `core/derma/panels/horizontal_scroll.lua:128` |
| `liaItemList` | `framework` | `core/derma/panels/genericitemlist.lua:63` |
| `liaItemSelector` | `framework` | `core/derma/panels/genericitemlist.lua:150` |
| `liaMarkupPanel` | `framework` | `core/libraries/thirdparty/cl_markup.lua:540` |
| `liaModelPanel` | `framework` | `core/derma/panels/modelpanel.lua:90` |
| `liaPrivilegeRow` | `framework` | `core/derma/panels/privilege_row.lua:101` |
| `liaSemiTransparentDFrame` | `framework` | `core/derma/panels/panels.lua:69` |
| `liaSimpleCheckbox` | `framework` | `core/derma/panels/checkbox.lua:176` |
| `liaSlider` | `framework` | `core/derma/panels/slider.lua:179` |
| `liaTable` | `framework` | `core/derma/panels/table.lua:633` |
| `liaUserGroupButton` | `framework` | `core/derma/panels/usergroup_button.lua:57` |
| `liaUserGroupList` | `framework` | `core/derma/panels/usergroup_list.lua:113` |
| `liaVoicePanel` | `framework` | `core/derma/panels/voice.lua:111` |
| `liaGridInventoryPanel` | `gridinv` | `modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua:250` |
| `liaGridInvItem` | `gridinv` | `modules/inventory/types/gridinv/derma/cl_grid_inventory_item.lua:133` |
| `liaVendorBodygroupEditor` | `vendor` | `modules/vendor/derma/client.lua:2664` |
| `liaVendorEditorItemRow` | `vendor` | `modules/vendor/derma/client.lua:1931` |
| `liaVendorFactionEditor` | `vendor` | `modules/vendor/derma/client.lua:2612` |
| `liaVendorItem` | `vendor` | `modules/vendor/derma/client.lua:1080` |
| `liaListInventory` | `weightinv` | `modules/inventory/types/weightinv/derma/cl_list_inventory.lua:27` |
| `liaListInventoryPanel` | `weightinv` | `modules/inventory/types/weightinv/derma/cl_list_inventory_panel.lua:157` |

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 82
- **UI / Derma Code Outside derma:** 6

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `administration` | `modules/administration/entities/weapons/lia_mapconfigurer/cl_init.lua:54` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:740` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:749` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:779` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:783` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:803` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:864` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:1238` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:1245` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:1397` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:55` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:92` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:105` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:140` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:168` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:199` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:230` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:240` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:256` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:316` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:357` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:482` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:488` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:511` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/server.lua:538` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `chatbox` | `modules/chatbox/libraries/client.lua:137` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\chatbox\netcalls` | Module net handler is outside the netcalls folder |
| `gridinv` | `modules/inventory/types/gridinv/libraries/server.lua:163` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\types\gridinv\netcalls` | Module net handler is outside the netcalls folder |
| `logs` | `modules/administration/submodules/logs/libraries/client.lua:263` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\logs\netcalls` | Module net handler is outside the netcalls folder |
| `logs` | `modules/administration/submodules/logs/libraries/server.lua:44` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\logs\netcalls` | Module net handler is outside the netcalls folder |
| `logs` | `modules/administration/submodules/logs/libraries/server.lua:52` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\logs\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/libraries/server.lua:61` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/module.lua:46` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/module.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/module.lua:184` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/module.lua:196` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `protection` | `modules/protection/libraries/client.lua:3251` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\protection\netcalls` | Module net handler is outside the netcalls folder |
| `recognition` | `modules/recognition/libraries/client.lua:44` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\recognition\netcalls` | Module net handler is outside the netcalls folder |
| `storage` | `modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua:67` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\types\gridinv\submodules\storage\netcalls` | Module net handler is outside the netcalls folder |
| `teams` | `modules/teams/libraries/server.lua:229` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\teams\netcalls` | Module net handler is outside the netcalls folder |
| `teams` | `modules/teams/libraries/server.lua:274` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\teams\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:121` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:216` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:229` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:238` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:259` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:267` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/server.lua:122` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/server.lua:132` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/server.lua:170` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/server.lua:200` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/server.lua:222` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:11` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:43` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:54` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:59` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:67` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:72` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:83` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:94` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:105` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:115` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:126` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:140` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:154` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:164` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:174` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:230` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:231` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/client.lua:250` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:382` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:387` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:398` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:414` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:425` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:453` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `vendor` | `modules/vendor/libraries/server.lua:482` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\vendor\netcalls` | Module net handler is outside the netcalls folder |
| `warnings` | `modules/administration/submodules/warnings/libraries/client.lua:20` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\warnings\netcalls` | Module net handler is outside the netcalls folder |
| `warnings` | `modules/administration/submodules/warnings/libraries/client.lua:104` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\warnings\netcalls` | Module net handler is outside the netcalls folder |
| `warnings` | `modules/administration/submodules/warnings/libraries/server.lua:32` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\warnings\netcalls` | Module net handler is outside the netcalls folder |
| `warnings` | `modules/administration/submodules/warnings/libraries/server.lua:73` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\warnings\netcalls` | Module net handler is outside the netcalls folder |
| `warnings` | `modules/administration/submodules/warnings/libraries/server.lua:83` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\warnings\netcalls` | Module net handler is outside the netcalls folder |
| `warnings` | `modules/administration/submodules/warnings/libraries/server.lua:93` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\warnings\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `administration` | `modules/administration/entities/weapons/lia_mapconfigurer/cl_init.lua:168` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `administration` | `modules/administration/libraries/client.lua:581` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:427` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\adminstick\derma` | Module UI-heavy code is outside the derma folder |
| `protection` | `modules/protection/libraries/client.lua:3166` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\protection\derma` | Module UI-heavy code is outside the derma folder |
| `storage` | `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\types\gridinv\submodules\storage\derma` | Module UI-heavy code is outside the derma folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:36` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\derma` | Module UI-heavy code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---
