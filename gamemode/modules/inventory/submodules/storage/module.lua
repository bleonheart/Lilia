MODULE.name = "Storage"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Adds persistent storage containers and player vaults that integrate with the inventory for item management."
MODULE.CAMIPrivileges = {
    {
        Name = "Staff Permissions - Can Spawn Storage",
        MinAccess = "superadmin"
    }
}

if SERVER then
    util.AddNetworkString("liaDBTables")
    util.AddNetworkString("liaDBTableData")
    net.Receive("liaDBTables", function(_, ply)
        local query = lia.db.module == "sqlite" and "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'lia_%'" or "SHOW TABLES LIKE 'lia_%'"
        lia.db.query(query, function(res)
            local tbls = {}
            if res then
                if lia.db.module == "sqlite" then
                    for _, row in ipairs(res) do
                        tbls[#tbls + 1] = row.name
                    end
                else
                    local k = next(res[1] or {})
                    for _, row in ipairs(res) do
                        tbls[#tbls + 1] = row[k]
                    end
                end
            end

            net.Start("liaDBTables")
            net.WriteTable(tbls)
            net.Send(ply)
        end)
    end)

    net.Receive("liaDBTableData", function(_, ply)
        local tbl = net.ReadString()
        if not tbl or tbl == "" then return end
        lia.db.query("SELECT * FROM " .. lia.db.escapeIdentifier(tbl), function(rows)
            local colQuery = lia.db.module == "sqlite" and "PRAGMA table_info(" .. lia.db.escapeIdentifier(tbl) .. ")" or "DESCRIBE " .. lia.db.escapeIdentifier(tbl)
            lia.db.query(colQuery, function(colRes)
                local cols = {}
                if colRes then
                    if lia.db.module == "sqlite" then
                        for _, r in ipairs(colRes) do
                            cols[#cols + 1] = {
                                name = r.name,
                                field = r.name
                            }
                        end
                    else
                        for _, r in ipairs(colRes) do
                            cols[#cols + 1] = {
                                name = r.Field,
                                field = r.Field
                            }
                        end
                    end
                end

                net.Start("liaDBTableData")
                net.WriteString(tbl)
                net.WriteTable(cols)
                net.WriteTable(rows or {})
                net.Send(ply)
            end)
        end)
    end)
else
    concommand.Add("database_browser", function()
        net.Start("liaDBTables")
        net.SendToServer()
    end)

    net.Receive("liaDBTables", function()
        local tables = net.ReadTable() or {}
        local f = vgui.Create("DFrame")
        f:SetTitle("lia_ tables")
        f:SetSize(300, 400)
        f:Center()
        f:MakePopup()
        local list = vgui.Create("DListView", f)
        list:Dock(FILL)
        list:AddColumn("Table")
        for _, t in ipairs(tables) do
            list:AddLine(t)
        end

        function list:OnRowSelected(_, line)
            local name = line:GetColumnText(1)
            net.Start("liaDBTableData")
            net.WriteString(name)
            net.SendToServer()
        end
    end)

    net.Receive("liaDBTableData", function()
        local name = net.ReadString()
        local cols = net.ReadTable() or {}
        local data = net.ReadTable() or {}
        local frame, list = lia.util.CreateTableUI("Table: " .. name, cols, data)
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.rowData then return end
            local row = line.rowData
            local menu = DermaMenu()
            menu:AddOption(L("copyRow"), function()
                local str = ""
                for k, v in pairs(row) do
                    str = str .. k .. ": " .. tostring(v) .. " | "
                end

                SetClipboardText(str:sub(1, -4))
            end)

            menu:AddOption("Print Row", function() PrintTable(row) end)
            menu:Open()
        end
    end)
end