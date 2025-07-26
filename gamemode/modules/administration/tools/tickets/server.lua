local MODULE = MODULE

-- local helper to record staff actions directly
local function logStaffAction(admin, action, victim, message, charID)
    local targetName
    local targetSteam
    if IsValid(victim) and victim:IsPlayer() then
        targetName = victim:Name()
        targetSteam = victim:SteamID()
    elseif isstring(victim) then
        targetSteam = victim
        local ply = player.GetBySteamID(victim) or player.GetBySteamID64(victim)
        if IsValid(ply) then
            targetName = ply:Name()
        else
            targetName = victim
        end
    else
        targetName = tostring(victim)
        targetSteam = tostring(victim)
    end

    lia.db.insertTable({
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        targetName = targetName,
        targetSteam = targetSteam,
        adminSteam = IsValid(admin) and admin:SteamID() or "Console",
        adminName = IsValid(admin) and admin:Name() or "Console",
        adminGroup = IsValid(admin) and admin:GetUserGroup() or "Console",
        action = action,
        message = message,
        charID = charID
    }, nil, "staffactions")
end
local function buildClaimTable(rows)
    local caseclaims = {}
    for _, row in ipairs(rows or {}) do
        local adminID = row.admin
        if adminID ~= "Unassigned" then adminID = tostring(adminID):match("(%d+)$") or adminID end
        local timestamp = tonumber(row.timestamp) or 0
        caseclaims[adminID] = caseclaims[adminID] or {
            name = adminID,
            claims = 0,
            lastclaim = 0,
            claimedFor = {}
        }

        local info = caseclaims[adminID]
        info.claims = tonumber(info.claims) + 1
        if timestamp > tonumber(info.lastclaim) then info.lastclaim = timestamp end
        local reqPly = player.GetBySteamID64(row.requester)
        info.claimedFor[row.requester] = IsValid(reqPly) and reqPly:Nick() or row.requester
    end

    for adminID, info in pairs(caseclaims) do
        local ply = player.GetBySteamID64(adminID)
        if IsValid(ply) then info.name = ply:Nick() end
    end
    return caseclaims
end

function MODULE:GetAllCaseClaims()
    return lia.db.select({"targetSteam", "adminSteam", "timestamp"}, "staffactions", "action = 'ticketClaim'"):next(function(res)
        local rows = {}
        for _, v in ipairs(res.results or {}) do
            rows[#rows + 1] = {
                requester = v.targetSteam,
                admin = v.adminSteam,
                timestamp = v.timestamp
            }
        end
        return buildClaimTable(rows)
    end)
end

function MODULE:TicketSystemClaim(admin, requester)
    logStaffAction(admin, "ticketClaim", requester)
    lia.db.count("staffactions", "adminSteam = " .. lia.db.convertDataType(admin:SteamID()) .. " AND action = 'ticketClaim'"):next(function(count)
        lia.log.add(admin, "ticketClaimed", requester:Name(), count)
    end)
end

function MODULE:TicketSystemClose(admin, requester)
    lia.db.count("staffactions", "adminSteam = " .. lia.db.convertDataType(admin:SteamID()) .. " AND action = 'ticketClaim'"):next(function(count)
        lia.log.add(admin, "ticketClosed", requester:Name(), count)
    end)
end

function MODULE:PlayerSay(client, text)
    if string.sub(text, 1, 1) == "@" then
        text = string.sub(text, 2)
        ClientAddText(client, Color(70, 0, 130), L("ticketMessageYou"), Color(151, 211, 255), " " .. L("ticketMessageToAdmins") .. " ", Color(0, 255, 0), text)
        self:SendPopup(client, text)
        logStaffAction(client, "ticketOpen", client, text)
        return ""
    end
end

function MODULE:PlayerDisconnected(client)
    for _, v in player.Iterator() do
        if v:hasPrivilege("Always See Tickets") or v:isStaffOnDuty() then
            net.Start("TicketSystemClose")
            net.WriteEntity(client)
            net.Send(v)
        end
    end
end

function MODULE:SendPopup(noob, message)
    for _, v in player.Iterator() do
        if v:hasPrivilege("Always See Tickets") or v:isStaffOnDuty() then
            net.Start("TicketSystem")
            net.WriteEntity(noob)
            net.WriteString(message)
            net.WriteEntity(noob.CaseClaimed)
            net.Send(v)
        end
    end

    if IsValid(noob) and noob:IsPlayer() then
        timer.Remove("ticketsystem-" .. noob:SteamID64())
        timer.Create("ticketsystem-" .. noob:SteamID64(), 60, 1, function() if IsValid(noob) and noob:IsPlayer() then noob.CaseClaimed = nil end end)
    end
end

net.Receive("ViewClaims", function(_, client)
    local sid = net.ReadString()
    MODULE:GetAllCaseClaims():next(function(caseclaims)
        net.Start("ViewClaims")
        net.WriteTable(caseclaims)
        net.WriteString(sid)
        net.Send(client)
    end)
end)

net.Receive("TicketSystemClaim", function(_, client)
    local requester = net.ReadEntity()
    if client == requester then
        client:notifyLocalized("ticketActionSelf")
        return
    end

    if (client:hasPrivilege("Always See Tickets") or client:isStaffOnDuty()) and not requester.CaseClaimed then
        for _, v in player.Iterator() do
            if v:hasPrivilege("Always See Tickets") or v:isStaffOnDuty() then
                net.Start("TicketSystemClaim")
                net.WriteEntity(client)
                net.WriteEntity(requester)
                net.Send(v)
            end
        end

        hook.Run("TicketSystemClaim", client, requester)
        requester.CaseClaimed = client
    end
end)

net.Receive("TicketSystemClose", function(_, client)
    local requester = net.ReadEntity()
    if client == requester then
        client:notifyLocalized("ticketActionSelf")
        return
    end

    if not requester or not IsValid(requester) or requester.CaseClaimed ~= client then return end
    if timer.Exists("ticketsystem-" .. requester:SteamID64()) then timer.Remove("ticketsystem-" .. requester:SteamID64()) end
    for _, v in player.Iterator() do
        if v:hasPrivilege("Always See Tickets") or v:isStaffOnDuty() then
            net.Start("TicketSystemClose")
            net.WriteEntity(requester)
            net.Send(v)
        end
    end

    hook.Run("TicketSystemClose", client, requester)
    requester.CaseClaimed = nil
end)