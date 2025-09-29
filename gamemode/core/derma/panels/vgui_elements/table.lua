local PANEL = {}
function PANEL:Init()
    self.columns = {}
    self.rows = {}
    self.headerHeight = 36
    self.rowHeight = 32
    self.font = 'Fated.18'
    self.rowFont = 'Fated.16'
    self.selectedRow = nil
    self.sortColumn = nil
    self.hoverAnim = 0
    self.padding = 8
    self.header = vgui.Create('Panel', self)
    self.header:Dock(TOP)
    self.header:SetTall(self.headerHeight)
    self.scrollPanel = vgui.Create('liaScrollPanel', self)
    self.scrollPanel:Dock(FILL)
    self.scrollPanel:DockMargin(0, 0, 0, 0)
    self.content = vgui.Create('Panel', self.scrollPanel)
    self.content:Dock(FILL)
    self.content.Paint = nil
    self.OnAction = function() end
    self.OnRightClick = function() end
end

function PANEL:AddColumn(name, width, align, sortable)
    table.insert(self.columns, {
        name = name,
        width = width,
        align = align or TEXT_ALIGN_LEFT,
        sortable = sortable or false
    })
end

function PANEL:AddItem(...)
    local args = {...}
    if #args ~= #self.columns then
        print(L("liliaTableErrorInvalidArgs"))
        return
    end

    table.insert(self.rows, args)
    self:RebuildRows()
    return #self.rows
end

function PANEL:AddLine(...)
    return self:AddItem(...)
end

function PANEL:SortByColumn(columnIndex)
    local column = self.columns[columnIndex]
    if not column or not column.sortable then return end
    self.sortColumn = columnIndex
    local function getValueType(value)
        if value == nil then return 'nil' end
        value = tostring(value)
        return tonumber(value) and 'number' or 'string'
    end

    local function compareValues(a, b)
        if a == nil and b == nil then return false end
        if a == nil then return true end
        if b == nil then return false end
        local typeA = getValueType(a)
        local typeB = getValueType(b)
        if typeA ~= typeB then return typeA < typeB end
        if typeA == 'number' then
            local numA = tonumber(a) or 0
            local numB = tonumber(b) or 0
            return numA > numB
        else
            local strA = tostring(a)
            local strB = tostring(b)
            return strA < strB
        end
    end

    local success, err = pcall(function() table.sort(self.rows, function(a, b) return compareValues(a[columnIndex], b[columnIndex]) end) end)
    if not success then
        print('[liaTable] ' .. L("sortError") .. ':', err)
        return
    end

    self:RebuildRows()
end

function PANEL:CreateHeader()
    self.header:Clear()
    self.header.Paint = function(_, w, h) lia.derma.rect(0, 0, w, h):Radii(16, 16, 0, 0):Color(lia.color.theme.focus_panel):Shape(lia.derma.SHAPE_IOS):Draw() end
    local xPos = 0
    for i, column in ipairs(self.columns) do
        local label = vgui.Create('DButton', self.header)
        label:SetText('')
        label:SetSize(column.width, self.headerHeight)
        label:SetPos(xPos, 0)
        label.Paint = function(s, w, h)
            local isHovered = s:IsHovered() and column.sortable
            local isActive = self.sortColumn == i
            if isHovered then lia.derma.rect(0, 0, w, h):Radii(16, 16, 0, 0):Color(lia.color.theme.hover):Shape(lia.derma.SHAPE_IOS):Draw() end
            local textColor = isActive and lia.color.theme.theme or lia.color.theme.text
            draw.SimpleText(column.name, self.font, w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if column.sortable then
            label.DoClick = function()
                self:SortByColumn(i)
                surface.PlaySound('button_click.wav')
            end
        end

        xPos = xPos + column.width
    end
end

function PANEL:CreateRow(rowIndex, rowData)
    local row = vgui.Create('DButton', self.content)
    row:Dock(TOP)
    row:DockMargin(0, 0, 0, 1)
    row:SetTall(self.rowHeight)
    row:SetText('')
    row.Paint = function(s, w, h)
        local bgColor = self.selectedRow == rowIndex and lia.color.theme.theme or (s:IsHovered() and lia.color.theme.hover or lia.color.theme.panel_alpha[1])
        lia.derma.rect(0, 0, w, h):Color(bgColor):Shape(lia.derma.SHAPE_IOS):Draw()
    end

    row.DoClick = function()
        self.selectedRow = rowIndex
        self.OnAction(rowData)
        surface.PlaySound('button_click.wav')
    end

    row.DoRightClick = function()
        self.selectedRow = rowIndex
        self.OnRightClick(rowData)
        local menu = lia.derma.derma_menu()
        for i, column in ipairs(self.columns) do
            menu:AddOption(L("copy") .. ' ' .. column.name, function() SetClipboardText(tostring(rowData[i])) end)
        end

        menu:AddSpacer()
        menu:AddOption(L("deleteRow"), function() self:RemoveRow(rowIndex) end, 'icon16/delete.png')
    end

    local xPos = 0
    for i, column in ipairs(self.columns) do
        local label = vgui.Create('DLabel', row)
        label:SetText(tostring(rowData[i]))
        label:SetFont(self.rowFont)
        label:SetTextColor(lia.color.theme.text)
        label:SetContentAlignment(column.align)
        label:SetSize(column.width, self.rowHeight)
        label:SetPos(xPos, 0)
        if column.align == TEXT_ALIGN_LEFT then
            label:SetTextInset(self.padding, 0)
        elseif column.align == TEXT_ALIGN_RIGHT then
            label:SetTextInset(0, 0, self.padding, 0)
        end

        label:SetContentAlignment(column.align + 4)
        xPos = xPos + column.width
    end
end

function PANEL:RebuildRows()
    self.content:Clear()
    self:CreateHeader()
    local totalWidth = 0
    for _, column in ipairs(self.columns) do
        totalWidth = totalWidth + column.width
    end

    for rowIndex, rowData in ipairs(self.rows) do
        self:CreateRow(rowIndex, rowData)
    end

    self.content:SetSize(totalWidth, #self.rows * (self.rowHeight + 1))
end

function PANEL:SetAction(func)
    self.OnAction = func
end

function PANEL:SetRightClickAction(func)
    self.OnRightClick = func
end

function PANEL:Clear()
    self.rows = {}
    self.selectedRow = nil
    self.content:Clear()
end

function PANEL:ClearSelection()
    self.selectedRow = nil
end

function PANEL:ClearLines()
    self:Clear()
end

function PANEL:GetSelectedRow()
    return self.selectedRow and self.rows[self.selectedRow] or nil
end

function PANEL:GetRowCount()
    return #self.rows
end

function PANEL:RemoveRow(index)
    if index and index > 0 and index <= #self.rows then
        table.remove(self.rows, index)
        if self.selectedRow == index then
            self.selectedRow = nil
        elseif self.selectedRow and self.selectedRow > index then
            self.selectedRow = self.selectedRow - 1
        end

        self:RebuildRows()
        self.scrollPanel:InvalidateLayout(true)
    end
end

function PANEL:GetLine(id)
    return self.rows[id]
end

function PANEL:SetMultiSelect()
end

function PANEL:IsLineSelected(id)
    return self.selectedRow == id
end

function PANEL:SelectItem(id)
    if id < 1 or id > #self.rows then return end
    self.selectedRow = id
    if self.OnAction then self.OnAction(self.rows[id]) end
end

function PANEL:SelectFirstItem()
    if #self.rows > 0 then self:SelectItem(1) end
end

function PANEL:SelectItemByID(id)
    self:SelectItem(id)
end

function PANEL:SelectItemByLine(line)
    for idx, data in ipairs(self.rows) do
        if data == line then
            self:SelectItem(idx)
            break
        end
    end
end

function PANEL:GetSelectedLine()
    return self.selectedRow
end

function PANEL:GetSelectedLines()
    if self.selectedRow then return {self.selectedRow} end
    return {}
end

function PANEL:GetSelected()
    if not self.selectedRow then return nil end
    return self.rows[self.selectedRow]
end

function PANEL:GetLines()
    return self.rows
end

function PANEL:Paint(w, h)
    lia.derma.rect(0, 0, w, h):Rad(16):Color(lia.color.theme.panel_alpha[2]):Shape(lia.derma.SHAPE_IOS):Draw()
end

vgui.Register('liaTable', PANEL, 'Panel')
