# Lilia Framework Audit

- **Scanned source:** `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode`
- **External module roots scanned:** 0
- **Documentation reference:** `D:\GMOD\Server\garrysmod\gamemodes\lilia\documentation`

## Executive Summary

### Function Documentation
- **Total Functions:** 701
- **Documented:** 696 (99.3%)
- **Missing Functions:** 5 unique (5 total occurrences)
  - **Library Functions:** 4
  - **Hook Functions:** 1
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 45 (used but undocumented)
- **Unused Hooks:** 5 (documented but unused)
- **Total Documented Hooks:** 438
- **Total Registered Hooks:** 474

### Localization Analysis
- **Undefined Calls:** 3 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 1

### Net Message Analysis
- **Defined Net Messages:** 250
- **Used Net Messages:** 250
- **Defined But Unused:** 1
- **Used But Undefined:** 1

### Config Analysis
- **Undefined lia.config.get Keys:** 0

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 44
- **Missing Documentation:** 5 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 4 functions

#### lia.admin
Count: 2 functions

- `lia.admin.canUseDebugProperties(client)`
- `lia.admin.clearPrivilegeCategoryCache()`

#### lia.net
Count: 1 functions

- `lia.net.profiler.recordSessionEntry(direction, messageName, rawSize, sender, receiver)`

#### lia.util
Count: 1 functions

- `lia.util.drawEntInfoBox(ent, data, alphaOverride)`

### Missing Hook Functions
Total: 1 functions

- `playerMeta:hasStaffCharacterPermission(privilegeName)`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 45 (used in code but not documented)
- **Documented Hooks:** 438
- **Registered Hooks:** 474
- **Method Hooks:** 46 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 428 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 5 (documented but not registered)

### Method-Style Hooks:
These hooks are defined as `function GM:HookName(...)`, `function MODULE:HookName(...)`, or `function SCHEMA:HookName(...)`.
- `AddFilteredWord(word)`
- `BuildFactionMemberDetailsPayload(client, factionUniqueID, charID, callback)`
- `BuildFactionMembersPayload(client, factionUniqueID, callback)`
- `BuildPlayerEntityData(serverEntities)`
- `CanAccessFactionRoster(client, factionUniqueID)`
- `CanEditFactionNotes(client, factionUniqueID)`
- `ChooseCharacter(id)`
- `ClearPlayerEntityWaypoint(key)`
- `CreateCharacter(data)`
- `CreateLogsUI(panel, categories)`
- `CreateTicketFrame(requester, message, claimed)`
- `DeleteCharacter(id)`
- `EnsureFactionTracking(character, actor, reason)`
- `FetchSpawns()`
- `FlushFactionPlaytime(character, now)`
- `FocusPlayerEntity(data)`
- `GetAllCaseClaims()`
- `GetClientsidePlayerEntities()`
- `GetDoorInfo(entity, doorData, doorInfo)`
- `GetFilteredWords()`
- `GetStaffCasesPermissions(client)`
- `GetWarnings(charID)`
- `HandleStaffCasesPayload(kind, data)`
- `LoadMainCharacter()`
- `OpenCharacterMenu()`
- `OpenNetLogs(panel)`
- `OpenNetProfiler(panel)`
- `OpenPlayerEntities(panel)`
- `OpenStaffCases(panel)`
- `PlayerLoadedCharacter(client)`
- `ReadLogEntries(category, page)`
- `ReconcilePlayerEntityWaypoints(entities)`
- `RemoveFilteredWord(word)`
- `RemoveWarning(charID, index)`
- `RunPlayerEntityAction(data, action)`
- `SendFactionMemberDetails(client, factionUniqueID, charID)`
- `SendFactionMembers(client, factionUniqueID)`
- `SetMainCharacter(charID)`
- `SetPlayerEntityWaypoint(data)`
- `StopPlayerEntityFocus()`
- `StoreSpawns(spawns)`
- `SyncFilteredWords(targets)`
- `UpdateNPCRelations(client)`
- `populateEntityTabPanel(entPanel)`
- `requestEntityTabData(force)`
- `startFullCharListRequest(panel)`

### Library Hook Registration Locations:
These entries show hooks registered from framework libraries.
- `AddReservedKeybinds`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `AddWarning`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `AdjustPACPartData`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `AdminPrivilegesUpdated`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `AttachPart`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `CanCharBeTransfered`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `CanPersistEntity`
  - library `compatibility` [standard] in `core/libraries/compatibility/permaprops/core.lua`
- `CanPlayerJoinClass`
  - library `core` [standard] in `core/libraries/core/classes/core.lua`
- `CanPlayerModifyConfig`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `CanPlayerUseCommand`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `CanTakeEntity`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `CharCleanUp`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `CharListExtraDetails`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `CharRestored`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `ChatParsed`
  - library `core` [standard] in `core/libraries/core/chatbox/core.lua`
- `CollectDoorDataFields`
  - library `core` [standard] in `core/libraries/core/doors/core.lua`
- `CommandAdded`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `CommandRan`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `ConfigChanged`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `CreateDefaultInventory`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `CreateInformationButtons`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
  - library `core` [standard] in `core/libraries/core/flags/core.lua`
  - library `core` [standard] in `core/libraries/core/workshop/core.lua`
- `CreateInventoryPanel`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `CreateMenuButtons`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `CreateSalaryTimers`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `DatabaseConnected`
  - library `core` [standard] in `core/libraries/core/loader.lua`
  - library `core` [method] in `core/libraries/core/database/core.lua`
- `DermaSkinChanged`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `DiscordRelayed`
  - library `core` [standard] in `core/libraries/core/loader.lua`
- `DiscordRelaySend`
  - library `core` [standard] in `core/libraries/core/loader.lua`
- `DiscordRelayUnavailable`
  - library `core` [standard] in `core/libraries/core/loader.lua`
- `DoModuleIncludes`
  - library `core` [standard] in `core/libraries/core/modularity/core.lua`
- `DoorEnabledToggled`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `DoorHiddenToggled`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `DoorOwnableToggled`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `DoorPriceSet`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `DoorTitleSet`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `DrawPlayerRagdoll`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `ForceRecognizeRange`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `FreelookToggled`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `GetAdjustedPartData`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `GetAttributeMax`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `GetAttributeStartingMax`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetDefaultCharDesc`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetDefaultCharName`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetDisplayedName`
  - library `core` [standard] in `core/libraries/core/chatbox/core.lua`
- `GetMaxStartingAttributePoints`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetPlayTime`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
- `GetUsergroupIcon`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `GetWeaponName`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `HandleItemTransferRequest`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `InitializedConfig`
  - library `core` [standard] in `core/libraries/core/color/core.lua`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `InitializedItems`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `InitializedKeybinds`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `InitializedModules`
  - library `core` [standard] in `core/libraries/core/currency/core.lua`
  - library `core` [standard] in `core/libraries/core/darkrp/core.lua`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
  - library `core` [standard] in `core/libraries/core/modularity/core.lua`
  - library `core` [standard] in `core/libraries/core/performance/core.lua`
  - library `core` [standard] in `core/libraries/core/workshop/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/arccw/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/simfphys/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sitanywhere/core.lua`
- `InitializedOptions`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `InitializedSchema`
  - library `core` [standard] in `core/libraries/core/modularity/core.lua`
- `InteractionMenuClosed`
  - library `core` [standard] in `core/libraries/core/derma/core.lua`
- `InteractionMenuOpened`
  - library `core` [standard] in `core/libraries/core/derma/core.lua`
- `InventoryClosed`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `InventoryOpened`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `IsSuitableForTrunk`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/simfphys/core.lua`
- `ItemDefaultFunctions`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `LiliaLoaded`
  - library `core` [standard] in `core/libraries/core/loader.lua`
- `LiliaNoticeOverride`
  - library `core` [standard] in `core/libraries/core/notice/core.lua`
- `LoadData`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
- `ModifyCharacterModel`
  - library `core` [standard] in `core/libraries/core/view/core.lua`
- `NetVarChanged`
  - library `core` [standard] in `core/libraries/core/net/core.lua`
- `OnAdminSystemLoaded`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
- `OnCharDelete`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `OnCharGetup`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `OnCharVarChanged`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `OnConfigUpdated`
  - library `core` [standard] in `core/libraries/core/color/core.lua`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/currency/core.lua`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `OnCreateDualInventoryPanels`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `OnDatabaseLoaded`
  - library `core` [standard] in `core/libraries/core/database/core.lua`
- `OnDataSet`
  - library `core` [standard] in `core/libraries/core/data/core.lua`
- `OnItemCreated`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnItemOverridden`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnItemRegistered`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnLoadTables`
  - library `core` [standard] in `core/libraries/core/database/core.lua`
- `OnNPCTypeSet`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
- `OnOOCMessageSent`
  - library `core` [standard] in `core/libraries/core/chatbox/core.lua`
- `OnPAC3PartTransfered`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `OnPlayerDroppedItem`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnPlayerInteractItem`
  - library `compatibility` [standard] in `core/libraries/compatibility/vmanip/core.lua`
- `OnPlayerObserve`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `OnPlayerPurchaseDoor`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `OnPlayerRotateItem`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnPlayerTakeItem`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnPrivilegeRegistered`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
- `OnPrivilegeUnregistered`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
- `OnServerLog`
  - library `core` [standard] in `core/libraries/core/logger/core.lua`
- `OnSetUsergroup`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sadmin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/serverguard/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/ulx/core.lua`
- `OnThemeChanged`
  - library `core` [standard] in `core/libraries/core/color/core.lua`
- `OnTransferred`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `OnUsergroupCreated`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `OnUsergroupPermissionsChanged`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `OnUsergroupRemoved`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `OnUsergroupRenamed`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `OnVoiceTypeChanged`
  - library `core` [standard] in `core/libraries/core/playerinteract/core.lua`
- `OptionAdded`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `OptionChanged`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `OptionReceived`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `OverrideFactionDesc`
  - library `core` [standard] in `core/libraries/core/factions/core.lua`
- `OverrideFactionModelCustomization`
  - library `core` [standard] in `core/libraries/core/factions/core.lua`
- `OverrideFactionModels`
  - library `core` [standard] in `core/libraries/core/factions/core.lua`
- `OverrideFactionName`
  - library `core` [standard] in `core/libraries/core/factions/core.lua`
- `OverrideSpawnTime`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `PlayerBodyGroupChanged`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `PlayerGagged`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PlayerLoadedChar`
  - library `compatibility` [standard] in `core/libraries/compatibility/prone/core.lua`
- `PlayerMessageSend`
  - library `core` [standard] in `core/libraries/core/chatbox/core.lua`
- `PlayerMuted`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PlayerUngagged`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PlayerUnmuted`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PopulateAdminTabs`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PopulateConfigurationButtons`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `PostLoadData`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `PostLoadFonts`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `PostPlayerInitialSpawn`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `PostPlayerLoadedChar`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `PreCharDelete`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `PreFreelookToggle`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `PreLiliaLoaded`
  - library `core` [standard] in `core/libraries/core/loader.lua`
- `RefreshFonts`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `RemovePart`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `RunAdminSystemCommand`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sadmin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/serverguard/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/ulx/core.lua`
- `SaveData`
  - library `core` [standard] in `core/libraries/core/data/core.lua`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
- `SetupDatabase`
  - library `core` [standard] in `core/libraries/core/loader.lua`
  - library `core` [method] in `core/libraries/core/database/core.lua`
- `SetupPACDataFromItems`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `SetupPlayerModel`
  - library `core` [standard] in `core/libraries/core/view/core.lua`
- `SetupQuickMenu`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `ShouldBarDraw`
  - library `core` [standard] in `core/libraries/core/bars/core.lua`
- `ShouldDisableThirdperson`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `ShouldHideBars`
  - library `core` [standard] in `core/libraries/core/bars/core.lua`
- `simfphys.RegisterEquipment`
  - library `compatibility` [standard] in `core/libraries/compatibility/simfphys/core.lua`
- `SyncCharList`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `ThirdPersonToggled`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `TrackFactionTransfer`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `TryViewModel`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `UpdateEntityPersistence`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
- `VoiceToggled`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `WarningIssued`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `WebImageDownloaded`
  - library `core` [standard] in `core/libraries/core/webimage/core.lua`
- `WebSoundDownloaded`
  - library `core` [standard] in `core/libraries/core/websound/core.lua`

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
  - other [standard] in `modules/protection/libraries/server.lua`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `AdjustCreationData`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `AdjustStaminaOffset`
  - other [standard] in `modules/attributes/libraries/shared.lua`
- `AdminPrivilegesUpdated`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
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
- `BuildFactionMemberDetailsPayload`
  - other [method] in `modules/teams/libraries/server.lua`
- `BuildFactionMembersPayload`
  - other [method] in `modules/teams/libraries/server.lua`
- `BuildPlayerEntityData`
  - other [method] in `modules/administration/libraries/client.lua`
- `CanAccessFactionRoster`
  - other [method] in `modules/teams/libraries/server.lua`
- `CanCharBeTransfered`
  - other [standard] in `modules/teams/pim.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanDeleteChar`
  - other [method] in `modules/protection/libraries/client.lua`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `CanDisplayCharInfo`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `CanDrawEntityHoverInfo`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `CanEditFactionNotes`
  - other [method] in `modules/teams/libraries/server.lua`
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
  - core `netcalls` [standard] in `core/netcalls/server.lua`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
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
  - core `netcalls` [standard] in `core/netcalls/client.lua`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `CharLoaded`
  - other [standard] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/administration/netcalls/client.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
  - meta `character` [standard] in `core/meta/character.lua`
- `CharMenuClosed`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `CharMenuOpened`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
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
- `ClearPlayerEntityWaypoint`
  - other [method] in `modules/administration/libraries/client.lua`
- `ConfigureCharacterCreationSteps`
  - core `derma` [standard] in `core/derma/mainmenu/creation.lua`
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
- `DoorDataReceived`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
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
  - core `derma` [standard] in `core/derma/panels/modelpanel.lua`
- `DrawPlayerInfoBackground`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `EnsureFactionTracking`
  - other [method] in `modules/teams/libraries/server.lua`
- `F1MenuClosed`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `F1MenuOpened`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `FetchSpawns`
  - other [method] in `modules/spawns/libraries/server.lua`
- `FilterCharModels`
  - core `derma` [standard] in `core/derma/mainmenu/steps/model.lua`
- `FilterDoorInfo`
  - other [standard] in `modules/doors/libraries/client.lua`
- `FlushFactionPlaytime`
  - other [method] in `modules/teams/libraries/server.lua`
- `FocusPlayerEntity`
  - other [method] in `modules/administration/libraries/client.lua`
- `ForceRecognizeRange`
  - other [method] in `modules/recognition/libraries/server.lua`
- `GetAdminESPTarget`
  - other [standard] in `modules/administration/libraries/client.lua`
- `GetAdminStickLists`
  - other [method] in `modules/doors/libraries/client.lua`
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
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterCreationSummary`
  - core `derma` [standard] in `core/derma/mainmenu/steps/summary.lua`
- `GetCharacterDisconnectButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterDiscordButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterLoadButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterLoadMainButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterMountButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterReturnButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterStaffButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharacterWorkshopButtonTooltip`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetCharMaxStamina`
  - other [standard] in `modules/attributes/libraries/client.lua`
  - other [standard] in `modules/attributes/libraries/server.lua`
  - other [standard] in `modules/attributes/libraries/shared.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
  - meta `player` [standard] in `core/meta/player.lua`
- `GetClientsidePlayerEntities`
  - other [method] in `modules/administration/libraries/client.lua`
- `GetDamageScale`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetDefaultCharDesc`
  - other [method] in `modules/teams/libraries/shared.lua`
  - core `derma` [standard] in `core/derma/mainmenu/steps/biography.lua`
- `GetDefaultCharName`
  - other [method] in `modules/teams/libraries/shared.lua`
  - core `derma` [standard] in `core/derma/mainmenu/steps/biography.lua`
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
  - core `hooks` [method] in `core/hooks/client.lua`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `GetMaxPlayerChar`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/module.lua`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
  - core `derma` [standard] in `core/derma/mainmenu/creation.lua`
- `GetMaxStartingAttributePoints`
  - core `hooks` [method] in `core/hooks/shared.lua`
  - core `derma` [standard] in `core/derma/panels/attribs.lua`
  - core `derma` [standard] in `core/derma/mainmenu/steps/biography.lua`
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
- `GetStaffCasesPermissions`
  - other [method] in `modules/administration/libraries/client.lua`
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
- `HandleStaffCasesPayload`
  - other [method] in `modules/administration/libraries/client.lua`
- `InitializedModules`
  - other [method] in `modules/protection/libraries/server.lua`
  - other [method] in `modules/chatbox/libraries/server.lua`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
- `InitializedSchema`
  - core `hooks` [method] in `core/hooks/server.lua`
- `InitializeStorage`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/shared.lua`
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
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
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
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua`
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
  - core `derma` [standard] in `core/derma/panels/modelpanel.lua`
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
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `ModifyCharacterCreationSummary`
  - core `derma` [standard] in `core/derma/mainmenu/steps/summary.lua`
- `ModifyCharacterModel`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
  - core `derma` [standard] in `core/derma/mainmenu/creation.lua`
- `ModifyScoreboardModel`
  - core `derma` [standard] in `core/derma/panels/scoreboard.lua`
- `NetVarChanged`
  - meta `character` [standard] in `core/meta/character.lua`
  - meta `entity` [standard] in `core/meta/entity.lua`
  - meta `player` [standard] in `core/meta/player.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `OnAdminStickMenuClosed`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `OnAmmoBoxUsed`
  - entity `entities` [standard] in `entities/entities/lia_ammobox/init.lua`
- `OnCharacterCreationModelIconSet`
  - core `derma` [standard] in `core/derma/mainmenu/steps/model.lua`
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
  - core `derma` [standard] in `core/derma/panels/modelpanel.lua`
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
  - core `derma` [standard] in `core/derma/panels/panels.lua`
- `OnTicketClaimed`
  - other [standard] in `modules/administration/submodules/tickets/netcalls/server.lua`
- `OnTicketClosed`
  - other [standard] in `modules/administration/submodules/tickets/netcalls/server.lua`
- `OnTicketCreated`
  - other [standard] in `modules/administration/submodules/tickets/libraries/server.lua`
- `OnTransferred`
  - other [standard] in `modules/teams/pim.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
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
- `OpenAdminStickUI`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `OpenCharacterMenu`
  - other [method] in `modules/mainmenu/module.lua`
- `OpenCharacterMenuOverride`
  - other [standard] in `modules/mainmenu/module.lua`
- `OpenNetLogs`
  - other [method] in `modules/administration/libraries/client.lua`
- `OpenNetProfiler`
  - other [method] in `modules/administration/libraries/client.lua`
- `OpenPlayerEntities`
  - other [method] in `modules/administration/libraries/client.lua`
- `OpenStaffCases`
  - other [method] in `modules/administration/libraries/client.lua`
- `OptionAdded`
  - core `derma` [standard] in `core/derma/panels/panels.lua`
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
  - other [method] in `modules/attributes/libraries/server.lua`
  - other [method] in `modules/administration/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `PlayerLoadedCharacter`
  - other [method] in `modules/chatbox/libraries/server.lua`
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
  - other [method] in `modules/protection/libraries/client.lua`
  - other [method] in `modules/chatbox/libraries/client.lua`
  - other [method] in `modules/administration/libraries/client.lua`
  - other [standard] in `modules/administration/libraries/client.lua`
  - other [method] in `modules/administration/submodules/tickets/libraries/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `PopulateConfigurationButtons`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `populateEntityTabPanel`
  - other [method] in `modules/protection/libraries/client.lua`
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
- `ReconcilePlayerEntityWaypoints`
  - other [method] in `modules/administration/libraries/client.lua`
- `RemoveFilteredWord`
  - other [method] in `modules/chatbox/libraries/server.lua`
- `RemovePart`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
- `RemoveWarning`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `requestEntityTabData`
  - other [method] in `modules/protection/libraries/client.lua`
- `ResetCharacterPanel`
  - other [method] in `modules/mainmenu/module.lua`
  - core `netcalls` [standard] in `core/netcalls/client.lua`
  - core `derma` [standard] in `core/derma/mainmenu/creation.lua`
- `RunPlayerEntityAction`
  - other [method] in `modules/administration/libraries/client.lua`
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
- `SendFactionMemberDetails`
  - other [method] in `modules/teams/libraries/server.lua`
- `SendFactionMembers`
  - other [method] in `modules/teams/libraries/server.lua`
- `SetMainCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `SetPlayerEntityWaypoint`
  - other [method] in `modules/administration/libraries/client.lua`
- `SetupBagInventoryAccessRules`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `SetupBotPlayer`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `SetupPlayerModel`
  - other [standard] in `modules/inventory/types/weightinv/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
  - meta `character` [standard] in `core/meta/character.lua`
  - core `derma` [standard] in `core/derma/mainmenu/character.lua`
- `SetupQuickMenu`
  - core `derma` [standard] in `core/derma/panels/panels.lua`
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
  - core `derma` [standard] in `core/derma/mainmenu/creation.lua`
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
  - core `derma` [standard] in `core/derma/mainmenu/steps/biography.lua`
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
- `startFullCharListRequest`
  - other [method] in `modules/administration/libraries/client.lua`
- `StopPlayerEntityFocus`
  - other [method] in `modules/administration/libraries/client.lua`
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
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `TrackOfflineFactionTransfer`
  - other [method] in `modules/teams/libraries/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `UpdateEntityPersistence`
  - other [standard] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/netcalls/server.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/init.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/shared.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
  - core `netcalls` [standard] in `core/netcalls/server.lua`
- `UpdateNPCRelations`
  - other [method] in `modules/teams/libraries/server.lua`
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
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorItemMaxStockUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorItemModeUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
- `VendorItemSellPriceUpdated`
  - other [standard] in `modules/vendor/derma/client.lua`
  - other [standard] in `modules/vendor/netcalls/client.lua`
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
- `BuildFactionMemberDetailsPayload(client, factionUniqueID, charID, callback)`
- `BuildFactionMembersPayload(client, factionUniqueID, callback)`
- `BuildPlayerEntityData(serverEntities)`
- `CanAccessFactionRoster(client, factionUniqueID)`
- `CanEditFactionNotes(client, factionUniqueID)`
- `CanPlayerChooseWeapon(weapon)`
- `CanPlayerOpenScoreboard(arg1)`
- `ClearPlayerEntityWaypoint(key)`
- `EnsureFactionTracking(character, actor, reason)`
- `FlushFactionPlaytime(character, now)`
- `FocusPlayerEntity(data)`
- `GetClientsidePlayerEntities()`
- `GetNPCRelations(client, arg2)`
- `GetRespawnScreenCause(ply, left, baseTime, lastDeath)`
- `GetStaffCasesPermissions(client)`
- `HandleStaffCasesPayload(kind, data)`
- `ModifyScoreboardModel(arg1, ply)`
- `OpenNetLogs(panel)`
- `OpenNetProfiler(panel)`
- `OpenPlayerEntities(panel)`
- `OpenStaffCases(panel)`
- `PlayerLoadedCharacter(client)`
- `ReconcilePlayerEntityWaypoints(entities)`
- `RunPlayerEntityAction(data, action)`
- `ScoreboardClosed(self)`
- `ScoreboardOpened(self)`
- `ScoreboardRowCreated(slot, ply)`
- `ScoreboardRowRemoved(self, ply)`
- `SendFactionMemberDetails(client, factionUniqueID, charID)`
- `SendFactionMembers(client, factionUniqueID)`
- `SetPlayerEntityWaypoint(data)`
- `ShouldDrawWepSelect(client)`
- `ShouldShowClassOnScoreboard(clsData)`
- `ShouldShowFactionOnScoreboard(ply)`
- `ShouldShowPlayerOnScoreboard(ply)`
- `StopPlayerEntityFocus()`
- `TrackFactionTransfer(targetChar, oldFaction, faction, client, arg5)`
- `TrackOfflineFactionTransfer(charID, oldFactionValue, newFactionValue, actor, reason)`
- `UpdateNPCRelations(client)`
- `WeaponCycleSound()`
- `WeaponSelectSound()`
- `populateEntityTabPanel(entPanel)`
- `requestEntityTabData(force)`
- `simfphys.RegisterEquipment()`
- `startFullCharListRequest(panel)`

### Unused Hook Documentation:
These hooks are documented but not registered in code:
- `CharListColumns()`
- `ModifyVoiceIndicatorText()`
- `OnLocalizationLoaded()`
- `ShouldUseFreelook()`
- `VerifyCheats()`

## Localization Analysis

- **Unique Keys:** 3931
- **Undefined Calls:** 3
- **Argument Mismatch:** 1

### Undefined Calls

- **inventory** in core\derma\panels\f1menu.lua:84
  - Context: ["@inventory"] = Material("icon16/box.png", "smooth"),
- **logisticslogs** in core\derma\panels\f1menu.lua:85
  - Context: ["@logisticslogs"] = Material("icon16/page_white_text.png", "smooth"),
- **logisticsstorage** in core\derma\panels\f1menu.lua:86
  - Context: ["@logisticsstorage"] = Material("icon16/database.png", "smooth"),

### Argument Mismatches

- **Total Mismatches:** 1


#### core/libraries/core/commands/core.lua
- **Line 6997:** classSet(1)
  - Expected: 2 args, Provided: 1 args
  - Context: target:notifyInfoLocalized("classSet", classData.name)

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `Privilege.Category` | Unlocalized string | `Player Info` | core\libraries\core\commands\core.lua | 1818 |
| `Privilege.Category` | Unlocalized string | `Player Info` | core\libraries\core\commands\core.lua | 1852 |
| `Privilege.Category` | Missing key | `Teleportation` | core\libraries\core\commands\core.lua | 1936 |
| `Privilege.Category` | Missing key | `Teleportation` | core\libraries\core\commands\core.lua | 1983 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\core\commands\core.lua | 2018 |
| `Privilege.Category` | Unlocalized string | `Player Punishment` | core\libraries\core\commands\core.lua | 2221 |
| `Privilege.Category` | Unlocalized string | `Player Punishment` | core\libraries\core\commands\core.lua | 2243 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2260 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2337 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2403 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2597 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2614 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2631 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2648 |
| `Privilege.Category` | Unlocalized string | `Player State` | core\libraries\core\commands\core.lua | 2694 |
| `Privilege.Category` | Missing key | `Observation` | core\libraries\core\commands\core.lua | 2987 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\core\commands\core.lua | 3280 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\core\commands\core.lua | 3457 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\core\commands\core.lua | 3652 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\core\commands\core.lua | 3678 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\core\commands\core.lua | 3745 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | core\libraries\core\commands\core.lua | 3798 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 3890 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\core\commands\core.lua | 3969 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\core\commands\core.lua | 4057 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\core\commands\core.lua | 4114 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\core\commands\core.lua | 4152 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\core\commands\core.lua | 4186 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\core\commands\core.lua | 4218 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | core\libraries\core\commands\core.lua | 4290 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\core\commands\core.lua | 4457 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4538 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4574 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4604 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4629 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4654 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4680 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 4717 |
| `Privilege.Category` | Missing key | `Attributes` | core\libraries\core\commands\core.lua | 5147 |
| `Privilege.Category` | Missing key | `Attributes` | core\libraries\core\commands\core.lua | 5190 |
| `Privilege.Category` | Missing key | `Attributes` | core\libraries\core\commands\core.lua | 5470 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\core\commands\core.lua | 5512 |
| `Privilege.Category` | Missing key | `Communication` | core\libraries\core\commands\core.lua | 5539 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\core\commands\core.lua | 7263 |
| `Privilege.Category` | Missing key | `Inventory` | core\libraries\core\commands\core.lua | 7302 |
| `Privilege.Category` | Missing key | `Tickets` | core\libraries\core\commands\core.lua | 7430 |
| `Privilege.Category` | Missing key | `Warnings` | core\libraries\core\commands\core.lua | 7642 |
| `Privilege.Category` | Missing key | `Warnings` | core\libraries\core\commands\core.lua | 7965 |
| `Privilege.Category` | Missing key | `Recognition` | core\libraries\core\commands\core.lua | 8123 |
| `Privilege.Category` | Missing key | `Recognition` | core\libraries\core\commands\core.lua | 8144 |
| `Privilege.Category` | Missing key | `Recognition` | core\libraries\core\commands\core.lua | 8165 |
| `Privilege.Category` | Missing key | `NPCs` | core\libraries\core\commands\core.lua | 8237 |
| `Privilege.Category` | Missing key | `Vendors` | core\libraries\core\commands\core.lua | 8384 |
| `Privilege.Category` | Unlocalized string | `Character Info` | core\libraries\core\commands\core.lua | 8609 |
| `Privilege.Name` | Unlocalized string | `Randomize Door Info` | core\libraries\core\commands\core.lua | 6136 |
| `Privilege.Name` | Unlocalized string | `View Net Logs` | modules\administration\module.lua | 64 |
| `data.category` | Unlocalized string | `Color for category elements and tabs.` | core\derma\panels\f1menu.lua | 2419 |
| `data.category` | Missing key | `Camera` | core\libraries\core\camera\core.lua | 539 |
| `data.category` | Missing key | `__all` | core\libraries\core\item\core.lua | 970 |
| `data.category` | Unlocalized string | `.. lia.db.convertDataType(category),` | modules\administration\submodules\logs\libraries\server.lua | 16 |
| `data.desc` | Unlocalized string | `A searchable text row used to test the sheet layout.` | core\derma\panels\panel_tester.lua | 267 |
| `data.desc` | Unlocalized string | `A smaller row variant.` | core\derma\panels\panel_tester.lua | 273 |
| `data.desc` | Unlocalized string | `Subsheet content` | core\derma\panels\panel_tester.lua | 283 |
| `data.desc` | Unlocalized string | `Remove all ragdoll entities from the map except active player ragdolls.` | core\libraries\core\commands\core.lua | 3526 |
| `data.desc` | Unlocalized string | `Apply randomized information to the door you are looking at.` | core\libraries\core\commands\core.lua | 6133 |
| `data.desc` | Unlocalized string | `Open a browser for previewing shared Lilia panels.` | core\libraries\core\commands\core.lua | 7945 |
| `data.desc` | Unlocalized string | `A medium-sized backpack with enough space for extra supplies.` | core\libraries\core\item\core.lua | 1591 |

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
- **Defined Net Messages:** 250
- **Used Net Messages:** 250
- **Defined But Unused:** 1
- **Used But Undefined:** 1

### Used But Undefined

- `liaRequestAllPks`
  - Used at: net.Receive at modules/administration/netcalls/server.lua:905

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 1

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

- `liaRequestAllPks` in module `administration`
  - Reason: Used only by module "administration" and not defined anywhere
  - Usage sites: net.Receive at modules/administration/netcalls/server.lua:905

### Direction / Flow Issues

Total suspicious patterns: **35**

- `liaAdminSetCharProperty`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:624
- `liaButtonRequestCancel`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:861
- `liaCheckHack`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:273
- `liaDoorData`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:1416
- `liaFullCharList`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/administration/libraries/client.lua:4924
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
  - Receiver sites: core/netcalls/client.lua:1588
- `liaKickCharacter`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:196
- `liaNetMessage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client, server
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:1226; core/netcalls/server.lua:1108
- `liaNPCWeaponChange`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:642
- `liaPksCount`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/netcalls/server.lua:919
  - Receiver sites: None
- `liaPopupQuestionRequestCancel`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:846
- `liaProvideServerPassword`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: core/netcalls/client.lua:365
- `liaRequestActiveTickets`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/tickets/netcalls/server.lua:89
- `liaRequestAllFlags`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:1114
- `liaRequestAllPks`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:905
- `liaRequestAllWarnings`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/netcalls/server.lua:43
- `liaRequestFullCharList`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:1099
- `liaRequestNetProfilerSnapshot`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:547
- `liaRequestPksCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:915
- `liaRequestPlayers`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:1314
- `liaRequestPlayerWarnings`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/netcalls/server.lua:63
- `liaRequestStaffSummary`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/netcalls/server.lua:1308
- `liaRequestTicketsCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/tickets/netcalls/server.lua:111
- `liaRequestWarningsCount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: modules/administration/submodules/warnings/netcalls/server.lua:53
- `liaRunInteraction`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: core/netcalls/server.lua:910
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
  - Sender sites: modules/administration/submodules/tickets/netcalls/server.lua:118
  - Receiver sites: None
- `liaTrunkInitStorage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: shared
  - Sender sites: None
  - Receiver sites: modules/inventory/types/gridinv/submodules/storage/netcalls/shared.lua:1
- `liaVendorBuyPrice`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/netcalls/client.lua:62
- `liaVendorFaction`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/netcalls/client.lua:57
- `liaVendorSellPrice`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: modules/vendor/netcalls/client.lua:73
- `liaWarningsCount`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: modules/administration/submodules/warnings/netcalls/server.lua:57
  - Receiver sites: None

---

## Font Analysis

### Used But Not Registered Fonts

- `LiliaFont.32`
- `LiliaFont.72`

### Registered Fonts

- `HUDFont`
- `LiliaFont`
- `LiliaFont.12`
- `LiliaFont.12b`
- `LiliaFont.12i`
- `LiliaFont.14`
- `LiliaFont.14b`
- `LiliaFont.14i`
- `LiliaFont.15`
- `LiliaFont.15b`
- `LiliaFont.15i`
- `LiliaFont.16`
- `LiliaFont.16b`
- `LiliaFont.16i`
- `LiliaFont.17`
- `LiliaFont.17b`
- `LiliaFont.17i`
- `LiliaFont.18`
- `LiliaFont.18b`
- `LiliaFont.18i`
- `LiliaFont.20`
- `LiliaFont.20b`
- `LiliaFont.20i`
- `LiliaFont.22`
- `LiliaFont.22b`
- `LiliaFont.22i`
- `LiliaFont.23`
- `LiliaFont.23b`
- `LiliaFont.23i`
- `LiliaFont.24`
- `LiliaFont.24b`
- `LiliaFont.24i`
- `LiliaFont.25`
- `LiliaFont.25b`
- `LiliaFont.25i`
- `LiliaFont.26`
- `LiliaFont.26b`
- `LiliaFont.26i`
- `LiliaFont.28`
- `LiliaFont.28b`
- `LiliaFont.28i`
- `LiliaFont.30`
- `LiliaFont.30b`
- `LiliaFont.30i`
- `LiliaFont.34`
- `LiliaFont.34b`
- `LiliaFont.34i`
- `LiliaFont.36`
- `LiliaFont.36b`
- `LiliaFont.36i`
- `LiliaFont.40`
- `LiliaFont.40b`
- `LiliaFont.40i`
- `LiliaFont.48`
- `LiliaFont.48b`
- `LiliaFont.48i`
- `LiliaHUDFont`
- `liaBigFont`
- `liaHugeFont`
- `liaMediumFont`
- `liaMiniFont`
- `liaSmallFont`
- `liaTinyFont`

## Derma Panel Analysis

### Summary
- **Registered Panels:** 61
- **Referenced Panels:** 94
- **Module Panels Outside derma:** 2
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `liaAdminStickActionCollector` | `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:1516` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\derma` |
| `liaAdminStickPanel` | `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:2586` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 6
- **UI / Derma Code Outside derma:** 2

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `administration` | `modules/administration/libraries/client.lua:4668` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:5427` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `administration` | `modules/administration/libraries/client.lua:5446` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\netcalls` | Module net handler is outside the netcalls folder |
| `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:2768` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\netcalls` | Module net handler is outside the netcalls folder |
| `adminstick` | `modules/administration/submodules/adminstick/libraries/server.lua:35` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\netcalls` | Module net handler is outside the netcalls folder |
| `protection` | `modules/protection/libraries/server.lua:20` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\protection\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:1516` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\derma` | Module Derma code is outside the derma folder |
| `adminstick` | `modules/administration/submodules/adminstick/libraries/client.lua:2586` | `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode\modules\administration\submodules\adminstick\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

## Additional Static Audits

- **Commands:** 5 findings
- **Entities:** 0 findings
- **Timers:** 14 findings
- **Performance:** 67 findings
- **Duplicate language keys:** 0
- **Duplicate table keys:** 0
- **Privilege modules analyzed:** 18
