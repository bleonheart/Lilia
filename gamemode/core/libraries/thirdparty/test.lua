if SERVER then return end
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
    panel = {Color(71, 71, 75), Color(60, 60, 64), Color(193, 193, 193)},
    panel_alpha = {Color(71, 71, 75, 150), Color(60, 60, 64, 150), Color(193, 193, 193, 150)},
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    gray = Color(190, 190, 190, 220),
    text = Color(255, 255, 255)
}

local NO_TL = 1
local NO_TR = 2
local NO_BL = 4
local NO_BR = 8
local SHAPE_CIRCLE = 16
local SHAPE_FIGMA = 32
local SHAPE_IOS = 64
local BLUR = 128
local MANUAL_COLOR = 256
local SHAPE_RECT = 512
local function Draw(_radius, x, y, w, h, col)
    surface.SetDrawColor(col or color_white)
    surface.DrawRect(x, y, w, h)
end

local function DrawMaterial(_radius, x, y, w, h, col, mat)
    surface.SetDrawColor(col or color_white)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x, y, w, h)
end

local function DrawTexture(_radius, x, y, w, h, col, texture)
    surface.SetDrawColor(col or color_white)
    surface.SetTexture(texture)
    surface.DrawTexturedRect(x, y, w, h)
end

local function DrawCircle(x, y, r, col)
    draw.NoTexture()
    surface.SetDrawColor(col or color_white)
    surface.DrawCircle(x, y, r, col and col.r or 255, col and col.g or 255, col and col.b or 255, col and col.a or 255)
end

local function DrawCircleOutlined(x, y, r, col)
    DrawCircle(x, y, r, col)
end

local function DrawShadows(_radius, _x, _y, _w, _h, _col)
    -- no-op for lightweight compat
end

local function DrawShadowsOutlined(_radius, _x, _y, _w, _h, _col)
    -- no-op for lightweight compat
end

if CLIENT then
    local panelList = {
        MantleFrame = function(parent)
            local pnl = parent:Add("MantleFrame")
            pnl:SetTitle("MantleFrame")
            pnl:SetSize(300, 200)
            pnl:Center()
            return pnl
        end,
        MantleBtn = function(parent)
            local pnl = parent:Add("MantleBtn")
            pnl:SetSize(200, 40)
            pnl:SetText("MantleBtn")
            pnl:Center()
            return pnl
        end,
        MantleEntry = function(parent)
            local pnl = parent:Add("MantleEntry")
            pnl:SetSize(300, 40)
            if pnl.SetValue then
                pnl:SetValue("MantleEntry")
            else
                pnl:SetText("MantleEntry")
            end

            pnl:Center()
            return pnl
        end,
        MantleScrollPanel = function(parent)
            local pnl = parent:Add("MantleScrollPanel")
            pnl:SetSize(300, 200)
            pnl:Center()
            for i = 1, 5 do
                local lbl = pnl:Add("DLabel")
                lbl:SetText("Label " .. i)
                lbl:Dock(TOP)
                lbl:DockMargin(5, 5, 5, 0)
            end
            return pnl
        end,
        MantleComboBox = function(parent)
            local pnl = parent:Add("MantleComboBox")
            pnl:SetSize(200, 30)
            if pnl.SetValue then pnl:SetValue("Option 1") end
            pnl:AddChoice("Option 1")
            pnl:AddChoice("Option 2")
            pnl:AddChoice("Option 3")
            pnl:Center()
            return pnl
        end,
        MantleTabs = function(parent)
            local pnl = parent:Add("MantleTabs")
            pnl:SetSize(350, 250)
            pnl:Center()
            local p1 = vgui.Create("DPanel")
            p1:Dock(FILL)
            p1.Paint = function(_, w, h)
                surface.SetDrawColor(255, 255, 255, 5)
                surface.DrawRect(0, 0, w, h)
            end

            pnl:AddTab("Tab 1", p1)
            local p2 = vgui.Create("DPanel")
            p2:Dock(FILL)
            p2.Paint = function(_, w, h)
                surface.SetDrawColor(255, 255, 255, 5)
                surface.DrawRect(0, 0, w, h)
            end

            pnl:AddTab("Tab 2", p2)
            return pnl
        end
    }

    local function openPreview()
        if IsValid(lia.gui.mantlePreview) then lia.gui.mantlePreview:Remove() end
        local frame = vgui.Create("DFrame")
        frame:SetSize(900, 600)
        frame:Center()
        frame:SetTitle("Mantle Panel Preview")
        frame:MakePopup()
        lia.gui.mantlePreview = frame
        local list = frame:Add("DScrollPanel")
        list:Dock(LEFT)
        list:SetWide(200)
        local preview = frame:Add("DPanel")
        preview:Dock(FILL)
        preview:DockMargin(4, 4, 4, 4)
        for name, builder in pairs(panelList) do
            local btn = list:Add("DButton")
            btn:Dock(TOP)
            btn:SetTall(24)
            btn:DockMargin(0, 0, 0, 2)
            btn:SetText(name)
            btn.DoClick = function()
                preview:Clear()
                local pnl = builder(preview)
                if pnl.Center then pnl:Center() end
            end
        end
    end

    concommand.Add("mantle_preview", openPreview)
end