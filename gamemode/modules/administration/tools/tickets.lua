if SERVER then
    local MODULE = MODULE
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
        local targetName
        local targetSteam
        if IsValid(requester) and requester:IsPlayer() then
            targetName = requester:Name()
            targetSteam = requester:SteamID()
        elseif isstring(requester) then
            targetSteam = requester
            local ply = player.GetBySteamID(requester) or player.GetBySteamID64(requester)
            if IsValid(ply) then
                targetName = ply:Name()
            else
                targetName = requester
            end
        else
            targetName = tostring(requester)
            targetSteam = tostring(requester)
        end

        lia.db.insertTable({
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
            targetName = targetName,
            targetSteam = targetSteam,
            adminSteam = IsValid(admin) and admin:SteamID() or "Console",
            adminName = IsValid(admin) and admin:Name() or "Console",
            adminGroup = IsValid(admin) and admin:GetUserGroup() or "Console",
            action = "ticketClaim",
            message = nil,
            charID = nil
        }, nil, "staffactions")

        lia.db.count("staffactions", "adminSteam = " .. lia.db.convertDataType(admin:SteamID()) .. " AND action = 'ticketClaim'"):next(function(count) lia.log.add(admin, "ticketClaimed", requester:Name(), count) end)
    end

    function MODULE:TicketSystemClose(admin, requester)
        lia.db.count("staffactions", "adminSteam = " .. lia.db.convertDataType(admin:SteamID()) .. " AND action = 'ticketClaim'"):next(function(count) lia.log.add(admin, "ticketClosed", requester:Name(), count) end)
    end

    function MODULE:PlayerSay(client, text)
        if string.sub(text, 1, 1) == "@" then
            text = string.sub(text, 2)
            ClientAddText(client, Color(70, 0, 130), L("ticketMessageYou"), Color(151, 211, 255), " " .. L("ticketMessageToAdmins") .. " ", Color(0, 255, 0), text)
            self:SendPopup(client, text)
            local targetName
            local targetSteam
            if IsValid(client) and client:IsPlayer() then
                targetName = client:Name()
                targetSteam = client:SteamID()
            elseif isstring(client) then
                targetSteam = client
                local ply = player.GetBySteamID(client) or player.GetBySteamID64(client)
                if IsValid(ply) then
                    targetName = ply:Name()
                else
                    targetName = client
                end
            else
                targetName = tostring(client)
                targetSteam = tostring(client)
            end

            lia.db.insertTable({
                timestamp = os.date("%Y-%m-%d %H:%M:%S"),
                targetName = targetName,
                targetSteam = targetSteam,
                adminSteam = IsValid(client) and client:SteamID() or "Console",
                adminName = IsValid(client) and client:Name() or "Console",
                adminGroup = IsValid(client) and client:GetUserGroup() or "Console",
                action = "ticketOpen",
                message = text,
                charID = nil
            }, nil, "staffactions")
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
else
    local MODULE = MODULE
    local xpos = xpos or 20
    local ypos = ypos or 20
    local TicketFrames = {}
    function MODULE:TicketFrame(requester, message, claimed)
        local mat_lightning = Material("icon16/lightning_go.png")
        local mat_arrow = Material("icon16/arrow_left.png")
        local mat_link = Material("icon16/link.png")
        local mat_case = Material("icon16/briefcase.png")
        if not IsValid(requester) or not requester:IsPlayer() then return end
        for _, v in pairs(TicketFrames) do
            if v.idiot == requester then
                local txt = v:GetChildren()[5]
                txt:AppendText("\n" .. message)
                txt:GotoTextEnd()
                timer.Remove("ticketsystem-" .. requester:SteamID64())
                timer.Create("ticketsystem-" .. requester:SteamID64(), 60, 1, function() if IsValid(v) then v:Remove() end end)
                surface.PlaySound("ui/hint.wav")
                return
            end
        end

        local frameWidth, frameHeight = 300, 120
        local frm = vgui.Create("DFrame")
        frm:SetSize(frameWidth, frameHeight)
        frm:SetPos(xpos, ypos)
        frm.idiot = requester
        function frm:Paint(paintWidth, paintHeight)
            draw.RoundedBox(0, 0, 0, paintWidth, paintHeight, Color(10, 10, 10, 230))
        end

        frm.lblTitle:SetColor(Color(255, 255, 255))
        frm.lblTitle:SetFont("ticketsystem")
        frm.lblTitle:SetContentAlignment(7)
        if claimed and IsValid(claimed) and claimed:IsPlayer() then
            frm:SetTitle(L("ticketTitleClaimed", requester:Nick(), claimed:Nick()))
            if claimed == LocalPlayer() then
                function frm:Paint(paintWidth, paintHeight)
                    draw.RoundedBox(0, 0, 0, paintWidth, paintHeight, Color(10, 10, 10, 230))
                    draw.RoundedBox(0, 2, 2, paintWidth - 4, 16, Color(38, 166, 91))
                end
            else
                function frm:Paint(paintWidth, paintHeight)
                    draw.RoundedBox(0, 0, 0, paintWidth, paintHeight, Color(10, 10, 10, 230))
                    draw.RoundedBox(0, 2, 2, paintWidth - 4, 16, Color(207, 0, 15))
                end
            end
        else
            frm:SetTitle(requester:Nick())
        end

        local msg = vgui.Create("RichText", frm)
        msg:SetPos(10, 30)
        msg:SetSize(190, frameHeight - 35)
        msg:SetContentAlignment(7)
        msg:SetVerticalScrollbarEnabled(false)
        function msg:PerformLayout()
            self:SetFontInternal("DermaDefault")
        end

        msg:AppendText(message)
        local function createButton(text, material, position, clickFunc, disabled)
            text = L(text)
            local btn = vgui.Create("DButton", frm)
            btn:SetPos(215, position)
            btn:SetSize(83, 18)
            btn:SetText("          " .. text)
            btn:SetColor(Color(255, 255, 255))
            btn:SetContentAlignment(4)
            btn.Disabled = disabled
            btn.DoClick = function() if not btn.Disabled then clickFunc() end end
            btn.Paint = function(panel, paintWidth, paintHeight)
                if panel.Depressed or panel.m_bSelected then
                    draw.RoundedBox(1, 0, 0, paintWidth, paintHeight, Color(255, 50, 50, 255))
                elseif panel.Hovered and not panel.Disabled then
                    draw.RoundedBox(1, 0, 0, paintWidth, paintHeight, Color(205, 30, 30, 255))
                else
                    draw.RoundedBox(1, 0, 0, paintWidth, paintHeight, panel.Disabled and Color(100, 100, 100, 255) or Color(80, 80, 80, 255))
                end

                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(material)
                surface.DrawTexturedRect(5, 1, 16, 16)
            end

            if disabled then btn:SetTooltip(L("ticketActionSelf")) end
            return btn
        end

        local isLocalPlayer = requester == LocalPlayer()
        createButton("goto", mat_lightning, 20, function() lia.admin.execCommand("goto", requester) end, isLocalPlayer)
        createButton("return", mat_arrow, 40, function() lia.admin.execCommand("return", requester) end, isLocalPlayer)
        createButton("freeze", mat_link, 60, function() lia.admin.execCommand("freeze", requester) end, isLocalPlayer)
        createButton("bring", mat_arrow, 80, function() lia.admin.execCommand("bring", requester) end, isLocalPlayer)
        local shouldClose = false
        local claimButton
        claimButton = createButton("claimCase", mat_case, 100, function()
            if not shouldClose then
                if frm.lblTitle:GetText():lower():find("claimed") then
                    chat.AddText(Color(255, 150, 0), L("errorPrefix") .. " " .. L("caseAlreadyClaimed"))
                    surface.PlaySound("common/wpn_denyselect.wav")
                else
                    net.Start("TicketSystemClaim")
                    net.WriteEntity(requester)
                    net.SendToServer()
                    shouldClose = true
                    claimButton:SetText("          " .. L("closeCase"))
                end
            else
                net.Start("TicketSystemClose")
                net.WriteEntity(requester)
                net.SendToServer()
            end
        end, isLocalPlayer)

        local closeButton = vgui.Create("DButton", frm)
        closeButton:SetText("×")
        closeButton:SetTooltip(L("close"))
        closeButton:SetColor(Color(255, 255, 255))
        closeButton:SetPos(frameWidth - 18, 2)
        closeButton:SetSize(16, 16)
        function closeButton:Paint()
        end

        closeButton.DoClick = function() frm:Close() end
        frm:ShowCloseButton(false)
        frm:SetPos(xpos, ypos + 130 * #TicketFrames)
        frm:MoveTo(xpos, ypos + 130 * #TicketFrames, 0.2, 0, 1, function() surface.PlaySound("garrysmod/balloon_pop_cute.wav") end)
        function frm:OnRemove()
            if TicketFrames then
                table.RemoveByValue(TicketFrames, frm)
                for k, v in ipairs(TicketFrames) do
                    v:MoveTo(xpos, ypos + 130 * (k - 1), 0.1, 0, 1)
                end
            end

            if IsValid(requester) and timer.Exists("ticketsystem-" .. requester:SteamID64()) then timer.Remove("ticketsystem-" .. requester:SteamID64()) end
        end

        table.insert(TicketFrames, frm)
        timer.Create("ticketsystem-" .. requester:SteamID64(), 60, 1, function() if IsValid(frm) then frm:Remove() end end)
    end

    hook.Add("liaAdminRegisterTab", "AdminTabTicketsDB", function(tabs)
        local function canView()
            local ply = LocalPlayer()
            return IsValid(ply) and ply:hasPrivilege("Access Tickets Tab") and ply:hasPrivilege("View DB Tables")
        end

        tabs["Tickets"] = {
            icon = "icon16/page_white_text.png",
            onShouldShow = canView,
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.tickets = pnl
                net.Start("liaRequestTableData")
                net.WriteString("lia_staffactions")
                net.SendToServer()
                return pnl
            end
        }
    end)

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
end