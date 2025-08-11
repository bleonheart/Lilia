if SERVER then return end

-- Minimal Mantle compatibility layer + lia aliases so Mantle panels work without Mantle installed

Mantle = Mantle or {}
Mantle.ui = Mantle.ui or { convar = { depth_ui = false, theme = 'dark' } }
Mantle.func = Mantle.func or {}

-- Screen size helpers
Mantle.func.sw = ScrW()
Mantle.func.sh = ScrH()
hook.Add('OnScreenSizeChanged', 'liaMantleShim.Screen', function()
    Mantle.func.sw = ScrW()
    Mantle.func.sh = ScrH()
end)

-- Colors (concise defaults covering fields used by panels)
Mantle.color = Mantle.color or {
    header = Color(51, 51, 51),
    header_text = Color(180, 180, 180),
    background = Color(34, 34, 34),
    background_alpha = Color(34, 34, 34, 210),
    background_panelpopup = Color(29, 29, 29),
    window_shadow = Color(0, 0, 0, 150),
    button = Color(56, 56, 56),
    button_shadow = Color(0, 0, 0, 30),
    button_hovered = Color(52, 70, 109),
    category = Color(54, 54, 56),
    category_opened = Color(54, 54, 56, 0),
    theme = Color(106, 108, 197),
    panel = { Color(71, 71, 75), Color(60, 60, 64), Color(193, 193, 193) },
    panel_alpha = { Color(71, 71, 75, 150), Color(60, 60, 64, 150), Color(193, 193, 193, 150) },
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    gray = Color(190, 190, 190, 220),
    text = Color(255, 255, 255)
}

-- Create Fated.* fonts used in the panels if missing
do
    local created = {}
    local function ensureFont(name, size, weight)
        if created[name] then return end
        surface.CreateFont(name, { font = 'Tahoma', size = size, weight = weight or 500, extended = true })
        created[name] = true
    end
    ensureFont('Fated.14', 14)
    ensureFont('Fated.16', 16)
    ensureFont('Fated.18', 18)
    ensureFont('Fated.20', 20)
    ensureFont('Fated.20b', 20, 800)
    ensureFont('Fated.28', 28)
    ensureFont('Fated.40', 40)
end

-- Mantle.func minimal implementations used by panels
do
    local matGradUp = Material('vgui/gradient_up')
    local matGradDown = Material('vgui/gradient_down')
    local matGradL = Material('vgui/gradient-l')
    local matGradR = Material('vgui/gradient-r')
    local gradients = { matGradUp, matGradDown, matGradL, matGradR }

    function Mantle.func.gradient(x, y, w, h, direction, colorShadow, _radius, _flags)
        local mat = gradients[direction or 1]
        surface.SetDrawColor(colorShadow or Color(0, 0, 0, 40))
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(x, y, w, h)
    end

    function Mantle.func.sound(snd)
        surface.PlaySound(snd or 'buttons/button14.wav')
    end

    local wCache, hCache = {}, {}
    function Mantle.func.w(val)
        if not wCache[val] then wCache[val] = val / 1920 * Mantle.func.sw end
        return wCache[val]
    end
    function Mantle.func.h(val)
        if not hCache[val] then hCache[val] = val / 1080 * Mantle.func.sh end
        return hCache[val]
    end

    function Mantle.func.LerpColor(frac, from, to)
        local ft = FrameTime() * (frac or 1)
        return Color(
            Lerp(ft, from.r, to.r),
            Lerp(ft, from.g, to.g),
            Lerp(ft, from.b, to.b),
            Lerp(ft, from.a or 255, to.a or 255)
        )
    end

    function Mantle.func.animate_appearance(panel, targetW, targetH, sizeDuration, alphaDuration, callback)
        if not IsValid(panel) then return end
        sizeDuration = sizeDuration or 0.15
        alphaDuration = alphaDuration or 0.2

        local scale = 0.9
        local targetX, targetY = panel:GetPos()
        local startW, startH = targetW * scale, targetH * scale
        local startX = targetX + (targetW - startW) / 2
        local startY = targetY + (targetH - startH) / 2

        panel:SetSize(startW, startH)
        panel:SetPos(startX, startY)
        panel:SetAlpha(0)

        panel:SizeTo(targetW, targetH, sizeDuration, 0, 0.1, function()
            if callback then callback(panel) end
        end)
        panel:MoveTo(targetX, targetY, sizeDuration, 0, 0.1)
        panel:AlphaTo(255, alphaDuration, 0)
    end
end

-- Simplified RNDX implementation with API used by panels
RNDX = RNDX or {}
do
    -- Flags placeholders
    RNDX.NO_TL = 1
    RNDX.NO_TR = 2
    RNDX.NO_BL = 4
    RNDX.NO_BR = 8
    RNDX.SHAPE_CIRCLE = 16
    RNDX.SHAPE_FIGMA = 32
    RNDX.SHAPE_IOS = 64
    RNDX.BLUR = 128
    RNDX.MANUAL_COLOR = 256

    function RNDX.Draw(_radius, x, y, w, h, col)
        surface.SetDrawColor(col or color_white)
        surface.DrawRect(x, y, w, h)
    end

    function RNDX.DrawOutlined(_radius, x, y, w, h, col, thickness)
        surface.SetDrawColor(col or color_white)
        surface.DrawOutlinedRect(x, y, w, h, thickness or 1)
    end

    function RNDX.DrawMaterial(_radius, x, y, w, h, col, mat)
        local tex = IsValid(mat) and mat.GetTexture and mat:GetTexture('$basetexture')
        if tex then
            surface.SetDrawColor(col or color_white)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(x, y, w, h)
        else
            -- Fallback: simple X icon
            surface.SetDrawColor(col or color_white)
            surface.DrawLine(x, y, x + w, y + h)
            surface.DrawLine(x + w, y, x, y + h)
        end
    end

    function RNDX.DrawTexture(_radius, x, y, w, h, col, texture)
        surface.SetDrawColor(col or color_white)
        surface.SetTexture(texture)
        surface.DrawTexturedRect(x, y, w, h)
    end

    function RNDX.DrawCircle(x, y, r, col)
        draw.NoTexture()
        surface.SetDrawColor(col or color_white)
        surface.DrawCircle(x, y, r, (col and col.r) or 255, (col and col.g) or 255, (col and col.b) or 255, (col and col.a) or 255)
    end

    function RNDX.DrawCircleOutlined(x, y, r, col)
        RNDX.DrawCircle(x, y, r, col)
    end

    function RNDX.DrawShadows(_radius, _x, _y, _w, _h, _col)
        -- Minimal: draw nothing (visual-only)
    end

    function RNDX.DrawShadowsOutlined(_radius, _x, _y, _w, _h, _col)
        -- Minimal: draw nothing (visual-only)
    end
end

-- Minimal BShadows used by radial panel; no-op implementations
BShadows = BShadows or {}
BShadows.BeginShadow = BShadows.BeginShadow or function() cam.Start2D() end
BShadows.EndShadow = BShadows.EndShadow or function() cam.End2D() end

-- lia namespace: expose only color/func and register panel aliases
lia = lia or {}
lia.func = lia.func or {}
lia.color = lia.color or Mantle.color
lia.func = setmetatable(lia.func, { __index = Mantle.func })

-- Register lia-named aliases for Mantle panels after they are loaded
local function registerAlias(alias, source, base)
    local tbl = vgui.GetControlTable(source)
    if not tbl then return false end
    vgui.Register(alias, tbl, base)
    return true
end

local aliases = {
    { alias = 'liaButton', source = 'MantleBtn', base = 'Button' },
    { alias = 'liaCategory', source = 'MantleCategory', base = 'Panel' },
    { alias = 'liaComboBox', source = 'MantleComboBox', base = 'Panel' },
    { alias = 'liaDermaMenu', source = 'MantleDermaMenu', base = 'DPanel' },
    { alias = 'liaEntry', source = 'MantleEntry', base = 'EditablePanel' },
    { alias = 'liaFrame', source = 'MantleFrame', base = 'EditablePanel' },
    { alias = 'liaRadialPanel', source = 'MantleRadialPanel', base = 'DPanel' },
    { alias = 'liaScrollPanel', source = 'MantleScrollPanel', base = 'DScrollPanel' },
    { alias = 'liaSlideBox', source = 'MantleSlideBox', base = 'Panel' },
    { alias = 'liaTable', source = 'MantleTable', base = 'Panel' },
    { alias = 'liaTabs', source = 'MantleTabs', base = 'Panel' },
}

timer.Create('liaMantleShim.RegisterAliases', 0.2, 50, function()
    local pending = 0
    for _, info in ipairs(aliases) do
        if not vgui.GetControlTable(info.alias) then
            local ok = registerAlias(info.alias, info.source, info.base)
            if not ok then pending = pending + 1 end
        end
    end
    if pending == 0 then timer.Remove('liaMantleShim.RegisterAliases') end
end)


