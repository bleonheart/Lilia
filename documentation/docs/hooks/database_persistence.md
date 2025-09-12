## Database & Persistence

---

### OnEntityPersistUpdated

**Purpose**

Notifies that a persistent entity's stored data has been updated and saved.

**Parameters**

* `ent` (*Entity*): The persistent entity.
* `data` (*table*): The saved persistence payload for this entity.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnEntityPersistUpdated", "LogVendorSave", function(ent, data)
    if IsValid(ent) and ent:GetClass() == "lia_vendor" then
        print("Vendor persistence updated:", data.name or "")
    end
end)
```

---

### UpdateEntityPersistence

**Purpose**

Request that the gamemode re-save a persistent entity's data to disk.

**Parameters**

* `ent` (*Entity*): The persistent entity to update.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
-- After editing a vendor entity, persist changes immediately
hook.Run("UpdateEntityPersistence", vendor)
```

---

### SaveData

**Purpose**

Called when the server saves data to disk. Allows adding custom data to the save payload.

**Parameters**

* `data` (*table*): Save data table to populate.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("SaveData", "SaveCustomData", function(data)
    data.customValue = "example"
end)
```

---

### OnDataSet

**Purpose**

Fires when a key-value pair is stored in the server's data system.

**Parameters**

* `key` (*string*): Data key that was set.
* `value` (*any*): Value that was stored.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnDataSet", "LogDataChanges", function(key, value)
    print("Data set:", key, "=", tostring(value))
end)
```

---

### PersistenceSave

**Purpose**

Called before an entity's persistence data is saved to disk.

**Parameters**

* `ent` (*Entity*): Entity being saved.
* `data` (*table*): Persistence data being saved.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PersistenceSave", "AddTimestamp", function(ent, data)
    data.lastSaved = os.time()
end)
```

---

### CanPersistEntity

**Purpose**

Determines if an entity should be saved for persistence.

**Parameters**

* `ent` (*Entity*): Entity to check.

**Returns**

- boolean: False to prevent persistence.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanPersistEntity", "NoTempEntities", function(ent)
    if ent:IsTemporary() then
        return false
    end
end)
```

---

### GetEntitySaveData

**Purpose**

Allows modification of the data saved for an entity's persistence.

**Parameters**

* `ent` (*Entity*): Entity being saved.
* `data` (*table*): Current save data.

**Returns**

* `modifiedData` (*table*): Modified save data.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("GetEntitySaveData", "AddMetadata", function(ent, data)
    data.metadata = {savedBy = "system"}
    return data
end)
```

---

### OnEntityPersisted

**Purpose**

Fires when an entity has been successfully saved to persistence.

**Parameters**

* `ent` (*Entity*): Entity that was saved.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnEntityPersisted", "LogPersistence", function(ent)
    print("Entity persisted:", ent:GetClass())
end)
```

---

### OnEntityLoaded

**Purpose**

Called when a persistent entity is loaded from disk.

**Parameters**

* `ent` (*Entity*): Entity that was loaded.
* `data` (*table*): Loaded persistence data.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnEntityLoaded", "RestoreState", function(ent, data)
    if data.health then
        ent:SetHealth(data.health)
    end
end)
```

---

### LoadData

**Purpose**

Called when the server loads saved data from disk.

**Parameters**

* `data` (*table*): Loaded data table.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("LoadData", "LoadCustomData", function(data)
    if data.customValue then
        print("Loaded custom value:", data.customValue)
    end
end)
```

---

### PostLoadData

**Purpose**

Runs after all saved data has been loaded and processed.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PostLoadData", "InitializeAfterLoad", function()
    print("All data loaded successfully")
end)
```

---

### ShouldDataBeSaved

**Purpose**

Determines if a specific data key should be saved to disk.

**Parameters**

* `key` (*string*): Data key to check.

**Returns**

- boolean: False to skip saving this key.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("ShouldDataBeSaved", "SkipTempData", function(key)
    if string.find(key, "temp_") then
        return false
    end
end)
```

---

### DatabaseConnected

**Purpose**

Fires when the database connection is established.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("DatabaseConnected", "InitDatabase", function()
    print("Database connection established")
end)
```

---

### CanSaveData

**Purpose**

Checks if data can be saved at this time.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

- boolean: False to prevent saving.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanSaveData", "PreventSaveDuringEvent", function()
    if game.GetGlobalState("event_active") then
        return false
    end
end)
```

---

### SetupDatabase

**Purpose**

Called during database initialization to set up tables and schema.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("SetupDatabase", "CreateCustomTables", function()
    -- Custom table creation logic
end)
```

---

### OnDatabaseLoaded

**Purpose**

Fires after the database schema and initial data have been loaded.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnDatabaseLoaded", "PostDatabaseInit", function()
    print("Database fully loaded")
end)
```

---

### OnWipeTables

**Purpose**

Called when database tables are being wiped/reset.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnWipeTables", "BackupBeforeWipe", function()
    -- Backup logic before wipe
end)
```

---

### LiliaTablesLoaded

**Purpose**

Fires when all Lilia database tables have been loaded and are ready.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("LiliaTablesLoaded", "InitializeModules", function()
    -- Initialize modules that depend on database tables
end)
```

---

### OnLoadTables

**Purpose**

Called during the table loading process.

**Parameters**

* `tableName` (*string*): Name of the table being loaded.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnLoadTables", "LogTableLoading", function(tableName)
    print("Loading table:", tableName)
end)
```

---

### OnItemRegistered

**Purpose**

Fires when an item is registered in the system.

**Parameters**

* `item` (*table*): Item data that was registered.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnItemRegistered", "LogItemRegistration", function(item)
    print("Item registered:", item.name)
end)
```

---

### OnCharVarChanged

**Purpose**

Called when a character variable changes.

**Parameters**

* `character` (*Character*): Character whose variable changed.
* `key` (*string*): Variable key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnCharVarChanged", "LogCharChanges", function(character, key, old, new)
    print("Character var changed:", key, "from", old, "to", new)
end)
```

---

### OnCharLocalVarChanged

**Purpose**

Fires when a character's local variable changes.

**Parameters**

* `character` (*Character*): Character whose variable changed.
* `key` (*string*): Variable key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("OnCharLocalVarChanged", "UpdateUI", function(character, key, old, new)
    -- Update UI elements based on local var changes
end)
```

---

### LocalVarChanged

**Purpose**

Called when any local variable changes.

**Parameters**

* `key` (*string*): Variable key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("LocalVarChanged", "TrackChanges", function(key, old, new)
    print("Local var changed:", key)
end)
```

---

### NetVarChanged

**Purpose**

Fires when a network variable changes.

**Parameters**

* `entity` (*Entity*): Entity whose netvar changed.
* `key` (*string*): Variable key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("NetVarChanged", "MonitorNetVars", function(ent, key, old, new)
    print("NetVar changed on", ent, ":", key)
end)
```

---

### ItemDataChanged

**Purpose**

Called when an item's data changes.

**Parameters**

* `item` (*Item*): Item whose data changed.
* `key` (*string*): Data key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("ItemDataChanged", "LogItemData", function(item, key, old, new)
    print("Item data changed:", item:getName(), key)
end)
```

---

### ItemQuantityChanged

**Purpose**

Fires when an item's quantity changes.

**Parameters**

* `item` (*Item*): Item whose quantity changed.
* `oldQuantity` (*number*): Previous quantity.
* `newQuantity` (*number*): New quantity.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("ItemQuantityChanged", "TrackQuantity", function(item, old, new)
    print("Quantity changed from", old, "to", new)
end)
```

---

### InventoryDataChanged

**Purpose**

Called when inventory data changes.

**Parameters**

* `inventory` (*Inventory*): Inventory whose data changed.
* `key` (*string*): Data key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InventoryDataChanged", "LogInventoryData", function(inv, key, old, new)
    print("Inventory data changed:", key)
end)
```

---

### InventoryInitialized

**Purpose**

Fires when an inventory is initialized.

**Parameters**

* `inventory` (*Inventory*): Inventory that was initialized.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InventoryInitialized", "SetupInventory", function(inv)
    print("Inventory initialized with ID:", inv:getID())
end)
```

---

### InventoryItemAdded

**Purpose**

Called when an item is added to an inventory.

**Parameters**

* `inventory` (*Inventory*): Inventory that received the item.
* `item` (*Item*): Item that was added.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InventoryItemAdded", "LogItemAddition", function(inv, item)
    print("Item added to inventory:", item:getName())
end)
```

---

### InventoryItemRemoved

**Purpose**

Fires when an item is removed from an inventory.

**Parameters**

* `inventory` (*Inventory*): Inventory that lost the item.
* `item` (*Item*): Item that was removed.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InventoryItemRemoved", "LogItemRemoval", function(inv, item)
    print("Item removed from inventory:", item:getName())
end)
```

---

### InventoryDeleted

**Purpose**

Called when an inventory is deleted.

**Parameters**

* `inventory` (*Inventory*): Inventory that was deleted.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InventoryDeleted", "CleanupInventory", function(inv)
    print("Inventory deleted:", inv:getID())
end)
```

---

### ItemDeleted

**Purpose**

Fires when an item is deleted.

**Parameters**

* `item` (*Item*): Item that was deleted.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("ItemDeleted", "LogItemDeletion", function(item)
    print("Item deleted:", item:getName())
end)
```

---

### ItemInitialized

**Purpose**

Called when an item is initialized.

**Parameters**

* `item` (*Item*): Item that was initialized.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("ItemInitialized", "SetupItem", function(item)
    print("Item initialized:", item:getName())
end)
```

---

### OnCharDisconnect

**Purpose**

Fires when a character disconnects.

**Parameters**

* `character` (*Character*): Character that disconnected.
* `client` (*Player*): Player who owned the character.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharDisconnect", "LogDisconnect", function(character, client)
    print("Character disconnected:", character:getName())
end)
```

---

### CharPreSave

**Purpose**

Called before a character is saved.

**Parameters**

* `character` (*Character*): Character being saved.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CharPreSave", "PrepareSave", function(character)
    -- Prepare character data before saving
end)
```

---

### CharPostSave

**Purpose**

Fires after a character is saved.

**Parameters**

* `character` (*Character*): Character that was saved.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CharPostSave", "PostSaveActions", function(character)
    print("Character saved:", character:getName())
end)
```

---

### CharLoaded

**Purpose**

Called when a character is loaded.

**Parameters**

* `character` (*Character*): Character that was loaded.
* `client` (*Player*): Player who loaded the character.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CharLoaded", "WelcomeMessage", function(character, client)
    client:ChatPrint("Welcome back, " .. character:getName())
end)
```

---

### PreCharDelete

**Purpose**

Fires before a character is deleted.

**Parameters**

* `character` (*Character*): Character being deleted.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PreCharDelete", "BackupCharacter", function(character)
    -- Create backup before deletion
end)
```

---

### OnCharDelete

**Purpose**

Called when a character is deleted.

**Parameters**

* `character` (*Character*): Character that was deleted.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharDelete", "LogDeletion", function(character)
    print("Character deleted:", character:getName())
end)
```

---

### OnCharCreated

**Purpose**

Fires when a character is created.

**Parameters**

* `character` (*Character*): Character that was created.
* `client` (*Player*): Player who created the character.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharCreated", "WelcomeNew", function(character, client)
    client:ChatPrint("Welcome to the server, " .. character:getName())
end)
```

---

### OnTransferred

**Purpose**

Called when something is transferred.

**Parameters**

* `old` (*any*): Previous state/location.
* `new` (*any*): New state/location.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnTransferred", "LogTransfer", function(old, new)
    print("Transfer occurred from", old, "to", new)
end)
```

---

### CharListLoaded

**Purpose**

Fires when the character list is loaded.

**Parameters**

* `characters` (*table*): List of characters.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CharListLoaded", "ProcessCharacters", function(characters)
    print("Character list loaded with", #characters, "characters")
end)
```

---

### CharListUpdated

**Purpose**

Called when the character list is updated.

**Parameters**

* `characters` (*table*): Updated character list.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CharListUpdated", "RefreshUI", function(characters)
    -- Refresh character selection UI
end)
```

---

### CharListExtraDetails

**Purpose**

Allows adding extra details to character list entries.

**Parameters**

* `character` (*Character*): Character to add details for.

**Returns**

* `details` (*table*): Extra details to display.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CharListExtraDetails", "AddLevel", function(character)
    return {level = character:getData("level", 1)}
end)
```

---

### KickedFromChar

**Purpose**

Fires when a player is kicked from a character.

**Parameters**

* `character` (*Character*): Character the player was kicked from.
* `reason` (*string*): Reason for the kick.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("KickedFromChar", "LogKick", function(character, reason)
    print("Player kicked from character:", reason)
end)
```

---

### OnCharCreated

**Purpose**

Called when a character is created (duplicate - see above).

**Parameters**

* `character` (*Character*): Character that was created.
* `client` (*Player*): Player who created the character.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharCreated", "SetupNewChar", function(character, client)
    -- Setup new character data
end)
```

---

### CharRestored

**Purpose**

Fires when a character is restored.

**Parameters**

* `character` (*Character*): Character that was restored.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("CharRestored", "LogRestore", function(character)
    print("Character restored:", character:getName())
end)
```

---

### CreateDefaultInventory

**Purpose**

Called to create a default inventory.

**Parameters**

* `client` (*Player*): Player to create inventory for.

**Returns**

* `inventory` (*Inventory*): Created inventory.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CreateDefaultInventory", "SetupDefaultInv", function(client)
    -- Create and return default inventory
end)
```

---

### CreateInventoryPanel

**Purpose**

Fires when an inventory panel is created.

**Parameters**

* `inventory` (*Inventory*): Inventory the panel is for.

**Returns**

* `panel` (*Panel*): Created inventory panel.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CreateInventoryPanel", "CustomPanel", function(inventory)
    -- Create and return custom inventory panel
end)
```

---

### DoModuleIncludes

**Purpose**

Called during module inclusion process.

**Parameters**

* `moduleName` (*string*): Name of the module being included.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("DoModuleIncludes", "LogIncludes", function(moduleName)
    print("Including module:", moduleName)
end)
```

---

### InitializedConfig

**Purpose**

Fires when configuration is initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedConfig", "PostConfigInit", function()
    print("Configuration initialized")
end)
```

---

### InitializedItems

**Purpose**

Called when items are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedItems", "PostItemInit", function()
    print("Items initialized")
end)
```

---

### InitializedModules

**Purpose**

Fires when modules are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedModules", "PostModuleInit", function()
    print("Modules initialized")
end)
```

---

### InitializedOptions

**Purpose**

Called when options are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedOptions", "PostOptionInit", function()
    print("Options initialized")
end)
```

---

### InitializedSchema

**Purpose**

Fires when schema is initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedSchema", "PostSchemaInit", function()
    print("Schema initialized")
end)
```

---

### OnPlayerPurchaseDoor

**Purpose**

Called when a player purchases a door.

**Parameters**

* `client` (*Player*): Player who purchased the door.
* `door` (*Entity*): Door that was purchased.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnPlayerPurchaseDoor", "LogPurchase", function(client, door)
    print(client:Nick(), "purchased door")
end)
```

---

### OnServerLog

**Purpose**

Fires when a server log entry is created.

**Parameters**

* `message` (*string*): Log message.
* `category` (*string*): Log category.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnServerLog", "CustomLogging", function(message, category)
    -- Custom log processing
end)
```

---

### PlayerMessageSend

**Purpose**

Called when a player sends a message.

**Parameters**

* `client` (*Player*): Player who sent the message.
* `chatType` (*string*): Type of chat message.
* `message` (*string*): Message content.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerMessageSend", "LogMessages", function(client, chatType, message)
    print(client:Nick(), "sent", chatType, ":", message)
end)
```

---

### ChatParsed

**Purpose**

Fires when a chat message is parsed.

**Parameters**

* `speaker` (*Player*): Player who sent the message.
* `text` (*string*): Original message text.
* `chatType` (*string*): Type of chat.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("ChatParsed", "ProcessChat", function(speaker, text, chatType)
    -- Process parsed chat message
end)
```

---

### OnConfigUpdated

**Purpose**

Called when configuration is updated.

**Parameters**

* `key` (*string*): Configuration key that was updated.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnConfigUpdated", "LogConfigChange", function(key, old, new)
    print("Config updated:", key, "from", old, "to", new)
end)
```

---

### OnOOCMessageSent

**Purpose**

Fires when an out-of-character message is sent.

**Parameters**

* `client` (*Player*): Player who sent the message.
* `text` (*string*): Message content.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnOOCMessageSent", "ProcessOOC", function(client, text)
    -- Process OOC message
end)
```

---

### OnSalaryGive

**Purpose**

Called when salary is given to a player.

**Parameters**

* `client` (*Player*): Player receiving salary.
* `amount` (*number*): Salary amount.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnSalaryGive", "LogSalary", function(client, amount)
    print(client:Nick(), "received salary:", amount)
end)
```

---

### OnTicketClaimed

**Purpose**

Fires when a ticket is claimed.

**Parameters**

* `ticket` (*table*): Ticket that was claimed.
* `claimer` (*Player*): Player who claimed the ticket.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnTicketClaimed", "ProcessClaim", function(ticket, claimer)
    -- Process ticket claim
end)
```

---

### OnTicketClosed

**Purpose**

Called when a ticket is closed.

**Parameters**

* `ticket` (*table*): Ticket that was closed.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnTicketClosed", "ProcessClosure", function(ticket)
    -- Process ticket closure
end)
```

---

### OnTicketCreated

**Purpose**

Fires when a ticket is created.

**Parameters**

* `ticket` (*table*): Ticket that was created.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnTicketCreated", "ProcessCreation", function(ticket)
    -- Process ticket creation
end)
```

---

### OnVendorEdited

**Purpose**

Called when a vendor is edited.

**Parameters**

* `vendor` (*Entity*): Vendor that was edited.
* `client` (*Player*): Player who edited the vendor.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnVendorEdited", "LogEdit", function(vendor, client)
    print("Vendor edited by", client:Nick())
end)
```

---

### CanPlayerEquipItem

**Purpose**

Queries if a player can equip an item. Returning false stops the equip action.

**Parameters**

* `client` (*Player*): Player equipping.

* `item` (*table*): Item to equip.

**Returns**

- boolean: False to block equipping

**Realm**

**Server**

**Example Usage**

```lua
-- Allow equipping only if level requirement met.
hook.Add("CanPlayerEquipItem", "CheckLevel", function(ply, item)
    if item.minLevel and ply:getChar():getAttrib("level", 0) < item.minLevel then
        return false
    end
end)
```

---

### CanPlayerUnequipItem

**Purpose**

Called before an item is unequipped. Return false to keep the item equipped.

**Parameters**

* `client` (*Player*): Player unequipping.

* `item` (*table*): Item being unequipped.

**Returns**

- boolean: False to prevent unequipping

**Realm**

**Server**

**Example Usage**

```lua
-- Prevent unequipping cursed gear.
hook.Add("CanPlayerUnequipItem", "Cursed", function(ply, item)
    if item.cursed then
        return false
    end
end)
```

---

### CanPlayerRotateItem

**Purpose**

Called when a player attempts to rotate an inventory item. Return false to block rotating.

**Parameters**

* `client` (*Player*): Player rotating.
* `item` (*table*): Item being rotated.

**Returns**

- boolean: False to block rotating

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanPlayerRotateItem", "NoRotatingArtifacts", function(ply, item)
    if item.isArtifact then
        return false
    end
end)
```

---

### PostPlayerSay

**Purpose**

Runs after chat messages are processed. Allows reacting to player chat.

**Parameters**

* `client` (*Player*): Speaking player.

* `message` (*string*): Chat text.

* `chatType` (*string*): Chat channel.

* `anonymous` (*boolean*): Whether the message was anonymous.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
-- Log all OOC chat.
hook.Add("PostPlayerSay", "LogOOC", function(ply, msg, chatType)
    if chatType == "ooc" then
        print("[OOC]", ply:Nick(), msg)
    end
end)
```

---

### ShouldSpawnClientRagdoll

**Purpose**

Decides if a corpse ragdoll should spawn for a player. Return false to skip ragdoll creation.

**Parameters**

* `client` (*Player*): Player that died.

**Returns**

- boolean: False to skip ragdoll

**Realm**

**Server**

**Example Usage**

```lua
-- Disable ragdolls for bots.
hook.Add("ShouldSpawnClientRagdoll", "NoBotRagdoll", function(ply)
    if ply:IsBot() then
        return false
    end
end)
```

