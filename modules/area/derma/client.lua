local PLUGIN = PLUGIN
-- area entry
DEFINE_BASECLASS("Panel")
local PANEL = {}
AccessorFunc(PANEL, "text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "tickSound", "TickSound", FORCE_STRING)
AccessorFunc(PANEL, "tickSoundRange", "TickSoundRange")
AccessorFunc(PANEL, "backgroundAlpha", "BackgroundAlpha", FORCE_NUMBER)
AccessorFunc(PANEL, "expireTime", "ExpireTime", FORCE_NUMBER)
AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
function PANEL:Init()
	self:DockPadding(4, 4, 4, 4)
	self:SetSize(self:GetParent():GetWide(), 0)
	self.label = self:Add("DLabel")
	self.label:Dock(FILL)
	self.label:SetFont("ixMediumLightFont")
	self.label:SetTextColor(color_white)
	self.label:SetExpensiveShadow(1, color_black)
	self.label:SetText("Area")
	self.text = ""
	self.tickSound = "ui/buttonrollover.wav"
	self.tickSoundRange = {190, 200}
	self.backgroundAlpha = 255
	self.expireTime = 8
	self.animationTime = 2
	self.character = 1
	self.createTime = RealTime()
	self.currentAlpha = 255
	self.currentHeight = 0
	self.nextThink = RealTime()
end

function PANEL:Show()
	self:CreateAnimation(0.5, {
		index = -1,
		target = {
			currentHeight = self.label:GetTall() + 8
		},
		easing = "outQuint",
		Think = function(animation, panel) panel:SetTall(panel.currentHeight) end
	})
end

function PANEL:SetFont(font)
	self.label:SetFont(font)
end

function PANEL:SetText(text)
	if text:sub(1, 1) == "@" then text = L(text:sub(2)) end
	self.label:SetText(text)
	self.text = text
	self.character = 1
end

function PANEL:Think()
	local time = RealTime()
	if time >= self.nextThink then
		if self.character < self.text:utf8len() then
			self.character = self.character + 1
			self.label:SetText(string.utf8sub(self.text, 1, self.character))
			LocalPlayer():EmitSound(self.tickSound, 100, math.random(self.tickSoundRange[1], self.tickSoundRange[2]))
		end

		if time >= self.createTime + self.expireTime and not self.bRemoving then self:Remove() end
		self.nextThink = time + 0.05
	end
end

function PANEL:SizeToContents()
	self:SetWide(self:GetParent():GetWide())
	self.label:SetWide(self:GetWide())
	self.label:SizeToContentsY()
end

function PANEL:Paint(width, height)
	self.backgroundAlpha = math.max(self.backgroundAlpha - 200 * FrameTime(), 0)
	derma.SkinFunc("PaintAreaEntry", self, width, height)
end

function PANEL:Remove()
	if self.bRemoving then return end
	self:CreateAnimation(self.animationTime, {
		target = {
			currentAlpha = 0
		},
		Think = function(animation, panel) panel:SetAlpha(panel.currentAlpha) end,
		OnComplete = function(animation, panel)
			panel:CreateAnimation(0.5, {
				index = -1,
				target = {
					currentHeight = 0
				},
				easing = "outQuint",
				Think = function(_, sizePanel) sizePanel:SetTall(sizePanel.currentHeight) end,
				OnComplete = function(_, sizePanel)
					sizePanel:OnRemove()
					BaseClass.Remove(sizePanel)
				end
			})
		end
	})

	self.bRemoving = true
end

function PANEL:OnRemove()
end

vgui.Register("ixAreaEntry", PANEL, "Panel")
-- main panel
PANEL = {}
function PANEL:Init()
	local chatWidth, _ = chat.GetChatBoxSize()
	local _, chatY = chat.GetChatBoxPos()
	self:SetSize(chatWidth, chatY)
	self:SetPos(32, 0)
	self:ParentToHUD()
	self.entries = {}
	ix.gui.area = self
end

function PANEL:AddEntry(entry, color)
	color = color or ix.config.Get("color")
	local id = #self.entries + 1
	local panel = entry
	if isstring(entry) then
		panel = self:Add("ixAreaEntry")
		panel:SetText(entry)
	end

	panel:SetBackgroundColor(color)
	panel:SizeToContents()
	panel:Dock(BOTTOM)
	panel:Show()
	panel.OnRemove = function()
		for k, v in pairs(self.entries) do
			if v == panel then
				table.remove(self.entries, k)
				break
			end
		end
	end

	self.entries[id] = panel
	return id
end

function PANEL:GetEntries()
	return self.entries
end

vgui.Register("ixArea", PANEL, "Panel")
local PANEL = {}
function PANEL:Init()
	if IsValid(ix.gui.areaEdit) then ix.gui.areaEdit:Remove() end
	ix.gui.areaEdit = self
	self.list = {}
	self.properties = {}
	self:SetDeleteOnClose(true)
	self:SetSizable(true)
	self:SetTitle(L("areaNew"))
	-- scroll panel
	self.canvas = self:Add("DScrollPanel")
	self.canvas:Dock(FILL)
	-- name entry
	self.nameEntry = vgui.Create("ixTextEntry")
	self.nameEntry:SetFont("ixMediumLightFont")
	self.nameEntry:SetText(L("areaNew"))
	local listRow = self.canvas:Add("ixListRow")
	listRow:SetList(self.list)
	listRow:SetLabelText(L("name"))
	listRow:SetRightPanel(self.nameEntry)
	listRow:Dock(TOP)
	listRow:SizeToContents()
	-- type entry
	self.typeEntry = self.canvas:Add("DComboBox")
	self.typeEntry:Dock(RIGHT)
	self.typeEntry:SetFont("ixMediumLightFont")
	self.typeEntry:SetTextColor(color_black)
	self.typeEntry.OnSelect = function(panel)
		panel:SizeToContents()
		panel:SetWide(panel:GetWide() + 12) -- padding for arrow (nice)
	end

	for id, name in pairs(ix.area.types) do
		self.typeEntry:AddChoice(L(name), id, id == "area")
	end

	listRow = self.canvas:Add("ixListRow")
	listRow:SetList(self.list)
	listRow:SetLabelText(L("type"))
	listRow:SetRightPanel(self.typeEntry)
	listRow:Dock(TOP)
	listRow:SizeToContents()
	-- properties
	for k, v in pairs(ix.area.properties) do
		local panel
		if v.type == ix.type.string or v.type == ix.type.number then
			panel = vgui.Create("ixTextEntry")
			panel:SetFont("ixMenuButtonFont")
			panel:SetText(tostring(v.default))
			if v.type == ix.type.number then
				panel.realGetValue = panel.GetValue
				panel.GetValue = function() return tonumber(panel:realGetValue()) or v.default end
			end
		elseif v.type == ix.type.bool then
			panel = vgui.Create("ixCheckBox")
			panel:SetChecked(v.default, true)
			panel:SetFont("ixMediumLightFont")
		elseif v.type == ix.type.color then
			panel = vgui.Create("DButton")
			panel.value = v.default
			panel:SetText("")
			panel:SetSize(64, 64)
			panel.picker = vgui.Create("DColorCombo")
			panel.picker:SetColor(panel.value)
			panel.picker:SetVisible(false)
			panel.picker.OnValueChanged = function(_, newColor) panel.value = newColor end
			panel.Paint = function(_, width, height)
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawOutlinedRect(0, 0, width, height)
				surface.SetDrawColor(panel.value)
				surface.DrawRect(4, 4, width - 8, height - 8)
			end

			panel.DoClick = function()
				if not panel.picker:IsVisible() then
					local x, y = panel:LocalToScreen(0, 0)
					panel.picker:SetPos(x, y + 32)
					panel.picker:SetColor(panel.value)
					panel.picker:SetVisible(true)
					panel.picker:MakePopup()
				else
					panel.picker:SetVisible(false)
				end
			end

			panel.OnRemove = function() panel.picker:Remove() end
			panel.GetValue = function() return panel.picker:GetColor() end
		end

		if IsValid(panel) then
			local row = self.canvas:Add("ixListRow")
			row:SetList(self.list)
			row:SetLabelText(L(k))
			row:SetRightPanel(panel)
			row:Dock(TOP)
			row:SizeToContents()
		end

		self.properties[k] = function() return panel:GetValue() end
	end

	-- save button
	self.saveButton = self:Add("DButton")
	self.saveButton:SetText(L("save"))
	self.saveButton:SizeToContents()
	self.saveButton:Dock(BOTTOM)
	self.saveButton.DoClick = function() self:Submit() end
	self:SizeToContents()
	self:SetPos(64, 0)
	self:CenterVertical()
end

function PANEL:SizeToContents()
	local width = 600
	local height = 37
	for _, v in ipairs(self.canvas:GetCanvas():GetChildren()) do
		width = math.max(width, v:GetLabelWidth())
		height = height + v:GetTall()
	end

	self:SetWide(width + 200)
	self:SetTall(height + self.saveButton:GetTall() + 50)
end

function PANEL:Submit()
	local name = self.nameEntry:GetValue()
	if ix.area.stored[name] then
		ix.util.NotifyLocalized("areaAlreadyExists")
		return
	end

	local properties = {}
	for k, v in pairs(self.properties) do
		properties[k] = v()
	end

	local _, type = self.typeEntry:GetSelected()
	net.Start("ixAreaAdd")
	net.WriteString(name)
	net.WriteString(type)
	net.WriteVector(PLUGIN.editStart)
	net.WriteVector(PLUGIN:GetPlayerAreaTrace().HitPos)
	net.WriteTable(properties)
	net.SendToServer()
	PLUGIN.editStart = nil
	self:Remove()
end

function PANEL:OnRemove()
	PLUGIN.editProperties = nil
end

vgui.Register("ixAreaEdit", PANEL, "DFrame")
if IsValid(ix.gui.areaEdit) then ix.gui.areaEdit:Remove() end