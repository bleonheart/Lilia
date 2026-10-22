local gradientUp = Material("vgui/gradient-u")
local gradientDown = Material("vgui/gradient-d")
local healthColor = Color(176, 48, 42)
local armorColor = Color(52, 92, 168)
local staminaColor = Color(196, 176, 72)
local fallbackColor = Color(200, 200, 200)
local textColor = Color(240, 240, 240)
local shadowColor = Color(20, 20, 20)

local function uiScale(px)
    local scale = math.Clamp(math.min(ScrW() / 1920, ScrH() / 1080), 0.75, 2)
    return math.max(1, math.Round(px * scale))
end

local function getSimfphysBase(client)
    if not IsValid(client) then return end

    local seat = client:GetVehicle()
    if not IsValid(seat) then return end
    if IsValid(seat.vehiclebase) then return seat.vehiclebase end

    local parent = seat:GetParent()
    if IsValid(parent) and (parent.IsSimfphyscar or parent:GetClass() == "gmod_sent_vehicle_fphysics_base") then return parent end
    if seat.IsSimfphyscar or seat:GetClass() == "gmod_sent_vehicle_fphysics_base" then return seat end

    if simfphys and isfunction(simfphys.IsCar) then
        if simfphys.IsCar(seat) then return seat end
        if IsValid(parent) and simfphys.IsCar(parent) then return parent end
    end
end

local function simfphysHudClearance(client)
    if not getSimfphysBase(client) then return 0 end
    if lia.config.get("DisableSimfphysHUD", false) then return 0 end

    local hud = GetConVar("cl_simfphys_hud")
    if hud and not hud:GetBool() then return 0 end

    local offset = GetConVar("cl_simfphys_hudoffset_y")
    return uiScale(190) + (offset and math.max(0, offset:GetInt()) or 0)
end

local function paintBar(x, y, w, h, fraction, color, material)
    fraction = math.Clamp(fraction or 0, 0, 1)
    color = color or fallbackColor

    surface.SetDrawColor(0, 0, 0, 180)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(255, 255, 255, 12)
    surface.DrawOutlinedRect(x, y, w, h)

    local padding = math.min(2, math.floor((h - 1) * 0.5))
    local fillWidth = math.floor(math.max(0, w - padding * 2) * fraction)
    local fillHeight = math.max(0, h - padding * 2)
    if fillWidth <= 0 or fillHeight <= 0 then return end

    surface.SetDrawColor(color.r, color.g, color.b, 230)
    surface.DrawRect(x + padding, y + padding, fillWidth, fillHeight)
    surface.SetDrawColor(255, 255, 255, 18)
    surface.SetMaterial(material)
    surface.DrawTexturedRect(x + padding, y + padding, fillWidth, fillHeight)
end

local function getBarColor(bar)
    if bar.identifier == "health" then return healthColor end
    if bar.identifier == "armor" then return armorColor end
    if bar.identifier == "stamina" or bar.identifier == "stm" then return staminaColor end
    return bar.color or fallbackColor
end

local function isMenuOpen()
    return lia.gui and (IsValid(lia.gui.menu) or IsValid(lia.gui.character) or IsValid(lia.gui.schemaCharacterCreator))
end

hook.Add("ShouldHideBars", "liaAltBarsMenu", function()
    if isMenuOpen() then return true end
end)

function lia.bar.drawBar(x, y, w, h, pos, maximum, color)
    maximum = tonumber(maximum) or 1
    local fraction = maximum > 0 and (tonumber(pos) or 0) / maximum or 0
    paintBar(x, y, w, h, fraction, color, gradientUp)
end

function lia.bar.drawAll()
    if isMenuOpen() or hook.Run("ShouldHideBars") then return end

    local client = LocalPlayer()
    if not IsValid(client) or not client:getChar() then return end

    local bars = lia.bar.list
    table.sort(bars, function(a, b)
        if a.priority == b.priority then return (a.order or 0) < (b.order or 0) end
        return (a.priority or 0) < (b.priority or 0)
    end)

    local delta = lia.bar.delta
    local values = lia.bar.values
    local now = CurTime()
    local speed = FrameTime() * 1.4
    local always = lia.option.get("BarsAlwaysVisible")
    local active = {}

    for _, bar in ipairs(bars) do
        if isfunction(bar.getValue) then
            local identifier = bar.identifier
            local key = identifier or bar
            local target = math.Clamp(tonumber(bar.getValue()) or 0, 0, 1)
            local value = math.Approach(delta[key] or 0, target, speed)
            delta[key] = value

            if values[key] ~= target or value ~= target then bar.lifeTime = now + 4 end
            values[key] = target

            local customVisibility = hook.Run("ShouldBarDraw", bar)
            local show = (always and target > 0) or (bar.lifeTime or 0) >= now or bar.visible or customVisibility == true
            if identifier == "health" or identifier == "stamina" or identifier == "stm" then show = true end
            if identifier == "armor" and client:Armor() <= 0 then show = false end

            if show then
                active[#active + 1] = {
                    fraction = value,
                    color = getBarColor(bar)
                }
            end
        end
    end

    if #active == 0 then return end

    local height = uiScale(8)
    local width = uiScale(240)
    local gap = uiScale(5)
    local padding = uiScale(8)
    local margin = uiScale(20)
    local clusterWidth = width + padding * 2
    local clusterHeight = padding * 2 + #active * height + (#active - 1) * gap
    local x = margin
    local y = math.max(margin, ScrH() - margin - clusterHeight - simfphysHudClearance(client))

    surface.SetDrawColor(0, 0, 0, 140)
    surface.DrawRect(x, y, clusterWidth, clusterHeight)
    surface.SetDrawColor(255, 255, 255, 10)
    surface.DrawOutlinedRect(x, y, clusterWidth, clusterHeight)

    x = x + padding
    y = y + padding
    for _, entry in ipairs(active) do
        paintBar(x, y, width, height, entry.fraction, entry.color, gradientUp)
        y = y + height + gap
    end
end

local function positionActionPanel(panel)
    local width = math.floor(ScrW() * 0.28)
    local height = uiScale(50)
    local x = math.floor((ScrW() - width) * 0.5)
    local y = math.floor(ScrH() * 0.72 - height * 0.5)
    panel:SetSize(width, height)
    panel:SetPos(x, y)
end

function lia.bar.drawAction(text, duration)
    if not lia.gui then return end
    if IsValid(lia.gui.actionPanel) then lia.gui.actionPanel:Remove() end
    lia.gui.actionPanel = nil

    duration = tonumber(duration) or 0
    if duration <= 0 then return end

    local startTime = CurTime()
    local endTime = startTime + duration
    local panel = vgui.Create("liaProgressBar")
    if not IsValid(panel) then return end

    lia.gui.actionPanel = panel
    panel:SetAsActionBar(true)
    panel:SetText(tostring(text or ""))
    panel:SetBarColor(lia.config.get("Color") or fallbackColor)
    panel:SetProgress(startTime, endTime)
    panel:SetFraction(1)
    positionActionPanel(panel)

    panel.Paint = function(self, w, h)
        local barHeight = uiScale(22)
        local barY = h - barHeight
        paintBar(0, barY, w, barHeight, self:GetFraction(), self.BarColor, gradientDown)

        if self.Text ~= "" then
            local labelY = barY - uiScale(17)
            draw.SimpleText(self.Text, "LiliaFont.17", 1, labelY + 1, shadowColor)
            draw.SimpleText(self.Text, "LiliaFont.17", 0, labelY, textColor)
        end
    end

    panel.Think = function(self)
        local current = CurTime()
        if current >= endTime then
            if lia.gui.actionPanel == self then lia.gui.actionPanel = nil end
            self:Remove()
            return
        end

        self:SetFraction(1 - math.TimeFraction(startTime, endTime, current))
    end

    panel:MakePopup()
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(false)
end

local overrideDrawBar = lia.bar.drawBar
local overrideDrawAll = lia.bar.drawAll
local overrideDrawAction = lia.bar.drawAction

local function applyBarOverrides()
    lia.bar.drawBar = overrideDrawBar
    lia.bar.drawAll = overrideDrawAll
    lia.bar.drawAction = overrideDrawAction
    hook.Remove("HUDPaintBackground", "liaBarDraw")
    hook.Add("HUDPaintBackground", "liaAltBarsOverride", overrideDrawAll)
end

applyBarOverrides()
hook.Add("InitializedModules", "liaAltBarsInstall", applyBarOverrides)
