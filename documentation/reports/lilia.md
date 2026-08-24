## Executive Summary

### Function Documentation
- **Total Functions:** 715
- **Documented:** 701 (98.0%)
- **Missing Functions:** 14 unique (14 total occurrences)
  - **Library Functions:** 13
  - **Hook Functions:** 1
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 1 (used but undocumented)
- **Unused Hooks:** 1 (documented but unused)
- **Total Documented Hooks:** 450
- **Total Registered Hooks:** 447

### Localization Analysis
- **Undefined Calls:** 1 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 203
- **Used Net Messages:** 203
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 45
- **Missing Documentation:** 14 unique functions

### Missing Library Functions
Total: 13 functions

#### lia.admin
Count: 1 functions

- `lia.admin.clearPrivilegeCategoryCache()`

#### lia.camera
Count: 6 functions

- `lia.camera.begin(owner, config)`
- `lia.camera.close(owner)`
- `lia.camera.getEntity(owner)`
- `lia.camera.rotate(owner, deltaYaw)`
- `lia.camera.setModel(owner, modelPath, options)`
- `lia.camera.shouldHidePlayer(player)`

#### lia.derma
Count: 2 functions

- `lia.derma.requestBinaryNotice(question, option1, option2, manualDismiss, callback)`
- `lia.derma.requestNPCSelection(title, description, options, callback)`

#### lia.net
Count: 1 functions

- `lia.net.profiler.recordSessionEntry(direction, messageName, rawSize, sender, receiver)`

#### lia.util
Count: 1 functions

- `lia.util.drawEntInfoBox(ent, data, alphaOverride)`

#### lia.webimage
Count: 2 functions

- `lia.webimage.getCRC(n)`
- `lia.webimage.getPath(n)`

### Missing Hook Functions
Total: 1 functions

- `playerMeta:hasStaffCharacterPermission(privilegeName)`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 450
- **Registered Hooks:** 447
- **Method Hooks:** 21 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 426 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 1 (documented but not registered)

### Method-Style Hooks:
These hooks are defined as `function GM:HookName(...)`, `function MODULE:HookName(...)`, or `function SCHEMA:HookName(...)`.
- `AddFilteredWord(word)`
- `ChooseCharacter(id)`
- `CreateCharacter(data)`
- `CreateLogsUI(panel, categories)`
- `CreateTicketFrame(requester, message, claimed)`
- `DeleteCharacter(id)`
- `FetchSpawns()`
- `GetAllCaseClaims()`
- `GetDoorInfo(entity, doorData, doorInfo)`
- `GetFilteredWords()`
- `GetWarnings(charID)`
- `LoadMainCharacter()`
- `OpenCharacterMenu()`
- `ReadLogEntries(category, page)`
- `RemoveFilteredWord(word)`
- `RemoveWarning(charID, index)`
- `SendPopup(client, message)`
- `SetMainCharacter(charID)`
- `StoreSpawns(spawns)`
- `SyncFilteredWords(targets)`
- `TrackOfflineFactionTransfer(charID, oldFactionValue, newFactionValue, actor, reason)`

### Library Hook Registration Locations:
These entries show hooks registered from framework libraries.
- `AddReservedKeybinds`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `AddWarning`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `AdjustPACPartData`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `AdminPrivilegesUpdated`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `AttachPart`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `CanCharBeTransfered`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `CanPersistEntity`
  - library `compatibility` [standard] in `core/libraries/compatibility/permaprops.lua`
- `CanPlayerJoinClass`
  - library `classes.lua` [standard] in `core/libraries/classes.lua`
- `CanPlayerModifyConfig`
  - library `config.lua` [standard] in `core/libraries/config.lua`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `CanPlayerUseCommand`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `CanRunItemAction`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `CanTakeEntity`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `CharCleanUp`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `CharRestored`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `ChatParsed`
  - library `chatbox.lua` [standard] in `core/libraries/chatbox.lua`
- `CollectDoorDataFields`
  - library `doors.lua` [standard] in `core/libraries/doors.lua`
- `CommandAdded`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `CommandRan`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `ConfigChanged`
  - library `config.lua` [standard] in `core/libraries/config.lua`
- `CreateDefaultInventory`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `CreateInformationButtons`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
  - library `flags.lua` [standard] in `core/libraries/flags.lua`
  - library `workshop.lua` [standard] in `core/libraries/workshop.lua`
- `CreateInventoryPanel`
  - library `inventory.lua` [standard] in `core/libraries/inventory.lua`
- `CreateMenuButtons`
  - library `config.lua` [standard] in `core/libraries/config.lua`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `CreateSalaryTimers`
  - library `config.lua` [standard] in `core/libraries/config.lua`
- `DatabaseConnected`
  - library `database.lua` [method] in `core/libraries/database.lua`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
- `DermaSkinChanged`
  - library `config.lua` [standard] in `core/libraries/config.lua`
- `DoModuleIncludes`
  - library `modularity.lua` [standard] in `core/libraries/modularity.lua`
- `DoorEnabledToggled`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `DoorHiddenToggled`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `DoorOwnableToggled`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `DoorPriceSet`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `DoorTitleSet`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `DrawPlayerRagdoll`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `ForceRecognizeRange`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `FreelookToggled`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
- `GetAdjustedPartData`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `GetAttributeMax`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `GetAttributeStartingMax`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `GetDefaultCharDesc`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `GetDefaultCharName`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `GetDisplayedName`
  - library `chatbox.lua` [standard] in `core/libraries/chatbox.lua`
- `GetMaxStartingAttributePoints`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `GetPlayTime`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
- `GetUsergroupIcon`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `GetWeaponName`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `HandleItemTransferRequest`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `InitializedConfig`
  - library `color.lua` [standard] in `core/libraries/color.lua`
  - library `config.lua` [standard] in `core/libraries/config.lua`
  - library `fonts.lua` [standard] in `core/libraries/fonts.lua`
- `InitializedItems`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `InitializedKeybinds`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `InitializedModules`
  - library `currency.lua` [standard] in `core/libraries/currency.lua`
  - library `darkrp.lua` [standard] in `core/libraries/darkrp.lua`
  - library `item.lua` [standard] in `core/libraries/item.lua`
  - library `modularity.lua` [standard] in `core/libraries/modularity.lua`
  - library `performance.lua` [standard] in `core/libraries/performance.lua`
  - library `workshop.lua` [standard] in `core/libraries/workshop.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/arccw.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/simfphys.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sitanywhere.lua`
- `InitializedOptions`
  - library `option.lua` [standard] in `core/libraries/option.lua`
- `InitializedSchema`
  - library `modularity.lua` [standard] in `core/libraries/modularity.lua`
- `InteractionMenuClosed`
  - library `playerinteract.lua` [standard] in `core/libraries/playerinteract.lua`
- `InteractionMenuOpened`
  - library `playerinteract.lua` [standard] in `core/libraries/playerinteract.lua`
- `InventoryClosed`
  - library `inventory.lua` [standard] in `core/libraries/inventory.lua`
- `InventoryInitialized`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `InventoryItemAdded`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `InventoryItemIconCreated`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `InventoryItemRemoved`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `InventoryOpened`
  - library `inventory.lua` [standard] in `core/libraries/inventory.lua`
- `IsSuitableForTrunk`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/simfphys.lua`
- `ItemDataChanged`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `ItemDefaultFunctions`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `ItemQuantityChanged`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `LiliaLoaded`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
- `LiliaNoticeOverride`
  - library `notice.lua` [standard] in `core/libraries/notice.lua`
- `LoadData`
  - library `dialog.lua` [standard] in `core/libraries/dialog.lua`
- `ModifyCharacterModel`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
- `NetVarChanged`
  - library `net.lua` [standard] in `core/libraries/net.lua`
- `OnAdminSystemLoaded`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
- `OnCharDelete`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `OnCharGetup`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `OnCharVarChanged`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `OnConfigUpdated`
  - library `color.lua` [standard] in `core/libraries/color.lua`
  - library `config.lua` [standard] in `core/libraries/config.lua`
  - library `currency.lua` [standard] in `core/libraries/currency.lua`
  - library `fonts.lua` [standard] in `core/libraries/fonts.lua`
  - library `languages.lua` [standard] in `core/libraries/languages.lua`
- `OnCreateDualInventoryPanels`
  - library `inventory.lua` [standard] in `core/libraries/inventory.lua`
- `OnDatabaseLoaded`
  - library `database.lua` [standard] in `core/libraries/database.lua`
- `OnDataSet`
  - library `data.lua` [standard] in `core/libraries/data.lua`
- `OnItemCreated`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `OnItemOverridden`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `OnItemRegistered`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `OnLoadTables`
  - library `database.lua` [standard] in `core/libraries/database.lua`
- `OnLocalizationLoaded`
  - library `languages.lua` [standard] in `core/libraries/languages.lua`
- `OnNPCTypeSet`
  - library `dialog.lua` [standard] in `core/libraries/dialog.lua`
- `OnOOCMessageSent`
  - library `chatbox.lua` [standard] in `core/libraries/chatbox.lua`
- `OnPAC3PartTransfered`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `OnPlayerDroppedItem`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `OnPlayerInteractItem`
  - library `compatibility` [standard] in `core/libraries/compatibility/vmanip.lua`
- `OnPlayerObserve`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `OnPlayerPurchaseDoor`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `OnPlayerRotateItem`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `OnPlayerTakeItem`
  - library `item.lua` [standard] in `core/libraries/item.lua`
- `OnPrivilegeRegistered`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
- `OnPrivilegeUnregistered`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
- `OnServerLog`
  - library `logger.lua` [standard] in `core/libraries/logger.lua`
- `OnSetUsergroup`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sadmin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/serverguard.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/ulx.lua`
- `OnThemeChanged`
  - library `color.lua` [standard] in `core/libraries/color.lua`
- `OnTransferred`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `OnUsergroupCreated`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `OnUsergroupPermissionsChanged`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `OnUsergroupRemoved`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `OnUsergroupRenamed`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `OnVoiceTypeChanged`
  - library `playerinteract.lua` [standard] in `core/libraries/playerinteract.lua`
- `OptionAdded`
  - library `option.lua` [standard] in `core/libraries/option.lua`
- `OptionChanged`
  - library `option.lua` [standard] in `core/libraries/option.lua`
- `OptionReceived`
  - library `option.lua` [standard] in `core/libraries/option.lua`
- `OverrideFactionDesc`
  - library `factions.lua` [standard] in `core/libraries/factions.lua`
- `OverrideFactionModelCustomization`
  - library `factions.lua` [standard] in `core/libraries/factions.lua`
- `OverrideFactionModels`
  - library `factions.lua` [standard] in `core/libraries/factions.lua`
- `OverrideFactionName`
  - library `factions.lua` [standard] in `core/libraries/factions.lua`
- `OverrideSpawnTime`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `PlayerBodyGroupChanged`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `PlayerGagged`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `PlayerLoadedChar`
  - library `compatibility` [standard] in `core/libraries/compatibility/prone.lua`
- `PlayerMessageSend`
  - library `chatbox.lua` [standard] in `core/libraries/chatbox.lua`
- `PlayerMuted`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `PlayerUngagged`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `PlayerUnmuted`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `PopulateAdminTabs`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
- `PopulateConfigurationButtons`
  - library `config.lua` [standard] in `core/libraries/config.lua`
  - library `item.lua` [standard] in `core/libraries/item.lua`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
  - library `option.lua` [standard] in `core/libraries/option.lua`
- `PostLoadData`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `PostLoadFonts`
  - library `fonts.lua` [standard] in `core/libraries/fonts.lua`
- `PostPlayerInitialSpawn`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `PostPlayerLoadedChar`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
- `PreCharDelete`
  - library `character.lua` [standard] in `core/libraries/character.lua`
- `PreFreelookToggle`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
- `PreLiliaLoaded`
  - library `keybind.lua` [standard] in `core/libraries/keybind.lua`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
- `RefreshFonts`
  - library `fonts.lua` [standard] in `core/libraries/fonts.lua`
- `RemovePart`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `RunAdminSystemCommand`
  - library `admin.lua` [standard] in `core/libraries/admin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sadmin.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/serverguard.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/ulx.lua`
- `SaveData`
  - library `data.lua` [standard] in `core/libraries/data.lua`
  - library `dialog.lua` [standard] in `core/libraries/dialog.lua`
- `SetupDatabase`
  - library `database.lua` [method] in `core/libraries/database.lua`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
- `SetupPACDataFromItems`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `SetupPlayerModel`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
- `SetupQuickMenu`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
- `ShouldAllowSit`
  - library `sit.lua` [standard] in `core/libraries/sit.lua`
- `ShouldBarDraw`
  - library `bars.lua` [standard] in `core/libraries/bars.lua`
- `ShouldDisableThirdperson`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
- `ShouldHideBars`
  - library `bars.lua` [standard] in `core/libraries/bars.lua`
- `SyncCharList`
  - library `character.lua` [standard] in `core/libraries/character.lua`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `ThirdPersonToggled`
  - library `camera.lua` [standard] in `core/libraries/camera.lua`
  - library `option.lua` [standard] in `core/libraries/option.lua`
- `TrackFactionTransfer`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `TryViewModel`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac.lua`
- `UpdateEntityPersistence`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
  - library `dialog.lua` [standard] in `core/libraries/dialog.lua`
- `VoiceToggled`
  - library `config.lua` [standard] in `core/libraries/config.lua`
- `WarningIssued`
  - library `commands.lua` [standard] in `core/libraries/commands.lua`
- `WebImageDownloaded`
  - library `webimage.lua` [standard] in `core/libraries/webimage.lua`
- `WebSoundDownloaded`
  - library `websound.lua` [standard] in `core/libraries/websound.lua`

### Other Hook Registration Locations:
These entries show hooks registered outside libraries and outside external module/submodule scans.
- `AddBarField`
  - other [standard] in `modules/attributes/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `AddFilteredWord`
  - other [method] in `modules/chatbox/libraries/server.lua`
- `AddSection`
  - other [standard] in `modules/attributes/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `AddTextField`
  - other [standard] in `modules/teams/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `AddToAdminStickHUD`
  - other [method] in `modules/vendor/libraries/client.lua`
  - other [method] in `modules/doors/libraries/client.lua`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `AddWarning`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `AdjustCreationData`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `AdjustStaminaOffset`
  - other [standard] in `modules/attributes/libraries/shared.lua`
- `AdminPrivilegesUpdated`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `AdminStickAddModels`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
- `AttachPart`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `BagInventoryReady`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `BagInventoryRemoved`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `CanAccessFactionRoster`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanCharBeTransfered`
  - other [standard] in `modules/teams/pim.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanDeleteChar`
  - other [method] in `modules/protection/libraries/client.lua`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CanDisplayCharInfo`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `CanDrawEntityHoverInfo`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `CanEditFactionNotes`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanInviteToClass`
  - other [standard] in `modules/teams/pim.lua`
- `CanInviteToFaction`
  - other [standard] in `modules/teams/pim.lua`
- `CanItemBeTransfered`
  - other [standard] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/inventory/types/weightinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
- `CanManageFilteredWords`
  - other [method] in `modules/chatbox/libraries/server.lua`
  - other [standard] in `modules/chatbox/libraries/server.lua`
  - other [standard] in `modules/chatbox/netcalls/server.lua`
- `CanOpenBagPanel`
  - other [standard] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `CanOutfitChangeModel`
  - item `base` [standard] in `items/base/outfit.lua`
- `CanPerformVendorEdit`
  - meta `player` [standard] in `core/meta/player.lua`
- `CanPersistEntity`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/administration/libraries/server.lua`
- `CanPickupMoney`
  - entity `entities` [standard] in `entities/entities/lia_money/init.lua`
- `CanPlayerAccessDoor`
  - other [method] in `modules/doors/libraries/server.lua`
  - meta `entity` [standard] in `core/meta/entity.lua`
- `CanPlayerAccessVendor`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/netcalls/server.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/init.lua`
- `CanPlayerChooseWeapon`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`
- `CanPlayerCreateChar`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `CanPlayerDropItem`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CanPlayerEarnSalary`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CanPlayerEquipItem`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CanPlayerHoldObject`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
- `CanPlayerInteractItem`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - meta `item` [standard] in `core/meta/item.lua`
- `CanPlayerJoinClass`
  - other [method] in `modules/teams/libraries/server.lua`
- `CanPlayerKnock`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
- `CanPlayerLock`
  - other [standard] in `modules/doors/libraries/server.lua`
- `CanPlayerModifyConfig`
  - other [method] in `modules/administration/libraries/shared.lua`
- `CanPlayerOpenScoreboard`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `CanPlayerRespawn`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `CanPlayerRotateItem`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CanPlayerSeeLogCategory`
  - other [standard] in `modules/administration/submodules/logs/netcalls/server.lua`
- `CanPlayerSeeLogs`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
  - other [standard] in `modules/administration/submodules/logs/netcalls/server.lua`
- `CanPlayerSpawnStorage`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
- `CanPlayerSwitchChar`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/protection/libraries/server.lua`
  - other [method] in `modules/mainmenu/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `CanPlayerTakeItem`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CanPlayerThrowPunch`
  - other [method] in `modules/attributes/libraries/shared.lua`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
- `CanPlayerTradeWithVendor`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/libraries/server.lua`
- `CanPlayerUnequipItem`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CanPlayerUnlock`
  - other [standard] in `modules/doors/libraries/server.lua`
- `CanPlayerUseAmmoBox`
  - entity `entities` [standard] in `entities/entities/lia_ammobox/init.lua`
- `CanPlayerUseChar`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/mainmenu/libraries/server.lua`
  - other [method] in `modules/administration/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `CanPlayerUseDoor`
  - other [method] in `modules/doors/libraries/server.lua`
  - other [standard] in `modules/doors/libraries/server.lua`
- `CanPlayerViewInventory`
  - other [standard] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `CanRunItemAction`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/item.lua`
- `CanSaveData`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
- `CharDeleted`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `CharForceRecognized`
  - other [standard] in `modules/recognition/libraries/server.lua`
- `CharHasFlags`
  - meta `player` [standard] in `core/meta/player.lua`
- `CharListEntry`
  - other [standard] in `modules/administration/netcalls/server.lua`
- `CharListLoaded`
  - other [method] in `modules/mainmenu/module.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `CharListUpdated`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `CharLoaded`
  - other [standard] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/administration/netcalls/client.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `CharMenuClosed`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CharMenuOpened`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CharPostSave`
  - meta `character` [standard] in `core/meta/character.lua`
- `CharPreSave`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/spawns/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `CharRestored`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
- `ChatboxPanelCreated`
  - other [standard] in `modules/chatbox/libraries/client.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `ChatboxTextAdded`
  - other [standard] in `modules/chatbox/libraries/client.lua`
- `CheckFactionLimitReached`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/teams/libraries/shared.lua`
- `ChooseCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `ConfigureCharacterCreationSteps`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
- `CreateCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `CreateChatboxPanel`
  - other [method] in `modules/chatbox/libraries/client.lua`
  - other [standard] in `modules/chatbox/libraries/client.lua`
  - other [standard] in `modules/chatbox/netcalls/client.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `CreateDefaultInventory`
  - core `hooks` [method] in `core/hooks/server.lua`
- `CreateInformationButtons`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `CreateInventoryPanel`
  - other [method] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/client.lua`
- `CreateLogsUI`
  - other [method] in `modules/administration/submodules/logs/libraries/client.lua`
- `CreateMenuButtons`
  - other [method] in `modules/mainmenu/module.lua`
  - other [method] in `modules/teams/libraries/client.lua`
  - other [standard] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `CreateSalaryTimers`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `CreateTicketFrame`
  - other [method] in `modules/administration/submodules/tickets/libraries/client.lua`
- `DatabaseConnected`
  - other [method] in `modules/vendor/libraries/server.lua`
- `DeleteCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `DermaSkinChanged`
  - core `hooks` [method] in `core/hooks/client.lua`
- `DisplayPlayerHUDInformation`
  - other [method] in `modules/administration/libraries/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `DoorLockToggled`
  - other [standard] in `modules/doors/libraries/server.lua`
- `DrawCharInfo`
  - other [method] in `modules/teams/libraries/client.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `DrawEntityInfo`
  - other [method] in `modules/doors/libraries/client.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `DrawItemEntityInfo`
  - entity `entities` [standard] in `entities/entities/lia_item/cl_init.lua`
- `DrawLiliaModelView`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/model.lua`
- `DrawPlayerInfoBackground`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `F1MenuClosed`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `F1MenuOpened`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `FetchSpawns`
  - other [method] in `modules/spawns/libraries/server.lua`
- `FilterCharModels`
  - other [standard] in `modules/mainmenu/derma/steps/cl_model.lua`
- `FilterDoorInfo`
  - other [standard] in `modules/doors/libraries/client.lua`
- `ForceRecognizeRange`
  - other [method] in `modules/recognition/libraries/server.lua`
- `GetAdminESPTarget`
  - other [standard] in `modules/administration/libraries/client.lua`
- `GetAdminStickLists`
  - other [method] in `modules/doors/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/derma/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
- `GetAllCaseClaims`
  - other [method] in `modules/administration/submodules/tickets/libraries/server.lua`
- `GetAttributeMax`
  - other [standard] in `modules/attributes/libraries/client.lua`
  - core `hooks` [method] in `core/hooks/shared.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `GetAttributeStartingMax`
  - core `hooks` [method] in `core/hooks/shared.lua`
- `GetBotModel`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetCharacterCreateButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterCreationSummary`
  - other [standard] in `modules/mainmenu/derma/steps/cl_summary.lua`
- `GetCharacterDisconnectButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterDiscordButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterLoadButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterLoadMainButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterMountButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterReturnButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterStaffButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharacterWorkshopButtonTooltip`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `GetCharMaxStamina`
  - other [standard] in `modules/attributes/libraries/client.lua`
  - other [standard] in `modules/attributes/libraries/server.lua`
  - other [standard] in `modules/attributes/libraries/shared.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
  - meta `player` [standard] in `core/meta/player.lua`
- `GetDamageScale`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetDefaultCharDesc`
  - other [method] in `modules/teams/libraries/shared.lua`
  - other [standard] in `modules/mainmenu/derma/steps/cl_biography.lua`
- `GetDefaultCharName`
  - other [method] in `modules/teams/libraries/shared.lua`
  - other [standard] in `modules/mainmenu/derma/steps/cl_biography.lua`
- `GetDefaultInventorySize`
  - other [standard] in `modules/inventory/types/gridinv/config.lua`
  - other [standard] in `modules/inventory/types/weightinv/config.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
- `GetDefaultInventoryType`
  - other [standard] in `modules/inventory/module.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetDisplayedDescription`
  - other [method] in `modules/recognition/libraries/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `GetDisplayedName`
  - other [method] in `modules/recognition/libraries/client.lua`
  - other [standard] in `modules/chatbox/libraries/shared.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
  - core `derma` [standard] in `core/derma/panels/voice.lua`
- `GetDoorInfo`
  - other [method] in `modules/doors/libraries/client.lua`
- `GetDoorInfoForAdminStick`
  - other [standard] in `modules/doors/libraries/client.lua`
- `GetEntitySaveData`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetFilteredWords`
  - other [method] in `modules/chatbox/libraries/server.lua`
- `GetHandsAttackSpeed`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
- `GetInjuredText`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `GetInventoryMaxWeight`
  - other [standard] in `modules/inventory/types/weightinv/weightinv.lua`
- `GetItemDropModel`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
- `GetMainCharacterID`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/module.lua`
- `GetMainMenuPosition`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
- `GetMaxPlayerChar`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
- `GetMaxStartingAttributePoints`
  - other [standard] in `modules/mainmenu/derma/steps/cl_biography.lua`
  - core `hooks` [method] in `core/hooks/shared.lua`
- `GetModelGender`
  - core `hooks` [method] in `core/hooks/shared.lua`
  - meta `entity` [standard] in `core/meta/entity.lua`
- `GetMoneyModel`
  - entity `entities` [standard] in `entities/entities/lia_money/init.lua`
- `GetNPCDialogOptions`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `GetNPCRelations`
  - other [standard] in `modules/teams/libraries/server.lua`
- `GetOOCDelay`
  - other [standard] in `modules/chatbox/libraries/shared.lua`
- `GetPlayerDeathSound`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetPlayerPainSound`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetPlayerPunchDamage`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
- `GetPlayerPunchRagdollTime`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
- `GetPlayerRespawnLocation`
  - other [standard] in `modules/spawns/libraries/server.lua`
- `GetPlayerSpawnLocation`
  - other [standard] in `modules/spawns/libraries/server.lua`
- `GetPlayTime`
  - meta `player` [standard] in `core/meta/player.lua`
- `GetPrestigePayBonus`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetPriceOverride`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/shared.lua`
- `GetRagdollTime`
  - meta `player` [standard] in `core/meta/player.lua`
- `GetRespawnScreenCause`
  - other [standard] in `modules/spawns/libraries/client.lua`
- `GetSalaryAmount`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetUsergroupIcon`
  - other [standard] in `modules/chatbox/libraries/shared.lua`
- `GetWarnings`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `GetWeaponName`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`
- `HandleItemTransferRequest`
  - other [method] in `modules/inventory/types/weightinv/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `InitializedModules`
  - other [method] in `modules/protection/libraries/server.lua`
  - other [method] in `modules/chatbox/libraries/server.lua`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
- `InitializedSchema`
  - core `hooks` [method] in `core/hooks/server.lua`
- `InitializeStorage`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua`
- `InteractionMenuOpened`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `InterceptClickItemIcon`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua`
- `InventoryClosed`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `InventoryDataChanged`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `InventoryDeleted`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `InventoryInitialized`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `InventoryItemAdded`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/client.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `InventoryItemIconCreated`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua`
- `InventoryItemRemoved`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/client.lua`
  - meta `inventory` [standard] in `core/meta/inventory.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `InventoryOpened`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `InventoryPanelCreated`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `IsCharacterCreationOverridden`
  - other [standard] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `IsCharFakeRecognized`
  - other [method] in `modules/recognition/libraries/shared.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `IsCharRecognized`
  - other [standard] in `modules/recognition/pim.lua`
  - other [method] in `modules/recognition/libraries/shared.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `IsRecognizedChatType`
  - other [standard] in `modules/recognition/libraries/client.lua`
- `IsSuitableForTrunk`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua`
- `ItemCombine`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
- `ItemDataChanged`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - meta `panel` [standard] in `core/meta/panel.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `ItemDeleted`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `ItemDraggedOutOfInventory`
  - other [standard] in `modules/inventory/types/weightinv/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `ItemFunctionCalled`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
  - meta `item` [standard] in `core/meta/item.lua`
- `ItemInitialized`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `ItemPaintOver`
  - core `derma` [standard] in `core/derma/panels/item.lua`
- `ItemQuantityChanged`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `ItemShowEntityMenu`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `ItemTransfered`
  - other [standard] in `modules/inventory/types/weightinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `KeyLock`
  - other [method] in `modules/doors/libraries/server.lua`
  - other [standard] in `modules/doors/entities/weapons/lia_keys/shared.lua`
- `KeyUnlock`
  - other [method] in `modules/doors/libraries/server.lua`
  - other [standard] in `modules/doors/entities/weapons/lia_keys/shared.lua`
- `KickedFromChar`
  - other [method] in `modules/mainmenu/module.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `LiliaLoaded`
  - other [method] in `modules/mainmenu/module.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `LiliaModelPanelPostDrawModel`
  - core `derma` [standard] in `core/derma/panels/model.lua`
- `LoadCharInformation`
  - other [method] in `modules/teams/libraries/client.lua`
  - other [method] in `modules/attributes/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `LoadData`
  - other [method] in `modules/doors/libraries/server.lua`
  - other [method] in `modules/chatbox/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `LoadMainCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `LoadMainMenuInformation`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `ModifyCharacterCreationSummary`
  - other [standard] in `modules/mainmenu/derma/steps/cl_summary.lua`
- `ModifyCharacterModel`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
- `ModifyScoreboardModel`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `NetVarChanged`
  - meta `character` [standard] in `core/meta/character.lua`
  - meta `entity` [standard] in `core/meta/entity.lua`
  - meta `player` [standard] in `core/meta/player.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnAdminStickMenuClosed`
  - other [standard] in `modules/administration/submodules/adminstick/derma/client.lua`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `OnAmmoBoxUsed`
  - entity `entities` [standard] in `entities/entities/lia_ammobox/init.lua`
- `OnCharacterCreationModelIconSet`
  - other [standard] in `modules/mainmenu/derma/steps/cl_model.lua`
- `OnCharAttribBoosted`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnCharAttribUpdated`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnCharCreated`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `OnCharDelete`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `OnCharDisconnect`
  - other [method] in `modules/spawns/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnCharFallover`
  - meta `player` [standard] in `core/meta/player.lua`
- `OnCharFlagsGiven`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnCharFlagsTaken`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnCharKick`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnCharNetVarChanged`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnCharPermakilled`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnCharRecognized`
  - other [standard] in `modules/recognition/pim.lua`
  - other [standard] in `modules/recognition/libraries/server.lua`
  - other [standard] in `modules/recognition/netcalls/client.lua`
- `OnCharTradeVendor`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/libraries/server.lua`
- `OnCharVarChanged`
  - other [method] in `modules/teams/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/shared.lua`
  - meta `character` [standard] in `core/meta/character.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnChatReceived`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnCreateItemInteractionMenu`
  - core `derma` [standard] in `core/derma/panels/item.lua`
- `OnCreateStoragePanel`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua`
- `OnDatabaseLoaded`
  - core `hooks` [method] in `core/hooks/server.lua`
- `OnDeathSoundPlayed`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnDialogNPCTypeSet`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `OnEntityLoaded`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnEntityPersisted`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnEntityPersistUpdated`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnItemAdded`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
  - meta `inventory` [standard] in `core/meta/inventory.lua`
- `OnItemCreated`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
- `OnItemSpawned`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
- `OnlineStaffDataReceived`
  - other [standard] in `modules/administration/netcalls/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `OnLocalVarSet`
  - other [method] in `modules/attributes/libraries/client.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnModelPanelSetup`
  - core `derma` [standard] in `core/derma/panels/model.lua`
- `OnOpenVendorMenu`
  - other [standard] in `modules/vendor/libraries/client.lua`
- `OnPainSoundPlayed`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnPickupMoney`
  - entity `entities` [standard] in `entities/entities/lia_money/init.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
- `OnPlayerDroppedItem`
  - other [method] in `modules/protection/libraries/server.lua`
- `OnPlayerInteractItem`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
  - meta `item` [standard] in `core/meta/item.lua`
- `OnPlayerJoinClass`
  - other [standard] in `modules/teams/pim.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnPlayerLostStackItem`
  - other [standard] in `modules/inventory/types/gridinv/gridinv.lua`
- `OnPlayerObserve`
  - other [standard] in `modules/administration/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `OnPlayerRotateItem`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
- `OnPlayerSwitchClass`
  - other [method] in `modules/teams/libraries/server.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `OnRequestItemTransfer`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua`
- `OnRespawnKeyPressed`
  - other [standard] in `modules/spawns/libraries/client.lua`
- `OnSalaryAdjust`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnSalaryGiven`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnSavedItemLoaded`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnThemeChanged`
  - other [standard] in `modules/vendor/derma/client.lua`
  - core `derma` [standard] in `core/derma/panels/chatbox.lua`
  - core `derma` [standard] in `core/derma/panels/dialog.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
  - core `derma` [standard] in `core/derma/panels/quick.lua`
- `OnTicketClaimed`
  - other [standard] in `modules/administration/submodules/tickets/netcalls/server.lua`
- `OnTicketClosed`
  - other [standard] in `modules/administration/submodules/tickets/netcalls/server.lua`
- `OnTicketCreated`
  - other [standard] in `modules/administration/submodules/tickets/commands.lua`
- `OnTransferred`
  - other [standard] in `modules/teams/pim.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `OnVendorEdited`
  - other [standard] in `modules/vendor/netcalls/server.lua`
- `OnVoiceTypeChanged`
  - core `hooks` [method] in `core/hooks/server.lua`
- `OnWeaponOverridesBulkSynced`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnWeaponOverrideUpdated`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `OnWeaponRuntimeOverridesBulkSynced`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnWeaponRuntimeOverrideUpdated`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `OpenAdminStickQuickMenu`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `OpenAdminStickUI`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `OpenCharacterMenu`
  - other [method] in `modules/mainmenu/module.lua`
- `OpenCharacterMenuOverride`
  - other [standard] in `modules/mainmenu/module.lua`
- `OptionAdded`
  - core `derma` [standard] in `core/derma/panels/quick.lua`
- `OverrideSpawnTime`
  - other [standard] in `modules/spawns/libraries/client.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `OverrideVoiceHearingStatus`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PaintItem`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory_item.lua`
  - entity `entities` [standard] in `entities/entities/lia_item/cl_init.lua`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
  - core `derma` [standard] in `core/derma/panels/item.lua`
  - core `derma` [standard] in `core/derma/panels/spawnicon.lua`
- `PlayerAccessVendor`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/init.lua`
- `PlayerLiliaDataLoaded`
  - other [method] in `modules/mainmenu/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PlayerLoadedChar`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/mainmenu/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [method] in `modules/chatbox/libraries/server.lua`
  - other [method] in `modules/attributes/libraries/server.lua`
  - other [method] in `modules/administration/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `PlayerModelChanged`
  - core `hooks` [standard] in `core/hooks/shared.lua`
- `PlayerShouldPermaKill`
  - other [method] in `modules/administration/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PlayerSpawnPointSelected`
  - other [standard] in `modules/spawns/libraries/server.lua`
- `PlayerStaminaGained`
  - other [standard] in `modules/attributes/libraries/shared.lua`
  - meta `player` [standard] in `core/meta/player.lua`
- `PlayerStaminaLost`
  - other [method] in `modules/attributes/libraries/server.lua`
  - other [standard] in `modules/attributes/libraries/shared.lua`
  - meta `player` [standard] in `core/meta/player.lua`
- `PlayerThrowPunch`
  - other [method] in `modules/attributes/libraries/server.lua`
  - entity `weapons` [standard] in `entities/weapons/lia_hands/shared.lua`
- `PlayerUseDoor`
  - other [standard] in `modules/doors/libraries/server.lua`
- `PopulateAdminStick`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
- `PopulateAdminTabs`
  - other [method] in `modules/teams/libraries/client.lua`
  - other [method] in `modules/chatbox/libraries/client.lua`
  - other [method] in `modules/administration/libraries/client.lua`
  - other [standard] in `modules/administration/libraries/client.lua`
  - other [method] in `modules/administration/submodules/tickets/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `PopulateConfigurationButtons`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `PopulateFactionRosterOptions`
  - other [standard] in `modules/teams/libraries/client.lua`
- `PostBotSetup`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PostDoorDataLoad`
  - other [standard] in `modules/doors/libraries/server.lua`
- `PostDrawInventory`
  - other [standard] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `PostLoadData`
  - other [method] in `modules/doors/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PostPlayerInitialSpawn`
  - other [method] in `modules/vendor/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PostPlayerLoadedChar`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `PostPlayerLoadout`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/spawns/libraries/server.lua`
  - other [method] in `modules/doors/libraries/server.lua`
  - other [method] in `modules/attributes/libraries/server.lua`
  - other [method] in `modules/administration/submodules/adminstick/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PostPlayerSay`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PostScaleDamage`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PreDoorDataSave`
  - other [standard] in `modules/doors/libraries/server.lua`
- `PreLiliaLoaded`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `PrePlayerInteractItem`
  - meta `item` [standard] in `core/meta/item.lua`
- `PrePlayerLoadedChar`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `PreSalaryGive`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PreScaleDamage`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ReadLogEntries`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `RemoveFilteredWord`
  - other [method] in `modules/chatbox/libraries/server.lua`
- `RemovePart`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `RemoveWarning`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `ResetCharacterPanel`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `SaveData`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [method] in `modules/doors/libraries/server.lua`
  - other [method] in `modules/chatbox/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ScoreboardClosed`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `ScoreboardOpened`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `ScoreboardRowCreated`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `ScoreboardRowRemoved`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `SendPopup`
  - other [method] in `modules/administration/submodules/tickets/commands.lua`
- `SetMainCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `SetupBagInventoryAccessRules`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `SetupBotPlayer`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `SetupPlayerModel`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - other [standard] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `SetupQuickMenu`
  - core `derma` [standard] in `core/derma/panels/quick.lua`
- `ShouldAllowScoreboardOverride`
  - other [method] in `modules/recognition/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
  - core `derma` [standard] in `core/derma/panels/voice.lua`
- `ShouldDataBeSaved`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldDeleteSavedItems`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldDrawAmmo`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `ShouldDrawCrosshair`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `ShouldDrawEntityInfo`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `ShouldDrawPlayerInfo`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `ShouldDrawWepSelect`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`
- `ShouldEntityLoad`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldEntitySave`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldMenuButtonShow`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
- `ShouldOverrideSalaryTimers`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldPlayDeathSound`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldPlayPainSound`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldRespawnScreenAppear`
  - other [standard] in `modules/spawns/libraries/client.lua`
- `ShouldSaveItem`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
- `ShouldShowCharVarInCreation`
  - other [standard] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/steps/cl_biography.lua`
- `ShouldShowClassOnScoreboard`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `ShouldShowFactionOnScoreboard`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `ShouldShowPlayerOnScoreboard`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `ShouldShowQuickMenu`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `ShouldSpawnClientRagdoll`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ShouldUseMapSpawns`
  - other [standard] in `modules/spawns/libraries/server.lua`
- `ShowPlayerOptions`
  - other [method] in `modules/administration/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `StorageEntityRemoved`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua`
- `StorageInventorySet`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua`
- `StorageOpen`
  - other [method] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua`
- `StorageRestored`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
- `StorageUnlockPrompt`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua`
- `StoreSpawns`
  - other [method] in `modules/spawns/libraries/server.lua`
- `SyncCharList`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `SyncFilteredWords`
  - other [method] in `modules/chatbox/libraries/server.lua`
- `ThirdPersonToggled`
  - other [standard] in `modules/mainmenu/module.lua`
- `TicketSystemClaim`
  - other [standard] in `modules/administration/submodules/tickets/netcalls/server.lua`
- `TicketSystemClose`
  - other [standard] in `modules/administration/submodules/tickets/netcalls/server.lua`
- `TooltipInitialize`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/dproperties.lua`
- `TooltipLayout`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/dproperties.lua`
- `TooltipPaint`
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/panels/dproperties.lua`
- `TrackFactionTransfer`
  - other [standard] in `modules/teams/pim.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `TrackOfflineFactionTransfer`
  - other [method] in `modules/teams/libraries/server.lua`
- `UpdateEntityPersistence`
  - other [standard] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/netcalls/server.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/init.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/shared.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `VendorClassUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorEdited`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorExited`
  - other [method] in `modules/vendor/libraries/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorFactionBuyScaleUpdated`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorFactionSellScaleUpdated`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorFactionUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorItemBuyPriceUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
- `VendorItemMaxStockUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorItemModeUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorItemSellPriceUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
- `VendorItemStockUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorMessagesUpdated`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorOpened`
  - other [method] in `modules/vendor/libraries/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorPropertyUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorSynchronized`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorTradeEvent`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/netcalls/server.lua`
- `VoiceToggled`
  - core `derma` [method] in `core/derma/panels/voice.lua`
- `WarningIssued`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `WarningRemoved`
  - other [standard] in `modules/administration/submodules/warnings/netcalls/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `WeaponCycleSound`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`
- `WeaponSelectSound`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `SendPopup(client, message)`

### Unused Hook Documentation:
These hooks are documented but not registered in code:
- `CharListExtraDetails()`

## Localization Analysis

- **Unique Keys:** 3929
- **Undefined Calls:** 1
- **Argument Mismatch:** 0

### Undefined Calls

- **value** in core\netcalls\client.lua:1618
  - Context: label:SetText(L("value") or "Value")

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `Privilege.Category` | Unlocalized string | `Player Info` | core\libraries\commands.lua | 1831 |
| `Privilege.Category` | Unlocalized string | `Player Info` | core\libraries\commands.lua | 1865 |
| `Privilege.Category` | Missing key | `Teleportation` | core\libraries\commands.lua | 1949 |
| `Privilege.Category` | Missing key | `Teleportation` | core\libraries\commands.lua | 1996 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\commands.lua | 2031 |
| `Privilege.Category` | Unlocalized string | `Player Punishment` | core\libraries\commands.lua | 2120 |
| `Privilege.Category` | Unlocalized string | `Player Punishment` | core\libraries\commands.lua | 2142 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2159 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2236 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2302 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2496 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2513 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2530 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2547 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\commands.lua | 2593 |
| `Privilege.Category` | Missing key | `Observation` | core\libraries\commands.lua | 2886 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\commands.lua | 3179 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\commands.lua | 3356 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\commands.lua | 3551 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\commands.lua | 3577 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\commands.lua | 3644 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\commands.lua | 3697 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 3789 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\commands.lua | 3868 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\commands.lua | 3956 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\commands.lua | 4013 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\commands.lua | 4051 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\commands.lua | 4085 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\commands.lua | 4117 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\commands.lua | 4189 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\commands.lua | 4356 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4437 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4473 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4503 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4528 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4553 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4579 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 4616 |
| `Privilege.Category` | Missing key | `Attributes` | core\libraries\commands.lua | 5046 |
| `Privilege.Category` | Missing key | `Attributes` | core\libraries\commands.lua | 5089 |
| `Privilege.Category` | Missing key | `Attributes` | core\libraries\commands.lua | 5369 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\commands.lua | 5411 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\commands.lua | 5438 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\commands.lua | 7162 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\commands.lua | 7201 |
| `Privilege.Category` | Missing key | `Tickets` | core\libraries\commands.lua | 7329 |
| `Privilege.Category` | Missing key | `Warnings` | core\libraries\commands.lua | 7541 |
| `Privilege.Category` | Missing key | `Warnings` | core\libraries\commands.lua | 7621 |
| `Privilege.Category` | Missing key | `Recognition` | core\libraries\commands.lua | 7779 |
| `Privilege.Category` | Missing key | `Recognition` | core\libraries\commands.lua | 7800 |
| `Privilege.Category` | Missing key | `Recognition` | core\libraries\commands.lua | 7821 |
| `Privilege.Category` | Missing key | `NPCs` | core\libraries\commands.lua | 7893 |
| `Privilege.Category` | Missing key | `Vendors` | core\libraries\commands.lua | 8045 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\commands.lua | 8270 |
| `Privilege.Name` | Unlocalized string | `Randomize Door Info` | core\libraries\commands.lua | 6035 |
| `Privilege.Name` | Unlocalized string | `View Net Logs` | modules\administration\module.lua | 78 |
| `data.category` | Unlocalized string | `Color for category elements and tabs.` | core\derma\panels\f1menu.lua | 2355 |
| `data.category` | Missing key | `__all` | core\libraries\item.lua | 1013 |
| `data.category` | Missing key | `inventory` | core\libraries\keybind.lua | 1141 |
| `data.category` | Missing key | `Camera` | core\libraries\keybind.lua | 1283 |
| `data.category` | Missing key | `menu` | core\libraries\keybind.lua | 2047 |
| `data.category` | Unlocalized string | `.. lia.db.convertDataType(category),` | modules\administration\submodules\logs\libraries\server.lua | 16 |
| `data.desc` | Unlocalized string | `Remove all ragdoll entities from the map except active player ragdolls.` | core\libraries\commands.lua | 3425 |
| `data.desc` | Unlocalized string | `Apply randomized information to the door you are looking at.` | core\libraries\commands.lua | 6032 |
| `data.desc` | Unlocalized string | `A medium-sized backpack with enough space for extra supplies.` | core\libraries\item.lua | 1625 |
| `data.desc` | Unlocalized string | `Open the standalone quick inventory.` | core\libraries\keybind.lua | 1140 |
| `interaction.actionText` | Unlocalized string | `LMB  SELECT` | core\derma\panels\radialpanel.lua | 276 |
| `interaction.actionText` | Unlocalized string | `LMB  RETURN` | core\derma\panels\radialpanel.lua | 280 |
| `interaction.actionText` | Unlocalized string | `LMB  CLOSE` | core\derma\panels\radialpanel.lua | 282 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 203
- **Used Net Messages:** 203
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
- **Registered Panels:** 54
- **Referenced Panels:** 84
- **Module Panels Outside derma:** 0
- **Registered But Unused:** 1

### Module Panels Outside derma

None

### Registered But Unused Panels

| Panel | Module | Location |
|---|---|---|
| `liaHorizontalScroll` | `framework` | `core/derma/panels/horizontal_scroll.lua:70` |

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 2
- **UI / Derma Code Outside derma:** 12

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `mainmenu` | `modules/mainmenu/module.lua:63` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |
| `mainmenu` | `modules/mainmenu/module.lua:106` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\mainmenu\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `administration` | `modules/administration/libraries/client.lua:27` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `administration` | `modules/administration/libraries/shared.lua:381` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `administration` | `modules/administration/netcalls/client.lua:99` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\derma` | Module UI-heavy code is outside the derma folder |
| `adminstick` | `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua:240` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\derma` | Module UI-heavy code is outside the derma folder |
| `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:471` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\derma` | Module UI-heavy code is outside the derma folder |
| `chatbox` | `modules/chatbox/libraries/client.lua:18` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\chatbox\derma` | Module UI-heavy code is outside the derma folder |
| `gridinv` | `modules/inventory/types/gridinv/libraries/client.lua:94` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\inventory\types\gridinv\derma` | Module UI-heavy code is outside the derma folder |
| `logs` | `modules/administration/submodules/logs/libraries/client.lua:71` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\logs\derma` | Module UI-heavy code is outside the derma folder |
| `storage` | `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\inventory\types\gridinv\submodules\storage\derma` | Module UI-heavy code is outside the derma folder |
| `teams` | `modules/teams/libraries/client.lua:226` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\teams\derma` | Module UI-heavy code is outside the derma folder |
| `tickets` | `modules/administration/submodules/tickets/libraries/client.lua:41` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\tickets\derma` | Module UI-heavy code is outside the derma folder |
| `weightinv` | `modules/inventory/types/weightinv/libraries/client.lua:50` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\inventory\types\weightinv\derma` | Module UI-heavy code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---
