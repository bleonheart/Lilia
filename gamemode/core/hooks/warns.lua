if SERVER then
    local MODULE = MODULE
    function MODULE:GetWarnings(charID)
        local condition = "action = 'warning' AND charID = " .. lia.db.convertDataType(charID)
        return lia.db.select({"id", "timestamp", "targetName AS playerName", "targetSteam AS playerSteam", "message AS reason", "adminName", "adminSteam"}, "staffactions", condition):next(function(res) return res.results or {} end)
    end

    function MODULE:AddWarning(charID, timestamp, playerName, playerSteam, reason, adminName, adminSteam)
        lia.db.insertTable({
            timestamp = timestamp,
            targetName = playerName,
            targetSteam = playerSteam,
            adminSteam = adminSteam,
            adminName = adminName,
            adminGroup = "",
            action = "warning",
            message = reason,
            charID = charID
        }, nil, "staffactions")
    end

    function MODULE:RemoveWarning(charID, index)
        local d = deferred.new()
        self:GetWarnings(charID):next(function(rows)
            if index < 1 or index > #rows then return d:resolve(nil) end
            local row = rows[index]
            lia.db.delete("staffactions", "id = " .. lia.db.convertDataType(row.id) .. " AND action = 'warning'"):next(function() d:resolve(row) end)
        end)
        return d
    end

    net.Receive("RequestRemoveWarning", function(_, client)
        if not client:hasPrivilege("Can Remove Warns") then return end
        local charID = net.ReadInt(32)
        local rowData = net.ReadTable()
        local warnIndex = tonumber(rowData.ID or rowData.index)
        if not warnIndex then
            client:notifyLocalized("invalidWarningIndex")
            return
        end

        local targetChar = lia.char.loaded[charID]
        if not targetChar then
            client:notifyLocalized("characterNotFound")
            return
        end

        local targetClient = targetChar:getPlayer()
        if not IsValid(targetClient) then
            client:notifyLocalized("playerNotFound")
            return
        end

        MODULE:RemoveWarning(charID, warnIndex):next(function(warn)
            if not warn then
                client:notifyLocalized("invalidWarningIndex")
                return
            end

            targetClient:notifyLocalized("warningRemovedNotify", client:Nick())
            client:notifyLocalized("warningRemoved", warnIndex, targetClient:Nick())
            hook.Run("WarningRemoved", client, targetClient, {
                reason = warn.reason,
                admin = warn.admin
            }, warnIndex)

            lia.db.count("staffactions", "action = 'warning' AND charID = " .. lia.db.convertDataType(targetClient:getChar():getID())):next(function(count)
                lia.log.add(client, "warningRemoved", targetClient, {
                    reason = warn.reason,
                    admin = warn.admin
                }, count, warnIndex)
            end)
        end)
    end)
else
    hook.Add("liaAdminRegisterTab", "AdminTabWarningsDB", function(tabs)
        local function canView()
            local ply = LocalPlayer()
            return IsValid(ply) and ply:hasPrivilege("Access Warnings Tab") and ply:hasPrivilege("View DB Tables")
        end

        tabs["Warnings"] = {
            icon = "icon16/error.png",
            onShouldShow = canView,
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.warnings = pnl
                net.Start("liaRequestTableData")
                net.WriteString("lia_staffactions")
                net.SendToServer()
                return pnl
            end
        }
    end)
end