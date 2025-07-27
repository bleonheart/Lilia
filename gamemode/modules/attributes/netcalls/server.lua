net.Receive("ChangeAttribute", function(_, client)
    if not client:hasPrivilege("Commands - Manage Attributes") then return end
    local charID = net.ReadInt(32)
    net.ReadTable()
    local attribKey = net.ReadString()
    local amountStr = net.ReadString()
    local mode = net.ReadString()
    if not attribKey or not lia.attribs.list[attribKey] then
        for k, v in pairs(lia.attribs.list) do
            if lia.util.stringMatches(L(v.name), attribKey) or lia.util.stringMatches(k, attribKey) then
                attribKey = k
                break
            end
        end
    end

    if not attribKey or not lia.attribs.list[attribKey] then
        client:notifyLocalized("invalidAttributeKey")
        return
    end

    local attribValue = tonumber(amountStr)
    if not attribValue then
        client:notifyLocalized("invalidAmount")
        return
    end

    local targetClient = lia.char.getBySteamID(charID)
    if not IsValid(targetClient) then
        client:notifyLocalized("characterNotFound")
        return
    end

    local targetChar = targetClient:getChar()
    if not targetChar then
        client:notifyLocalized("characterNotFound")
        return
    end

    if mode == "Set" then
        if attribValue < 0 then
            client:notifyLocalized("attribNonNegative")
            return
        end

        targetChar:setAttrib(attribKey, attribValue)
        client:notifyLocalized("attribSet", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
        targetChar:getPlayer():notifyLocalized("yourAttributeSet", lia.attribs.list[attribKey].name, attribValue, client:Nick())
    elseif mode == "Add" then
        if attribValue <= 0 then
            client:notifyLocalized("attribPositive")
            return
        end

        local current = targetChar:getAttrib(attribKey, 0) or 0
        local newValue = current + attribValue
        if not isnumber(newValue) or newValue < 0 then
            client:notifyLocalized("attribCalculationError")
            return
        end

        targetChar:updateAttrib(attribKey, newValue)
        client:notifyLocalized("attribUpdate", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
        targetChar:getPlayer():notifyLocalized("yourAttributeIncreased", lia.attribs.list[attribKey].name, attribValue, client:Nick())
    else
        client:notifyLocalized("invalidMode")
    end
end)

