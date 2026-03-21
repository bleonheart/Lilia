--[[
    Folder: Libraries
    File: log.md
]]
--[[
    Logger

    Comprehensive logging and audit trail system for the Lilia framework.
]]
--[[
    Overview:
        The logger library provides comprehensive logging functionality for the Lilia framework, enabling detailed tracking and recording of player actions, administrative activities, and system events. It operates on the server side and automatically categorizes log entries into predefined categories such as character management, combat, world interactions, chat communications, item transactions, administrative actions, and security events. The library stores all log entries in a database table with timestamps, player information, and categorized messages. It supports dynamic log type registration and provides hooks for external systems to process log events. The logger ensures accountability and provides administrators with detailed audit trails for server management and moderation.
]]
lia.log = lia.log or {}
lia.log.types = lia.log.types or {}
local logTypeData = {
    character = {
        charRecognize = function(client, id, name) return string.format("Player %s recognized character %s (%s)", client:Name(), id, name) end,
        charCreate = function(client, character) return string.format("Player %s created character %s", client:Name(), character:getName()) end,
        charLoad = function(client, name) return string.format("Player %s loaded character %s", client:Name(), name) end,
        charDelete = function(client, id)
            local name = IsValid(client) and client:Name() or "CONSOLE"
            return string.format("%s deleted character ID %s.", name, id)
        end,
        playerSpawn = function(client) return string.format("Player '%s' spawned.", client:Name()) end,
        charsetmodel = function(client, targetName, newModel, oldModel) return string.format("Admin '%s' changed %s's model from %s to %s", client:Name(), targetName, oldModel, newModel) end,
        attribSet = function(client, targetName, attrib, value) return string.format("Admin '%s' set %s's '%s' attribute to %s.", client:Name(), targetName, attrib, value) end,
        attribAdd = function(client, targetName, attrib, value) return string.format("Admin '%s' added %s to %s's '%s' attribute.", client:Name(), value, targetName, attrib) end,
        attribCheck = function(client, targetName) return string.format("Admin '%s' viewed attributes of %s.", client:Name(), targetName) end,
    },
    combat = {
        playerHurt = function(client, attacker, damage, health) return string.format("Player '%s' took %s damage from '%s'. Current Health: %s", client:Name(), damage, attacker, health) end,
        playerDeath = function(client, attacker) return string.format("Player '%s' was killed by '%s'.", client:Name(), attacker) end,
        swep_spawning = function(client, swep) return string.format("Player '%s' spawned SWEP '%s'.", client:Name(), swep) end,
    },
    world = {
        spawned_prop = function(client, model) return string.format("Player '%s' spawned prop: %s.", client:Name(), model) end,
        spawned_ragdoll = function(client, model) return string.format("Player '%s' spawned ragdoll: %s.", client:Name(), model) end,
        spawned_effect = function(client, effect) return string.format("Player '%s' spawned effect: %s.", client:Name(), effect) end,
        spawned_vehicle = function(client, vehicle, model) return string.format("Player '%s' spawned vehicle '%s' with model '%s'.", client:Name(), vehicle, model) end,
        spawned_npc = function(client, npc, model) return string.format("Player '%s' spawned NPC '%s' with model '%s'.", client:Name(), npc, model) end,
        spawned_sent = function(client, class, model) return string.format("Player '%s' spawned entity '%s' with model '%s'.", client:Name(), class, model) end,
        vehicleEnter = function(client, class, model) return string.format("Player '%s' entered vehicle '%s' (%s).", client:Name(), class, model) end,
        vehicleExit = function(client, class, model) return string.format("Player '%s' left vehicle '%s' (%s).", client:Name(), class, model) end,
    },
    tools = {
        physgunPickup = function(client, class, model) return string.format("Player '%s' picked up '%s' (%s) with the physgun.", client:Name(), class, model) end,
        physgunDrop = function(client, class, model) return string.format("Player '%s' dropped '%s' (%s) with the physgun.", client:Name(), class, model) end,
        physgunFreeze = function(client, class, model) return string.format("Player '%s' froze '%s' (%s) with the physgun.", client:Name(), class, model) end,
        toolgunUse = function(client, tool) return string.format("Player '%s' used toolgun: '%s'.", client:Name(), tool) end,
    },
    chat = {
        chat = function(client, chatType, message) return string.format("(%s) %s said: '%s'", chatType, client:Name(), message) end,
        chatOOC = function(client, msg) return string.format("Player '%s' said (OOC): '%s'.", client:Name(), msg) end,
        chatLOOC = function(client, msg) return string.format("Player '%s' said (LOOC): '%s'.", client:Name(), msg) end,
        command = function(client, text) return string.format("Player '%s' ran command: %s.", client:Name(), text) end,
    },
    money = {
        money = function(client, amount) return string.format("Player '%s' changed money by: %s.", client:Name(), amount) end,
        moneyPickedUp = function(client, amount) return string.format("Player '%s' picked up %s %s.", client:Name(), lia.currency.get(amount), amount > 1 and lia.currency.plural or lia.currency.singular) end,
        charSetMoney = function(client, targetName, amount) return string.format("Admin '%s' set %s's money to %s.", client:Name(), targetName, lia.currency.get(amount)) end,
        charAddMoney = function(client, targetName, amount, total) return string.format("Admin '%s' gave %s %s (New Total: %s).", client:Name(), targetName, lia.currency.get(amount), lia.currency.get(total)) end,
        moneyDropped = function(client, amount) return string.format("Player '%s' dropped %s on the ground.", client:Name(), lia.currency.get(amount)) end,
        moneyDupeAttempt = function(client, message) return string.format("Player '%s' attempted money duplication: %s", client:Name(), message) end,
        giveMoneySteamID = function(_, steamID, amount, count) return string.format("Gave %s to all %s characters owned by SteamID '%s'.", steamID, lia.currency.get(amount), count) end,
    },
    items = {
        itemTake = function(client, item) return string.format("Player '%s' took item '%s'.", client:Name(), item) end,
        use = function(client, item) return string.format("Player '%s' used item '%s'.", client:Name(), item) end,
        itemDrop = function(client, item) return string.format("Player '%s' dropped item '%s'.", client:Name(), item) end,
        itemInteractionFailed = function(client, action, itemName) return string.format("Player '%s' failed to %s item '%s'.", client:Name(), action, itemName) end,
        itemInteraction = function(client, action, item) return string.format("Player '%s' %s item '%s'.", client:Name(), action, item.name) end,
        itemEquip = function(client, item) return string.format("Player '%s' equipped item '%s'.", client:Name(), item) end,
        itemUnequip = function(client, item) return string.format("Player '%s' unequipped item '%s'.", client:Name(), item) end,
        itemTransfer = function(client, itemName, fromID, toID) return string.format("Player '%s' moved item '%s' from inventory %s to %s.", client:Name(), itemName, tostring(fromID), tostring(toID)) end,
        itemTransferFailed = function(client, itemName, fromID, toID) return string.format("Player '%s' failed to move item '%s' from inventory %s to %s.", client:Name(), itemName, tostring(fromID), tostring(toID)) end,
        itemCombine = function(client, itemName, targetName) return string.format("Player '%s' combined item '%s' with '%s'.", client:Name(), itemName, targetName) end,
        itemFunction = function(client, action, itemName) return string.format("Player '%s' called item function '%s' on '%s'.", client:Name(), action, itemName) end,
        itemAdded = function(client, itemName) return string.format("Item '%s' added to %s's inventory.", itemName, IsValid(client) and client:Name() or "Unknown") end,
        itemCreated = function(_, itemName) return string.format("Item '%s' instance created.", itemName) end,
        itemSpawned = function(_, itemName) return string.format("Item '%s' spawned in the world.", itemName) end,
        itemDraggedOut = function(client, itemName) return string.format("Player '%s' dragged item '%s' out of an inventory.", client:Name(), itemName) end,
        spawnItem = function(client, displayName, message) return string.format("Player '%s' spawned an item: '%s' %s.", client:Name(), displayName, message) end,
        chargiveItem = function(client, itemName, target, message) return string.format("Player '%s' gave item '%s' to %s. Info: %s", client:Name(), itemName, target:Name(), message) end,
        vendorAccess = function(client, vendor) return string.format("%s accessed vendor %s", client:Name(), vendor:getName() or "Unknown") end,
        vendorExit = function(client, vendor) return string.format("%s exited vendor %s", client:Name(), vendor:getName() or "Unknown") end,
        vendorSell = function(client, item, vendor) return string.format("%s sold a %s to %s", client:Name(), item, vendor:getName() or "Unknown") end,
        vendorEdit = function(client, vendor, key) return string.format("%s edited vendor %s with key %s", client:Name(), vendor:getName() or "Unknown", key) end,
        vendorBuy = function(client, item, vendor, isFailed)
            if isFailed then
                return string.format("%s tried to buy a %s from %s but it failed. They likely had no space!", client:Name(), item, vendor:getName() or "Unknown")
            else
                return string.format("%s bought a %s from %s", client:Name(), item, vendor:getName() or "Unknown")
            end
        end,
        restockvendor = function(client, vendor) return string.format("%s restocked vendor %s", client:Name(), IsValid(vendor) and (vendor:getName() or "Unknown") or "Unknown") end,
        restockallvendors = function(client, count) return string.format("%s restocked all vendors (%s total)", client:Name(), count) end,
        resetvendormoney = function(client, vendor, amount) return string.format("%s set vendor %s money to %s", client:Name(), IsValid(vendor) and (vendor:getName() or "Unknown") or "Unknown", lia.currency.get(amount)) end,
        resetallvendormoney = function(client, amount, count) return string.format("%s reset all vendors money to %s (%s affected)", client:Name(), lia.currency.get(amount), count) end,
        restockvendormoney = function(client, vendor, amount) return string.format("%s restocked vendor %s money to %s", client:Name(), IsValid(vendor) and (vendor:getName() or "Unknown") or "Unknown", lia.currency.get(amount)) end,
        savevendors = function(client) return string.format("%s saved all vendor data", client:Name()) end,
    },
    permissions = {
        permissionDenied = function(client, action) return string.format("Player '%s' was denied permission to %s.", client:Name(), action) end,
        spawnDenied = function(client, objectType, model) return string.format("Player '%s' was denied from spawning %s '%s'.", client:Name(), objectType, tostring(model)) end,
        toolDenied = function(client, tool) return string.format("Player '%s' was denied tool '%s'.", client:Name(), tool) end,
    },
    admin = {
        observeToggle = function(client, state) return string.format("Player '%s' toggled observe mode %s.", client:Name(), state) end,
        configChange = function(name, oldValue, value) return string.format("Configuration changed: '%s' from '%s' to '%s'.", name, tostring(oldValue), tostring(value)) end,
        warningIssued = function(client, target, reason, severity, count, index) return string.format("Warning issued at %s by admin '%s' to player '%s' for: '%s' [Severity: %s]. Total warnings: %s (added #%s).", os.date("%Y-%m-%d %H:%M:%S"), client:Name(), IsValid(target) and target:Name() or "N/A", reason, severity or "Medium", count or 0, index or count or 0) end,
        warningRemoved = function(client, target, warning, count, index) return string.format("Warning removed at %s by admin '%s' for player '%s'. Reason: '%s'. Remaining warnings: %s (removed #%s).", os.date("%Y-%m-%d %H:%M:%S"), client:Name(), IsValid(target) and target:Name() or "N/A", warning.reason, count or 0, index or 0) end,
        viewWarns = function(client, target) return string.format("Admin '%s' viewed warnings for player '%s'.", client:Name(), IsValid(target) and target:Name() or tostring(target)) end,
        viewWarnsIssued = function(client, target) return string.format("Admin '%s' viewed warnings issued by staff '%s'.", client:Name(), IsValid(target) and target:Name() or tostring(target)) end,
        adminMode = function(client, id, message) return string.format("Admin Mode toggled at %s by '%s': %s. (ID: %s)", os.date("%Y-%m-%d %H:%M:%S"), client:Name(), message, id) end,
        forceSay = function(client, targetName, message) return string.format("Admin '%s' forced %s to say: %s", client:Name(), targetName, message) end,
        flagGive = function(client, targetName, flags) return string.format("Admin '%s' gave flags '%s' to %s.", client:Name(), targetName, flags) end,
        flagGiveAll = function(client, targetName) return string.format("Admin '%s' gave all flags to %s.", client:Name(), targetName) end,
        flagTake = function(client, targetName, flags) return string.format("Admin '%s' took flags '%s' from %s.", client:Name(), targetName, flags) end,
        flagTakeAll = function(client, targetName) return string.format("Admin '%s' removed all flags from %s.", client:Name(), targetName) end,
        voiceToggle = function(client, targetName, state) return string.format("Admin '%s' toggled voice ban for %s: %s.", client:Name(), targetName, state) end,
        charBan = function(client, targetName) return string.format("Admin '%s' banned character '%s'.", client:Name(), targetName) end,
        charUnban = function(client, targetName) return string.format("Admin '%s' unbanned character '%s'.", client:Name(), targetName) end,
        charKick = function(client, targetName) return string.format("Admin '%s' kicked character '%s'.", client:Name(), targetName) end,
        sitRoomSet = function(client, pos, message) return string.format("Administration room set at %s by '%s': %s. Position: %s", os.date("%Y-%m-%d %H:%M:%S"), client:Name(), message, pos) end,
        sitRoomRenamed = function(client, details) return string.format("%s renamed an Administration Room: %s", client:Name(), details) end,
        sitRoomRepositioned = function(client, details) return string.format("%s repositioned an Administration Room: %s", client:Name(), details) end,
        sendToSitRoom = function(client, targetName, roomName)
            if targetName == client:Name() then return string.format("Player '%s' teleported to Administration Room '%s'.", client:Name(), roomName) end
            return string.format("Player '%s' sent '%s' to Administration Room '%s'.", client:Name(), targetName, roomName)
        end,
        sitRoomReturn = function(client, targetName)
            if targetName == client:Name() then return string.format("Player '%s' returned from an Administration Room.", client:Name()) end
            return string.format("Player '%s' returned '%s' from an Administration Room.", client:Name(), targetName)
        end,
        returnItems = function(client, targetName) return string.format("Admin '%s' returned lost items to %s.", client:Name(), targetName) end,
        banOOC = function(client, targetName, steamID) return string.format("Admin '%s' banned %s (%s) from OOC chat.", client:Name(), targetName, steamID) end,
        unbanOOC = function(client, targetName, steamID) return string.format("Admin '%s' unbanned %s (%s) from OOC chat.", client:Name(), targetName, steamID) end,
        blockOOC = function(client, state) return string.format("Admin '%s' %s OOC chat globally.", client:Name(), state and "blocked" or "Unblocked") end,
        clearChat = function(client) return string.format("Admin '%s' cleared the chat.", client:Name()) end,
        altKicked = function(_, name, steamID) return string.format("Alt account '%s' (%s) was kicked.", name, steamID) end,
        altBanned = function(_, name, steamID) return string.format("Alt account '%s' (%s) was banned due to blacklist.", name, steamID) end,
        plyKick = function(client, targetName) return string.format("Admin '%s' kicked player '%s'.", client:Name(), targetName) end,
        plyBan = function(client, targetName) return string.format("Admin '%s' banned player '%s'.", client:Name(), targetName) end,
        plyUnban = function(client, targetIdentifier) return string.format("Admin '%s' unbanned player '%s'.", client:Name(), targetIdentifier) end,
        viewPlayerClaims = function(client, targetName) return string.format("Admin '%s' viewed claims for %s.", client:Name(), targetName) end,
        viewAllClaims = function(client) return string.format("Admin '%s' viewed all ticket claims.", client:Name()) end,
        viewPlayerTickets = function(client, targetName) return string.format("Admin '%s' viewed tickets for %s.", client:Name(), targetName) end,
        ticketClaimed = function(client, requester, count) return string.format("Admin '%s' claimed a ticket for %s. Total claims: %s.", client:Name(), requester, count or 0) end,
        ticketClosed = function(client, requester, count) return string.format("Admin '%s' closed a ticket for %s. Total claims: %s.", client:Name(), requester, count or 0) end,
        plyBring = function(client, targetName) return string.format("Admin '%s' brought player '%s'.", client:Name(), targetName) end,
        plyGoto = function(client, targetName) return string.format("Admin '%s' teleported to player '%s'.", client:Name(), targetName) end,
        plyReturn = function(client, targetName) return string.format("Admin '%s' returned player '%s' to their previous position.", client:Name(), targetName) end,
        plyJail = function(client, targetName) return string.format("Admin '%s' jailed player '%s'.", client:Name(), targetName) end,
        plyUnjail = function(client, targetName) return string.format("Admin '%s' unjailed player '%s'.", client:Name(), targetName) end,
        plyKill = function(client, targetName) return string.format("Admin '%s' killed player '%s'.", client:Name(), targetName) end,
        plySlay = function(client, targetName) return string.format("Admin '%s' slayed player '%s'.", client:Name(), targetName) end,
        plyRespawn = function(client, targetName) return string.format("Admin '%s' respawned player '%s'.", client:Name(), targetName) end,
        plyFreeze = function(client, targetName, duration) return string.format("Admin '%s' froze player '%s' for %s seconds.", client:Name(), targetName, tostring(duration)) end,
        plyUnfreeze = function(client, targetName) return string.format("Admin '%s' unfroze player '%s'.", client:Name(), targetName) end,
        plyBlind = function(client, targetName, duration) return string.format("Admin '%s' blinded player '%s' for %s seconds.", client:Name(), targetName, tostring(duration)) end,
        plyUnblind = function(client, targetName) return string.format("Admin '%s' unblinded player '%s'.", client:Name(), targetName) end,
        plyBlindFade = function(client, targetName, duration, color) return string.format("Admin '%s' blind-faded player '%s' for %s seconds with color '%s'.", client:Name(), targetName, tostring(duration), color) end,
        blindFadeAll = function(_, duration, color) return string.format("All players blind-faded for %s seconds with color '%s'.", tostring(duration), color) end,
        plyGag = function(client, targetName) return string.format("Admin '%s' gagged player '%s'.", client:Name(), targetName) end,
        plyUngag = function(client, targetName) return string.format("Admin '%s' ungagged player '%s'.", client:Name(), targetName) end,
        plyMute = function(client, targetName) return string.format("Admin '%s' muted player '%s'.", client:Name(), targetName) end,
        plyUnmute = function(client, targetName) return string.format("Admin '%s' unmuted player '%s'.", client:Name(), targetName) end,
        plyCloak = function(client, targetName) return string.format("Admin '%s' cloaked player '%s'.", client:Name(), targetName) end,
        plyUncloak = function(client, targetName) return string.format("Admin '%s' uncloaked player '%s'.", client:Name(), targetName) end,
        plyGod = function(client, targetName) return string.format("Admin '%s' enabled god mode for '%s'.", client:Name(), targetName) end,
        plyUngod = function(client, targetName) return string.format("Admin '%s' disabled god mode for '%s'.", client:Name(), targetName) end,
        plyIgnite = function(client, targetName, duration) return string.format("Admin '%s' ignited player '%s' for %s seconds.", client:Name(), targetName, tostring(duration)) end,
        plyExtinguish = function(client, targetName) return string.format("Admin '%s' extinguished player '%s'.", client:Name(), targetName) end,
        plyStrip = function(client, targetName) return string.format("Admin '%s' stripped weapons from '%s'.", client:Name(), targetName) end,
        charBanOffline = function(client, charID) return string.format("Admin '%s' banned offline character ID %s.", client:Name(), tostring(charID)) end,
        charWipe = function(client, targetName, charID) return string.format("Admin '%s' wiped character '%s' (ID: %s) from the database.", client:Name(), targetName, charID) end,
        charWipeOffline = function(client, targetName, charID) return string.format("Admin '%s' wiped offline character '%s' (ID: %s) from the database.", client:Name(), targetName, charID) end,
        charUnbanOffline = function(client, charID) return string.format("Admin '%s' unbanned offline character ID %s.", client:Name(), tostring(charID)) end,
        missingPrivilege = function(client, privilege, playerInfo, groupInfo)
            if client then
                return string.format("%s requested missing privilege '%s' (Player: %s, Group: %s)", client:Name(), privilege, playerInfo or "Unknown", groupInfo or "Unknown")
            else
                return string.format("Missing privilege '%s' requested (Player: %s, Group: %s)", privilege, playerInfo or "Unknown", groupInfo or "Unknown")
            end
        end,
    },
    factions = {
        plyTransfer = function(client, targetName, oldFaction, newFaction) return string.format("Admin '%s' transferred '%s' from faction '%s' to '%s'.", client:Name(), targetName, oldFaction, newFaction) end,
        plyWhitelist = function(client, targetName, faction) return string.format("Admin '%s' whitelisted '%s' for faction '%s'.", client:Name(), targetName, faction) end,
        plyUnwhitelist = function(client, targetName, faction) return string.format("Admin '%s' removed '%s' from faction '%s' whitelist.", client:Name(), targetName, faction) end,
        beClass = function(client, className) return string.format("Player '%s' joined class '%s'.", client:Name(), className) end,
        setClass = function(client, targetName, className) return string.format("Admin '%s' set '%s' to class '%s'.", client:Name(), targetName, className) end,
        classWhitelist = function(client, targetName, className) return string.format("Admin '%s' whitelisted '%s' for class '%s'.", client:Name(), targetName, className) end,
        classUnwhitelist = function(client, targetName, className) return string.format("Admin '%s' removed '%s' from class '%s' whitelist.", client:Name(), targetName, className) end,
    },
    inventory = {
        invUpdateSize = function(client, targetName, w, h) return string.format("Admin '%s' reset %s's inventory size to %sx%s.", client:Name(), targetName, w, h) end,
        invSetSize = function(client, targetName, w, h) return string.format("Admin '%s' set %s's inventory size to %sx%s.", client:Name(), targetName, w, h) end,
        storageLock = function(client, entClass, state) return string.format("Admin '%s' %s storage %s.", client:Name(), state and "Locked" or "unlocked", entClass) end,
        storageUnlock = function(client, entClass) return string.format("Client %s unlocked storage %s.", client:Name(), entClass) end,
        storageUnlockFailed = function(client, entClass, password) return string.format("Client %s failed to unlock storage %s with password '%s'.", client:Name(), entClass, password) end,
    },
    connections = {
        playerConnect = function(_, name, ip) return string.format("Player '%s' is connecting from %s.", name, ip) end,
        playerConnected = function(client) return string.format("Player finished loading: '%s'.", client:Name()) end,
        playerDisconnected = function(client) return string.format("Player disconnected: '%s'.", client:Name()) end,
        failedPassword = function(_, steamID, name, svpass, clpass) return string.format("[%s] %s failed server password (Server: '%s', Client: '%s')", steamID, name, svpass, clpass) end,
        steamIDMissing = function(_, name, steamID) return string.format("SteamID missing for '%s' [%s] during CheckSeed.", name, steamID) end,
        steamIDMismatch = function(_, name, realSteamID, sentSteamID) return string.format("SteamID mismatch for '%s': expected [%s] but got [%s].", name, realSteamID, sentSteamID) end,
    },
    cheating = {
        exploitAttempt = function(_, name, steamID, netMessage) return string.format("Player '%s' [%s] triggered exploit net message '%s'.", name, steamID, netMessage) end,
        backdoorDetected = function(_, netMessage, file, line)
            if file then return string.format("Detected backdoor net '%s' defined in %s:%s.", netMessage, file, tostring(line)) end
            return string.format("Detected backdoor net '%s' during initialization.", netMessage)
        end,
        hackAttempt = function(client, netName)
            if netName then return string.format("Client %s triggered hack detection via '%s'.", client:Name(), netName) end
            return string.format("Client %s triggered hack detection.", client:Name())
        end,
        verifyCheatsOK = function(client) return string.format("Client %s responded to VerifyCheats.", client:Name()) end,
        cheaterBanned = function(_, name, steamID) return string.format("Cheater '%s' (%s) was automatically banned.", name, steamID) end,
        cheaterDetected = function(_, name, steamID) return string.format("Player '%s' (%s) was flagged for cheating.", name, steamID) end,
        cheaterToggle = function(client, targetName, state) return string.format("Admin '%s' toggled cheater status for %s: %s.", client:Name(), targetName, state) end,
        cheaterAction = function(client, action) return string.format("Cheater '%s' attempted to %s.", client:Name(), action) end,
    }
}

local logTypeCategories = {
    character = "Character",
    combat = "Combat",
    world = "World",
    tools = "Tools",
    chat = "Chat",
    money = "Money",
    items = "Items",
    permissions = "Permissions",
    admin = "Admin",
    factions = "Factions",
    inventory = "Inventory",
    connections = "Connections",
    cheating = "Cheating",
}

for category, logTypes in pairs(logTypeData) do
    local categoryName = logTypeCategories[category]
    for logType, func in pairs(logTypes) do
        lia.log.types[logType] = {
            func = func,
            category = categoryName
        }
    end
end

--[[
    Purpose:
        Register a new log type with formatter and category.

    When Called:
        During init to add custom audit events (e.g., quests, crafting).

    Parameters:
        logType (string)
            Unique log key.
        func (function)
            Formatter function (client, ... ) -> string.
        category (string)
            Category label used in console output and DB.
    Realm:
        Shared

    Example Usage:
        ```lua
            lia.log.addType("questComplete", function(client, questID, reward)
                return string.format("Quest '%s' completed by %s. Reward: %s", questID, client:Name(), reward)
            end, "Quests")
        ```
]]
function lia.log.addType(logType, func, category)
    lia.log.types[logType] = {
        func = func,
        category = category,
    }
end
--[[
    Purpose:
        Build a formatted log string and return its category.

    When Called:
        Internally by lia.log.add before printing/persisting logs.

    Parameters:
        client (Player|nil)
        logType (string)
        ... (vararg)
            Arguments passed to formatter.

    Returns:
        string|nil, string|nil
            logString, category

    Realm:
        Shared

    Example Usage:
        ```lua
            local text, category = lia.log.getString(ply, "playerDeath", attackerName)
            if text then print(category, text) end
        ```
]]
function lia.log.getString(client, logType, ...)
    local logData = lia.log.types[logType]
    if not logData then return end
    if isfunction(logData.func) then
        local success, result = pcall(logData.func, client, ...)
        if success then return result, logData.category end
    end
end

--[[
    Purpose:
        Create and store a log entry (console + database) using a logType.

    When Called:
        Anywhere you need to audit player/admin/system actions.

    Parameters:
        client (Player|nil)
        logType (string)
        ... (vararg)
            Formatter args for the log type.
    Realm:
        Shared

    Example Usage:
        ```lua
            lia.log.add(client, "itemTake", itemName)
            lia.log.add(nil, "frameworkOutdated") -- system log without player
        ```
]]
function lia.log.add(client, logType, ...)
    local logString, category = lia.log.getString(client, logType, ...)
    if not isstring(category) then category = "Uncategorized" end
    if not isstring(logString) then return end
    hook.Run("OnServerLog", client, logType, logString, category)
    MsgC(Color(83, 143, 239), "[LOG] ")
    MsgC(Color(0, 255, 0), "[Category: " .. tostring(category) .. "] ")
    MsgC(Color(255, 255, 255), tostring(logString) .. "\n")
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local charID
    local steamID
    if IsValid(client) then
        local char = client:getChar()
        charID = char and char:getID() or nil
        steamID = client:SteamID()
    end

    lia.db.insertTable({
        timestamp = timestamp,
        gamemode = engine.ActiveGamemode(),
        category = category,
        message = logString,
        charID = charID,
        steamID = steamID
    }, nil, "logs")
end
