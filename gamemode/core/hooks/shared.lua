local GM = GM or GAMEMODE
function GM:OnCharVarChanged(character, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for _, v in pairs(lia.char.varHooks[varName]) do
            v(character, oldVar, newVar)
        end
    end
end

function GM:CanPlayerCreateChar(client)
    if SERVER then
        local count = #client.liaCharList or 0
        local maxChars = hook.Run("GetMaxPlayerChar", client) or lia.config.get("MaxCharacters")
        if (count or 0) >= maxChars then return false end
        return true
    else
        local count = #lia.characters or 0
        local maxChars = hook.Run("GetMaxPlayerChar", client) or lia.config.get("MaxCharacters")
        if (count or 0) >= maxChars then return false end
    end
end