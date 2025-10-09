local PANEL = {}
local HIGHLIGHT = Color(255, 255, 255, 50)
function PANEL:Init()
    self:Dock(FILL)
    local function makeLabel(key)
        local lbl = self:Add("DLabel")
        lbl:SetFont("liaMediumFont")
        lbl:SetText(L(key):upper())
        lbl:SizeToContents()
        lbl:Dock(TOP)
        lbl:DockMargin(0, 0, 0, 4)
        return lbl
    end

    self.nameLabel = makeLabel("name")
    self.nameEntry = self:makeTextEntry("name")
    self.nameEntry:SetTall(32)
    self.descLabel = makeLabel("desc")
    self.descEntry = self:makeTextEntry("desc")
    self.descEntry:SetTall(32)

    -- Add attributes if they exist
    self:addAttributes()
end

function PANEL:makeTextEntry(key)
    local entry = self:Add("DTextEntry")
    entry:Dock(TOP)
    entry:SetFont("liaMediumFont")
    entry:SetTall(32)
    entry:DockMargin(0, 4, 0, 8)
    entry:SetUpdateOnType(true)
    entry.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
        entry:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
    end

    entry.OnValueChange = function(_, val) self:setContext(key, string.Trim(val)) end
    local saved = self:getContext(key)
    if saved then entry:SetValue(saved) end
    return entry
end

function PANEL:addAttributes()
    local function makeLabel(key)
        local lbl = self:Add("DLabel")
        lbl:SetFont("liaMediumFont")
        lbl:SetText(L(key):upper())
        lbl:SizeToContents()
        lbl:Dock(TOP)
        lbl:DockMargin(0, 0, 0, 4)
        return lbl
    end

    local hasAttributes = false
    for _, attrib in pairs(lia.attribs.list) do
        if not attrib.noStartBonus then
            hasAttributes = true
            break
        end
    end

    if not hasAttributes then return end

    -- Add attributes label
    local attrLabel = makeLabel("attributes")
    self.attrLabel = attrLabel

    -- Add attributes panel
    self.attribsPanel = self:Add("liaCharacterAttribs")
    self.attribsPanel:Dock(TOP)
    self.attribsPanel:DockMargin(0, 4, 0, 8)

    -- Store reference to parent for easy access
    self.attribsPanel.parentBio = self
end

function PANEL:shouldSkip()
    return false
end

function PANEL:updateAttributesLabel()
    if IsValid(self.attrLabel) and IsValid(self.attribsPanel) then
        local points = self.attribsPanel.left or 0
        self.attrLabel:SetText(L("attributes"):upper() .. " - " .. points .. " " .. L("pointsLeft"):lower())
    end
end


function PANEL:validate()
    for _, info in ipairs({{self.nameEntry, "name"}, {self.descEntry, "desc"}}) do
        local val = string.Trim(info[1]:GetValue() or "")
        if val == "" then return false, L("requiredFieldError", info[2]) end
    end
    return true
end

function PANEL:onDisplay()
    local n, d = self.nameEntry:GetValue(), self.descEntry:GetValue()
    self:Clear()
    self:Init()
    self.nameEntry:SetValue(n)
    self.descEntry:SetValue(d)

    -- Restore attributes if they exist
    if IsValid(self.attribsPanel) then
        self.attribsPanel:onDisplay()
        -- Update the attributes label after everything is initialized
        timer.Simple(0.01, function()
            if IsValid(self) then
                self:updateAttributesLabel()
            end
        end)
    end
end

vgui.Register("liaCharacterBiography", PANEL, "liaCharacterCreateStep")
