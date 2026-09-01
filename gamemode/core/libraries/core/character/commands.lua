lia.command.add("charid", {
    adminOnly = false,
    desc = "Displays your current character's ID.",
    onRun = function(client)
        local char = client:getChar()
        if not char then
            client:notifyError("You have no character selected")
            return
        end

        local charID = char:getID()
        client:notifyInfo(string.format("Your character ID is: %s", charID))
    end
})

lia.command.add("returntodeathpos", {
    adminOnly = true,
    desc = "Return to your last recorded death position.",
    onRun = function(client)
        if IsValid(client) and client:Alive() then
            local character = client:getChar()
            local oldPos = character and character:getData("deathPos")
            if oldPos then
                client:SetPos(oldPos)
                character:setData("deathPos", nil)
            else
                client:notifyError("No death position saved.")
            end
        else
            client:notifyWarning("Wait until you respawn.")
        end
    end
})

lia.command.add("forcefallover", {
    adminOnly = true,
    desc = "Force another player to fall over (go into ragdoll).",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "time",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local time = tonumber(arguments[2])
        if not time or time < 1 then
            time = 5
        else
            time = math.Clamp(time, 1, 60)
        end

        target.FallOverCooldown = true
        target:setRagdolled(true, time)
    end
})

lia.command.add("forcegetup", {
    adminOnly = true,
    desc = "Force another player to get up from ragdoll.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not IsValid(target:GetRagdollEntity()) then return end
        local entity = target:GetRagdollEntity()
        if IsValid(entity) and entity.liaGrace and entity.liaGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and not entity.liaWakingUp then
            entity.liaWakingUp = true
            target:setAction("gettingUp", 5, function()
                if IsValid(entity) then
                    hook.Run("OnCharGetup", target, entity)
                    SafeRemoveEntity(entity)
                end
            end)
        end
    end
})

lia.command.add("chardesc", {
    adminOnly = false,
    desc = "Change your character's description.",
    arguments = {
        {
            name = "desc",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local desc = table.concat(arguments, " ")
        if not desc:find("%S") then return client:requestString("Change Name", "Enter the character's new name below.", function(text) lia.command.run(client, "chardesc", {text}) end, client:getChar() and client:getChar():getDesc() or "") end
        local trimmedDesc = string.Trim(desc)
        local descWithoutSpaces = string.gsub(trimmedDesc, "%s", "")
        local minLength = lia.config.get("MinDescLen", 16)
        if #descWithoutSpaces < minLength then
            client:notifyError(string.format("Description must be at least %s characters long.", minLength))
            return
        end

        local character = client:getChar()
        if character then character:setDesc(desc) end
        return "Character description has been changed."
    end
})

lia.command.add("chargetup", {
    adminOnly = false,
    desc = "Force yourself to get up from ragdoll (if possible).",
    onRun = function(client)
        if not IsValid(client:GetRagdollEntity()) then return end
        local entity = client:GetRagdollEntity()
        if IsValid(entity) and entity.liaGrace and entity.liaGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and not entity.liaWakingUp then
            entity.liaWakingUp = true
            client:setAction("gettingUp", 5, function()
                if IsValid(entity) then
                    hook.Run("OnCharGetup", client, entity)
                    SafeRemoveEntity(entity)
                end
            end)
        end
    end,
    alias = {"getup"}
})

lia.command.add("fallover", {
    adminOnly = false,
    desc = "Fall over (ragdoll) for a certain duration.",
    arguments = {
        {
            name = "time",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        if client.FallOverCooldown then
            client:notifyWarning("This Command Is In Cooldown!")
            return
        elseif client:IsFrozen() then
            client:notifyWarning("You cannot use this while frozen!")
            return
        elseif not client:Alive() then
            client:notifyError("You cannot use this while dead!")
            return
        elseif IsValid(client:GetVehicle()) then
            client:notifyWarning("You cannot use this as you are in a vehicle!")
            return
        elseif client:GetMoveType() == MOVETYPE_NOCLIP then
            client:notifyWarning("You cannot use this while in noclip!")
            return
        elseif IsValid(client:GetRagdollEntity()) then
            return
        end

        local time = math.Clamp(tonumber(arguments[1]) or 5, 1, 60)
        client.FallOverCooldown = true
        client:setRagdolled(true, time)
        timer.Simple(time, function() if IsValid(client) then client.FallOverCooldown = false end end)
    end
})

if SERVER then
    concommand.Add("lia_wipecharacters", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.db.wipeCharacters()
        lia.information("All characters have been wiped!")
    end)
end