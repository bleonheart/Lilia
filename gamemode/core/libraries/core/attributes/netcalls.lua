if CLIENT then
net.Receive("liaAttributeData", function()
    local id = net.ReadUInt(32)
    local key = net.ReadString()
    local value = net.ReadType()
    lia.char.getCharacter(id, nil, function(character) if character then character:getAttribs()[key] = value end end)
end)
end
