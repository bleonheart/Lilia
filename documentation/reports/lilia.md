## Executive Summary

### Function Documentation
- **Total Functions:** 644
- **Documented:** 591 (91.8%)
- **Missing Functions:** 53 unique (53 total occurrences)
  - **Library Functions:** 52
  - **Hook Functions:** 1
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 6 (used but undocumented)
- **Unused Hooks:** 2 (documented but unused)
- **Total Documented Hooks:** 450
- **Total Registered Hooks:** 451

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 203
- **Used Net Messages:** 205
- **Defined But Unused:** 0
- **Used But Undefined:** 2

### Config Analysis
- **Undefined lia.config.get Keys:** 0

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 54
- **Missing Documentation:** 53 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 10 functions

These functions are unused by Lilia itself but referenced by the sibling `lilia_rp` gamemode:

- `lia.class.register` — defined in `core\libraries\core\classes\core.lua:34`; used at `modules\done\computers\module.lua:82`; `modules\done\computers\module.lua:90`; `modules\done\computers\module.lua:98`; `modules\done\computers\module.lua:106`; `modules\done\computers\module.lua:114`
- `lia.data.delete` — defined in `core\libraries\core\data\core.lua:364`; used at `modules\done\bonemerge\sh_config.lua:84`; `modules\done\bonemerge\sh_config.lua:98`; `modules\done\logisticspoints\libraries\server.lua:65`
- `lia.db.createTable` — defined in `core\libraries\core\database\core.lua:432`; used at `modules\done\banking\libraries\server.lua:758`; `modules\done\banking\libraries\server.lua:2233`; `modules\done\chess\chess\sv_database.lua:4`; `modules\done\chess\chess\sv_database.lua:135`; `modules\done\marketplace\libraries\server.lua:7`
- `lia.db.exists` — defined in `core\libraries\core\database\core.lua:263`; used at `modules\done\banking\libraries\server.lua:1048`
- `lia.db.selectWithCondition` — defined in `core\libraries\core\database\core.lua:235`; used at `modules\done\banking\entities\entities\lia_atm\init.lua:25`; `modules\done\banking\libraries\server.lua:30`; `modules\done\banking\libraries\server.lua:58`; `modules\done\banking\libraries\server.lua:96`; `modules\done\banking\libraries\server.lua:194`
- `lia.faction.getAll` — defined in `core\libraries\core\factions\core.lua:150`; used at `modules\done\factionrelationships\libraries\shared.lua:100`
- `lia.item.getItemByID` — defined in `core\libraries\core\item\core.lua:179`; used at `modules\done\propbasedbuilding\libraries\server.lua:137`
- `lia.item.newInv` — defined in `core\libraries\core\item\core.lua:379`; used at `modules\done\corpselooting\libraries\sv_hooks.lua:41`; `modules\done\corpselooting\libraries\sv_hooks.lua:42`
- `lia.item.overrideItem` — defined in `core\libraries\core\item\core.lua:325`; used at `modules\done\policesuite\libraries\shared.lua:222`
- `lia.util.findPlayerItemsByClass` — defined in `core\libraries\core\util\core.lua:131`; used at `modules\done\drugs\libraries\server.lua:8`

### Missing Library Functions
Total: 52 functions

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

#### lia.db
Count: 39 functions

- `lia.db.addDatabaseFields(callback)`
- `lia.db.bulkInsert(dbTable, rows)`
- `lia.db.bulkUpsert(dbTable, rows)`
- `lia.db.connect(callback, reconnect, failureCallback)`
- `lia.db.convertDataType(value, noEscape)`
- `lia.db.count(dbTable, condition)`
- `lia.db.createColumn(dbName, columnName, columnType, defaultValue)`
- `lia.db.createSnapshot(dbName)`
- `lia.db.createTable(dbName, primaryKey, schema)`
- `lia.db.delete(dbTable, condition)`
- `lia.db.ensureIndexes(callback)`
- `lia.db.escape(value)`
- `lia.db.escapeIdentifier(identifier)`
- `lia.db.exists(dbTable, condition)`
- `lia.db.fieldExists(name, field)`
- `lia.db.fixCharacters()`
- `lia.db.getCharacterTable(callback)`
- `lia.db.getColumns(name)`
- `lia.db.getTables()`
- `lia.db.indexExists(name, indexName)`
- `lia.db.insertOrIgnore(value, dbTable)`
- `lia.db.insertTable(value, callback, dbTable)`
- `lia.db.loadSnapshot(fileName)`
- `lia.db.loadTables(callback)`
- `lia.db.query(statement, callback, errorCallback)`
- `lia.db.removeColumn(dbName, columnName)`
- `lia.db.removeTable(dbName)`
- `lia.db.select(fields, dbTable, condition, limit)`
- `lia.db.selectOne(fields, dbTable, condition)`
- `lia.db.selectWithCondition(fields, dbTable, conditions, limit, orderBy)`
- `lia.db.tableExists(name)`
- `lia.db.transaction(statements)`
- `lia.db.updateTable(value, callback, dbTable, condition)`
- `lia.db.upsert(value, dbTable)`
- `lia.db.waitForTablesToLoad()`
- `lia.db.wipeBans()`
- `lia.db.wipeCharacters()`
- `lia.db.wipeLogs()`
- `lia.db.wipeTables(callback)`

#### lia.derma
Count: 2 functions

- `lia.derma.requestBinaryNotice(question, option1, option2, manualDismiss, callback)`
- `lia.derma.requestNPCSelection(title, description, options, callback)`

#### lia.loader
Count: 1 functions

- `lia.loader.includeCoreLibrary(entry)`

#### lia.net
Count: 1 functions

- `lia.net.profiler.recordSessionEntry(direction, messageName, rawSize, sender, receiver)`

#### lia.player
Count: 1 functions

- `lia.player.registerWaypointStop(player, waypointID, onReach)`

#### lia.webimage
Count: 1 functions

- `lia.webimage.getPath(n)`

### Missing Hook Functions
Total: 1 functions

- `playerMeta:hasStaffCharacterPermission(privilegeName)`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 6 (used in code but not documented)
- **Documented Hooks:** 450
- **Registered Hooks:** 451
- **Method Hooks:** 21 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 430 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 2 (documented but not registered)

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
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `AdjustCreationData`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `AdjustPACPartData`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `AdminPrivilegesUpdated`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `AttachPart`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `CanDeleteChar`
  - library `core` [method] in `core/libraries/core/protection/core.lua`
- `CanPersistEntity`
  - library `compatibility` [standard] in `core/libraries/compatibility/permaprops/core.lua`
- `CanPlayerAccessDoor`
  - library `core` [standard] in `core/libraries/core/entity/meta.lua`
- `CanPlayerCreateChar`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `CanPlayerInteractItem`
  - library `core` [standard] in `core/libraries/core/item/meta.lua`
- `CanPlayerJoinClass`
  - library `core` [standard] in `core/libraries/core/classes/core.lua`
- `CanPlayerModifyConfig`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/config/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `CanPlayerRespawn`
  - library `core` [standard] in `core/libraries/core/player/netcalls.lua`
- `CanPlayerSwitchChar`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
  - library `core` [method] in `core/libraries/core/protection/core.lua`
- `CanPlayerUseChar`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `CanPlayerUseCommand`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `CanRunItemAction`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `CanTakeEntity`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `CharCleanUp`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `CharDeleted`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `CharHasFlags`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
- `CharListLoaded`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `CharListUpdated`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `CharLoaded`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `CharPostSave`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `CharPreSave`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
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
  - library `core` [standard] in `core/libraries/core/config/netcalls.lua`
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
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `CreateSalaryTimers`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `DatabaseConnected`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
  - library `core` [method] in `core/libraries/core/database/core.lua`
- `DatabaseConnectionFailed`
  - library `thirdparty` [standard] in `core/libraries/thirdparty/sv_mysql.lua`
- `DatabaseDisconnected`
  - library `thirdparty` [standard] in `core/libraries/thirdparty/sv_mysql.lua`
- `DatabaseSchemaFailed`
  - library `core` [standard] in `core/libraries/core/database/core.lua`
- `DermaSkinChanged`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
- `DoModuleIncludes`
  - library `core` [standard] in `core/libraries/core/modularity/core.lua`
- `DrawPlayerRagdoll`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `FreelookToggled`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `GetAdjustedPartData`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `GetAttributeMax`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `GetAttributeStartingMax`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetCharMaxStamina`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
- `GetDefaultCharDesc`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetDefaultCharName`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetMaxStartingAttributePoints`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `GetModelGender`
  - library `core` [standard] in `core/libraries/core/entity/meta.lua`
- `GetNPCDialogOptions`
  - library `core` [standard] in `core/libraries/core/dialog/netcalls.lua`
- `GetPlayTime`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
- `GetRagdollTime`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
- `GetUsergroupIcon`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `GetWeaponName`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
  - library `core` [standard] in `core/libraries/core/item/netcalls.lua`
- `HandleItemTransferRequest`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `InitializedConfig`
  - library `core` [standard] in `core/libraries/core/color/core.lua`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/config/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `InitializedItems`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `InitializedKeybinds`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `InitializedModules`
  - library `core` [standard] in `core/libraries/core/performance.lua`
  - library `core` [standard] in `core/libraries/core/currency/core.lua`
  - library `core` [standard] in `core/libraries/core/darkrp/core.lua`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
  - library `core` [standard] in `core/libraries/core/modularity/core.lua`
  - library `core` [method] in `core/libraries/core/protection/core.lua`
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
  - library `core` [standard] in `core/libraries/core/playerinteract/core.lua`
- `InteractionMenuOpened`
  - library `core` [standard] in `core/libraries/core/playerinteract/core.lua`
- `InventoryClosed`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `InventoryDataChanged`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
- `InventoryDeleted`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
- `InventoryInitialized`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `InventoryItemAdded`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `InventoryItemIconCreated`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `InventoryItemRemoved`
  - library `core` [standard] in `core/libraries/core/inventory/meta.lua`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `InventoryOpened`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `IsCharFakeRecognized`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `IsCharRecognized`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `IsSuitableForTrunk`
  - library `compatibility` [standard] in `core/libraries/compatibility/simfphys/core.lua`
- `ItemDataChanged`
  - library `core` [standard] in `core/libraries/core/derma/meta.lua`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `ItemDefaultFunctions`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `ItemDeleted`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
- `ItemFunctionCalled`
  - library `core` [standard] in `core/libraries/core/item/meta.lua`
- `ItemInitialized`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
- `ItemQuantityChanged`
  - library `core` [standard] in `core/libraries/core/inventory/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `KickedFromChar`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `LiliaCommandFrameworkReady`
  - library `core` [standard] in `core/libraries/core/character/commands.lua`
  - library `core` [standard] in `core/libraries/core/commands/core.lua`
- `LiliaLoaded`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
- `LiliaNoticeOverride`
  - library `core` [standard] in `core/libraries/core/notice/core.lua`
- `LoadData`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
- `ModifyCharacterModel`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `MySQLConnected`
  - library `thirdparty` [standard] in `core/libraries/thirdparty/sv_mysql.lua`
- `NetVarChanged`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
  - library `core` [standard] in `core/libraries/core/entity/meta.lua`
  - library `core` [standard] in `core/libraries/core/net/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
- `OnAdminSystemLoaded`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/sam/core.lua`
- `OnCharAttribBoosted`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnCharAttribUpdated`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnCharCreated`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `OnCharDelete`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `OnCharFallover`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
- `OnCharFlagsGiven`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnCharFlagsTaken`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnCharGetup`
  - library `core` [standard] in `core/libraries/core/character/commands.lua`
- `OnCharKick`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnCharNetVarChanged`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `OnCharPermakilled`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnCharVarChanged`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `OnConfigUpdated`
  - library `core` [standard] in `core/libraries/core/color/core.lua`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
  - library `core` [standard] in `core/libraries/core/config/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/currency/core.lua`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `OnCreateDualInventoryPanels`
  - library `core` [standard] in `core/libraries/core/inventory/core.lua`
- `OnDatabaseLoaded`
  - library `core` [standard] in `core/libraries/core/database/core.lua`
- `OnDataSet`
  - library `core` [standard] in `core/libraries/core/data/core.lua`
- `OnDialogNPCTypeSet`
  - library `core` [standard] in `core/libraries/core/dialog/netcalls.lua`
- `OnItemAdded`
  - library `core` [standard] in `core/libraries/core/inventory/meta.lua`
- `OnItemCreated`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnItemOverridden`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnItemRegistered`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnLoadTables`
  - library `core` [standard] in `core/libraries/core/database/core.lua`
- `OnLocalVarSet`
  - library `core` [standard] in `core/libraries/core/net/netcalls.lua`
- `OnNPCTypeSet`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
- `OnOOCMessageSent`
  - library `core` [standard] in `core/libraries/core/chatbox/core.lua`
- `OnPAC3PartTransfered`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `OnPlayerDroppedItem`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
  - library `core` [method] in `core/libraries/core/protection/core.lua`
- `OnPlayerInteractItem`
  - library `core` [standard] in `core/libraries/core/item/meta.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/vmanip/core.lua`
- `OnPlayerJoinClass`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `OnPlayerObserve`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `OnPlayerRotateItem`
  - library `core` [standard] in `core/libraries/core/item/core.lua`
- `OnPlayerSwitchClass`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
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
- `OnWeaponOverridesBulkSynced`
  - library `core` [standard] in `core/libraries/core/item/netcalls.lua`
- `OnWeaponOverrideUpdated`
  - library `core` [standard] in `core/libraries/core/item/netcalls.lua`
- `OnWeaponRuntimeOverridesBulkSynced`
  - library `core` [standard] in `core/libraries/core/item/netcalls.lua`
- `OnWeaponRuntimeOverrideUpdated`
  - library `core` [standard] in `core/libraries/core/item/netcalls.lua`
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
  - library `core` [standard] in `core/libraries/core/player/netcalls.lua`
- `PlayerBodyGroupChanged`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `PlayerGagged`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PlayerLoadedChar`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
  - library `compatibility` [standard] in `core/libraries/compatibility/prone/core.lua`
- `PlayerMessageSend`
  - library `core` [standard] in `core/libraries/core/chatbox/core.lua`
- `PlayerMuted`
  - library `core` [standard] in `core/libraries/core/admin/core.lua`
- `PlayerStaminaGained`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
- `PlayerStaminaLost`
  - library `core` [standard] in `core/libraries/core/player/meta.lua`
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
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `PreCharDelete`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
- `PreFreelookToggle`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `PreLiliaLoaded`
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
  - library `core` [standard] in `core/libraries/core/keybind/core.lua`
- `PrePlayerInteractItem`
  - library `core` [standard] in `core/libraries/core/item/meta.lua`
- `PrePlayerLoadedChar`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `RefreshFonts`
  - library `core` [standard] in `core/libraries/core/fonts/core.lua`
- `RemovePart`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `ResetCharacterPanel`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
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
  - library `loader.lua` [standard] in `core/libraries/loader.lua`
  - library `core` [method] in `core/libraries/core/database/core.lua`
- `SetupPACDataFromItems`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `SetupPlayerModel`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
  - library `core` [standard] in `core/libraries/core/character/meta.lua`
- `SetupQuickMenu`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `ShouldAllowSit`
  - library `core` [standard] in `core/libraries/core/sit/core.lua`
  - library `core` [standard] in `core/libraries/core/sit/netcalls.lua`
- `ShouldBarDraw`
  - library `core` [standard] in `core/libraries/core/bars/core.lua`
- `ShouldDisableThirdperson`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
- `ShouldHideBars`
  - library `core` [standard] in `core/libraries/core/bars/core.lua`
- `SyncCharList`
  - library `core` [standard] in `core/libraries/core/character/core.lua`
  - library `core` [standard] in `core/libraries/core/character/netcalls.lua`
- `ThirdPersonToggled`
  - library `core` [standard] in `core/libraries/core/camera/core.lua`
  - library `core` [standard] in `core/libraries/core/option/core.lua`
- `TryViewModel`
  - library `compatibility` [standard] in `core/libraries/compatibility/pac/core.lua`
- `UpdateEntityPersistence`
  - library `core` [standard] in `core/libraries/core/dialog/core.lua`
  - library `core` [standard] in `core/libraries/core/dialog/netcalls.lua`
- `VoiceToggled`
  - library `core` [standard] in `core/libraries/core/config/core.lua`
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
  - other [standard] in `modules/administration/submodules/warnings/commands.lua`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `AdjustStaminaOffset`
  - other [standard] in `modules/attributes/libraries/shared.lua`
- `AdminPrivilegesUpdated`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `AdminStickAddModels`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
- `BagInventoryReady`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `BagInventoryRemoved`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `CanAccessFactionRoster`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanCharBeTransfered`
  - other [standard] in `modules/teams/commands.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanDeleteChar`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CanDisplayCharInfo`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `CanDrawEntityHoverInfo`
  - core `hooks` [standard] in `core/hooks/client.lua`
- `CanEditFactionNotes`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `CanInviteToClass`
  - other [standard] in `modules/teams/libraries/server.lua`
- `CanInviteToFaction`
  - other [standard] in `modules/teams/libraries/server.lua`
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
  - other [standard] in `modules/vendor/libraries/meta.lua`
- `CanPersistEntity`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/administration/libraries/server.lua`
- `CanPickupMoney`
  - entity `entities` [standard] in `entities/entities/lia_money/init.lua`
- `CanPlayerAccessDoor`
  - other [method] in `modules/doors/libraries/server.lua`
- `CanPlayerAccessVendor`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/netcalls/server.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/init.lua`
- `CanPlayerChooseWeapon`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`
- `CanPlayerCreateChar`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
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
  - other [method] in `modules/mainmenu/libraries/server.lua`
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
- `CharForceRecognized`
  - other [standard] in `modules/recognition/libraries/server.lua`
- `CharListEntry`
  - other [standard] in `modules/administration/netcalls/server.lua`
- `CharListLoaded`
  - other [method] in `modules/mainmenu/module.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
- `CharListUpdated`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CharLoaded`
  - other [standard] in `modules/mainmenu/netcalls/client.lua`
  - other [standard] in `modules/administration/netcalls/client.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
- `CharMenuClosed`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CharMenuOpened`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `CharPreSave`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/spawns/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
- `ChatboxPanelCreated`
  - other [standard] in `modules/chatbox/libraries/client.lua`
  - other [standard] in `modules/chatbox/netcalls/client.lua`
- `ChatboxTextAdded`
  - other [standard] in `modules/chatbox/libraries/client.lua`
- `CheckFactionLimitReached`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/teams/libraries/shared.lua`
- `ChooseCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `CollectDoorDataFields`
  - other [method] in `modules/doors/libraries/server.lua`
- `ConfigureCharacterCreationSteps`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
- `CreateCharacter`
  - other [method] in `modules/mainmenu/module.lua`
- `CreateChatboxPanel`
  - other [method] in `modules/chatbox/libraries/client.lua`
  - other [standard] in `modules/chatbox/libraries/client.lua`
  - other [standard] in `modules/chatbox/netcalls/client.lua`
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
- `DoorEnabledToggled`
  - other [standard] in `modules/doors/commands.lua`
- `DoorHiddenToggled`
  - other [standard] in `modules/doors/commands.lua`
- `DoorLockToggled`
  - other [standard] in `modules/doors/libraries/server.lua`
- `DoorOwnableToggled`
  - other [standard] in `modules/doors/commands.lua`
- `DoorPriceSet`
  - other [standard] in `modules/doors/commands.lua`
- `DoorTitleSet`
  - other [standard] in `modules/doors/commands.lua`
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
  - other [standard] in `modules/recognition/commands.lua`
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
  - other [standard] in `modules/administration/commands.lua`
  - other [standard] in `modules/attributes/libraries/client.lua`
  - core `hooks` [method] in `core/hooks/shared.lua`
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
- `GetMoneyModel`
  - entity `entities` [standard] in `entities/entities/lia_money/init.lua`
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
- `GetPrestigePayBonus`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetPriceOverride`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/shared.lua`
- `GetRespawnScreenCause`
  - other [standard] in `modules/spawns/libraries/client.lua`
- `GetSalaryAmount`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `GetUsergroupIcon`
  - other [standard] in `modules/chatbox/libraries/shared.lua`
- `GetWarnings`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `GetWeaponName`
  - core `derma` [standard] in `core/derma/panels/weaponselector.lua`
- `HandleItemTransferRequest`
  - other [method] in `modules/inventory/types/weightinv/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/items/base/bags.lua`
- `InitializedModules`
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
- `InventoryInitialized`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
- `InventoryItemAdded`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/client.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
- `InventoryItemIconCreated`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua`
- `InventoryItemRemoved`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/client.lua`
- `InventoryOpened`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `InventoryPanelCreated`
  - other [standard] in `modules/inventory/types/gridinv/libraries/client.lua`
- `IsCharacterCreationOverridden`
  - other [standard] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_character.lua`
- `IsCharFakeRecognized`
  - other [method] in `modules/recognition/libraries/shared.lua`
- `IsCharRecognized`
  - other [standard] in `modules/recognition/libraries/server.lua`
  - other [method] in `modules/recognition/libraries/shared.lua`
- `IsRecognizedChatType`
  - other [standard] in `modules/recognition/libraries/client.lua`
- `IsSuitableForTrunk`
  - other [standard] in `modules/administration/commands.lua`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/shared.lua`
- `ItemCombine`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
- `ItemDataChanged`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
- `ItemDraggedOutOfInventory`
  - other [standard] in `modules/inventory/types/weightinv/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `ItemFunctionCalled`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `ItemPaintOver`
  - core `derma` [standard] in `core/derma/panels/item.lua`
- `ItemQuantityChanged`
  - other [standard] in `modules/inventory/types/gridinv/derma/cl_grid_inventory.lua`
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
- `OnAdminStickMenuClosed`
  - other [standard] in `modules/administration/submodules/adminstick/derma/client.lua`
  - other [method] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/libraries/client.lua`
  - other [standard] in `modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua`
- `OnAmmoBoxUsed`
  - entity `entities` [standard] in `entities/entities/lia_ammobox/init.lua`
- `OnCharacterCreationModelIconSet`
  - other [standard] in `modules/mainmenu/derma/steps/cl_model.lua`
- `OnCharCreated`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [method] in `modules/inventory/types/gridinv/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `OnCharDelete`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `OnCharDisconnect`
  - other [method] in `modules/spawns/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnCharRecognized`
  - other [standard] in `modules/recognition/libraries/server.lua`
  - other [standard] in `modules/recognition/netcalls/client.lua`
- `OnCharTradeVendor`
  - other [method] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/libraries/server.lua`
- `OnCharVarChanged`
  - other [method] in `modules/teams/libraries/server.lua`
  - core `hooks` [method] in `core/hooks/shared.lua`
- `OnChatReceived`
  - other [standard] in `modules/chatbox/netcalls/client.lua`
  - core `hooks` [method] in `core/hooks/client.lua`
- `OnCreateItemInteractionMenu`
  - core `derma` [standard] in `core/derma/panels/item.lua`
- `OnCreateStoragePanel`
  - other [method] in `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/client.lua`
- `OnDatabaseLoaded`
  - core `hooks` [method] in `core/hooks/server.lua`
- `OnDeathSoundPlayed`
  - core `hooks` [standard] in `core/hooks/server.lua`
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
- `OnItemCreated`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
- `OnItemSpawned`
  - entity `entities` [standard] in `entities/entities/lia_item/init.lua`
- `OnlineStaffDataReceived`
  - other [standard] in `modules/administration/netcalls/client.lua`
  - core `derma` [standard] in `core/derma/panels/f1menu.lua`
- `OnLocalVarSet`
  - other [method] in `modules/attributes/libraries/client.lua`
- `OnModelPanelSetup`
  - core `derma` [standard] in `core/derma/panels/model.lua`
- `OnOpenVendorMenu`
  - other [standard] in `modules/vendor/libraries/client.lua`
- `OnPainSoundPlayed`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `OnPickupMoney`
  - entity `entities` [standard] in `entities/entities/lia_money/init.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
- `OnPlayerInteractItem`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `OnPlayerJoinClass`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
- `OnPlayerLostStackItem`
  - other [standard] in `modules/inventory/types/gridinv/gridinv.lua`
- `OnPlayerObserve`
  - other [standard] in `modules/administration/libraries/server.lua`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `OnPlayerPurchaseDoor`
  - other [standard] in `modules/doors/commands.lua`
- `OnPlayerRotateItem`
  - other [standard] in `modules/inventory/types/gridinv/libraries/server.lua`
- `OnPlayerSwitchClass`
  - other [method] in `modules/teams/libraries/server.lua`
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
  - other [standard] in `modules/chatbox/derma/cl_chatbox.lua`
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
  - other [standard] in `modules/teams/commands.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `OnVendorEdited`
  - other [standard] in `modules/vendor/netcalls/server.lua`
- `OnVoiceTypeChanged`
  - core `hooks` [method] in `core/hooks/server.lua`
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
  - other [standard] in `modules/administration/commands.lua`
  - other [standard] in `modules/spawns/libraries/client.lua`
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
- `PlayerModelChanged`
  - core `hooks` [standard] in `core/hooks/shared.lua`
- `PlayerShouldPermaKill`
  - other [method] in `modules/administration/libraries/server.lua`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PlayerSpawnPointSelected`
  - other [standard] in `modules/spawns/libraries/server.lua`
- `PlayerStaminaGained`
  - other [standard] in `modules/attributes/libraries/shared.lua`
- `PlayerStaminaLost`
  - other [method] in `modules/attributes/libraries/server.lua`
  - other [standard] in `modules/attributes/libraries/shared.lua`
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
- `PrePlayerLoadedChar`
  - core `hooks` [method] in `core/hooks/server.lua`
- `PreSalaryGive`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `PreScaleDamage`
  - core `hooks` [standard] in `core/hooks/server.lua`
- `ReadLogEntries`
  - other [method] in `modules/administration/submodules/logs/libraries/server.lua`
- `RemoveFilteredWord`
  - other [method] in `modules/chatbox/libraries/server.lua`
- `RemoveWarning`
  - other [method] in `modules/administration/submodules/warnings/libraries/server.lua`
- `ResetCharacterPanel`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/derma/cl_creation.lua`
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
  - other [standard] in `modules/administration/commands.lua`
  - other [method] in `modules/mainmenu/module.lua`
  - other [standard] in `modules/mainmenu/libraries/server.lua`
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
  - other [standard] in `modules/teams/commands.lua`
  - other [method] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/libraries/server.lua`
  - other [standard] in `modules/teams/netcalls/server.lua`
- `TrackOfflineFactionTransfer`
  - other [method] in `modules/teams/libraries/server.lua`
- `UpdateEntityPersistence`
  - other [standard] in `modules/administration/commands.lua`
  - other [standard] in `modules/vendor/libraries/server.lua`
  - other [standard] in `modules/vendor/netcalls/server.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/init.lua`
  - other [standard] in `modules/vendor/entities/entities/lia_vendor/shared.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/commands.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/libraries/server.lua`
  - other [standard] in `modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua`
  - core `hooks` [method] in `core/hooks/server.lua`
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
  - other [standard] in `modules/administration/submodules/warnings/commands.lua`
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
- `DatabaseConnectionFailed(errorText, arg2)`
- `DatabaseDisconnected(errorText)`
- `DatabaseSchemaFailed(message)`
- `LiliaCommandFrameworkReady()`
- `MySQLConnected(arg1)`
- `SendPopup(client, message)`

### Unused Hook Documentation:
These hooks are documented but not registered in code:
- `CharListExtraDetails()`
- `OnLocalizationLoaded()`

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
| `CLASS.desc` | Unlocalized string | `No Description` | core\libraries\core\classes\core.lua | 98 |
| `CLASS.name` | Missing key | `Unknown` | core\libraries\core\classes\core.lua | 97 |
| `FACTION.desc` | Unlocalized string | `No Description` | core\libraries\core\factions\core.lua | 125 |
| `FACTION.name` | Missing key | `Unknown` | core\libraries\core\factions\core.lua | 120 |
| `ITEM.desc` | Missing key | `arccwAttachmentDesc` | core\libraries\compatibility\arccw\items\base\arccw_att.lua | 2 |
| `ITEM.desc` | Missing key | `pacoutfitDesc` | core\libraries\compatibility\pac\items\base\pacoutfit.lua | 3 |
| `ITEM.desc` | Unlocalized string | `No Description` | core\libraries\core\item\core.lua | 235 |
| `ITEM.desc` | Unlocalized string | `No Description` | core\libraries\core\item\core.lua | 255 |
| `ITEM.desc` | Missing key | `aidDesc` | items\base\aid.lua | 2 |
| `ITEM.desc` | Missing key | `booksDesc` | items\base\books.lua | 2 |
| `ITEM.desc` | Missing key | `entitiesDesc` | items\base\entities.lua | 3 |
| `ITEM.desc` | Missing key | `grenadeDesc` | items\base\grenade.lua | 2 |
| `ITEM.desc` | Missing key | `outfitDesc` | items\base\outfit.lua | 2 |
| `ITEM.desc` | Missing key | `urlDesc` | items\base\url.lua | 2 |
| `ITEM.desc` | Missing key | `weaponsDesc` | items\base\weapons.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A bag to hold more items.` | modules\inventory\types\gridinv\items\base\bags.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A bag to hold more items.` | modules\inventory\types\weightinv\items\base\bags.lua | 2 |
| `ITEM.name` | Missing key | `arccwAttachment` | core\libraries\compatibility\arccw\items\base\arccw_att.lua | 1 |
| `ITEM.name` | Missing key | `pacoutfitName` | core\libraries\compatibility\pac\items\base\pacoutfit.lua | 2 |
| `ITEM.name` | Unlocalized string | `Invalid name!` | core\libraries\core\item\meta.lua | 4 |
| `ITEM.name` | Missing key | `aidName` | items\base\aid.lua | 1 |
| `ITEM.name` | Missing key | `ammoName` | items\base\ammo.lua | 1 |
| `ITEM.name` | Missing key | `booksName` | items\base\books.lua | 1 |
| `ITEM.name` | Missing key | `entitiesName` | items\base\entities.lua | 1 |
| `ITEM.name` | Missing key | `grenadeName` | items\base\grenade.lua | 1 |
| `ITEM.name` | Missing key | `outfit` | items\base\outfit.lua | 1 |
| `ITEM.name` | Missing key | `stackableName` | items\base\stackable.lua | 1 |
| `ITEM.name` | Missing key | `urlName` | items\base\url.lua | 1 |
| `ITEM.name` | Missing key | `weaponsName` | items\base\weapons.lua | 1 |
| `ITEM.name` | Missing key | `Bag` | modules\inventory\types\gridinv\items\base\bags.lua | 1 |
| `ITEM.name` | Missing key | `Bag` | modules\inventory\types\weightinv\items\base\bags.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Provides comprehensive administration tools and staff management features.` | modules\administration\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `\\nReload switches tool sections \\nAdmin: Left click selects target, right click freezes player \\nMap Configurer: Left click sets aim position, right click uses your position \\nShift + Reload uses the active section` | modules\administration\submodules\adminstick\module.lua | 4 |
| `MODULE.desc` | Missing key | `Logging` | modules\administration\submodules\logs\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Sends a support ticket to staff.` | modules\administration\submodules\tickets\module.lua | 4 |
| `MODULE.desc` | Missing key | `Warnings` | modules\administration\submodules\warnings\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Implements character attributes and provides tools for managing them.` | modules\attributes\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Replaces the default chat with a configurable box that supports colored text, command parsing, and dedicated staff channels.` | modules\chatbox\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Manages door ownership, access control, and door-related permissions.` | modules\doors\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Implements a modular grid-based inventory with item stacking, weight limits, and support for hot-loading additional modules.` | modules\inventory\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Implements a modular grid-based inventory with item stacking, weight limits, and support for hot-loading additional modules.` | modules\inventory\types\gridinv\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Adds persistent storage containers and player vaults that integrate with the inventory for item management.` | modules\inventory\types\gridinv\submodules\storage\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Adds a weight-based simple inventory type with list display and storage support.` | modules\inventory\types\weightinv\module.lua | 4 |
| `MODULE.desc` | Missing key | `mainMenuDescription` | modules\mainmenu\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Introduces a recognition system where characters must learn each other` | modules\recognition\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Manages player spawns and spawn protection systems.` | modules\spawns\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Manages teams and factions with whitelist support and admin controls.` | modules\teams\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Provides NPC vendors who can buy and sell items with stock management and dialogue-driven transactions.` | modules\vendor\module.lua | 4 |
| `MODULE.name` | Missing key | `Attributes` | modules\attributes\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Chat Box` | modules\chatbox\module.lua | 1 |
| `MODULE.name` | Missing key | `Doors` | modules\doors\module.lua | 1 |
| `MODULE.name` | Missing key | `Inventory` | modules\inventory\module.lua | 1 |
| `MODULE.name` | Missing key | `Inventory` | modules\inventory\types\gridinv\module.lua | 1 |
| `MODULE.name` | Missing key | `Storage` | modules\inventory\types\gridinv\submodules\storage\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Simple Inventory` | modules\inventory\types\weightinv\module.lua | 1 |
| `MODULE.name` | Missing key | `mainMenuModuleName` | modules\mainmenu\module.lua | 1 |
| `MODULE.name` | Missing key | `Recognition` | modules\recognition\module.lua | 1 |
| `MODULE.name` | Missing key | `Spawns` | modules\spawns\module.lua | 1 |
| `MODULE.name` | Missing key | `Teams` | modules\teams\module.lua | 1 |
| `MODULE.name` | Missing key | `Vendor` | modules\vendor\module.lua | 1 |
| `Privilege.Category` | Missing key | `Compatibility` | core\libraries\compatibility\pac\core.lua | 210 |
| `Privilege.Category` | Missing key | `Lilia` | core\libraries\compatibility\sam\core.lua | 250 |
| `Privilege.Category` | Missing key | `Lilia` | core\libraries\compatibility\serverguard\core.lua | 29 |
| `Privilege.Category` | Missing key | `Lilia` | core\libraries\compatibility\serverguard\core.lua | 36 |
| `Privilege.Category` | Missing key | `Lilia` | core\libraries\compatibility\serverguard\core.lua | 108 |
| `Privilege.Category` | Missing key | `Lilia` | core\libraries\compatibility\ulx\core.lua | 8 |
| `Privilege.Category` | Missing key | `Compatibility` | core\libraries\compatibility\vjbase\core.lua | 36 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | core\libraries\core\admin\core.lua | 578 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | core\libraries\core\admin\core.lua | 589 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | core\libraries\core\admin\core.lua | 1415 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | core\libraries\core\admin\core.lua | 1429 |
| `Privilege.Category` | Unlocalized string | `Staff Permissions` | core\libraries\core\commands\core.lua | 58 |
| `Privilege.Category` | Missing key | `Commands` | core\libraries\core\commands\core.lua | 110 |
| `Privilege.Category` | Missing key | `Commands` | core\libraries\core\commands\core.lua | 124 |
| `Privilege.Category` | Missing key | `Lilia` | entities\entities\lia_ammobox\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | entities\entities\lia_bodygrouper\shared.lua | 3 |
| `Privilege.Category` | Missing key | `Lilia` | entities\entities\lia_item\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | entities\entities\lia_model_wardrobe\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Lilia` | entities\entities\lia_money\shared.lua | 5 |
| `Privilege.Category` | Missing key | `Lilia` | entities\entities\lia_npc\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Player Info` | modules\administration\commands.lua | 326 |
| `Privilege.Category` | Unlocalized string | `Player Info` | modules\administration\commands.lua | 360 |
| `Privilege.Category` | Missing key | `Teleportation` | modules\administration\commands.lua | 444 |
| `Privilege.Category` | Missing key | `Teleportation` | modules\administration\commands.lua | 491 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | modules\administration\commands.lua | 526 |
| `Privilege.Category` | Unlocalized string | `Player Punishment` | modules\administration\commands.lua | 615 |
| `Privilege.Category` | Unlocalized string | `Player Punishment` | modules\administration\commands.lua | 637 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 654 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 780 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 974 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 991 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 1008 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 1025 |
| `Privilege.Category` | Unlocalized string | `Player State` | modules\administration\commands.lua | 1071 |
| `Privilege.Category` | Missing key | `Observation` | modules\administration\commands.lua | 1360 |
| `Privilege.Category` | Missing key | `Inventory` | modules\administration\commands.lua | 1479 |
| `Privilege.Category` | Missing key | `Communication` | modules\administration\commands.lua | 1656 |
| `Privilege.Category` | Missing key | `Inventory` | modules\administration\commands.lua | 1848 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | modules\administration\commands.lua | 1874 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | modules\administration\commands.lua | 1941 |
| `Privilege.Category` | Unlocalized string | `Character Discipline` | modules\administration\commands.lua | 1994 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2086 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | modules\administration\commands.lua | 2165 |
| `Privilege.Category` | Missing key | `Inventory` | modules\administration\commands.lua | 2253 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | modules\administration\commands.lua | 2310 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | modules\administration\commands.lua | 2348 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | modules\administration\commands.lua | 2382 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | modules\administration\commands.lua | 2414 |
| `Privilege.Category` | Unlocalized string | `Character Editing` | modules\administration\commands.lua | 2486 |
| `Privilege.Category` | Missing key | `Communication` | modules\administration\commands.lua | 2653 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2734 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2770 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2800 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2825 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2850 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2876 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 2913 |
| `Privilege.Category` | Missing key | `Attributes` | modules\administration\commands.lua | 3338 |
| `Privilege.Category` | Missing key | `Attributes` | modules\administration\commands.lua | 3381 |
| `Privilege.Category` | Missing key | `Attributes` | modules\administration\commands.lua | 3554 |
| `Privilege.Category` | Missing key | `Communication` | modules\administration\commands.lua | 3596 |
| `Privilege.Category` | Missing key | `Communication` | modules\administration\commands.lua | 3623 |
| `Privilege.Category` | Missing key | `NPCs` | modules\administration\commands.lua | 3737 |
| `Privilege.Category` | Unlocalized string | `Character Info` | modules\administration\commands.lua | 3839 |
| `Privilege.Category` | Missing key | `Lilia` | modules\administration\entities\weapons\lia_distance\shared.lua | 6 |
| `Privilege.Category` | Unlocalized string | `Staff: Items` | modules\administration\module.lua | 10 |
| `Privilege.Category` | Missing key | `Exploiting` | modules\administration\module.lua | 15 |
| `Privilege.Category` | Unlocalized string | `Staff: Items` | modules\administration\module.lua | 20 |
| `Privilege.Category` | Missing key | `Blacklisting` | modules\administration\module.lua | 25 |
| `Privilege.Category` | Missing key | `developmentHUD` | modules\administration\module.lua | 30 |
| `Privilege.Category` | Missing key | `developmentHUD` | modules\administration\module.lua | 35 |
| `Privilege.Category` | Missing key | `bodygroups` | modules\administration\module.lua | 40 |
| `Privilege.Category` | Missing key | `bodygroups` | modules\administration\module.lua | 46 |
| `Privilege.Category` | Missing key | `Blacklisting` | modules\administration\module.lua | 51 |
| `Privilege.Category` | Unlocalized string | `User Interface` | modules\administration\module.lua | 56 |
| `Privilege.Category` | Missing key | `Usergroups` | modules\administration\module.lua | 61 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 66 |
| `Privilege.Category` | Missing key | `Server` | modules\administration\module.lua | 72 |
| `Privilege.Category` | Unlocalized string | `User Interface` | modules\administration\module.lua | 77 |
| `Privilege.Category` | Unlocalized string | `User Interface` | modules\administration\module.lua | 82 |
| `Privilege.Category` | Missing key | `Character` | modules\administration\module.lua | 87 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 92 |
| `Privilege.Category` | Unlocalized string | `SAM | Admin Mod` | modules\administration\module.lua | 97 |
| `Privilege.Category` | Unlocalized string | `Simfphys Vehicles` | modules\administration\module.lua | 102 |
| `Privilege.Category` | Unlocalized string | `SAM | Admin Mod` | modules\administration\module.lua | 107 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 112 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 117 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 122 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 127 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 132 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 137 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 142 |
| `Privilege.Category` | Missing key | `Exploiting` | modules\administration\module.lua | 147 |
| `Privilege.Category` | Missing key | `Server` | modules\administration\module.lua | 152 |
| `Privilege.Category` | Unlocalized string | `Staff: Tools` | modules\administration\module.lua | 157 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 162 |
| `Privilege.Category` | Unlocalized string | `Staff: Physgun` | modules\administration\module.lua | 167 |
| `Privilege.Category` | Unlocalized string | `Staff: Physgun` | modules\administration\module.lua | 172 |
| `Privilege.Category` | Unlocalized string | `Staff: Physgun` | modules\administration\module.lua | 177 |
| `Privilege.Category` | Unlocalized string | `Staff: Physgun` | modules\administration\module.lua | 182 |
| `Privilege.Category` | Unlocalized string | `Staff: Physgun` | modules\administration\module.lua | 187 |
| `Privilege.Category` | Unlocalized string | `Staff: Protection` | modules\administration\module.lua | 192 |
| `Privilege.Category` | Unlocalized string | `Staff: Physgun` | modules\administration\module.lua | 197 |
| `Privilege.Category` | Unlocalized string | `Staff: Movement` | modules\administration\module.lua | 202 |
| `Privilege.Category` | Unlocalized string | `User Interface` | modules\administration\module.lua | 207 |
| `Privilege.Category` | Missing key | `Compatibility` | modules\administration\module.lua | 212 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 217 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 222 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 227 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 232 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 237 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 242 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 247 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 252 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 257 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 262 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\administration\module.lua | 267 |
| `Privilege.Category` | Unlocalized string | `Staff: Blacklisting` | modules\administration\module.lua | 272 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 277 |
| `Privilege.Category` | Unlocalized string | `Staff: Tools` | modules\administration\module.lua | 282 |
| `Privilege.Category` | Missing key | `Commands` | modules\administration\module.lua | 287 |
| `Privilege.Category` | Missing key | `Commands` | modules\administration\module.lua | 292 |
| `Privilege.Category` | Missing key | `Commands` | modules\administration\module.lua | 297 |
| `Privilege.Category` | Missing key | `NPCs` | modules\administration\module.lua | 302 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 307 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\administration\module.lua | 312 |
| `Privilege.Category` | Missing key | `Lilia` | modules\administration\submodules\adminstick\entities\weapons\lia_adminstick\shared.lua | 5 |
| `Privilege.Category` | Unlocalized string | `Admin Stick` | modules\administration\submodules\adminstick\module.lua | 10 |
| `Privilege.Category` | Missing key | `Logging` | modules\administration\submodules\logs\module.lua | 10 |
| `Privilege.Category` | Missing key | `Tickets` | modules\administration\submodules\tickets\commands.lua | 126 |
| `Privilege.Category` | Missing key | `Tickets` | modules\administration\submodules\tickets\module.lua | 10 |
| `Privilege.Category` | Missing key | `Warnings` | modules\administration\submodules\warnings\commands.lua | 23 |
| `Privilege.Category` | Missing key | `Warnings` | modules\administration\submodules\warnings\commands.lua | 83 |
| `Privilege.Category` | Missing key | `Warning` | modules\administration\submodules\warnings\module.lua | 10 |
| `Privilege.Category` | Missing key | `Warning` | modules\administration\submodules\warnings\module.lua | 15 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 10 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 15 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 20 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 25 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 30 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 35 |
| `Privilege.Category` | Missing key | `Chat` | modules\chatbox\module.lua | 40 |
| `Privilege.Category` | Missing key | `doorActions` | modules\doors\commands.lua | 34 |
| `Privilege.Category` | Missing key | `doorActions` | modules\doors\commands.lua | 67 |
| `Privilege.Category` | Missing key | `doorActions` | modules\doors\commands.lua | 148 |
| `Privilege.Category` | Missing key | `doorActions` | modules\doors\commands.lua | 200 |
| `Privilege.Category` | Missing key | `doorSettings` | modules\doors\commands.lua | 245 |
| `Privilege.Category` | Missing key | `doorMaintenance` | modules\doors\commands.lua | 285 |
| `Privilege.Category` | Missing key | `doorSettings` | modules\doors\commands.lua | 318 |
| `Privilege.Category` | Missing key | `doorSettings` | modules\doors\commands.lua | 345 |
| `Privilege.Category` | Missing key | `doorSettings` | modules\doors\commands.lua | 378 |
| `Privilege.Category` | Missing key | `doorSettings` | modules\doors\commands.lua | 415 |
| `Privilege.Category` | Missing key | `doorMaintenance` | modules\doors\commands.lua | 449 |
| `Privilege.Category` | Missing key | `doorInformation` | modules\doors\commands.lua | 465 |
| `Privilege.Category` | Missing key | `doorMaintenance` | modules\doors\commands.lua | 544 |
| `Privilege.Category` | Missing key | `doorMaintenance` | modules\doors\commands.lua | 622 |
| `Privilege.Category` | Missing key | `Inventory` | modules\inventory\commands.lua | 14 |
| `Privilege.Category` | Missing key | `Inventory` | modules\inventory\commands.lua | 53 |
| `Privilege.Category` | Unlocalized string | `Staff: Management` | modules\inventory\module.lua | 9 |
| `Privilege.Category` | Missing key | `Lilia` | modules\inventory\types\gridinv\submodules\storage\entities\entities\lia_storage\shared.lua | 5 |
| `Privilege.Category` | Unlocalized string | `Spawn Permissions` | modules\inventory\types\gridinv\submodules\storage\module.lua | 10 |
| `Privilege.Category` | Missing key | `Recognition` | modules\recognition\commands.lua | 14 |
| `Privilege.Category` | Missing key | `Recognition` | modules\recognition\commands.lua | 35 |
| `Privilege.Category` | Missing key | `Recognition` | modules\recognition\commands.lua | 56 |
| `Privilege.Category` | Unlocalized string | `Faction Management` | modules\teams\module.lua | 10 |
| `Privilege.Category` | Unlocalized string | `Faction Management` | modules\teams\module.lua | 15 |
| `Privilege.Category` | Missing key | `Vendors` | modules\vendor\commands.lua | 124 |
| `Privilege.Category` | Missing key | `Lilia` | modules\vendor\entities\entities\lia_vendor\shared.lua | 6 |
| `Privilege.Category` | Missing key | `Vendors` | modules\vendor\module.lua | 10 |
| `Privilege.Category` | Missing key | `Vendors` | modules\vendor\module.lua | 15 |
| `Privilege.Name` | Unlocalized string | `Better dupe` | core\libraries\compatibility\advdupe2\core.lua | 64 |
| `Privilege.Name` | Unlocalized string | `Can Use PAC3` | core\libraries\compatibility\pac\core.lua | 207 |
| `Privilege.Name` | Unlocalized string | `VJ NPC Properties` | core\libraries\compatibility\vjbase\core.lua | 33 |
| `Privilege.Name` | Missing key | `string` | core\libraries\core\admin\core.lua | 1542 |
| `Privilege.Name` | Unlocalized string | `Get Player Playtime` | modules\administration\commands.lua | 324 |
| `Privilege.Name` | Unlocalized string | `Check Character ID` | modules\administration\commands.lua | 358 |
| `Privilege.Name` | Unlocalized string | `Send To Administration Room` | modules\administration\commands.lua | 442 |
| `Privilege.Name` | Unlocalized string | `Return From Administration Room` | modules\administration\commands.lua | 489 |
| `Privilege.Name` | Unlocalized string | `Character Kill (Permakill)` | modules\administration\commands.lua | 524 |
| `Privilege.Name` | Unlocalized string | `Ban Player` | modules\administration\commands.lua | 613 |
| `Privilege.Name` | Unlocalized string | `Kick Player` | modules\administration\commands.lua | 635 |
| `Privilege.Name` | Unlocalized string | `Kill Player` | modules\administration\commands.lua | 652 |
| `Privilege.Name` | Unlocalized string | `Blind Player (Fade)` | modules\administration\commands.lua | 778 |
| `Privilege.Name` | Unlocalized string | `Cloak Player` | modules\administration\commands.lua | 972 |
| `Privilege.Name` | Unlocalized string | `Uncloak Player` | modules\administration\commands.lua | 989 |
| `Privilege.Name` | Unlocalized string | `Give God Mode` | modules\administration\commands.lua | 1006 |
| `Privilege.Name` | Unlocalized string | `Remove God Mode` | modules\administration\commands.lua | 1023 |
| `Privilege.Name` | Unlocalized string | `Strip Weapons` | modules\administration\commands.lua | 1069 |
| `Privilege.Name` | Unlocalized string | `Spectate Player` | modules\administration\commands.lua | 1358 |
| `Privilege.Name` | Unlocalized string | `Check Inventory` | modules\administration\commands.lua | 1477 |
| `Privilege.Name` | Unlocalized string | `Toggle Voice` | modules\administration\commands.lua | 1654 |
| `Privilege.Name` | Unlocalized string | `Clear Inventory` | modules\administration\commands.lua | 1846 |
| `Privilege.Name` | Unlocalized string | `Kick Character` | modules\administration\commands.lua | 1872 |
| `Privilege.Name` | Unlocalized string | `Ban Character` | modules\administration\commands.lua | 1939 |
| `Privilege.Name` | Unlocalized string | `Wipe Character` | modules\administration\commands.lua | 1992 |
| `Privilege.Name` | Unlocalized string | `Check Money` | modules\administration\commands.lua | 2084 |
| `Privilege.Name` | Unlocalized string | `Set Character Speed` | modules\administration\commands.lua | 2163 |
| `Privilege.Name` | Unlocalized string | `Give Item` | modules\administration\commands.lua | 2251 |
| `Privilege.Name` | Unlocalized string | `Set Character Description` | modules\administration\commands.lua | 2308 |
| `Privilege.Name` | Unlocalized string | `Set Character Name` | modules\administration\commands.lua | 2346 |
| `Privilege.Name` | Unlocalized string | `Set Character Scale` | modules\administration\commands.lua | 2380 |
| `Privilege.Name` | Unlocalized string | `Set Character Jump Height` | modules\administration\commands.lua | 2412 |
| `Privilege.Name` | Unlocalized string | `Set Character Skin` | modules\administration\commands.lua | 2484 |
| `Privilege.Name` | Unlocalized string | `Force Say` | modules\administration\commands.lua | 2651 |
| `Privilege.Name` | Unlocalized string | `Get Character Model` | modules\administration\commands.lua | 2732 |
| `Privilege.Name` | Unlocalized string | `Get Character Flags` | modules\administration\commands.lua | 2768 |
| `Privilege.Name` | Unlocalized string | `Get Character Name` | modules\administration\commands.lua | 2798 |
| `Privilege.Name` | Unlocalized string | `Get Character Health` | modules\administration\commands.lua | 2823 |
| `Privilege.Name` | Unlocalized string | `Get Character Money` | modules\administration\commands.lua | 2848 |
| `Privilege.Name` | Unlocalized string | `Get Character Inventory` | modules\administration\commands.lua | 2874 |
| `Privilege.Name` | Unlocalized string | `Get All Informations` | modules\administration\commands.lua | 2911 |
| `Privilege.Name` | Unlocalized string | `Set Attributes` | modules\administration\commands.lua | 3336 |
| `Privilege.Name` | Unlocalized string | `Check Attributes` | modules\administration\commands.lua | 3379 |
| `Privilege.Name` | Unlocalized string | `Add Attributes` | modules\administration\commands.lua | 3552 |
| `Privilege.Name` | Unlocalized string | `Ban OOC` | modules\administration\commands.lua | 3594 |
| `Privilege.Name` | Unlocalized string | `Unban OOC` | modules\administration\commands.lua | 3621 |
| `Privilege.Name` | Unlocalized string | `Change NPC Type` | modules\administration\commands.lua | 3735 |
| `Privilege.Name` | Unlocalized string | `View and edit a player` | modules\administration\commands.lua | 3837 |
| `Privilege.Name` | Missing key | `Administration` | modules\administration\module.lua | 1 |
| `Privilege.Name` | Unlocalized string | `Manage Weapon Overrides` | modules\administration\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Can See Alting Notifications` | modules\administration\module.lua | 13 |
| `Privilege.Name` | Unlocalized string | `Can Use Item Spawner` | modules\administration\module.lua | 18 |
| `Privilege.Name` | Unlocalized string | `Manage Prop Blacklist` | modules\administration\module.lua | 23 |
| `Privilege.Name` | Unlocalized string | `Staff HUD` | modules\administration\module.lua | 28 |
| `Privilege.Name` | Unlocalized string | `Development HUD` | modules\administration\module.lua | 33 |
| `Privilege.Name` | Unlocalized string | `Manage Bodygroups` | modules\administration\module.lua | 38 |
| `Privilege.Name` | Unlocalized string | `Change Bodygroups` | modules\administration\module.lua | 43 |
| `Privilege.Name` | Unlocalized string | `Manage Vehicle Blacklist` | modules\administration\module.lua | 49 |
| `Privilege.Name` | Unlocalized string | `Access Edit Configuration Menu` | modules\administration\module.lua | 54 |
| `Privilege.Name` | Unlocalized string | `Manage Permissions` | modules\administration\module.lua | 59 |
| `Privilege.Name` | Unlocalized string | `View Staff Management` | modules\administration\module.lua | 64 |
| `Privilege.Name` | Unlocalized string | `View Net Logs` | modules\administration\module.lua | 69 |
| `Privilege.Name` | Unlocalized string | `Can Access Scoreboard Admin Options` | modules\administration\module.lua | 75 |
| `Privilege.Name` | Unlocalized string | `Can Access Scoreboard Info Out Of Staff` | modules\administration\module.lua | 80 |
| `Privilege.Name` | Unlocalized string | `List Characters` | modules\administration\module.lua | 85 |
| `Privilege.Name` | Unlocalized string | `Create Staff Character` | modules\administration\module.lua | 90 |
| `Privilege.Name` | Unlocalized string | `Can Bypass Staff Faction SAM Command whitelist` | modules\administration\module.lua | 95 |
| `Privilege.Name` | Unlocalized string | `Can Edit Simfphys Cars` | modules\administration\module.lua | 100 |
| `Privilege.Name` | Unlocalized string | `Can See SAM Notifications Outside Staff Character` | modules\administration\module.lua | 105 |
| `Privilege.Name` | Unlocalized string | `Check Inventories` | modules\administration\module.lua | 110 |
| `Privilege.Name` | Unlocalized string | `Manage Character Information` | modules\administration\module.lua | 115 |
| `Privilege.Name` | Unlocalized string | `Manage Characters` | modules\administration\module.lua | 120 |
| `Privilege.Name` | Unlocalized string | `Manage Doors` | modules\administration\module.lua | 125 |
| `Privilege.Name` | Unlocalized string | `Manage Flags` | modules\administration\module.lua | 130 |
| `Privilege.Name` | Unlocalized string | `Manage Administration Rooms` | modules\administration\module.lua | 135 |
| `Privilege.Name` | Unlocalized string | `Manage Transfers` | modules\administration\module.lua | 140 |
| `Privilege.Name` | Unlocalized string | `View Entity Tab` | modules\administration\module.lua | 145 |
| `Privilege.Name` | Unlocalized string | `Stop Sound For Everyone` | modules\administration\module.lua | 150 |
| `Privilege.Name` | Unlocalized string | `Use Disallowed Tools` | modules\administration\module.lua | 155 |
| `Privilege.Name` | Unlocalized string | `Can Bypass Character Lock` | modules\administration\module.lua | 160 |
| `Privilege.Name` | Unlocalized string | `Can Grab World Props` | modules\administration\module.lua | 165 |
| `Privilege.Name` | Unlocalized string | `Can Grab Players` | modules\administration\module.lua | 170 |
| `Privilege.Name` | Unlocalized string | `Physgun Pickup` | modules\administration\module.lua | 175 |
| `Privilege.Name` | Unlocalized string | `Physgun Pickup on Restricted Entities` | modules\administration\module.lua | 180 |
| `Privilege.Name` | Unlocalized string | `Physgun Pickup on Vehicles` | modules\administration\module.lua | 185 |
| `Privilege.Name` | Missing key | `Can` | modules\administration\module.lua | 190 |
| `Privilege.Name` | Unlocalized string | `Can Physgun Reload` | modules\administration\module.lua | 195 |
| `Privilege.Name` | Unlocalized string | `Noclip Outside Staff Character` | modules\administration\module.lua | 200 |
| `Privilege.Name` | Unlocalized string | `Noclip ESP Outside Staff Character` | modules\administration\module.lua | 205 |
| `Privilege.Name` | Unlocalized string | `Can Use PAC3` | modules\administration\module.lua | 210 |
| `Privilege.Name` | Unlocalized string | `Can Property World Entities` | modules\administration\module.lua | 215 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Ragdolls` | modules\administration\module.lua | 220 |
| `Privilege.Name` | Unlocalized string | `Can Spawn SWEPs` | modules\administration\module.lua | 225 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Effects` | modules\administration\module.lua | 230 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Props` | modules\administration\module.lua | 235 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Blacklisted Props` | modules\administration\module.lua | 240 |
| `Privilege.Name` | Unlocalized string | `Can Spawn NPCs` | modules\administration\module.lua | 245 |
| `Privilege.Name` | Unlocalized string | `No Car Spawn Delay` | modules\administration\module.lua | 250 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Cars` | modules\administration\module.lua | 255 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Blacklisted Cars` | modules\administration\module.lua | 260 |
| `Privilege.Name` | Unlocalized string | `Can Spawn SENTs` | modules\administration\module.lua | 265 |
| `Privilege.Name` | Unlocalized string | `Can Remove Blocked Entities` | modules\administration\module.lua | 270 |
| `Privilege.Name` | Unlocalized string | `Can Remove World Entities` | modules\administration\module.lua | 275 |
| `Privilege.Name` | Unlocalized string | `Use Position Tool` | modules\administration\module.lua | 280 |
| `Privilege.Name` | Unlocalized string | `Access to Blind Command` | modules\administration\module.lua | 285 |
| `Privilege.Name` | Unlocalized string | `Access to Mute Command` | modules\administration\module.lua | 290 |
| `Privilege.Name` | Unlocalized string | `Access to Goto Command` | modules\administration\module.lua | 295 |
| `Privilege.Name` | Unlocalized string | `Can Manage Dialog NPCs` | modules\administration\module.lua | 300 |
| `Privilege.Name` | Unlocalized string | `Can Manage Properties` | modules\administration\module.lua | 305 |
| `Privilege.Name` | Unlocalized string | `See Insert Notifications` | modules\administration\module.lua | 310 |
| `Privilege.Name` | Unlocalized string | `Admin Stick` | modules\administration\submodules\adminstick\module.lua | 1 |
| `Privilege.Name` | Unlocalized string | `Always Spawn w/ Admin Stick` | modules\administration\submodules\adminstick\module.lua | 8 |
| `Privilege.Name` | Missing key | `Logs` | modules\administration\submodules\logs\module.lua | 1 |
| `Privilege.Name` | Unlocalized string | `Can See Logs` | modules\administration\submodules\logs\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `View Ticket Claims` | modules\administration\submodules\tickets\commands.lua | 124 |
| `Privilege.Name` | Missing key | `Tickets` | modules\administration\submodules\tickets\module.lua | 1 |
| `Privilege.Name` | Unlocalized string | `Always See Tickets` | modules\administration\submodules\tickets\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Warn Player` | modules\administration\submodules\warnings\commands.lua | 21 |
| `Privilege.Name` | Unlocalized string | `View Player Warnings` | modules\administration\submodules\warnings\commands.lua | 81 |
| `Privilege.Name` | Missing key | `Warnings` | modules\administration\submodules\warnings\module.lua | 1 |
| `Privilege.Name` | Unlocalized string | `View Player Warnings` | modules\administration\submodules\warnings\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Can Remove Warns` | modules\administration\submodules\warnings\module.lua | 13 |
| `Privilege.Name` | Unlocalized string | `No OOC Cooldown` | modules\chatbox\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Admin Chat` | modules\chatbox\module.lua | 13 |
| `Privilege.Name` | Unlocalized string | `Local Event Chat` | modules\chatbox\module.lua | 18 |
| `Privilege.Name` | Unlocalized string | `Event Chat` | modules\chatbox\module.lua | 23 |
| `Privilege.Name` | Unlocalized string | `Always Have Access to Help Chat` | modules\chatbox\module.lua | 28 |
| `Privilege.Name` | Unlocalized string | `Bypass OOC Block` | modules\chatbox\module.lua | 33 |
| `Privilege.Name` | Unlocalized string | `Manage Chat Filter` | modules\chatbox\module.lua | 38 |
| `Privilege.Name` | Unlocalized string | `Sell Door` | modules\doors\commands.lua | 32 |
| `Privilege.Name` | Unlocalized string | `Admin Sell Door` | modules\doors\commands.lua | 65 |
| `Privilege.Name` | Unlocalized string | `Toggle Door State` | modules\doors\commands.lua | 146 |
| `Privilege.Name` | Unlocalized string | `Buy Door` | modules\doors\commands.lua | 198 |
| `Privilege.Name` | Unlocalized string | `Toggle Door Ownable` | modules\doors\commands.lua | 243 |
| `Privilege.Name` | Unlocalized string | `Reset Door Data` | modules\doors\commands.lua | 283 |
| `Privilege.Name` | Unlocalized string | `Toggle Door Enabled` | modules\doors\commands.lua | 316 |
| `Privilege.Name` | Unlocalized string | `Toggle Door Hidden` | modules\doors\commands.lua | 343 |
| `Privilege.Name` | Unlocalized string | `Set Door Price` | modules\doors\commands.lua | 376 |
| `Privilege.Name` | Unlocalized string | `Set Door Title` | modules\doors\commands.lua | 413 |
| `Privilege.Name` | Unlocalized string | `Save Doors` | modules\doors\commands.lua | 447 |
| `Privilege.Name` | Unlocalized string | `Get Door Information` | modules\doors\commands.lua | 463 |
| `Privilege.Name` | Unlocalized string | `Add Sample Data` | modules\doors\commands.lua | 542 |
| `Privilege.Name` | Unlocalized string | `Randomize Door Info` | modules\doors\commands.lua | 620 |
| `Privilege.Name` | Unlocalized string | `Return Items` | modules\inventory\commands.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Return All Items` | modules\inventory\commands.lua | 51 |
| `Privilege.Name` | Unlocalized string | `No item cooldown` | modules\inventory\module.lua | 7 |
| `Privilege.Name` | Unlocalized string | `Can Spawn Storage` | modules\inventory\types\gridinv\submodules\storage\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Force Recognition (Whisper)` | modules\recognition\commands.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Force Recognition (Normal)` | modules\recognition\commands.lua | 33 |
| `Privilege.Name` | Unlocalized string | `Force Recognition (Yell)` | modules\recognition\commands.lua | 54 |
| `Privilege.Name` | Unlocalized string | `Can Manage Factions` | modules\teams\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Manage Whitelists` | modules\teams\module.lua | 13 |
| `Privilege.Name` | Unlocalized string | `Reset Vendor Cooldowns` | modules\vendor\commands.lua | 122 |
| `Privilege.Name` | Unlocalized string | `Can Edit Vendors` | modules\vendor\module.lua | 8 |
| `Privilege.Name` | Unlocalized string | `Can Create Vendor Presets` | modules\vendor\module.lua | 13 |
| `Privilege.Name` | Missing key | `Lilia` | shared.lua | 8 |
| `data.category` | Unlocalized string | `Color for category elements and tabs.` | core\derma\panels\f1menu.lua | 2346 |
| `data.category` | Missing key | `attachments` | core\libraries\compatibility\arccw\core.lua | 19 |
| `data.category` | Missing key | `attachments` | core\libraries\compatibility\arccw\items\base\arccw_att.lua | 3 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\pac\core.lua | 200 |
| `data.category` | Missing key | `outfit` | core\libraries\compatibility\pac\items\base\pacoutfit.lua | 4 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\sam\core.lua | 289 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\sam\core.lua | 295 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\simfphys\core.lua | 154 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\simfphys\core.lua | 160 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\simfphys\core.lua | 166 |
| `data.category` | Missing key | `Core` | core\libraries\compatibility\simfphys\core.lua | 180 |
| `data.category` | Missing key | `Permissions` | core\libraries\core\admin\core.lua | 62 |
| `data.category` | Missing key | `Permissions` | core\libraries\core\admin\core.lua | 77 |
| `data.category` | Missing key | `staffPermissions` | core\libraries\core\admin\core.lua | 271 |
| `data.category` | Missing key | `staffPermissions` | core\libraries\core\admin\core.lua | 275 |
| `data.category` | Missing key | `staffPermissions` | core\libraries\core\admin\core.lua | 279 |
| `data.category` | Missing key | `compatibility` | core\libraries\core\admin\core.lua | 283 |
| `data.category` | Missing key | `compatibility` | core\libraries\core\admin\core.lua | 287 |
| `data.category` | Missing key | `compatibility` | core\libraries\core\admin\core.lua | 291 |
| `data.category` | Missing key | `compatibility` | core\libraries\core\admin\core.lua | 295 |
| `data.category` | Missing key | `exploiting` | core\libraries\core\admin\core.lua | 299 |
| `data.category` | Missing key | `staffPermissions` | core\libraries\core\admin\core.lua | 303 |
| `data.category` | Unlocalized string | `Staff Permissions` | core\libraries\core\admin\core.lua | 311 |
| `data.category` | Missing key | `Unassigned` | core\libraries\core\admin\core.lua | 341 |
| `data.category` | Missing key | `Core` | core\libraries\core\color\core.lua | 581 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 961 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 970 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 976 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 984 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 990 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 996 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1006 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1014 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1020 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1026 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1032 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1040 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1048 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1060 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1068 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1076 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1082 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1090 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1098 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1106 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1114 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1122 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1130 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1136 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1144 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1150 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1156 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1162 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1168 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1174 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1180 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1186 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1192 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1198 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1207 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1215 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1221 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1229 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1237 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1255 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1262 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1269 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1275 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1283 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1289 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1297 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1306 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1314 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1323 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1332 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1341 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1348 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1357 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1366 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1375 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1383 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1392 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1400 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1408 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1417 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1423 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1431 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1439 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1447 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1455 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1463 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1471 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1477 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1483 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1489 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1497 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1503 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1509 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1515 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1521 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1527 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1533 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1539 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1545 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1553 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1561 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1567 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1573 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1581 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1587 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1593 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1599 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1605 |
| `data.category` | Missing key | `Performance` | core\libraries\core\config\core.lua | 1613 |
| `data.category` | Missing key | `Performance` | core\libraries\core\config\core.lua | 1619 |
| `data.category` | Missing key | `Performance` | core\libraries\core\config\core.lua | 1625 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1631 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1637 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1645 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1653 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1661 |
| `data.category` | Missing key | `fonts` | core\libraries\core\config\core.lua | 1667 |
| `data.category` | Missing key | `Gameplay` | core\libraries\core\config\core.lua | 1677 |
| `data.category` | Missing key | `Gameplay` | core\libraries\core\config\core.lua | 1683 |
| `data.category` | Missing key | `Gameplay` | core\libraries\core\config\core.lua | 1689 |
| `data.category` | Missing key | `Gameplay` | core\libraries\core\config\core.lua | 1695 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1701 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1707 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1715 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1723 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1729 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1735 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1741 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1747 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1753 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1763 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1771 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1779 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1786 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1792 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1798 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1804 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1822 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1836 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1844 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1851 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1857 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1863 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1869 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1875 |
| `data.category` | Missing key | `Core` | core\libraries\core\config\core.lua | 1883 |
| `data.category` | Unlocalized string | `VARCHAR(255)` | core\libraries\core\database\core.lua | 563 |
| `data.category` | Missing key | `Core` | core\libraries\core\fonts\core.lua | 368 |
| `data.category` | Missing key | `__all` | core\libraries\core\item\core.lua | 865 |
| `data.category` | Missing key | `entities` | core\libraries\core\item\core.lua | 1469 |
| `data.category` | Missing key | `storage` | core\libraries\core\item\core.lua | 1479 |
| `data.category` | Missing key | `inventory` | core\libraries\core\keybind\core.lua | 1127 |
| `data.category` | Missing key | `Core` | core\libraries\core\keybind\core.lua | 1246 |
| `data.category` | Missing key | `Core` | core\libraries\core\keybind\core.lua | 1257 |
| `data.category` | Missing key | `Camera` | core\libraries\core\keybind\core.lua | 1268 |
| `data.category` | Missing key | `menu` | core\libraries\core\keybind\core.lua | 2022 |
| `data.category` | Missing key | `Uncategorized` | core\libraries\core\logger\core.lua | 261 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 813 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 820 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 825 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 830 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 835 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 840 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 853 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 866 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 879 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 892 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 910 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 927 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 944 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 956 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 974 |
| `data.category` | Missing key | `ESP` | core\libraries\core\option\core.lua | 991 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 1003 |
| `data.category` | Unlocalized string | `Third Person` | core\libraries\core\option\core.lua | 1008 |
| `data.category` | Unlocalized string | `Third Person` | core\libraries\core\option\core.lua | 1013 |
| `data.category` | Unlocalized string | `Third Person` | core\libraries\core\option\core.lua | 1018 |
| `data.category` | Unlocalized string | `Third Person` | core\libraries\core\option\core.lua | 1025 |
| `data.category` | Unlocalized string | `Third Person` | core\libraries\core\option\core.lua | 1032 |
| `data.category` | Missing key | `Camera` | core\libraries\core\option\core.lua | 1039 |
| `data.category` | Missing key | `Camera` | core\libraries\core\option\core.lua | 1045 |
| `data.category` | Missing key | `Camera` | core\libraries\core\option\core.lua | 1051 |
| `data.category` | Missing key | `Camera` | core\libraries\core\option\core.lua | 1058 |
| `data.category` | Missing key | `Camera` | core\libraries\core\option\core.lua | 1065 |
| `data.category` | Missing key | `Camera` | core\libraries\core\option\core.lua | 1073 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 1078 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1083 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1088 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1093 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1098 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1103 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1108 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1113 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1118 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1123 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1128 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1133 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1140 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1145 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1152 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1159 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1164 |
| `data.category` | Missing key | `Performance` | core\libraries\core\option\core.lua | 1172 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 1177 |
| `data.category` | Missing key | `Core` | core\libraries\core\option\core.lua | 1183 |
| `data.category` | Missing key | `Voice` | core\libraries\core\playerinteract\core.lua | 200 |
| `data.category` | Missing key | `Voice` | core\libraries\core\playerinteract\core.lua | 211 |
| `data.category` | Missing key | `Voice` | core\libraries\core\playerinteract\core.lua | 222 |
| `data.category` | Missing key | `Base` | core\libraries\loader.lua | 354 |
| `data.category` | Missing key | `Base` | core\libraries\loader.lua | 373 |
| `data.category` | Missing key | `itemCatAmmunition` | items\base\ammo.lua | 6 |
| `data.category` | Missing key | `itemCatLiterature` | items\base\books.lua | 3 |
| `data.category` | Missing key | `entities` | items\base\entities.lua | 4 |
| `data.category` | Missing key | `itemCatGrenades` | items\base\grenade.lua | 3 |
| `data.category` | Missing key | `outfit` | items\base\outfit.lua | 3 |
| `data.category` | Missing key | `weapons` | items\base\weapons.lua | 3 |
| `data.category` | Missing key | `moderation` | modules\administration\submodules\adminstick\libraries\client.lua | 1178 |
| `data.category` | Missing key | `storageManagement` | modules\administration\submodules\adminstick\libraries\client.lua | 1204 |
| `data.category` | Unlocalized string | `.. lia.db.convertDataType(category),` | modules\administration\submodules\logs\libraries\server.lua | 16 |
| `data.category` | Missing key | `doorManagement` | modules\doors\libraries\client.lua | 308 |
| `data.category` | Missing key | `doorManagement` | modules\doors\libraries\client.lua | 330 |
| `data.category` | Missing key | `doorManagement` | modules\doors\libraries\client.lua | 359 |
| `data.category` | Missing key | `doorManagement` | modules\doors\libraries\client.lua | 390 |
| `data.category` | Missing key | `Core` | modules\inventory\types\gridinv\config.lua | 22 |
| `data.category` | Missing key | `Core` | modules\inventory\types\gridinv\config.lua | 49 |
| `data.category` | Missing key | `Core` | modules\inventory\types\gridinv\config.lua | 57 |
| `data.category` | Missing key | `Core` | modules\inventory\types\gridinv\config.lua | 65 |
| `data.category` | Missing key | `Storage` | modules\inventory\types\gridinv\items\base\bags.lua | 4 |
| `data.category` | Missing key | `Core` | modules\inventory\types\weightinv\config.lua | 3 |
| `data.category` | Missing key | `Core` | modules\inventory\types\weightinv\config.lua | 11 |
| `data.category` | Missing key | `Core` | modules\inventory\types\weightinv\config.lua | 36 |
| `data.category` | Missing key | `Core` | modules\inventory\types\weightinv\config.lua | 63 |
| `data.category` | Missing key | `Core` | modules\inventory\types\weightinv\config.lua | 71 |
| `data.category` | Missing key | `Core` | modules\inventory\types\weightinv\config.lua | 79 |
| `data.category` | Missing key | `Storage` | modules\inventory\types\weightinv\items\base\bags.lua | 4 |
| `data.category` | Missing key | `Recognition` | modules\recognition\libraries\server.lua | 81 |
| `data.category` | Missing key | `Recognition` | modules\recognition\libraries\server.lua | 88 |
| `data.category` | Missing key | `Recognition` | modules\recognition\libraries\server.lua | 95 |
| `data.category` | Missing key | `Recognition` | modules\recognition\libraries\server.lua | 102 |
| `data.category` | Unlocalized string | `Faction Management` | modules\teams\libraries\server.lua | 509 |
| `data.category` | Unlocalized string | `Faction Management` | modules\teams\libraries\server.lua | 562 |
| `data.desc` | Missing key | `arccwAttachmentDesc` | core\libraries\compatibility\arccw\items\base\arccw_att.lua | 2 |
| `data.desc` | Unlocalized string | `Clears PAC3 caches and restarts PAC3 to fix any outfit issues.` | core\libraries\compatibility\pac\core.lua | 165 |
| `data.desc` | Unlocalized string | `Enables PAC3 (Player Appearance Customizer).` | core\libraries\compatibility\pac\core.lua | 182 |
| `data.desc` | Unlocalized string | `Disables PAC3 (Player Appearance Customizer).` | core\libraries\compatibility\pac\core.lua | 191 |
| `data.desc` | Unlocalized string | `Determines whether loading PAC3 packs from a URL should be blocked.` | core\libraries\compatibility\pac\core.lua | 199 |
| `data.desc` | Missing key | `pacoutfitDesc` | core\libraries\compatibility\pac\items\base\pacoutfit.lua | 3 |
| `data.desc` | Unlocalized string | `Clears all decals (blood, bullet holes, etc.) for every player.` | core\libraries\compatibility\sam\core.lua | 279 |
| `data.desc` | Unlocalized string | `Restricts certain notifications to admins with specific permissions or those on duty.` | core\libraries\compatibility\sam\core.lua | 288 |
| `data.desc` | Unlocalized string | `Determines whether staff enforcement for SAM commands is enabled` | core\libraries\compatibility\sam\core.lua | 294 |
| `data.desc` | Unlocalized string | `Whether or not you take damage while in cars` | core\libraries\compatibility\simfphys\core.lua | 153 |
| `data.desc` | Unlocalized string | `Whether entering a vehicle requires a delay.` | core\libraries\compatibility\simfphys\core.lua | 159 |
| `data.desc` | Unlocalized string | `Defines the time to enter vehicle.` | core\libraries\compatibility\simfphys\core.lua | 165 |
| `data.desc` | Unlocalized string | `Removes the simfphys HUD. This only applies after a Lua refresh or server restart.` | core\libraries\compatibility\simfphys\core.lua | 179 |
| `data.desc` | Unlocalized string | `Usergroup assigned to players when Lilia does not already have one stored for their SteamID.` | core\libraries\core\admin\core.lua | 61 |
| `data.desc` | Unlocalized string | `Displays icon16 usergroup icons in OOC/LOOC messages and usergroup tabs.` | core\libraries\core\admin\core.lua | 76 |
| `data.desc` | Unlocalized string | `Displays your current character` | core\libraries\core\character\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Return to your last recorded death position.` | core\libraries\core\character\commands.lua | 18 |
| `data.desc` | Unlocalized string | `Force another player to fall over (go into ragdoll).` | core\libraries\core\character\commands.lua | 37 |
| `data.desc` | Unlocalized string | `Force another player to get up from ragdoll.` | core\libraries\core\character\commands.lua | 70 |
| `data.desc` | Unlocalized string | `Change your character` | core\libraries\core\character\commands.lua | 100 |
| `data.desc` | Unlocalized string | `Force yourself to get up from ragdoll (if possible).` | core\libraries\core\character\commands.lua | 127 |
| `data.desc` | Unlocalized string | `Fall over (ragdoll) for a certain duration.` | core\libraries\core\character\commands.lua | 146 |
| `data.desc` | Unlocalized string | `No Description` | core\libraries\core\classes\core.lua | 98 |
| `data.desc` | Unlocalized string | `Selects the visual theme for the user interface.` | core\libraries\core\color\core.lua | 580 |
| `data.desc` | Unlocalized string | `Displays your total playtime on the server.` | core\libraries\core\commands\core.lua | 1307 |
| `data.desc` | Unlocalized string | `Rolls a dice and displays the result.` | core\libraries\core\commands\core.lua | 1326 |
| `data.desc` | Unlocalized string | `How many days until you can change your main character again. Set to 0 to allow changes at any time.` | core\libraries\core\config\core.lua | 965 |
| `data.desc` | Unlocalized string | `Defines the model used for representing money in the game.` | core\libraries\core\config\core.lua | 969 |
| `data.desc` | Unlocalized string | `Maximum number of money entities that can be dropped at once.` | core\libraries\core\config\core.lua | 975 |
| `data.desc` | Unlocalized string | `Specifies the currency symbol used in the game.` | core\libraries\core\config\core.lua | 983 |
| `data.desc` | Unlocalized string | `Singular name of the in-game currency.` | core\libraries\core\config\core.lua | 989 |
| `data.desc` | Unlocalized string | `Plural name of the in-game currency.` | core\libraries\core\config\core.lua | 995 |
| `data.desc` | Unlocalized string | `Controls how fast characters walk.` | core\libraries\core\config\core.lua | 1005 |
| `data.desc` | Unlocalized string | `Enable or disable death sounds globally.` | core\libraries\core\config\core.lua | 1013 |
| `data.desc` | Unlocalized string | `Enable or disable pain sounds globally.` | core\libraries\core\config\core.lua | 1019 |
| `data.desc` | Unlocalized string | `Enable or disable fall damage globally.` | core\libraries\core\config\core.lua | 1025 |
| `data.desc` | Unlocalized string | `Sets the damage multiplier for limb hits.` | core\libraries\core\config\core.lua | 1031 |
| `data.desc` | Unlocalized string | `Scales all damage dealt by this multiplier.` | core\libraries\core\config\core.lua | 1039 |
| `data.desc` | Unlocalized string | `Sets the damage multiplier for headshots.` | core\libraries\core\config\core.lua | 1047 |
| `data.desc` | Unlocalized string | `Controls how fast characters run.` | core\libraries\core\config\core.lua | 1059 |
| `data.desc` | Unlocalized string | `Sets the maximum number of characters a player can have.` | core\libraries\core\config\core.lua | 1067 |
| `data.desc` | Unlocalized string | `Determines whether private messages are allowed.` | core\libraries\core\config\core.lua | 1075 |
| `data.desc` | Unlocalized string | `Minimum length required for a character` | core\libraries\core\config\core.lua | 1081 |
| `data.desc` | Unlocalized string | `Specifies the default amount of money a player starts with.` | core\libraries\core\config\core.lua | 1089 |
| `data.desc` | Unlocalized string | `Time interval between data saves.` | core\libraries\core\config\core.lua | 1097 |
| `data.desc` | Unlocalized string | `Time interval between character data saves.` | core\libraries\core\config\core.lua | 1105 |
| `data.desc` | Unlocalized string | `Time to respawn after death.` | core\libraries\core\config\core.lua | 1113 |
| `data.desc` | Unlocalized string | `Defines the time to enter vehicle.` | core\libraries\core\config\core.lua | 1121 |
| `data.desc` | Unlocalized string | `Whether entering a vehicle requires a delay.` | core\libraries\core\config\core.lua | 1129 |
| `data.desc` | Unlocalized string | `Sets the maximum length of chat messages.` | core\libraries\core\config\core.lua | 1135 |
| `data.desc` | Unlocalized string | `When enabled, all doors will be disabled by default when the server loads.` | core\libraries\core\config\core.lua | 1143 |
| `data.desc` | Unlocalized string | `Specifies if the logging system should replicate to super admins` | core\libraries\core\config\core.lua | 1149 |
| `data.desc` | Unlocalized string | `Whether background input is disabled during character menu use` | core\libraries\core\config\core.lua | 1155 |
| `data.desc` | Unlocalized string | `Allow players to edit their keybinds in the settings menu.` | core\libraries\core\config\core.lua | 1161 |
| `data.desc` | Unlocalized string | `Enables the crosshair.` | core\libraries\core\config\core.lua | 1167 |
| `data.desc` | Unlocalized string | `Enables automatic conversion of dropped weapons into inventory items.` | core\libraries\core\config\core.lua | 1173 |
| `data.desc` | Unlocalized string | `Enables automatic conversion of ammo entities into inventory items.` | core\libraries\core\config\core.lua | 1179 |
| `data.desc` | Unlocalized string | `Enables whether or not items can be destroyed.` | core\libraries\core\config\core.lua | 1185 |
| `data.desc` | Unlocalized string | `Enables ammo display.` | core\libraries\core\config\core.lua | 1191 |
| `data.desc` | Unlocalized string | `Whether or not voice chat is enabled.` | core\libraries\core\config\core.lua | 1197 |
| `data.desc` | Unlocalized string | `Interval in seconds between salary payouts.` | core\libraries\core\config\core.lua | 1206 |
| `data.desc` | Unlocalized string | `Allows players to toggle third-person view on or off.` | core\libraries\core\config\core.lua | 1214 |
| `data.desc` | Unlocalized string | `Caps how far the third-person camera can be moved away from the character.` | core\libraries\core\config\core.lua | 1220 |
| `data.desc` | Unlocalized string | `Caps how far left or right the third-person camera can be offset from the character.` | core\libraries\core\config\core.lua | 1228 |
| `data.desc` | Unlocalized string | `Caps how high the third-person camera can be offset above the character.` | core\libraries\core\config\core.lua | 1236 |
| `data.desc` | Unlocalized string | `Select the Derma UI skin to use.` | core\libraries\core\config\core.lua | 1254 |
| `data.desc` | Unlocalized string | `Determines the language setting for the game.` | core\libraries\core\config\core.lua | 1261 |
| `data.desc` | Unlocalized string | `Determines if the spawn menu is limited to PET flag holders or staff` | core\libraries\core\config\core.lua | 1268 |
| `data.desc` | Unlocalized string | `Determines how many days of logs should be read.` | core\libraries\core\config\core.lua | 1274 |
| `data.desc` | Unlocalized string | `Is Stamina Slowdown Enabled?` | core\libraries\core\config\core.lua | 1282 |
| `data.desc` | Unlocalized string | `Sets default stamina value.` | core\libraries\core\config\core.lua | 1288 |
| `data.desc` | Unlocalized string | `Maximum number of points that can be allocated across an attribute.` | core\libraries\core\config\core.lua | 1296 |
| `data.desc` | Unlocalized string | `Stamina cost deducted when the player jumps.` | core\libraries\core\config\core.lua | 1305 |
| `data.desc` | Unlocalized string | `Maximum value of each attribute at character creation.` | core\libraries\core\config\core.lua | 1313 |
| `data.desc` | Unlocalized string | `Total number of points available for starting attribute allocation.` | core\libraries\core\config\core.lua | 1322 |
| `data.desc` | Unlocalized string | `How much stamina is consumed per punch.` | core\libraries\core\config\core.lua | 1331 |
| `data.desc` | Unlocalized string | `Whether punches can kill players or just knock them out.` | core\libraries\core\config\core.lua | 1340 |
| `data.desc` | Unlocalized string | `The rate at which stamina drains.` | core\libraries\core\config\core.lua | 1347 |
| `data.desc` | Unlocalized string | `The rate at which stamina regenerates.` | core\libraries\core\config\core.lua | 1356 |
| `data.desc` | Unlocalized string | `The rate at which stamina regenerates while crouching.` | core\libraries\core\config\core.lua | 1365 |
| `data.desc` | Unlocalized string | `Number of log entries to display per page in the administration logs interface` | core\libraries\core\config\core.lua | 1374 |
| `data.desc` | Unlocalized string | `Duration in seconds that players are ragdolled when punched while lethality is disabled.` | core\libraries\core\config\core.lua | 1382 |
| `data.desc` | Unlocalized string | `The maximum weight that a player can carry in their hands.` | core\libraries\core\config\core.lua | 1391 |
| `data.desc` | Unlocalized string | `How hard a player can throw the item that they` | core\libraries\core\config\core.lua | 1399 |
| `data.desc` | Unlocalized string | `Minimum playtime in seconds required to punch.` | core\libraries\core\config\core.lua | 1407 |
| `data.desc` | Unlocalized string | `Change chat sound on message send.` | core\libraries\core\config\core.lua | 1416 |
| `data.desc` | Unlocalized string | `Base range for all talk-based chat modes (whisper, normal, yell).` | core\libraries\core\config\core.lua | 1422 |
| `data.desc` | Unlocalized string | `Range at which whisper chat can be heard.` | core\libraries\core\config\core.lua | 1430 |
| `data.desc` | Unlocalized string | `Range at which yell chat can be heard.` | core\libraries\core\config\core.lua | 1438 |
| `data.desc` | Unlocalized string | `Limit of characters in OOC.` | core\libraries\core\config\core.lua | 1446 |
| `data.desc` | Unlocalized string | `Set OOC text delay.` | core\libraries\core\config\core.lua | 1454 |
| `data.desc` | Unlocalized string | `Set LOOC text delay.` | core\libraries\core\config\core.lua | 1462 |
| `data.desc` | Unlocalized string | `Should admins have LOOC delay.` | core\libraries\core\config\core.lua | 1470 |
| `data.desc` | Unlocalized string | `Whether or not out-of-character chat is globally blocked.` | core\libraries\core\config\core.lua | 1476 |
| `data.desc` | Unlocalized string | `Enable different chat size.` | core\libraries\core\config\core.lua | 1482 |
| `data.desc` | Unlocalized string | `The volume level for the main menu music` | core\libraries\core\config\core.lua | 1488 |
| `data.desc` | Unlocalized string | `The file path or URL for the main menu background music` | core\libraries\core\config\core.lua | 1496 |
| `data.desc` | Unlocalized string | `The URL or file path for the main menu background image` | core\libraries\core\config\core.lua | 1502 |
| `data.desc` | Unlocalized string | `The file path or URL for the server logo displayed on the main menu and scoreboard` | core\libraries\core\config\core.lua | 1508 |
| `data.desc` | Unlocalized string | `Enable or disable the server logo display on the main menu` | core\libraries\core\config\core.lua | 1514 |
| `data.desc` | Unlocalized string | `Discord server URL for the main menu` | core\libraries\core\config\core.lua | 1520 |
| `data.desc` | Unlocalized string | `Workshop collection URL for the main menu` | core\libraries\core\config\core.lua | 1526 |
| `data.desc` | Unlocalized string | `Whether background input is disabled during character menu use` | core\libraries\core\config\core.lua | 1532 |
| `data.desc` | Unlocalized string | `If true, character switch cooldowns gets applied by all types of damage.` | core\libraries\core\config\core.lua | 1538 |
| `data.desc` | Unlocalized string | `Cooldown duration (in seconds) after taking damage to switch characters.` | core\libraries\core\config\core.lua | 1544 |
| `data.desc` | Unlocalized string | `Cooldown duration (in seconds) for switching characters.` | core\libraries\core\config\core.lua | 1552 |
| `data.desc` | Unlocalized string | `Determines whether being hit by an explosion results in ragdolling` | core\libraries\core\config\core.lua | 1560 |
| `data.desc` | Unlocalized string | `Determines whether being hit by a car results in ragdolling` | core\libraries\core\config\core.lua | 1566 |
| `data.desc` | Unlocalized string | `Specifies the duration (in seconds) until a dropped SWEP is removed` | core\libraries\core\config\core.lua | 1572 |
| `data.desc` | Unlocalized string | `Whether or not alting is permitted` | core\libraries\core\config\core.lua | 1580 |
| `data.desc` | Unlocalized string | `Determines whether acts are active` | core\libraries\core\config\core.lua | 1586 |
| `data.desc` | Unlocalized string | `Enables prop crash prevention behaviors (physgun pickup/drop collision safety and freeze pass-through).` | core\libraries\core\config\core.lua | 1592 |
| `data.desc` | Unlocalized string | `Makes it so that props frozen can be passed through when frozen` | core\libraries\core\config\core.lua | 1598 |
| `data.desc` | Unlocalized string | `Delay for spawning a vehicle after the previous one` | core\libraries\core\config\core.lua | 1604 |
| `data.desc` | Unlocalized string | `Whether or not the mouth movement animation is enabled.` | core\libraries\core\config\core.lua | 1612 |
| `data.desc` | Unlocalized string | `Whether or not the grab ear animation is enabled.` | core\libraries\core\config\core.lua | 1618 |
| `data.desc` | Unlocalized string | `Whether or not the default voice icons are shown.` | core\libraries\core\config\core.lua | 1624 |
| `data.desc` | Unlocalized string | `Whether or not Lilia should prevent lua_run hooks on maps` | core\libraries\core\config\core.lua | 1630 |
| `data.desc` | Unlocalized string | `Time delay between equipping items.` | core\libraries\core\config\core.lua | 1636 |
| `data.desc` | Unlocalized string | `Time delay between unequipping items.` | core\libraries\core\config\core.lua | 1644 |
| `data.desc` | Unlocalized string | `Time delay between dropping items.` | core\libraries\core\config\core.lua | 1652 |
| `data.desc` | Unlocalized string | `When enabled, all items dropped by a player will be deleted when they disconnect.` | core\libraries\core\config\core.lua | 1660 |
| `data.desc` | Unlocalized string | `Font used for HUD-painted text and overlays.` | core\libraries\core\config\core.lua | 1666 |
| `data.desc` | Unlocalized string | `Model used for the bodygrouper entity.` | core\libraries\core\config\core.lua | 1676 |
| `data.desc` | Unlocalized string | `Specifies the model path for the wardrobe entity.` | core\libraries\core\config\core.lua | 1682 |
| `data.desc` | Unlocalized string | `Determines whether faction models are enabled for the wardrobe entity.` | core\libraries\core\config\core.lua | 1688 |
| `data.desc` | Unlocalized string | `Determines whether class models are enabled for the wardrobe entity.` | core\libraries\core\config\core.lua | 1694 |
| `data.desc` | Unlocalized string | `When enabled, all entities created by a player (except lia_ entities) will be deleted when they disconnect.` | core\libraries\core\config\core.lua | 1700 |
| `data.desc` | Unlocalized string | `Time delay between taking items.` | core\libraries\core\config\core.lua | 1706 |
| `data.desc` | Unlocalized string | `How fast transferring items between players via giveForward is.` | core\libraries\core\config\core.lua | 1714 |
| `data.desc` | Unlocalized string | `Determines if item giving via giveForward is enabled.` | core\libraries\core\config\core.lua | 1722 |
| `data.desc` | Unlocalized string | `Determine if items marked for loss are lost on death by NPCs.` | core\libraries\core\config\core.lua | 1728 |
| `data.desc` | Unlocalized string | `Determine if items marked for loss are lost on death by humans.` | core\libraries\core\config\core.lua | 1734 |
| `data.desc` | Unlocalized string | `Determine if items marked for loss are lost on death by the world.` | core\libraries\core\config\core.lua | 1740 |
| `data.desc` | Unlocalized string | `Enable or disable the death information popup.` | core\libraries\core\config\core.lua | 1746 |
| `data.desc` | Unlocalized string | `Whether or not classes are displayed on characters.` | core\libraries\core\config\core.lua | 1752 |
| `data.desc` | Unlocalized string | `Scoreboard width proportion` | core\libraries\core\config\core.lua | 1762 |
| `data.desc` | Unlocalized string | `Scoreboard height proportion` | core\libraries\core\config\core.lua | 1770 |
| `data.desc` | Unlocalized string | `Determines where the scoreboard appears on screen` | core\libraries\core\config\core.lua | 1778 |
| `data.desc` | Unlocalized string | `Should class headers exist?` | core\libraries\core\config\core.lua | 1785 |
| `data.desc` | Unlocalized string | `Whether or not character recognition is enabled?` | core\libraries\core\config\core.lua | 1791 |
| `data.desc` | Unlocalized string | `Are fake names enabled?` | core\libraries\core\config\core.lua | 1797 |
| `data.desc` | Unlocalized string | `Default amount of money vendors start with` | core\libraries\core\config\core.lua | 1803 |
| `data.desc` | Unlocalized string | `Specifies which tab is opened by default when the menu is shown.` | core\libraries\core\config\core.lua | 1821 |
| `data.desc` | Unlocalized string | `Time delay for door lock/unlock actions` | core\libraries\core\config\core.lua | 1835 |
| `data.desc` | Unlocalized string | `Percentage you can sell a door for` | core\libraries\core\config\core.lua | 1843 |
| `data.desc` | Unlocalized string | `Uses the character` | core\libraries\core\config\core.lua | 1850 |
| `data.desc` | Unlocalized string | `Display timestamps in 12-hour AM/PM format instead of 24-hour format.` | core\libraries\core\config\core.lua | 1856 |
| `data.desc` | Unlocalized string | `The primary accent color used throughout the UI.` | core\libraries\core\config\core.lua | 1862 |
| `data.desc` | Unlocalized string | `Grants god mode to staff members while they are on duty.` | core\libraries\core\config\core.lua | 1868 |
| `data.desc` | Unlocalized string | `Adjust the description width on the HUD` | core\libraries\core\config\core.lua | 1874 |
| `data.desc` | Unlocalized string | `The maximum total number of attribute points a character can have.` | core\libraries\core\config\core.lua | 1882 |
| `data.desc` | Missing key | `LONGTEXT` | core\libraries\core\database\core.lua | 517 |
| `data.desc` | Unlocalized string | `No Description` | core\libraries\core\factions\core.lua | 125 |
| `data.desc` | Unlocalized string | `The Staff` | core\libraries\core\factions\core.lua | 462 |
| `data.desc` | Unlocalized string | `Font Description` | core\libraries\core\fonts\core.lua | 367 |
| `data.desc` | Unlocalized string | `No Description` | core\libraries\core\item\core.lua | 235 |
| `data.desc` | Unlocalized string | `No Description` | core\libraries\core\item\core.lua | 255 |
| `data.desc` | Unlocalized string | `A placeable ammo box that refills the weapon you are holding.` | core\libraries\core\item\core.lua | 1467 |
| `data.desc` | Unlocalized string | `A medium-sized backpack with enough space for extra supplies.` | core\libraries\core\item\core.lua | 1477 |
| `data.desc` | Unlocalized string | `A Weapon.` | core\libraries\core\item\netcalls.lua | 84 |
| `data.desc` | Unlocalized string | `Opens your inventory menu` | core\libraries\core\keybind\core.lua | 1120 |
| `data.desc` | Unlocalized string | `Open the standalone quick inventory.` | core\libraries\core\keybind\core.lua | 1126 |
| `data.desc` | Unlocalized string | `Toggles admin mode to switch between staff and regular character` | core\libraries\core\keybind\core.lua | 1147 |
| `data.desc` | Unlocalized string | `Quickly takes an item from the world when looking at it` | core\libraries\core\keybind\core.lua | 1230 |
| `data.desc` | Unlocalized string | `Opens the interaction menu for nearby players and entities` | core\libraries\core\keybind\core.lua | 1245 |
| `data.desc` | Unlocalized string | `Opens the personal actions menu` | core\libraries\core\keybind\core.lua | 1256 |
| `data.desc` | Unlocalized string | `Hold Freelook` | core\libraries\core\keybind\core.lua | 1267 |
| `data.desc` | Unlocalized string | `Converts a world entity into an item` | core\libraries\core\keybind\core.lua | 1275 |
| `data.desc` | Unlocalized string | `No Description` | core\libraries\core\modularity\core.lua | 161 |
| `data.desc` | Missing key | `aidDesc` | items\base\aid.lua | 2 |
| `data.desc` | Missing key | `booksDesc` | items\base\books.lua | 2 |
| `data.desc` | Missing key | `entitiesDesc` | items\base\entities.lua | 3 |
| `data.desc` | Missing key | `grenadeDesc` | items\base\grenade.lua | 2 |
| `data.desc` | Missing key | `outfitDesc` | items\base\outfit.lua | 2 |
| `data.desc` | Missing key | `urlDesc` | items\base\url.lua | 2 |
| `data.desc` | Missing key | `weaponsDesc` | items\base\weapons.lua | 2 |
| `data.desc` | Unlocalized string | `Shows the total playtime of the specified character.` | modules\administration\commands.lua | 328 |
| `data.desc` | Unlocalized string | `Shows the character ID of the specified player.` | modules\administration\commands.lua | 362 |
| `data.desc` | Unlocalized string | `Displays your current character` | modules\administration\commands.lua | 387 |
| `data.desc` | Unlocalized string | `Manage administration rooms on the current map: view existing administration rooms, teleport to them, rename them, or reposition them.` | modules\administration\commands.lua | 402 |
| `data.desc` | Unlocalized string | `Set Administration Room` | modules\administration\commands.lua | 415 |
| `data.desc` | Unlocalized string | `Send a player to an Administration Room` | modules\administration\commands.lua | 434 |
| `data.desc` | Unlocalized string | `Returns you or the specified player to their previous position before teleporting to an administration room.` | modules\administration\commands.lua | 481 |
| `data.desc` | Unlocalized string | `Opens the PK case menu to permanently kill a character.` | modules\administration\commands.lua | 516 |
| `data.desc` | Unlocalized string | `Ban a player from the server for a duration.` | modules\administration\commands.lua | 596 |
| `data.desc` | Unlocalized string | `Kick a player from the server.` | modules\administration\commands.lua | 622 |
| `data.desc` | Unlocalized string | `Kill the specified player.` | modules\administration\commands.lua | 644 |
| `data.desc` | Unlocalized string | `Remove a player` | modules\administration\commands.lua | 661 |
| `data.desc` | Unlocalized string | `Freeze a player for an optional duration.` | modules\administration\commands.lua | 680 |
| `data.desc` | Unlocalized string | `Unfreeze a player.` | modules\administration\commands.lua | 697 |
| `data.desc` | Unlocalized string | `Slay a player instantly.` | modules\administration\commands.lua | 709 |
| `data.desc` | Unlocalized string | `Blind a player with a black screen.` | modules\administration\commands.lua | 721 |
| `data.desc` | Unlocalized string | `Remove blindness from a player.` | modules\administration\commands.lua | 738 |
| `data.desc` | Unlocalized string | `Fade a player` | modules\administration\commands.lua | 750 |
| `data.desc` | Unlocalized string | `Fade all non-staff players` | modules\administration\commands.lua | 809 |
| `data.desc` | Unlocalized string | `Gag a player, blocking voice chat.` | modules\administration\commands.lua | 855 |
| `data.desc` | Unlocalized string | `Ungag a player.` | modules\administration\commands.lua | 867 |
| `data.desc` | Unlocalized string | `Mute a player` | modules\administration\commands.lua | 879 |
| `data.desc` | Unlocalized string | `Unmute a player` | modules\administration\commands.lua | 891 |
| `data.desc` | Unlocalized string | `Teleport a player to you.` | modules\administration\commands.lua | 903 |
| `data.desc` | Unlocalized string | `Teleport yourself to a player.` | modules\administration\commands.lua | 915 |
| `data.desc` | Unlocalized string | `Return a player to their previous position.` | modules\administration\commands.lua | 927 |
| `data.desc` | Unlocalized string | `Jail a player by locking and freezing them.` | modules\administration\commands.lua | 940 |
| `data.desc` | Unlocalized string | `Release a jailed player.` | modules\administration\commands.lua | 952 |
| `data.desc` | Unlocalized string | `Make a player invisible.` | modules\administration\commands.lua | 964 |
| `data.desc` | Unlocalized string | `Remove invisibility from a player.` | modules\administration\commands.lua | 981 |
| `data.desc` | Unlocalized string | `Enable god mode on a player.` | modules\administration\commands.lua | 998 |
| `data.desc` | Unlocalized string | `Disable a player` | modules\administration\commands.lua | 1015 |
| `data.desc` | Unlocalized string | `Set a player on fire.` | modules\administration\commands.lua | 1032 |
| `data.desc` | Unlocalized string | `Extinguish the specified player.` | modules\administration\commands.lua | 1049 |
| `data.desc` | Unlocalized string | `Strip all weapons from a player.` | modules\administration\commands.lua | 1061 |
| `data.desc` | Unlocalized string | `Unban an offline character using their Char ID.` | modules\administration\commands.lua | 1277 |
| `data.desc` | Unlocalized string | `Ban an offline character using their Char ID.` | modules\administration\commands.lua | 1299 |
| `data.desc` | Unlocalized string | `Play a global sound for all players.` | modules\administration\commands.lua | 1328 |
| `data.desc` | Unlocalized string | `Spectate a player in third person.` | modules\administration\commands.lua | 1350 |
| `data.desc` | Unlocalized string | `Stop spectating and return to normal view.` | modules\administration\commands.lua | 1393 |
| `data.desc` | Unlocalized string | `Play the specified sound on a specific player.` | modules\administration\commands.lua | 1425 |
| `data.desc` | Unlocalized string | `Toggle whether players can swap characters.` | modules\administration\commands.lua | 1455 |
| `data.desc` | Unlocalized string | `Check another player` | modules\administration\commands.lua | 1469 |
| `data.desc` | Unlocalized string | `Give the following flags to the player.` | modules\administration\commands.lua | 1506 |
| `data.desc` | Unlocalized string | `Give all possible flags to a character.` | modules\administration\commands.lua | 1548 |
| `data.desc` | Unlocalized string | `Remove all flags from a character.` | modules\administration\commands.lua | 1573 |
| `data.desc` | Unlocalized string | `Remove the following flags from the player.` | modules\administration\commands.lua | 1603 |
| `data.desc` | Unlocalized string | `Bring lost items in a 500 radius to your position.` | modules\administration\commands.lua | 1636 |
| `data.desc` | Unlocalized string | `Toggles voice chat ban for the specified character.` | modules\administration\commands.lua | 1646 |
| `data.desc` | Unlocalized string | `Remove all item entities from the map.` | modules\administration\commands.lua | 1695 |
| `data.desc` | Unlocalized string | `Remove all prop entities from the map.` | modules\administration\commands.lua | 1709 |
| `data.desc` | Unlocalized string | `Remove all ragdoll entities from the map except active player ragdolls.` | modules\administration\commands.lua | 1725 |
| `data.desc` | Unlocalized string | `Restore all map-created props by performing a map cleanup.` | modules\administration\commands.lua | 1747 |
| `data.desc` | Unlocalized string | `Remove all NPC entities from the map.` | modules\administration\commands.lua | 1761 |
| `data.desc` | Unlocalized string | `Unban a character by name or ID.` | modules\administration\commands.lua | 1777 |
| `data.desc` | Unlocalized string | `Clear a player` | modules\administration\commands.lua | 1838 |
| `data.desc` | Unlocalized string | `Kick the target` | modules\administration\commands.lua | 1864 |
| `data.desc` | Unlocalized string | `Freeze all props owned by a specific player.` | modules\administration\commands.lua | 1899 |
| `data.desc` | Unlocalized string | `Ban a character by name or ID.` | modules\administration\commands.lua | 1931 |
| `data.desc` | Unlocalized string | `Completely wipe a character from the database by name or ID.` | modules\administration\commands.lua | 1984 |
| `data.desc` | Unlocalized string | `Completely wipe an offline character from the database using their Char ID.` | modules\administration\commands.lua | 2043 |
| `data.desc` | Unlocalized string | `Check how much money the target player has.` | modules\administration\commands.lua | 2076 |
| `data.desc` | Unlocalized string | `List the available bodygroups for a target player.` | modules\administration\commands.lua | 2102 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2150 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2182 |
| `data.desc` | Unlocalized string | `Open the bodygroup editor for a player` | modules\administration\commands.lua | 2212 |
| `data.desc` | Unlocalized string | `Give an item to a player` | modules\administration\commands.lua | 2239 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2295 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2333 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2367 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2399 |
| `data.desc` | Unlocalized string | `Set a specific bodygroup on a player` | modules\administration\commands.lua | 2431 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2472 |
| `data.desc` | Unlocalized string | `Set a player` | modules\administration\commands.lua | 2510 |
| `data.desc` | Unlocalized string | `Add a certain amount of money to a player` | modules\administration\commands.lua | 2543 |
| `data.desc` | Unlocalized string | `Force all bots on the server to say something.` | modules\administration\commands.lua | 2579 |
| `data.desc` | Unlocalized string | `Force a specific bot to say something.` | modules\administration\commands.lua | 2601 |
| `data.desc` | Unlocalized string | `Force a player to say something in chat.` | modules\administration\commands.lua | 2639 |
| `data.desc` | Unlocalized string | `Get the model of the entity you are looking at.` | modules\administration\commands.lua | 2674 |
| `data.desc` | Unlocalized string | `Sends a private message to a specified player.` | modules\administration\commands.lua | 2688 |
| `data.desc` | Unlocalized string | `Get the model of a player` | modules\administration\commands.lua | 2724 |
| `data.desc` | Unlocalized string | `Check every player` | modules\administration\commands.lua | 2749 |
| `data.desc` | Unlocalized string | `Check which flags a player has.` | modules\administration\commands.lua | 2760 |
| `data.desc` | Unlocalized string | `Get a player` | modules\administration\commands.lua | 2790 |
| `data.desc` | Unlocalized string | `Get a player` | modules\administration\commands.lua | 2815 |
| `data.desc` | Unlocalized string | `Get how much money a player has.` | modules\administration\commands.lua | 2840 |
| `data.desc` | Unlocalized string | `Get the contents of a player` | modules\administration\commands.lua | 2866 |
| `data.desc` | Unlocalized string | `Print all character data columns to the console.` | modules\administration\commands.lua | 2903 |
| `data.desc` | Unlocalized string | `Drop money from your character` | modules\administration\commands.lua | 2944 |
| `data.desc` | Unlocalized string | `Export all current privileges to a data file` | modules\administration\commands.lua | 2998 |
| `data.desc` | Unlocalized string | `Manage server bots - list, kick, or spawn bots.` | modules\administration\commands.lua | 3122 |
| `data.desc` | Unlocalized string | `Spawn a specific number of bots around your position.` | modules\administration\commands.lua | 3180 |
| `data.desc` | Unlocalized string | `Spawn a bot and bring it to your location` | modules\administration\commands.lua | 3218 |
| `data.desc` | Unlocalized string | `Make all bots say a specified number of random phrases.` | modules\administration\commands.lua | 3252 |
| `data.desc` | Unlocalized string | `Set Attributes` | modules\administration\commands.lua | 3313 |
| `data.desc` | Unlocalized string | `Check Attributes` | modules\administration\commands.lua | 3371 |
| `data.desc` | Unlocalized string | `Sets your staff Discord username.` | modules\administration\commands.lua | 3440 |
| `data.desc` | Unlocalized string | `Open the vehicle trunk you` | modules\administration\commands.lua | 3464 |
| `data.desc` | Unlocalized string | `Add Attributes` | modules\administration\commands.lua | 3529 |
| `data.desc` | Unlocalized string | `Bans the specified player from using out-of-character chat.` | modules\administration\commands.lua | 3586 |
| `data.desc` | Unlocalized string | `Unbans the specified player from out-of-character chat.` | modules\administration\commands.lua | 3613 |
| `data.desc` | Unlocalized string | `Force another player to respawn.` | modules\administration\commands.lua | 3647 |
| `data.desc` | Unlocalized string | `Force yourself to respawn after death.` | modules\administration\commands.lua | 3663 |
| `data.desc` | Unlocalized string | `Clears chat for all players.` | modules\administration\commands.lua | 3690 |
| `data.desc` | Unlocalized string | `Kick all bots from the server.` | modules\administration\commands.lua | 3700 |
| `data.desc` | Unlocalized string | `Change the type of a dialog NPC you are looking at.` | modules\administration\commands.lua | 3733 |
| `data.desc` | Unlocalized string | `View and edit a player` | modules\administration\commands.lua | 3835 |
| `data.desc` | Unlocalized string | `Provides comprehensive administration tools and staff management features.` | modules\administration\module.lua | 4 |
| `data.desc` | Unlocalized string | `\\nReload switches tool sections \\nAdmin: Left click selects target, right click freezes player \\nMap Configurer: Left click sets aim position, right click uses your position \\nShift + Reload uses the active section` | modules\administration\submodules\adminstick\module.lua | 4 |
| `data.desc` | Missing key | `Logging` | modules\administration\submodules\logs\module.lua | 4 |
| `data.desc` | Unlocalized string | `Sends a support ticket to staff.` | modules\administration\submodules\tickets\commands.lua | 38 |
| `data.desc` | Unlocalized string | `Displays all tickets requested by the specified player.` | modules\administration\submodules\tickets\commands.lua | 55 |
| `data.desc` | Unlocalized string | `Displays detailed claim information for the specified player.` | modules\administration\submodules\tickets\commands.lua | 116 |
| `data.desc` | Unlocalized string | `Displays a summary table of claim data for all admins.` | modules\administration\submodules\tickets\commands.lua | 200 |
| `data.desc` | Unlocalized string | `Prints detailed claim information for every admin to chat.` | modules\administration\submodules\tickets\commands.lua | 260 |
| `data.desc` | Unlocalized string | `Sends a support ticket to staff.` | modules\administration\submodules\tickets\module.lua | 4 |
| `data.desc` | Unlocalized string | `Issues a warning to the specified player with a given reason.` | modules\administration\submodules\warnings\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Displays all warnings issued to the specified player.` | modules\administration\submodules\warnings\commands.lua | 73 |
| `data.desc` | Unlocalized string | `Displays all warnings issued by the specified staff member.` | modules\administration\submodules\warnings\commands.lua | 163 |
| `data.desc` | Missing key | `Warnings` | modules\administration\submodules\warnings\module.lua | 4 |
| `data.desc` | Unlocalized string | `Implements character attributes and provides tools for managing them.` | modules\attributes\module.lua | 4 |
| `data.desc` | Unlocalized string | `Says something in-character.` | modules\chatbox\libraries\shared.lua | 8 |
| `data.desc` | Unlocalized string | `Displays a close-range emote action.` | modules\chatbox\libraries\shared.lua | 30 |
| `data.desc` | Unlocalized string | `Displays a general action.` | modules\chatbox\libraries\shared.lua | 46 |
| `data.desc` | Unlocalized string | `Displays a far-range emote action.` | modules\chatbox\libraries\shared.lua | 64 |
| `data.desc` | Unlocalized string | `Displays an in-character message at close range.` | modules\chatbox\libraries\shared.lua | 80 |
| `data.desc` | Unlocalized string | `Displays an in-character message at far range.` | modules\chatbox\libraries\shared.lua | 95 |
| `data.desc` | Unlocalized string | `Flips a coin and displays the result.` | modules\chatbox\libraries\shared.lua | 104 |
| `data.desc` | Unlocalized string | `Performs an emote action.` | modules\chatbox\libraries\shared.lua | 124 |
| `data.desc` | Unlocalized string | `Performs an globally seen emote action.` | modules\chatbox\libraries\shared.lua | 144 |
| `data.desc` | Unlocalized string | `Displays an in-character descriptive message.` | modules\chatbox\libraries\shared.lua | 160 |
| `data.desc` | Unlocalized string | `Whispers a message.` | modules\chatbox\libraries\shared.lua | 179 |
| `data.desc` | Unlocalized string | `Yells a message.` | modules\chatbox\libraries\shared.lua | 197 |
| `data.desc` | Unlocalized string | `Out-of-character chat with a cooldown.` | modules\chatbox\libraries\shared.lua | 215 |
| `data.desc` | Unlocalized string | `Rolls a dice and displays the result.` | modules\chatbox\libraries\shared.lua | 250 |
| `data.desc` | Unlocalized string | `Sends a private message to a specified player.` | modules\chatbox\libraries\shared.lua | 277 |
| `data.desc` | Unlocalized string | `Sends a local event message (admin only).` | modules\chatbox\libraries\shared.lua | 296 |
| `data.desc` | Unlocalized string | `Sends an event message to everyone (admin only).` | modules\chatbox\libraries\shared.lua | 318 |
| `data.desc` | Unlocalized string | `Out-of-character chat for general discussion.` | modules\chatbox\libraries\shared.lua | 336 |
| `data.desc` | Unlocalized string | `Displays an action in possessive form.` | modules\chatbox\libraries\shared.lua | 394 |
| `data.desc` | Unlocalized string | `Displays an exaggerated far-range action.` | modules\chatbox\libraries\shared.lua | 414 |
| `data.desc` | Unlocalized string | `Sends a help message to staff.` | modules\chatbox\libraries\shared.lua | 434 |
| `data.desc` | Unlocalized string | `Sends a message to admin chat.` | modules\chatbox\libraries\shared.lua | 455 |
| `data.desc` | Unlocalized string | `Replaces the default chat with a configurable box that supports colored text, command parsing, and dedicated staff channels.` | modules\chatbox\module.lua | 4 |
| `data.desc` | Unlocalized string | `Sell a door you own and receive a refund based on the door` | modules\doors\commands.lua | 29 |
| `data.desc` | Unlocalized string | `Admin command to sell a door on behalf of its owner and refund the owner.` | modules\doors\commands.lua | 62 |
| `data.desc` | Unlocalized string | `Permanently assign a door to a player` | modules\doors\commands.lua | 97 |
| `data.desc` | Unlocalized string | `Remove a door` | modules\doors\commands.lua | 128 |
| `data.desc` | Unlocalized string | `Toggle a door` | modules\doors\commands.lua | 143 |
| `data.desc` | Unlocalized string | `Purchase a door if it is available and you can afford it.` | modules\doors\commands.lua | 195 |
| `data.desc` | Unlocalized string | `Toggle whether a door can be owned by players.` | modules\doors\commands.lua | 240 |
| `data.desc` | Unlocalized string | `Reset door data to default settings.` | modules\doors\commands.lua | 280 |
| `data.desc` | Unlocalized string | `Toggle door enabled state (active/inactive).` | modules\doors\commands.lua | 313 |
| `data.desc` | Unlocalized string | `Toggle the hidden state of a door.` | modules\doors\commands.lua | 340 |
| `data.desc` | Unlocalized string | `Set the price for a door.` | modules\doors\commands.lua | 367 |
| `data.desc` | Unlocalized string | `Set the title for a door.` | modules\doors\commands.lua | 404 |
| `data.desc` | Unlocalized string | `Save door data persistently.` | modules\doors\commands.lua | 444 |
| `data.desc` | Unlocalized string | `Display information about the targeted door.` | modules\doors\commands.lua | 460 |
| `data.desc` | Unlocalized string | `Add sample information to a door using common door variables.` | modules\doors\commands.lua | 539 |
| `data.desc` | Unlocalized string | `Apply randomized information to the door you are looking at.` | modules\doors\commands.lua | 617 |
| `data.desc` | Unlocalized string | `Add a faction restriction to a door, allowing only specific factions to access it.` | modules\doors\commands.lua | 649 |
| `data.desc` | Unlocalized string | `Remove a faction restriction from a door, or clear all restrictions.` | modules\doors\commands.lua | 712 |
| `data.desc` | Unlocalized string | `Set a class (job) restriction for a door.` | modules\doors\commands.lua | 774 |
| `data.desc` | Unlocalized string | `Remove a class (job) restriction from a door.` | modules\doors\commands.lua | 845 |
| `data.desc` | Unlocalized string | `Toggle the enabled state for all doors in the map.` | modules\doors\commands.lua | 1020 |
| `data.desc` | Unlocalized string | `Set the door ID for identification purposes.` | modules\doors\commands.lua | 1052 |
| `data.desc` | Unlocalized string | `List every door on the current map with its map ID, position, and model.` | modules\doors\commands.lua | 1072 |
| `data.desc` | Unlocalized string | `Manages door ownership, access control, and door-related permissions.` | modules\doors\module.lua | 4 |
| `data.desc` | Unlocalized string | `Returns items lost on death to the specified player, if any.` | modules\inventory\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Returns items lost on death to all players who have lost items.` | modules\inventory\commands.lua | 49 |
| `data.desc` | Unlocalized string | `Implements a modular grid-based inventory with item stacking, weight limits, and support for hot-loading additional modules.` | modules\inventory\module.lua | 4 |
| `data.desc` | Unlocalized string | `Defines the width of the default inventory.` | modules\inventory\types\gridinv\config.lua | 21 |
| `data.desc` | Unlocalized string | `Defines the height of the default inventory.` | modules\inventory\types\gridinv\config.lua | 48 |
| `data.desc` | Unlocalized string | `Defines the width of the default trunk inventory.` | modules\inventory\types\gridinv\config.lua | 56 |
| `data.desc` | Unlocalized string | `Defines the height of the default trunk inventory.` | modules\inventory\types\gridinv\config.lua | 64 |
| `data.desc` | Unlocalized string | `A bag to hold more items.` | modules\inventory\types\gridinv\items\base\bags.lua | 2 |
| `data.desc` | Unlocalized string | `Implements a modular grid-based inventory with item stacking, weight limits, and support for hot-loading additional modules.` | modules\inventory\types\gridinv\module.lua | 4 |
| `data.desc` | Unlocalized string | `Remove the password from the storage container you` | modules\inventory\types\gridinv\submodules\storage\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Change the password on the storage container you` | modules\inventory\types\gridinv\submodules\storage\commands.lua | 29 |
| `data.desc` | Unlocalized string | `A generic storage container.` | modules\inventory\types\gridinv\submodules\storage\entities\entities\lia_storage\shared.lua | 23 |
| `data.desc` | Unlocalized string | `Adds persistent storage containers and player vaults that integrate with the inventory for item management.` | modules\inventory\types\gridinv\submodules\storage\module.lua | 4 |
| `data.desc` | Unlocalized string | `The maximum weight a player` | modules\inventory\types\weightinv\config.lua | 2 |
| `data.desc` | Unlocalized string | `The unit label displayed for inventory weight (e.g. KG, LB).` | modules\inventory\types\weightinv\config.lua | 10 |
| `data.desc` | Unlocalized string | `Defines the width of the default inventory.` | modules\inventory\types\weightinv\config.lua | 35 |
| `data.desc` | Unlocalized string | `Defines the height of the default inventory.` | modules\inventory\types\weightinv\config.lua | 62 |
| `data.desc` | Unlocalized string | `Defines the width of the default trunk inventory.` | modules\inventory\types\weightinv\config.lua | 70 |
| `data.desc` | Unlocalized string | `Defines the height of the default trunk inventory.` | modules\inventory\types\weightinv\config.lua | 78 |
| `data.desc` | Unlocalized string | `A bag to hold more items.` | modules\inventory\types\weightinv\items\base\bags.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a weight-based simple inventory type with list display and storage support.` | modules\inventory\types\weightinv\module.lua | 4 |
| `data.desc` | Missing key | `mainMenuDescription` | modules\mainmenu\module.lua | 4 |
| `data.desc` | Unlocalized string | `Force player recognition in whisper range.` | modules\recognition\commands.lua | 10 |
| `data.desc` | Unlocalized string | `Force player recognition in normal range.` | modules\recognition\commands.lua | 31 |
| `data.desc` | Unlocalized string | `Force player recognition in yell range.` | modules\recognition\commands.lua | 52 |
| `data.desc` | Unlocalized string | `Force all bots to recognize people around them. Optionally specify a fake name.` | modules\recognition\commands.lua | 79 |
| `data.desc` | Unlocalized string | `Introduces a recognition system where characters must learn each other` | modules\recognition\module.lua | 4 |
| `data.desc` | Unlocalized string | `Adds a spawn point at your current position for the specified faction.` | modules\spawns\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Removes all spawn points within the given radius of your position (default 120).` | modules\spawns\commands.lua | 55 |
| `data.desc` | Unlocalized string | `Removes all spawn points for the specified faction.` | modules\spawns\commands.lua | 100 |
| `data.desc` | Unlocalized string | `Manages player spawns and spawn protection systems.` | modules\spawns\module.lua | 4 |
| `data.desc` | Unlocalized string | `Transfers the specified player to a new faction.` | modules\teams\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Adds the specified player to a faction whitelist.` | modules\teams\commands.lua | 102 |
| `data.desc` | Unlocalized string | `Removes the specified player from a faction whitelist.` | modules\teams\commands.lua | 157 |
| `data.desc` | Unlocalized string | `Changes your current class to the specified class.` | modules\teams\commands.lua | 216 |
| `data.desc` | Unlocalized string | `Sets the specified player` | modules\teams\commands.lua | 309 |
| `data.desc` | Unlocalized string | `Grants the specified player whitelist access to a class.` | modules\teams\commands.lua | 380 |
| `data.desc` | Unlocalized string | `Revokes the specified player` | modules\teams\commands.lua | 427 |
| `data.desc` | Unlocalized string | `Manages teams and factions with whitelist support and admin controls.` | modules\teams\module.lua | 4 |
| `data.desc` | Unlocalized string | `Restocks all items for the vendor you are looking at to their default quantities.` | modules\vendor\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Restocks all items on every vendor on the map to their default quantities.` | modules\vendor\commands.lua | 27 |
| `data.desc` | Unlocalized string | `Delete a saved vendor preset by name.` | modules\vendor\commands.lua | 46 |
| `data.desc` | Unlocalized string | `List all saved vendor preset names.` | modules\vendor\commands.lua | 87 |
| `data.desc` | Unlocalized string | `Reset vendor cooldowns for a player` | modules\vendor\commands.lua | 111 |
| `data.desc` | Unlocalized string | `Provides NPC vendors who can buy and sell items with stock management and dialogue-driven transactions.` | modules\vendor\module.lua | 4 |
| `data.privilege` | Missing key | `manageCharacterInformation` | modules\administration\commands.lua | 2181 |
| `data.privilege` | Missing key | `changeBodygroups` | modules\administration\commands.lua | 2211 |
| `entity.contact` | Missing key | `liliaplayer` | entities\entities\lia_ammobox\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | entities\entities\lia_item\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | entities\entities\lia_money\shared.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | entities\entities\lia_npc\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | entities\weapons\lia_hands\shared.lua | 7 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\entities\weapons\lia_distance\shared.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\submodules\adminstick\entities\weapons\lia_adminstick\shared.lua | 2 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\submodules\adminstick\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\submodules\logs\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\submodules\tickets\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\administration\submodules\warnings\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\attributes\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\chatbox\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\doors\entities\weapons\lia_keys\shared.lua | 2 |
| `entity.contact` | Missing key | `liliaplayer` | modules\doors\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\inventory\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\inventory\types\gridinv\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\inventory\types\gridinv\submodules\storage\entities\entities\lia_storage\shared.lua | 4 |
| `entity.contact` | Missing key | `liliaplayer` | modules\inventory\types\gridinv\submodules\storage\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\inventory\types\weightinv\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\mainmenu\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\recognition\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\spawns\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\teams\module.lua | 3 |
| `entity.contact` | Missing key | `liliaplayer` | modules\vendor\entities\entities\lia_vendor\shared.lua | 5 |
| `entity.contact` | Missing key | `liliaplayer` | modules\vendor\module.lua | 3 |
| `interaction.actionText` | Unlocalized string | `LMB  SELECT` | core\derma\panels\radialpanel.lua | 276 |
| `interaction.actionText` | Unlocalized string | `LMB  RETURN` | core\derma\panels\radialpanel.lua | 280 |
| `interaction.actionText` | Unlocalized string | `LMB  CLOSE` | core\derma\panels\radialpanel.lua | 282 |
| `lia.config.add:name` | Unlocalized string | `Block Pack URL Load` | core\libraries\compatibility\pac\core.lua | 198 |
| `lia.config.add:name` | Unlocalized string | `Admin Only Notifications` | core\libraries\compatibility\sam\core.lua | 287 |
| `lia.config.add:name` | Unlocalized string | `Enforce Staff Rank To SAM` | core\libraries\compatibility\sam\core.lua | 293 |
| `lia.config.add:name` | Unlocalized string | `Take Damage in Cars` | core\libraries\compatibility\simfphys\core.lua | 152 |
| `lia.config.add:name` | Unlocalized string | `Car Entry Delay Enabled` | core\libraries\compatibility\simfphys\core.lua | 158 |
| `lia.config.add:name` | Unlocalized string | `Time To Enter Vehicle` | core\libraries\compatibility\simfphys\core.lua | 164 |
| `lia.config.add:name` | Unlocalized string | `Disable simfphys HUD` | core\libraries\compatibility\simfphys\core.lua | 172 |
| `lia.config.add:name` | Unlocalized string | `Default User Group` | core\libraries\core\admin\core.lua | 60 |
| `lia.config.add:name` | Unlocalized string | `OOC/LOOC Icon Message` | core\libraries\core\admin\core.lua | 75 |
| `lia.config.add:name` | Missing key | `Theme` | core\libraries\core\color\core.lua | 570 |
| `lia.config.add:name` | Unlocalized string | `Main Character Cooldown (Days)` | core\libraries\core\config\core.lua | 960 |
| `lia.config.add:name` | Unlocalized string | `Money Model` | core\libraries\core\config\core.lua | 968 |
| `lia.config.add:name` | Unlocalized string | `Max Money Entities` | core\libraries\core\config\core.lua | 974 |
| `lia.config.add:name` | Unlocalized string | `Currency Symbol` | core\libraries\core\config\core.lua | 982 |
| `lia.config.add:name` | Unlocalized string | `Currency Singular Name` | core\libraries\core\config\core.lua | 988 |
| `lia.config.add:name` | Unlocalized string | `Currency Plural Name` | core\libraries\core\config\core.lua | 994 |
| `lia.config.add:name` | Unlocalized string | `Walk Speed` | core\libraries\core\config\core.lua | 1000 |
| `lia.config.add:name` | Unlocalized string | `Enable Death Sound` | core\libraries\core\config\core.lua | 1012 |
| `lia.config.add:name` | Unlocalized string | `Enable Pain Sound` | core\libraries\core\config\core.lua | 1018 |
| `lia.config.add:name` | Unlocalized string | `Enable Fall Damage` | core\libraries\core\config\core.lua | 1024 |
| `lia.config.add:name` | Unlocalized string | `Limb Damage Multiplier` | core\libraries\core\config\core.lua | 1030 |
| `lia.config.add:name` | Unlocalized string | `Global Damage Scale` | core\libraries\core\config\core.lua | 1038 |
| `lia.config.add:name` | Unlocalized string | `Headshot Damage Multiplier` | core\libraries\core\config\core.lua | 1046 |
| `lia.config.add:name` | Unlocalized string | `Run Speed` | core\libraries\core\config\core.lua | 1054 |
| `lia.config.add:name` | Unlocalized string | `Max Characters` | core\libraries\core\config\core.lua | 1066 |
| `lia.config.add:name` | Unlocalized string | `Allow Private Messages` | core\libraries\core\config\core.lua | 1074 |
| `lia.config.add:name` | Unlocalized string | `Minimum Description Length` | core\libraries\core\config\core.lua | 1080 |
| `lia.config.add:name` | Unlocalized string | `Default Money` | core\libraries\core\config\core.lua | 1088 |
| `lia.config.add:name` | Unlocalized string | `Data Save Interval` | core\libraries\core\config\core.lua | 1096 |
| `lia.config.add:name` | Unlocalized string | `Character Data Save Interval` | core\libraries\core\config\core.lua | 1104 |
| `lia.config.add:name` | Unlocalized string | `Respawn Time` | core\libraries\core\config\core.lua | 1112 |
| `lia.config.add:name` | Unlocalized string | `Time To Enter Vehicle` | core\libraries\core\config\core.lua | 1120 |
| `lia.config.add:name` | Unlocalized string | `Car Entry Delay Enabled` | core\libraries\core\config\core.lua | 1128 |
| `lia.config.add:name` | Unlocalized string | `Max Chat Length` | core\libraries\core\config\core.lua | 1134 |
| `lia.config.add:name` | Unlocalized string | `Doors Always Disabled` | core\libraries\core\config\core.lua | 1142 |
| `lia.config.add:name` | Unlocalized string | `Admin Console Network Logs` | core\libraries\core\config\core.lua | 1148 |
| `lia.config.add:name` | Unlocalized string | `Character Menu Background Input Disabled` | core\libraries\core\config\core.lua | 1154 |
| `lia.config.add:name` | Unlocalized string | `Allow Keybind Editing` | core\libraries\core\config\core.lua | 1160 |
| `lia.config.add:name` | Unlocalized string | `Enable Crosshair` | core\libraries\core\config\core.lua | 1166 |
| `lia.config.add:name` | Unlocalized string | `Auto Weapon-to-Item Generation` | core\libraries\core\config\core.lua | 1172 |
| `lia.config.add:name` | Unlocalized string | `Auto Ammo Item Generation` | core\libraries\core\config\core.lua | 1178 |
| `lia.config.add:name` | Unlocalized string | `Items Can Be Destroyed` | core\libraries\core\config\core.lua | 1184 |
| `lia.config.add:name` | Unlocalized string | `Enable Ammo Display` | core\libraries\core\config\core.lua | 1190 |
| `lia.config.add:name` | Unlocalized string | `Voice Chat Enabled` | core\libraries\core\config\core.lua | 1196 |
| `lia.config.add:name` | Unlocalized string | `Salary Interval` | core\libraries\core\config\core.lua | 1202 |
| `lia.config.add:name` | Unlocalized string | `Enable Third-Person View` | core\libraries\core\config\core.lua | 1213 |
| `lia.config.add:name` | Unlocalized string | `Maximum Third-Person Distance` | core\libraries\core\config\core.lua | 1219 |
| `lia.config.add:name` | Unlocalized string | `Maximum Third-Person Horizontal Offset` | core\libraries\core\config\core.lua | 1227 |
| `lia.config.add:name` | Unlocalized string | `Maximum Third-Person Height Offset` | core\libraries\core\config\core.lua | 1235 |
| `lia.config.add:name` | Unlocalized string | `Derma UI Skin` | core\libraries\core\config\core.lua | 1253 |
| `lia.config.add:name` | Missing key | `Language` | core\libraries\core\config\core.lua | 1260 |
| `lia.config.add:name` | Unlocalized string | `Limit Spawn Menu Access` | core\libraries\core\config\core.lua | 1267 |
| `lia.config.add:name` | Unlocalized string | `Log Retention Period` | core\libraries\core\config\core.lua | 1273 |
| `lia.config.add:name` | Unlocalized string | `Stamina Slowdown Enabled` | core\libraries\core\config\core.lua | 1281 |
| `lia.config.add:name` | Unlocalized string | `Default Stamina Value` | core\libraries\core\config\core.lua | 1287 |
| `lia.config.add:name` | Unlocalized string | `Max Attribute Points` | core\libraries\core\config\core.lua | 1295 |
| `lia.config.add:name` | Unlocalized string | `Jump Stamina Cost` | core\libraries\core\config\core.lua | 1304 |
| `lia.config.add:name` | Unlocalized string | `Max Starting Attributes` | core\libraries\core\config\core.lua | 1312 |
| `lia.config.add:name` | Unlocalized string | `Starting Attribute Points` | core\libraries\core\config\core.lua | 1321 |
| `lia.config.add:name` | Unlocalized string | `Punch Stamina` | core\libraries\core\config\core.lua | 1330 |
| `lia.config.add:name` | Unlocalized string | `Punch Lethality` | core\libraries\core\config\core.lua | 1339 |
| `lia.config.add:name` | Unlocalized string | `Stamina Drain` | core\libraries\core\config\core.lua | 1346 |
| `lia.config.add:name` | Unlocalized string | `Stamina Regeneration` | core\libraries\core\config\core.lua | 1355 |
| `lia.config.add:name` | Unlocalized string | `Stamina Crouch Regeneration` | core\libraries\core\config\core.lua | 1364 |
| `lia.config.add:name` | Unlocalized string | `Logs Per Page` | core\libraries\core\config\core.lua | 1373 |
| `lia.config.add:name` | Unlocalized string | `Punch Ragdoll Time` | core\libraries\core\config\core.lua | 1381 |
| `lia.config.add:name` | Unlocalized string | `Maximum Hold Weight` | core\libraries\core\config\core.lua | 1390 |
| `lia.config.add:name` | Unlocalized string | `Throw Force` | core\libraries\core\config\core.lua | 1398 |
| `lia.config.add:name` | Unlocalized string | `Punch Playtime Protection` | core\libraries\core\config\core.lua | 1406 |
| `lia.config.add:name` | Unlocalized string | `Custom Chat Sound` | core\libraries\core\config\core.lua | 1415 |
| `lia.config.add:name` | Unlocalized string | `Talk Range` | core\libraries\core\config\core.lua | 1421 |
| `lia.config.add:name` | Unlocalized string | `Whisper Range` | core\libraries\core\config\core.lua | 1429 |
| `lia.config.add:name` | Unlocalized string | `Yell Range` | core\libraries\core\config\core.lua | 1437 |
| `lia.config.add:name` | Unlocalized string | `OOC Character Limit` | core\libraries\core\config\core.lua | 1445 |
| `lia.config.add:name` | Unlocalized string | `OOC Delay` | core\libraries\core\config\core.lua | 1453 |
| `lia.config.add:name` | Unlocalized string | `LOOC Delay` | core\libraries\core\config\core.lua | 1461 |
| `lia.config.add:name` | Unlocalized string | `LOOC Delay for Admins` | core\libraries\core\config\core.lua | 1469 |
| `lia.config.add:name` | Unlocalized string | `The OOC is Globally Blocked!` | core\libraries\core\config\core.lua | 1475 |
| `lia.config.add:name` | Unlocalized string | `Enable Different Chat Size` | core\libraries\core\config\core.lua | 1481 |
| `lia.config.add:name` | Unlocalized string | `Music Volume` | core\libraries\core\config\core.lua | 1487 |
| `lia.config.add:name` | Unlocalized string | `Main Menu Music` | core\libraries\core\config\core.lua | 1495 |
| `lia.config.add:name` | Unlocalized string | `Main Menu Background URL` | core\libraries\core\config\core.lua | 1501 |
| `lia.config.add:name` | Unlocalized string | `Server Logo` | core\libraries\core\config\core.lua | 1507 |
| `lia.config.add:name` | Unlocalized string | `Main Menu Logo Enabled` | core\libraries\core\config\core.lua | 1513 |
| `lia.config.add:name` | Unlocalized string | `Main Menu Discord URL` | core\libraries\core\config\core.lua | 1519 |
| `lia.config.add:name` | Unlocalized string | `Main Menu Workshop URL` | core\libraries\core\config\core.lua | 1525 |
| `lia.config.add:name` | Unlocalized string | `Character Menu Background Input Disabled` | core\libraries\core\config\core.lua | 1531 |
| `lia.config.add:name` | Unlocalized string | `Apply cooldown on all entities` | core\libraries\core\config\core.lua | 1537 |
| `lia.config.add:name` | Unlocalized string | `Switch cooldown after damage` | core\libraries\core\config\core.lua | 1543 |
| `lia.config.add:name` | Unlocalized string | `Character switch cooldown timer` | core\libraries\core\config\core.lua | 1551 |
| `lia.config.add:name` | Unlocalized string | `Explosion Ragdoll on Hit` | core\libraries\core\config\core.lua | 1559 |
| `lia.config.add:name` | Unlocalized string | `Car Ragdoll on Hit` | core\libraries\core\config\core.lua | 1565 |
| `lia.config.add:name` | Unlocalized string | `Time Until Dropped SWEP Removed` | core\libraries\core\config\core.lua | 1571 |
| `lia.config.add:name` | Unlocalized string | `Disable Alts` | core\libraries\core\config\core.lua | 1579 |
| `lia.config.add:name` | Unlocalized string | `Enable Acts` | core\libraries\core\config\core.lua | 1585 |
| `lia.config.add:name` | Unlocalized string | `Prop Protection` | core\libraries\core\config\core.lua | 1591 |
| `lia.config.add:name` | Unlocalized string | `Passable on Freeze` | core\libraries\core\config\core.lua | 1597 |
| `lia.config.add:name` | Unlocalized string | `Player Spawn Vehicle Delay` | core\libraries\core\config\core.lua | 1603 |
| `lia.config.add:name` | Unlocalized string | `Mouth Move Animation` | core\libraries\core\config\core.lua | 1611 |
| `lia.config.add:name` | Unlocalized string | `Grab Ear Animation` | core\libraries\core\config\core.lua | 1617 |
| `lia.config.add:name` | Unlocalized string | `Voice Icons` | core\libraries\core\config\core.lua | 1623 |
| `lia.config.add:name` | Unlocalized string | `Disable Lua Run Hooks` | core\libraries\core\config\core.lua | 1629 |
| `lia.config.add:name` | Unlocalized string | `Equip Delay` | core\libraries\core\config\core.lua | 1635 |
| `lia.config.add:name` | Unlocalized string | `Unequip Delay` | core\libraries\core\config\core.lua | 1643 |
| `lia.config.add:name` | Unlocalized string | `Drop Delay` | core\libraries\core\config\core.lua | 1651 |
| `lia.config.add:name` | Unlocalized string | `Delete Dropped Items On Leave` | core\libraries\core\config\core.lua | 1659 |
| `lia.config.add:name` | Unlocalized string | `HUD Font` | core\libraries\core\config\core.lua | 1665 |
| `lia.config.add:name` | Unlocalized string | `Bodygrouper Model` | core\libraries\core\config\core.lua | 1675 |
| `lia.config.add:name` | Unlocalized string | `Wardrobe Model` | core\libraries\core\config\core.lua | 1681 |
| `lia.config.add:name` | Unlocalized string | `Enable Faction Models` | core\libraries\core\config\core.lua | 1687 |
| `lia.config.add:name` | Unlocalized string | `Enable Class Models` | core\libraries\core\config\core.lua | 1693 |
| `lia.config.add:name` | Unlocalized string | `Delete Entities On Leave` | core\libraries\core\config\core.lua | 1699 |
| `lia.config.add:name` | Unlocalized string | `Take Delay` | core\libraries\core\config\core.lua | 1705 |
| `lia.config.add:name` | Unlocalized string | `Item Give Speed` | core\libraries\core\config\core.lua | 1713 |
| `lia.config.add:name` | Unlocalized string | `Is Item Giving Enabled` | core\libraries\core\config\core.lua | 1721 |
| `lia.config.add:name` | Unlocalized string | `Lose Items on NPC Death` | core\libraries\core\config\core.lua | 1727 |
| `lia.config.add:name` | Unlocalized string | `Lose Items on Human Death` | core\libraries\core\config\core.lua | 1733 |
| `lia.config.add:name` | Unlocalized string | `Lose Items on World Death` | core\libraries\core\config\core.lua | 1739 |
| `lia.config.add:name` | Unlocalized string | `Enable Death Popup` | core\libraries\core\config\core.lua | 1745 |
| `lia.config.add:name` | Unlocalized string | `Display Classes on Characters` | core\libraries\core\config\core.lua | 1751 |
| `lia.config.add:name` | Unlocalized string | `Scoreboard Width` | core\libraries\core\config\core.lua | 1761 |
| `lia.config.add:name` | Unlocalized string | `Scoreboard Height` | core\libraries\core\config\core.lua | 1769 |
| `lia.config.add:name` | Unlocalized string | `Scoreboard Dock` | core\libraries\core\config\core.lua | 1777 |
| `lia.config.add:name` | Unlocalized string | `Class Headers` | core\libraries\core\config\core.lua | 1784 |
| `lia.config.add:name` | Unlocalized string | `Character Recognition Enabled` | core\libraries\core\config\core.lua | 1790 |
| `lia.config.add:name` | Unlocalized string | `Fake Names Enabled` | core\libraries\core\config\core.lua | 1796 |
| `lia.config.add:name` | Unlocalized string | `Default Vendor Money` | core\libraries\core\config\core.lua | 1802 |
| `lia.config.add:name` | Unlocalized string | `Default Menu Tab` | core\libraries\core\config\core.lua | 1820 |
| `lia.config.add:name` | Unlocalized string | `Door Lock Time` | core\libraries\core\config\core.lua | 1834 |
| `lia.config.add:name` | Unlocalized string | `Door Sell Ratio` | core\libraries\core\config\core.lua | 1842 |
| `lia.config.add:name` | Unlocalized string | `Use Last Position for Main Menu` | core\libraries\core\config\core.lua | 1849 |
| `lia.config.add:name` | Unlocalized string | `American Timestamps` | core\libraries\core\config\core.lua | 1855 |
| `lia.config.add:name` | Unlocalized string | `Accent Color` | core\libraries\core\config\core.lua | 1861 |
| `lia.config.add:name` | Unlocalized string | `Staff Has God Mode` | core\libraries\core\config\core.lua | 1867 |
| `lia.config.add:name` | Unlocalized string | `Description Width` | core\libraries\core\config\core.lua | 1873 |
| `lia.config.add:name` | Unlocalized string | `Max Attributes` | core\libraries\core\config\core.lua | 1881 |
| `lia.config.add:name` | Missing key | `Font` | core\libraries\core\fonts\core.lua | 363 |
| `lia.config.add:name` | Unlocalized string | `Inventory Width` | modules\inventory\types\gridinv\config.lua | 1 |
| `lia.config.add:name` | Unlocalized string | `Inventory Height` | modules\inventory\types\gridinv\config.lua | 28 |
| `lia.config.add:name` | Unlocalized string | `Trunk Inventory Width` | modules\inventory\types\gridinv\config.lua | 55 |
| `lia.config.add:name` | Unlocalized string | `Trunk Inventory Height` | modules\inventory\types\gridinv\config.lua | 63 |
| `lia.config.add:name` | Unlocalized string | `Max Inventory Weight` | modules\inventory\types\weightinv\config.lua | 1 |
| `lia.config.add:name` | Unlocalized string | `Inventory Weight Unit` | modules\inventory\types\weightinv\config.lua | 9 |
| `lia.config.add:name` | Unlocalized string | `Inventory Width` | modules\inventory\types\weightinv\config.lua | 15 |
| `lia.config.add:name` | Unlocalized string | `Inventory Height` | modules\inventory\types\weightinv\config.lua | 42 |
| `lia.config.add:name` | Unlocalized string | `Trunk Inventory Width` | modules\inventory\types\weightinv\config.lua | 69 |
| `lia.config.add:name` | Unlocalized string | `Trunk Inventory Height` | modules\inventory\types\weightinv\config.lua | 77 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to PAC3.` | core\libraries\compatibility\pac\core.lua | 222 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning vehicles.` | core\libraries\core\flags\core.lua | 26 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning SWEPS.` | core\libraries\core\flags\core.lua | 27 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning SENTs.` | core\libraries\core\flags\core.lua | 28 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning Effects.` | core\libraries\core\flags\core.lua | 29 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning ragdolls.` | core\libraries\core\flags\core.lua | 30 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning props.` | core\libraries\core\flags\core.lua | 31 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to spawning NPCs.` | core\libraries\core\flags\core.lua | 32 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to inviting to your faction.` | core\libraries\core\flags\core.lua | 33 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to inviting to your class.` | core\libraries\core\flags\core.lua | 34 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to viewing your faction roster.` | core\libraries\core\flags\core.lua | 35 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to Physgun.` | core\libraries\core\flags\core.lua | 36 |
| `lia.flag.add:desc` | Unlocalized string | `Gives Access to Toolgun` | core\libraries\core\flags\core.lua | 45 |
| `lia.option.add:desc` | Unlocalized string | `Adjust the description width on the HUD` | core\libraries\core\option\core.lua | 812 |
| `lia.option.add:desc` | Unlocalized string | `Show or hide hover information for players.` | core\libraries\core\option\core.lua | 819 |
| `lia.option.add:desc` | Unlocalized string | `Show or hide hover information for dropped items and money.` | core\libraries\core\option\core.lua | 824 |
| `lia.option.add:desc` | Unlocalized string | `Show or hide hover information for general entities.` | core\libraries\core\option\core.lua | 829 |
| `lia.option.add:desc` | Unlocalized string | `Invert the weapon selection scroll direction.` | core\libraries\core\option\core.lua | 834 |
| `lia.option.add:desc` | Unlocalized string | `Toggle ESP features.` | core\libraries\core\option\core.lua | 839 |
| `lia.option.add:desc` | Unlocalized string | `Enable ESP for players.` | core\libraries\core\option\core.lua | 852 |
| `lia.option.add:desc` | Unlocalized string | `Enable ESP for items.` | core\libraries\core\option\core.lua | 865 |
| `lia.option.add:desc` | Unlocalized string | `Enable ESP for entities.` | core\libraries\core\option\core.lua | 878 |
| `lia.option.add:desc` | Unlocalized string | `Enable ESP for doors without configuration.` | core\libraries\core\option\core.lua | 891 |
| `lia.option.add:desc` | Unlocalized string | `Sets the ESP color for items.` | core\libraries\core\option\core.lua | 904 |
| `lia.option.add:desc` | Unlocalized string | `Sets the ESP color for entities.` | core\libraries\core\option\core.lua | 921 |
| `lia.option.add:desc` | Unlocalized string | `Sets the ESP color for unconfigured doors.` | core\libraries\core\option\core.lua | 938 |
| `lia.option.add:desc` | Unlocalized string | `Enable ESP for doors with configuration.` | core\libraries\core\option\core.lua | 955 |
| `lia.option.add:desc` | Unlocalized string | `Sets the ESP color for configured doors.` | core\libraries\core\option\core.lua | 968 |
| `lia.option.add:desc` | Unlocalized string | `Sets the ESP color for players.` | core\libraries\core\option\core.lua | 985 |
| `lia.option.add:desc` | Unlocalized string | `Make all bars always visible` | core\libraries\core\option\core.lua | 1002 |
| `lia.option.add:desc` | Unlocalized string | `Allows players to toggle third-person view on or off.` | core\libraries\core\option\core.lua | 1007 |
| `lia.option.add:desc` | Unlocalized string | `Makes third-person aiming follow your camera direction even while standing still.` | core\libraries\core\option\core.lua | 1012 |
| `lia.option.add:desc` | Unlocalized string | `Makes the third-person camera sit higher or lower.` | core\libraries\core\option\core.lua | 1017 |
| `lia.option.add:desc` | Unlocalized string | `Makes the third-person camera sit farther left or right.` | core\libraries\core\option\core.lua | 1024 |
| `lia.option.add:desc` | Unlocalized string | `Makes the third-person camera sit closer to or farther from your character.` | core\libraries\core\option\core.lua | 1031 |
| `lia.option.add:desc` | Unlocalized string | `Makes realistic view work with non-whitelisted weapons instead of only the default keys behavior.` | core\libraries\core\option\core.lua | 1038 |
| `lia.option.add:desc` | Unlocalized string | `Makes freelook available so you can look around without turning your character.` | core\libraries\core\option\core.lua | 1044 |
| `lia.option.add:desc` | Unlocalized string | `Makes freelook stop once you reach this up-or-down angle.` | core\libraries\core\option\core.lua | 1050 |
| `lia.option.add:desc` | Unlocalized string | `Makes freelook stop once you reach this left-or-right angle.` | core\libraries\core\option\core.lua | 1057 |
| `lia.option.add:desc` | Unlocalized string | `Makes the freelook camera catch up faster at higher values and lag more at lower values.` | core\libraries\core\option\core.lua | 1064 |
| `lia.option.add:desc` | Unlocalized string | `Makes freelook turn off while aiming and blocks normal firing while freelook is being held.` | core\libraries\core\option\core.lua | 1072 |
| `lia.option.add:desc` | Unlocalized string | `Should chat show timestamp` | core\libraries\core\option\core.lua | 1077 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable shadow rendering for better performance.` | core\libraries\core\option\core.lua | 1082 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable dynamic lighting from lights and flashlights.` | core\libraries\core\option\core.lua | 1087 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable eye movement on player models.` | core\libraries\core\option\core.lua | 1092 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable facial flex animations and expressions.` | core\libraries\core\option\core.lua | 1097 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable motion blur effects.` | core\libraries\core\option\core.lua | 1102 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable water reflections.` | core\libraries\core\option\core.lua | 1107 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable rendering of in-game monitors and screens.` | core\libraries\core\option\core.lua | 1112 |
| `lia.option.add:desc` | Unlocalized string | `Show/hide alien gibs (body parts).` | core\libraries\core\option\core.lua | 1117 |
| `lia.option.add:desc` | Unlocalized string | `Show/hide human gibs (body parts).` | core\libraries\core\option\core.lua | 1122 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable water splash effects.` | core\libraries\core\option\core.lua | 1127 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable shell casing ejection from weapons.` | core\libraries\core\option\core.lua | 1132 |
| `lia.option.add:desc` | Unlocalized string | `How long spray paints last (in seconds).` | core\libraries\core\option\core.lua | 1137 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable decals on models (bullet holes, blood splatters).` | core\libraries\core\option\core.lua | 1144 |
| `lia.option.add:desc` | Unlocalized string | `Distance at which details begin fading.` | core\libraries\core\option\core.lua | 1149 |
| `lia.option.add:desc` | Unlocalized string | `Distance at which detail props are visible.` | core\libraries\core\option\core.lua | 1156 |
| `lia.option.add:desc` | Unlocalized string | `Enable/disable entity smoothing for network interpolation.` | core\libraries\core\option\core.lua | 1163 |
| `lia.option.add:desc` | Unlocalized string | `Network smoothing interpolation time.` | core\libraries\core\option\core.lua | 1168 |
| `lia.option.add:desc` | Unlocalized string | `Display a circle showing your current voice range` | core\libraries\core\option\core.lua | 1176 |
| `lia.option.add:desc` | Unlocalized string | `Controls where the weapon selector appears on screen (Left, Right, or Center).` | core\libraries\core\option\core.lua | 1182 |
| `lia.option.add:name` | Unlocalized string | `Description Width` | core\libraries\core\option\core.lua | 812 |
| `lia.option.add:name` | Unlocalized string | `Player Hover Info` | core\libraries\core\option\core.lua | 819 |
| `lia.option.add:name` | Unlocalized string | `Item Hover Info` | core\libraries\core\option\core.lua | 824 |
| `lia.option.add:name` | Unlocalized string | `Entity Hover Info` | core\libraries\core\option\core.lua | 829 |
| `lia.option.add:name` | Unlocalized string | `Invert Weapon Scroll` | core\libraries\core\option\core.lua | 834 |
| `lia.option.add:name` | Unlocalized string | `ESP Enabled` | core\libraries\core\option\core.lua | 839 |
| `lia.option.add:name` | Unlocalized string | `ESP Players` | core\libraries\core\option\core.lua | 852 |
| `lia.option.add:name` | Unlocalized string | `ESP Items` | core\libraries\core\option\core.lua | 865 |
| `lia.option.add:name` | Unlocalized string | `ESP Entities` | core\libraries\core\option\core.lua | 878 |
| `lia.option.add:name` | Unlocalized string | `ESP Unconfigured Doors` | core\libraries\core\option\core.lua | 891 |
| `lia.option.add:name` | Unlocalized string | `ESP Items Color` | core\libraries\core\option\core.lua | 904 |
| `lia.option.add:name` | Unlocalized string | `ESP Entities Color` | core\libraries\core\option\core.lua | 921 |
| `lia.option.add:name` | Unlocalized string | `ESP Unconfigured Doors Color` | core\libraries\core\option\core.lua | 938 |
| `lia.option.add:name` | Unlocalized string | `ESP Configured Doors` | core\libraries\core\option\core.lua | 955 |
| `lia.option.add:name` | Unlocalized string | `ESP Configured Doors Color` | core\libraries\core\option\core.lua | 968 |
| `lia.option.add:name` | Unlocalized string | `ESP Players Color` | core\libraries\core\option\core.lua | 985 |
| `lia.option.add:name` | Unlocalized string | `Bars Always Visible` | core\libraries\core\option\core.lua | 1002 |
| `lia.option.add:name` | Unlocalized string | `Enable Third-Person View` | core\libraries\core\option\core.lua | 1007 |
| `lia.option.add:name` | Unlocalized string | `Classic Mode` | core\libraries\core\option\core.lua | 1012 |
| `lia.option.add:name` | Unlocalized string | `Third Person Height` | core\libraries\core\option\core.lua | 1017 |
| `lia.option.add:name` | Missing key | `Horizontal` | core\libraries\core\option\core.lua | 1024 |
| `lia.option.add:name` | Missing key | `Distance` | core\libraries\core\option\core.lua | 1031 |
| `lia.option.add:name` | Unlocalized string | `Enable Realistic View` | core\libraries\core\option\core.lua | 1038 |
| `lia.option.add:name` | Unlocalized string | `Enable Freelook` | core\libraries\core\option\core.lua | 1044 |
| `lia.option.add:name` | Unlocalized string | `Freelook Vertical Limit` | core\libraries\core\option\core.lua | 1050 |
| `lia.option.add:name` | Unlocalized string | `Freelook Horizontal Limit` | core\libraries\core\option\core.lua | 1057 |
| `lia.option.add:name` | Unlocalized string | `Freelook Smoothness` | core\libraries\core\option\core.lua | 1064 |
| `lia.option.add:name` | Unlocalized string | `Freelook Block ADS` | core\libraries\core\option\core.lua | 1072 |
| `lia.option.add:name` | Unlocalized string | `Show Chat Timestamp` | core\libraries\core\option\core.lua | 1077 |
| `lia.option.add:name` | Missing key | `Shadows` | core\libraries\core\option\core.lua | 1082 |
| `lia.option.add:name` | Unlocalized string | `Dynamic Lighting` | core\libraries\core\option\core.lua | 1087 |
| `lia.option.add:name` | Unlocalized string | `Eye Movement` | core\libraries\core\option\core.lua | 1092 |
| `lia.option.add:name` | Unlocalized string | `Facial Expressions` | core\libraries\core\option\core.lua | 1097 |
| `lia.option.add:name` | Unlocalized string | `Motion Blur` | core\libraries\core\option\core.lua | 1102 |
| `lia.option.add:name` | Unlocalized string | `Water Reflections` | core\libraries\core\option\core.lua | 1107 |
| `lia.option.add:name` | Unlocalized string | `Game Monitors` | core\libraries\core\option\core.lua | 1112 |
| `lia.option.add:name` | Unlocalized string | `Alien Gibs` | core\libraries\core\option\core.lua | 1117 |
| `lia.option.add:name` | Unlocalized string | `Human Gibs` | core\libraries\core\option\core.lua | 1122 |
| `lia.option.add:name` | Unlocalized string | `Water Splashes` | core\libraries\core\option\core.lua | 1127 |
| `lia.option.add:name` | Unlocalized string | `Shell Ejection` | core\libraries\core\option\core.lua | 1132 |
| `lia.option.add:name` | Unlocalized string | `Spray Lifetime` | core\libraries\core\option\core.lua | 1137 |
| `lia.option.add:name` | Unlocalized string | `Model Decals` | core\libraries\core\option\core.lua | 1144 |
| `lia.option.add:name` | Unlocalized string | `Detail Fade Distance` | core\libraries\core\option\core.lua | 1149 |
| `lia.option.add:name` | Unlocalized string | `Detail Distance` | core\libraries\core\option\core.lua | 1156 |
| `lia.option.add:name` | Unlocalized string | `Network Smoothing` | core\libraries\core\option\core.lua | 1163 |
| `lia.option.add:name` | Unlocalized string | `Smoothing Time` | core\libraries\core\option\core.lua | 1168 |
| `lia.option.add:name` | Unlocalized string | `Voice Range` | core\libraries\core\option\core.lua | 1176 |
| `lia.option.add:name` | Unlocalized string | `Weapon Selector Position` | core\libraries\core\option\core.lua | 1182 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 203
- **Used Net Messages:** 205
- **Defined But Unused:** 0
- **Used But Undefined:** 2

### Used But Undefined

- `liaCheckSeed`
  - Used at: net.Start at core/libraries/core/protection/core.lua:361; net.Receive at core/libraries/core/protection/netcalls.lua:13
- `liaInsertKeyPressed`
  - Used at: net.Start at core/libraries/core/protection/core.lua:350; net.Receive at core/libraries/core/protection/netcalls.lua:1

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 3
- **Module-Specific Used But Undefined:** 0

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

- `liaBlindFade` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/commands.lua:796; net.Start at modules/administration/commands.lua:842; net.Start at modules/administration/commands.lua:1179; net.Start at modules/administration/commands.lua:1204; net.Receive at modules/administration/netcalls/client.lua:42
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaManagesitrooms` in module `administration`
  - Reason: Used only by module "administration" but defined outside that module
  - Usage sites: net.Start at modules/administration/commands.lua:407; net.Receive at modules/administration/netcalls/client.lua:96
  - Definition sites: init.lua networkStrings at init.lua:2
- `liaVendorSyncPresets` in module `vendor`
  - Reason: Used only by module "vendor" but defined outside that module
  - Usage sites: net.Start at modules/vendor/commands.lua:75; net.Start at modules/vendor/libraries/server.lua:171; net.Receive at modules/vendor/netcalls/client.lua:144; net.Start at modules/vendor/netcalls/server.lua:67; net.Start at modules/vendor/netcalls/server.lua:96
  - Definition sites: init.lua networkStrings at init.lua:2

#### Module-Specific Used But Undefined

None

### Direction / Flow Issues

Total suspicious patterns: **1**

- `liaBinaryQuestionRequestCancel`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: unknown
  - Sender sites: None
  - Receiver sites: core/libraries/core/option/netcalls.lua:129

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 54
- **Referenced Panels:** 83
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
