local MODULE = MODULE
MODULE.ActiveTickets = MODULE.ActiveTickets or {}
function MODULE:PlayerSay(client, text)
    if text and string.sub(text, 1, 1) == "@" then
        local message = string.sub(text, 2)
        ClientAddText(client, Color(70, 0, 130), "You", Color(151, 211, 255), " " .. "to admins" .. ": ", Color(0, 255, 0), message)
        MODULE:SendPopup(client, message)
        return ""
    end
end

local function buildClaimTable(rows)
    local caseclaims = {}
    for _, row in ipairs(rows or {}) do
        local adminID = row.adminSteamID
        caseclaims[adminID] = caseclaims[adminID] or {
            name = row.admin,
            claims = 0,
            lastclaim = 0,
            claimedFor = {}
        }

        local info = caseclaims[adminID]
        info.claims = info.claims + 1
        local rowTime = isnumber(row.timestamp) and row.timestamp or os.time(lia.time.toNumber(row.timestamp))
        if rowTime > info.lastclaim then info.lastclaim = rowTime end
        local reqPly = lia.util.getBySteamID(row.requesterSteamID)
        info.claimedFor[row.requesterSteamID] = IsValid(reqPly) and reqPly:Nick() or row.requester
    end

    for adminID, info in pairs(caseclaims) do
        local ply = lia.util.getBySteamID(adminID)
        if IsValid(ply) then info.name = ply:Nick() end
    end
    return caseclaims
end

function MODULE:GetAllCaseClaims()
    return lia.db.select({"timestamp", "requester", "requesterSteamID", "admin", "adminSteamID", "message"}, "ticketclaims"):next(function(res) return buildClaimTable(res.results) end)
end

function MODULE:OnReloaded()
    local hasTickets = false
    for steamID, _ in pairs(MODULE.ActiveTickets) do
        hasTickets = true
        MODULE.ActiveTickets[steamID] = nil
    end

    if hasTickets then
        if timer.Exists("liaClearAllTicketFrames") then timer.Remove("liaClearAllTicketFrames") end
        timer.Create("liaClearAllTicketFrames", 0.05, 1, function()
            net.Start("liaClearAllTicketFrames")
            net.Broadcast()
        end)
    end
end

function MODULE:PlayerDisconnected(client)
    for _, v in player.Iterator() do
        local hasAlwaysSeeTickets = v:hasPrivilege("alwaysSeeTickets")
        local isStaffOnDuty = v:isStaffOnDuty()
        local permission = hasAlwaysSeeTickets or isStaffOnDuty
        lia.debug("[Permissions]", "Permission Check for function MODULE:PlayerDisconnected ticket close recipient", "targetPlayer=", tostring(v:Name()), "hasPrivilege(alwaysSeeTickets)=", tostring(hasAlwaysSeeTickets), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(permission))
        if permission then
            net.Start("liaTicketSystemClose")
            net.WriteEntity(client)
            net.Send(v)
        end
    end

    MODULE.ActiveTickets[client:SteamID()] = nil
end
