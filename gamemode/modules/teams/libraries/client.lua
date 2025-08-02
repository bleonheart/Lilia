function MODULE:LoadCharInformation()
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
        local className = L(charClass.name) or L("undefinedClass")
        info[#info + 1] = {className, classColor}
    end
end

function MODULE:CreateMenuButtons(tabs)
    local joinable = lia.class.retrieveJoinable(LocalPlayer())
    if #joinable > 1 then tabs["classes"] = function(panel) panel:Add("liaClasses") end end
end

function MODULE:CreateInformationButtons(pages)
    local client = LocalPlayer()
    local character = client:getChar()
    if not character then return end
    local isLeader = client:hasPrivilege("Manage Faction Members") or character:hasFlags("V")
    if isLeader then
        table.insert(pages, {
            name = L("roster"),
            drawFunc = function(parent)
                local sheet = vgui.Create("liaSheet", parent)
                sheet:SetPlaceholderText(L("search"))
                lia.gui.rosterSheet = sheet
            end,
            onSelect = function()
                if IsValid(lia.gui.rosterSheet) then
                    net.Start("RequestRoster")
                    net.SendToServer()
                end
            end
        })
    end
end

hook.Add("F1MenuClosed", "liaRosterSheetCleanup", function() lia.gui.rosterSheet = nil end)