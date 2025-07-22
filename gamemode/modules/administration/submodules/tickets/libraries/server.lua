function MODULE:GetCaseClaims(callback, steamID)
    local condition
    if steamID then
        condition = "_admin = " .. lia.db.convertDataType(steamID)
    end
    lia.db.select({"_request", "_admin", "_timestamp"}, "ticketclaims", condition):next(function(res)
        local rows = res.results or {}
        local claims = {}
        for _, row in ipairs(rows) do
            local adminID = row._admin
            if steamID and adminID ~= steamID then continue end
            local info = claims[adminID]
            if not info then
                local ply = player.GetBySteamID64(adminID)
                info = {
                    name = IsValid(ply) and ply:Nick() or adminID,
                    claims = 0,
                    lastclaim = 0,
                    claimedFor = {}
                }
                claims[adminID] = info
            end
            info.claims = info.claims + 1
            info.lastclaim = math.max(info.lastclaim, tonumber(row._timestamp) or 0)
            local reqID = row._request
            local reqPly = player.GetBySteamID64(reqID)
            info.claimedFor[reqID] = IsValid(reqPly) and reqPly:Nick() or reqID
        end
        callback(claims)
    end)
end

function MODULE:TicketSystemClaim(admin, requester)
    lia.db.insertTable({
        _request = requester:SteamID64(),
        _admin = admin:SteamID64(),
        _timestamp = os.time()
    }, nil, "ticketclaims")
end


function MODULE:PlayerSay(client, text)
    if string.sub(text, 1, 1) == "@" then
        text = string.sub(text, 2)
        ClientAddText(client, Color(70, 0, 130), L("ticketMessageYou"), Color(151, 211, 255), " " .. L("ticketMessageToAdmins") .. " ", Color(0, 255, 0), text)
        self:SendPopup(client, text)
        return ""
    end
end

function MODULE:PlayerDisconnected(client)
    for _, v in player.Iterator() do
        if v:hasPrivilege("Staff Permissions - Always See Tickets") or v:isStaffOnDuty() then
            net.Start("TicketSystemClose")
            net.WriteEntity(client)
            net.Send(v)
        end
    end
end

function MODULE:SendPopup(noob, message)
    for _, v in player.Iterator() do
        if v:hasPrivilege("Staff Permissions - Always See Tickets") or v:isStaffOnDuty() then
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
