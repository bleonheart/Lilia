-- Client-side visual comparison for Lilia's RNDX wrapper.
local rndxTestFrame

local function closeRndxTest()
    if IsValid(rndxTestFrame) then rndxTestFrame:Remove() end
    rndxTestFrame = nil
end

local function createRndxTestPanel(parent, useRndx, title)
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(LEFT)
    panel:SetWide(300)
    panel:DockMargin(12, 12, 0, 12)
    panel.Paint = function(self, w, h)
        local bg = Color(35, 35, 42)
        if useRndx then
            lia.derma.draw(24, 0, 0, w, h, bg, lia.derma.SHAPE_IOS)
        else
            draw.RoundedBox(2, 0, 0, w, h, bg)
            surface.SetDrawColor(110, 170, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        draw.SimpleText(title, "DermaDefaultBold", w / 2, h / 2 - 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(useRndx and "one RNDX rounded draw" or "square-ish + flat", "DermaDefault", w / 2, h / 2 + 2, Color(190, 195, 205), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

concommand.Add("lia_test_rndx", function()
    closeRndxTest()
    rndxTestFrame = vgui.Create("DFrame")
    rndxTestFrame:SetSize(660, 230)
    rndxTestFrame:Center()
    rndxTestFrame:SetTitle("Lilia RNDX visual test")
    rndxTestFrame:MakePopup()
    rndxTestFrame.Paint = function(self, w, h) draw.RoundedBox(8, 0, 0, w, h, Color(22, 24, 30)) end
    createRndxTestPanel(rndxTestFrame, false, "Without RNDX")
    createRndxTestPanel(rndxTestFrame, true, "With RNDX")
end)

concommand.Add("lia_test_rndx_close", closeRndxTest)
