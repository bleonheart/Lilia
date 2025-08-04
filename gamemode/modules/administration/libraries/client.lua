function MODULE:ShowPlayerOptions(target, options)
    local client = LocalPlayer()
    if (client:hasPrivilege("Can Access Scoreboard Info Out Of Staff") or client:hasPrivilege("Can Access Scoreboard Admin Options") and client:isStaffOnDuty()) and IsValid(target) then
        local orderedOptions = {
            {
                name = L("nameCopyFormat", target:Name()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "Name"))
                    SetClipboardText(target:Name())
                end
            },
            {
                name = L("charIDCopyFormat", target:getChar() and target:getChar():getID() or L("na")),
                image = "icon16/page_copy.png",
                func = function()
                    if target:getChar() then
                        client:ChatPrint(L("copiedCharID", target:getChar():getID()))
                        SetClipboardText(target:getChar():getID())
                    end
                end
            },
            {
                name = L("steamIDCopyFormat", target:SteamID()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "SteamID"))
                    SetClipboardText(target:SteamID())
                end
            },
            {
                name = L("Blind"),
                image = "icon16/eye.png",
                func = function() RunConsoleCommand("say", "!blind " .. target:SteamID()) end
            },
            {
                name = L("Freeze"),
                image = "icon16/lock.png",
                func = function() RunConsoleCommand("say", "!freeze " .. target:SteamID()) end
            },
            {
                name = L("Gag"),
                image = "icon16/sound_mute.png",
                func = function() RunConsoleCommand("say", "!gag " .. target:SteamID()) end
            },
            {
                name = L("Ignite"),
                image = "icon16/fire.png",
                func = function() RunConsoleCommand("say", "!ignite " .. target:SteamID()) end
            },
            {
                name = L("Jail"),
                image = "icon16/lock.png",
                func = function() RunConsoleCommand("say", "!jail " .. target:SteamID()) end
            },
            {
                name = L("Mute"),
                image = "icon16/sound_delete.png",
                func = function() RunConsoleCommand("say", "!mute " .. target:SteamID()) end
            },
            {
                name = L("Slay"),
                image = "icon16/bomb.png",
                func = function() RunConsoleCommand("say", "!slay " .. target:SteamID()) end
            },
            {
                name = L("Unblind"),
                image = "icon16/eye.png",
                func = function() RunConsoleCommand("say", "!unblind " .. target:SteamID()) end
            },
            {
                name = L("Ungag"),
                image = "icon16/sound_low.png",
                func = function() RunConsoleCommand("say", "!ungag " .. target:SteamID()) end
            },
            {
                name = L("Unfreeze"),
                image = "icon16/accept.png",
                func = function() RunConsoleCommand("say", "!unfreeze " .. target:SteamID()) end
            },
            {
                name = L("Unmute"),
                image = "icon16/sound_add.png",
                func = function() RunConsoleCommand("say", "!unmute " .. target:SteamID()) end
            },
            {
                name = L("Bring"),
                image = "icon16/arrow_down.png",
                func = function() RunConsoleCommand("say", "!bring " .. target:SteamID()) end
            },
            {
                name = L("Goto"),
                image = "icon16/arrow_right.png",
                func = function() RunConsoleCommand("say", "!goto " .. target:SteamID()) end
            },
            {
                name = L("Respawn"),
                image = "icon16/arrow_refresh.png",
                func = function() RunConsoleCommand("say", "!respawn " .. target:SteamID()) end
            },
            {
                name = L("return"),
                image = "icon16/arrow_redo.png",
                func = function() RunConsoleCommand("say", "!return " .. target:SteamID()) end
            }
        }

        for _, option in ipairs(orderedOptions) do
            table.insert(options, option)
        end
    end
end

function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("View Staff Management") then return end
    table.insert(pages, {
        name = "Staff Management",
        drawFunc = function(panel)
            panelRef = panel
            net.Start("liaRequestStaffSummary")
            net.SendToServer()
        end
    })
end

function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege(L("canAccessPlayerList")) then return end
    table.insert(pages, {
        name = L("players"),
        drawFunc = function(panel)
            panelRef = panel
            net.Start("liaRequestPlayers")
            net.SendToServer()
        end
    })
end

function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("List Characters") then return end
    table.insert(pages, {
        name = L("characterList"),
        drawFunc = function(panel)
            panelRef = panel
            panel:Clear()
            panel:DockPadding(10, 10, 10, 10)
            panel.Paint = function() end
            panel.sheet = panel:Add("DPropertySheet")
            panel.sheet:Dock(FILL)
            function panel:buildSheets(data)
                -- Recreate the property sheet to avoid CloseTab errors
                if IsValid(self.sheet) then self.sheet:Remove() end
                self.sheet = self:Add("DPropertySheet")
                self.sheet:Dock(FILL)
                local function formatPlayTime(secs)
                    local h = math.floor(secs / 3600)
                    local m = math.floor((secs % 3600) / 60)
                    local s = secs % 60
                    return string.format("%02i:%02i:%02i", h, m, s)
                end

                local hasBanInfo = false
                for _, row in ipairs(data.all or {}) do
                    if row.Banned then
                        hasBanInfo = true
                        break
                    end
                end

                local columns = {
                    {
                        name = L("id"),
                        field = "ID"
                    },
                    {
                        name = L("name"),
                        field = "Name"
                    },
                    {
                        name = L("description"),
                        field = "Desc"
                    },
                    {
                        name = L("faction"),
                        field = "Faction"
                    },
                    {
                        name = L("steamID"),
                        field = "SteamID"
                    },
                    {
                        name = L("lastUsed"),
                        field = "LastUsed"
                    },
                    {
                        name = L("banned"),
                        field = "Banned",
                        format = function(val) return val and L("yes") or L("no") end
                    }
                }

                if hasBanInfo then
                    table.insert(columns, {
                        name = L("banningAdminName"),
                        field = "BanningAdminName"
                    })

                    table.insert(columns, {
                        name = L("banningAdminSteamID"),
                        field = "BanningAdminSteamID"
                    })

                    table.insert(columns, {
                        name = L("banningAdminRank"),
                        field = "BanningAdminRank"
                    })
                end

                table.insert(columns, {
                    name = L("playtime"),
                    field = "PlayTime",
                    format = function(val) return formatPlayTime(val or 0) end
                })

                table.insert(columns, {
                    name = L("money"),
                    field = "Money",
                    format = function(val) return lia.currency.get(tonumber(val) or 0) end
                })

                hook.Run("CharListColumns", columns)
                local function createList(parent, rows)
                    local container = parent:Add("DPanel")
                    container:Dock(FILL)
                    container.Paint = function() end
                    local search = container:Add("DTextEntry")
                    search:Dock(TOP)
                    search:SetPlaceholderText(L("search"))
                    search:SetTextColor(Color(255, 255, 255))
                    local list = container:Add("DListView")
                    list:Dock(FILL)
                    local steamIDColumnIndex
                    for i, col in ipairs(columns) do
                        list:AddColumn(col.name)
                        if col.field == "SteamID" then steamIDColumnIndex = i end
                    end

                    local function populate(filter)
                        list:Clear()
                        filter = string.lower(filter or "")
                        for _, row in ipairs(rows) do
                            local values = {}
                            for _, col in ipairs(columns) do
                                local value = row[col.field]
                                if col.format then value = col.format(value, row) end
                                values[#values + 1] = value or ""
                            end

                            local match = false
                            if filter == "" then
                                match = true
                            else
                                for _, value in ipairs(values) do
                                    if tostring(value):lower():find(filter, 1, true) then
                                        match = true
                                        break
                                    end
                                end
                            end

                            if match then
                                local line = list:AddLine(unpack(values))
                                line.CharID = row.ID
                            end
                        end
                    end

                    search.OnChange = function() populate(search:GetValue()) end
                    populate("")
                    function list:OnRowRightClick(_, line)
                        if not IsValid(line) then return end
                        local menu = DermaMenu()
                        if steamIDColumnIndex then menu:AddOption(L("copySteamID"), function() SetClipboardText(line:GetColumnText(steamIDColumnIndex) or "") end):SetIcon("icon16/page_copy.png") end
                        menu:AddOption(L("copyRow"), function()
                            local rowString = ""
                            for i, column in ipairs(self.Columns or {}) do
                                local header = column.Header and column.Header:GetText() or L("columnWithNumber", i)
                                local value = line:GetColumnText(i) or ""
                                rowString = rowString .. header .. " " .. value .. " | "
                            end

                            SetClipboardText(string.sub(rowString, 1, -4))
                        end):SetIcon("icon16/page_copy.png")

                        if line.CharID then
                            if LocalPlayer():hasPrivilege("Manage Characters") then
                                menu:AddOption(L("banCharacter"), function() LocalPlayer():ConCommand([[say "/charban ]] .. line.CharID .. [["]]) end):SetIcon("icon16/cancel.png")
                                menu:AddOption(L("unbanCharacter"), function() LocalPlayer():ConCommand([[say "/charunban ]] .. line.CharID .. [["]]) end):SetIcon("icon16/accept.png")
                            end

                            if LocalPlayer():hasPrivilege("Ban Offline") then menu:AddOption(L("banCharacterOffline"), function() LocalPlayer():ConCommand([[say "/charbanoffline ]] .. line.CharID .. [["]]) end):SetIcon("icon16/cancel.png") end
                            if LocalPlayer():hasPrivilege("Unban Offline") then menu:AddOption(L("unbanCharacterOffline"), function() LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. line.CharID .. [["]]) end):SetIcon("icon16/accept.png") end
                        end

                        menu:Open()
                    end
                end

                local allPanel = self.sheet:Add("DPanel")
                allPanel:Dock(FILL)
                allPanel.Paint = function() end
                createList(allPanel, data.all or {})
                self.sheet:AddSheet(L("allCharacters"), allPanel)
                for steamID, chars in pairs(data.players or {}) do
                    local ply = lia.util.getBySteamID(tostring(steamID))
                    if IsValid(ply) then
                        local pnl = self.sheet:Add("DPanel")
                        pnl:Dock(FILL)
                        pnl.Paint = function() end
                        createList(pnl, chars)
                        self.sheet:AddSheet(ply:Nick(), pnl)
                    end
                end
            end

            net.Start("liaRequestFullCharList")
            net.SendToServer()
        end
    })
end

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
                    local columns = {}
                    function list:OnRowRightClick(_, line)
                        if not IsValid(line) or not line.rowData then return end
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

                        menu:AddOption(L("viewEntry"), function() openRowInfo(line.rowData) end):SetIcon("icon16/table.png")
                        menu:AddOption(L("viewDecodedTable"), function() openDecodedTable(tbl, columns, rows) end):SetIcon("icon16/table_go.png")
                        menu:Open()
                    end

                    if rows and rows[1] then
                        for col in pairs(rows[1]) do
                            list:AddColumn(col)
                            columns[#columns + 1] = col
                        end

                        for _, row in ipairs(rows) do
                            local lineData = {}
                            for _, col in ipairs(columns) do
                                lineData[#lineData + 1] = tostring(row[col])
                            end

                            local line = list:AddLine(unpack(lineData))
                            line.rowData = row
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

function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege(L("canAccessFlagManagement")) then return end
    table.insert(pages, {
        name = L("flagsManagement"),
        drawFunc = function(panel)
            panelRef = panel
            net.Start("liaRequestAllFlags")
            net.SendToServer()
        end
    })
end

function MODULE:PopulateAdminTabs(pages)
    if IsValid(LocalPlayer()) and LocalPlayer():hasPrivilege("Can Manage Factions") then
        table.insert(pages, {
            name = L("factionManagement"),
            drawFunc = function(panel)
                rosterPanel = panel
                net.Start("liaRequestFactionRoster")
                net.SendToServer()
            end
        })
    end
end

function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("Manage Characters") then return end
    table.insert(pages, {
        name = L("pkManager"),
        drawFunc = function(panel)
            panelRef = panel
            net.Start("liaRequestAllPKs")
            net.SendToServer()
        end
    })
end