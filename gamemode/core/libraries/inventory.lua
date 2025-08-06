lia.inventory = lia.inventory or {}
lia.inventory.types = lia.inventory.types or {}
lia.inventory.instances = lia.inventory.instances or {}
local function serverOnly(value)
    return SERVER and value or nil
end

local InvTypeStructType = {
    __index = "table",
    add = serverOnly("function"),
    remove = serverOnly("function"),
    sync = serverOnly("function"),
    typeID = "string",
    className = "string"
}

local function checkType(typeID, struct, expected, prefix)
    prefix = prefix or ""
    for key, expectedType in pairs(expected) do
        local actualValue = struct[key]
        local expectedTypeString = isstring(expectedType) and expectedType or type(expectedType)
        local fieldName = prefix .. key
        assert(type(actualValue) == expectedTypeString, L("invTypeMismatch", fieldName, expectedTypeString, typeID, type(actualValue)))
        if istable(expectedType) then checkType(typeID, actualValue, expectedType, prefix .. key .. ".") end
    end
end

--[[
    lia.inventory.newType

    Purpose:
        Registers a new inventory type with the given typeID and structure. 
        Ensures the structure matches the expected format and stores it for later use.

    Parameters:
        typeID (string) - The unique identifier for the inventory type.
        invTypeStruct (table) - The structure/table describing the inventory type.

    Returns:
        None.

    Realm:
        Shared.

    Example Usage:
        lia.inventory.newType("backpack", {
            __index = {},
            add = function(self, item) self.items[#self.items + 1] = item end,
            remove = function(self, item) table.RemoveByValue(self.items, item) end,
            sync = function(self) end,
            typeID = "backpack",
            className = "liaBackpack",
            config = {size = 20}
        })
]]
function lia.inventory.newType(typeID, invTypeStruct)
    assert(not lia.inventory.types[typeID], L("duplicateInventoryType", typeID))
    assert(istable(invTypeStruct), L("expectedTableArg", 2))
    checkType(typeID, invTypeStruct, InvTypeStructType)
    debug.getregistry()[invTypeStruct.className] = invTypeStruct
    lia.inventory.types[typeID] = invTypeStruct
end

--[[
    lia.inventory.new

    Purpose:
        Creates a new inventory instance of the specified typeID, initializing its items and config.

    Parameters:
        typeID (string) - The type identifier of the inventory to create.

    Returns:
        inventory (table) - The new inventory instance.

    Realm:
        Shared.

    Example Usage:
        local inv = lia.inventory.new("backpack")
        print(inv.config.size) -- prints the size from the config
]]
function lia.inventory.new(typeID)
    local class = lia.inventory.types[typeID]
    assert(class ~= nil, L("badInventoryType", typeID))
    return setmetatable({
        items = {},
        config = table.Copy(class.config)
    }, class)
end

if SERVER then
    local INV_FIELDS = {"invID", "_invType", "charID"}
    local INV_TABLE = "inventories"
    local DATA_FIELDS = {"key", "value"}
    local DATA_TABLE = "invdata"
    local ITEMS_TABLE = "items"

    --[[
        lia.inventory.loadByID

        Purpose:
            Loads an inventory instance by its ID, optionally using a cache. 
            Supports custom inventory type loaders.

        Parameters:
            id (number) - The inventory ID to load.
            noCache (boolean) - If true, ignores the cache and reloads from storage.

        Returns:
            deferred (deferred) - A deferred object that resolves to the loaded inventory instance.

        Realm:
            Server.

        Example Usage:
            lia.inventory.loadByID(123):next(function(inv)
                print("Loaded inventory with ID:", inv.id)
            end)
    ]]
    function lia.inventory.loadByID(id, noCache)
        local instance = lia.inventory.instances[id]
        if instance and not noCache then
            local d = deferred.new()
            d:resolve(instance)
            return d
        end

        for _, invType in pairs(lia.inventory.types) do
            local loadFunction = rawget(invType, "loadFromStorage")
            if loadFunction then
                local d = loadFunction(invType, id)
                if d then return d end
            end
        end

        assert(isnumber(id) and id >= 0, L("noInventoryLoader", tostring(id)))
        return lia.inventory.loadFromDefaultStorage(id, noCache)
    end

    --[[
        lia.inventory.loadFromDefaultStorage

        Purpose:
            Loads an inventory from the default storage backend using its ID.

        Parameters:
            id (number) - The inventory ID to load.
            noCache (boolean) - If true, ignores the cache and reloads from storage.

        Returns:
            deferred (deferred) - A deferred object that resolves to the loaded inventory instance.

        Realm:
            Server.

        Example Usage:
            lia.inventory.loadFromDefaultStorage(123):next(function(inv)
                print("Loaded inventory from default storage:", inv.id)
            end)
    ]]
    function lia.inventory.loadFromDefaultStorage(id, noCache)
        return deferred.all({lia.db.select(INV_FIELDS, INV_TABLE, "invID = " .. id, 1), lia.db.select(DATA_FIELDS, DATA_TABLE, "invID = " .. id)}):next(function(res)
            if lia.inventory.instances[id] and not noCache then return lia.inventory.instances[id] end
            local results = res[1].results and res[1].results[1] or nil
            if not results then return end
            local typeID = results._invType
            local invType = lia.inventory.types[typeID]
            if not invType then
                lia.error(L("inventoryInvalidType", id, typeID))
                return
            end

            local instance = invType:new()
            instance.id = id
            instance.data = {}
            for _, row in ipairs(res[2].results or {}) do
                local decoded = util.JSONToTable(row.value)
                instance.data[row.key] = decoded and decoded[1] or nil
            end

            instance.data.char = tonumber(results.charID) or instance.data.char
            lia.inventory.instances[id] = instance
            instance:onLoaded()
            return instance:loadItems():next(function() return instance end)
        end, function(err)
            lia.information(L("failedLoadInventory", tostring(id)))
            lia.information(err)
        end)
    end

    --[[
        lia.inventory.instance

        Purpose:
            Creates and stores a new inventory instance of the given type, initializing storage and data.

        Parameters:
            typeID (string) - The type identifier of the inventory to create.
            initialData (table) - (Optional) Initial data to store in the inventory.

        Returns:
            deferred (deferred) - A deferred object that resolves to the new inventory instance.

        Realm:
            Server.

        Example Usage:
            lia.inventory.instance("backpack", {char = 1}):next(function(inv)
                print("Created inventory with ID:", inv.id)
            end)
    ]]
    function lia.inventory.instance(typeID, initialData)
        local invType = lia.inventory.types[typeID]
        assert(istable(invType), L("invalidInventoryType", tostring(typeID)))
        assert(initialData == nil or istable(initialData), L("initialDataMustBeTable"))
        initialData = initialData or {}
        return invType:initializeStorage(initialData):next(function(id)
            local instance = invType:new()
            instance.id = id
            instance.data = initialData
            lia.inventory.instances[id] = instance
            instance:onInstanced()
            return instance
        end)
    end

    --[[
        lia.inventory.loadAllFromCharID

        Purpose:
            Loads all inventories associated with a given character ID.

        Parameters:
            charID (number) - The character ID whose inventories to load.

        Returns:
            deferred (deferred) - A deferred object that resolves to a table of inventory instances.

        Realm:
            Server.

        Example Usage:
            lia.inventory.loadAllFromCharID(1):next(function(inventories)
                for _, inv in ipairs(inventories) do
                    print("Loaded inventory:", inv.id)
                end
            end)
    ]]
    function lia.inventory.loadAllFromCharID(charID)
        assert(isnumber(charID), L("charIDMustBeNumber"))
        return lia.db.select({"invID"}, INV_TABLE, "charID = " .. charID):next(function(res) return deferred.map(res.results or {}, function(result) return lia.inventory.loadByID(tonumber(result.invID)) end) end)
    end

    --[[
        lia.inventory.deleteByID

        Purpose:
            Deletes an inventory and all its associated data by its ID.

        Parameters:
            id (number) - The inventory ID to delete.

        Returns:
            None.

        Realm:
            Server.

        Example Usage:
            lia.inventory.deleteByID(123)
    ]]
    function lia.inventory.deleteByID(id)
        lia.db.delete(DATA_TABLE, "invID = " .. id)
        lia.db.delete(INV_TABLE, "invID = " .. id)
        lia.db.delete(ITEMS_TABLE, "invID = " .. id)
        local instance = lia.inventory.instances[id]
        if instance then instance:destroy() end
    end

    --[[
        lia.inventory.cleanUpForCharacter

        Purpose:
            Destroys all inventories associated with a given character.

        Parameters:
            character (table) - The character object whose inventories should be destroyed.

        Returns:
            None.

        Realm:
            Server.

        Example Usage:
            local char = client:getChar()
            lia.inventory.cleanUpForCharacter(char)
    ]]
    function lia.inventory.cleanUpForCharacter(character)
        for _, inventory in pairs(character:getInv(true)) do
            inventory:destroy()
        end
    end
else
    --[[
        lia.inventory.show

        Purpose:
            Displays the given inventory in a GUI panel, handling opening and closing hooks, and ensures only one panel per inventory is open at a time.

        Parameters:
            inventory (table) - The inventory object to display.
            parent (Panel) - (Optional) The parent panel to attach the inventory panel to.

        Returns:
            panel (Panel) - The created inventory panel.

        Realm:
            Client.

        Example Usage:
            -- Show the player's main inventory in a new panel
            local myInventory = LocalPlayer():getChar():getInv()
            local myPanel = lia.inventory.show(myInventory)

            -- Show a secondary inventory in a child panel
            local secondaryInv = someOtherInventory
            local parentPanel = vgui.Create("DFrame")
            local invPanel = lia.inventory.show(secondaryInv, parentPanel)
    ]]
    function lia.inventory.show(inventory, parent)
        local globalName = "inv" .. inventory.id
        if IsValid(lia.gui[globalName]) then lia.gui[globalName]:Remove() end
        local panel = hook.Run("CreateInventoryPanel", inventory, parent)
        hook.Run("InventoryOpened", panel, inventory)
        local oldOnRemove = panel.OnRemove
        function panel:OnRemove()
            if oldOnRemove then oldOnRemove(self) end
            hook.Run("InventoryClosed", self, inventory)
        end

        lia.gui[globalName] = panel
        return panel
    end
end
