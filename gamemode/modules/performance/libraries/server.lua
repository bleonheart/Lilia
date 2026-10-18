local MODULE = MODULE
local subscribers = setmetatable({}, {__mode = "k"})
local nextRefresh = 0

function MODULE:SendPerfopusState(client)
    net.Start("liaPerfopusState")
    net.WriteBool(self.perfopusFrozen)
    net.WriteFloat(self.perfopusRefreshRate)
    net.Send(client)
end

function MODULE:SyncPerfopusState()
    for client in pairs(subscribers) do
        if self:CanViewMetrics(client) then
            self:SendPerfopusState(client)
        else
            subscribers[client] = nil
        end
    end
end

function MODULE:SetPerfopusServerSetting(name, value)
    if name == "freeze" then
        self.perfopusFrozen = value == true
    elseif name == "refresh" then
        if not isnumber(value) or value ~= value or value == math.huge or value == -math.huge then return end
        self.perfopusRefreshRate = math.Clamp(value, 0.1, 5)
    else
        return
    end

    self:SyncPerfopusState()
end

function MODULE:SendPerfopusMetrics()
    local readable = self:GetReadableMetrics()
    for client in pairs(subscribers) do
        if not self:CanViewMetrics(client) then
            subscribers[client] = nil
        else
            for source, data in pairs(readable) do
                net.Start("liaPerfopusMetric")
                net.WriteString(source)
                net.WriteString(self:MakeToolTipString(data.funcs, 10))
                net.WriteUInt(data.realm, 1)
                net.WriteFloat(data.time)
                net.Send(client)
            end
        end
    end
end

function MODULE:Think()
    if not self.perfopusStarted or self.perfopusFrozen then return end
    if nextRefresh > CurTime() then return end
    self:SendPerfopusMetrics()
    table.Empty(self.perfopusMetrics)
    nextRefresh = CurTime() + math.Clamp(self.perfopusRefreshRate, 0.1, 5)
end

function MODULE:HandlePerfopusStart(client)
    if not self:CanViewMetrics(client) then return end
    self:StartProfiling()
end

function MODULE:HandlePerfopusSettings(client)
    if not self:CanViewMetrics(client) then return end
    local setting = net.ReadString()
    if setting == "freeze" then
        self:SetPerfopusServerSetting(setting, net.ReadBool())
    elseif setting == "refresh" then
        self:SetPerfopusServerSetting(setting, net.ReadFloat())
    end
end

function MODULE:HandlePerfopusSubscription(client)
    if not self:CanViewMetrics(client) then return end
    if net.ReadBool() then
        subscribers[client] = true
        self:SendPerfopusState(client)
    else
        subscribers[client] = nil
    end
end

net.Receive("liaPerfopusStart", function(_, client) MODULE:HandlePerfopusStart(client) end)
net.Receive("liaPerfopusSettings", function(_, client) MODULE:HandlePerfopusSettings(client) end)
net.Receive("liaPerfopusSubscription", function(_, client) MODULE:HandlePerfopusSubscription(client) end)
