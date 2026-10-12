local PANEL = {}
local function mmColor(src, fallback, alpha)
    local c = IsColor(src) and src or fallback
    return Color(c.r, c.g, c.b, alpha or c.a or 255)
end

local function mmTheme()
    return lia.color and lia.color.theme or {}
end

local function mmAccent(alpha)
    local theme = mmTheme()
    local src = theme.maincolor or theme.accent or theme.theme or lia.config.get("Color") or Color(76, 164, 224)
    return mmColor(src, Color(76, 164, 224), alpha)
end

local function mmText(alpha)
    local theme = mmTheme()
    local src = theme.text or theme.foreground or Color(230, 239, 239)
    return mmColor(src, Color(230, 239, 239), alpha)
end

local function mmBg(alpha)
    local theme = mmTheme()
    local src = theme.background or theme.panel or theme.window or Color(7, 14, 23)
    return mmColor(src, Color(7, 14, 23), alpha)
end

local function mmMix(from, to, frac, alpha)
    from = IsColor(from) and from or Color(7, 14, 23)
    to = IsColor(to) and to or Color(230, 239, 239)
    frac = math.Clamp(tonumber(frac) or 0, 0, 1)
    return Color(math.Round(Lerp(frac, from.r, to.r)), math.Round(Lerp(frac, from.g, to.g)), math.Round(Lerp(frac, from.b, to.b)), alpha or math.Round(Lerp(frac, from.a or 255, to.a or 255)))
end

local function mmSurface(frac, alpha)
    return mmMix(mmBg(255), mmText(255), frac or 0.04, alpha)
end

local function mmMuted(alpha)
    return mmMix(mmText(255), mmBg(255), 0.40, alpha or 190)
end

local function mmNegative(alpha)
    local theme = mmTheme()
    local src = theme.negative or Color(205, 74, 74)
    return mmColor(src, Color(205, 74, 74), alpha)
end

local function mmDrawPanel(x, y, w, h, radius, bg, outline)
    if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
        lia.derma.rect(x, y, w, h):Rad(radius or 6):Color(bg):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius or 6):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
    else
        draw.RoundedBox(radius or 6, x, y, w, h, bg)
        if outline then
            surface.SetDrawColor(outline)
            surface.DrawOutlinedRect(x, y, w, h, 1)
        end
    end
end

local function mmPaintContainer(w, h)
    local accent = mmAccent()
    mmDrawPanel(0, 0, w, h, 5, mmSurface(0.02, 236), Color(accent.r, accent.g, accent.b, 70))
end

local function mmPaintBlock(w, h, active)
    local accent = mmAccent()
    local frac = active and 0.065 or 0.05
    local bg = mmSurface(frac, active and 242 or 238)
    local out = Color(accent.r, accent.g, accent.b, active and 145 or 52)
    mmDrawPanel(0, 0, w, h, 7, bg, out)
end

local function mmStyleScrollBar(scroll)
    if not IsValid(scroll) or not IsValid(scroll.VBar) then return end
    local bar = scroll.VBar
    bar:SetWide(8)
    bar.Paint = function() end
    if IsValid(bar.btnUp) then bar.btnUp.Paint = function() end end
    if IsValid(bar.btnDown) then bar.btnDown.Paint = function() end end
    if IsValid(bar.btnGrip) then bar.btnGrip.Paint = function(self, w, h) draw.RoundedBox(4, 1, 0, math.max(w - 2, 1), h, self:IsHovered() and mmAccent(150) or mmMuted(90)) end end
end

local function mmEase(t)
    t = math.Clamp(t, 0, 1)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

local function mmTweenPanel(panel, targetX, targetY, targetAlpha, duration, delay, onComplete)
    if not IsValid(panel) then return end
    local fromX, fromY = panel:GetPos()
    local fromAlpha = panel:GetAlpha()
    local startTime = RealTime() + (delay or 0)
    duration = math.max(duration or 0.28, 0.01)
    panel.Think = function(self)
        local t = (RealTime() - startTime) / duration
        if t < 0 then return end
        local fraction = mmEase(t)
        self:SetPos(math.Round(Lerp(fraction, fromX, targetX)), math.Round(Lerp(fraction, fromY, targetY)))
        self:SetAlpha(math.Round(Lerp(fraction, fromAlpha, targetAlpha)))
        if t >= 1 then
            self.Think = nil
            if isfunction(onComplete) then onComplete() end
        end
    end
end

local function mmAnimateIn(panel, x, y, dx, dy, duration, delay)
    if not IsValid(panel) then return end
    panel:SetPos(x + (dx or 0), y + (dy or 0))
    panel:SetAlpha(0)
    mmTweenPanel(panel, x, y, 255, duration or 0.32, delay or 0)
end

function PANEL:Init()
    if hook.Run("IsCharacterCreationOverridden") == true then
        self:SetVisible(false)
        timer.Simple(0, function() if IsValid(self) then self:Remove() end end)
        return
    end

    local client = LocalPlayer()
    local clientChar = client.getChar and client:getChar()
    self.disableClientModel = false
    self.noBlur = true
    self.isLoadMode = false
    if IsValid(lia.gui.loading) then lia.gui.loading:Remove() end
    if IsValid(lia.gui.character) then lia.gui.character:Remove() end
    lia.gui.character = self
    hook.Run("CharMenuOpened", self)
    if not render.oldDrawBeam then
        render.oldDrawBeam = render.DrawBeam
        render.DrawBeam = function(startPos, endPos, width, textureStart, textureEnd, color)
            if IsValid(lia.gui.character) then return end
            return render.oldDrawBeam(startPos, endPos, width, textureStart, textureEnd, color)
        end
    end

    hook.Add("DrawPhysgunBeam", "liaMainMenuPreDrawPhysgunBeam", function() return IsValid(lia.gui.character) end)
    hook.Remove("RenderScreenspaceEffects", "liaCharMenuDarken")
    self:Dock(FILL)
    self:MakePopup()
    self:SetAlpha(255)
    self:Stop()
    self.charListUpdateHook = "liaCharacterCharListUpdate" .. tostring(self)
    hook.Add("CharListUpdated", self.charListUpdateHook, function(oldCharList, newCharList)
        if not IsValid(self) then return end
        self:onCharListUpdated(oldCharList, newCharList)
    end)

    self.adminPrivilegesUpdateHook = "liaCharacterAdminPrivilegesUpdate" .. tostring(self)
    hook.Add("AdminPrivilegesUpdated", self.adminPrivilegesUpdateHook, function()
        if not IsValid(self) or not self.inMainMenu or self.panelsTransitioning then return end
        self:createStartButton()
    end)

    self.tabs = self:Add("DPanel")
    self.tabs:Dock(TOP)
    self.tabs:DockMargin(64, 32, 64, 0)
    self.tabs:SetTall(48)
    self.tabs:SetPaintBackground(false)
    self.content = self:Add("DPanel")
    self.content:Dock(FILL)
    self.content:DockMargin(64, 0, 64, 64)
    self.content:SetPaintBackground(false)
    self:StartBGMusic()
    self:createTitle()
    self:loadBackground()
    if clientChar and lia.characters and #lia.characters > 0 then
        for i, charID in ipairs(lia.characters) do
            local charObj = isnumber(charID) and lia.char.getCharacter(charID) or charID
            if charObj and charObj.getID and charObj:getID() == clientChar:getID() then
                self.currentIndex = i
                break
            end
        end

        self.currentIndex = self.currentIndex or 1
    end

    self:createStartButton()
end

function PANEL:setInWorldPreviewEnabled(enabled)
    enabled = enabled == true
    if enabled == self.inWorldPreview then return end
    self.inWorldPreview = enabled
    if enabled then
        self:hideExternalEntities()
        hook.Add("PrePlayerDraw", "liaMainMenuPrePlayerDraw", function() return true end)
        local calcViewHook = "liaMainMenuCalcView"
        hook.Add("CalcView", calcViewHook, function(_, _, _, fov)
            if not IsValid(self) or not self.inWorldPreview then return end
            local ent = self.modelEntity
            if not IsValid(ent) then return end
            local center = ent:GetPos() + Vector(0, 0, 60)
            local modelAngles = self.mainMenuModelAngles or ent:GetAngles()
            local forward = modelAngles:Forward()
            local desired = center + forward * 70
            if not self.currentCamPos then
                self.currentCamPos = desired
            else
                self.currentCamPos = LerpVector(FrameTime() * 5, self.currentCamPos, desired)
            end

            local target = center
            if self.inWorldPreview and not self.isLoadMode then target = target - modelAngles:Right() * 40 end
            return {
                origin = self.currentCamPos,
                angles = (target - self.currentCamPos):Angle(),
                fov = fov,
                drawviewer = true
            }
        end)
    else
        self:restoreExternalEntities()
        self.currentCamPos = nil
        hook.Remove("CalcView", "liaMainMenuCalcView")
        hook.Remove("PrePlayerDraw", "liaMainMenuPrePlayerDraw")
        hook.Remove("PostDrawOpaqueRenderables", "liaMainMenuPostDrawOpaqueRenderables")
        if self.mainMenuRenderHookID then
            hook.Remove("PostDrawOpaqueRenderables", self.mainMenuRenderHookID)
            self.mainMenuRenderHookID = nil
        end

        if IsValid(self.modelEntity) then self.modelEntity:Remove() end
    end
end

function PANEL:updateCreationModelEntity(context)
    if not istable(context) then return end
    local factionIndex = context.faction
    local faction = factionIndex and lia.faction.indices[factionIndex] or nil
    if not faction then return end
    local class = lia.faction.getCharacterCreationClass(faction, context.class)
    local info = lia.faction.getCharacterCreationModelInfo(faction, class, context.model)
    if not info then return end
    local parsed = lia.faction.getModelData(context.model, info)
    local mdl, skin, groups = info, 0, {}
    if parsed then mdl, skin, groups = parsed.model, parsed.skin, parsed.bodygroups end
    if IsValid(self.modelEntity) then self.modelEntity:Remove() end
    self.modelEntity = ClientsideModel(mdl or "models/error.mdl", RENDERGROUP_OPAQUE)
    if not IsValid(self.modelEntity) then return end
    self.modelEntity:SetSkin(lia.faction.normalizeSkinValue(context.skin, skin))
    local finalGroups = istable(context.groups) and context.groups or istable(groups) and groups
    if finalGroups then lia.util.applyBodygroups(self.modelEntity, finalGroups) end
    hook.Run("SetupPlayerModel", self.modelEntity)
    local pos, ang
    if faction.mainMenuPosition then
        local menuPos = faction.mainMenuPosition
        local currentMap = game.GetMap()
        if istable(menuPos) and menuPos[currentMap] then
            local mapPos = menuPos[currentMap]
            if istable(mapPos) then
                pos, ang = mapPos.position, mapPos.angles
            elseif isvector(mapPos) then
                pos, ang = mapPos, Angle(0, 0, 0)
            end
        elseif istable(menuPos) then
            pos, ang = menuPos.position, menuPos.angles
        elseif isvector(menuPos) then
            pos, ang = menuPos, Angle(0, 0, 0)
        end
    end

    if not pos then
        local client = LocalPlayer()
        local hookResult = hook.Run("GetMainMenuPosition", IsValid(client) and client.getChar and client:getChar() or nil)
        if hookResult then
            if istable(hookResult) then
                pos, ang = hookResult.pos, hookResult.ang
            elseif isvector(hookResult) then
                pos = hookResult
                ang = Angle(0, 0, 0)
            end
        end
    end

    if not pos or not ang then
        local spawns = ents.FindByClass("info_player_start")
        if #spawns > 0 then
            pos = spawns[1]:GetPos()
            ang = spawns[1]:GetAngles()
        else
            pos = Vector()
            ang = Angle()
        end
    end

    self.mainMenuModelAngles = ang
    pos = self:getClosestGroundPosition(pos)
    self.modelEntity:SetPos(pos)
    self.modelEntity:SetAngles(ang)
    self.currentCamPos = nil
    local seqID = self.modelEntity:LookupSequence("idle_all_01")
    if seqID > 0 then
        self.modelEntity:ResetSequence(seqID)
        self.modelEntity:SetCycle(0)
    end

    hook.Run("ModifyCharacterModel", self.modelEntity, context)
    hook.Remove("PostDrawOpaqueRenderables", "liaMainMenuPostDrawOpaqueRenderables")
    if self.mainMenuRenderHookID then
        hook.Remove("PostDrawOpaqueRenderables", self.mainMenuRenderHookID)
        self.mainMenuRenderHookID = nil
    end

    self.mainMenuRenderHookID = "liaMainMenuPostDrawOpaqueRenderables" .. tostring(self)
    hook.Add("PostDrawOpaqueRenderables", self.mainMenuRenderHookID, function()
        if not IsValid(self) or not self.inWorldPreview or not IsValid(self.modelEntity) then return end
        self.modelEntity:FrameAdvance()
        render.SuppressEngineLighting(true)
        local ok, err = pcall(function()
            render.ResetModelLighting(1, 1, 1)
            for i = 0, 6 do
                render.SetModelLighting(i, 1, 1, 1)
            end

            self.modelEntity:DrawModel()
        end)

        render.SuppressEngineLighting(false)
        render.ResetModelLighting(1, 1, 1)
        for i = 0, 6 do
            render.SetModelLighting(i, 0, 0, 0)
        end

        if not ok then ErrorNoHalt(err .. "\n") end
    end)
end

function PANEL:createWelcomeSidePanel()
    local client = LocalPlayer()
    if not IsValid(client) then return end
    if IsValid(self.welcomeSide) then self.welcomeSide:Remove() end
    local function changelogText()
        local data = SCHEMA and (SCHEMA.changelog or SCHEMA.Changelog)
        if isstring(data) then
            for line in data:gmatch("[^\r\n]+") do
                local entry = string.Trim(line)
                if entry ~= "" then return "LATEST CHANGELOG", entry end
            end
        elseif istable(data) then
            local entries = data.entries or data.releases or data.versions or data.items or data.list or data
            if istable(entries) then
                local key, entry
                if #entries > 0 then
                    entry = entries[1]
                else
                    for k, v in pairs(entries) do
                        if not key or tostring(k) > tostring(key) then key, entry = k, v end
                    end
                end

                if isstring(entry) then return key and "CHANGELOG / " .. tostring(key) or "LATEST CHANGELOG", entry end
                if istable(entry) then
                    local heading = entry.version or entry.title or key
                    local values = entry.changes or entry.notes or entry.text or entry.message or entry.description or entry.entries or entry.items
                    if istable(values) then
                        values = values[1]
                        if istable(values) then values = values.text or values.message or values.description or values.change end
                    end

                    if isstring(values) and string.Trim(values) ~= "" then return heading and "CHANGELOG / " .. tostring(heading) or "LATEST CHANGELOG", values end
                end
            end
        end
        return nil
    end

    local changeTitle, changeText = changelogText()
    local rightW = math.Clamp(ScrW() * 0.23, 360, 520)
    local rightH = math.min(changeText and 344 or 202, ScrH() - 48)
    local rightX = ScrW() - rightW - math.max(32, ScrW() * 0.04)
    local mainMenuHeight = math.Clamp(ScrH() * 0.58, 440, 640)
    local rightY = ScrH() * 0.5 - mainMenuHeight * 0.5
    local pad = 18
    local innerW = rightW - pad * 2
    self.welcomeSide = self:Add("DPanel")
    local panel = self.welcomeSide
    panel:SetSize(rightW, rightH)
    panel.Paint = function(_, w, h) mmPaintContainer(w, h) end
    mmAnimateIn(panel, rightX, rightY, 18, 0, 0.36, 0.06)
    local function addLabel(text, font, color, x, y, width, height)
        local label = panel:Add("DLabel")
        label:SetPos(x, y)
        label:SetSize(width, height)
        label:SetFont(font)
        label:SetTextColor(color)
        label:SetText(text)
        return label
    end

    local function fitText(value, font, width)
        local str = tostring(value or "")
        surface.SetFont(font)
        if surface.GetTextSize(str) <= width then return str end
        while #str > 0 and surface.GetTextSize(str .. "...") > width do
            str = string.sub(str, 1, -2)
        end
        return str .. "..."
    end

    local function formatPlaytime(value)
        local seconds = math.max(tonumber(value) or 0, 0)
        local days = math.floor(seconds / 86400)
        local hours = math.floor(seconds % 86400 / 3600)
        local minutes = math.floor(seconds % 3600 / 60)
        if days > 0 then return string.format("%dd %dh %dm", days, hours, minutes) end
        if hours > 0 then return string.format("%dh %dm", hours, minutes) end
        return string.format("%dm", minutes)
    end

    local function characterCount()
        return lia.characters and #lia.characters or 0
    end

    local function characterLimit()
        local count = tonumber(hook.Run("GetMaxPlayerChar", client)) or tonumber(lia.config.get("MaxCharacters", 5)) or 5
        return math.max(0, math.floor(count))
    end

    local function drawDivider(y)
        local line = panel:Add("DPanel")
        line:SetPos(pad, y)
        line:SetSize(innerW, 1)
        line.Paint = function(_, w, h)
            local accent = mmAccent(70)
            surface.SetDrawColor(accent)
            surface.DrawRect(0, 0, w, h)
        end
    end

    addLabel(characterCount() == 0 and "WELCOME" or "WELCOME BACK", "LiliaFont.30", mmText(), pad, 19, innerW, 38)
    local greeting = addLabel("", "LiliaFont.17", mmMuted(), pad, 58, innerW, 24)
    drawDivider(91)
    local cardW = math.floor((innerW - 10) * 0.5)
    local function addInfoCard(x, y, heading)
        local card = panel:Add("DPanel")
        card:SetPos(x, y)
        card:SetSize(cardW, 72)
        card.Paint = function(_, w, h) mmPaintBlock(w, h, false) end
        addLabel(heading, "LiliaFont.14", mmMuted(), x + 12, y + 9, cardW - 24, 20)
        return addLabel("", "LiliaFont.22", mmText(), x + 12, y + 32, cardW - 24, 29)
    end

    local playtime = addInfoCard(pad, 110, "TOTAL PLAYTIME")
    local characters = addInfoCard(pad + cardW + 10, 110, "CHARACTERS")
    if changeText and rightH >= 296 then
        local changeY = 203
        addLabel(fitText(changeTitle, "LiliaFont.14", innerW), "LiliaFont.14", mmAccent(), pad, changeY, innerW, 21)
        local changeCard = panel:Add("DPanel")
        changeCard:SetPos(pad, changeY + 26)
        changeCard:SetSize(innerW, math.min(92, math.max(40, rightH - changeY - 48)))
        changeCard.Paint = function(_, w, h) mmPaintBlock(w, h, false) end
        local changeLabel = changeCard:Add("DLabel")
        changeLabel:SetPos(12, 9)
        changeLabel:SetSize(innerW - 24, changeCard:GetTall() - 17)
        changeLabel:SetFont("LiliaFont.16")
        changeLabel:SetTextColor(mmText())
        changeLabel:SetWrap(true)
        changeLabel:SetText(string.Trim(changeText))
    end

    local previousName, previousCount, previousLimit, previousMinutes
    greeting.Think = function()
        if not IsValid(client) then return end
        local name = client.steamName and client:steamName() or client:SteamName() or client:Nick() or "Player"
        local count, limit = characterCount(), characterLimit()
        if name ~= previousName or count ~= previousCount or limit ~= previousLimit then
            previousName, previousCount, previousLimit = name, count, limit
            greeting:SetText(fitText((count == 0 and "Welcome, " or "Good to see you again, ") .. name .. ".", "LiliaFont.17", innerW))
            characters:SetText(string.format("%d / %d", count, limit))
        end

        local minutes = math.floor((tonumber(client.getPlayTime and client:getPlayTime() or 0) or 0) / 60)
        if minutes ~= previousMinutes then
            previousMinutes = minutes
            playtime:SetText(formatPlaytime(client.getPlayTime and client:getPlayTime() or 0))
        end
    end
end

function PANEL:getPreviewPlacement(character)
    local pos, ang
    local result = {hook.Run("GetMainMenuPosition", character)}
    if isvector(result[1]) then
        pos = result[1]
        if isangle(result[2]) then ang = result[2] end
    elseif istable(result[1]) then
        pos = result[1].pos or result[1].position
        ang = result[1].ang or result[1].angles
    end

    if not isvector(pos) then
        local spawns = ents.FindByClass("info_player_start")
        if #spawns > 0 then
            pos = spawns[1]:GetPos()
            ang = spawns[1]:GetAngles()
        else
            pos = Vector()
            ang = Angle()
        end
    end

    if not isangle(ang) then ang = Angle() end
    return self:getClosestGroundPosition(pos), ang
end

function PANEL:getLoadEntryView(fov)
    local state = self.loadEntryCamera
    if not state then return end
    local progress = math.Clamp((RealTime() - state.startTime) / state.duration, 0, 1)
    local fraction = mmEase(progress)
    local origin = LerpVector(fraction, state.fromPos, state.toPos)
    local angles = LerpAngle(fraction, state.fromAngles, state.toAngles)
    self.currentCamPos = origin
    if progress >= 1 then
        self.loadEntryCamera = nil
        self.currentCamPos = state.toPos
    end
    return {
        origin = origin,
        angles = angles,
        fov = fov,
        drawviewer = true
    }
end

function PANEL:beginLoadCameraTransition()
    self.loadEntryCamera = nil
    local characterIDs = {}
    for _, characterID in pairs(lia.characters or {}) do
        local character = lia.char.getCharacter(characterID)
        if character and character:getFaction() ~= FACTION_STAFF then characterIDs[#characterIDs + 1] = characterID end
    end

    if #characterIDs == 0 then return end
    local index = math.Clamp(self.currentIndex or 1, 1, #characterIDs)
    local character = lia.char.getCharacter(characterIDs[index])
    if not character then return end
    local pos, ang = self:getPreviewPlacement(character)
    local center = pos + Vector(0, 0, 60)
    local target = center + ang:Forward() * 70
    local fromPos = EyePos()
    local fromAngles = EyeAngles()
    if not isvector(fromPos) or not isangle(fromAngles) then return end
    self.loadEntryCamera = {
        fromPos = fromPos,
        fromAngles = fromAngles,
        toPos = target,
        toAngles = (center - target):Angle(),
        startTime = RealTime(),
        duration = 1.05
    }

    hook.Add("CalcView", "liaMainMenuCalcView", function(_, _, _, fov)
        if not IsValid(self) then return end
        return self:getLoadEntryView(fov)
    end)
end

function PANEL:transitionPanelsOut(panels, callback)
    if self.panelsTransitioning then return end
    self.panelsTransitioning = true
    local transitioning = {}
    for _, info in ipairs(panels or {}) do
        if IsValid(info.panel) then transitioning[#transitioning + 1] = info end
    end

    if #transitioning == 0 then
        self.panelsTransitioning = false
        if isfunction(callback) then callback() end
        return
    end

    local remaining = #transitioning
    for _, info in ipairs(transitioning) do
        local panel = info.panel
        local x, y = panel:GetPos()
        panel:SetMouseInputEnabled(false)
        mmTweenPanel(panel, x + (info.dx or 0), y + (info.dy or 0), 0, 0.44, 0, function()
            if IsValid(panel) then panel:Remove() end
            remaining = remaining - 1
            if remaining <= 0 and IsValid(self) then
                self.panelsTransitioning = false
                if isfunction(callback) then callback() end
            end
        end)
    end
end

function PANEL:openCharacterSelectionWithTransition()
    if self.panelsTransitioning then return end
    self:clickSound()
    self:beginLoadCameraTransition()
    self:transitionPanelsOut({
        {
            panel = self.menuPanel,
            dx = -22
        },
        {
            panel = self.welcomeSide,
            dx = 22
        }
    }, function() if IsValid(self) then self:createCharacterSelection() end end)
end

function PANEL:animateCreationInterface(creator)
    if IsValid(creator) and IsValid(creator.inputWindow) then
        creator:InvalidateLayout(true)
        if isvector(creator.cameraToOrigin) and isvector(creator.cameraToLook) then
            local origin = EyePos()
            local angles = EyeAngles()
            if isvector(origin) and isangle(angles) then
                creator.cameraFromOrigin = origin
                creator.cameraFromLook = origin + angles:Forward() * 150
                creator.cameraCurrentOrigin = creator.cameraFromOrigin
                creator.cameraCurrentLook = creator.cameraFromLook
                creator.cameraFromFOV = creator.cameraToFOV
                creator.cameraCurrentFOV = creator.cameraToFOV
                creator.cameraStartTime = CurTime()
                creator.cameraDuration = 0.95
            end
        end

        local window = creator.inputWindow
        window:SetAlpha(0)
        window:AlphaTo(255, 0.58, 0.01)
        if IsValid(creator.paper) then
            local paper = creator.paper
            local x, y = paper:GetPos()
            paper:SetPos(x + 42, y)
            paper:SetAlpha(0)
            mmTweenPanel(paper, x, y, 255, 0.62, 0.04)
        end
        return
    end

    if not IsValid(self.content) then return end
    local content = self.content
    local x, y = content:GetPos()
    content:SetAlpha(0)
    mmTweenPanel(content, x, y, 255, 0.58, 0.03)
end

function PANEL:openCharacterCreationWithTransition()
    if self.panelsTransitioning then return end
    self:clickSound()
    self.loadEntryCamera = nil
    self:transitionPanelsOut({
        {
            panel = self.menuPanel,
            dx = -22
        },
        {
            panel = self.selectionPanel,
            dx = 22
        },
        {
            panel = self.welcomeSide,
            dx = 22
        },
        {
            panel = self.leftArrow,
            dx = -12
        },
        {
            panel = self.rightArrow,
            dx = 12
        }
    }, function()
        if not IsValid(self) then return end
        self.isLoadMode = false
        self:showContent(true)
        self.tabs:SetVisible(true)
        self.content:SetVisible(true)
        local creator = self:createCharacterCreation()
        if not IsValid(creator) and IsValid(lia.gui.schemaCharacterCreator) then creator = lia.gui.schemaCharacterCreator end
        self:animateCreationInterface(creator)
    end)
end

function PANEL:createTitle()
    if self.tabs then self.tabs:DockMargin(64, 32, 64, 0) end
end

function PANEL:createChangelogDisplay()
    if not SCHEMA or not (SCHEMA.changelog or SCHEMA.Changelog) then return end
    self.changelogPanel = self:Add("DPanel")
    self.changelogPanel:SetPos(32, 32)
    self.changelogPanel:SetSize(ScrW() * 0.25, ScrH() * 0.4)
    self.changelogPanel:SetAlpha(0)
    self.changelogPanel:AlphaTo(255, 0.4, 0)
    local accentColor = lia.color.theme.theme
    self.changelogPanel.Paint = function(s, w, h)
        local bgColor = Color(25, 28, 35, 250)
        lia.derma.rect(0, 0, w, h):Rad(12):Color(Color(0, 0, 0, 180)):Shadow(15, 20):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(0, 0, w, h):Rad(12):Color(bgColor):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(0, 0, w, 5):Radii(12, 12, 0, 0):Color(accentColor):Draw()
    end

    local padding = 20
    local contentY = padding + 10
    local titleLabel = self.changelogPanel:Add("DLabel")
    titleLabel:SetFont("LiliaFont.30")
    titleLabel:SetTextColor(Color(255, 255, 255))
    titleLabel:SetText("Changelog")
    titleLabel:SetContentAlignment(5)
    titleLabel:SetWide(self.changelogPanel:GetWide() - padding * 2)
    titleLabel:SetPos(padding, contentY)
    titleLabel:SetTall(40)
    titleLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    contentY = contentY + 50
    local scroll = self.changelogPanel:Add("liaScrollPanel")
    scroll:SetPos(padding, contentY)
    scroll:SetSize(self.changelogPanel:GetWide() - padding * 2, self.changelogPanel:GetTall() - contentY - padding)
    scroll:InvalidateLayout(true)
    local function addSpacer(height)
        local spacer = scroll:Add("DPanel")
        spacer:SetTall(height or 15)
        spacer:Dock(TOP)
        spacer.Paint = function() end
    end

    local function addTextLabel(text, font, color, indent, marginBottom)
        local label = scroll:Add("DLabel")
        label:SetFont(font)
        label:SetTextColor(color)
        label:SetText(tostring(text or ""))
        label:SetWrap(true)
        label:SetAutoStretchVertical(true)
        label:SetWide(scroll:GetWide() - padding * 2)
        label:Dock(TOP)
        label:DockMargin(indent or 0, 0, 0, marginBottom or 8)
        return label
    end

    local function addVersionLabel(text)
        local versionLabel = scroll:Add("DLabel")
        versionLabel:SetFont("LiliaFont.22")
        versionLabel:SetTextColor(accentColor)
        versionLabel:SetText(tostring(text or ""))
        versionLabel:SetContentAlignment(5)
        versionLabel:SetWide(scroll:GetWide() - padding * 2)
        versionLabel:SetTall(30)
        versionLabel:Dock(TOP)
        versionLabel:DockMargin(0, 0, 0, 5)
        versionLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
        return versionLabel
    end

    local function addDateLabel(text)
        local dateLabel = scroll:Add("DLabel")
        dateLabel:SetFont("LiliaFont.16")
        dateLabel:SetTextColor(Color(180, 180, 180))
        dateLabel:SetText(tostring(text or ""))
        dateLabel:SetContentAlignment(5)
        dateLabel:SetWide(scroll:GetWide() - padding * 2)
        dateLabel:SetTall(20)
        dateLabel:Dock(TOP)
        dateLabel:DockMargin(0, 0, 0, 10)
        return dateLabel
    end

    local function extractChangeText(change)
        if isstring(change) then return change end
        if not istable(change) then return tostring(change or "") end
        local text = change.text or change.message or change.description or change.title or change.label or change.name or change.change or change[1]
        if not text then return "" end
        local category = change.type or change.category or change.tag or change.kind
        if isstring(category) and category ~= "" then text = "[" .. category .. "] " .. tostring(text) end
        return tostring(text)
    end

    local function renderChanges(changes)
        if isstring(changes) then
            addTextLabel(changes, "LiliaFont.18", Color(220, 220, 220), 0, 8)
            return
        end

        if not istable(changes) then return end
        for _, change in ipairs(changes) do
            local text = extractChangeText(change)
            if text ~= "" then addTextLabel("• " .. text, "LiliaFont.18", Color(220, 220, 220), 10, 8) end
        end
    end

    local function versionSortValue(version)
        local parts = {}
        for piece in tostring(version):gmatch("(%d+)") do
            parts[#parts + 1] = tonumber(piece) or 0
        end
        return parts
    end

    local function versionSorter(a, b)
        local aParts = versionSortValue(a)
        local bParts = versionSortValue(b)
        local count = math.max(#aParts, #bParts)
        for i = 1, count do
            local aPart = aParts[i] or 0
            local bPart = bParts[i] or 0
            if aPart ~= bPart then return aPart > bPart end
        end
        return tostring(a) > tostring(b)
    end

    local changelogContent = SCHEMA.changelog or SCHEMA.Changelog
    if istable(changelogContent) then changelogContent = changelogContent.entries or changelogContent.releases or changelogContent.versions or changelogContent.items or changelogContent.list or changelogContent end
    if istable(changelogContent) then
        local isKeyedFormat = false
        local isSimpleList = true
        for k, v in pairs(changelogContent) do
            if isstring(k) and (istable(v) or isstring(v)) then
                isKeyedFormat = true
                break
            end

            if not isnumber(k) or not isstring(v) then isSimpleList = false end
        end

        if isKeyedFormat then
            local sortedVersions = {}
            for version in pairs(changelogContent) do
                table.insert(sortedVersions, version)
            end

            table.sort(sortedVersions, versionSorter)
            for _, version in ipairs(sortedVersions) do
                local entry = changelogContent[version]
                local versionText = string.format("Version %s", version)
                local dateText
                local changes = entry
                if istable(entry) and (entry.changes or entry.notes or entry.entries or entry.items or entry.text or entry.message or entry.title or entry.label or entry.date or entry.released or entry.releaseDate) then
                    versionText = entry.version or entry.title or entry.label or versionText
                    dateText = entry.date or entry.released or entry.releaseDate
                    changes = entry.changes or entry.notes or entry.entries or entry.items or entry.text or entry.message or (#entry > 0 and entry or nil)
                end

                addVersionLabel(versionText)
                if dateText then addDateLabel(dateText) end
                renderChanges(changes)
                addSpacer()
            end
        elseif isSimpleList then
            renderChanges(changelogContent)
        else
            for i, entry in ipairs(changelogContent) do
                if isstring(entry) then
                    renderChanges({entry})
                elseif istable(entry) then
                    local versionText = entry.version or entry.title or entry.label or string.format("Version %s", i)
                    local dateText = entry.date or entry.released or entry.releaseDate
                    local changes = entry.changes or entry.notes or entry.entries or entry.items or entry.text or entry.message or (#entry > 0 and entry or nil)
                    addVersionLabel(versionText)
                    if dateText then addDateLabel(dateText) end
                    renderChanges(changes)
                    addSpacer()
                end
            end
        end
    elseif isstring(changelogContent) then
        addTextLabel(changelogContent, "LiliaFont.18", Color(220, 220, 220), 0, 8)
    end
end

function PANEL:StartBGMusic()
    if lia.menuMusic then
        lia.menuMusic:Stop()
        lia.menuMusic = nil
    end

    timer.Remove("liaMusicFader")
    local src = lia.config.get("Music", "")
    if not src:match("%S") then return end
    local vol = lia.config.get("MusicVolume", 0.25)
    local function play(music)
        music:SetVolume(vol)
        lia.menuMusic = music
        music:Play()
    end

    sound.PlayFile(src, "noplay", function(m) if m then play(m) end end)
end

function PANEL:hideExternalEntities()
    if self.hiddenEntities then self:restoreExternalEntities() end
    self.hiddenEntities = {}
    for _, ent in ents.Iterator() do
        if ent ~= self.modelEntity and not ent:IsWorld() and not ent:CreatedByMap() then
            self.hiddenEntities[ent] = ent:GetNoDraw()
            ent:SetNoDraw(true)
        end
    end
end

function PANEL:restoreExternalEntities()
    if not self.hiddenEntities then return end
    for ent, wasHidden in pairs(self.hiddenEntities) do
        if IsValid(ent) then ent:SetNoDraw(wasHidden) end
    end

    local client = LocalPlayer()
    if IsValid(client) and self.hiddenEntities[client] ~= nil then
        client:SetNoDraw(self.hiddenEntities[client])
    elseif IsValid(client) then
        client:SetNoDraw(false)
    end

    self.hiddenEntities = nil
end

function PANEL:loadBackground()
    if self.isLoadMode then
        hook.Remove("CalcView", "liaMainMenuCalcView")
        hook.Remove("PrePlayerDraw", "liaMainMenuPrePlayerDraw")
        self:hideExternalEntities()
        hook.Add("PrePlayerDraw", "liaMainMenuPrePlayerDraw", function() return true end)
        self:updateSelectedCharacter()
        if not IsValid(self.leftArrow) and self.availableCharacters and #self.availableCharacters > 1 then self:createArrows() end
        hook.Add("CalcView", "liaMainMenuCalcView", function(_, _, _, fov)
            if not IsValid(self) then return end
            if self.loadEntryCamera then return self:getLoadEntryView(fov) end
            local ent = self.modelEntity
            if not IsValid(ent) then return end
            local toCenter = ent:GetPos() + Vector(0, 0, 60)
            local toForward = ent:GetAngles():Forward()
            local origin, lookAt
            if self._camTransitionStart and self._camTransitionDuration and self._camFromCenter and self._camToCenter and self._camFromForward and self._camToForward then
                local t = math.Clamp((CurTime() - self._camTransitionStart) / self._camTransitionDuration, 0, 1)
                local eased = mmEase(t)
                local center = LerpVector(eased, self._camFromCenter, self._camToCenter)
                local forward = LerpVector(eased, self._camFromForward, self._camToForward)
                if forward:LengthSqr() < 0.0001 then forward = toForward end
                forward:Normalize()
                local baseDist = 70
                local outDist = self._camPanOutDistance or 60
                local dist = baseDist + outDist * math.sin(math.pi * eased)
                origin = center + forward * dist
                lookAt = center
                self.currentCamPos = origin
                if t >= 1 then
                    self._camTransitionStart = nil
                    self._camTransitionDuration = nil
                    self._camFromCenter = nil
                    self._camToCenter = nil
                    self._camFromForward = nil
                    self._camToForward = nil
                    self._camPanOutDistance = nil
                end
            else
                local desired = toCenter + toForward * 70
                if not self.currentCamPos then
                    self.currentCamPos = desired
                else
                    self.currentCamPos = LerpVector(FrameTime() * 5, self.currentCamPos, desired)
                end

                origin = self.currentCamPos
                lookAt = toCenter
            end
            return {
                origin = origin,
                angles = ((lookAt or toCenter) - origin):Angle(),
                fov = fov,
                drawviewer = true
            }
        end)
    else
        hook.Remove("CalcView", "liaMainMenuCalcView")
        self.loadEntryCamera = nil
        hook.Remove("PrePlayerDraw", "liaMainMenuPrePlayerDraw")
        self:restoreExternalEntities()
        if IsValid(self.modelEntity) then self.modelEntity:Remove() end
        if IsValid(self.leftArrow) then
            self.leftArrow:Remove()
            self.leftArrow = nil
        end

        if IsValid(self.rightArrow) then
            self.rightArrow:Remove()
            self.rightArrow = nil
        end

        local url = lia.config.get("BackgroundURL")
        if not isstring(url) then url = tostring(url or "") end
        if string.find(url, "%S") then
            self.background = self:Add("DHTML")
            self.background:SetSize(ScrW(), ScrH())
            self.background.ConsoleMessage = function(_, msg) end
            self.background.OnDocumentReady = function() if IsValid(self.bgLoader) then self.bgLoader:Remove() end end
            self.background.OnDocumentError = function(_, errCode, errText) end
            if string.find(url, "http", 1, true) then
                local isImageURL = url:find("%.png", 1, true) or url:find("%.jpg", 1, true) or url:find("%.jpeg", 1, true) or url:find("%.webp", 1, true) or url:find("%.gif", 1, true)
                if isImageURL then
                    local safeURL = url:gsub('"', "%%22")
                    self.background:SetHTML([[<html><head><meta charset="utf-8"><style>
html, body { width:100%; height:100%; margin:0; padding:0; overflow:hidden; background:#000; }
body { background-position:center center; background-repeat:no-repeat; background-size:cover; }
</style></head><body>
<script>
(function() {
  try {
    var url = "]] .. safeURL .. [[";
    console.log("[Lilia MainMenu] Attempting to load image:", url);
    var img = new Image();
    img.onload = function() {
      document.body.style.backgroundImage = 'url("' + url + '")';
      console.log("[Lilia MainMenu] Image loaded OK:", img.width + "x" + img.height);
      document.title = "LiliaBG:OK";
    };
    img.onerror = function(e) {
      console.log("[Lilia MainMenu] Image failed to load", e);
      document.title = "LiliaBG:ERR";
    };
    img.src = url;
  } catch (e) {
    console.log("[Lilia MainMenu] Exception:", e);
    document.title = "LiliaBG:EX";
  }
})();
</script>
</body></html>]])
                else
                    self.background:OpenURL(url)
                end
            else
                self.background:SetHTML(url)
            end

            self.background:MoveToBack()
            self.background:SetZPos(-999)
            if lia.config.get("CharMenuBGInputDisabled", true) then
                self.background:SetMouseInputEnabled(false)
                self.background:SetKeyboardInputEnabled(false)
            end

            self.bgLoader = self:Add("DPanel")
            self.bgLoader:SetSize(ScrW(), ScrH())
            self.bgLoader:SetZPos(-998)
            self.bgLoader.Paint = function(_, w, h)
                surface.SetDrawColor(5, 5, 5)
                surface.DrawRect(0, 0, w, h)
            end
        end
    end
end

function PANEL:createStartButton()
    local client = LocalPlayer()
    if not IsValid(client) then
        timer.Simple(0.1, function() if IsValid(self) then self:createStartButton() end end)
        return
    end

    self.inMainMenu = true
    self.isLoadMode = false
    self:setInWorldPreviewEnabled(false)
    if IsValid(self.menuPanel) then self.menuPanel:Remove() end
    if IsValid(self.welcomeSide) then self.welcomeSide:Remove() end
    if IsValid(self.selectionPanel) then self.selectionPanel:Remove() end
    if IsValid(self.infoFrame) then self.infoFrame:Remove() end
    if IsValid(self.bgLoader) then self.bgLoader:Remove() end
    if IsValid(self.background) then self.background:Remove() end
    if IsValid(self.changelogPanel) then self.changelogPanel:Remove() end
    if IsValid(self.modelEntity) then
        self.modelEntity:Remove()
        self.modelEntity = nil
    end

    self.buttons = self.buttons or {}
    self:showContent(false)
    self.tabs:SetVisible(false)
    self.content:SetVisible(false)
    local accent = mmAccent()
    local w = math.Clamp(ScrW() * 0.24, 340, 470)
    local h = math.Clamp(ScrH() * 0.58, 440, 640)
    local x = math.max(32, ScrW() * 0.035)
    local y = ScrH() * 0.5 - h * 0.5
    self.menuPanel = self:Add("DPanel")
    self.menuPanel:SetSize(w, h)
    self.menuPanel:SetPos(x, y)
    self.menuPanel.Paint = function(_, pw, ph) mmPaintContainer(pw, ph) end
    mmAnimateIn(self.menuPanel, x, y, -14, 0, 0.34, 0)
    local discordURL = lia.config.get("DiscordURL", "")
    local workshopURL = lia.config.get("Workshop", "")
    local buttonsData = {}
    local hasStaffChar, hasNonStaffChar = false, false
    if lia.characters and #lia.characters > 0 then
        for _, charID in pairs(lia.characters) do
            local character = lia.char.getCharacter(charID)
            if character then
                if character:getFaction() == FACTION_STAFF then
                    hasStaffChar = true
                else
                    hasNonStaffChar = true
                end
            end
        end
    end

    local function openCharacterCreation()
        self:openCharacterCreationWithTransition()
    end

    local function openCharacterSelection()
        self:openCharacterSelectionWithTransition()
    end

    local function addEntry(section, id, text, tooltip, doClick)
        buttonsData[#buttonsData + 1] = {
            section = section,
            id = id,
            text = text,
            tooltip = tooltip,
            doClick = doClick
        }
    end

    if hook.Run("CanPlayerCreateChar", client) ~= false then addEntry("Character Access", "create", "Create Character", "Create a new identity and enter the city.", openCharacterCreation) end
    local loadTooltip = hasNonStaffChar and "Continue with an existing identity." or "Browse characters or create your first character."
    addEntry("Character Access", "load", "Load Character", loadTooltip, openCharacterSelection)
    local mainCharID = IsValid(client) and client:getMainCharacter() or nil
    local clientChar = client.getChar and client:getChar()
    if mainCharID and lia.characters and #lia.characters > 0 and table.HasValue(lia.characters, mainCharID) and (not clientChar or clientChar:getID() ~= mainCharID) then
        addEntry("Character Access", "loadmain", "Load Main Character", "Jump straight into your main character.", function()
            self:clickSound()
            lia.module.get("mainmenu"):LoadMainCharacter():next(function() end):catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end)
        end)
    end

    local canCreateStaffCharacter = client:hasPrivilege("createStaffCharacter")
    local isStaffOnDuty = client:isStaffOnDuty()
    if canCreateStaffCharacter and not isStaffOnDuty then
        addEntry("Staff Access", "staff", hasStaffChar and "Load Staff Character" or "Create Staff Character", hasStaffChar and "Load your staff character." or "Create a character with staff permissions.", function()
            self:clickSound()
            if hasStaffChar then
                for _, charID in pairs(lia.characters or {}) do
                    local character = lia.char.getCharacter(charID)
                    if character and character:getFaction() == FACTION_STAFF then
                        lia.module.get("mainmenu"):ChooseCharacter(character:getID()):next(function() if IsValid(lia.gui.character) then lia.gui.character:Remove() end end):catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end)
                        break
                    end
                end
            else
                self:createStaffCharacter()
            end
        end)
    end

    if discordURL ~= "" then
        addEntry("System", "discord", "Discord", "Join our Discord server.", function()
            self:clickSound()
            gui.OpenURL(discordURL)
        end)
    end

    if workshopURL ~= "" then
        addEntry("System", "workshop", "Workshop", "View our Workshop collection.", function()
            self:clickSound()
            gui.OpenURL(workshopURL)
        end)
    end

    local needsDownload = lia.workshop.hasContentToDownload()
    addEntry("System", "mount", "Mount Content", needsDownload and "Mount required Workshop content." or "Remount Workshop addons.", function()
        self:clickSound()
        if not needsDownload then
            lia.workshop.remountContent()
        else
            lia.workshop.mountContent()
        end
    end)

    addEntry("System", "disconnect", "Disconnect", "Leave the server and return to desktop.", function()
        self:clickSound()
        RunConsoleCommand("disconnect")
    end)

    if clientChar and not self.isKickedFromChar then addEntry("System", "return", "Return to Your Character", "Close this menu and return to play.", function() self:Remove() end) end
    self.buttons = {}
    local pad = 18
    local innerW = w - pad * 2
    local cursorY = 18
    local title = self.menuPanel:Add("DLabel")
    title:SetFont("LiliaFont.30")
    title:SetTextColor(mmText())
    title:SetText("MAIN MENU")
    title:SetPos(pad, cursorY)
    title:SizeToContents()
    cursorY = cursorY + 34
    local subtitle = self.menuPanel:Add("DLabel")
    subtitle:SetFont("LiliaFont.17")
    subtitle:SetTextColor(mmMuted())
    subtitle:SetText("Choose how you want to enter the city.")
    subtitle:SetPos(pad, cursorY)
    subtitle:SizeToContents()
    cursorY = cursorY + 28
    local lastSection
    local function addSectionLabel(text)
        local lbl = self.menuPanel:Add("DLabel")
        lbl:SetFont("LiliaFont.14")
        lbl:SetTextColor(mmMuted(180))
        lbl:SetText(string.upper(text))
        lbl:SetPos(pad, cursorY)
        lbl:SizeToContents()
        cursorY = cursorY + 22
    end

    local function addMenuButton(entry)
        local btnH = 56
        local btn = self.menuPanel:Add("DButton")
        btn:SetText("")
        btn:SetPos(pad, cursorY)
        btn:SetSize(innerW, btnH)
        btn.liaToolTip = entry.tooltip and entry.tooltip ~= ""
        if btn.liaToolTip then btn:SetTooltip("<font=LiliaFont.16>" .. entry.tooltip .. "</font>") end
        btn.Paint = function(s, bw, bh)
            local hovered = s:IsHovered()
            mmPaintBlock(bw, bh, hovered)
            draw.SimpleText(string.upper(entry.text), "LiliaFont.17", 16, 18, mmText(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(entry.tooltip or "", "LiliaFont.14", 16, 38, mmMuted(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if hovered then draw.SimpleText(">", "LiliaFont.17", bw - 16, bh * 0.5, mmAccent(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        end

        function btn:OnCursorEntered()
            if IsValid(lia.gui.character) and isfunction(lia.gui.character.hoverSound) then lia.gui.character:hoverSound() end
        end

        btn.DoClick = entry.doClick
        self.buttons[entry.id] = btn
        cursorY = cursorY + btnH + 10
    end

    for _, entry in ipairs(buttonsData) do
        if entry.section ~= lastSection then
            addSectionLabel(entry.section)
            lastSection = entry.section
        end

        addMenuButton(entry)
    end

    self:createWelcomeSidePanel()
end

function PANEL:addTab(name, callback, justClick, height)
    local btn = self.tabs:Add("liaMediumButton")
    surface.SetFont(btn:GetFont())
    local textW, textH = surface.GetTextSize(tostring(name):upper())
    btn:SetWide(textW + 40)
    btn:SetText(tostring(name):upper())
    btn:SetShowLine(true)
    btn:SetTall(height or textH + 20)
    if justClick then
        if isfunction(callback) then btn.DoClick = function() callback(self) end end
        return btn
    end

    btn.DoClick = function(b) b:SetSelected(true) end
    if isfunction(callback) then btn:onSelected(function() callback(self) end) end
    return btn
end

function PANEL:createTabs()
    self.tabs:Clear()
    if not self.isLoadMode and not self.isKickedFromChar then self:addTab("Return to Main Menu", function() self:backToMainMenu() end, true) end
end

function PANEL:backToMainMenu()
    self:clickSound()
    if IsValid(lia.gui.charConfirm) then lia.gui.charConfirm:Remove() end
    if IsValid(self.infoFrame) then self.infoFrame:Remove() end
    if IsValid(self.changelogPanel) then self.changelogPanel:Remove() end
    if IsValid(self.leftArrow) then
        self.leftArrow:Remove()
        self.leftArrow = nil
    end

    if IsValid(self.rightArrow) then
        self.rightArrow:Remove()
        self.rightArrow = nil
    end

    local function finish()
        if self.inWorldPreview then self:setInWorldPreviewEnabled(false) end
        if IsValid(self.selectBtn) then self.selectBtn:Remove() end
        if IsValid(self.deleteBtn) then self.deleteBtn:Remove() end
        if IsValid(self.setMainBtn) then self.setMainBtn:Remove() end
        for _, btn in pairs(self.buttons) do
            if IsValid(btn) then btn:Remove() end
        end

        self.buttons = {}
        self.isLoadMode = false
        self.disableClientModel = false
        self.inCharacterCreation = false
        self.content:Clear()
        self.tabs:Clear()
        self:createStartButton()
        self:loadBackground()
    end

    self:transitionPanelsOut({
        {
            panel = self.menuPanel,
            dx = -14
        },
        {
            panel = self.selectionPanel,
            dx = 14
        }
    }, function() if IsValid(self) then finish() end end)
end

function PANEL:getClosestGroundPosition(pos)
    if not isvector(pos) then return pos end
    local startPos = pos + Vector(0, 0, 64)
    local endPos = pos + Vector(0, 0, -16384)
    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        mask = MASK_SOLID,
        filter = {self.modelEntity, LocalPlayer()}
    })

    if tr.Hit and tr.HitWorld and not tr.HitSky then
        local hitPos = tr.HitPos
        if isvector(hitPos) and hitPos.z <= startPos.z + 1 then return hitPos + Vector(0, 0, 2) end
    end
    return pos
end

function PANEL:createCharacterSelection()
    self.isLoadMode = true
    self.inMainMenu = false
    if IsValid(self.welcomeSide) then self.welcomeSide:Remove() end
    if IsValid(self.menuPanel) then self.menuPanel:Remove() end
    if IsValid(self.selectionPanel) then self.selectionPanel:Remove() end
    if IsValid(self.changelogPanel) then self.changelogPanel:Remove() end
    self.buttons = self.buttons or {}
    self.availableCharacters = {}
    for _, charID in pairs(lia.characters or {}) do
        local character = lia.char.getCharacter(charID)
        if character and character:getFaction() ~= FACTION_STAFF then self.availableCharacters[#self.availableCharacters + 1] = charID end
    end

    self:showContent(true)
    self.tabs:SetVisible(false)
    self.content:SetVisible(true)
    local client = LocalPlayer()
    local hasStaffChar = false
    for _, charID in pairs(lia.characters or {}) do
        local character = lia.char.getCharacter(charID)
        if character and character:getFaction() == FACTION_STAFF then
            hasStaffChar = true
            break
        end
    end

    local accent = mmAccent()
    local leftW = math.Clamp(ScrW() * 0.24, 340, 470)
    local leftH = math.Clamp(ScrH() * 0.58, 440, 640)
    local leftX = math.max(32, ScrW() * 0.035)
    local leftY = ScrH() * 0.5 - leftH * 0.5
    self.menuPanel = self:Add("DPanel")
    self.menuPanel:SetSize(leftW, leftH)
    self.menuPanel:SetPos(leftX, leftY)
    self.menuPanel.Paint = function(_, pw, ph) mmPaintContainer(pw, ph) end
    mmAnimateIn(self.menuPanel, leftX, leftY, -14, 0, 0.34, 0)
    local pad = 18
    local innerW = leftW - pad * 2
    local y = 18
    local title = self.menuPanel:Add("DLabel")
    title:SetFont("LiliaFont.30")
    title:SetTextColor(mmText())
    title:SetText("MAIN MENU")
    title:SetPos(pad, y)
    title:SizeToContents()
    y = y + 34
    local subtitle = self.menuPanel:Add("DLabel")
    subtitle:SetFont("LiliaFont.17")
    subtitle:SetTextColor(mmMuted())
    subtitle:SetText("Use the arrows to switch characters.")
    subtitle:SetPos(pad, y)
    subtitle:SizeToContents()
    y = y + 28
    local function addSectionLabel(text)
        local lbl = self.menuPanel:Add("DLabel")
        lbl:SetFont("LiliaFont.14")
        lbl:SetTextColor(mmMuted(180))
        lbl:SetText(string.upper(text))
        lbl:SetPos(pad, y)
        lbl:SizeToContents()
        y = y + 22
    end

    local function addMenuButton(text, tooltip, doClick)
        local btnH = 56
        local btn = self.menuPanel:Add("DButton")
        btn:SetText("")
        btn:SetPos(pad, y)
        btn:SetSize(innerW, btnH)
        btn.Paint = function(s, bw, bh)
            local hovered = s:IsHovered()
            mmPaintBlock(bw, bh, hovered)
            draw.SimpleText(string.upper(text), "LiliaFont.17", 16, 18, mmText(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(tooltip or "", "LiliaFont.14", 16, 38, mmMuted(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if hovered then draw.SimpleText(">", "LiliaFont.17", bw - 16, bh * 0.5, mmAccent(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        end

        function btn:OnCursorEntered()
            if IsValid(lia.gui.character) and isfunction(lia.gui.character.hoverSound) then lia.gui.character:hoverSound() end
        end

        btn.DoClick = doClick
        y = y + btnH + 10
        return btn
    end

    addSectionLabel("Character Access")
    addMenuButton("Create Character", "Create a new identity and enter the city.", function() self:openCharacterCreationWithTransition() end)
    addMenuButton("Load Character", #self.availableCharacters > 0 and "Continue with an existing identity." or "No characters found yet.", function() self:clickSound() end)
    if client:hasPrivilege("createStaffCharacter") and not client:isStaffOnDuty() then
        addSectionLabel("Staff Access")
        addMenuButton(hasStaffChar and "Load Staff Character" or "Create Staff Character", hasStaffChar and "Load your staff character." or "Create a character with staff permissions.", function()
            self:clickSound()
            if hasStaffChar then
                for _, charID in pairs(lia.characters or {}) do
                    local character = lia.char.getCharacter(charID)
                    if character and character:getFaction() == FACTION_STAFF then
                        lia.module.get("mainmenu"):ChooseCharacter(character:getID()):next(function() if IsValid(lia.gui.character) then lia.gui.character:Remove() end end):catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end)
                        break
                    end
                end
            else
                self:createStaffCharacter()
            end
        end)
    end

    addSectionLabel("System")
    local needsDownload = lia.workshop.hasContentToDownload()
    addMenuButton("Mount Content", needsDownload and "Mount required Workshop content." or "Remount Workshop addons.", function()
        self:clickSound()
        if not needsDownload then
            lia.workshop.remountContent()
        else
            lia.workshop.mountContent()
        end
    end)

    addMenuButton("Disconnect", "Leave the server and return to desktop.", function()
        self:clickSound()
        RunConsoleCommand("disconnect")
    end)

    local rightW = math.Clamp(ScrW() * 0.23, 360, 520)
    local rightH = math.Clamp(ScrH() * 0.60, 480, 700)
    local rightX = ScrW() - rightW - math.max(32, ScrW() * 0.04)
    local rightY = ScrH() * 0.5 - rightH * 0.5
    self.selectionPanel = self:Add("DPanel")
    self.selectionPanel:SetSize(rightW, rightH)
    self.selectionPanel:SetPos(rightX, rightY)
    self.selectionPanel.Paint = function(_, pw, ph) mmPaintContainer(pw, ph) end
    mmAnimateIn(self.selectionPanel, rightX, rightY, 18, 0, 0.36, 0.06)
    self.selectionTitle = self.selectionPanel:Add("DLabel")
    self.selectionTitle:SetFont("LiliaFont.22")
    self.selectionTitle:SetTextColor(mmText())
    self.selectionTitle:SetText("CHARACTER DETAILS")
    self.selectionTitle:SetPos(16, 14)
    self.selectionTitle:SizeToContents()
    self.selectionCountLabel = self.selectionPanel:Add("DLabel")
    self.selectionCountLabel:SetFont("LiliaFont.17")
    self.selectionCountLabel:SetTextColor(mmAccent())
    self.selectionCountLabel:SetText("")
    self.selectionCountLabel:SetPos(rightW - 54, 16)
    self.selectionCountLabel:SizeToContents()
    local detailsY = 50
    local actionHeight = 139
    local actionY = rightH - actionHeight - 15
    self.detailsWrap = self.selectionPanel:Add("DPanel")
    self.detailsWrap:SetPos(16, detailsY)
    self.detailsWrap:SetSize(rightW - 32, math.max(80, actionY - detailsY - 12))
    self.detailsWrap.Paint = function(_, w, h) mmPaintBlock(w, h, false) end
    self.detailsPanel = self.detailsWrap:Add("DScrollPanel")
    self.detailsPanel:SetPos(6, 6)
    self.detailsPanel:SetSize(self.detailsWrap:GetWide() - 12, self.detailsWrap:GetTall() - 12)
    self.detailsPanel.Paint = function() end
    mmStyleScrollBar(self.detailsPanel)
    self.actionPanel = self.selectionPanel:Add("DPanel")
    self.actionPanel:SetPos(16, actionY)
    self.actionPanel:SetSize(rightW - 32, actionHeight)
    self.actionPanel.Paint = function() end
    if #self.availableCharacters > 0 then
        self.currentIndex = math.Clamp(self.currentIndex or 1, 1, #self.availableCharacters)
    else
        self.currentIndex = nil
    end

    self:updateSelectedCharacter()
end

function PANEL:createCharacterCreation()
    self:restoreExternalEntities()
    hook.Remove("PrePlayerDraw", "liaMainMenuPrePlayerDraw")
    hook.Remove("CalcView", "liaMainMenuCalcView")
    hook.Remove("PostDrawOpaqueRenderables", "liaMainMenuPostDrawOpaqueRenderables")
    if self.mainMenuRenderHookID then
        hook.Remove("PostDrawOpaqueRenderables", self.mainMenuRenderHookID)
        self.mainMenuRenderHookID = nil
    end

    if IsValid(self.modelEntity) then
        self.modelEntity:Remove()
        self.modelEntity = nil
    end

    if IsValid(self.fadingModelEntity) then self.fadingModelEntity:Remove() end
    self.fadingModelEntity = nil
    self.previewCharacterID = nil
    if IsValid(self.leftArrow) then
        self.leftArrow:Remove()
        self.leftArrow = nil
    end

    if IsValid(self.rightArrow) then
        self.rightArrow:Remove()
        self.rightArrow = nil
    end

    for _, name in ipairs{"background", "logo", "changelogPanel"} do
        if IsValid(self[name]) then
            self[name]:Remove()
            self[name] = nil
        end
    end

    for _, b in pairs(self.buttons) do
        if IsValid(b) then b:Remove() end
    end

    self.buttons = {}
    if IsValid(self.bgLoader) then self.bgLoader:Remove() end
    self.content:Clear()
    self.content:InvalidateLayout(true)
    self.content:Add("liaCharacterCreation")
    self.inCharacterCreation = true
end

function PANEL:createStaffCharacter()
    local client = LocalPlayer()
    local steamName = client:Nick()
    local staffData = {
        name = steamName,
        faction = FACTION_STAFF,
        model = 1,
        desc = "",
        skin = 0,
        groups = {}
    }

    lia.module.get("mainmenu"):CreateCharacter(staffData):next(function(charID) lia.module.get("mainmenu"):ChooseCharacter(charID):next(function() if IsValid(lia.gui.character) then lia.gui.character:Remove() end end):catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end) end):catch(function(err) LocalPlayer():notifyErrorLocalized(err or "failedToCreateStaffCharacter") end)
end

function PANEL:updateSelectedCharacter()
    if not self.isLoadMode then return end
    local chars = self.availableCharacters or {}
    if #chars == 0 then
        self.currentIndex = nil
        if IsValid(self.modelEntity) then
            self.modelEntity:Remove()
            self.modelEntity = nil
        end

        if IsValid(self.fadingModelEntity) then
            self.fadingModelEntity:Remove()
            self.fadingModelEntity = nil
        end

        self.previewCharacterID = nil
        self:createSelectedCharacterInfoPanel(nil)
        return
    end

    self.currentIndex = math.Clamp(self.currentIndex or 1, 1, #chars)
    local selectedID = chars[self.currentIndex]
    local character = lia.char.getCharacter(selectedID)
    self:createSelectedCharacterInfoPanel(character)
    if character and (self.previewCharacterID ~= selectedID or not IsValid(self.modelEntity)) then self:updateModelEntity(character) end
end

function PANEL:updateSelectedCharacterForID(charID)
    if not self.isLoadMode then return end
    local chars = self.availableCharacters or {}
    if #chars == 0 then
        self.currentIndex = nil
        if IsValid(self.modelEntity) then
            self.modelEntity:Remove()
            self.modelEntity = nil
        end

        self:createSelectedCharacterInfoPanel(nil)
        return
    end

    for i, cID in ipairs(chars) do
        if cID == charID then
            self.currentIndex = i
            break
        end
    end

    self:updateSelectedCharacter()
end

function PANEL:createSelectedCharacterInfoPanel(character)
    if not IsValid(self.selectionPanel) then return end
    local accent = mmAccent()
    local chars = self.availableCharacters or {}
    if IsValid(self.detailsPanel) then self.detailsPanel:Clear() end
    if IsValid(self.actionPanel) then self.actionPanel:Clear() end
    if IsValid(self.selectionCountLabel) then
        self.selectionCountLabel:SetText(string.format("%d / %d", self.currentIndex or 0, #chars))
        self.selectionCountLabel:SizeToContents()
    end

    if not character then
        local empty = self.detailsPanel:Add("DPanel")
        empty:Dock(FILL)
        empty.Paint = function(_, w, h)
            draw.SimpleText("NO CHARACTERS FOUND", "LiliaFont.22", w * 0.5, h * 0.38, mmText(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Create a character to begin your journey in the city.", "LiliaFont.17", w * 0.5, h * 0.50, mmMuted(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local createBtn = self.actionPanel:Add("DButton")
        createBtn:Dock(TOP)
        createBtn:SetTall(42)
        createBtn:SetText("")
        createBtn.Paint = function(s, w, h)
            mmPaintBlock(w, h, s:IsHovered())
            draw.SimpleText("CREATE CHARACTER", "LiliaFont.17", w * 0.5, h * 0.5, mmText(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function createBtn:OnCursorEntered()
            if IsValid(lia.gui.character) and isfunction(lia.gui.character.hoverSound) then lia.gui.character:hoverSound() end
        end

        createBtn.DoClick = function() self:openCharacterCreationWithTransition() end
        return
    end

    local detailsWidth = math.max(250, self.detailsPanel:GetWide() - 14)
    local cardGap = 8
    local rowHeight = 57
    local cardWidth = math.floor((detailsWidth - cardGap) * 0.5)
    local function createDetailCard(parent, title, value, width, height)
        local card = parent:Add("DPanel")
        card:SetSize(width, height)
        card.Paint = function(_, w, h) mmPaintBlock(w, h, false) end
        local key = card:Add("DLabel")
        key:SetFont("LiliaFont.14")
        key:SetTextColor(mmMuted())
        key:SetText(string.upper(title))
        key:SetPos(12, 9)
        key:SizeToContents()
        local label = card:Add("DLabel")
        label:SetFont(title == "Description" and "LiliaFont.16" or "LiliaFont.17")
        label:SetTextColor(mmText())
        label:SetText(tostring(value or ""))
        label:SetWrap(true)
        label:SetContentAlignment(7)
        label:SetPos(12, 28)
        label:SetSize(width - 24, height - 34)
        return card
    end

    local function createPair(left, right)
        local row = self.detailsPanel:Add("DPanel")
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, cardGap)
        row:SetTall(rowHeight)
        row.Paint = function() end
        createDetailCard(row, left[1], left[2], cardWidth, rowHeight):SetPos(0, 0)
        if right then createDetailCard(row, right[1], right[2], cardWidth, rowHeight):SetPos(cardWidth + cardGap, 0) end
    end

    local function createFull(title, value, height)
        local card = createDetailCard(self.detailsPanel, title, value, detailsWidth, height)
        card:Dock(TOP)
        card:DockMargin(0, 0, 0, cardGap)
    end

    createPair({"Name", character:getName() or ""}, {"Faction", team.GetName(character:getFaction()) or ""})
    local description = tostring(character:getDesc() or "")
    local estimatedLines = math.ceil(#description / math.max(20, math.floor((detailsWidth - 24) / 7.4)))
    local descriptionHeight = 43 + math.max(2, estimatedLines) * 18
    createFull("Description", description, math.Clamp(descriptionHeight, 79, 186))
    local extraValue
    if character.getClass and character:getClass() then
        local cls = lia.class.list[character:getClass()]
        if cls and cls.name then extraValue = {"Class", cls.name} end
    end

    createPair({"Money", lia.currency.get(character:getMoney())}, extraValue)
    if next(lia.attribs.list or {}) then
        local heading = self.detailsPanel:Add("DLabel")
        heading:Dock(TOP)
        heading:DockMargin(0, 7, 0, 9)
        heading:SetTall(19)
        heading:SetFont("LiliaFont.16")
        heading:SetTextColor(mmAccent())
        heading:SetText("ATTRIBUTES")
        local attrs = {}
        for id, attr in pairs(lia.attribs.list) do
            attrs[#attrs + 1] = {
                id = id,
                attr = attr
            }
        end

        table.sort(attrs, function(a, b) return a.attr.name < b.attr.name end)
        for _, entry in ipairs(attrs) do
            local value = character:getAttrib(entry.id) or (entry.attr.min or 0)
            local maximum = math.max(entry.attr.max or 100, 1)
            local label = self.detailsPanel:Add("DLabel")
            label:Dock(TOP)
            label:DockMargin(0, 0, 0, 4)
            label:SetTall(18)
            label:SetFont("LiliaFont.14")
            label:SetTextColor(mmText())
            label:SetText(entry.attr.name)
            local progress = self.detailsPanel:Add("liaProgressBar")
            progress:Dock(TOP)
            progress:DockMargin(0, 0, 0, 12)
            progress:SetTall(26)
            progress:SetFraction(math.Clamp(value / maximum, 0, 1))
            progress:SetText(value .. "/" .. maximum)
            progress.Font = "LiliaFont.14"
            progress:SetBarColor(entry.attr.color or accent)
        end
    end

    self.detailsPanel:InvalidateLayout(true)
    if IsValid(self.detailsWrap) then
        local x, y = self.detailsWrap:GetPos()
        self.detailsWrap:SetAlpha(0)
        mmTweenPanel(self.detailsWrap, x, y, 255, 0.24, 0)
    end

    local function addActionButton(text, colorOverride, doClick)
        local btn = self.actionPanel:Add("DButton")
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 8)
        btn:SetTall(36)
        btn:SetText("")
        btn.Paint = function(s, w, h)
            local borderColor = colorOverride or mmAccent()
            local active = s:IsHovered()
            local bg = mmSurface(active and 0.06 or 0.04, active and 242 or 236)
            mmDrawPanel(0, 0, w, h, 4, bg, Color(borderColor.r, borderColor.g, borderColor.b, active and 120 or 70))
            draw.SimpleText(string.upper(text), "LiliaFont.14", w * 0.5, h * 0.5, mmText(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function btn:OnCursorEntered()
            if IsValid(lia.gui.character) and isfunction(lia.gui.character.hoverSound) then lia.gui.character:hoverSound() end
        end

        btn.DoClick = doClick
        return btn
    end

    addActionButton(character:isBanned() and "Character Permanently Killed" or "Play Character", nil, function()
        if character:isBanned() then
            local characterName = character:getName()
            LocalPlayer():requestString("Permanent Kill", string.format("Your character: %s, has been permanently killed. An administrator has approved this PK.\nPKs are a regular part of RP; you can always make a new character. Have fun!", characterName), function() end)
            return
        end

        self:clickSound()
        lia.module.get("mainmenu"):ChooseCharacter(character:getID()):next(function() if IsValid(self) then self:Remove() end end):catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end)
    end)

    addActionButton("Delete Character", Color(185, 90, 90), function()
        local charID = character:getID()
        if hook.Run("CanDeleteChar", charID) == false then
            LocalPlayer():notifyError("You cannot delete this character!")
            return
        end

        self:showConfirmation("Are you sure you want to delete this character?\nThis action cannot be undone.", function() lia.module.get("mainmenu"):DeleteCharacter(charID) end)
    end)

    local localClient = LocalPlayer()
    local mainCharID = IsValid(localClient) and localClient:getMainCharacter() or nil
    if character:getID() ~= mainCharID then
        addActionButton("Set as Main Character", nil, function()
            if IsValid(localClient) then localClient:setMainCharacter(character:getID()) end
            self:clickSound()
            self:createSelectedCharacterInfoPanel(character)
        end)
    end
end

function PANEL:updateModelEntity(character)
    local prevEnt = self.modelEntity
    if not character then return end
    if IsValid(self.fadingModelEntity) then self.fadingModelEntity:Remove() end
    self.fadingModelEntity = nil
    local model = character.getModel and character:getModel() or LocalPlayer():GetModel()
    self.modelEntity = ClientsideModel(model, RENDERGROUP_OPAQUE)
    if not IsValid(self.modelEntity) then
        self.modelEntity = prevEnt
        return
    end

    self.modelEntity:SetSkin(character:getSkin())
    lia.util.applyBodygroups(self.modelEntity, character:getBodygroups())
    hook.Run("SetupPlayerModel", self.modelEntity, character)
    local pos, ang = self:getPreviewPlacement(character)
    self.modelEntity:SetPos(pos)
    self.modelEntity:SetAngles(ang)
    if IsValid(prevEnt) and self.isLoadMode then
        local fromCenter = prevEnt:GetPos() + Vector(0, 0, 60)
        local fromForward = prevEnt:GetAngles():Forward()
        local toCenter = self.modelEntity:GetPos() + Vector(0, 0, 60)
        local toForward = self.modelEntity:GetAngles():Forward()
        self._camFromCenter = fromCenter
        self._camFromForward = fromForward
        self._camToCenter = toCenter
        self._camToForward = toForward
        self._camTransitionStart = CurTime()
        self._camTransitionDuration = 0.72
        self._camPanOutDistance = 34
    elseif not self.loadEntryCamera then
        self.currentCamPos = nil
    end

    self.previewCharacterID = character:getID()
    if IsValid(prevEnt) then
        self.fadingModelEntity = prevEnt
        self.modelTransitionStarted = RealTime()
    else
        self.modelTransitionStarted = nil
    end

    local seqID = self.modelEntity:LookupSequence("idle_all_01")
    if seqID > 0 then
        self.modelEntity:ResetSequence(seqID)
        self.modelEntity:SetCycle(0)
    else
        for _, seq in ipairs(self.modelEntity:GetSequenceList()) do
            if seq:lower():find("idle") and seq ~= "idlenoise" then
                self.modelEntity:ResetSequence(seq)
                self.modelEntity:SetCycle(0)
                break
            end
        end
    end

    hook.Run("ModifyCharacterModel", self.modelEntity, character)
    hook.Add("PostDrawOpaqueRenderables", "liaMainMenuPostDrawOpaqueRenderables", function()
        if not IsValid(self) or not IsValid(self.modelEntity) or not (self.isLoadMode or self.inWorldPreview) then return end
        local fraction = self.modelTransitionStarted and mmEase((RealTime() - self.modelTransitionStarted) / 0.36) or 1
        if IsValid(self.fadingModelEntity) then
            if fraction < 1 then
                render.SetBlend(1 - fraction)
                self.fadingModelEntity:FrameAdvance()
                self.fadingModelEntity:DrawModel()
            else
                self.fadingModelEntity:Remove()
                self.fadingModelEntity = nil
                self.modelTransitionStarted = nil
            end
        end

        render.SetBlend(fraction)
        self.modelEntity:FrameAdvance()
        self.modelEntity:DrawModel()
        render.SetBlend(1)
    end)
end

function PANEL:createArrows()
    if IsValid(self.leftArrow) then self.leftArrow:Remove() end
    if IsValid(self.rightArrow) then self.rightArrow:Remove() end
    local size = math.Clamp(ScrH() * 0.062, 48, 66)
    local gap = math.Clamp(ScrW() * 0.135, 155, 265)
    local centerX = ScrW() * 0.5
    local centerY = ScrH() * 0.52
    local function newArrow(direction)
        local button = self:Add("DButton")
        button:SetText("")
        button:SetSize(size, size)
        local x = direction < 0 and centerX - gap - size or centerX + gap
        local y = centerY - size * 0.5
        mmAnimateIn(button, x, y, direction * 12, 0, 0.34, 0.08)
        button.hoverFraction = 0
        button.Paint = function(s, w, h)
            s.hoverFraction = Lerp(math.min(FrameTime() * 12, 1), s.hoverFraction, s:IsHovered() and 1 or 0)
            local fraction = s.hoverFraction
            local accent = mmAccent()
            local background = mmSurface(0.05 + fraction * 0.035, 232 + fraction * 15)
            mmDrawPanel(0, 0, w, h, 6, background, Color(accent.r, accent.g, accent.b, 65 + fraction * 110))
            local cx = math.floor(w * 0.5)
            local cy = math.floor(h * 0.5)
            local reach = math.floor(math.min(w, h) * 0.16)
            surface.SetDrawColor(mmMix(mmMuted(), accent, 0.45 + fraction * 0.55))
            if direction < 0 then
                surface.DrawLine(cx + reach * 0.35, cy - reach, cx - reach * 0.65, cy)
                surface.DrawLine(cx - reach * 0.65, cy, cx + reach * 0.35, cy + reach)
            else
                surface.DrawLine(cx - reach * 0.35, cy - reach, cx + reach * 0.65, cy)
                surface.DrawLine(cx + reach * 0.65, cy, cx - reach * 0.35, cy + reach)
            end
        end

        button.OnCursorEntered = function() if IsValid(self) then self:hoverSound() end end
        button.DoClick = function()
            local chars = self.availableCharacters or {}
            if not self.isLoadMode or self.panelsTransitioning or #chars < 2 then return end
            if self.nextArrowInput and RealTime() < self.nextArrowInput then return end
            self.nextArrowInput = RealTime() + 0.14
            self._loadSwapDir = direction
            self.currentIndex = (self.currentIndex or 1) + direction
            if self.currentIndex < 1 then self.currentIndex = #chars end
            if self.currentIndex > #chars then self.currentIndex = 1 end
            self:clickSound()
            self:updateSelectedCharacter()
        end
        return button
    end

    self.leftArrow = newArrow(-1)
    self.rightArrow = newArrow(1)
end

function PANEL:UpdateLogoPosition()
    if not IsValid(self.logo) then return end
    local pad = ScrH() * 0.03
    local baseSize = math.max(ScrW() * 0.15, 300)
    local logoW, logoH = baseSize * 0.95, baseSize * 0.6 * 0.95
    local left, right, top = math.huge, -math.huge, math.huge
    for _, v in pairs(self.buttons) do
        if IsValid(v) then
            local x, y = v:GetPos()
            left = math.min(left, x)
            right = math.max(right, x + v:GetWide())
            top = math.min(top, y)
        end
    end

    top = top == math.huge and ScrH() * 0.5 or top
    local center = (left + right) * 0.5
    local maxLogoW = math.min(logoW, ScrW() * 0.8)
    local maxLogoH = math.min(logoH, ScrH() * 0.3)
    logoW = maxLogoW
    logoH = maxLogoH
    local logoX = math.max(pad, math.min(center - logoW * 0.5, ScrW() - logoW - pad))
    local logoY = math.max(pad, top - logoH - pad)
    self.logo:SetPos(logoX, logoY)
    self.logo:SetSize(logoW, logoH)
    self.logo:SetKeepAspect(true)
end

function PANEL:showContent(disableBg)
    if IsValid(self.infoFrame) then self.infoFrame:Remove() end
    if IsValid(self.bgLoader) then self.bgLoader:Remove() end
    if IsValid(self.background) then self.background:Remove() end
    if IsValid(self.leftArrow) then
        self.leftArrow:Remove()
        self.leftArrow = nil
    end

    if IsValid(self.rightArrow) then
        self.rightArrow:Remove()
        self.rightArrow = nil
    end

    if IsValid(self.logo) then
        self.logo:Remove()
        self.logo = nil
    end

    for _, b in pairs(self.buttons) do
        if IsValid(b) then b:Remove() end
    end

    self.buttons = {}
    self.disableClientModel = true
    self:removeClientModelModifications()
    if IsValid(self.modelEntity) then self.modelEntity:Remove() end
    if IsValid(self.fadingModelEntity) then self.fadingModelEntity:Remove() end
    self.fadingModelEntity = nil
    self.previewCharacterID = nil
    self.modelTransitionStarted = nil
    self.tabs:Clear()
    self.content:Clear()
    self:createTabs()
    self.noBlur = self.isLoadMode or false
    if self.isLoadMode or not disableBg then self:loadBackground() end
end

function PANEL:removeClientModelModifications()
    hook.Remove("PrePlayerDraw", "liaMainMenuPrePlayerDraw")
    hook.Remove("CalcView", "liaMainMenuCalcView")
    hook.Remove("PostDrawOpaqueRenderables", "liaMainMenuPostDrawOpaqueRenderables")
    if self.mainMenuRenderHookID then
        hook.Remove("PostDrawOpaqueRenderables", self.mainMenuRenderHookID)
        self.mainMenuRenderHookID = nil
    end
end

function PANEL:setFadeToBlack(fade)
    local d = deferred.new()
    if fade then
        if IsValid(self.fade) then self.fade:Remove() end
        local p = vgui.Create("DPanel")
        p:SetSize(ScrW(), ScrH())
        p:SetSkin("Default")
        p:SetBackgroundColor(color_black)
        p:SetAlpha(0)
        p:AlphaTo(255, 0.5, 0, function() d:resolve() end)
        p:SetZPos(999)
        p:MakePopup()
        self.fade = p
    else
        if IsValid(self.fade) then
            local p = self.fade
            p:AlphaTo(0, 0.5, 0, function()
                p:Remove()
                d:resolve()
            end)
        end
    end
    return d
end

function PANEL:fadeOut()
    self:AlphaTo(0, 0.1, 0, function() self:Remove() end)
end

function PANEL:Paint(w, h)
    self:paintBackground(w, h)
end

function PANEL:paintBackground(w, h)
    if not IsValid(self.background) and self.blank then
        surface.SetDrawColor(42, 42, 42, 179)
        surface.DrawRect(0, 0, w, h)
    end
end

function PANEL:hoverSound()
    LocalPlayer():EmitSound("buttons/button15.wav", 35, 250)
end

function PANEL:clickSound()
    LocalPlayer():EmitSound("buttons/button14.wav", 35, 255)
end

function PANEL:warningSound()
    LocalPlayer():EmitSound("friends/friend_join.wav", 40, 255)
end

function PANEL:Update()
    if IsValid(self) then
        self:Remove()
        local mainMenuModule = lia.module.get("mainmenu")
        if mainMenuModule and isfunction(mainMenuModule.OpenCharacterMenu) then
            MODULE:OpenCharacterMenu()
        else
            vgui.Create("liaCharacter")
        end
    end
end

function PANEL:onCharListUpdated(_, newCharList)
    if not self.isLoadMode then return end
    self.availableCharacters = {}
    for _, charID in ipairs(newCharList or {}) do
        local character = lia.char.getCharacter(charID)
        if character and character:getFaction() ~= FACTION_STAFF then self.availableCharacters[#self.availableCharacters + 1] = charID end
    end

    if self.currentIndex and #self.availableCharacters > 0 then
        self.currentIndex = math.Clamp(self.currentIndex, 1, #self.availableCharacters)
    else
        self.currentIndex = #self.availableCharacters > 0 and 1 or nil
    end

    self:createCharacterSelection()
end

function PANEL:OnRemove()
    if lia.gui.character == self then lia.gui.character = nil end
    hook.Run("CharMenuClosed")
    self:restoreExternalEntities()
    local client = LocalPlayer()
    if IsValid(client) then client:SetNoDraw(false) end
    hook.Remove("PrePlayerDraw", "liaMainMenuPrePlayerDraw")
    hook.Remove("CalcView", "liaMainMenuCalcView")
    hook.Remove("PostDrawOpaqueRenderables", "liaMainMenuPostDrawOpaqueRenderables")
    if self.mainMenuRenderHookID then
        hook.Remove("PostDrawOpaqueRenderables", self.mainMenuRenderHookID)
        self.mainMenuRenderHookID = nil
    end

    hook.Remove("DrawPhysgunBeam", "liaMainMenuPreDrawPhysgunBeam")
    hook.Remove("RenderScreenspaceEffects", "liaCharMenuDarken")
    if self.charListUpdateHook then hook.Remove("CharListUpdated", self.charListUpdateHook) end
    if self.adminPrivilegesUpdateHook then hook.Remove("AdminPrivilegesUpdated", self.adminPrivilegesUpdateHook) end
    if render.oldDrawBeam then
        render.DrawBeam = render.oldDrawBeam
        render.oldDrawBeam = nil
    end

    local music = lia.menuMusic
    if music then
        lia.menuMusic = nil
        timer.Remove("liaMusicFader")
        local vol = lia.config.get("MusicVolume", 0.25)
        local start = RealTime()
        timer.Create("liaMusicFader", 0.1, 0, function()
            if not music then return timer.Remove("liaMusicFader") end
            local frac = math.max(0, 1 - (RealTime() - start) / 5)
            if music.ChangeVolume then
                music:ChangeVolume(frac * vol, 0.1)
            else
                music:SetVolume(frac * vol)
            end

            if frac <= 0 then
                music:Stop()
                timer.Remove("liaMusicFader")
            end
        end)
    end

    self.loadEntryCamera = nil
    if IsValid(self.modelEntity) then self.modelEntity:Remove() end
    if IsValid(self.fadingModelEntity) then self.fadingModelEntity:Remove() end
end

function PANEL:Think()
    if IsValid(self.logo) then
        self.logo:SetZPos(9999)
        self.logo:MoveToFront()
        self:UpdateLogoPosition()
    end
end

function PANEL:showConfirmation(message, onConfirm, onCancel)
    if IsValid(lia.gui.charConfirm) then lia.gui.charConfirm:Remove() end
    local frame = vgui.Create("liaFrame", self)
    lia.gui.charConfirm = frame
    local pad, btnH = 10, 25
    frame:SetSize(400, 200)
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(("Are you sure?"):upper())
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    local accentColor = lia.color.theme.theme
    local oldPaint = frame.Paint
    frame.Paint = function(s, w, h)
        if oldPaint then oldPaint(s, w, h) end
        surface.SetDrawColor(accentColor)
        surface.DrawRect(0, 0, w, 2)
    end

    local messageLabel = frame:Add("DLabel")
    messageLabel:SetFont("LiliaFont.14")
    messageLabel:SetTextColor(color_white)
    messageLabel:SetWrap(true)
    messageLabel:SetContentAlignment(5)
    local confirmButton = frame:Add("liaButton")
    confirmButton:SetFont("LiliaFont.17")
    confirmButton:SetText(("Yes"):upper())
    confirmButton:SetPaintBackground(false)
    confirmButton:SetContentAlignment(5)
    function confirmButton:OnCursorEntered()
        self.BaseClass.OnCursorEntered(self)
        if lia.gui.character and isfunction(lia.gui.character.hoverSound) then lia.gui.character:hoverSound() end
    end

    confirmButton.DoClick = function()
        if lia.gui.character and isfunction(lia.gui.character.clickSound) then lia.gui.character:clickSound() end
        if isfunction(onConfirm) then onConfirm() end
        frame:Remove()
    end

    local cancelButton = frame:Add("liaButton")
    cancelButton:SetFont("LiliaFont.17")
    cancelButton:SetText(("No"):upper())
    cancelButton:SetPaintBackground(false)
    cancelButton:SetContentAlignment(5)
    function cancelButton:OnCursorEntered()
        self.BaseClass.OnCursorEntered(self)
        if lia.gui.character and isfunction(lia.gui.character.hoverSound) then lia.gui.character:hoverSound() end
    end

    cancelButton.DoClick = function()
        if lia.gui.character and isfunction(lia.gui.character.clickSound) then lia.gui.character:clickSound() end
        if isfunction(onCancel) then onCancel() end
        frame:Remove()
    end

    timer.Simple(0.25, function() if lia.gui.character and isfunction(lia.gui.character.warningSound) then lia.gui.character:warningSound() end end)
    timer.Simple(0, function()
        if IsValid(frame) then
            local w, h = frame:GetWide(), frame:GetTall()
            frame:SetPos((ScrW() - w) * 0.5, (ScrH() - h) * 0.5)
        end
    end)

    function frame:PerformLayout(w, h)
        if IsValid(frame.top_panel) then frame.top_panel:SetSize(w, 24) end
        if IsValid(frame.cls) then
            frame.cls:SetSize(20, 20)
            frame.cls:SetPos(w - 22, 2)
        end

        if IsValid(frame.resizer) then
            frame.resizer:SetSize(14, 14)
            frame.resizer:SetPos(w - 14, h - 14)
            frame.resizer:SetVisible(frame.sizable or false)
        end

        local availH = h - 24 - pad * 2 - btnH
        messageLabel:SetSize(w - pad * 2, availH)
        messageLabel:InvalidateLayout(true)
        messageLabel:SizeToContentsY()
        messageLabel:SetPos((w - messageLabel:GetWide()) * 0.5, 24 + pad + (availH - messageLabel:GetTall()) * 0.5)
        local btnW = (w - pad * 3) * 0.5
        confirmButton:SetSize(btnW, btnH)
        confirmButton:SetPos(pad, h - pad - btnH)
        cancelButton:SetSize(btnW, btnH)
        cancelButton:SetPos(pad * 2 + btnW, h - pad - btnH)
    end

    messageLabel:SetText(message:upper())
    frame:InvalidateLayout()
    return frame
end

vgui.Register("liaCharacter", PANEL, "EditablePanel")