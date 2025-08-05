﻿function MODULE:LoadCharInformation()
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local character = client:getChar()
    if not character then return end
    hook.Run("AddTextField", L("generalInfo"), "faction", L("faction"), function() return team.GetName(client:Team()) end)
    local classID = character:getClass()
    local classData = lia.class.list[classID]
    if classID and classData and classData.name then hook.Run("AddTextField", L("generalInfo"), "class", L("class"), function() return classData.name end) end
end

function MODULE:DrawCharInfo(client, _, info)
    if not lia.config.get("ClassDisplay", true) then return end
    local charClass = client:getClassData()
    if charClass then
        local classColor = charClass.color or Color(255, 255, 255)
        info[#info + 1] = {L(charClass.name) or L("undefinedClass"), classColor}
    end
end

function MODULE:CreateMenuButtons(tabs)
    local joinable = lia.class.retrieveJoinable(LocalPlayer())
    if #joinable > 1 then tabs["classes"] = function(panel) panel:Add("liaClasses") end end
end

function MODULE:CreateInformationButtons(pages)
    local client = LocalPlayer()
    local character = client:getChar()
    if not character or client:isStaffOnDuty() then return end
    if character:hasFlags("V") then
        table.insert(pages, {
            name = L("factionRoster"),
            drawFunc = function(parent)
                local roster = vgui.Create("liaRoster", parent)
                roster:SetRosterType("faction")
                lia.gui.roster = roster
                lia.gui.currentRosterType = "faction"
            end,
            onSelect = function()
                if IsValid(lia.gui.roster) then
                    lia.gui.roster:SetRosterType("faction")
                    lia.gui.currentRosterType = "faction"
                    net.Start("RequestFactionRoster")
                    net.SendToServer()
                end
            end
        })
    end
    if character:hasFlags("W") then
        table.insert(pages, {
            name = L("classRoster"),
            drawFunc = function(parent)
                local roster = vgui.Create("liaRoster", parent)
                roster:SetRosterType("class")
                lia.gui.roster = roster
                lia.gui.currentRosterType = "class"
            end,
            onSelect = function()
                if IsValid(lia.gui.roster) then
                    lia.gui.roster:SetRosterType("class")
                    lia.gui.currentRosterType = "class"
                    net.Start("RequestClassRoster")
                    net.SendToServer()
                end
            end
        })
    end
end

hook.Add("F1MenuClosed", "liaRosterCleanup", function()
    lia.gui.roster = nil
    lia.gui.currentRosterType = nil
end)