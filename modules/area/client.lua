local MODULE = MODULE
local function DrawTextBackground(x, y, text, font, backgroundColor, padding)
	font = font or "liaSubTitleFont"
	padding = padding or 8
	backgroundColor = backgroundColor or Color(88, 88, 88, 255)
	surface.SetFont(font)
	local textWidth, textHeight = surface.GetTextSize(text)
	local width, height = textWidth + padding * 2, textHeight + padding * 2
	lia.util.drawBlurAt(x, y, width, height)
	surface.SetDrawColor(0, 0, 0, 40)
	surface.DrawRect(x, y, width, height)
	derma.SkinFunc("DrawImportantBackground", x, y, width, height, backgroundColor)
	surface.SetTextColor(color_white)
	surface.SetTextPos(x + padding, y + padding)
	surface.DrawText(text)
	return height
end

function MODULE:InitPostEntity()
	hook.Run("SetupAreaProperties")
end

function MODULE:ChatboxCreated()
	if IsValid(self.panel) then self.panel:Remove() end
	self.panel = vgui.Create("liaArea")
end

function MODULE:ChatboxPositionChanged(x, y, width, height)
	if not IsValid(self.panel) then return end
	self.panel:SetSize(width, y)
	self.panel:SetPos(32, 0)
end

function MODULE:ShouldDrawCrosshair()
	if lia.area.bEditing then return true end
end

function MODULE:PlayerBindPress(client, bind, bPressed)
	if not lia.area.bEditing then return end
	if (bind:find("invnext") or bind:find("invprev")) and bPressed then
		return true
	elseif bind:find("attack2") and bPressed then
		self:EditRightClick()
		return true
	elseif bind:find("attack") and bPressed then
		self:EditClick()
		return true
	elseif bind:find("reload") and bPressed then
		self:EditReload()
		return true
	end
end

function MODULE:HUDPaint()
	if not lia.area.bEditing then return end
	local id = LocalPlayer():GetArea()
	local area = lia.area.stored[id]
	local height = ScrH()
	local y = 64
	y = y + DrawTextBackground(64, y, L("areaEditMode"), nil, lia.config.get("color"))
	if not self.editStart then
		y = y + DrawTextBackground(64, y, L("areaEditTip"), "liaSmallFont")
		DrawTextBackground(64, y, L("areaRemoveTip"), "liaSmallFont")
	else
		DrawTextBackground(64, y, L("areaFinishTip"), "liaSmallFont")
	end

	if area then DrawTextBackground(64, height - 64 - ScreenScale(12), id, "liaSmallFont", area.properties.color) end
end

function MODULE:PostDrawTranslucentRenderables(bDepth, bSkybox)
	if bSkybox or not lia.area.bEditing then return end
	for k, v in pairs(lia.area.stored) do
		local center, min, max = self:GetLocalAreaPosition(v.startPosition, v.endPosition)
		local color = ColorAlpha(v.properties.color or lia.config.get("color"), 255)
		render.DrawWireframeBox(center, angle_zero, min, max, color)
		cam.Start2D()
		local centerScreen = center:ToScreen()
		local _, textHeight = draw.SimpleText(k, "BudgetLabel", centerScreen.x, centerScreen.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if v.type ~= "area" then draw.SimpleText("(" .. L(v.type) .. ")", "BudgetLabel", centerScreen.x, centerScreen.y + textHeight, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
		cam.End2D()
	end

	if self.editStart then
		local center, min, max = self:GetLocalAreaPosition(self.editStart, self:GetPlayerAreaTrace().HitPos)
		local color = Color(255, 255, 255, 25 + (1 + math.sin(SysTime() * 6)) * 115)
		render.DrawWireframeBox(center, angle_zero, min, max, color)
		cam.Start2D()
		local centerScreen = center:ToScreen()
		draw.SimpleText(L("areaNew"), "BudgetLabel", centerScreen.x, centerScreen.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End2D()
	end
end

function MODULE:EditRightClick()
	if self.editStart then
		self.editStart = nil
	else
		self:StopEditing()
	end
end

function MODULE:EditClick()
	if not self.editStart then
		self.editStart = LocalPlayer():GetEyeTraceNoCursor().HitPos
	elseif self.editStart and not self.editProperties then
		self.editProperties = true
		local panel = vgui.Create("liaAreaEdit")
		panel:MakePopup()
	end
end

function MODULE:EditReload()
	if self.editStart then return end
	local id = LocalPlayer():GetArea()
	local area = lia.area.stored[id]
	if not area then return end
	Derma_Query(L("areaDeleteConfirm", id), L("areaDelete"), L("no"), nil, L("yes"), function()
		net.Start("liaAreaRemove")
		net.WriteString(id)
		net.SendToServer()
	end)
end

function MODULE:ShouldDisplayArea(id)
	if lia.area.bEditing then return false end
end

function MODULE:OnAreaChanged(client, oldID, newID)
	if client ~= LocalPlayer() then return end
	client.liaArea = newID
	local area = lia.area.stored[newID]
	if not area then
		client.liaInArea = false
		return
	end

	client.liaInArea = true
	if hook.Run("ShouldDisplayArea", newID) == false or not area.properties.display then return end
	local format = newID .. (lia.option.get("24hourTime", false) and ", %H:%M." or ", %I:%M %p.")
	if lia.time and lia.time.GetDate then
		format = os.date(format)
	else
		format = os.date(format)
	end

	self.panel:AddEntry(format, area.properties.color)
end

net.Receive("liaAreaEditStart", function() MODULE:StartEditing() end)
net.Receive("liaAreaEditEnd", function() MODULE:StopEditing() end)
net.Receive("liaAreaAdd", function()
	local name = net.ReadString()
	local type = net.ReadString()
	local startPosition, endPosition = net.ReadVector(), net.ReadVector()
	local properties = net.ReadTable()
	if name ~= "" then
		lia.area.stored[name] = {
			type = type,
			startPosition = startPosition,
			endPosition = endPosition,
			properties = properties
		}

		hook.Run("OnAreaAdded", name, lia.area.stored[name])
	end
end)

net.Receive("liaAreaRemove", function()
	local name = net.ReadString()
	if lia.area.stored[name] then
		lia.area.stored[name] = nil
		hook.Run("OnAreaRemoved", name)
	end
end)

net.Receive("liaAreaSync", function()
	local length = net.ReadUInt(32)
	local data = net.ReadData(length)
	local uncompressed = util.Decompress(data)
	if not uncompressed then
		ErrorNoHalt("[Lilia] Unable to decompress area data!\n")
		return
	end

	lia.area.stored = util.JSONToTable(uncompressed)
end)

net.Receive("liaAreaChanged", function()
	local oldID, newID = net.ReadString(), net.ReadString()
	local client = LocalPlayer()
	hook.Run("OnPlayerAreaChanged", client, oldID, newID)
	hook.Run("OnAreaChanged", client, oldID, newID)
end)

local PLUGIN = MODULE
function MODULE:GetPlayerAreaTrace()
	local client = LocalPlayer()
	return util.TraceLine({
		start = client:GetShootPos(),
		endpos = client:GetShootPos() + client:GetForward() * 96,
		filter = client
	})
end

function MODULE:StartEditing()
	lia.area.bEditing = true
	self.editStart = nil
	self.editProperties = nil
end

function MODULE:StopEditing()
	lia.area.bEditing = false
	if IsValid(lia.gui.areaEdit) then lia.gui.areaEdit:Remove() end
end