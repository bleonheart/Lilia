--[[
    Hooks:
        OnlineStaffDataReceived(table staffData)

    Purpose:
        Runs after the online-staff summary payload arrives on the client so UI code can refresh with the latest staff data.

    Category:
        Administration

    Parameters:
        staffData (table)
            The decoded online-staff summary array received from the server.

    Example Usage:
        ```lua
        hook.Add("OnlineStaffDataReceived", "liaExampleOnlineStaffDataReceived", function(staffData)
            print("Online staff entries:", #staffData)
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
lia.adminStickMapState = lia.adminStickMapState or lia.mapConfigurerState or {
    modeIndex = 1,
    cachedPositions = {},
    cacheType = nil,
    lastRequest = 0,
    removalMenuOpen = false
}

lia.mapConfigurerState = lia.adminStickMapState
net.Receive("liaFeaturePositions", function()
    local typeId = net.ReadString()
    local count = net.ReadUInt(16)
    local list = {}
    for i = 1, count do
        local pos = net.ReadVector()
        local label = net.ReadString()
        list[#list + 1] = {
            pos = pos,
            label = label
        }
    end

    local radiusCount = net.ReadUInt(16)
    for i = 1, radiusCount do
        local radius = net.ReadFloat()
        if list[i] then list[i].radius = radius end
    end

    lia.adminStickMapState.cacheType = typeId
    lia.adminStickMapState.cachedPositions = list
end)

net.Receive("liaBlindTarget", function()
    local enabled = net.ReadBool()
    if enabled then
        hook.Add("HUDPaint", "blindTarget", function() draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255)) end)
    else
        hook.Remove("HUDPaint", "blindTarget")
    end
end)

net.Receive("liaBlindFade", function()
    local isWhite = net.ReadBool()
    local duration = net.ReadFloat()
    local fadeIn = net.ReadFloat()
    local fadeOut = net.ReadFloat()
    local startTime = CurTime()
    local endTime = startTime + duration
    local color = isWhite and Color(255, 255, 255) or Color(0, 0, 0)
    local hookName = "blindFade" .. startTime
    hook.Add("HUDPaint", hookName, function()
        local ct = CurTime()
        if ct >= endTime then
            hook.Remove("HUDPaint", hookName)
            return
        end

        local alpha
        if ct < startTime + fadeIn then
            alpha = (ct - startTime) / fadeIn
        elseif ct > endTime - fadeOut then
            alpha = (endTime - ct) / fadeOut
        else
            alpha = 1
        end

        surface.SetDrawColor(color.r, color.g, color.b, math.Clamp(alpha * 255, 0, 255))
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end)
end)

net.Receive("liaAdminModeSwapCharacter", function()
    local id = net.ReadInt(32)
    assert(isnumber(id), L("idMustBeNumber"))
    local d = deferred.new()
    net.Receive("liaCharChoose", function()
        local message = net.ReadString()
        if message == "" then
            d:resolve()
            lia.char.getCharacter(id, nil, function(character)
                local client = LocalPlayer()
                if IsValid(client) then client:SetNoDraw(false) end
                hook.Run("CharLoaded", character)
            end)
        else
            d:reject(message)
        end
    end)

    net.Start("liaCharChoose")
    net.WriteUInt(id, 32)
    net.SendToServer()
    d:catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end)
end)

net.Receive("liaManagesitrooms", function()
    local rooms = net.ReadTable() or {}
    local frame = vgui.Create("liaFrame")
    frame:SetTitle(L("manageSitRooms"))
    frame:SetSize(640, 420)
    frame:Center()
    frame:MakePopup()
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 30, 10, 10)
    for name in pairs(rooms) do
        local entry = vgui.Create("DPanel", scroll)
        entry:SetTall(40)
        entry:Dock(TOP)
        entry:DockMargin(0, 0, 0, 5)
        local lbl = vgui.Create("DLabel", entry)
        lbl:Dock(LEFT)
        lbl:DockMargin(5, 0, 0, 0)
        lbl:SetText(name)
        lbl:SetTall(40)
        lbl:SetContentAlignment(4)
        local function makeButton(key, action)
            local btn = vgui.Create("liaButton", entry)
            btn:Dock(RIGHT)
            btn:SetWide(80)
            btn:SetText(L(key))
            btn.DoClick = function()
                net.Start("liaManagesitroomsAction")
                net.WriteUInt(action, 2)
                net.WriteString(name)
                if action == 2 then
                    local prompt = vgui.Create("liaFrame")
                    prompt:SetTitle(L("renameSitroomTitle"))
                    prompt:SetSize(300, 100)
                    prompt:Center()
                    prompt:MakePopup()
                    local txt = vgui.Create("liaEntry", prompt)
                    txt:Dock(FILL)
                    local ok = vgui.Create("liaButton", prompt)
                    ok:Dock(BOTTOM)
                    ok:SetText(string.upper(L("ok")))
                    ok.DoClick = function()
                        net.WriteString(txt:GetValue())
                        net.SendToServer()
                        prompt:Close()
                        frame:Close()
                    end
                    return
                end

                net.SendToServer()
                frame:Close()
            end
        end

        makeButton("teleport", 1)
        makeButton("reposition", 3)
        makeButton("rename", 2)
    end
end)

lia.net.readBigTable("liaStaffCasesSnapshot", function(payload)
    payload = payload or {}
    local adminModule = lia.module.get("administration")
    if not adminModule then return end
    adminModule.staffCasesPayload = {
        tickets = payload.tickets or {},
        warnings = payload.warnings or {},
        pks = payload.pks or {}
    }

    local panel = adminModule.staffCasesPanel
    if IsValid(panel) and isfunction(panel.RefreshData) then panel:RefreshData() end
end)

net.Receive("liaOnlineStaffData", function()
    local staffData = net.ReadTable() or {}
    hook.Run("OnlineStaffDataReceived", staffData)
end)

net.Receive("liaCharDeleted", function()
    if not (IsValid(panelRef) and isfunction(panelRef.buildSheets)) then return end
    MODULE.charListRequestID = ((MODULE.charListRequestID or 0) + 1) % 65535
    panelRef.charListRequestID = MODULE.charListRequestID
    panelRef.charListLoadedCount = 0
    panelRef.charListTotalCount = 0
    panelRef.charListBuilt = false
    panelRef:Clear()
    panelRef:DockPadding(16, 16, 16, 16)
    panelRef.Paint = nil
    local loading = panelRef:Add("DLabel")
    loading:Dock(FILL)
    loading:SetFont("LiliaFont.20")
    loading:SetText("Loading character records...")
    loading:SetTextColor(Color(180, 190, 190))
    loading:SetContentAlignment(5)
    net.Start("liaRequestFullCharListPage")
    net.WriteUInt(panelRef.charListRequestID, 16)
    net.WriteUInt(0, 32)
    net.WriteUInt(100, 16)
    net.SendToServer()
end)

net.Receive("liaNetProfilerSnapshot", function()
    local panel = MODULE.netProfilerPanel
    if not IsValid(panel) then return end
    local snapshot = net.ReadTable()
    if isfunction(panel.RenderNetProfilerSnapshot) then panel:RenderNetProfilerSnapshot(snapshot) end
end)

net.Receive("liaToolPermissionTiers", function()
    local data = net.ReadTable() or {tools = {}, tiers = {}}
    MODULE.toolPermissionTierData = MODULE.toolPermissionTierData or {tools = {}, tiers = {}}
    MODULE.toolPermissionTierData.tools = data.tools or {}
    MODULE.toolPermissionTierData.tiers = data.tiers or {}
    if MODULE.toolPermissionTierRefresh then MODULE.toolPermissionTierRefresh() end
end)

net.Receive("liaStaffCharacterConfiguration", function()
    local config = MODULE.staffCharacterConfiguration or {}
    local incoming = net.ReadTable()
    if incoming then
        for key in pairs(config) do config[key] = nil end
        for key, value in pairs(incoming) do config[key] = value end
    end
    config.permissions = config.permissions or {}
    config.flags = config.flags or {}
    config.privileges = config.privileges or {}
    config.flagDefinitions = config.flagDefinitions or {}
    local operations = MODULE.staffCharacterConfigurationOperations or {}
    if #operations > 0 then table.remove(operations, 1) end
    for _, operation in ipairs(operations) do
        if operation.kind == "permission" then
            config.permissions[operation.id] = operation.enabled and true or nil
        elseif operation.kind == "flag" then
            config.flags[operation.id] = operation.enabled and true or nil
        elseif operation.kind == "reset" then
            config.permissions = {}
            config.flags = {}
        end
    end
    MODULE.staffCharacterConfiguration = config
    lia.staffCharacterPermissions = config.permissions
    lia.staffCharacterFlags = config.flags
    if MODULE.staffCharacterConfigurationRefresh then MODULE.staffCharacterConfigurationRefresh(true) end
end)

