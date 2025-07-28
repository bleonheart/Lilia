local MODULE = MODULE
function SWEP:PrimaryAttack()
    local target = self:GetTarget()
    local client = LocalPlayer()
    if IsValid(target) then
        client.AdminStickTarget = target
        if not MODULE:OpenAdminStickUI(target) then
            client.AdminStickTarget = nil
        end
    end
end

function SWEP:SecondaryAttack()
    local client = LocalPlayer()
    if not IsFirstTimePredicted() then return end
    local target = self:GetTarget()
    if IsValid(target) and target:IsPlayer() and target ~= client then
        local action = target:IsFrozen() and "unfreeze" or "freeze"
        local victim = target:IsBot() and target:Name() or target:SteamID()
        hook.Run("RunAdminSystemCommand", action, client, victim)
    else
        client:notifyLocalized("cantFreezeTarget")
    end
end

function SWEP:GetTarget()
    local client = LocalPlayer()
    local target = IsValid(client.AdminStickTarget) and client.AdminStickTarget or client:GetEyeTrace().Entity
    return target
end

function SWEP:DrawHUD()
    local client = LocalPlayer()
    local x, y = ScrW() / 2, ScrH() / 2
    local target = IsValid(client.AdminStickTarget) and client.AdminStickTarget or client:GetEyeTrace().Entity
    local crossColor = Color(0, 255, 0)
    local information = {}
    if IsValid(target) then
        if not target:IsPlayer() then
            if target:GetClass() ~= "lia_item" and target.GetCreator and IsValid(target:GetCreator()) then
                local creator = target:GetCreator()
                local creatorInfo = creator:Name()
                if creator.SteamID then
                    creatorInfo = creatorInfo .. " - " .. creator:SteamID()
                end
                table.Add(information, {L("entityClassESPLabel", target:GetClass()), L("entityCreatorESPLabel", creatorInfo)})
            end
            if target:IsVehicle() and IsValid(target:GetDriver()) then target = target:GetDriver() end

            if target:GetClass() == "lia_item" then
                local item = target:getItemTable()
                if item then
                    table.insert(information, L("itemESPLabel", item:getName()))
                    table.insert(information, L("itemWidthESPLabel", item.width or 1))
                    table.insert(information, L("itemHeightESPLabel", item.height or 1))
                    local creator = target:GetCreator()
                    if IsValid(creator) then
                        table.insert(information, L("entityCreatorESPLabel", creator:Name() .. " - " .. creator:SteamID()))
                    end
                    local extra = {}
                    hook.Run("GetAdminStickItemInfo", extra, item, target)
                    for _, v in ipairs(extra) do
                        table.insert(information, tostring(v))
                    end
                end
            end
        end

        if target:IsPlayer() then
            local group = target:GetUserGroup()
            local privTbl = lia.administration and lia.administration.groups and lia.administration.groups[group] or {}
            local privNames = {}
            for priv in pairs(privTbl) do
                privNames[#privNames + 1] = priv
            end

            table.sort(privNames)
            local privStr = table.concat(privNames, ", ")
            information = {L("nicknameLabel", target:Nick()), L("steamNameLabel", target.SteamName and target:SteamName() or target:Name()), L("steamIDLabel", target:SteamID()), L("steamID64Label", target:SteamID64()), L("healthLabel", target:Health()), L("armorLabel", target:Armor()), L("usergroupLabel", group), L("usergroupPrivilegesLabel", privStr)}
            if target:getChar() then
                local char = target:getChar()
                local faction = lia.faction.indices[target:Team()]
                table.Add(information, {L("charNameIs", char:getName()), L("characterFactionLabel", faction.name)})
            else
                table.insert(information, L("noLoadedCharacter"))
            end
        end
    end

    local length, thickness = 20, 1
    surface.SetDrawColor(crossColor)
    surface.DrawRect(x - length / 2, y - thickness / 2, length, thickness)
    surface.DrawRect(x - thickness / 2, y - length / 2, thickness, length)
    local startPosX, startPosY, buffer = x - 250, y + 10, 0
    for _, v in pairs(information) do
        surface.SetFont("DebugFixed")
        surface.SetTextColor(color_black)
        surface.SetTextPos(startPosX + 1, startPosY + buffer + 1)
        surface.DrawText(v)
        surface.SetTextColor(crossColor)
        surface.SetTextPos(startPosX, startPosY + buffer)
        surface.DrawText(v)
        local _, t_h = surface.GetTextSize(v)
        buffer = buffer + t_h + 4
    end
end

function SWEP:Reload()
    if self.NextReload and self.NextReload > SysTime() then return end
    self.NextReload = SysTime() + 0.5
    local client = LocalPlayer()
    if client:KeyDown(IN_SPEED) then
        client.AdminStickTarget = client
        if not MODULE:OpenAdminStickUI(client) then
            client.AdminStickTarget = nil
        end
    end
end
