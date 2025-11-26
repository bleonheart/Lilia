local PANEL = {}
function PANEL:Init()
    self.categories = {}
    self.pnlCanvas = vgui.Create("DListLayout", self)
    self.pnlCanvas:Dock(FILL)
    self.pnlCanvas:DockMargin(0, 0, 0, 0)
end

function PANEL:Add(label)
    local category = vgui.Create("liaCategory", self.pnlCanvas)
    category:Dock(TOP)
    category:DockMargin(0, #self.categories > 0 and 8 or 0, 0, 0)
    category:SetText(label)
    category:SetExpanded(false)
    table.insert(self.categories, category)
    return category
end

function PANEL:AddCategory(label)
    return self:Add(label)
end

function PANEL:GetCategories()
    return self.categories
end

function PANEL:Clear()
    for _, cat in ipairs(self.categories) do
        if IsValid(cat) then cat:Remove() end
    end

    self.categories = {}
    if IsValid(self.pnlCanvas) then self.pnlCanvas:Clear() end
end

function PANEL:InvalidateLayout(layoutNow)
    if IsValid(self.pnlCanvas) then self.pnlCanvas:InvalidateLayout(layoutNow) end
    self.BaseClass.InvalidateLayout(self, layoutNow)
end

function PANEL:Paint(w, h)
end

vgui.Register("liaCategoryList", PANEL, "liaScrollPanel")
