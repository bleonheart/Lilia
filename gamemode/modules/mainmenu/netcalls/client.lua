net.Receive("liaCharList", function()
    print("[CHAR-DEBUG] Client received liaCharList")
    local newCharList = {}
    local length = net.ReadUInt(32)
    print("[CHAR-DEBUG] liaCharList length:", length)
    for i = 1, length do
        newCharList[i] = net.ReadUInt(32)
        print("[CHAR-DEBUG] liaCharList id[" .. i .. "] =", newCharList[i])
    end

    local oldCharList = lia.characters
    lia.characters = newCharList
    if oldCharList then
        hook.Run("CharListUpdated", oldCharList, newCharList)
    else
        hook.Run("CharListLoaded", newCharList)
    end

    print("[CHAR-DEBUG] Char list applied; ResetCharacterPanel hook")
    hook.Run("ResetCharacterPanel")
end)
