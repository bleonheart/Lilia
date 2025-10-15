local GM = GM or GAMEMODE
function GM:OnCharVarChanged(character, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for _, v in pairs(lia.char.varHooks[varName]) do
            v(character, oldVar, newVar)
        end
    end
    --[[
    if SERVER and varName == "faction" and oldVar ~= newVar then
        local defaultClass = lia.faction.getDefaultClass(newVar)
        if defaultClass then
            character:setClass(defaultClass.index)
        else
            character:setClass(nil)
        end
    end]]
end

function GM:GetModelGender(model)
    local isFemale = model:find("alyx") or model:find("mossman") or model:find("female")
    return isFemale and "female" or "male"
end