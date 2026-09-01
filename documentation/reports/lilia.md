## Executive Summary

### Function Documentation
- **Total Functions:** 653
- **Documented:** 590 (90.4%)
- **Missing Functions:** 63 unique (63 total occurrences)
  - **Library Functions:** 62
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
- **Defined Net Messages:** 487
- **Used Net Messages:** 466
- **Defined But Unused:** 29
- **Used But Undefined:** 8

### Config Analysis
- **Undefined lia.config.get Keys:** 12
- **Undefined Inferred Localization Keys:** 0

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 54
- **Missing Documentation:** 63 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 9 functions

These functions are unused by Lilia itself but referenced by the sibling `lilia_rp` gamemode:

- `lia.data.delete` — defined in `core\libraries\core\data\core.lua:364`; used at `modules\done\bonemerge\sh_config.lua:84`; `modules\done\bonemerge\sh_config.lua:98`; `modules\done\logisticspoints\libraries\server.lua:66`
- `lia.db.createTable` — defined in `core\libraries\core\database\core.lua:432`; used at `modules\done\banking\libraries\server.lua:754`; `modules\done\banking\libraries\server.lua:2229`; `modules\done\chess\chess\sv_database.lua:4`; `modules\done\chess\chess\sv_database.lua:135`; `modules\done\marketplace\libraries\server.lua:7`
- `lia.db.exists` — defined in `core\libraries\core\database\core.lua:263`; used at `modules\done\banking\libraries\server.lua:1044`
- `lia.db.selectWithCondition` — defined in `core\libraries\core\database\core.lua:235`; used at `modules\done\banking\entities\entities\lia_atm\init.lua:25`; `modules\done\banking\libraries\server.lua:26`; `modules\done\banking\libraries\server.lua:54`; `modules\done\banking\libraries\server.lua:92`; `modules\done\banking\libraries\server.lua:190`
- `lia.faction.getAll` — defined in `core\libraries\core\factions\core.lua:150`; used at `modules\done\factionrelationships\libraries\shared.lua:100`
- `lia.item.getItemByID` — defined in `core\libraries\core\item\core.lua:179`; used at `modules\done\propbasedbuilding\libraries\server.lua:137`
- `lia.item.newInv` — defined in `core\libraries\core\item\core.lua:379`; used at `modules\done\corpselooting\libraries\sv_hooks.lua:41`; `modules\done\corpselooting\libraries\sv_hooks.lua:42`
- `lia.item.overrideItem` — defined in `core\libraries\core\item\core.lua:325`; used at `modules\done\policesuite\libraries\shared.lua:222`
- `lia.util.findPlayerItemsByClass` — defined in `core\libraries\core\util\core.lua:131`; used at `modules\done\drugs\libraries\server.lua:8`

### Missing Library Functions
Total: 62 functions

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

#### lia.darkrp
Count: 10 functions

- `lia.darkrp.api.defineChatCommand(cmd, callback)`
- `lia.darkrp.api.definePrivilegedChatCommand(cmd, privilege, callback)`
- `lia.darkrp.api.getCategories()`
- `lia.darkrp.api.getJobByCommand(command)`
- `lia.darkrp.api.removeChatCommand()`
- `lia.darkrp.createJob(name, data, model, description, weapons, command, max, salary, admin, vote, hasLicense, needToChangeFrom, customCheck)`
- `lia.darkrp.getEnvironment()`
- `lia.darkrp.include(path)`
- `lia.darkrp.load(path, realm)`
- `lia.darkrp.syncJobs()`

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

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `BankingAddAccountButtons`
  - module `banking` [standard] in `libraries/client.lua`
- `BankingAddOptions`
  - module `banking` [standard] in `libraries/client.lua`
- `BankingLogEntry`
  - module `banking` [standard] in `libraries/server.lua`
- `BankingPreATMOpen`
  - module `banking` [standard] in `libraries/client.lua`
- `CanPlayerViewAchievements`
  - module `achievements` [standard] in `libraries/client.lua`
- `ComputerAppPanelRegistered`
  - module `computers` [standard] in `libraries/shared.lua`
  - module `scp_computer` [standard] in `libraries/shared.lua`
- `ComputerAppWindowClosed`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerAppWindowCreated`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerButtonClicked`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerPopupClosed`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerPopupCreated`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerPopupRegistered`
  - module `computers` [standard] in `libraries/shared.lua`
- `ComputerUIBuilt`
  - module `computers` [standard] in `libraries/client.lua`
- `ComputerUIReady`
  - module `computers` [standard] in `libraries/client.lua`
  - module `scp_computer` [standard] in `libraries/shared.lua`
- `CorpseInventorySet`
  - module `corpselooting` [standard] in `libraries/sv_hooks.lua`
- `entity_killed`
  - module `bonemerge` [standard] in `cl_bonemerge.lua`
- `FineIssued`
  - module `policesuite` [standard] in `libraries/server.lua`
- `FinePaid`
  - module `policesuite` [standard] in `libraries/server.lua`
- `GetComputerBackground`
  - module `computers` [standard] in `libraries/client.lua`
- `GetComputerScreenBounds`
  - module `computers` [standard] in `libraries/client.lua`
- `getModelGender`
  - module `identifications` [standard] in `config.lua`
- `liaInjuriesPostPlayerRevive`
  - module `injuries` [standard] in `entities/weapons/lia_defibrilator/init.lua`
- `MedalsDataUpdated`
  - module `medals` [standard] in `libraries/client.lua`
- `OnCorpseCreated`
  - module `corpselooting` [standard] in `libraries/sv_hooks.lua`
- `OnDescGeneratorCompleted`
  - module `identifications` [standard] in `libraries/client.lua`
- `OnPropertyDataReceived`
  - module `realtor` [standard] in `libraries/client.lua`
- `PlayerArrested`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PlayerCanGiveMedals`
  - module `medals` [standard] in `libraries/server.lua`
- `PlayerCanTakeMedals`
  - module `medals` [standard] in `libraries/server.lua`
- `PlayerHandcuffed`
  - module `handcuffs` [standard] in `meta/server.lua`
- `PlayerMedalsChanged`
  - module `medals` [standard] in `libraries/server.lua`
- `PlayerReleased`
  - module `handcuffs` [standard] in `meta/server.lua`
- `PlayerReleasedFromJail`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PlayerReleasedOffline`
  - module `policesuite` [standard] in `libraries/server.lua`
- `PoliceComputerAddRegistrySection`
  - module `policesuite` [standard] in `libraries/client.lua`
- `RobberyLootGranted`
  - module `robberies` [standard] in `libraries/server.lua`
- `RobberyMinigameFinished`
  - module `robberies` [standard] in `libraries/server.lua`
- `RobberyMinigameStarted`
  - module `robberies` [standard] in `libraries/server.lua`
- `ShouldRadioBeep`
  - submodule `radio` [standard] in `libraries/shared.lua`
  - module `radio` [standard] in `libraries/shared.lua`
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
- `ToggleLock`
  - module `caroptions` [standard] in `pim.lua`
- `Vkeycards_PostRenderScreen`
  - module `keycards` [standard] in `entities/entities/scp_access_scanner/cl_init.lua`
- `VKeycardsOverrideRender`
  - module `keycards` [standard] in `entities/entities/scp_access_scanner/cl_init.lua`
- `VKeycardsPreventRender`
  - module `keycards` [standard] in `entities/entities/scp_access_scanner/cl_init.lua`
- `WarOperationEnded`
  - module `factionrelationships` [standard] in `libraries/server.lua`
- `WarOperationStarted`
  - module `factionrelationships` [standard] in `libraries/server.lua`
- `WarrantIssued`
  - module `policesuite` [standard] in `libraries/server.lua`
- `WarrantsCleared`
  - module `policesuite` [standard] in `libraries/server.lua`
- `WarRelationChanged`
  - module `factionrelationships` [standard] in `libraries/server.lua`

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

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 487
- **Used Net Messages:** 466
- **Defined But Unused:** 29
- **Used But Undefined:** 8

### Used But Undefined

- `liaBankingTransferMoney`
  - Used at: net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371
- `liaBankingValidateAccount`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:59; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:63; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46
- `liaCarSpawnOpenMenu`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/entities/entities/lia_cardealer/init.lua:82; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:1
- `liaCheckSeed`
  - Used at: net.Start at core/libraries/core/protection/core.lua:361; net.Receive at core/libraries/core/protection/netcalls.lua:13
- `liaInsertKeyPressed`
  - Used at: net.Start at core/libraries/core/protection/core.lua:350; net.Receive at core/libraries/core/protection/netcalls.lua:1
- `liaJobNpcCloseDialog`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:852; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:908; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1420
- `liaLevelingPrestige`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:506; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:189
- `liaLevelingSpendAttrib`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:424; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:152

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 3
- **Module-Specific Used But Undefined:** 5

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

- `liaBankingTransferMoney` in module `banking`
  - Reason: Used only by module "banking" and not defined anywhere
  - Usage sites: net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371
- `liaBankingValidateAccount` in module `banking`
  - Reason: Used only by module "banking" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:59; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:63; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46
- `liaCarSpawnOpenMenu` in module `carspawner`
  - Reason: Used only by module "carspawner" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/entities/entities/lia_cardealer/init.lua:82; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:1
- `liaLevelingPrestige` in module `leveling`
  - Reason: Used only by module "leveling" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:506; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:189
- `liaLevelingSpendAttrib` in module `leveling`
  - Reason: Used only by module "leveling" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:424; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:152

### Direction / Flow Issues

Total suspicious patterns: **73**

- `Bonemerge.ConvertModel`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:181
  - Receiver sites: None
- `Bonemerge.RequestSync`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sh_clothing.lua:29999
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:469
- `Bonemerge.StartAdjustingItem`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:172
- `car_spawner_purchase`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:85
  - Receiver sites: None
- `liaAcquireSkill`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:140
- `liaAllMedalsData`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:235; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:245; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:297; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:301
  - Receiver sites: None
- `liaBankingAdminTestDeposit`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2945
- `liaBankingAdminTestReceive`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3037
- `liaBankingAdminTestRequest`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3013
- `liaBankingAdminTestWithdraw`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2979
- `liaBankingConfigUpdate`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2514
- `liaBankingGetAccountDetails`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2379
- `liaBankingOpenBankerUI`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1722
- `liaBankingReceiveAccountName`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1296; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1300
  - Receiver sites: None
- `liaBankingReceiveMemberPermissions`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1256
  - Receiver sites: None
- `liaBankingRedeemCheckAtATM`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1650
- `liaBankingRequestConfig`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2462
- `liaBankingRequestMemberPermissions`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1223
- `liaBankingRetrievePaycheck`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:517
- `liaBankingTransferMoney`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371
- `liaBankingUpdateMember`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1125
- `liaBankingValidateAccount`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:59; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:63
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46
- `liaBinaryQuestionRequestCancel`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: unknown
  - Sender sites: None
  - Receiver sites: core/libraries/core/option/netcalls.lua:129
- `liaBrowserNavigate`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_browser.lua:118
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:168
- `liaChessClientCallDraw`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1542; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1554
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2169
- `liaChessClientRequestMove`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1445
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2120
- `liaChessClientResign`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1533; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1638; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_draughts_board.lua:774
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2137
- `liaChessClientWager`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1628; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1647
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2226
- `liaChessDrawOffer`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1523; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2164; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_draughts_board.lua:764
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1998; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2144
- `liaChessGameOver`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:236; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:985; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:999; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1380; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1396
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1999
- `liaChessPromotionSelection`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1358; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2031; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2044; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2057; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2070
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2017; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2323
- `liaChessTop10`
  - Reason: Message appears to send and receive only on the client side
  - Send sides: client
  - Receive sides: client
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/chess/cl_top.lua:36
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/chess/cl_top.lua:89
- `liaChessUpdate`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:914
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2083
- `liaEmailFetch`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:846; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:850
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:358
- `liaEmailMarkRead`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:659
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:494
- `liaEmailRegister`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:874
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:363
- `liaEmailSend`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_email.lua:919
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:408
- `liaFOBRequestRespawnList`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:293
- `liaGiveMedalToPlayer`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:307
- `liaInjuryTestAdd`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:180
- `liaInjuryTestClearAll`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:241
- `liaInjuryTestRemove`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:209
- `liaInjuryTestUpdate`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:205; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:237; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:257
  - Receiver sites: None
- `liaJailerOpenViewPrisoners`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2636
- `liaJobNpcCloseDialog`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:852; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:908; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1420; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1550; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:1606
  - Receiver sites: None
- `lialootDpMny`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:64
  - Receiver sites: None
- `lialootExit`
  - Reason: Message has senders but no detected receivers
  - Send sides: client, server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:89; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:131; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:107
  - Receiver sites: None
- `lialootMoney`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:143
  - Receiver sites: None
- `lialootOpen`
  - Reason: Message has senders but no detected receivers
  - Send sides: client, server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:20; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:121
  - Receiver sites: None
- `lialootWdMny`
  - Reason: Message has senders but no detected receivers
  - Send sides: client
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:43
  - Receiver sites: None
- `liaMarketplaceRequestListMenu`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:323
- `liaNotesDelete`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_notes.lua:486
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:130
- `liaNotesFetch`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_notes.lua:443
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:70
- `liaNotesSave`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/apps/sh_notes.lua:466
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:82
- `liapadScreen`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cameras/items/pad.lua:59
  - Receiver sites: None
- `liaPoliceComputerOpen`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2641
- `liaPoliceJailsSync`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:49
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:65
- `liaPolicePayAllFinesFromAccount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2646
- `liaPolicePayFineFromAccount`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2633
- `liaPoliceSetRank`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2893
- `liaRadioComlinkAnim`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:340; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:373; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/shared.lua:355; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/shared.lua:427
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:182; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:213
- `liaRadioTransmit`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:335; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:350; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:367; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/shared.lua:383; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/shared.lua:347
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:137; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:168
- `liaRecruiterNpcCloseDialog`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/recruiternpc/config/server.lua:86; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/recruiternpc/config/server.lua:102
  - Receiver sites: None
- `liaReportsFetch`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:2040; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:2048
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3299
- `liaReportsSave`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:1982
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3325
- `liaRequestAllMedals`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:227
- `liaTakeMedalFromPlayer`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:327
- `lootDpMny`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:183
- `lootExit`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:113
- `lootMoney`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:33
- `lootOpen`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client, server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:161; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:129
- `lootWdMny`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:163
- `ReceiveSyringeMessage`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/extraction/libraries/client.lua:1

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 69
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 14
- **Registered But Unused:** 0

### Module Panels Outside derma

| Panel | Module | Location | Expected Folder |
|---|---|---|---|
| `ClothingVendor` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:612` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `playerEquipSlot` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:738` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `playerPanel` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:887` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `playerEquipSlot` | `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:1097` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` |
| `liaFramePlain` | `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/client.lua:10` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\derma` |
| `liaCraftItemModel` | `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:328` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` |
| `liaCrafting` | `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1267` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` |
| `liaWarManager` | `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1073` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\derma` |
| `liaCharacterDescGenerator` | `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:579` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\derma` |
| `liaLootMenu` | `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:260` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\derma` |
| `liaPoliceComputer` | `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:1572` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\derma` |
| `liaFenceSellPanel` | `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:598` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` |
| `liaFenceBuyPanel` | `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:995` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` |
| `liaRobberyMinigamePanel` | `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1879` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` |

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 266
- **UI / Derma Code Outside derma:** 14

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:771` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:776` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:854` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1063` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1191` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1691` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1722` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1727` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1840` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1845` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1929` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:2528` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:2544` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:2559` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3528` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3533` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3547` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3782` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:39` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:69` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:169` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:245` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:469` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:517` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:536` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:654` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:977` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:985` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1019` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1125` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1178` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1223` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1263` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1284` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1306` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1351` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1403` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1650` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1691` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1771` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1820` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1866` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2056` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2080` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2121` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2379` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2462` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2463` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2514` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2557` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2616` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2672` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2719` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2811` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2843` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2945` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2979` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3013` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3037` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/client.lua:74` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/client.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/client.lua:177` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/server.lua:152` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `blackmarket` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/blackmarket/libraries/server.lua:160` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:121` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:122` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:156` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:172` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_network.lua:173` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:368` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:410` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:416` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:422` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/sv_network.lua:469` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\netcalls` | Module net handler is outside the netcalls folder |
| `cameras` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cameras/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cameras\netcalls` | Module net handler is outside the netcalls folder |
| `cameras` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cameras/libraries/server.lua:118` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cameras\netcalls` | Module net handler is outside the netcalls folder |
| `cameras` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cameras/libraries/server.lua:119` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cameras\netcalls` | Module net handler is outside the netcalls folder |
| `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/client.lua:1549` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\netcalls` | Module net handler is outside the netcalls folder |
| `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/server.lua:569` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\netcalls` | Module net handler is outside the netcalls folder |
| `carspawner` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/carspawner/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/derma/cl_phone_dialer.lua:497` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/derma/cl_phone_dialer.lua:498` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/libraries/server.lua:609` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/libraries/server.lua:614` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `cellphones` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cellphones/libraries/server.lua:622` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/chess/cl_top.lua:89` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1998` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:1999` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2017` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2083` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2120` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2137` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2144` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2169` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2226` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `chess` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/chess/entities/entities/lia_chess_board.lua:2323` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess\netcalls` | Module net handler is outside the netcalls folder |
| `clearance` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/clearance/libraries/client.lua:397` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\netcalls` | Module net handler is outside the netcalls folder |
| `clearance` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/clearance/libraries/server.lua:318` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/client.lua:879` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/client.lua:886` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/client.lua:895` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:70` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:82` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:130` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:168` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:358` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:363` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:408` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `computers` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/libraries/server.lua:494` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:33` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/cl_hooks.lua:161` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:113` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:129` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:163` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_hooks.lua:183` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `corpselooting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/corpselooting/libraries/sv_networking.lua:9` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1268` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1274` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1346` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1357` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/server.lua:14` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/server.lua:54` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/server.lua:76` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\netcalls` | Module net handler is outside the netcalls folder |
| `disks` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/disks/libraries/client.lua:795` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\disks\netcalls` | Module net handler is outside the netcalls folder |
| `disks` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/disks/libraries/client.lua:801` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\disks\netcalls` | Module net handler is outside the netcalls folder |
| `disks` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/disks/libraries/server.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\disks\netcalls` | Module net handler is outside the netcalls folder |
| `disks` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/disks/libraries/server.lua:7` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\disks\netcalls` | Module net handler is outside the netcalls folder |
| `dt_scrambler` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/dt_scrambler/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\dt_scrambler\netcalls` | Module net handler is outside the netcalls folder |
| `extraction` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/extraction/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction\netcalls` | Module net handler is outside the netcalls folder |
| `factionmessages` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionmessages/libraries/client.lua:103` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\netcalls` | Module net handler is outside the netcalls folder |
| `factionmessages` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionmessages/libraries/server.lua:76` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\netcalls` | Module net handler is outside the netcalls folder |
| `factionmessages` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionmessages/libraries/server.lua:81` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1097` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1103` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:355` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:356` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:363` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/server.lua:370` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\netcalls` | Module net handler is outside the netcalls folder |
| `handcuffs` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/handcuffs/libraries/client.lua:61` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\netcalls` | Module net handler is outside the netcalls folder |
| `handcuffs` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/handcuffs/libraries/client.lua:88` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\netcalls` | Module net handler is outside the netcalls folder |
| `handcuffs` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/handcuffs/libraries/server.lua:383` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs\netcalls` | Module net handler is outside the netcalls folder |
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:312` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\netcalls` | Module net handler is outside the netcalls folder |
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:318` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\netcalls` | Module net handler is outside the netcalls folder |
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/server.lua:53` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/entities/weapons/lia_surgicalkit/cl_init.lua:49` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/entities/weapons/lia_surgicalkit/cl_init.lua:54` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/client.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/client.lua:156` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:173` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:180` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:209` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `injuries` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/injuries/libraries/server.lua:241` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/derma/cl_scanneradmin.lua:342` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/libraries/cl_keycards.lua:134` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/libraries/sv_keycards.lua:500` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `keycards` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/keycards/libraries/sv_keycards.lua:522` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:11` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/client.lua:35` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:140` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:152` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `leveling` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/leveling/libraries/server.lua:189` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/client.lua:351` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/client.lua:352` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/client.lua:363` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:351` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:352` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:357` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `logisticspoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/logisticspoints/libraries/server.lua:389` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints\netcalls` | Module net handler is outside the netcalls folder |
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:312` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\netcalls` | Module net handler is outside the netcalls folder |
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:321` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\netcalls` | Module net handler is outside the netcalls folder |
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/server.lua:1` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:2` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:341` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:346` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:355` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:859` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/client.lua:869` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:291` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:297` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:303` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:308` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:323` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:473` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `marketplace` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/marketplace/libraries/server.lua:484` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/client.lua:697` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:119` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:227` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:307` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:327` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:1573` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2061` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2557` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2595` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2636` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2641` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2694` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:2868` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:3128` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:3134` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:3142` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:1906` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2374` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2496` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2542` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2633` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2646` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2658` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2670` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2874` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2893` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2949` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:2981` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3299` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/server.lua:3325` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/shared.lua:65` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/entities/weapons/lia_radio/init.lua:94` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/entities/weapons/lia_radio/init.lua:105` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/entities/weapons/lia_radio/init.lua:112` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/client.lua:154` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/client.lua:179` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:137` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:144` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:157` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:172` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/computers/radio/libraries/server.lua:182` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/entities/weapons/lia_radio/init.lua:97` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/entities/weapons/lia_radio/init.lua:108` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/entities/weapons/lia_radio/init.lua:115` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/client.lua:154` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/client.lua:179` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:168` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:175` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:188` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:203` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `radio` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/radio/libraries/server.lua:213` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\netcalls` | Module net handler is outside the netcalls folder |
| `realtor` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/realtor/libraries/server.lua:64` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:920` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:966` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/client.lua:971` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:208` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:293` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:299` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `respawnpoints` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/respawnpoints/libraries/server.lua:327` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:603` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:613` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:632` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1000` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1005` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1880` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1886` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1891` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1152` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1187` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1382` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1398` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/server.lua:1470` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\netcalls` | Module net handler is outside the netcalls folder |
| `scp_computer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/scp_computer/libraries/client.lua:131` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\netcalls` | Module net handler is outside the netcalls folder |
| `scp_computer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/scp_computer/libraries/server.lua:1143` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\netcalls` | Module net handler is outside the netcalls folder |
| `scp_computer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/scp_computer/libraries/server.lua:1184` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/client.lua:243` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/client.lua:270` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/client.lua:271` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/server.lua:663` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |
| `vehiclebeacons` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/vehiclebeacons/libraries/server.lua:668` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:612` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:738` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:887` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `bonemerge` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/bonemerge/cl_vendor.lua:1097` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\derma` | Module Derma code is outside the derma folder |
| `cardealer` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/cardealer/libraries/client.lua:10` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer\derma` | Module Derma code is outside the derma folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:328` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` | Module Derma code is outside the derma folder |
| `crafting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/crafting/libraries/client.lua:1267` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting\derma` | Module Derma code is outside the derma folder |
| `factionrelationships` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/factionrelationships/libraries/client.lua:1073` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships\derma` | Module Derma code is outside the derma folder |
| `identifications` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/identifications/libraries/client.lua:579` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications\derma` | Module Derma code is outside the derma folder |
| `looting` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/looting/libraries/client.lua:260` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting\derma` | Module Derma code is outside the derma folder |
| `policesuite` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/policesuite/libraries/client.lua:1572` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite\derma` | Module Derma code is outside the derma folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:598` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` | Module Derma code is outside the derma folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:995` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` | Module Derma code is outside the derma folder |
| `robberies` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/robberies/libraries/client.lua:1879` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies\derma` | Module Derma code is outside the derma folder |

---

## Config: Undefined lia.config.get Keys

Total: **12** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `ChatColor` | 2 |
| `ChatRange` | 4 |
| `ControlConquestable` | 1 |
| `ControlMinPlayers` | 1 |
| `ControlRadius` | 1 |
| `ControlSpawnUnowned` | 1 |
| `bonemergeSurgeryPrice` | 2 |

### Details

#### `ChatColor`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\libraries\shared.lua** line 20: `onChatAdd = function(speaker, text) chat.AddText(Color(0, 200, 0), "[Phone] ", lia.config.get("ChatColor"), speaker:Name() .. ": " .. text) end,`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones\libraries\shared.lua** line 46: `chat.AddText(Color(0, 150, 255), "[SMS] ", lia.config.get("ChatColor"), "PHONE NUMBER: " .. phoneNumber .. ": " .. text)`

#### `ChatRange`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua** line 81: `local speakRange = lia.config.get("ChatRange", 280)`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio\libraries\shared.lua** line 147: `local speakRange = lia.config.get("ChatRange", 280)`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\libraries\shared.lua** line 81: `local speakRange = lia.config.get("ChatRange", 280)`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio\libraries\shared.lua** line 147: `local speakRange = lia.config.get("ChatRange", 280)`

#### `ControlConquestable`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\init.lua** line 52: `if settings.conquestable == nil then settings.conquestable = (definition and definition.conquestable) or lia.config.get("ControlConquestable", true) end`

#### `ControlMinPlayers`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\init.lua** line 51: `if settings.minDefenders == nil then settings.minDefenders = (definition and definition.minDefenders) or lia.config.get("ControlMinPlayers", MODULE.DEFAULT_MIN_DEFENDERS or 1) end`

#### `ControlRadius`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\entities\entities\lia_controlpoint\init.lua** line 50: `if settings.radius == nil then settings.radius = (definition and definition.radius) or lia.config.get("ControlRadius", MODULE.DEFAULT_RADIUS or 200) end`

#### `ControlSpawnUnowned`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories\libraries\server.lua** line 107: `if settings.owner == nil and not lia.config.get("ControlSpawnUnowned", false) then`

#### `bonemergeSurgeryPrice`

- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\cl_network.lua** line 83: `local surgeryPrice = lia.config.get("bonemergeSurgeryPrice", 5000)`
- **D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge\sv_network.lua** line 92: `Response = function() return "Excellent! Plastic surgery costs " .. lia.currency.get(lia.config.get("bonemergeSurgeryPrice", 5000)) .. ". Would you like to proceed?" end,`

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements`

### Module Documentation Report

- **Undocumented Hooks:**
  - `CanPlayerViewAchievements()`

- **Undocumented Meta Functions:**
  - `playerMeta:hasAchievement()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.animations.getBoneTable()`
  - `lia.animations.performAnimation()`
  - `lia.animations.resetBones()`
  - `lia.animations.toggleAnimation()`
  - `lia.animations.updateAnimation()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\armors`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.armors.equipArmor()`
  - `lia.armors.getEquippedArmorData()`
  - `lia.armors.getInstalledMods()`
  - `lia.armors.getModBonuses()`
  - `lia.armors.refreshArmorEffects()`
  - `lia.armors.registerArmor()`
  - `lia.armors.registerMod()`
  - `lia.armors.resolvePlayerModel()`
  - `lia.armors.unequipArmor()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking`

### Module Documentation Report

- **Undocumented Hooks:**
  - `BankingAddAccountButtons()`
  - `BankingAddOptions()`
  - `BankingLogEntry()`
  - `BankingPreATMOpen()`

- **Undocumented lia.* Functions:**
  - `lia.banking.AddBankLog()`
  - `lia.banking.canCreateAccount()`
  - `lia.banking.getNextAccountType()`
  - `lia.banking.getRegisteredActions()`
  - `lia.banking.openAdminPanel()`
  - `lia.banking.openCheckViewer()`
  - `lia.banking.openItemBankCL()`
  - `lia.banking.openManageMembers()`
  - `lia.banking.receiveBankBalance()`
  - `lia.banking.refreshBankingUI()`
  - `lia.banking.registerAction()`
  - `lia.banking.registerCheck()`
  - `lia.banking.sendCheck()`
  - `lia.banking.showAdminAccountDetails()`
  - `lia.banking.showAdminDeleteAccountDialog()`
  - `lia.banking.showDeleteAccountDialog()`
  - `lia.banking.showMemberPermissions()`
  - `lia.banking.showMemberPermissionsDialog()`
  - `lia.banking.showPaycheckDepositDialog()`
  - `lia.banking.showRedeemCheckDialog()`
  - `lia.banking.showRemoveMemberDialog()`
  - `lia.banking.showRenameDialog()`
  - `lia.banking.showRequestSubPanel()`
  - `lia.banking.showTransactionHistory()`
  - `lia.banking.showTransferDialog()`
  - `lia.banking.showTransferSubPanel()`
  - `lia.banking.showViewRequests()`
  - `lia.banking.showWithdrawDialog()`
  - `lia.banking.viewBankAccountAsAdmin()`
  - `lia.banking.writeCheck()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.blackmarket.getLocations()`
  - `lia.blackmarket.loadLocationsFromDisk()`
  - `lia.blackmarket.registerBlackMarketItem()`
  - `lia.blackmarket.saveLocations()`
  - `lia.blackmarket.swapNPCPosition()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge`

### Module Documentation Report

- **Undocumented Hooks:**
  - `entity_killed()`

- **Undocumented Meta Functions:**
  - `entMeta:GetBonemergedChildren()`
  - `entMeta:GetBonemergedChildrenBySlot()`
  - `entMeta:GetGender()`
  - `entMeta:IsFemale()`
  - `entMeta:IsMale()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.cardealer.addGarage()`
  - `lia.cardealer.checkVehicleRequirements()`
  - `lia.cardealer.getAllGarages()`
  - `lia.cardealer.getData()`
  - `lia.cardealer.getNearestAvailableGarage()`
  - `lia.cardealer.getNearestGarage()`
  - `lia.cardealer.getNPCCategorySelection()`
  - `lia.cardealer.getOwnedCars()`
  - `lia.cardealer.getRestrictedFactionNames()`
  - `lia.cardealer.getRestrictedFactions()`
  - `lia.cardealer.getVehicleCategories()`
  - `lia.cardealer.getVehicleCategory()`
  - `lia.cardealer.getVehicleModel()`
  - `lia.cardealer.getVehiclesForNPC()`
  - `lia.cardealer.hasValidModel()`
  - `lia.cardealer.loadDataFromDisk()`
  - `lia.cardealer.loadStoredGarages()`
  - `lia.cardealer.normalizeCategorySelection()`
  - `lia.cardealer.npcAllowsVehicle()`
  - `lia.cardealer.openCategoryConfigUI()`
  - `lia.cardealer.registerVehicle()`
  - `lia.cardealer.removeGarage()`
  - `lia.cardealer.renameGarage()`
  - `lia.cardealer.repairVehicleByID()`
  - `lia.cardealer.saveData()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ToggleLock()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.cellphones.answerSession()`
  - `lia.cellphones.beginTelephoneRinging()`
  - `lia.cellphones.buildDialerPayload()`
  - `lia.cellphones.buildOriginEndpoint()`
  - `lia.cellphones.clearPlayerState()`
  - `lia.cellphones.clearTelephoneState()`
  - `lia.cellphones.copyEndpoint()`
  - `lia.cellphones.createSession()`
  - `lia.cellphones.endCallForPlayer()`
  - `lia.cellphones.endSession()`
  - `lia.cellphones.findPlayerByPhoneNumber()`
  - `lia.cellphones.findTelephoneByNumber()`
  - `lia.cellphones.generatePhoneNumber()`
  - `lia.cellphones.getConnectedPeer()`
  - `lia.cellphones.getEndpointUser()`
  - `lia.cellphones.getPeerEndpoint()`
  - `lia.cellphones.getPlayerCellphoneItem()`
  - `lia.cellphones.getPlayerPhoneNumber()`
  - `lia.cellphones.getPlayerSession()`
  - `lia.cellphones.getSessionByID()`
  - `lia.cellphones.getSessionByNumber()`
  - `lia.cellphones.hangup()`
  - `lia.cellphones.isCellphoneNumberTaken()`
  - `lia.cellphones.isPhoneNumberTaken()`
  - `lia.cellphones.isTelephoneNumberTaken()`
  - `lia.cellphones.linkVoiceUsers()`
  - `lia.cellphones.normalizePhoneNumber()`
  - `lia.cellphones.openCellphoneDialer()`
  - `lia.cellphones.openDialer()`
  - `lia.cellphones.openTelephoneDialer()`
  - `lia.cellphones.resolveNumber()`
  - `lia.cellphones.sendDialer()`
  - `lia.cellphones.sendSessionUpdate()`
  - `lia.cellphones.setPlayerSessionState()`
  - `lia.cellphones.startCall()`
  - `lia.cellphones.startCallFromCellphone()`
  - `lia.cellphones.stopTelephoneRinging()`

- **Undocumented Meta Functions:**
  - `playerMeta:connectedPair()`
  - `playerMeta:getPartner()`
  - `playerMeta:hasCallPair()`
  - `playerMeta:setPartner()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess`

### Module Documentation Report

- **Undocumented Meta Functions:**
  - `playerMeta:chessDraw()`
  - `playerMeta:chessWin()`
  - `playerMeta:doChessElo()`
  - `playerMeta:doDraughtsElo()`
  - `playerMeta:draughtsDraw()`
  - `playerMeta:draughtsWin()`
  - `playerMeta:expectedChessWin()`
  - `playerMeta:expectedDraughtsWin()`
  - `playerMeta:getChessElo()`
  - `playerMeta:getChessEloWithRecognition()`
  - `playerMeta:getChessKFactor()`
  - `playerMeta:getDraughtsElo()`
  - `playerMeta:getDraughtsEloWithRecognition()`
  - `playerMeta:getDraughtsKFactor()`
  - `playerMeta:setChessElo()`
  - `playerMeta:setDraughtsElo()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ComputerAppPanelRegistered()`
  - `ComputerAppWindowClosed()`
  - `ComputerAppWindowCreated()`
  - `ComputerButtonClicked()`
  - `ComputerPopupClosed()`
  - `ComputerPopupCreated()`
  - `ComputerPopupRegistered()`
  - `ComputerUIBuilt()`
  - `ComputerUIReady()`
  - `GetComputerBackground()`
  - `GetComputerScreenBounds()`

- **Undocumented lia.* Functions:**
  - `lia.computers.generateButton()`
  - `lia.computers.generateComputer()`
  - `lia.computers.getAppPanelDefinition()`
  - `lia.computers.getButtonsForComputer()`
  - `lia.computers.getComputer()`
  - `lia.computers.getPopupDefinition()`
  - `lia.computers.registerAppPanel()`
  - `lia.computers.registerPopup()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ShouldRadioBeep()`

- **Undocumented lia.* Functions:**
  - `lia.radio.canAccessEncryptedFrequency()`
  - `lia.radio.canAccessStaticalRadio()`
  - `lia.radio.checkEncryptedFrequencyStatus()`
  - `lia.radio.getPresetName()`
  - `lia.radio.isVoiceViable()`
  - `lia.radio.registerEncryptedFrequency()`
  - `lia.radio.registerPresetFrequency()`
  - `lia.radio.startStaticMonitoring()`
  - `lia.radio.stopStaticMonitoring()`

- **Undocumented Meta Functions:**
  - `playerMeta:getPlayerRadioFrequency()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting`

### Module Documentation Report

- **Undocumented Hooks:**
  - `CorpseInventorySet()`
  - `OnCorpseCreated()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.crafting.generateCraftingRecipe()`
  - `lia.crafting.generateCraftingTable()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.drugs.applyDrugEffect()`
  - `lia.drugs.clearPlayerDrugEffects()`
  - `lia.drugs.collectDrug()`
  - `lia.drugs.formatTimeRemaining()`
  - `lia.drugs.getActiveDrugEffectInfo()`
  - `lia.drugs.getActiveMultiplier()`
  - `lia.drugs.getClientMultiplier()`
  - `lia.drugs.getEffectDisplayName()`
  - `lia.drugs.handleDrugOverdose()`
  - `lia.drugs.hasActiveDrugEffect()`
  - `lia.drugs.isEffectExpiringSoon()`
  - `lia.drugs.isPlayerProducingDrugs()`
  - `lia.drugs.processDrug()`
  - `lia.drugs.recalcRunSpeed()`
  - `lia.drugs.resetAllDrugItems()`
  - `lia.drugs.resetDrugProcessors()`
  - `lia.drugs.resetPlantedPlants()`
  - `lia.drugs.setupBasicUtilityFunctionality()`
  - `lia.drugs.setupDrugProcessorFunctionality()`
  - `lia.drugs.setupFilledSoilFunctionality()`
  - `lia.drugs.setupPotFunctionality()`
  - `lia.drugs.startOrRefreshGrowthTimer()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships`

### Module Documentation Report

- **Undocumented Hooks:**
  - `WarOperationEnded()`
  - `WarOperationStarted()`
  - `WarRelationChanged()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.armors.equipArmor()`
  - `lia.armors.getEquippedArmorData()`
  - `lia.armors.getInstalledMods()`
  - `lia.armors.getModBonuses()`
  - `lia.armors.refreshArmorEffects()`
  - `lia.armors.registerArmor()`
  - `lia.armors.registerMod()`
  - `lia.armors.resolvePlayerModel()`
  - `lia.armors.unequipArmor()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.food.registerFood()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.gathering.generateEntity()`
  - `lia.gathering.generateItems()`
  - `lia.gathering.handleReward()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs`

### Module Documentation Report

- **Undocumented Hooks:**
  - `PlayerHandcuffed()`
  - `PlayerReleased()`

- **Undocumented lia.* Functions:**
  - `lia.tying.searchPlayer()`
  - `lia.tying.stopSearching()`

- **Undocumented Meta Functions:**
  - `playerMeta:GetDragee()`
  - `playerMeta:GetDragger()`
  - `playerMeta:GetTyingData()`
  - `playerMeta:HandcuffPlayer()`
  - `playerMeta:IsBeingSearched()`
  - `playerMeta:IsBlinded()`
  - `playerMeta:IsDragged()`
  - `playerMeta:IsDraggingSomeone()`
  - `playerMeta:IsGagged()`
  - `playerMeta:IsHandcuffed()`
  - `playerMeta:RemoveHandcuffs()`
  - `playerMeta:SetDrag()`
  - `playerMeta:SetTyingData()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications`

### Module Documentation Report

- **Undocumented Hooks:**
  - `getModelGender()`
  - `OnDescGeneratorCompleted()`

- **Undocumented lia.* Functions:**
  - `lia.identifications.generateDescription()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries`

### Module Documentation Report

- **Undocumented Hooks:**
  - `liaInjuriesPostPlayerRevive()`

- **Undocumented Meta Functions:**
  - `playerMeta:addInjury()`
  - `playerMeta:clearAllInjuries()`
  - `playerMeta:hasInjury()`
  - `playerMeta:removeInjury()`

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling`

### Module Documentation Report

- **Undocumented Meta Functions:**
  - `characterMeta:acquireSkill()`
  - `characterMeta:canAcquireSkill()`
  - `characterMeta:canPrestige()`
  - `characterMeta:getLevel()`
  - `characterMeta:getLevelingProgress()`
  - `characterMeta:getLevelXP()`
  - `characterMeta:getMaxXPForLevel()`
  - `characterMeta:getPrestige()`
  - `characterMeta:getSkillPoints()`
  - `characterMeta:getXP()`
  - `characterMeta:giveSkillPoints()`
  - `characterMeta:giveXP()`
  - `characterMeta:hasSkill()`
  - `characterMeta:isLevel()`
  - `characterMeta:isLevelExact()`
  - `characterMeta:pastLvlXP()`
  - `characterMeta:setPrestige()`
  - `characterMeta:setSkillAcquired()`
  - `characterMeta:setSkillPoints()`
  - `characterMeta:setXP()`
  - `characterMeta:spendSkillPoints()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.resourcesystem.addLog()`
  - `lia.resourcesystem.addLP()`
  - `lia.resourcesystem.buildState()`
  - `lia.resourcesystem.calculateDepositLP()`
  - `lia.resourcesystem.canPurchaseReward()`
  - `lia.resourcesystem.canSpendLP()`
  - `lia.resourcesystem.depositResource()`
  - `lia.resourcesystem.getAverageResourceDemand()`
  - `lia.resourcesystem.getAverageResourceSupply()`
  - `lia.resourcesystem.getLogPage()`
  - `lia.resourcesystem.getLogs()`
  - `lia.resourcesystem.getLP()`
  - `lia.resourcesystem.getNodeResourceField()`
  - `lia.resourcesystem.getResourceChoices()`
  - `lia.resourcesystem.getResourceDemand()`
  - `lia.resourcesystem.getResourceIDFromItem()`
  - `lia.resourcesystem.getStoredResources()`
  - `lia.resourcesystem.getSupplyDemandMultiplier()`
  - `lia.resourcesystem.initializePersistence()`
  - `lia.resourcesystem.openDepot()`
  - `lia.resourcesystem.purchaseReward()`
  - `lia.resourcesystem.registerNode()`
  - `lia.resourcesystem.registerResource()`
  - `lia.resourcesystem.registerReward()`
  - `lia.resourcesystem.removeResourceItems()`
  - `lia.resourcesystem.sendLogPage()`
  - `lia.resourcesystem.setLogs()`
  - `lia.resourcesystem.setLP()`
  - `lia.resourcesystem.setStoredResources()`
  - `lia.resourcesystem.syncState()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.loot.checkSkillRequirements()`
  - `lia.loot.generateContents()`
  - `lia.loot.generateWeightedContents()`
  - `lia.loot.pickWeightedItem()`
  - `lia.loot.registerLoot()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.marketplace.adminChangeItemValue()`
  - `lia.marketplace.adminRemoveItem()`
  - `lia.marketplace.buyItem()`
  - `lia.marketplace.getCharListings()`
  - `lia.marketplace.getListingInfo()`
  - `lia.marketplace.getListings()`
  - `lia.marketplace.listItem()`
  - `lia.marketplace.openAdminMenu()`
  - `lia.marketplace.openMarketplace()`
  - `lia.marketplace.openValueChangeDialog()`
  - `lia.marketplace.receivePage()`
  - `lia.marketplace.showListMenu()`
  - `lia.marketplace.unlistItem()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals`

### Module Documentation Report

- **Undocumented Hooks:**
  - `MedalsDataUpdated()`
  - `PlayerCanGiveMedals()`
  - `PlayerCanTakeMedals()`
  - `PlayerMedalsChanged()`

- **Undocumented lia.* Functions:**
  - `lia.medals.getAll()`
  - `lia.medals.getCharacterMedals()`
  - `lia.medals.getIconPath()`
  - `lia.medals.getIconURL()`
  - `lia.medals.registerMedal()`

- **Undocumented Meta Functions:**
  - `playerMeta:canGiveMedals()`
  - `playerMeta:canTakeMedals()`
  - `playerMeta:giveMedal()`
  - `playerMeta:giveMedalWorn()`
  - `playerMeta:medalsID()`
  - `playerMeta:takeMedal()`

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite`

### Module Documentation Report

- **Undocumented Hooks:**
  - `FineIssued()`
  - `FinePaid()`
  - `PlayerArrested()`
  - `PlayerReleasedFromJail()`
  - `PlayerReleasedOffline()`
  - `PoliceComputerAddRegistrySection()`
  - `WarrantIssued()`
  - `WarrantsCleared()`

- **Undocumented lia.* Functions:**
  - `lia.police.askQuizQuestion()`
  - `lia.police.clearAllWarrants()`
  - `lia.police.finishQuiz()`
  - `lia.police.getJailFilePath()`
  - `lia.police.getJailMapKey()`
  - `lia.police.getJails()`
  - `lia.police.getLegalArrestReasons()`
  - `lia.police.getQuizResults()`
  - `lia.police.getQuizResultsByCharID()`
  - `lia.police.hasActiveWarrants()`
  - `lia.police.issueFine()`
  - `lia.police.payAllFinesFromAccount()`
  - `lia.police.payFine()`
  - `lia.police.payFineFromAccount()`
  - `lia.police.saveJails()`
  - `lia.police.saveQuizResult()`
  - `lia.police.syncJails()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ShouldRadioBeep()`

- **Undocumented lia.* Functions:**
  - `lia.radio.canAccessEncryptedFrequency()`
  - `lia.radio.canAccessStaticalRadio()`
  - `lia.radio.checkEncryptedFrequencyStatus()`
  - `lia.radio.getPresetName()`
  - `lia.radio.isVoiceViable()`
  - `lia.radio.registerEncryptedFrequency()`
  - `lia.radio.registerPresetFrequency()`
  - `lia.radio.startStaticMonitoring()`
  - `lia.radio.stopStaticMonitoring()`

- **Undocumented Meta Functions:**
  - `playerMeta:getPlayerRadioFrequency()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.ranking.canDemote()`
  - `lia.ranking.canHire()`
  - `lia.ranking.canKick()`
  - `lia.ranking.canPromote()`
  - `lia.ranking.demotePlayer()`
  - `lia.ranking.getRankTable()`
  - `lia.ranking.hirePlayer()`
  - `lia.ranking.kickPlayer()`
  - `lia.ranking.promotePlayer()`
  - `lia.ranking.registerRank()`
  - `lia.ranking.setRank()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor`

### Module Documentation Report

- **Undocumented Hooks:**
  - `OnPropertyDataReceived()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies`

### Module Documentation Report

- **Undocumented Hooks:**
  - `RobberyLootGranted()`
  - `RobberyMinigameFinished()`
  - `RobberyMinigameStarted()`

- **Undocumented lia.* Functions:**
  - `lia.robberies.beginEntityCooldown()`
  - `lia.robberies.canRob()`
  - `lia.robberies.registerEntity()`
  - `lia.robberies.releaseEntity()`
  - `lia.robberies.reserveEntity()`
  - `lia.robberies.robberyReward()`

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.territories.register()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.terrorism.armWithManualDetonator()`
  - `lia.terrorism.armWithTimer()`
  - `lia.terrorism.explodeDoor()`
  - `lia.terrorism.explodePlantedBomb()`
  - `lia.terrorism.explodeVehicle()`
  - `lia.terrorism.explodeWorldBomb()`
  - `lia.terrorism.getBombsByOwner()`
  - `lia.terrorism.getPlantedBombs()`
  - `lia.terrorism.placeWorldBombDetonator()`
  - `lia.terrorism.placeWorldBombTimer()`
  - `lia.terrorism.registerBomb()`
  - `lia.terrorism.setupPlantedBomb()`
  - `lia.terrorism.unregisterBomb()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.vehiclebeacons.checkVehicleRequirements()`
  - `lia.vehiclebeacons.getDeploymentTime()`
  - `lia.vehiclebeacons.getDespawnTime()`
  - `lia.vehiclebeacons.getGroundedVehiclePosition()`
  - `lia.vehiclebeacons.getResolvedVehicleClass()`
  - `lia.vehiclebeacons.getRestrictedFactionNames()`
  - `lia.vehiclebeacons.getRestrictedFactions()`
  - `lia.vehiclebeacons.getVehicleData()`
  - `lia.vehiclebeacons.getVehicleModel()`
  - `lia.vehiclebeacons.isLFSVehicle()`
  - `lia.vehiclebeacons.isSimfphysVehicle()`
  - `lia.vehiclebeacons.registerVehicle()`
  - `lia.vehiclebeacons.validatePlacement()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\achievements | 1 | 0 | 1 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\anim | 0 | 5 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\armors | 0 | 9 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking | 4 | 30 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\blackmarket | 0 | 5 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\bonemerge | 1 | 0 | 5 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cameras | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cardealer | 0 | 25 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\caroptions | 1 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\carspawner | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\cellphones | 0 | 37 | 4 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\chess | 0 | 0 | 16 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\clearance | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers | 11 | 8 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\computers\radio | 1 | 9 | 1 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\corpselooting | 2 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\crafting | 0 | 2 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\delivery | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\disks | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs | 0 | 22 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\dt_scrambler | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\events | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\extraction | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionmessages | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\factionrelationships | 3 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors | 0 | 9 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\food | 0 | 1 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\gathering | 0 | 3 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\handcuffs | 2 | 2 | 13 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\helpnpc | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\identifications | 2 | 1 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\injuries | 1 | 0 | 4 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\keycards | 3 | 36 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\leveling | 0 | 0 | 21 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\limbdamage | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\logisticspoints | 0 | 30 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\looting | 0 | 5 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\lscs | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\marketplace | 0 | 13 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals | 4 | 5 | 6 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medical_npc_injuries | 0 | 18 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\policesuite | 8 | 17 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\propbasedbuilding | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\radio | 1 | 9 | 1 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\ranking | 0 | 11 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\realtor | 1 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\recruiternpc | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\respawnpoints | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\robberies | 3 | 6 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\scp_computer | 2 | 34 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\species_creator_poc | 10 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\taxi | 0 | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\territories | 0 | 1 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\terrorism | 0 | 13 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\vehiclebeacons | 0 | 13 | 0 |
