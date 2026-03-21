lia.playerinteract.addInteraction("inviteToFaction", {
    serverOnly = true,
    category = "categoryFactionManagement",
    shouldShow = function(client, target)
        local cChar = client:getChar()
        local tChar = target:getChar()
        if not cChar or not tChar then return false end
        if cChar:hasFlags("Z") then return true end
        local classData = lia.class.list[cChar:getClass()]
        if classData and classData.canInviteToFaction then return true end
        return hook.Run("CanInviteToFaction", client, target) ~= false and cChar:getFaction() ~= tChar:getFaction()
    end,
    onRun = function(client, target)
        if not SERVER then return end
        local iChar = client:getChar()
        local tChar = target:getChar()
        if not iChar or not tChar then return end
        local faction
        for _, fac in pairs(lia.faction.teams) do
            if fac.index == client:Team() then faction = fac end
        end

        if not faction then
            client:notifyError("The specified faction is not valid.")
            return
        end

        if faction.uniqueID == "staff" then
            client:notifyError("You cannot invite players to the staff faction through the interaction menu. Staff characters must be created through the menu system.")
            return
        end

        target:requestBinaryQuestion("Join Faction", "Do you want to join this faction?", "Yes", "No", function(choice)
            if choice ~= 0 then
                client:notifyInfo("Invite declined.")
                return
            end

            if hook.Run("CanCharBeTransfered", tChar, faction, tChar:getFaction()) == false then return end
            local oldFaction = tChar:getFaction()
            tChar.vars.faction = faction.uniqueID
            tChar:setFaction(faction.index)
            hook.Run("OnTransferred", target)
            if faction.OnTransferred then faction:OnTransferred(target, oldFaction) end
            hook.Run("PlayerLoadout", target)
            client:notifySuccess(string.format("%s has been transferred to %s.", target:Name(), faction.name))
            if client ~= target then target:notifyInfo(string.format("You have been transferred to %s by %s.", faction.name, client:Name())) end
            tChar:takeFlags("Z")
        end)
    end
})

lia.playerinteract.addInteraction("inviteToClass", {
    serverOnly = true,
    category = "categoryFactionManagement",
    shouldShow = function(client, target)
        local cChar = client:getChar()
        local tChar = target:getChar()
        if not cChar or not tChar then return false end
        if cChar:hasFlags("X") then return true end
        local classData = lia.class.list[cChar:getClass()]
        if classData and classData.canInviteToClass then return true end
        if cChar:getFaction() ~= tChar:getFaction() then return false end
        return hook.Run("CanInviteToClass", client, target) ~= false
    end,
    onRun = function(client, target)
        if not SERVER then return end
        local cChar = client:getChar()
        local tChar = target:getChar()
        if not cChar or not tChar then return end
        local class = lia.class.list[cChar:getClass()]
        if not class then
            client:notifyError("The specified class is not valid.")
            return
        end

        target:requestBinaryQuestion("Join Class", "Do you want to join this class?", "Yes", "No", function(choice)
            if choice ~= 0 then
                client:notifyInfo("Invite declined.")
                return
            end

            if hook.Run("CanCharBeTransfered", tChar, class, tChar:getClass()) == false then return end
            local oldClass = tChar:getClass()
            tChar:setClass(class.index)
            hook.Run("OnPlayerJoinClass", target, class.index, oldClass)
            client:notifySuccess(string.format("%s has been transferred to %s.", target:Name(), class.name))
            if client ~= target then target:notifyInfo(string.format("You have been transferred to %s by %s.", class.name, client:Name())) end
        end)
    end
})
