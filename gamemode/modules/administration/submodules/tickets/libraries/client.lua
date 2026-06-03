function MODULE:PopulateAdminTabs(pages)
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local canAlwaysSeeTickets = client:hasPrivilege("alwaysSeeTickets")
    local isStaffOnDuty = client:isStaffOnDuty()
    local canSeeTickets = canAlwaysSeeTickets or isStaffOnDuty
    if canSeeTickets then
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
end

local TicketFrames = {}
local xpos = xpos or 20
local ypos = ypos or 20
local function CreateTicketFrame(requester, message, claimed)
    if not IsValid(requester) or not requester:IsPlayer() then return end
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then
            local txt = v:GetChildren()[5]
            txt:AppendText("\n" .. message)
            txt:GotoTextEnd()
            lia.websound.playButtonSound("ui/hint.wav")
            return
        end
    end

    local frameWidth, frameHeight = 400, 160
    local frm = vgui.Create("liaFrame")
    frm:SetSize(frameWidth, frameHeight)
    frm:SetPos(xpos, ypos)
    frm.idiot = requester
    frm:ShowCloseButton(false)
    if claimed and IsValid(claimed) and claimed:IsPlayer() then
        frm:SetTitle(L("ticketTitleClaimed", requester:Nick(), claimed:Nick()))
        if claimed ~= LocalPlayer() then frm.headerColor = Color(207, 0, 15) end
    else
        frm:SetTitle(requester:Nick())
    end

    local msg = vgui.Create("liaEntry", frm)
    msg:SetPos(10, 30)
    msg:SetSize(280, frameHeight - 35)
    msg:SetText(message)
    msg:SetMultiline(true)
    msg:SetEditable(false)
    msg:SetPaintBackground(false)
    msg.Paint = function(panel, w, h)
        lia.derma.rect(0, 0, w, h):Rad(4):Color((lia.color.theme and lia.color.theme.panel and lia.color.theme.panel[1]) or Color(34, 62, 62)):Shape(lia.derma.SHAPE_IOS):Draw()
        panel:DrawTextEntryText((lia.color.theme and lia.color.theme.text) or Color(210, 235, 235), (lia.color.theme and lia.color.theme.text) or Color(210, 235, 235), (lia.color.theme and lia.color.theme.text) or Color(210, 235, 235))
    end

    local function createButton(text, position, clickFunc, disabled)
        text = L(text)
        local btn = vgui.Create("liaButton", frm)
        btn:SetPos(300, position)
        btn:SetSize(83, 18)
        btn:SetText(text)
        btn.Disabled = disabled
        btn.DoClick = function() if not btn.Disabled then clickFunc() end end
        if disabled then btn:SetTooltip(L("ticketActionSelf")) end
        return btn
    end

    local isLocalPlayer = requester == LocalPlayer()
    createButton("goTo", 35, function() lia.admin.execCommand("goto", requester) end, isLocalPlayer)
    createButton("returnText", 60, function() lia.admin.execCommand("return", requester) end, isLocalPlayer)
    createButton("freeze", 85, function() lia.admin.execCommand("freeze", requester) end, isLocalPlayer)
    createButton("bring", 110, function() lia.admin.execCommand("bring", requester) end, isLocalPlayer)
    local shouldClose = false
    local claimButton
    claimButton = createButton("claimCase", 135, function()
        if not IsValid(frm) then return end
        if not frm.title then return end
        if not shouldClose then
            local title = frm.title
            if title and title:lower():find(L("claimedBy"):lower()) then
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
    frm:SetPos(xpos, ypos + 180 * #TicketFrames)
    frm:MoveTo(xpos, ypos + 180 * #TicketFrames, 0.2, 0, 1, function() surface.PlaySound("garrysmod/balloon_pop_cute.wav") end)
    function frm:OnRemove()
        if TicketFrames then
            table.RemoveByValue(TicketFrames, frm)
            for k, v in ipairs(TicketFrames) do
                v:MoveTo(xpos, ypos + 180 * (k - 1), 0.1, 0, 1)
            end
        end
    end

    table.insert(TicketFrames, frm)
end

net.Receive("liaActiveTickets", function()
    local tickets = net.ReadTable() or {}
    if not IsValid(ticketPanel) then return end
    ticketPanel:Clear()
    ticketPanel:DockPadding(6, 6, 6, 6)
    ticketPanel.Paint = function() end
    local search = ticketPanel:Add("liaEntry")
    search:Dock(TOP)
    search:DockMargin(0, 20, 0, 15)
    search:SetTall(30)
    search:SetFont("LiliaFont.17")
    search:SetPlaceholderText(L("search"))
    search:SetTextColor(Color(200, 200, 200))
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

    list:AddMenuOption(L("copyRow"), function(rowData)
        local rowString = ""
        for i, column in ipairs(columns) do
            local header = column.name or L("columnWithNumber", i)
            local value = tostring(rowData[i] or "")
            rowString = rowString .. header .. " " .. value .. " | "
        end

        SetClipboardText(string.sub(rowString, 1, -4))
    end, "icon16/page_copy.png")

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

        list:ForceCommit()
        list:InvalidateLayout(true)
        if list.scrollPanel then list.scrollPanel:InvalidateLayout(true) end
    end

    list:AddMenuOption(L("noOptionsAvailable"), function() end)
    search.OnTextChanged = function(_, value) populate(value or "") end
    populate("")
end)

net.Receive("liaViewClaims", function()
    local tbl = net.ReadTable()
    local steamid = net.ReadString()
    if steamid and steamid ~= "" and steamid ~= " " then
        local v = tbl[steamid]
        lia.information(L("claimRecordLast", v.name, v.claims, string.NiceTime(os.time() - v.lastclaim)))
    else
        for _, v in pairs(tbl) do
            lia.information(L("claimRecord", v.name, v.claims))
        end
    end
end)

net.Receive("liaTicketSystem", function()
    local pl = net.ReadEntity()
    local msg = net.ReadString()
    local claimed = net.ReadEntity()
    local client = LocalPlayer()
    local permission = IsValid(client) and (client:isStaffOnDuty() or client:hasPrivilege("alwaysSeeTickets")) or false
    if permission then CreateTicketFrame(pl, msg, claimed) end
end)

net.Receive("liaTicketSystemClaim", function()
    local pl = net.ReadEntity()
    local requester = net.ReadEntity()
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then
            v:SetTitle(requester:Nick() .. " - " .. L("claimedBy") .. " " .. pl:Nick())
            local bu = v:GetChildren()[11]
            if not bu or not IsValid(bu) then return end
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
end)

net.Receive("liaClearAllTicketFrames", function()
    for _, v in pairs(TicketFrames) do
        if IsValid(v) then v:Remove() end
    end

    TicketFrames = {}
end)

