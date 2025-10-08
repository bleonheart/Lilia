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
    self.skipFirstSelect = true
    local client = LocalPlayer()
    print("[Faction Step Init] Player on duty:", client:isStaffOnDuty())
    print("[Faction Step Init] Total factions:", table.Count(lia.faction.teams))

    for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
        print("[Faction Step Init] Checking faction:", fac.name, "ID:", id, "uniqueID:", fac.uniqueID, "hasWhitelist:", lia.faction.hasWhitelist(fac.index))
        if lia.faction.hasWhitelist(fac.index) then
            -- Don't show staff faction if player is on duty
            if fac.uniqueID == "staff" and client:isStaffOnDuty() then
                print("[Faction Step Init] Skipping staff faction - player is on duty")
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

        for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
            if lia.faction.hasWhitelist(fac.index) then
                -- Don't show staff faction if player is on duty
                if fac.uniqueID == "staff" and client:isStaffOnDuty() then
                    continue
                end
                availableFactions = availableFactions + 1
            end
        end

        -- If the number of available factions changed, refresh the choices
        if availableFactions ~= currentChoices then
            self.faction:Clear()
            for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
                if lia.faction.hasWhitelist(fac.index) then
                    -- Don't show staff faction if player is on duty
                    if fac.uniqueID == "staff" and client:isStaffOnDuty() then
                        continue
                    end
                    self.faction:AddChoice(L(fac.name), id)
                end
            end
            self.faction:FinishAddingOptions()
        end
    end

    local id = self.faction:GetSelectedData()
    if id then
        local fac = lia.faction.teams[id]
        if fac then
            -- Show description for already selected faction
            self.desc:SetText(L(fac.desc or "noDesc"))
            self.desc:SetVisible(true)
            self:onFactionSelected(fac)
        else
            self.desc:SetVisible(false)
        end
    else
        -- Hide description if no faction is selected
        self.desc:SetVisible(false)
    end
end

function PANEL:onFactionSelected(fac)
    -- Always update the description when a faction is selected
    self.desc:SetText(L(fac.desc or "noDesc"))
    self.desc:SetVisible(true)

    -- Only skip context updates if it's the same faction and not the first select
    if self:getContext("faction") == fac.index and not self.skipFirstSelect then
        return
    end

    self:clearContext()
    self:setContext("faction", fac.index)
    self:setContext("model", 1)
    self:updateModelPanel()
    if self.skipFirstSelect then
        self.skipFirstSelect = false
        return
    end

    lia.gui.character:clickSound()
end

function PANEL:shouldSkip()
    local client = LocalPlayer()
    local availableFactions = 0

    for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
        if lia.faction.hasWhitelist(fac.index) then
            -- Don't count staff faction if player is on duty
            if fac.uniqueID == "staff" and client:isStaffOnDuty() then
                continue
            end
            availableFactions = availableFactions + 1
        end
    end

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
