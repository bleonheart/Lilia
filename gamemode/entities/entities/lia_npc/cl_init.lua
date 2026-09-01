ENT.DrawInfo = {
    {
        text = function(ent)
            local uniqueID = ent:getNetVar("uniqueID", "")
            local npcName = ent:getNetVar("NPCName", ent.PrintName or "NPC")
            if uniqueID == "" or uniqueID == nil then return "Unconfigured NPC" end
            return npcName
        end,
        posY = 0
    }
}
