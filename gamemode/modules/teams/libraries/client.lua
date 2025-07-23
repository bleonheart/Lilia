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
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local character = client:getChar()
    if not character then return end
    local isLeader = client:IsSuperAdmin()  or character:hasFlags("V")
    if not isLeader then return end
    tabs[L("roster")] = function(panel)
        net.Start("RosterRequest")
        net.SendToServer()
    end
end