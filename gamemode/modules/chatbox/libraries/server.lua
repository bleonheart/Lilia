function MODULE:SaveData()
    self:setData({
        bans = self.OOCBans
    })
end

function MODULE:LoadData()
    local data = self:getData()
    self.OOCBans = istable(data) and data.bans or {}
end

function MODULE:InitializedModules()
    SetGlobalBool("oocblocked", false)
end