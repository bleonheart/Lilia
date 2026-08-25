if SERVER then
    net.Receive("liaRunInteraction", function(_, ply)
        local name = net.ReadString()
        local hasEntity = net.ReadBool()
        local tracedEntity = hasEntity and net.ReadEntity() or nil
        local opt = lia.playerinteract.stored[name]
        if opt and opt.type == "interaction" and opt.serverOnly and IsValid(tracedEntity) and lia.playerinteract.isWithinRange(ply, tracedEntity, opt.range) then
            local targetType = opt.target or "player"
            local isPlayerTarget = tracedEntity:IsPlayer()
            if targetType ~= "any" and targetType ~= "player" and targetType ~= "entity" then return end
            if targetType == "player" and not isPlayerTarget or targetType == "entity" and isPlayerTarget then return end
            opt.onRun(ply, tracedEntity)
            return
        end

        if opt and opt.type == "action" and opt.serverOnly then
            if hasEntity and IsValid(tracedEntity) then opt.onRun(ply, tracedEntity) else opt.onRun(ply) end
        end
    end)

    net.Receive("liaRequestInteractOptions", function(_, ply)
        if not IsValid(ply) then return end
        local requestType = net.ReadString()
        local options = {}
        local ent = requestType == "interaction" and ply:getTracedEntity(100) or nil
        if requestType == "interaction" and not IsValid(ent) then
            net.Start("liaProvideInteractOptions")
            net.WriteString(requestType)
            net.WriteUInt(0, 16)
            net.Send(ply)
            return
        end

        if requestType ~= "interaction" and not ply:getChar() then
            net.Start("liaProvideInteractOptions")
            net.WriteString("action")
            net.WriteUInt(0, 16)
            net.Send(ply)
            return
        end

        for name, opt in pairs(lia.playerinteract.stored or {}) do
            local validType = requestType == "interaction" and opt.type == "interaction" or requestType ~= "interaction" and opt.type == "action"
            if validType then
                local canShow = true
                if opt.shouldShow then
                    local ok, result = pcall(opt.shouldShow, ply, requestType == "interaction" and ent or nil)
                    canShow = ok and result ~= false
                end
                local inRange = requestType ~= "interaction" or lia.playerinteract.isWithinRange(ply, ent, opt.range and math.min(opt.range, 100) or 100)
                local target = opt.target or "player"
                local targetMatches = requestType ~= "interaction" or target == "any" or target == "player" and ent:IsPlayer() or target == "entity" and not ent:IsPlayer()
                if canShow and inRange and targetMatches then
                    options[#options + 1] = {name = name, opt = {type = opt.type, serverOnly = opt.serverOnly and true or false, range = opt.range, category = opt.category or "", target = opt.target, timeToComplete = opt.timeToComplete, actionText = opt.actionText, targetActionText = opt.targetActionText}}
                end
            end
        end

        net.Start("liaProvideInteractOptions")
        net.WriteString(requestType == "interaction" and "interaction" or "action")
        net.WriteUInt(#options, 16)
        for _, entry in ipairs(options) do
            local data = entry.opt
            net.WriteString(entry.name)
            net.WriteString(data.type)
            net.WriteBool(data.serverOnly)
            net.WriteUInt(data.range or 0, 16)
            net.WriteString(data.category)
            net.WriteBool(data.target ~= nil)
            if data.target ~= nil then net.WriteString(data.target) end
            net.WriteBool(data.timeToComplete ~= nil)
            if data.timeToComplete ~= nil then net.WriteFloat(data.timeToComplete) end
            net.WriteBool(data.actionText ~= nil)
            if data.actionText ~= nil then net.WriteString(data.actionText) end
            net.WriteBool(data.targetActionText ~= nil)
            if data.targetActionText ~= nil then net.WriteString(data.targetActionText) end
        end
        net.Send(ply)
    end)
end
