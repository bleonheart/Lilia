-- @type method cleanitems - Clean Up Items
-- @typeCommentStart
-- Removes all items from the map.
-- @typeCommentEnd
-- @classmod Commands
-- @realm server
-- @usageStart
-- /cleanitems - Removes all items from the map.
-- @usageEnd
lia.command.add("cleanitems", {
    onRun = function(client, arguments)
        local count = 0

        if not client:IsSuperAdmin() then
            client:notify("Your rank is not high enough to use this command.")

            return false
        end

        for k, v in pairs(ents.FindByClass("lia_item")) do
            count = count + 1
            v:Remove()
        end

        client:notify(count .. " items have been cleaned up from the map.")
    end
})

-- @type method cleanprops - Clean Up Props
-- @typeCommentStart
-- Removes all props from the map.
-- @typeCommentEnd
-- @classmod Commands
-- @realm server
-- @usageStart
-- /cleanprops - Removes all props from the map.
-- @usageEnd
lia.command.add("cleanprops", {
    onRun = function(client, arguments)
        local count = 0

        if not client:IsSuperAdmin() then
            client:notify("Your rank is not high enough to use this command.")

            return false
        end

        for k, v in pairs(ents.FindByClass("prop_physics")) do
            count = count + 1
            v:Remove()
        end

        client:notify(count .. " props have been cleaned up from the map.")
    end
})

-- @type method cleannpcs - Clean Up NPCs
-- @typeCommentStart
-- Removes all NPCs from the map.
-- @typeCommentEnd
-- @classmod Commands
-- @realm server
-- @usageStart
-- /cleannpcs - Removes all NPCs from the map.
-- @usageEnd
lia.command.add("cleannpcs", {
    onRun = function(client, arguments)
        local count = 0

        if not client:IsSuperAdmin() then
            client:notify("Your rank is not high enough to use this command.")

            return false
        end

        for k, v in pairs(ents.GetAll()) do
            if IsValid(v) and v:IsNPC() then
                count = count + 1
                v:Remove()
            end
        end

        client:notify(count .. " NPCs have been cleaned up from the map.")
    end
})