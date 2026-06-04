## Executive Summary

### Function Documentation
- **Total Functions:** 633
- **Documented:** 626 (98.9%)
- **Missing Functions:** 7 unique (7 total occurrences)
  - **Library Functions:** 7
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 21 (used but undocumented)
- **Unused Hooks:** 3 (documented but unused)
- **Total Documented Hooks:** 432
- **Total Registered Hooks:** 445

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
- **Missing Hooks:** 21 (used in code but not documented)
- **Documented Hooks:** 432
- **Registered Hooks:** 445
- **Unused Hooks:** 3 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `AddReservedKeybinds(reserved)`
- `CanDrawEntityHoverInfo(e, category)`
- `CanPlayerSeeLog(client)`
- `CanPlayerUseAmmoBox(activator, self)`
- `CreateLogsUI(panel, categories)`
- `CreateTicketFrame(requester, message, claimed)`
- `IsCharacterCreationOverridden()`
- `LiliaNoticeOverride(msg, ntype)`
- `OnAmmoBoxUsed(activator, self, weapon, ammoType, givenAmount)`
- `OnWeaponRuntimeOverrideUpdated(className, dotPath, value)`
- `OnWeaponRuntimeOverridesBulkSynced(overrides)`
- `OpenCharacterMenu()`
- `OpenCharacterMenuOverride()`
- `ReadLogEntries(category, page)`
- `SAM.LoadedRanks()`
- `ShouldDrawCrosshair(client, wpn)`
- `SuppressHint(hint)`
- `VendorItemBuyPriceUpdated(vendor, itemType, value)`
- `VendorItemSellPriceUpdated(vendor, itemType, value)`
- `VendorPropertyUpdated(vendor, propertyName, propertyValue)`
- `VerifyCheats()`

### Unused Hook Documentation:
These hooks are documented but not registered in code:
- `GetVendorSaleScale()`
- `OnPlayerEnterSequence()`
- `VendorItemPriceUpdated()`

## Localization Analysis

- **Unique Keys:** 3830
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

- **Module-Specific But Registered Outside Module:** 3
- **Module-Specific Used But Undefined:** 0

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

- `liaUpdateAdminPrivileges` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: lia.net.readBigTable at modules/administration/admin.lua:1568; lia.net.writeBigTable at modules/administration/admin.lua:873
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorEdit` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/derma/client.lua:2011; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:113; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:196; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:205; net.Start at modules/vendor/entities/entities/lia_vendor/init.lua:215
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorPropertySync` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/libraries/server.lua:177; net.Start at modules/vendor/libraries/server.lua:186; net.Receive at modules/vendor/netcalls/client.lua:194; net.Start at modules/vendor/netcalls/server.lua:109; net.Start at modules/vendor/netcalls/server.lua:118
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
  - Receiver sites: modules/administration/netcalls/server.lua:3
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
  - Sender sites: modules/administration/netcalls/server.lua:572
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
  - Sender sites: modules/administration/netcalls/server.lua:287
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
  - Receiver sites: modules/administration/netcalls/server.lua:548
- `liaRequestPksCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:283
- `liaRequestRemoveWarning`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/netcalls/server.lua:3
- `liaRequestTicketsCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/tickets/netcalls/server.lua:103
- `liaRequestWarningsCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/netcalls/server.lua:54
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
  - Sender sites: modules/administration/submodules/tickets/netcalls/server.lua:110
  - Receiver sites: None
- `liaTrunkInitStorage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: shared
  - Sender sites: None
  - Receiver sites: modules/inventory/types/gridinv/submodules/storage/netcalls/shared.lua:3
- `liaVendorBuyPrice`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/netcalls/client.lua:64
- `liaVendorFaction`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/netcalls/client.lua:59
- `liaVendorSellPrice`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/netcalls/client.lua:75
- `liaWarningsCount`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/submodules/warnings/netcalls/server.lua:58
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
| `liaVendorBodygroupEditor` | `vendor` | `modules/vendor/derma/client.lua:2754` |
| `liaVendorEditorItemRow` | `vendor` | `modules/vendor/derma/client.lua:2002` |
| `liaVendorFactionEditor` | `vendor` | `modules/vendor/derma/client.lua:2702` |
| `liaVendorItem` | `vendor` | `modules/vendor/derma/client.lua:1080` |
| `liaListInventory` | `weightinv` | `modules/inventory/types/weightinv/derma/cl_list_inventory.lua:27` |
| `liaListInventoryPanel` | `weightinv` | `modules/inventory/types/weightinv/derma/cl_list_inventory_panel.lua:157` |

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 2
- **UI / Derma Code Outside derma:** 8

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `mainmenu` | `modules/mainmenu/module.lua:49` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/module.lua:92` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `administration` | `modules/administration/admin.lua:1592` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `administration` | `modules/administration/entities/weapons/lia_mapconfigurer/cl_init.lua:146` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `administration` | `modules/administration/libraries/client.lua:581` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `administration` | `modules/administration/netcalls/client.lua:91` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:427` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\adminstick\derma` | Module UI-heavy code is outside the derma folder |
| `protection` | `modules/protection/libraries/client.lua:3166` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\protection\derma` | Module UI-heavy code is outside the derma folder |
| `storage` | `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\types\gridinv\submodules\storage\derma` | Module UI-heavy code is outside the derma folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:42` | `D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\submodules\tickets\derma` | Module UI-heavy code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---
