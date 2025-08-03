local MODULE = MODULE
local rosterPanel
local charMenuContext
local function requestPlayerCharacters(steamID, line, buildMenu)
    charMenuContext = {
        pos = {gui.MousePos()},
        line = line,
        steamID = steamID,
        buildMenu = buildMenu
    }

    net.Start("liaRequestPlayerCharacters")
    net.WriteString(steamID)
    net.SendToServer()
end

local function OpenRoster(panel, data)
    panel:Clear()
    local sheet = panel:Add("DPropertySheet")
    sheet:Dock(FILL)
    sheet:DockMargin(10, 10, 10, 10)
    for factionName, members in pairs(data) do
        local membersData = members
        local page = sheet:Add("DPanel")
        page:Dock(FILL)
        page:DockPadding(10, 10, 10, 10)
        local search = page:Add("DTextEntry")
        search:Dock(TOP)
        search:SetPlaceholderText(L("search"))
        search:SetTextColor(Color(255, 255, 255))
        local list = page:Add("DListView")
        list:Dock(FILL)
        list:SetMultiSelect(false)
        list:AddColumn(L("name", "Name"))
        list:AddColumn(L("steamID", "SteamID"))
        list:AddColumn(L("class", "Class"))
        list:AddColumn(L("characterPlaytime", "Character Playtime"))
        list:AddColumn(L("lastOnline", "Last Online"))
        local function populate(filter)
            list:Clear()
            filter = string.lower(filter or "")
            for _, member in ipairs(membersData) do
                if filter == "" or string.lower(member.name):find(filter, 1, true) then
                    local line = list:AddLine(member.name, member.steamID or "", member.class or L("none"), member.playTime or "", member.lastOnline or "")
                    line.rowData = member
                end
            end
        end

        search.OnChange = function() populate(search:GetValue()) end
        populate("")
        function list:OnRowRightClick(_, line)
            if not IsValid(line) or not line.rowData or not line.rowData.steamID then return end
            local parentList = self
            requestPlayerCharacters(line.rowData.steamID, line, function(menu, ln, steamID, characters)
                if LocalPlayer():hasPrivilege("Can Manage Factions") then
                    menu:AddOption(L("kick"), function()
                        Derma_Query(L("kickConfirm"), L("confirm"), L("yes"), function()
                            net.Start("KickCharacter")
                            net.WriteInt(ln.rowData.id, 32)
                            net.SendToServer()
                        end, L("no"))
                    end):SetIcon("icon16/user_delete.png")
                end

                local charSubMenu = menu:AddSubMenu(L("viewCharacterList", "View Character List"))
                if not characters or #characters == 0 then
                    charSubMenu:AddOption(L("none", "None"))
                else
                    for _, name in ipairs(characters) do
                        charSubMenu:AddOption(name)
                    end
                end

                menu:AddOption(L("copyRow"), function()
                    local rowString = ""
                    for i, column in ipairs(parentList.Columns or {}) do
                        local header = column.Header and column.Header:GetText() or "Column " .. i
                        local value = ln:GetColumnText(i) or ""
                        rowString = rowString .. header .. " " .. value .. " | "
                    end

                    SetClipboardText(string.sub(rowString, 1, -4))
                end):SetIcon("icon16/page_copy.png")

                menu:AddOption(L("copyName", "Copy Name"), function()
                    local name = ln.rowData and ln.rowData.name or ln:GetColumnText(1) or ""
                    SetClipboardText(name)
                end):SetIcon("icon16/page_copy.png")

                menu:AddOption(L("copySteamID", "Copy SteamID"), function() SetClipboardText(steamID) end):SetIcon("icon16/page_copy.png")
                menu:AddOption(L("openSteamProfile", "Open Steam Profile"), function() gui.OpenURL("https://steamcommunity.com/profiles/" .. steamID) end):SetIcon("icon16/world.png")
            end)
        end

        sheet:AddSheet(factionName, page)
    end
end

lia.net.readBigTable("liaFactionRosterData", function(data) if IsValid(rosterPanel) then OpenRoster(rosterPanel, data or {}) end end)
lia.net.readBigTable("liaPlayerCharacters", function(data)
    if not data or not charMenuContext then return end
    local menu = DermaMenu()
    if charMenuContext.buildMenu then
        charMenuContext.buildMenu(menu, charMenuContext.line, data.steamID, data.characters or {})
    end
    if charMenuContext.pos then
        menu:Open(charMenuContext.pos[1], charMenuContext.pos[2])
    else
        menu:Open()
    end
    charMenuContext = nil
end)
function MODULE:PopulateAdminTabs(pages)
    if IsValid(LocalPlayer()) and LocalPlayer():hasPrivilege("Can Manage Factions") then
        table.insert(pages, {
            name = L("factionManagement", "Factions"),
            drawFunc = function(panel)
                rosterPanel = panel
                net.Start("liaRequestFactionRoster")
                net.SendToServer()
            end
        })
    end
end
