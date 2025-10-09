local TicketFrames = {}
local xpos = xpos or 20
local ypos = ypos or 20
function MODULE:TicketFrame(requester, message, claimed)
    if not IsValid(requester) or not requester:IsPlayer() then return end
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then
            local txt = v:GetChildren()[5]
            txt:AppendText("\n" .. message)
            txt:GotoTextEnd()
            timer.Remove("ticketsystem-" .. requester:SteamID())
            timer.Create("ticketsystem-" .. requester:SteamID(), 60, 1, function() if IsValid(v) then v:Remove() end end)
            surface.PlaySound("ui/hint.wav")
            return
        end
    end

    local frameWidth, frameHeight = 300, 120
    local frm = vgui.Create("liaFrame")
    frm:SetSize(frameWidth, frameHeight)
    frm:SetPos(xpos, ypos)
    frm.idiot = requester
    frm:ShowCloseButton(false)
    if claimed and IsValid(claimed) and claimed:IsPlayer() then
        frm:SetTitle(L("ticketTitleClaimed", requester:Nick(), claimed:Nick()))
        if claimed == LocalPlayer() then
            frm.headerColor = Color(38, 166, 91)
        else
            frm.headerColor = Color(207, 0, 15)
        end
    else
        frm:SetTitle(requester:Nick())
    end

    local msg = vgui.Create("SemiTransparentDPanel", frm)
    msg:SetPos(10, 30)
    msg:SetSize(190, frameHeight - 35)
    msg.message = message
    msg.Paint = function(panel, w, h)
        lia.derma.rect(0, 0, w, h):Rad(4):Color(lia.color.theme.panel[1]):Shape(lia.derma.SHAPE_IOS):Draw()
        draw.SimpleText(panel.message, "DermaDefault", w * 0.5, h * 0.5, lia.color.theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local function createButton(text, position, clickFunc, disabled)
        text = L(text)
        local btn = vgui.Create("liaButton", frm)
        btn:SetPos(215, position)
        btn:SetSize(83, 18)
        btn:SetText(text)
        btn.Disabled = disabled
        btn.DoClick = function() if not btn.Disabled then clickFunc() end end
        if disabled then btn:SetTooltip(L("ticketActionSelf")) end
        return btn
    end

    local isLocalPlayer = requester == LocalPlayer()
    createButton("goTo", 20, function() lia.administrator.execCommand("goto", requester) end, isLocalPlayer)
    createButton("returnText", 40, function() lia.administrator.execCommand("return", requester) end, isLocalPlayer)
    createButton("freeze", 60, function() lia.administrator.execCommand("freeze", requester) end, isLocalPlayer)
    createButton("bring", 80, function() lia.administrator.execCommand("bring", requester) end, isLocalPlayer)
    local shouldClose = false
    local claimButton
    claimButton = createButton("claimCase", 100, function()
        if not IsValid(frm) or not frm.GetTitle then return end
        if not shouldClose then
            if frm:GetTitle():lower():find(L("claimedBy"):lower()) then
                chat.AddText(Color(255, 150, 0), "[" .. L("error") .. "] " .. L("caseAlreadyClaimed"))
                surface.PlaySound("common/wpn_denyselect.wav")
            else
                net.Start("liaTicketSystemClaim")
                net.WriteEntity(requester)
                net.SendToServer()
                shouldClose = true
                claimButton:SetText(L("closeCase"))
            end
        else
            net.Start("liaTicketSystemClose")
            net.WriteEntity(requester)
            net.SendToServer()
        end
    end, isLocalPlayer)

    local closeButton = vgui.Create("liaButton", frm)
    closeButton:SetText("X")
    closeButton:SetTooltip(L("close"))
    closeButton:SetPos(frameWidth - 18, 2)
    closeButton:SetSize(16, 16)
    closeButton.DoClick = function() frm:Remove() end
    frm:SetPos(xpos, ypos + 130 * #TicketFrames)
    frm:MoveTo(xpos, ypos + 130 * #TicketFrames, 0.2, 0, 1, function() surface.PlaySound("garrysmod/balloon_pop_cute.wav") end)
    function frm:OnRemove()
        if TicketFrames then
            table.RemoveByValue(TicketFrames, frm)
            for k, v in ipairs(TicketFrames) do
                v:MoveTo(xpos, ypos + 130 * (k - 1), 0.1, 0, 1)
            end
        end

        if IsValid(requester) and timer.Exists("ticketsystem-" .. requester:SteamID()) then timer.Remove("ticketsystem-" .. requester:SteamID()) end
    end

    table.insert(TicketFrames, frm)
    timer.Create("ticketsystem-" .. requester:SteamID(), 60, 1, function() if IsValid(frm) then frm:Remove() end end)
end

local MODULE = MODULE
local ticketPanel
local ticketsTabAdded = false
net.Receive("liaActiveTickets", function()
    local tickets = net.ReadTable() or {}
    if not IsValid(ticketPanel) then return end
    ticketPanel:Clear()
    ticketPanel:DockPadding(6, 6, 6, 6)
    ticketPanel.Paint = function() end
    local search = ticketPanel:Add("DTextEntry")
    search:Dock(TOP)
    search:DockMargin(0, 0, 0, 15)
    search:SetTall(30)
    search:SetPlaceholderText(L("search"))
    search:SetTextColor(Color(200, 200, 200))
    search.PaintOver = function(_, w, h) lia.derma.rect(0, 0, w, h):Rad(16):Color(Color(0, 0, 0, 100)):Shape(lia.derma.SHAPE_IOS):Draw() end
    local list = ticketPanel:Add("liaTable")
    list:Dock(FILL)
    local columns = {
        {
            name = L("timestamp"),
            field = "timestamp"
        },
        {
            name = L("requester"),
            field = "requesterDisplay"
        },
        {
            name = L("admin"),
            field = "adminDisplay"
        },
        {
            name = L("message"),
            field = "message"
        }
    }

    for _, col in ipairs(columns) do
        list:AddColumn(col.name)
    end

    local function populate(filter)
        list:Clear()
        filter = string.lower(filter or "")
        for _, t in pairs(tickets) do
            local requester = t.requester or ""
            local requesterDisplay = ""
            if requester ~= "" then
                local requesterPly = lia.util.getBySteamID(requester)
                local requesterName = IsValid(requesterPly) and requesterPly:Nick() or requester
                requesterDisplay = string.format("%s (%s)", requesterName, requester)
            end

            local ts = os.date("%Y-%m-%d %H:%M:%S", t.timestamp or os.time())
            local adminDisplay = L("unassigned")
            if t.admin then
                local adminPly = lia.util.getBySteamID(t.admin)
                local adminName = IsValid(adminPly) and adminPly:Nick() or t.admin
                adminDisplay = string.format("%s (%s)", adminName, t.admin)
            end

            local values = {ts, requesterDisplay, adminDisplay, t.message or ""}
            local match = false
            if filter == "" then
                match = true
            else
                for _, value in ipairs(values) do
                    if tostring(value):lower():find(filter, 1, true) then
                        match = true
                        break
                    end
                end
            end

            if match then list:AddLine(unpack(values)) end
        end
    end

    search.OnChange = function() populate(search:GetValue()) end
    populate("")
    function list:OnRowRightClick(_, line)
        if not IsValid(line) then return end
        local menu = lia.derma.dermaMenu()
        menu:AddOption(L("copyRow"), function()
            local rowString = ""
            for i, column in ipairs(self.Columns or {}) do
                local header = column.Header and column.Header:GetText() or L("columnWithNumber", i)
                local value = line:GetColumnText(i) or ""
                rowString = rowString .. header .. " " .. value .. " | "
            end

            SetClipboardText(string.sub(rowString, 1, -4))
        end):SetIcon("icon16/page_copy.png")

        menu:Open()
    end
end)

net.Receive("liaTicketsCount", function()
    local count = net.ReadInt(32)
    ticketsCount = count
    if not ticketsTabAdded and count > 0 then ticketsTabAdded = true end
end)

hook.Add("PopulateAdminTabs", "liaTicketsTab", function(pages)
    if not IsValid(LocalPlayer()) or not (LocalPlayer():hasPrivilege("alwaysSeeTickets") or LocalPlayer():isStaffOnDuty()) then return end
    if ticketsCount and ticketsCount > 0 then
        table.insert(pages, {
            name = "tickets",
            icon = "icon16/report.png",
            drawFunc = function(panel)
                ticketPanel = panel
                net.Start("liaRequestActiveTickets")
                net.SendToServer()
            end
        })
    end
end)

net.Receive("liaViewClaims", function()
    local tbl = net.ReadTable()
    local steamid = net.ReadString()
    if steamid and steamid ~= "" and steamid ~= " " then
        local v = tbl[steamid]
        lia.admin(L("claimRecordLast", v.name, v.claims, string.NiceTime(os.time() - v.lastclaim)))
    else
        for _, v in pairs(tbl) do
            lia.admin(L("claimRecord", v.name, v.claims))
        end
    end
end)

net.Receive("liaTicketSystem", function()
    local pl = net.ReadEntity()
    local msg = net.ReadString()
    local claimed = net.ReadEntity()
    if IsValid(LocalPlayer()) and (LocalPlayer():isStaffOnDuty() or LocalPlayer():hasPrivilege("alwaysSeeTickets")) then MODULE:TicketFrame(pl, msg, claimed) end
end)

net.Receive("liaTicketSystemClaim", function()
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
                    net.Start("liaTicketSystemClose")
                    net.WriteEntity(requester)
                    net.SendToServer()
                else
                    v:Close()
                end
            end
        end
    end
end)

net.Receive("liaTicketSystemClose", function()
    local requester = net.ReadEntity()
    if not IsValid(requester) or not requester:IsPlayer() then return end
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then v:Remove() end
    end

    if timer.Exists("ticketsystem-" .. requester:SteamID()) then timer.Remove("ticketsystem-" .. requester:SteamID()) end
end)