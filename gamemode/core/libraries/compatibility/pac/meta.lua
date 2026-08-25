local playerMeta = FindMetaTable("Player")

function playerMeta:getParts()
    return self:getNetVar("parts", {})
end

if SERVER then
    function playerMeta:syncParts()
        net.Start("liaPacSync")
        net.Send(self)
    end

    function playerMeta:addPart(partID)
        if self:getParts()[partID] then return end
        net.Start("liaPacPartAdd")
        net.WriteEntity(self)
        net.WriteString(partID)
        net.Broadcast()
        local parts = self:getParts()
        parts[partID] = true
        self:setNetVar("parts", parts)
    end

    function playerMeta:removePart(partID)
        net.Start("liaPacPartRemove")
        net.WriteEntity(self)
        net.WriteString(partID)
        net.Broadcast()
        local parts = self:getParts()
        parts[partID] = nil
        self:setNetVar("parts", parts)
    end

    function playerMeta:resetParts()
        net.Start("liaPacPartReset")
        net.WriteEntity(self)
        net.Broadcast()
        self:setNetVar("parts", {})
    end
end
