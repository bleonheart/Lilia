﻿local function buildClaimTable(rows)
    local caseclaims = {}
    for _, row in ipairs(rows or {}) do
        local adminID = row.adminSteamID
        if adminID ~= "" and adminID ~= "Unassigned" then adminID = tostring(adminID) end
        caseclaims[adminID] = caseclaims[adminID] or {
            name = row.admin or adminID,
            claims = 0,
            lastclaim = 0,
            claimedFor = {}
        }

        local info = caseclaims[adminID]
        info.claims = info.claims + 1
        if row.timestamp > info.lastclaim then info.lastclaim = row.timestamp end
        local reqPly = player.GetBySteamID64(row.requesterSteamID)
        info.claimedFor[row.requesterSteamID] = IsValid(reqPly) and reqPly:Nick() or row.requester
    end

    for adminID, info in pairs(caseclaims) do
        local ply = player.GetBySteamID64(adminID)
        if IsValid(ply) then info.name = ply:Nick() end
    end
    return caseclaims
end

function MODULE:GetAllCaseClaims()
    return lia.db.select({"requesterSteamID", "adminSteamID", "timestamp"}, "ticketclaims")
        :next(function(res) return buildClaimTable(res.results) end)
end

function MODULE:TicketSystemClaim(admin, requester)
    lia.db.updateTable({
        admin = admin:Name(),
        adminSteamID = admin:SteamID64()
    }, nil, "ticketclaims", "requesterSteamID = " .. lia.db.convertDataType(requester:SteamID64()) .. " AND admin = 'Unassigned'")
end

function MODULE:PlayerSay(client, text)
    if string.sub(text, 1, 1) == "@" then
        text = string.sub(text, 2)
        ClientAddText(client, Color(70, 0, 130), L("ticketMessageYou"), Color(151, 211, 255), " " .. L("ticketMessageToAdmins") .. " ", Color(0, 255, 0), text)
        self:SendPopup(client, text)
        lia.db.insertTable({
            requester = client:Name(),
            requesterSteamID = client:SteamID64(),
            admin = "Unassigned",
            adminSteamID = "",
            message = text,
            timestamp = os.time()
        }, nil, "ticketclaims")
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
