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
    assert(isnumber(id), "id must be a number")
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
    d:catch(function(err) if err and err ~= "" then LocalPlayer():notifyError(err) end end)
end)

net.Receive("liaManagesitrooms", function()
    local rooms = net.ReadTable() or {}
    local frame = vgui.Create("liaFrame")
    frame:SetTitle("Manage Administration Rooms")
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
            btn:SetText(key)
            btn.DoClick = function()
                net.Start("liaManagesitroomsAction")
                net.WriteUInt(action, 2)
                net.WriteString(name)
                if action == 2 then
                    local prompt = vgui.Create("liaFrame")
                    prompt:SetTitle("Rename Administration Room")
                    prompt:SetSize(300, 100)
                    prompt:Center()
                    prompt:MakePopup()
                    local txt = vgui.Create("liaEntry", prompt)
                    txt:Dock(FILL)
                    local ok = vgui.Create("liaButton", prompt)
                    ok:Dock(BOTTOM)
                    ok:SetText(string.upper("ok"))
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
    local data = net.ReadTable() or {
        tools = {},
        tiers = {}
    }

    MODULE.toolPermissionTierData = MODULE.toolPermissionTierData or {
        tools = {},
        tiers = {}
    }

    MODULE.toolPermissionTierData.tools = data.tools or {}
    MODULE.toolPermissionTierData.tiers = data.tiers or {}
    if MODULE.toolPermissionTierRefresh then MODULE.toolPermissionTierRefresh() end
end)

net.Receive("liaStaffCharacterConfiguration", function()
    local config = MODULE.staffCharacterConfiguration or {}
    local incoming = net.ReadTable()
    if incoming then
        for key in pairs(config) do
            config[key] = nil
        end

        for key, value in pairs(incoming) do
            config[key] = value
        end
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

net.Receive("liaBodygrouperMenu", function()
    local client = LocalPlayer()
    if IsValid(lia.gui.bodygroupMenu) then lia.gui.bodygroupMenu:Remove() end
    local entity = net.ReadEntity()
    lia.gui.bodygroupMenu = vgui.Create("BodygrouperMenu")
    local target = IsValid(entity) and entity or client
    lia.gui.bodygroupMenu:SetTarget(target)
end)

net.Receive("liaBodygrouperMenuCloseClientside", function() if IsValid(lia.gui.bodygroupMenu) then lia.gui.bodygroupMenu:Remove() end end)
net.Receive("liaSeeModelTable", function()
    local models = net.ReadTable()
    if not istable(models) or #models == 0 then return end
    local selectedModel = models[1]
    local frame = vgui.Create("liaFrame")
    frame:setScaledSize(520, math.min(ScrH() * 0.82, 820))
    frame:SetPos(ScrW() - frame:GetWide() - 48, math.max(48, (ScrH() - frame:GetTall()) * 0.5))
    frame:SetTitle("Model Wardrobe")
    frame:MakePopup()
    frame:DockPadding(12, 34, 12, 12)
    local function positionWardrobeCloseButton(this)
        if IsValid(this.cls) then
            this.cls:SetParent(this)
            this.cls:SetSize(20, 20)
            this.cls:SetPos(this:GetWide() - 22, 2)
            this.cls:SetZPos(1000)
        end
    end

    frame.OnSizeChanged = function(this) positionWardrobeCloseButton(this) end
    positionWardrobeCloseButton(frame)
    local title = frame:Add("DPanel")
    title:Dock(TOP)
    title:DockMargin(0, 0, 0, 12)
    title:SetTall(32)
    title.Paint = function(_, w, h)
        local lineColor = lia.color.theme.theme
        surface.SetDrawColor(lineColor)
        surface.DrawRect(4, h - 2, math.max(w - 8, 0), 2)
    end

    local titleLabel = title:Add("DLabel")
    titleLabel:Dock(FILL)
    titleLabel:DockMargin(8, 0, 8, 0)
    titleLabel:SetFont("LiliaFont.18")
    titleLabel:SetText(("Select a model"):upper())
    titleLabel:SetTextColor(lia.color.theme and lia.color.theme.text or color_white)
    titleLabel:SetContentAlignment(5)
    local hint = frame:Add("DLabel")
    hint:Dock(TOP)
    hint:DockMargin(0, 0, 0, 10)
    hint:SetTall(20)
    hint:SetFont("LiliaFont.16")
    hint:SetTextColor(Color(220, 220, 220))
    hint:SetContentAlignment(5)
    hint:SetText(string.format("Use %s and %s to rotate the model.", "A", "D"))
    local confirmButton = vgui.Create("DButton", frame)
    confirmButton:SetText("Confirm")
    confirmButton:Dock(BOTTOM)
    confirmButton:SetTall(40)
    confirmButton:SetColor(Color(255, 255, 255))
    confirmButton:SetFont("DermaDefaultBold")
    confirmButton:SetContentAlignment(5)
    confirmButton:DockMargin(0, 10, 0, 0)
    local modelsScroll = vgui.Create("liaScrollPanel", frame)
    modelsScroll:Dock(FILL)
    modelsScroll:DockMargin(0, 0, 0, 0)
    local iconLayoutParent = modelsScroll.GetCanvas and modelsScroll:GetCanvas() or modelsScroll
    local iconLayout = iconLayoutParent:Add("DIconLayout")
    iconLayout:Dock(LEFT)
    iconLayout:SetSpaceX(8)
    iconLayout:SetSpaceY(8)
    iconLayout:SetPaintBackground(false)
    frame._iconColumns = 5
    frame._iconSpace = 8
    local function requestIconResize()
        if not IsValid(iconLayout) then return false end
        local w = iconLayout:GetWide() or 0
        if w <= 0 then return false end
        frame._needsIconResize = true
        frame:InvalidateLayout(true)
        return true
    end

    local oldLayoutPerformLayout = iconLayout.PerformLayout
    iconLayout.PerformLayout = function(layout, w, h)
        if oldLayoutPerformLayout then oldLayoutPerformLayout(layout, w, h) end
        local offsetX = layout._centerOffsetX or 0
        local prevOffsetX = layout._appliedCenterOffsetX or 0
        local delta = offsetX - prevOffsetX
        if delta == 0 then return end
        for _, child in ipairs(layout:GetChildren()) do
            if IsValid(child) then
                local x, y = child:GetPos()
                child:SetPos(x + delta, y)
            end
        end

        layout._appliedCenterOffsetX = offsetX
    end

    frame.PerformLayout = function(this, w, h)
        local columns = this._iconColumns or 5
        local space = this._iconSpace or 8
        local layoutW = IsValid(modelsScroll) and modelsScroll:GetWide() or 0
        if layoutW <= 0 then return end
        iconLayout:SetWide(layoutW)
        local iconW = math.floor((layoutW - (columns - 1) * space) / columns)
        if iconW < 64 then iconW = 64 end
        if iconW > 80 then iconW = 80 end
        local iconH = math.floor(iconW * 2)
        for _, child in ipairs(iconLayout:GetChildren()) do
            if IsValid(child) and child.SetSize then child:SetSize(iconW, iconH) end
        end

        iconLayout:SizeToChildren(false, true)
        local childCount = #iconLayout:GetChildren()
        local usedWidth = math.min(childCount, columns) * iconW + math.max(0, math.min(childCount, columns) - 1) * space
        iconLayout._centerOffsetX = math.max(0, math.floor((layoutW - usedWidth) * 0.5))
        iconLayout:InvalidateLayout(true)
        this._needsIconResize = nil
    end

    local function previewModel(modelPath)
        lia.camera.begin(frame, {
            hideEntities = {LocalPlayer()}
        })

        lia.camera.setModel(frame, modelPath)
    end

    local function setSelectedModel(modelPath)
        selectedModel = modelPath
        previewModel(modelPath)
        if IsValid(iconLayout) then
            for _, child in ipairs(iconLayout:GetChildren()) do
                if IsValid(child) then child._liaSelected = child.modelPath == modelPath end
            end
        end
    end

    local function paintIcon(icon, w, h)
        if not icon._liaSelected then return end
        local col = lia.config.get("Color", color_white)
        surface.SetDrawColor(col.r, col.g, col.b, 200)
        for i = 1, 3 do
            local o = i * 2
            surface.DrawOutlinedRect(i, i, w - o, h - o)
        end
    end

    local function buildModelIcons()
        if not IsValid(iconLayout) then return end
        iconLayout:Clear()
        for _, modelPath in ipairs(models) do
            local icon = iconLayout:Add("SpawnIcon")
            icon:SetModel(modelPath)
            icon.modelPath = modelPath
            icon.PaintOver = paintIcon
            icon.DoClick = function() setSelectedModel(modelPath) end
        end

        requestIconResize()
    end

    buildModelIcons()
    setSelectedModel(models[1])
    frame.Think = function()
        if input.IsKeyDown(KEY_A) then
            lia.camera.rotate(frame, -50 * FrameTime())
        elseif input.IsKeyDown(KEY_D) then
            lia.camera.rotate(frame, 50 * FrameTime())
        end
    end

    frame.OnRemove = function() lia.camera.close(frame) end
    confirmButton.DoClick = function()
        if isstring(selectedModel) and selectedModel ~= "" then
            net.Start("liaWardrobeChangeModel")
            net.WriteString(selectedModel)
            net.SendToServer()
            frame:Close()
        else
            chat.AddText(Color(255, 0, 0), "Failed to load wardrobe models.")
        end
    end

    timer.Simple(0, function()
        if not IsValid(frame) then return end
        requestIconResize()
        timer.Simple(0.05, function() if IsValid(frame) then requestIconResize() end end)
    end)
end)
