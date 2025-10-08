local PANEL = {}
function PANEL:Init()
    self.title = self:addLabel(L("selectFaction"))
    self.faction = self:Add("liaComboBox")
    self.faction:Dock(TOP)
    self.faction:PostInit()
    self.faction:DockMargin(0, 4, 0, 0)
    self.faction:SetTall(40)
    self.faction.Paint = function(p, w, h)
        lia.util.drawBlur(p)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
    end

    self.faction:SetTextColor(color_white)
    self.faction.OnSelect = function(_, _, _, id)
        local fac = lia.faction.teams[id]
        if fac then
            self:onFactionSelected(fac)
        else
            -- If faction not found, hide description
            self.desc:SetVisible(false)
        end
    end
    self.desc = self:addLabel(L("description"))
    self.desc:DockMargin(0, 8, 0, 0)
    self.desc:SetFont("LiliaFont.18")
    self.desc:SetWrap(true)
    self.desc:SetAutoStretchVertical(true)
    self.desc:SetVisible(false)
    print("[Faction Step Init] Description label created, visible:", self.desc:IsVisible())
    self.skipFirstSelect = true
    local client = LocalPlayer()
    print("[Faction Step Init] Player on duty:", client:isStaffOnDuty())
    print("[Faction Step Init] Always excluding staff faction from character creation")
    print("[Faction Step Init] Total factions:", table.Count(lia.faction.teams))

    -- Debug: List all factions
    for id, fac in pairs(lia.faction.teams) do
        print("[Faction Step Init] Faction:", fac.name, "uniqueID:", fac.uniqueID, "index:", fac.index)
    end

    for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
        print("[Faction Step Init] Checking faction:", fac.name, "ID:", id, "uniqueID:", fac.uniqueID, "hasWhitelist:", lia.faction.hasWhitelist(fac.index))
        if lia.faction.hasWhitelist(fac.index) then
            -- Don't show staff faction in character creation dropdown
            if fac.uniqueID == "staff" then
                print("[Faction Step Init] Skipping staff faction")
                continue
            end
            print("[Faction Step Init] Adding faction:", fac.name, "ID:", id)
            self.faction:AddChoice(L(fac.name), id, self.skipFirstSelect)
            self.skipFirstSelect = false
        end
    end

    self.faction:FinishAddingOptions()
end

function PANEL:onDisplay()
    self.skipFirstSelect = true

    -- Refresh faction list in case duty status changed
    if self.faction.choices and #self.faction.choices > 0 then
        local currentChoices = #self.faction.choices
        local availableFactions = 0
        local client = LocalPlayer()
        print("[Faction Step onDisplay] Player on duty:", client:isStaffOnDuty())
        print("[Faction Step onDisplay] Always excluding staff faction from character creation")
        print("[Faction Step onDisplay] Current choices:", currentChoices)

        for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
            if lia.faction.hasWhitelist(fac.index) then
                -- Don't show staff faction in character creation dropdown
                if fac.uniqueID == "staff" then
                    print("[Faction Step onDisplay] Skipping staff faction")
                    continue
                end
                availableFactions = availableFactions + 1
                print("[Faction Step onDisplay] Counting faction:", fac.name, "available:", availableFactions)
            end
        end

        print("[Faction Step onDisplay] Available factions:", availableFactions, "Current choices:", currentChoices)

        -- If the number of available factions changed, refresh the choices
        if availableFactions ~= currentChoices then
            print("[Faction Step onDisplay] Refreshing faction list")
            self.faction:Clear()
            for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
                if lia.faction.hasWhitelist(fac.index) then
                    -- Don't show staff faction in character creation dropdown
                    if fac.uniqueID == "staff" then
                        print("[Faction Step onDisplay] Skipping staff faction in refresh")
                        continue
                    end
                    print("[Faction Step onDisplay] Adding faction in refresh:", fac.name)
                    self.faction:AddChoice(L(fac.name), id)
                end
            end
            self.faction:FinishAddingOptions()
        else
            print("[Faction Step onDisplay] No refresh needed")
        end
    else
        print("[Faction Step onDisplay] No existing choices, skipping refresh")
    end

    local id = self.faction:GetSelectedData()
    print("[Faction Step onDisplay] Selected faction ID:", id)
    if id then
        local fac = lia.faction.teams[id]
        if fac then
            -- Show description for already selected faction
            print("[Faction Step onDisplay] Showing description for faction:", fac.name)
            print("[Faction Step onDisplay] Description text:", L(fac.desc or "noDesc"))
            self.desc:SetText(L(fac.desc or "noDesc"))
            self.desc:SetVisible(true)
            print("[Faction Step onDisplay] Description shown, visible:", self.desc:IsVisible())
            self:onFactionSelected(fac)
        else
            print("[Faction Step onDisplay] Faction not found for ID:", id)
            self.desc:SetVisible(false)
        end
    else
        -- Hide description if no faction is selected
        print("[Faction Step onDisplay] No faction selected, hiding description")
        self.desc:SetVisible(false)
        print("[Faction Step onDisplay] Description hidden, visible:", self.desc:IsVisible())
    end
end

function PANEL:onFactionSelected(fac)
    -- Always update the description when a faction is selected
    print("[Faction Step onFactionSelected] Setting description for faction:", fac.name)
    print("[Faction Step onFactionSelected] Description text:", L(fac.desc or "noDesc"))
    self.desc:SetText(L(fac.desc or "noDesc"))
    self.desc:SetVisible(true)
    print("[Faction Step onFactionSelected] Description visible:", self.desc:IsVisible())

    -- Only skip context updates if it's the same faction and not the first select
    if self:getContext("faction") == fac.index and not self.skipFirstSelect then
        print("[Faction Step onFactionSelected] Same faction selected, skipping context updates")
        return
    end

    print("[Faction Step onFactionSelected] Updating context for faction:", fac.name)
    self:clearContext()
    self:setContext("faction", fac.index)
    self:setContext("model", 1)
    self:updateModelPanel()
    if self.skipFirstSelect then
        self.skipFirstSelect = false
        print("[Faction Step onFactionSelected] First faction selected")
        return
    end

    print("[Faction Step onFactionSelected] Playing click sound")
    lia.gui.character:clickSound()
end

function PANEL:shouldSkip()
    local client = LocalPlayer()
    local availableFactions = 0
    print("[Faction Step shouldSkip] Player on duty:", client:isStaffOnDuty())
    print("[Faction Step shouldSkip] Always excluding staff faction from character creation")

    for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
        if lia.faction.hasWhitelist(fac.index) then
            -- Don't count staff faction in character creation dropdown
            if fac.uniqueID == "staff" then
                print("[Faction Step shouldSkip] Skipping staff faction in count")
                continue
            end
            availableFactions = availableFactions + 1
            print("[Faction Step shouldSkip] Counting faction:", fac.name, "total:", availableFactions)
        end
    end

    print("[Faction Step shouldSkip] Available factions:", availableFactions, "Should skip:", availableFactions == 1)
    return availableFactions == 1
end

function PANEL:onSkip()
    local id = self.faction:GetSelectedData()
    if id then
        local fac = lia.faction.teams[id]
        if fac then
            self:setContext("faction", fac.index)
        end
    end
    self:setContext("model", self:getContext("model", 1))
end

vgui.Register("liaCharacterFaction", PANEL, "liaCharacterCreateStep")
