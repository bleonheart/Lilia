if SERVER then
    net.Receive("liaStringRequest", function(_, client)
        local id = net.ReadUInt(32)
        local value = net.ReadString()
        if client.liaStrReqs and client.liaStrReqs[id] then
            client.liaStrReqs[id](value)
            client.liaStrReqs[id] = nil
        end
    end)

    net.Receive("liaStringRequestCancel", function(_, client)
        local id = net.ReadUInt(32)
        if client.liaStrReqs and client.liaStrReqs[id] then client.liaStrReqs[id] = nil end
    end)

    net.Receive("liaArgumentsRequest", function(_, client)
        local id = net.ReadUInt(32)
        local data = net.ReadTable()
        local req = client.liaArgReqs and client.liaArgReqs[id]
        if not req then return end
        local spec = req.spec or {}
        local isOrdered = istable(spec) and #spec > 0 and istable(spec[1])
        for name, typeInfo in isOrdered and ipairs(spec) or pairs(spec) do
            local fieldName, expectedType = isOrdered and typeInfo[1] or name, isOrdered and typeInfo[2] or typeInfo
            if istable(expectedType) then expectedType = expectedType[1] end
            local value = data and data[fieldName]
            if value == nil and expectedType ~= "boolean" and expectedType ~= "table" then
                client:notifyError("Please fill in all required fields.")
                client.liaArgReqs[id] = nil
                return
            elseif value == nil then
                client.liaArgReqs[id] = nil
                return
            end
        end

        if isfunction(req.callback) then req.callback(true, data) end
        client.liaArgReqs[id] = nil
    end)

    net.Receive("liaArgumentsRequestCancel", function(_, client)
        local id = net.ReadUInt(32)
        local req = client.liaArgReqs and client.liaArgReqs[id]
        if req and isfunction(req.callback) then req.callback(false) end
        if client.liaArgReqs then client.liaArgReqs[id] = nil end
    end)

    net.Receive("liaRequestDropdown", function(_, client)
        local id = net.ReadUInt(32)
        local selectedOption = net.ReadString()
        local selectedData = net.ReadString()
        if selectedData == "" then selectedData = nil end
        local req = client.liaDropdownReqs and client.liaDropdownReqs[id]
        if not req then return end
        local valid = false
        for _, opt in ipairs(req.allowed or {}) do
            local text = istable(opt) and opt[1] or opt
            if isstring(text) and text:sub(1, 1) == "@" then text = text:sub(2) end
            if string.lower(tostring(text)) == string.lower(tostring(selectedOption)) then
                valid = true
                break
            end
        end

        if not valid then
            client.liaDropdownReqs[id] = nil
            return
        end

        if isfunction(req.callback) then
            if selectedData ~= nil then
                req.callback(selectedOption, selectedData)
            else
                req.callback(selectedOption)
            end
        end

        client.liaDropdownReqs[id] = nil
    end)

    net.Receive("liaRequestDropdownCancel", function(_, client)
        local id = net.ReadUInt(32)
        if client.liaDropdownReqs then client.liaDropdownReqs[id] = nil end
    end)

    net.Receive("liaOptionsRequest", function(_, client)
        local id = net.ReadUInt(32)
        local selected = net.ReadTable()
        local req = client.liaOptionsReqs and client.liaOptionsReqs[id]
        if not req or not istable(selected) or #selected == 0 or #selected > (tonumber(req.limit) or 1) then
            if client.liaOptionsReqs then client.liaOptionsReqs[id] = nil end
            return
        end

        for _, value in ipairs(selected) do
            local valid = false
            for _, allowed in ipairs(req.allowed or {}) do
                local text = istable(allowed) and allowed[1] or allowed
                if isstring(text) and text:sub(1, 1) == "@" then text = text:sub(2) end
                if string.lower(tostring(text)) == string.lower(tostring(value)) then
                    valid = true
                    break
                end
            end

            if not valid then
                client.liaOptionsReqs[id] = nil
                return
            end
        end

        if isfunction(req.callback) then req.callback(selected) end
        client.liaOptionsReqs[id] = nil
    end)

    net.Receive("liaOptionsRequestCancel", function(_, client)
        local id = net.ReadUInt(32)
        if client.liaOptionsReqs then client.liaOptionsReqs[id] = nil end
    end)

    net.Receive("liaBinaryQuestionRequest", function(_, client)
        local id = net.ReadUInt(32)
        local choice = net.ReadUInt(1)
        local callback = client.liaBinaryReqs and client.liaBinaryReqs[id]
        if isfunction(callback) then callback(choice) end
        if client.liaBinaryReqs then client.liaBinaryReqs[id] = nil end
    end)

    net.Receive("liaBinaryQuestionRequestCancel", function(_, client)
        local id = net.ReadUInt(32)
        if client.liaBinaryReqs then client.liaBinaryReqs[id] = nil end
    end)

    net.Receive("liaPopupQuestionRequest", function(_, client)
        local id = net.ReadUInt(32)
        local index = net.ReadUInt(8)
        local callbacks = client.liaPopupReqs and client.liaPopupReqs[id]
        if callbacks and isfunction(callbacks[index]) then callbacks[index]() end
        if client.liaPopupReqs then client.liaPopupReqs[id] = nil end
    end)

    net.Receive("liaButtonRequest", function(_, client)
        local id = net.ReadUInt(32)
        local choice = net.ReadUInt(8)
        local data = client.buttonRequests and client.buttonRequests[id]
        if data and data[choice] then
            data[choice](client)
            client.buttonRequests[id] = nil
        end
    end)
end

if CLIENT then
    local function requestThemeColor(value, fallback)
        if IsColor(value) then return value end
        return fallback
    end

    local function blendRequestColor(base, tint, fraction, alpha)
        fraction = math.Clamp(fraction or 0, 0, 1)
        return Color(math.Round(Lerp(fraction, base.r, tint.r)), math.Round(Lerp(fraction, base.g, tint.g)), math.Round(Lerp(fraction, base.b, tint.b)), alpha or 255)
    end

    local function getRequestPalette()
        local theme = lia.color and lia.color.theme or {}
        local accent = requestThemeColor(theme.accent or theme.maincolor or theme.theme, Color(60, 140, 140))
        local textColor = requestThemeColor(theme.text, Color(210, 235, 235))
        local background = requestThemeColor(theme.background, Color(24, 32, 32))
        local popup = requestThemeColor(theme.backgroundPanelPopup or theme.background_panelpopup, Color(20, 28, 28))
        local button = requestThemeColor(theme.button, Color(38, 66, 66))
        local buttonHovered = requestThemeColor(theme.buttonHovered or theme.button_hovered, Color(70, 140, 140))
        return {
            accent = accent,
            text = textColor,
            textSecondary = blendRequestColor(textColor, background, 0.18, 255),
            textMuted = blendRequestColor(textColor, background, 0.46, 255),
            surface = blendRequestColor(popup, accent, 0.08, 248),
            surfaceRaised = blendRequestColor(popup, accent, 0.14, 245),
            inset = blendRequestColor(background, accent, 0.09, 235),
            button = blendRequestColor(button, accent, 0.08, 238),
            buttonHovered = blendRequestColor(buttonHovered, accent, 0.14, 248),
            keycap = blendRequestColor(background, accent, 0.16, 245),
            border = Color(accent.r, accent.g, accent.b, 68),
            borderStrong = Color(accent.r, accent.g, accent.b, 126),
            separator = Color(accent.r, accent.g, accent.b, 32)
        }
    end

    local function drawRequestPanel(x, y, w, h, radius, color, outline)
        if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
            lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
            if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
            return
        end

        draw.RoundedBox(radius, x, y, w, h, color)
        if outline then
            surface.SetDrawColor(outline)
            surface.DrawOutlinedRect(x, y, w, h, 1)
        end
    end

    local function drawRequestOutline(x, y, w, h, radius, color)
        if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
            lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
            return
        end

        surface.SetDrawColor(color)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end

    local function resolveClientRequestText(value, fallback)
        if value == nil then return fallback end
        if istable(value) then
            local token = value[1]
            if isstring(token) and token:sub(1, 1) == "@" then return token end
            if token ~= nil then return tostring(token) end
            return fallback
        end

        if isstring(value) and value:sub(1, 1) == "@" then return value:sub(2) end
        return tostring(value)
    end

    local function resolveClientRequestOption(value)
        if not istable(value) then return resolveClientRequestText(value, value) end
        local result = table.Copy(value)
        if result.text ~= nil then result.text = resolveClientRequestText(result.text, result.text) end
        if result[1] ~= nil then result[1] = resolveClientRequestText(result[1], result[1]) end
        return result
    end

    local function StyleRequestFrame(frame, kind, title, description)
        if not IsValid(frame) then return frame end
        frame._liaRequestKind = string.upper(tostring(kind or "REQUEST"))
        frame._liaRequestTitle = resolveClientRequestText(title, frame.GetTitle and frame:GetTitle() or "Request")
        frame._liaRequestDescription = resolveClientRequestText(description, "")
        frame._liaRequestHeaderHeight = frame._liaRequestDescription ~= "" and 82 or 66
        if frame.SetTitle then frame:SetTitle("") end
        if frame.SetCenterTitle then frame:SetCenterTitle("") end
        if frame.SetDraggable then frame:SetDraggable(true) end
        frame:DockPadding(18, frame._liaRequestHeaderHeight, 18, 18)
        frame:SetDrawOnTop(true)
        frame:SetZPos(30000)
        frame.Paint = function(s, w, h)
            local palette = getRequestPalette()
            draw.RoundedBox(10, 5, 6, math.max(w - 10, 0), math.max(h - 3, 0), Color(0, 0, 0, 115))
            drawRequestPanel(0, 0, w, h, 9, palette.surface, palette.borderStrong)
            draw.RoundedBoxEx(8, 0, 0, 4, h, palette.accent, true, false, true, false)
            draw.SimpleText(s._liaRequestKind, "LiliaFont.15", 18, 12, palette.accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(lia.util.wrapText(s._liaRequestTitle, math.max(w - 86, 60), "LiliaFont.20", 1, "...")[1] or "", "LiliaFont.20", 18, 30, palette.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            if s._liaRequestDescription ~= "" then draw.SimpleText(lia.util.wrapText(s._liaRequestDescription, math.max(w - 86, 60), "LiliaFont.15", 1, "...")[1] or "", "LiliaFont.15", 18, 54, palette.textMuted, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end
            surface.SetDrawColor(palette.separator)
            surface.DrawRect(18, s._liaRequestHeaderHeight - 8, math.max(w - 36, 0), 1)
        end

        if IsValid(frame.cls) then
            frame.cls.Paint = function(s, w, h)
                local palette = getRequestPalette()
                if s:IsHovered() then drawRequestPanel(0, 0, w, h, 5, Color(palette.accent.r, palette.accent.g, palette.accent.b, 24), Color(palette.accent.r, palette.accent.g, palette.accent.b, 70)) end
                draw.SimpleText("X", "LiliaFont.18", w * 0.5, h * 0.5, s:IsHovered() and palette.accent or palette.textMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        return frame
    end

    local function CreateRequestButton(parent, text, mode, icon)
        local button = parent:Add("DButton")
        button:SetText("")
        button:SetCursor("hand")
        button._liaRequestText = tostring(text or "")
        button._liaRequestMode = mode or "secondary"
        button._liaRequestHover = 0
        button._liaRequestIcon = isstring(icon) and icon ~= "" and Material(icon, "smooth") or type(icon) == "IMaterial" and icon or nil
        button.Paint = function(s, w, h)
            local palette = getRequestPalette()
            s._liaRequestHover = Lerp(math.Clamp(FrameTime() * 14, 0, 1), s._liaRequestHover, s:IsHovered() and 1 or 0)
            local primary = s._liaRequestMode == "primary"
            local base = primary and blendRequestColor(palette.button, palette.accent, 0.16, 248) or palette.button
            local hovered = primary and blendRequestColor(palette.buttonHovered, palette.accent, 0.18, 252) or palette.buttonHovered
            local background = Color(math.Round(Lerp(s._liaRequestHover, base.r, hovered.r)), math.Round(Lerp(s._liaRequestHover, base.g, hovered.g)), math.Round(Lerp(s._liaRequestHover, base.b, hovered.b)), math.Round(Lerp(s._liaRequestHover, base.a or 245, hovered.a or 250)))
            local outlineAlpha = math.Round(Lerp(s._liaRequestHover, primary and 88 or 42, primary and 165 or 125))
            drawRequestPanel(0, 0, w, h, 6, background, Color(palette.accent.r, palette.accent.g, palette.accent.b, outlineAlpha))
            if primary or s._liaRequestHover > 0.01 then
                surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(primary and Lerp(s._liaRequestHover, 110, 225) or 200 * s._liaRequestHover))
                surface.DrawRect(6, h - 2, math.max(w - 12, 0), 2)
            end

            local textX = w * 0.5
            local align = TEXT_ALIGN_CENTER
            if s._liaRequestIcon and not s._liaRequestIcon:IsError() then
                surface.SetMaterial(s._liaRequestIcon)
                surface.SetDrawColor(palette.textSecondary)
                surface.DrawTexturedRect(13, math.floor((h - 16) * 0.5), 16, 16)
                textX = 38
                align = TEXT_ALIGN_LEFT
            end

            draw.SimpleText(s._liaRequestText, "LiliaFont.17", textX, h * 0.5, palette.textSecondary, align, TEXT_ALIGN_CENTER)
        end
        return button
    end

    local function CreateRequestCard(parent, height)
        local card = parent:Add("DPanel")
        card:Dock(TOP)
        card:SetTall(height or 62)
        card:DockMargin(0, 0, 0, 8)
        card.Paint = function(_, w, h)
            local palette = getRequestPalette()
            drawRequestPanel(0, 0, w, h, 7, palette.inset, Color(palette.accent.r, palette.accent.g, palette.accent.b, 34))
        end
        return card
    end

    local function CreateRequestFooter(frame, cancelText, submitText, onCancel, onSubmit)
        local footer = frame:Add("DPanel")
        footer:Dock(BOTTOM)
        footer:SetTall(54)
        footer:DockMargin(0, 10, 0, 0)
        footer.Paint = function(_, w)
            local palette = getRequestPalette()
            surface.SetDrawColor(palette.separator)
            surface.DrawRect(0, 0, w, 1)
        end

        local cancel
        if cancelText then
            cancel = CreateRequestButton(footer, cancelText, "secondary")
            cancel:SetSize(126, 40)
            cancel.DoClick = onCancel
        end

        local submit
        if submitText then
            submit = CreateRequestButton(footer, submitText, "primary")
            submit:SetSize(126, 40)
            submit.DoClick = onSubmit
        end

        footer.PerformLayout = function(_, w)
            if IsValid(cancel) then cancel:SetPos(0, 10) end
            if IsValid(submit) then submit:SetPos(w - submit:GetWide(), 10) end
        end
        return footer, submit, cancel
    end

    local function CreateRequestScroll(frame)
        local scroll = frame:Add("liaScrollPanel")
        scroll:Dock(FILL)
        scroll:DockMargin(0, 6, 0, 0)
        scroll.Paint = function() end
        return scroll
    end

    local function AddComboChoices(combo, options, defaultValue)
        local defaultChoice
        for index, option in ipairs(options or {}) do
            local display = resolveClientRequestOption(option)
            if istable(display) then
                combo:AddChoice(tostring(display[1]), display[2])
                if defaultValue ~= nil and (display[2] == defaultValue or display[1] == defaultValue) then defaultChoice = index end
            else
                combo:AddChoice(tostring(display))
                if defaultValue ~= nil and tostring(display) == tostring(defaultValue) then defaultChoice = index end
            end
        end

        if combo.FinishAddingOptions then combo:FinishAddingOptions() end
        if combo.PostInit then combo:PostInit() end
        if defaultChoice and combo.ChooseOptionID then
            combo:ChooseOptionID(defaultChoice)
        elseif #options > 0 and combo.ChooseOptionID then
            combo:ChooseOptionID(1)
        end
    end

    lia.derma.requestOptions = function(title, subTitle, options, callback, onCancel)
        if IsValid(lia.gui.menuRequestOptions) then lia.gui.menuRequestOptions:Remove() end
        options = istable(options) and options or {}
        local count = #options
        local width = 620
        local height = math.Clamp(154 + count * 70, 270, math.floor(ScrH() * 0.68))
        local frame = vgui.Create("liaFrame")
        frame:SetSize(width, height)
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "OPTION REQUEST", resolveClientRequestText(title, "Options"), resolveClientRequestText(subTitle, ""))
        local finished = false
        local controls = {}
        local function cancelRequest()
            if finished then return end
            finished = true
            if onCancel then onCancel() end
            if IsValid(frame) then frame:Remove() end
        end

        local function submitRequest()
            if finished then return end
            finished = true
            local selected = {}
            for _, info in ipairs(controls) do
                if info.kind == "checkbox" then
                    if info.control:GetChecked() then selected[#selected + 1] = info.data end
                else
                    local selectedText, selectedData = info.control:GetSelected()
                    selected[info.name] = selectedData ~= nil and selectedData or selectedText
                end
            end

            if callback then callback(selected) end
            if IsValid(frame) then frame:Remove() end
        end

        CreateRequestFooter(frame, "Cancel", "Submit", cancelRequest, submitRequest)
        local scroll = CreateRequestScroll(frame)
        for _, option in ipairs(options) do
            local optionName
            local optionData
            if istable(option) then
                optionName = option[1] or tostring(option[2] or "")
                optionData = option[2]
            else
                optionName = tostring(option)
                optionData = option
            end

            optionName = resolveClientRequestText(optionName, optionName)
            local card = CreateRequestCard(scroll, istable(optionData) and 70 or 60)
            local label = card:Add("DLabel")
            label:SetFont("LiliaFont.17")
            label:SetText(optionName)
            label:SetTextColor(getRequestPalette().textSecondary)
            label:SetContentAlignment(4)
            label:SetMouseInputEnabled(false)
            local control
            local kind
            if istable(optionData) then
                kind = "combo"
                control = card:Add("liaComboBox")
                control:SetTall(36)
                AddComboChoices(control, optionData)
            else
                kind = "checkbox"
                control = card:Add("liaCheckbox")
                control:SetChecked(false)
            end

            card.PerformLayout = function(_, w, h)
                local rightWidth = kind == "checkbox" and 60 or math.min(250, math.floor(w * 0.43))
                label:SetPos(14, 0)
                label:SetSize(math.max(w - rightWidth - 42, 80), h)
                if kind == "checkbox" then
                    control:SetSize(60, 22)
                    control:SetPos(w - 74, math.floor((h - 22) * 0.5))
                else
                    control:SetSize(rightWidth, 36)
                    control:SetPos(w - rightWidth - 12, math.floor((h - 36) * 0.5))
                end
            end

            controls[#controls + 1] = {
                name = optionName,
                data = optionData,
                control = control,
                kind = kind
            }
        end

        frame.OnRemove = function()
            if finished then return end
            finished = true
            if onCancel then onCancel() end
        end

        lia.gui.menuRequestOptions = frame
        return frame
    end

    lia.derma.requestDropdown = function(title, options, callback, defaultValue)
        if IsValid(lia.gui.menuRequestDropdown) then lia.gui.menuRequestDropdown:Remove() end
        options = istable(options) and options or {}
        local frame = vgui.Create("liaFrame")
        frame:SetSize(500, 280)
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "SELECTION REQUEST", resolveClientRequestText(title, "Select Option"), "Choose one option from the list.")
        local finished = false
        local selectedText
        local selectedData
        local function cancelRequest()
            if finished then return end
            finished = true
            if callback then callback(false) end
            if IsValid(frame) then frame:Remove() end
        end

        local function submitRequest()
            if finished then return end
            local text = selectedText
            local data = selectedData
            if not text then
                local first = resolveClientRequestOption(options[1])
                if istable(first) then
                    text, data = tostring(first[1]), first[2]
                elseif first ~= nil then
                    text = tostring(first)
                end
            end

            if not text then return end
            finished = true
            if callback then
                if data ~= nil then
                    callback(text, data)
                else
                    callback(text)
                end
            end

            if IsValid(frame) then frame:Remove() end
        end

        CreateRequestFooter(frame, "Cancel", "Select", cancelRequest, submitRequest)
        local body = frame:Add("DPanel")
        body:Dock(FILL)
        body:DockMargin(0, 12, 0, 0)
        body.Paint = function() end
        local card = CreateRequestCard(body, 92)
        card:Dock(TOP)
        local label = card:Add("DLabel")
        label:SetFont("LiliaFont.15")
        label:SetText("Select" or "Selection")
        label:SetTextColor(getRequestPalette().textMuted)
        local dropdown = card:Add("liaComboBox")
        AddComboChoices(dropdown, options, istable(defaultValue) and defaultValue[2] or defaultValue)
        local first = resolveClientRequestOption(options[1])
        if istable(first) then
            selectedText, selectedData = tostring(first[1]), first[2]
        elseif first ~= nil then
            selectedText = tostring(first)
        end

        if defaultValue ~= nil then
            if istable(defaultValue) then
                selectedText, selectedData = tostring(defaultValue[1]), defaultValue[2]
            else
                selectedText = tostring(defaultValue)
            end
        end

        dropdown.OnSelect = function(_, _, value, data)
            selectedText = value
            selectedData = data
        end

        card.PerformLayout = function(_, w)
            label:SetPos(14, 12)
            label:SetSize(w - 28, 18)
            dropdown:SetPos(14, 38)
            dropdown:SetSize(w - 28, 40)
        end

        frame.OnRemove = function()
            if finished then return end
            finished = true
            if callback then callback(false) end
        end

        lia.gui.menuRequestDropdown = frame
        return frame
    end

    lia.derma.requestString = function(title, description, callback, defaultValue, maxLength)
        if IsValid(lia.gui.menuRequestString) then lia.gui.menuRequestString:Remove() end
        local vendorPanel = lia.gui.vendor
        local vendorEditor = lia.gui.vendorEditor
        if IsValid(vendorPanel) then vendorPanel:SetVisible(false) end
        if IsValid(vendorEditor) then vendorEditor:SetVisible(false) end
        local frame = vgui.Create("liaFrame")
        frame:SetSize(560, 250)
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "INPUT REQUEST", resolveClientRequestText(title, "Enter Text"), resolveClientRequestText(description, "Enter value..."))
        local finished = false
        local entry
        local function restoreVendor()
            if IsValid(vendorPanel) then vendorPanel:SetVisible(true) end
            if IsValid(vendorEditor) then vendorEditor:SetVisible(true) end
        end

        local function cancelRequest()
            if finished then return end
            finished = true
            if callback then callback(false) end
            if IsValid(frame) then frame:Remove() end
        end

        local function submitRequest()
            if finished or not IsValid(entry) then return end
            finished = true
            if callback then callback(entry:GetValue()) end
            if IsValid(frame) then frame:Remove() end
        end

        CreateRequestFooter(frame, "Cancel", "Submit", cancelRequest, submitRequest)
        local body = frame:Add("DPanel")
        body:Dock(FILL)
        body:DockMargin(0, 8, 0, 0)
        body.Paint = function() end
        local card = CreateRequestCard(body, 72)
        local label = card:Add("DLabel")
        label:SetFont("LiliaFont.15")
        label:SetText("value" or "Value")
        label:SetTextColor(getRequestPalette().textMuted)
        entry = card:Add("liaEntry")
        entry:SetFont("LiliaFont.17")
        if defaultValue ~= nil then entry:SetValue(tostring(defaultValue)) end
        if maxLength then entry:SetMaxLength(maxLength) end
        entry.OnEnter = submitRequest
        card.PerformLayout = function(_, w)
            label:SetPos(14, 8)
            label:SetSize(w - 28, 18)
            entry:SetPos(14, 29)
            entry:SetSize(w - 28, 36)
        end

        frame.OnRemove = function()
            restoreVendor()
            if finished then return end
            finished = true
            if callback then callback(false) end
        end

        lia.gui.menuRequestString = frame
        return frame
    end

    lia.derma.requestArguments = function(title, argTypes, onSubmit, defaults)
        defaults = defaults or {}
        argTypes = istable(argTypes) and argTypes or {}
        local count = table.Count(argTypes)
        local frame = vgui.Create("liaFrame")
        frame:SetSize(640, math.Clamp(168 + count * 72, 300, math.floor(ScrH() * 0.72)))
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "ARGUMENT REQUEST", resolveClientRequestText(title, "Enter arguments..."), "Complete the required fields below.")
        local finished = false
        local controls = {}
        local ordered = {}
        if #argTypes > 0 and istable(argTypes[1]) then
            for _, info in ipairs(argTypes) do
                ordered[#ordered + 1] = {
                    name = info[1],
                    typeInfo = info[2]
                }
            end
        else
            for name, typeInfo in pairs(argTypes) do
                ordered[#ordered + 1] = {
                    name = name,
                    typeInfo = typeInfo
                }
            end

            table.sort(ordered, function(a, b) return tostring(a.name) < tostring(b.name) end)
        end

        local submitButton
        local function validate()
            if not IsValid(submitButton) then return end
            local valid = true
            for _, info in ipairs(controls) do
                if info.kind == "boolean" then continue end
                if info.kind == "combo" then
                    local text = select(1, info.control:GetSelected())
                    if not text or text == "" or text == "Select" or text == "Choose" then
                        valid = false
                        break
                    end
                else
                    local value = info.control:GetValue()
                    if value == nil or value == "" then
                        valid = false
                        break
                    end

                    if info.kind == "number" and tonumber(value) == nil then
                        valid = false
                        break
                    end
                end
            end

            submitButton:SetEnabled(valid)
            submitButton:SetMouseInputEnabled(valid)
            submitButton:SetAlpha(valid and 255 or 110)
        end

        local function cancelRequest()
            if finished then return end
            finished = true
            if isfunction(onSubmit) then onSubmit(false) end
            if IsValid(frame) then frame:Remove() end
        end

        local function submitRequest()
            if finished then return end
            local result = {}
            for _, info in ipairs(controls) do
                if info.kind == "boolean" then
                    result[info.name] = info.control:GetChecked()
                elseif info.kind == "combo" then
                    local text, data = info.control:GetSelected()
                    result[info.name] = data ~= nil and data or text
                else
                    local value = info.control:GetValue()
                    result[info.name] = info.kind == "number" and tonumber(value) or value
                end
            end

            finished = true
            if isfunction(onSubmit) then onSubmit(true, result) end
            if IsValid(frame) then frame:Remove() end
        end

        local _, submit = CreateRequestFooter(frame, "Cancel", "Submit", cancelRequest, submitRequest)
        submitButton = submit
        local scroll = CreateRequestScroll(frame)
        for _, item in ipairs(ordered) do
            local name = tostring(item.name or "")
            if name == "" then continue end
            local typeInfo = item.typeInfo
            local fieldType = typeInfo
            local dataTable
            local defaultValue
            if istable(typeInfo) then
                fieldType = typeInfo[1]
                dataTable = typeInfo[2]
                defaultValue = typeInfo[3]
            end

            fieldType = string.lower(tostring(fieldType or "string"))
            if defaultValue == nil and defaults[name] ~= nil then defaultValue = defaults[name] end
            local card = CreateRequestCard(scroll, 66)
            local label = card:Add("DLabel")
            label:SetFont("LiliaFont.17")
            label:SetText(name)
            label:SetTextColor(getRequestPalette().textSecondary)
            label:SetContentAlignment(4)
            local control
            local kind
            if fieldType == "boolean" then
                kind = "boolean"
                control = card:Add("liaCheckbox")
                control:SetChecked(defaultValue ~= nil and tobool(defaultValue) or false)
            elseif fieldType == "table" then
                kind = "combo"
                control = card:Add("liaComboBox")
                AddComboChoices(control, dataTable or {}, defaultValue)
            elseif fieldType == "player" then
                kind = "combo"
                control = card:Add("liaComboBox")
                local playerOptions = {}
                for _, client in player.Iterator() do
                    if IsValid(client) then playerOptions[#playerOptions + 1] = {client:Name(), client:SteamID()} end
                end

                AddComboChoices(control, playerOptions, defaultValue)
            else
                if fieldType == "int" or fieldType == "number" then
                    kind = "number"
                else
                    kind = "string"
                end

                control = card:Add("liaEntry")
                control:SetFont("LiliaFont.17")
                if kind == "number" and control.SetNumeric then control:SetNumeric(true) end
                if defaultValue ~= nil then control:SetValue(tostring(defaultValue)) end
            end

            card.PerformLayout = function(_, w, h)
                local controlWidth = kind == "boolean" and 60 or math.min(290, math.floor(w * 0.48))
                label:SetPos(14, 0)
                label:SetSize(math.max(w - controlWidth - 42, 80), h)
                if kind == "boolean" then
                    control:SetSize(60, 22)
                    control:SetPos(w - 74, math.floor((h - 22) * 0.5))
                else
                    control:SetSize(controlWidth, 36)
                    control:SetPos(w - controlWidth - 12, math.floor((h - 36) * 0.5))
                end
            end

            local info = {
                name = name,
                kind = kind,
                control = control
            }

            controls[#controls + 1] = info
            local oldChange = control.OnValueChange
            control.OnValueChange = function(...)
                if oldChange then oldChange(...) end
                validate()
            end

            local oldText = control.OnTextChanged
            control.OnTextChanged = function(...)
                if oldText then oldText(...) end
                validate()
            end

            local oldSelect = control.OnSelect
            control.OnSelect = function(...)
                if oldSelect then oldSelect(...) end
                validate()
            end

            local oldChangeGeneric = control.OnChange
            control.OnChange = function(...)
                if oldChangeGeneric then oldChangeGeneric(...) end
                validate()
            end
        end

        validate()
        frame.OnRemove = function()
            if finished then return end
            finished = true
            if isfunction(onSubmit) then onSubmit(false) end
        end
        return frame
    end

    lia.derma.requestBinaryQuestion = function(title, question, callback, yesText, noText)
        if IsValid(lia.gui.menuRequestBinary) then lia.gui.menuRequestBinary:Remove() end
        local frame = vgui.Create("liaFrame")
        frame:SetSize(500, 190)
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "CONFIRMATION", resolveClientRequestText(title, "Question"), resolveClientRequestText(question, "Are you sure?"))
        local finished = false
        local function finish(value)
            if finished then return end
            finished = true
            if callback then callback(value) end
            if IsValid(frame) then frame:Remove() end
        end

        CreateRequestFooter(frame, resolveClientRequestText(noText, "No"), resolveClientRequestText(yesText, "Yes"), function() finish(false) end, function() finish(true) end)
        frame.OnRemove = function()
            if finished then return end
            finished = true
            if callback then callback(false) end
        end

        lia.gui.menuRequestBinary = frame
        return frame
    end

    lia.derma.requestButtons = function(title, buttons, callback, description)
        if IsValid(lia.gui.menuRequestButtons) then lia.gui.menuRequestButtons:Remove() end
        buttons = istable(buttons) and buttons or {}
        local frame = vgui.Create("liaFrame")
        frame:SetSize(520, math.Clamp(158 + #buttons * 52, 260, math.floor(ScrH() * 0.68)))
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "ACTION REQUEST", resolveClientRequestText(title, "Select Option"), resolveClientRequestText(description, "Choose an action."))
        local finished = false
        local buttonPanels = {}
        local function closeRequest()
            if finished then return end
            finished = true
            if callback then callback(false) end
            if IsValid(frame) then frame:Remove() end
        end

        CreateRequestFooter(frame, "Close", nil, closeRequest, nil)
        local scroll = CreateRequestScroll(frame)
        for index, buttonInfo in ipairs(buttons) do
            local textValue
            local clickCallback
            local icon
            if istable(buttonInfo) then
                textValue = buttonInfo.text or buttonInfo[1] or tostring(buttonInfo)
                clickCallback = buttonInfo.callback or buttonInfo[2]
                icon = buttonInfo.icon or buttonInfo[3]
            else
                textValue = tostring(buttonInfo)
            end

            local buttonText = resolveClientRequestText(textValue, textValue)
            local button = CreateRequestButton(scroll, buttonText, "secondary", icon)
            button:Dock(TOP)
            button:SetTall(44)
            button:DockMargin(0, 0, 0, 8)
            button.DoClick = function()
                if finished then return end
                local shouldClose = true
                if isfunction(clickCallback) then
                    shouldClose = clickCallback() ~= false
                elseif callback then
                    shouldClose = callback(index, buttonText) ~= false
                end

                if shouldClose then
                    finished = true
                    if IsValid(frame) then frame:Remove() end
                end
            end

            buttonPanels[index] = button
        end

        frame.OnRemove = function()
            if finished then return end
            finished = true
            if callback then callback(false) end
        end

        lia.gui.menuRequestButtons = frame
        return frame, buttonPanels
    end

    lia.derma.requestPopupQuestion = function(question, buttons)
        if IsValid(lia.gui.menuRequestPopup) then lia.gui.menuRequestPopup:Remove() end
        buttons = istable(buttons) and buttons or {}
        local frame = vgui.Create("liaFrame")
        frame:SetSize(500, math.Clamp(120 + #buttons * 52, 210, math.floor(ScrH() * 0.62)))
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "QUESTION", resolveClientRequestText(question, "Are you sure?"), "Select one of the available responses.")
        local scroll = CreateRequestScroll(frame)
        for _, buttonInfo in ipairs(buttons) do
            local textValue
            local clickCallback
            if istable(buttonInfo) then
                textValue = buttonInfo[1] or buttonInfo.text or tostring(buttonInfo)
                clickCallback = buttonInfo[2] or buttonInfo.callback
            else
                textValue = tostring(buttonInfo)
            end

            local buttonText = resolveClientRequestText(textValue, textValue)
            local button = CreateRequestButton(scroll, buttonText, "secondary")
            button:Dock(TOP)
            button:SetTall(44)
            button:DockMargin(0, 0, 0, 8)
            button.DoClick = function()
                if isfunction(clickCallback) then clickCallback() end
                if IsValid(frame) then frame:Remove() end
            end
        end

        lia.gui.menuRequestPopup = frame
        return frame
    end

    net.Receive("liaOptionsRequest", function()
        local id = net.ReadUInt(32)
        local title = net.ReadString()
        local subTitle = net.ReadString()
        local options = net.ReadTable()
        local limit = net.ReadUInt(32)
        lia.derma.requestOptions(title, subTitle, options, function(selectedOptions)
            if limit > 0 and #selectedOptions > limit then
                local limited = {}
                for i = 1, limit do
                    if selectedOptions[i] then table.insert(limited, selectedOptions[i]) end
                end

                selectedOptions = limited
            end

            net.Start("liaOptionsRequest")
            net.WriteUInt(id, 32)
            net.WriteTable(selectedOptions)
            net.SendToServer()
        end, function()
            net.Start("liaOptionsRequestCancel")
            net.WriteUInt(id, 32)
            net.SendToServer()
        end)
    end)

    net.Receive("liaProvideInteractOptions", function()
        local kind = net.ReadString()
        local count = net.ReadUInt(16)
        local temp = {}
        for _ = 1, count do
            local name = net.ReadString()
            local typ = net.ReadString()
            local serverOnly = net.ReadBool()
            local range = net.ReadUInt(16)
            local category = net.ReadString()
            local hasTarget = net.ReadBool()
            local target = hasTarget and net.ReadString() or nil
            local hasTime = net.ReadBool()
            local timeToComplete = hasTime and net.ReadFloat() or nil
            local hasActionText = net.ReadBool()
            local actionText = hasActionText and net.ReadString() or nil
            local hasTargetActionText = net.ReadBool()
            local targetActionText = hasTargetActionText and net.ReadString() or nil
            temp[name] = {
                type = typ,
                serverOnly = serverOnly,
                range = range,
                category = category,
                target = target,
                timeToComplete = timeToComplete,
                actionText = actionText,
                targetActionText = targetActionText
            }
        end

        local optionsMap = {}
        local optionCount = 0
        for name, opt in pairs(temp) do
            optionsMap[name] = opt
            optionCount = optionCount + 1
        end

        local isInteraction = kind == "interaction"
        if optionCount == 0 then return end
        lia.playerinteract.openMenu(optionsMap, isInteraction, isInteraction and "Player Interactions" or "Actions Menu", isInteraction and lia.keybind.get("Interaction Menu", KEY_TAB) or lia.keybind.get("Personal Actions", KEY_G), "liaRunInteraction", true)
    end)

    net.Receive("liaRequestDropdown", function()
        local id = net.ReadUInt(32)
        local title = net.ReadString()
        net.ReadString()
        local options = net.ReadTable()
        lia.derma.requestDropdown(title, options, function(selectedText, selectedData)
            if selectedText == false then
                net.Start("liaRequestDropdownCancel")
                net.WriteUInt(id, 32)
                net.SendToServer()
            else
                net.Start("liaRequestDropdown")
                net.WriteUInt(id, 32)
                net.WriteString(selectedText)
                if selectedData ~= nil then
                    net.WriteString(tostring(selectedData))
                else
                    net.WriteString("")
                end

                net.SendToServer()
            end
        end)
    end)

    net.Receive("liaArgumentsRequest", function()
        local id = net.ReadUInt(32)
        local title = net.ReadString()
        local fields = net.ReadTable()
        lia.derma.requestArguments(title, fields, function(success, data)
            if success then
                net.Start("liaArgumentsRequest")
                net.WriteUInt(id, 32)
                net.WriteTable(data)
                net.SendToServer()
            else
                net.Start("liaArgumentsRequestCancel")
                net.WriteUInt(id, 32)
                net.SendToServer()
            end
        end)
    end)

    net.Receive("liaStringRequest", function()
        local id = net.ReadUInt(32)
        local title = net.ReadString()
        local subTitle = net.ReadString()
        local default = net.ReadString()
        lia.derma.requestString(title, subTitle, function(value)
            if value == false then
                net.Start("liaStringRequestCancel")
                net.WriteUInt(id, 32)
                net.SendToServer()
            else
                net.Start("liaStringRequest")
                net.WriteUInt(id, 32)
                net.WriteString(value)
                net.SendToServer()
            end
        end, default)
    end)
end
