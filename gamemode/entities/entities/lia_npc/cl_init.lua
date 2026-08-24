ENT.DrawInfo = {
    {
        text = function(ent)
            local uniqueID = ent:getNetVar("uniqueID", "")
            local npcName = ent:getNetVar("NPCName", ent.PrintName or "NPC")
            if uniqueID == "" or uniqueID == nil then return L("unconfiguredNPC") end
            return npcName
        end,
        posY = 0
    }
}
