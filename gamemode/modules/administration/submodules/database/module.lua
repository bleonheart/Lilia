MODULE.name = L("databaseView")
MODULE.author = "ChatGPT"
MODULE.desc = "View database tables"
MODULE.Privileges = {
    {
        Name = L("View DB Tables"),
        MinAccess = "superadmin",
        Category = L("database")
    }
}

if SERVER then
    net.Receive("liaRequestDatabaseView", function(_, client)
        if not IsValid(client) or not client:hasPrivilege("View DB Tables") then return end
        lia.db.getTables():next(function(tables)
            tables = tables or {}
            local data = {}
            local remaining = #tables
            if remaining == 0 then
                lia.net.writeBigTable(client, "liaDatabaseViewData", data)
                return
            end

            for _, tbl in ipairs(tables) do
                lia.db.query("SELECT * FROM " .. lia.db.escapeIdentifier(tbl), function(res)
                    data[tbl] = res or {}
                    remaining = remaining - 1
                    if remaining == 0 then
                        lia.net.writeBigTable(client, "liaDatabaseViewData", data)
                    end
                end)
            end
        end)
    end)
else
    local panelRef
    lia.net.readBigTable("liaDatabaseViewData", function(data)
        if IsValid(panelRef) then panelRef:buildSheets(data) end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("View DB Tables") then return end
        table.insert(pages, {
            name = L("databaseView"),
            drawFunc = function(panel)
                panelRef = panel
                panel:Clear()
                panel:DockPadding(10, 10, 10, 10)
                panel.Paint = function() end
                panel.sheet = panel:Add("DPropertySheet")
                panel.sheet:Dock(FILL)
                function panel:buildSheets(data)
                    for _, v in ipairs(self.sheet.Items or {}) do
                        if IsValid(v.Tab) then self.sheet:CloseTab(v.Tab, true) end
                    end
                    self.sheet.Items = {}
                    for tbl, rows in SortedPairs(data or {}) do
                        local pnl = self.sheet:Add("DPanel")
                        pnl:Dock(FILL)
                        pnl.Paint = function() end
                        local list = pnl:Add("DListView")
                        list:Dock(FILL)
                        function list:OnRowRightClick(_, line)
                            if not IsValid(line) then return end
                            local menu = DermaMenu()
                            menu:AddOption(L("copyRow"), function()
                                local rowString = ""
                                for i, column in ipairs(self.Columns or {}) do
                                    local header = column.Header and column.Header:GetText() or L("columnWithNumber", i)
                                    local value = line:GetColumnText(i) or ""
                                    rowString = rowString .. header .. " " .. value .. " | "
                                end
                                SetClipboardText(string.sub(rowString, 1, -4))
                            end):SetIcon("icon16/page_copy.png")
                            menu:Open()
                        end
                        if rows and rows[1] then
                            local columns = {}
                            for col in pairs(rows[1]) do
                                list:AddColumn(col)
                                columns[#columns + 1] = col
                            end
                            for _, row in ipairs(rows) do
                                local lineData = {}
                                for _, col in ipairs(columns) do
                                    lineData[#lineData + 1] = tostring(row[col])
                                end
                                list:AddLine(unpack(lineData))
                            end
                        end
                        local sheetName = tbl:gsub("^lia_", "")
                        self.sheet:AddSheet(sheetName, pnl)
                    end
                end
                net.Start("liaRequestDatabaseView")
                net.SendToServer()
            end
        })
    end
end
