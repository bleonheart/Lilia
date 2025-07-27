local MODULE = MODULE
net.Receive("ViewClaims", function()
    local tbl = net.ReadTable()
    local steamid = net.ReadString()
    if steamid and steamid ~= "" and steamid ~= " " then
        local v = tbl[steamid]
        print(L("claimRecordLast", v.name, v.claims, string.NiceTime(os.time() - v.lastclaim)))
    else
        for _, v in pairs(tbl) do
            print(L("claimRecord", v.name, v.claims))
        end
    end
end)

net.Receive("TicketSystem", function()
    local pl = net.ReadEntity()
    local msg = net.ReadString()
    local claimed = net.ReadEntity()
    if LocalPlayer():isStaffOnDuty() or LocalPlayer():IsSuperAdmin() then MODULE:TicketFrame(pl, msg, claimed) end
end)

net.Receive("TicketSystemClaim", function()
    local pl = net.ReadEntity()
    local requester = net.ReadEntity()
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then
            local titl = v:GetChildren()[4]
            titl:SetText(titl:GetText() .. " - " .. L("claimedBy") .. " " .. pl:Nick())
            if pl == LocalPlayer() then
                function v:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 230))
                    draw.RoundedBox(0, 2, 2, w - 4, 16, Color(38, 166, 91))
                end
            else
                function v:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 230))
                    draw.RoundedBox(0, 2, 2, w - 4, 16, Color(207, 0, 15))
                end
            end

            local bu = v:GetChildren()[11]
            bu.DoClick = function()
                if LocalPlayer() == pl then
                    net.Start("TicketSystemClose")
                    net.WriteEntity(requester)
                    net.SendToServer()
                else
                    v:Close()
                end
            end
        end
    end
end)

net.Receive("TicketSystemClose", function()
    local requester = net.ReadEntity()
    if not IsValid(requester) or not requester:IsPlayer() then return end
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then v:Remove() end
    end

    if timer.Exists("ticketsystem-" .. requester:SteamID64()) then timer.Remove("ticketsystem-" .. requester:SteamID64()) end
end)


net.Receive("TicketClaims", function()
    local MODULE = lia.module.get("tickets")
    local claims = net.ReadTable()
    if IsValid(MODULE.ticketList) then
        MODULE.ticketList:Clear()
        for _, c in ipairs(claims) do
            MODULE.ticketList:AddLine(os.date("%Y-%m-%d %H:%M:%S", c.timestamp or 0), c.requester or "", c.requesterSteamID or "", c.admin or "", c.adminSteamID or "", c.message or "")
        end
    end
end)
